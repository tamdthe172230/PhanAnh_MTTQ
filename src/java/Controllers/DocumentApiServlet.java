package Controllers;

import com.google.gson.Gson;
import Models.Document;
import Models.DocumentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

@WebServlet(name = "DocumentApiServlet", urlPatterns = {"/api/documents"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 50,
    maxRequestSize = 1024 * 1024 * 100
)
public class DocumentApiServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String fileNameParam = request.getParameter("file");

        if ((idParam != null && !idParam.trim().isEmpty()) || (fileNameParam != null && !fileNameParam.trim().isEmpty())) {
            serveDocumentStream(request, response);
            return;
        }

        response.setContentType("application/json; charset=UTF-8");
        DocumentDAO docDao = new DocumentDAO();
        String json = gson.toJson(docDao.getAllDocuments());
        response.getWriter().write(json);
    }

    private void serveDocumentStream(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        String fileNameParam = request.getParameter("file");
        String mode = request.getParameter("mode"); // "view" hoặc "download"

        DocumentDAO docDao = new DocumentDAO();
        Document doc = null;

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idParam.trim());
                doc = docDao.getDocumentById(id);
            } catch (Exception ex) {}
        }

        if (doc == null && fileNameParam != null && !fileNameParam.trim().isEmpty()) {
            String cleanName = Paths.get(fileNameParam.trim()).getFileName().toString();
            List<Document> list = docDao.getAllDocuments();
            for (Document d : list) {
                if (cleanName.equalsIgnoreCase(d.getFilePath())) {
                    doc = docDao.getDocumentById(d.getId());
                    break;
                }
            }
        }

        byte[] fileBytes = null;
        String fileName = "van_ban.pdf";

        if (doc != null) {
            fileName = doc.getFilePath() != null ? doc.getFilePath() : "van_ban.pdf";
            if (doc.getFileData() != null && !doc.getFileData().trim().isEmpty()) {
                try {
                    fileBytes = Base64.getDecoder().decode(doc.getFileData().trim());
                } catch (Exception ex) {
                    System.out.println("Lỗi giải mã Base64: " + ex.getMessage());
                }
            }
        }

        // Fallback đọc file vật lý nếu CSDL không có file_data
        if (fileBytes == null || fileBytes.length == 0) {
            String cleanFileName = fileNameParam != null ? Paths.get(fileNameParam.trim()).getFileName().toString() : fileName;
            String uploadPath = request.getServletContext().getRealPath("/uploads/documents");
            if (uploadPath == null) {
                uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "documents";
            }

            File file = new File(uploadPath + File.separator + cleanFileName);
            if (!file.exists()) {
                String fallbackPath = request.getServletContext().getRealPath("/uploads");
                if (fallbackPath == null) {
                    fallbackPath = getServletContext().getRealPath("") + File.separator + "uploads";
                }
                file = new File(fallbackPath + File.separator + cleanFileName);
            }

            if (file.exists()) {
                try (InputStream in = new FileInputStream(file);
                     ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                    byte[] buf = new byte[8192];
                    int len;
                    while ((len = in.read(buf)) != -1) {
                        baos.write(buf, 0, len);
                    }
                    fileBytes = baos.toByteArray();
                }
            }
        }

        if (fileBytes == null || fileBytes.length == 0) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.setContentType("text/html; charset=UTF-8");
            response.getWriter().write("<h3 style='color:#dc3545;font-family:sans-serif;text-align:center;margin-top:50px;'>❌ Tệp văn bản không tồn tại hoặc đã bị xóa khỏi hệ thống!</h3>");
            return;
        }

        String mimeType = getServletContext().getMimeType(fileName);
        if (mimeType == null) {
            String nameLower = fileName.toLowerCase();
            if (nameLower.endsWith(".pdf")) mimeType = "application/pdf";
            else if (nameLower.endsWith(".docx")) mimeType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
            else if (nameLower.endsWith(".doc")) mimeType = "application/msword";
            else if (nameLower.endsWith(".xlsx")) mimeType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            else if (nameLower.endsWith(".xls")) mimeType = "application/vnd.ms-excel";
            else if (nameLower.endsWith(".png")) mimeType = "image/png";
            else if (nameLower.endsWith(".jpg") || nameLower.endsWith(".jpeg")) mimeType = "image/jpeg";
            else mimeType = "application/octet-stream";
        }

        response.setContentType(mimeType);
        response.setContentLength(fileBytes.length);

        String encodedFileName = "";
        try {
            encodedFileName = java.net.URLEncoder.encode(fileName, "UTF-8").replace("+", "%20");
        } catch (Exception ex) {
            encodedFileName = fileName;
        }
        String asciiFallback = fileName.replaceAll("[^\\x00-\\x7F]", "_");

        if ("download".equalsIgnoreCase(mode)) {
            response.setHeader("Content-Disposition", "attachment; filename=\"" + asciiFallback + "\"; filename*=UTF-8''" + encodedFileName);
        } else {
            response.setHeader("Content-Disposition", "inline; filename=\"" + asciiFallback + "\"; filename*=UTF-8''" + encodedFileName);
        }

        try (OutputStream out = response.getOutputStream()) {
            out.write(fileBytes);
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        jakarta.servlet.http.HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (!"admin".equals(role)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"success\": false, \"message\": \"Chỉ quản trị viên mới có quyền đăng văn bản!\"}");
            return;
        }

        String title = request.getParameter("title");
        String category = request.getParameter("category");
        String description = request.getParameter("description");

        if (title == null || title.trim().isEmpty() ||
            category == null || category.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng điền đầy đủ tiêu đề và loại văn bản!\"}");
            return;
        }

        String fileName = "";
        String base64Data = "";
        try {
            Part filePart = request.getPart("file");
            if (filePart != null && filePart.getSize() > 0) {
                String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (originalFileName != null && !originalFileName.trim().isEmpty()) {
                    fileName = originalFileName.replaceAll("[\\\\/:*?\"<>|]", "_");
                    
                    try (InputStream is = filePart.getInputStream();
                         ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
                        byte[] buf = new byte[8192];
                        int n;
                        while ((n = is.read(buf)) != -1) {
                            baos.write(buf, 0, n);
                        }
                        base64Data = Base64.getEncoder().encodeToString(baos.toByteArray());
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi upload file văn bản: " + e.getMessage());
        }

        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm dd/MM/yyyy");
        sdf.setTimeZone(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
        String dateStr = sdf.format(new Date());
        Document doc = new Document();
        doc.setTitle(title.trim());
        doc.setCategory(category.trim());
        doc.setDocDate(dateStr);
        doc.setFilePath(fileName);
        doc.setFileData(base64Data);
        doc.setDescription(description != null ? description.trim() : "");

        DocumentDAO docDao = new DocumentDAO();
        int nextId = docDao.addDocument(doc);

        if (nextId > 0) {
            response.getWriter().write("{\"success\": true, \"id\": " + nextId + "}");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi lưu văn bản vào cơ sở dữ liệu!\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (!"admin".equals(role)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"success\": false, \"message\": \"Không có quyền xóa văn bản!\"}");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Thiếu ID văn bản!\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            DocumentDAO docDao = new DocumentDAO();
            boolean success = docDao.deleteDocument(id);
            if (success) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"Lỗi xóa văn bản!\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"ID văn bản không hợp lệ!\"}");
        }
    }
}
