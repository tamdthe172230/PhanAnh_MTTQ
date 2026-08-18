package Models;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO extends DBContext {

    private void ensureDocumentTableExist() {
        if (connection == null) return;
        try {
            Statement st = connection.createStatement();
            boolean isPostgres = false;
            try {
                if (connection.getMetaData() != null && connection.getMetaData().getDatabaseProductName() != null) {
                    isPostgres = connection.getMetaData().getDatabaseProductName().toLowerCase().contains("postgresql");
                }
            } catch(Exception ex) {}

            if (isPostgres) {
                st.executeUpdate(
                    "CREATE TABLE IF NOT EXISTS documents (" +
                    "id SERIAL PRIMARY KEY, " +
                    "title VARCHAR(255) NOT NULL, " +
                    "category VARCHAR(100) NOT NULL, " +
                    "doc_date VARCHAR(50) NOT NULL, " +
                    "file_path VARCHAR(255) NOT NULL, " +
                    "file_data TEXT, " +
                    "description TEXT, " +
                    "is_deleted INT DEFAULT 0" +
                    ")"
                );
                try {
                    st.executeUpdate("ALTER TABLE documents ADD COLUMN IF NOT EXISTS file_data TEXT");
                } catch(Exception ex) {}
            } else {
                try {
                    st.executeUpdate(
                        "IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='documents' and xtype='U') " +
                        "CREATE TABLE documents (" +
                        "id INT IDENTITY(1,1) PRIMARY KEY, " +
                        "title NVARCHAR(255) NOT NULL, " +
                        "category NVARCHAR(100) NOT NULL, " +
                        "doc_date VARCHAR(50) NOT NULL, " +
                        "file_path NVARCHAR(255) NOT NULL, " +
                        "file_data NVARCHAR(MAX), " +
                        "description NVARCHAR(MAX), " +
                        "is_deleted INT DEFAULT 0" +
                        ")"
                    );
                } catch(Exception ex) {}
                try {
                    st.executeUpdate("IF NOT EXISTS (SELECT * FROM syscolumns WHERE id=object_id('documents') AND name='file_data') ALTER TABLE documents ADD file_data NVARCHAR(MAX)");
                } catch(Exception ex) {}
            }

            // Kiểm tra và nạp dữ liệu mẫu kèm chuỗi PDF Base64 chuẩn nếu chưa có
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM documents");
            if (rs.next() && rs.getInt(1) == 0) {
                String samplePdfBase64 = "JVBERi0xLjQKMSAwIG9iaiA8PC9UeXBlIC9DYXRhbG9nIC9QYWdlcyAyIDAgUj4+IGVuZG9iagoyIDAgb2JqIDw8L1R5cGUgL1BhZ2VzIC9Db3VudCAxIC9LaWRzIFszIDAgUl0+PiBlbmRvYmoKMyAwIG9iaiA8PC9UeXBlIC9QYWdlIC9QYXJlbnQgMiAwIFIgL01lZGlhQm94IFswIDAgNjEyIDc5MlQgL1Jlc291cmNlcyA8PD4+IC9Db250ZW50cyA0IDAgUj4+IGVuZG9iago0IDAgb2JqIDw8L0xlbmd0aCA2OD4+IHN0cmVhbQpCVCAvRjEgMTYgVGYgNzIgNzEyIFRkIChCYW8gY2FvIGtldCBxdWEgY29uZyB0YWMgTWF0IHRyYW4gUGh1b25nIExpZW4gSG9hIG5hbSAyMDI1KSBUaiBFVAplbmRzdHJlYW0gZW5kb2JqCnhyZWYKMCA1CjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAwOSAwMDAwMCBuIAowMDAwMDAwMDU2IDAwMDAwIG4gCjAwMDAwMDAxMTEgMDAwMDAgbiAKMDAwMDAwMDIxMiAwMDAwMCBuIAp0cmFpbGVyIDw8L1NpemUgNSAvUm9vdCAxIDAgUj4+CnN0YXJ0eHJlZgozMzAKJSVFT0YK";
                String seedSql = "INSERT INTO documents (title, category, doc_date, file_path, file_data, description, is_deleted) VALUES " +
                    "('Báo cáo kết quả công tác Mặt trận Phường Liên Hòa năm 2025', 'Báo cáo', '15/01/2026', 'sample_doc1.pdf', '" + samplePdfBase64 + "', 'Báo cáo chi tiết kết quả thực hiện các phong trào thi đua và công tác mặt trận năm 2025.', 0), " +
                    "('Thông báo lịch tiếp dân và xử lý phản ánh kiến nghị tháng 08/2026', 'Thông báo', '01/08/2026', 'sample_doc2.pdf', '" + samplePdfBase64 + "', 'Thông báo thời gian, địa điểm và thành phần tiếp dân định kỳ của Thường trực Ủy ban MTTQ Phường.', 0), " +
                    "('Kế hoạch phát động phong trào Toàn dân đoàn kết xây dựng đời sống văn hóa', 'Kế hoạch', '10/06/2026', 'sample_doc3.pdf', '" + samplePdfBase64 + "', 'Kế hoạch triển khai đăng ký danh hiệu Khu phố văn hóa và Gia đình văn hóa năm 2026.', 0)";
                st.executeUpdate(seedSql);
            }
        } catch (Exception e) {
            System.out.println("Lỗi ensureDocumentTableExist: " + e.getMessage());
        }
    }

    public List<Document> getAllDocuments() {
        List<Document> list = new ArrayList<>();
        if (connection == null) return list;
        ensureDocumentTableExist();

        String sql = "SELECT id, title, category, doc_date, file_path, description, is_deleted " +
                     "FROM documents " +
                     "WHERE is_deleted = 0 OR is_deleted IS NULL " +
                     "ORDER BY id DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Document doc = new Document();
                doc.setId(rs.getInt("id"));
                doc.setTitle(rs.getString("title"));
                doc.setCategory(rs.getString("category"));
                doc.setDocDate(rs.getString("doc_date"));
                doc.setFilePath(rs.getString("file_path"));
                doc.setDescription(rs.getString("description"));
                doc.setIsDeleted(rs.getInt("is_deleted"));
                list.add(doc);
            }
        } catch (Exception e) {
            System.out.println("Lỗi getAllDocuments: " + e.getMessage());
        } finally {
            close();
        }
        return list;
    }

    public Document getDocumentById(int id) {
        if (connection == null) return null;
        ensureDocumentTableExist();
        String sql = "SELECT id, title, category, doc_date, file_path, file_data, description, is_deleted FROM documents WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Document doc = new Document();
                doc.setId(rs.getInt("id"));
                doc.setTitle(rs.getString("title"));
                doc.setCategory(rs.getString("category"));
                doc.setDocDate(rs.getString("doc_date"));
                doc.setFilePath(rs.getString("file_path"));
                doc.setFileData(rs.getString("file_data"));
                doc.setDescription(rs.getString("description"));
                doc.setIsDeleted(rs.getInt("is_deleted"));
                return doc;
            }
        } catch (Exception e) {
            System.out.println("Lỗi getDocumentById: " + e.getMessage());
        } finally {
            close();
        }
        return null;
    }

    public int addDocument(Document doc) {
        if (connection == null) return -1;
        ensureDocumentTableExist();

        try {
            boolean isPostgres = false;
            try {
                if (connection.getMetaData() != null && connection.getMetaData().getDatabaseProductName() != null) {
                    isPostgres = connection.getMetaData().getDatabaseProductName().toLowerCase().contains("postgresql");
                }
            } catch(Exception ex) {}

            String sql;
            PreparedStatement st;
            if (isPostgres) {
                sql = "INSERT INTO documents (title, category, doc_date, file_path, file_data, description, is_deleted) " +
                      "VALUES (?, ?, ?, ?, ?, ?, 0) RETURNING id";
                st = connection.prepareStatement(sql);
            } else {
                sql = "INSERT INTO documents (title, category, doc_date, file_path, file_data, description, is_deleted) " +
                      "VALUES (?, ?, ?, ?, ?, ?, 0)";
                st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            }

            st.setString(1, doc.getTitle());
            st.setString(2, doc.getCategory());
            st.setString(3, doc.getDocDate());
            st.setString(4, doc.getFilePath() != null ? doc.getFilePath() : "");
            st.setString(5, doc.getFileData() != null ? doc.getFileData() : "");
            st.setString(6, doc.getDescription() != null ? doc.getDescription() : "");

            if (isPostgres) {
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            } else {
                int affectedRows = st.executeUpdate();
                if (affectedRows > 0) {
                    try {
                        ResultSet rs = st.getGeneratedKeys();
                        if (rs != null && rs.next()) {
                            return rs.getInt(1);
                        }
                    } catch (Exception ex) {}
                    try {
                        Statement stMax = connection.createStatement();
                        ResultSet rsMax = stMax.executeQuery("SELECT MAX(id) FROM documents");
                        if (rsMax.next()) {
                            return rsMax.getInt(1);
                        }
                    } catch(Exception ex2) {}
                    return 1;
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi addDocument: " + e.getMessage());
        } finally {
            close();
        }
        return -1;
    }

    public boolean deleteDocument(int id) {
        if (connection == null) return false;
        String sql = "UPDATE documents SET is_deleted = 1 WHERE id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Lỗi deleteDocument: " + e.getMessage());
        } finally {
            close();
        }
        return false;
    }
}
