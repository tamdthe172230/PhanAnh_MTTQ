package utils;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Properties;
import java.util.concurrent.CompletableFuture;

public class EmailService {

    private static final String DEFAULT_GMAIL_USER = System.getenv("GMAIL_USER") != null ? System.getenv("GMAIL_USER") : "mattrantoquoclienhoa@gmail.com";
    private static final String DEFAULT_GMAIL_PASS = System.getenv("GMAIL_PASS") != null ? System.getenv("GMAIL_PASS") : "";

    public static String sendEmailSync(String recipientEmail, String subject, String htmlContent) {
        String gmailUser = System.getenv("GMAIL_USER") != null ? System.getenv("GMAIL_USER").trim() : DEFAULT_GMAIL_USER;
        String rawPass = System.getenv("GMAIL_PASS") != null ? System.getenv("GMAIL_PASS") : DEFAULT_GMAIL_PASS;
        String gmailPass = rawPass != null ? rawPass.replaceAll("[\\s-]", "") : "";

        // Tùy chọn 1: Brevo HTTP REST API (Port 443 HTTPS - Không bị chặn trên Render Cloud)
        String brevoKey = System.getenv("BREVO_API_KEY");
        if (brevoKey != null && !brevoKey.trim().isEmpty()) {
            try {
                return sendViaBrevoApi(brevoKey.trim(), gmailUser.isEmpty() ? "tamvg2k3@gmail.com" : gmailUser, recipientEmail, subject, htmlContent);
            } catch (Exception ex) {
                System.out.println("⚠️ Brevo API error: " + ex.getMessage());
                return "Lỗi Brevo API: " + ex.getMessage();
            }
        }

        // Tùy chọn 2: Resend HTTP REST API (Port 443 HTTPS - Không bị chặn trên Render Cloud)
        String resendKey = System.getenv("RESEND_API_KEY");
        if (resendKey != null && !resendKey.trim().isEmpty()) {
            try {
                return sendViaResendApi(resendKey.trim(), recipientEmail, subject, htmlContent);
            } catch (Exception ex) {
                System.out.println("⚠️ Resend API error: " + ex.getMessage());
                return "Lỗi Resend API: " + ex.getMessage();
            }
        }

        if (gmailUser.isEmpty() || gmailPass.isEmpty()) {
            return "Chưa cấu hình GMAIL_USER / GMAIL_PASS hoặc BREVO_API_KEY / RESEND_API_KEY.";
        }

        // Tùy chọn 3: Gmail SMTP Port 587 STARTTLS
        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.starttls.required", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.3");
            props.put("mail.smtp.ssl.trust", "*");
            props.put("mail.smtp.connectiontimeout", "8000");
            props.put("mail.smtp.timeout", "8000");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(gmailUser, gmailPass);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(gmailUser, "UBMTTQ Phường Liên Hòa"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail.trim()));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            return "OK";
        } catch (Exception e) {
            System.out.println("⚠️ Lỗi Port 587 (" + e.getMessage() + "), thử lại qua Cổng 465...");
            try {
                Properties props2 = new Properties();
                props2.put("mail.smtp.host", "smtp.gmail.com");
                props2.put("mail.smtp.port", "465");
                props2.put("mail.smtp.auth", "true");
                props2.put("mail.smtp.ssl.enable", "true");
                props2.put("mail.smtp.ssl.trust", "*");
                props2.put("mail.smtp.connectiontimeout", "8000");
                props2.put("mail.smtp.timeout", "8000");

                Session session2 = Session.getInstance(props2, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(gmailUser, gmailPass);
                    }
                });

                Message message2 = new MimeMessage(session2);
                message2.setFrom(new InternetAddress(gmailUser, "UBMTTQ Phường Liên Hòa"));
                message2.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail.trim()));
                message2.setSubject(subject);
                message2.setContent(htmlContent, "text/html; charset=UTF-8");

                Transport.send(message2);
                return "OK";
            } catch (Exception ex2) {
                ex2.printStackTrace();
                return "Render Cloud chặn cổng SMTP (587 & 465). Vui lòng thêm biến BREVO_API_KEY hoặc RESEND_API_KEY trên Render. Chi tiết: " + (ex2.getMessage() != null ? ex2.getMessage() : ex2.toString());
            }
        }
    }

    public static String sendTestEmailSync(String recipientEmail) {
        String subject = "[Kiểm tra hệ thống] Thử nghiệm tính năng gửi Email thông báo";
        String htmlContent = "<div style=\"font-family:sans-serif;padding:20px;border:1px solid #b5000b;border-radius:8px;\">"
                + "<h2 style=\"color:#b5000b;\">UBMTTQ PHƯỜNG LIÊN HÒA</h2>"
                + "<p>Xin chào! Đây là email thử nghiệm kết nối hệ thống thông báo tự động từ Cổng Phản ánh cử tri.</p>"
                + "<p>✅ Kết nối gửi Email đã hoạt động hoàn hảo!</p>"
                + "</div>";
        return sendEmailSync(recipientEmail, subject, htmlContent);
    }

    public static void sendFeedbackReplyAsync(String recipientEmail, String voterName, String code, String questionContent, String statusLabel, String replyContent) {
        if (recipientEmail == null || recipientEmail.trim().isEmpty() || !recipientEmail.contains("@")) {
            System.out.println("Email người nhận không hợp lệ, bỏ qua gửi thông báo email: " + recipientEmail);
            return;
        }

        CompletableFuture.runAsync(() -> {
            String subject = "[Thông báo] Kết quả xử lý Phản ánh, Kiến nghị mã số " + code;
            String htmlContent = "<div style=\"font-family:'Segoe UI',Arial,sans-serif;max-width:640px;margin:0 auto;border:1px solid #e0e0e0;border-radius:8px;overflow:hidden;box-shadow:0 4px 12px rgba(0,0,0,0.08);\">"
                    + "  <div style=\"background:#b5000b;color:#ffffff;padding:20px;text-align:center;\">"
                    + "    <h2 style=\"margin:0;font-size:1.3rem;text-transform:uppercase;\">ỦY BAN MẶT TRẬN TỔ QUỐC VIỆT NAM PHƯỜNG LIÊN HÒA</h2>"
                    + "    <p style=\"margin:6px 0 0;font-size:0.95rem;opacity:0.9;\">Cổng Thông tin tiếp nhận Phản ánh, Kiến nghị cử tri</p>"
                    + "  </div>"
                    + "  <div style=\"padding:24px;background:#ffffff;\">"
                    + "    <p style=\"font-size:1rem;color:#333;\">Kính gửi ông/bà <strong>" + voterName + "</strong>,</p>"
                    + "    <p style=\"font-size:0.95rem;color:#555;line-height:1.6;\">Ủy ban MTTQ Việt Nam Phường Liên Hòa trân trọng thông báo kết quả trả lời phản ánh của ông/bà như sau:</p>"
                    + "    <div style=\"background:#f8f9fa;border-left:4px solid #b5000b;padding:14px;margin:16px 0;border-radius:4px;\">"
                    + "      <p style=\"margin:0 0 6px;font-weight:bold;color:#b5000b;\">📌 Mã số phản ánh: " + code + "</p>"
                    + "      <p style=\"margin:0 0 6px;color:#444;\"><strong>Nội dung phản ánh:</strong> \"<i>" + questionContent + "</i>\"</p>"
                    + "      <p style=\"margin:0;color:#28a745;\"><strong>Trạng thái mới:</strong> <span style=\"background:#e0e7ff;color:#3730a3;padding:2px 8px;border-radius:4px;font-weight:bold;\">" + statusLabel + "</span></p>"
                    + "    </div>"
                    + "    <div style=\"background:#eef2ff;border:1px solid #c7d2fe;padding:16px;border-radius:6px;margin-bottom:20px;\">"
                    + "      <h4 style=\"margin:0 0 8px;color:#1e3a8a;\">📝 NỘI DUNG TRẢ LỜI TỪ CƠ QUAN CHỨC NĂNG:</h4>"
                    + "      <p style=\"margin:0;color:#1e293b;line-height:1.6;white-space:pre-wrap;\">" + replyContent + "</p>"
                    + "    </div>"
                    + "    <p style=\"font-size:0.9rem;color:#666;\">Quý cử tri có thể tra cứu lại phản ánh bất kỳ lúc nào tại Cổng thông tin:</p>"
                    + "    <div style=\"text-align:center;margin:20px 0;\">"
                    + "      <a href=\"https://phananh-mttq.onrender.com/?ma=" + code + "#tracuu\" style=\"background:#b5000b;color:#ffffff;text-decoration:none;padding:10px 24px;border-radius:4px;font-weight:bold;display:inline-block;\">🔍 Xem chi tiết trên Website</a>"
                    + "    </div>"
                    + "  </div>"
                    + "  <div style=\"background:#f1f5f9;color:#64748b;padding:14px;text-align:center;font-size:0.85rem;\">"
                    + "    Email này được gửi tự động từ Cổng thông tin Phản ánh cử tri Phường Liên Hòa. Vui lòng không trả lời trực tiếp email này."
                    + "  </div>"
                    + "</div>";

            String res = sendEmailSync(recipientEmail, subject, htmlContent);
            if ("OK".equals(res)) {
                System.out.println("✅ Gửi email thông báo phản hồi thành công đến: " + recipientEmail);
            } else {
                System.out.println("❌ Lỗi gửi email thông báo: " + res);
            }
        });
    }

    private static String sendViaBrevoApi(String apiKey, String senderEmail, String recipientEmail, String subject, String htmlContent) throws Exception {
        URL url = new URL("https://api.brevo.com/v3/smtp/email");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("api-key", apiKey);
        conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
        conn.setRequestProperty("Accept", "application/json");
        conn.setDoOutput(true);

        String jsonInputString = "{\"sender\":{\"name\":\"UBMTTQ Phường Liên Hòa\",\"email\":\"" + escapeJson(senderEmail) + "\"},\"to\":[{\"email\":\"" + escapeJson(recipientEmail) + "\"}],\"subject\":\"" + escapeJson(subject) + "\",\"htmlContent\":\"" + escapeJson(htmlContent) + "\"}";

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int code = conn.getResponseCode();
        if (code >= 200 && code < 300) {
            return "OK";
        } else {
            InputStream err = conn.getErrorStream();
            String errText = "";
            if (err != null) errText = new String(err.readAllBytes(), StandardCharsets.UTF_8);
            throw new Exception("Brevo API HTTP " + code + " " + errText);
        }
    }

    private static String sendViaResendApi(String apiKey, String recipientEmail, String subject, String htmlContent) throws Exception {
        URL url = new URL("https://api.resend.com/emails");
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + apiKey);
        conn.setRequestProperty("Content-Type", "application/json; charset=utf-8");
        conn.setDoOutput(true);

        String jsonInputString = "{\"from\":\"UBMTTQ Phường Liên Hòa <onboarding@resend.dev>\",\"to\":[\"" + escapeJson(recipientEmail) + "\"],\"subject\":\"" + escapeJson(subject) + "\",\"html\":\"" + escapeJson(htmlContent) + "\"}";

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int code = conn.getResponseCode();
        if (code >= 200 && code < 300) {
            return "OK";
        } else {
            InputStream err = conn.getErrorStream();
            String errText = "";
            if (err != null) errText = new String(err.readAllBytes(), StandardCharsets.UTF_8);
            throw new Exception("Resend API HTTP " + code + " " + errText);
        }
    }

    private static String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\b", "\\b")
                    .replace("\f", "\\f")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}
