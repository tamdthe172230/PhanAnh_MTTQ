package Models;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAO extends DBContext {

    public AdminDAO() {
        super();
        initAdminTable();
    }

    private void initAdminTable() {
        if (connection == null) return;
        try {
            // Tạo bảng admin_users nếu chưa tồn tại
            String sqlCreate = "CREATE TABLE IF NOT EXISTS admin_users (" +
                               "username VARCHAR(50) PRIMARY KEY, " +
                               "password VARCHAR(100) NOT NULL" +
                               ")";
            try (PreparedStatement ps = connection.prepareStatement(sqlCreate)) {
                ps.executeUpdate();
            }

            // Kiểm tra xem đã có tài khoản admin mặc định chưa
            String sqlCheck = "SELECT COUNT(*) FROM admin_users WHERE username = 'admin'";
            try (PreparedStatement ps = connection.prepareStatement(sqlCheck);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) == 0) {
                    String sqlInsert = "INSERT INTO admin_users (username, password) VALUES ('admin', '123')";
                    try (PreparedStatement psIns = connection.prepareStatement(sqlInsert)) {
                        psIns.executeUpdate();
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi initAdminTable: " + e.getMessage());
        }
    }

    public boolean authenticate(String username, String password) {
        if (connection == null || username == null || password == null) return false;
        String sql = "SELECT password FROM admin_users WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String dbPass = rs.getString("password");
                    return password.equals(dbPass);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi authenticate: " + e.getMessage());
        }
        // Fallback kiểm tra mặc định nếu DB gián đoạn
        return "admin".equalsIgnoreCase(username) && "123".equals(password);
    }

    public boolean changePassword(String username, String oldPassword, String newPassword) {
        if (connection == null || username == null || oldPassword == null || newPassword == null) return false;
        if (!authenticate(username, oldPassword)) return false;

        String sql = "UPDATE admin_users SET password = ? WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newPassword.trim());
            ps.setString(2, username.trim());
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            System.out.println("Lỗi changePassword: " + e.getMessage());
        }
        return false;
    }
}
