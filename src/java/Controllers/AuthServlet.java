package Controllers;

import com.google.gson.Gson;
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

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if ("admin".equals(username) && "123".equals(password)) {
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
