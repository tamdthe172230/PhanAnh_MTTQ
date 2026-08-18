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
import utils.EmailService;

@WebServlet(name = "TestEmailServlet", urlPatterns = {"/api/test-email"})
public class TestEmailServlet extends HttpServlet {
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        if (!"admin".equals(role)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            result.put("success", false);
            result.put("message", "Chỉ quản trị viên mới có quyền thử nghiệm gửi Email!");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        String toEmail = request.getParameter("email");
        if (toEmail == null || toEmail.trim().isEmpty() || !toEmail.contains("@")) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            result.put("success", false);
            result.put("message", "Vui lòng nhập địa chỉ email hợp lệ để thử nghiệm!");
            response.getWriter().write(gson.toJson(result));
            return;
        }

        String resMsg = EmailService.sendTestEmailSync(toEmail.trim());
        if (resMsg.startsWith("OK")) {
            result.put("success", true);
            result.put("message", "✅ Gửi email thử nghiệm thành công! Vui lòng kiểm tra hòm thư: " + toEmail);
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            result.put("success", false);
            result.put("message", "❌ Lỗi gửi email: " + resMsg);
        }

        response.getWriter().write(gson.toJson(result));
    }
}
