package Models;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DocumentCategoryDAO extends DBContext {

    public DocumentCategoryDAO() {
        super();
        ensureCategoryTableExist();
    }

    private void ensureCategoryTableExist() {
        if (connection == null) return;
        try {
            String sqlCreate = "CREATE TABLE IF NOT EXISTS document_categories (" +
                               "id SERIAL PRIMARY KEY, " +
                               "name VARCHAR(100) NOT NULL UNIQUE" +
                               ")";
            // Đối với SQL Server fallback
            boolean isPostgres = false;
            try {
                if (connection.getMetaData() != null && connection.getMetaData().getDatabaseProductName() != null) {
                    isPostgres = connection.getMetaData().getDatabaseProductName().toLowerCase().contains("postgresql");
                }
            } catch (Exception ex) {}

            if (!isPostgres) {
                sqlCreate = "IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'document_categories') " +
                            "CREATE TABLE document_categories (" +
                            "id INT IDENTITY(1,1) PRIMARY KEY, " +
                            "name NVARCHAR(100) NOT NULL UNIQUE" +
                            ")";
            }

            try (PreparedStatement ps = connection.prepareStatement(sqlCreate)) {
                ps.executeUpdate();
            }

            // Khởi tạo các thể loại mặc định nếu chưa có
            String sqlCheck = "SELECT COUNT(*) FROM document_categories";
            try (PreparedStatement ps = connection.prepareStatement(sqlCheck);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) == 0) {
                    String[] defaultCats = {"Thông báo", "Báo cáo", "Kế hoạch", "Tài liệu hướng dẫn"};
                    for (String cat : defaultCats) {
                        addCategory(cat);
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi ensureCategoryTableExist: " + e.getMessage());
        }
    }

    public List<String> getAllCategories() {
        List<String> list = new ArrayList<>();
        if (connection == null) {
            list.add("Thông báo");
            list.add("Báo cáo");
            list.add("Kế hoạch");
            list.add("Tài liệu hướng dẫn");
            return list;
        }

        String sql = "SELECT name FROM document_categories ORDER BY id ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("name"));
            }
        } catch (Exception e) {
            System.out.println("Lỗi getAllCategories: " + e.getMessage());
        }

        if (list.isEmpty()) {
            list.add("Thông báo");
            list.add("Báo cáo");
            list.add("Kế hoạch");
            list.add("Tài liệu hướng dẫn");
        }
        return list;
    }

    public boolean addCategory(String name) {
        if (connection == null || name == null || name.trim().isEmpty()) return false;
        String sql = "INSERT INTO document_categories (name) VALUES (?) ON CONFLICT (name) DO NOTHING";
        boolean isPostgres = false;
        try {
            if (connection.getMetaData() != null && connection.getMetaData().getDatabaseProductName() != null) {
                isPostgres = connection.getMetaData().getDatabaseProductName().toLowerCase().contains("postgresql");
            }
        } catch (Exception ex) {}

        if (!isPostgres) {
            sql = "IF NOT EXISTS (SELECT 1 FROM document_categories WHERE name = ?) INSERT INTO document_categories (name) VALUES (?)";
        }

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            if (!isPostgres) {
                ps.setString(2, name.trim());
            }
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            System.out.println("Lỗi addCategory: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteCategory(String name) {
        if (connection == null || name == null || name.trim().isEmpty()) return false;
        String sql = "DELETE FROM document_categories WHERE name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name.trim());
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            System.out.println("Lỗi deleteCategory: " + e.getMessage());
        }
        return false;
    }
}
