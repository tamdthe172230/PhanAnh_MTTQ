package Controllers;

import com.google.gson.Gson;
import Models.Feedback;
import Models.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

@WebServlet(name = "FeedbackApiServlet", urlPatterns = {"/api/feedback"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,
    maxFileSize = 1024 * 1024 * 10,
    maxRequestSize = 1024 * 1024 * 50
)
public class FeedbackApiServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        FeedbackDAO feedbackDao = new FeedbackDAO();
        String json = gson.toJson(feedbackDao.getAllFeedbacks());
        response.getWriter().write(json);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String action = request.getParameter("action");
        if ("update".equals(action)) {
            jakarta.servlet.http.HttpSession session = request.getSession(false);
            String role = (session != null) ? (String) session.getAttribute("role") : null;
            if (!"admin".equals(role)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"success\": false, \"message\": \"Không có quyền truy cập!\"}");
                return;
            }

            String idStr = request.getParameter("id");
            String status = request.getParameter("status");
            String reply = request.getParameter("reply");
            
            if (idStr == null || status == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin cập nhật!\"}");
                return;
            }
            
            try {
                int id = Integer.parseInt(idStr.trim());
                String statusLabel = "Đã tiếp nhận";
                if ("processing".equals(status)) {
                    statusLabel = "Đang xử lý";
                } else if ("answered".equals(status)) {
                    statusLabel = "Đã trả lời";
                }
                
                FeedbackDAO getDao = new FeedbackDAO();
                Feedback fb = getDao.getFeedbackById(id);

                FeedbackDAO updateDao = new FeedbackDAO();
                boolean success = updateDao.updateFeedbackStatusAndReply(id, status, statusLabel, reply != null ? reply.trim() : "");
                
                if (success) {
                    // Tự động gửi email thông báo cho người dân nếu có email
                    try {
                        if (fb != null && fb.getEmail() != null && !fb.getEmail().trim().isEmpty()) {
                            String year = new SimpleDateFormat("yyyy").format(new Date());
                            String code = "PA-" + year + "-" + String.format("%03d", fb.getId());
                            utils.EmailService.sendFeedbackReplyAsync(fb.getEmail(), fb.getVoterName(), code, fb.getContent(), statusLabel, reply != null ? reply.trim() : "");
                        }
                    } catch (Exception ex) {
                        System.out.println("Lỗi kích hoạt gửi email thông báo: " + ex.getMessage());
                    }

                    response.getWriter().write("{\"success\": true}");
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"success\": false, \"message\": \"Lỗi cập nhật phản ánh!\"}");
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\": false, \"message\": \"ID hoặc dữ liệu cập nhật không hợp lệ!\"}");
            }
            return;
        }

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String thon = request.getParameter("thon");
        String type = request.getParameter("type");
        String typeOther = request.getParameter("typeOther");
        String content = request.getParameter("content");

        if (name == null || name.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            thon == null || thon.trim().isEmpty() ||
            type == null || type.trim().isEmpty() ||
            content == null || content.trim().isEmpty()) {
            
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Thiếu thông tin bắt buộc!\"}");
            return;
        }

        try {
            int streetId = Integer.parseInt(thon.trim());
            int typeId = Integer.parseInt(type.trim());
            FeedbackDAO feedbackDao = new FeedbackDAO();
            
            if (typeOther != null && !typeOther.trim().isEmpty()) {
                content = "[Lĩnh vực: " + typeOther.trim() + "] " + content;
            }
            
            // Xử lý tệp đính kèm
            String fileName = "";
            try {
                Part filePart = request.getPart("file");
                if (filePart != null && filePart.getSize() > 0) {
                    String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    if (originalFileName != null && !originalFileName.trim().isEmpty()) {
                        fileName = System.currentTimeMillis() + "_" + originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                        String uploadPath = request.getServletContext().getRealPath("/uploads");
                        if (uploadPath == null) {
                            uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                        }
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        filePart.write(uploadPath + File.separator + fileName);
                    }
                }
            } catch (Exception e) {
                System.out.println("Lỗi upload tệp: " + e.getMessage());
            }

            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm dd/MM/yyyy");
            sdf.setTimeZone(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
            String dateStr = sdf.format(new Date());
            Feedback fb = new Feedback();
            fb.setVoterName(name.trim());
            fb.setPhone(phone.trim());
            fb.setEmail(email != null ? email.trim() : "");
            fb.setDate(dateStr);
            fb.setStatus("received");
            fb.setStatusLabel("Đã tiếp nhận");
            fb.setContent(content.trim());
            fb.setReply("");
            fb.setAttachedFile(fileName);

            int nextId = feedbackDao.addFeedback(fb, streetId, typeId);

            if (nextId > 0) {
                response.getWriter().write("{\"success\": true, \"id\": " + nextId + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"Lỗi lưu phản ánh vào cơ sở dữ liệu!\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Mã địa bàn hoặc lĩnh vực phản ánh không hợp lệ!\"}");
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
            response.getWriter().write("{\"success\": false, \"message\": \"Không có quyền thực hiện chức năng này!\"}");
            return;
        }

        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Thiếu ID phản ánh!\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            FeedbackDAO feedbackDao = new FeedbackDAO();
            boolean success = feedbackDao.deleteFeedback(id);
            if (success) {
                response.getWriter().write("{\"success\": true}");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"success\": false, \"message\": \"Lỗi xóa phản ánh!\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"ID không hợp lệ!\"}");
        }
    }
}
