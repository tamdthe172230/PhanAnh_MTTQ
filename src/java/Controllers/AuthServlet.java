package Controllers;

import com.google.gson.Gson;
import Models.AdminDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AuthServlet", urlPatterns = {"/api/auth"})
public class AuthServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        Map<String, Object> result = new HashMap<>();

        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("role");
            }
            result.put("success", true);
            result.put("message", "Đăng xuất thành công");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        if ("changePassword".equals(action)) {
            HttpSession session = request.getSession(false);
            String role = (session != null) ? (String) session.getAttribute("role") : null;
            if (!"admin".equals(role)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                result.put("success", false);
                result.put("message", "Bạn chưa đăng nhập quản trị viên!");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");

            if (oldPassword == null || oldPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                result.put("success", false);
                result.put("message", "Vui lòng nhập đầy đủ mật khẩu hiện tại và mật khẩu mới!");
                response.getWriter().write(gson.toJson(result));
                return;
            }

            AdminDAO adminDao = new AdminDAO();
            boolean success = adminDao.changePassword("admin", oldPassword.trim(), newPassword.trim());
            if (success) {
                result.put("success", true);
                result.put("message", "Đổi mật khẩu thành công!");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                result.put("success", false);
                result.put("message", "Mật khẩu hiện tại không chính xác!");
            }
            response.getWriter().write(gson.toJson(result));
            return;
        }

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        AdminDAO adminDao = new AdminDAO();
        if (adminDao.authenticate(username, password)) {
            HttpSession session = request.getSession(true);
            session.setAttribute("role", "admin");
            result.put("success", true);
            result.put("message", "Đăng nhập thành công");
        } else {
            result.put("success", false);
            result.put("message", "Sai tài khoản hoặc mật khẩu!");
        }

        response.getWriter().write(gson.toJson(result));
    }
}
