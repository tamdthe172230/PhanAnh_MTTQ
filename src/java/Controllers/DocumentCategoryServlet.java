package Controllers;

import com.google.gson.Gson;
import Models.DocumentCategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "DocumentCategoryServlet", urlPatterns = {"/api/document-categories"})
public class DocumentCategoryServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        DocumentCategoryDAO dao = new DocumentCategoryDAO();
        List<String> categories = dao.getAllCategories();
        response.getWriter().write(gson.toJson(categories));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (!"admin".equals(role)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            result.put("success", false);
            result.put("message", "Chỉ quản trị viên mới có quyền thêm thể loại!");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        String name = request.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            result.put("success", false);
            result.put("message", "Tên thể loại không được để trống!");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        DocumentCategoryDAO dao = new DocumentCategoryDAO();
        boolean success = dao.addCategory(name.trim());
        if (success) {
            result.put("success", true);
            result.put("message", "Thêm thể loại văn bản mới thành công!");
        } else {
            result.put("success", false);
            result.put("message", "Thể loại đã tồn tại hoặc có lỗi xảy ra!");
        }
        response.getWriter().write(gson.toJson(result));
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (!"admin".equals(role)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            result.put("success", false);
            result.put("message", "Chỉ quản trị viên mới có quyền xóa thể loại!");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        String name = request.getParameter("name");
        if (name == null || name.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            result.put("success", false);
            result.put("message", "Thiếu tên thể loại cần xóa!");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        DocumentCategoryDAO dao = new DocumentCategoryDAO();
        boolean success = dao.deleteCategory(name.trim());
        if (success) {
            result.put("success", true);
            result.put("message", "Xóa thể loại văn bản thành công!");
        } else {
            result.put("success", false);
            result.put("message", "Không thể xóa thể loại văn bản này!");
        }
        response.getWriter().write(gson.toJson(result));
    }
}
