package Models;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicInteger;

public class FeedbackDAO extends DBContext {

    private static final List<Feedback> MEMORY_FEEDBACKS = new CopyOnWriteArrayList<>();
    private static final AtomicInteger MEMORY_ID_COUNTER = new AtomicInteger(100);
    private static boolean memorySeeded = false;

    private static synchronized void initMemoryStore() {
        if (memorySeeded) return;
        memorySeeded = true;

        Feedback f1 = new Feedback();
        f1.setId(1);
        f1.setVoterName("Nguyễn Văn An");
        f1.setPhone("0912345678");
        f1.setEmail("vunan@gmail.com");
        f1.setDate("15/07/2026");
        f1.setThon("Khu phố Lưu Khê");
        f1.setType("An ninh trật tự - Phòng cháy chữa cháy");
        f1.setStatus("answered");
        f1.setStatusLabel("Đã trả lời");
        f1.setContent("Đề nghị kiểm tra công trình xây dựng lấn chiếm lòng đường tại khu vực tổ 3, gây cản trở giao thông.");
        f1.setReply("UBND Phường đã cử cán bộ địa chính xuống kiểm tra và yêu cầu chủ hộ tháo dỡ phần vi phạm.");

        Feedback f2 = new Feedback();
        f2.setId(2);
        f2.setVoterName("Trần Thị Bình");
        f2.setPhone("0987654321");
        f2.setEmail("binhtran@gmail.com");
        f2.setDate("16/07/2026");
        f2.setThon("Khu phố Liên Hòa 1");
        f2.setType("Môi trường - Vệ sinh công cộng");
        f2.setStatus("processing");
        f2.setStatusLabel("Đang xử lý");
        f2.setContent("Hố rác tập trung tại khu vực bến đò gây ô nhiễm mùi hôi thối vào buổi chiều, đề nghị thu gom rác đúng giờ.");
        f2.setReply("Đang giao Ban quản lý môi trường đô thị tăng cường xe thu gom.");

        Feedback f3 = new Feedback();
        f3.setId(3);
        f3.setVoterName("Lê Văn Cường");
        f3.setPhone("0905112233");
        f3.setEmail("cuongle@gmail.com");
        f3.setDate("17/07/2026");
        f3.setThon("Khu phố Liên Hòa 2");
        f3.setType("An ninh trật tự - Phòng cháy chữa cháy");
        f3.setStatus("received");
        f3.setStatusLabel("Đã tiếp nhận");
        f3.setContent("Tình trạng thanh thiếu niên tụ tập nẹt bô xe máy ban đêm gây mất trật tự an ninh khu phố.");
        f3.setReply("");

        MEMORY_FEEDBACKS.add(f1);
        MEMORY_FEEDBACKS.add(f2);
        MEMORY_FEEDBACKS.add(f3);
    }

    public FeedbackDAO() {
        super();
        initMemoryStore();
        ensureTablesExist();
    }

    private void ensureTablesExist() {
        if (connection == null) return;
        try {
            boolean isPostgres = false;
            try {
                if (connection.getMetaData() != null && connection.getMetaData().getDatabaseProductName() != null) {
                    isPostgres = connection.getMetaData().getDatabaseProductName().toLowerCase().contains("postgresql");
                }
            } catch(Exception ex) {}

            Statement st = connection.createStatement();

            // 1. Tạo bảng streets nếu chưa tồn tại
            if (isPostgres) {
                st.executeUpdate("CREATE TABLE IF NOT EXISTS streets (id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL)");
            } else {
                try {
                    st.executeUpdate("IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='streets' AND xtype='U') " +
                                     "CREATE TABLE streets (id INT IDENTITY(1,1) PRIMARY KEY, name NVARCHAR(255) NOT NULL)");
                } catch(Exception ex) {}
            }

            // 2. Tạo bảng feedback_type nếu chưa tồn tại
            if (isPostgres) {
                st.executeUpdate("CREATE TABLE IF NOT EXISTS feedback_type (id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL)");
            } else {
                try {
                    st.executeUpdate("IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='feedback_type' AND xtype='U') " +
                                     "CREATE TABLE feedback_type (id INT IDENTITY(1,1) PRIMARY KEY, name NVARCHAR(255) NOT NULL)");
                } catch(Exception ex) {}
            }

            // 3. Tạo bảng feedback nếu chưa tồn tại
            if (isPostgres) {
                st.executeUpdate("CREATE TABLE IF NOT EXISTS feedback (" +
                                 "id SERIAL PRIMARY KEY, " +
                                 "voter_name VARCHAR(255) NOT NULL, " +
                                 "phone VARCHAR(50), " +
                                 "email VARCHAR(150), " +
                                 "feedback_date VARCHAR(50), " +
                                 "street_id INT, " +
                                 "type_id INT, " +
                                 "status VARCHAR(50) DEFAULT 'received', " +
                                 "status_label VARCHAR(100) DEFAULT 'Đã tiếp nhận', " +
                                 "content TEXT, " +
                                 "reply TEXT, " +
                                 "is_deleted INT DEFAULT 0, " +
                                 "attached_file VARCHAR(255))");
                st.executeUpdate("ALTER TABLE feedback ADD COLUMN IF NOT EXISTS email VARCHAR(150)");
            } else {
                try {
                    st.executeUpdate("IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='feedback' AND xtype='U') " +
                                     "CREATE TABLE feedback (" +
                                     "id INT IDENTITY(1,1) PRIMARY KEY, " +
                                     "voter_name NVARCHAR(255) NOT NULL, " +
                                     "phone VARCHAR(50), " +
                                     "email NVARCHAR(150), " +
                                     "feedback_date VARCHAR(50), " +
                                     "street_id INT, " +
                                     "type_id INT, " +
                                     "status VARCHAR(50) DEFAULT 'received', " +
                                     "status_label NVARCHAR(100) DEFAULT 'Đã tiếp nhận', " +
                                     "content NVARCHAR(MAX), " +
                                     "reply NVARCHAR(MAX), " +
                                     "is_deleted INT DEFAULT 0, " +
                                     "attached_file NVARCHAR(255))");
                } catch(Exception ex) {}
                try {
                    st.executeUpdate("IF NOT EXISTS (SELECT * FROM syscolumns WHERE id=object_id('feedback') AND name='email') ALTER TABLE feedback ADD email NVARCHAR(150)");
                } catch(Exception ex) {}
            }

            // 4. Kiểm tra nạp dữ liệu khu phố
            ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM streets");
            if (rs1.next() && rs1.getInt(1) == 0) {
                st.executeUpdate("INSERT INTO streets (name) VALUES ('Khu phố Lưu Khê'), ('Khu phố Liên Hòa 1'), ('Khu phố Liên Hòa 2'), ('Khu phố Vĩnh Hòa')");
            }

            // 5. Kiểm tra nạp dữ liệu lĩnh vực
            ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM feedback_type");
            if (rs2.next() && rs2.getInt(1) == 0) {
                st.executeUpdate("INSERT INTO feedback_type (name) VALUES ('An ninh trật tự - Phòng cháy chữa cháy'), ('Môi trường - Vệ sinh công cộng'), ('Đô thị - Giao thông'), ('Hạ tầng - Đô thị'), ('Lĩnh vực khác')");
            }

            // 6. Kiểm tra nạp dữ liệu mẫu phản ánh nếu chưa có
            ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM feedback");
            if (rs3.next() && rs3.getInt(1) == 0) {
                String seedFeedbackSql = "INSERT INTO feedback (voter_name, phone, email, feedback_date, street_id, type_id, status, status_label, content, reply, is_deleted) VALUES " +
                    "('Nguyễn Văn An', '0912345678', 'vunan@gmail.com', '15/07/2026', 1, 1, 'answered', 'Đã trả lời', 'Đề nghị kiểm tra công trình xây dựng lấn chiếm lòng đường tại khu vực tổ 3, gây cản trở giao thông.', 'UBND Phường đã cử cán bộ địa chính xuống kiểm tra và yêu cầu chủ hộ tháo dỡ phần vi phạm.', 0), " +
                    "('Trần Thị Bình', '0987654321', 'binhtran@gmail.com', '16/07/2026', 1, 2, 'processing', 'Đang xử lý', 'Hố rác tập trung tại khu vực bến đò gây ô nhiễm mùi hôi thối vào buổi chiều, đề nghị thu gom rác đúng giờ.', 'Đang giao Ban quản lý môi trường đô thị tăng cường xe thu gom.', 0), " +
                    "('Lê Văn Cường', '0905112233', 'cuongle@gmail.com', '17/07/2026', 2, 1, 'received', 'Đã tiếp nhận', 'Tình trạng thanh thiếu niên tụ tập nẹt bô xe máy ban đêm gây mất trật tự an ninh khu phố.', '', 0)";
                st.executeUpdate(seedFeedbackSql);
            }
        } catch (Exception e) {
            System.out.println("Lỗi ensureTablesExist: " + e.getMessage());
        }
    }

    public List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        if (connection != null) {
            String sql = "SELECT f.id, f.voter_name, f.phone, f.email, f.feedback_date, s.name AS street_name, t.name AS type_name, f.status, f.status_label, f.content, f.reply, f.attached_file " +
                         "FROM feedback f " +
                         "LEFT JOIN streets s ON f.street_id = s.id " +
                         "LEFT JOIN feedback_type t ON f.type_id = t.id " +
                         "WHERE f.is_deleted = 0 OR f.is_deleted IS NULL " +
                         "ORDER BY f.id DESC";
            try {
                PreparedStatement st = connection.prepareStatement(sql);
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
                    Feedback fb = new Feedback();
                    fb.setId(rs.getInt("id"));
                    fb.setVoterName(rs.getString("voter_name"));
                    fb.setPhone(rs.getString("phone"));
                    fb.setEmail(rs.getString("email"));
                    fb.setDate(rs.getString("feedback_date"));
                    fb.setThon(rs.getString("street_name"));
                    String rawType = rs.getString("type_name");
                    String rawContent = rs.getString("content");
                    if (rawContent != null && rawContent.startsWith("[Lĩnh vực:")) {
                        int endIdx = rawContent.indexOf("]");
                        if (endIdx != -1) {
                            String customType = rawContent.substring(rawContent.indexOf(":") + 1, endIdx).trim();
                            if (!customType.isEmpty()) {
                                rawType = customType;
                            }
                            rawContent = rawContent.substring(endIdx + 1).trim();
                        }
                    }
                    fb.setType(rawType);
                    fb.setContent(rawContent);
                    fb.setStatus(rs.getString("status"));
                    fb.setStatusLabel(rs.getString("status_label"));
                    fb.setReply(rs.getString("reply"));
                    fb.setAttachedFile(rs.getString("attached_file"));
                    list.add(fb);
                }
            } catch (Exception e) {
                System.out.println("Lỗi getAllFeedbacks: " + e.getMessage());
            } finally {
                close();
            }
        }
        if (list.isEmpty()) {
            return new ArrayList<>(MEMORY_FEEDBACKS);
        }
        return list;
    }

    public Feedback getFeedbackById(int id) {
        if (connection != null) {
            String sql = "SELECT f.id, f.voter_name, f.phone, f.email, f.feedback_date, s.name AS street_name, t.name AS type_name, f.status, f.status_label, f.content, f.reply, f.attached_file " +
                         "FROM feedback f " +
                         "LEFT JOIN streets s ON f.street_id = s.id " +
                         "LEFT JOIN feedback_type t ON f.type_id = t.id " +
                         "WHERE f.id = ?";
            try {
                PreparedStatement st = connection.prepareStatement(sql);
                st.setInt(1, id);
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    Feedback fb = new Feedback();
                    fb.setId(rs.getInt("id"));
                    fb.setVoterName(rs.getString("voter_name"));
                    fb.setPhone(rs.getString("phone"));
                    fb.setEmail(rs.getString("email"));
                    fb.setDate(rs.getString("feedback_date"));
                    fb.setThon(rs.getString("street_name"));
                    fb.setType(rs.getString("type_name"));
                    fb.setContent(rs.getString("content"));
                    fb.setStatus(rs.getString("status"));
                    fb.setStatusLabel(rs.getString("status_label"));
                    fb.setReply(rs.getString("reply"));
                    fb.setAttachedFile(rs.getString("attached_file"));
                    return fb;
                }
            } catch (Exception e) {
                System.out.println("Lỗi getFeedbackById: " + e.getMessage());
            } finally {
                close();
            }
        }
        for (Feedback fb : MEMORY_FEEDBACKS) {
            if (fb.getId() == id) return fb;
        }
        return null;
    }

    private String getStreetNameById(int id) {
        switch (id) {
            case 1: return "Khu phố Lưu Khê";
            case 2: return "Khu phố Liên Hòa 1";
            case 3: return "Khu phố Liên Hòa 2";
            case 4: return "Khu phố Vĩnh Hòa";
            default: return "Khu phố Lưu Khê";
        }
    }

    private String getTypeNameById(int id) {
        switch (id) {
            case 1: return "An ninh trật tự - Phòng cháy chữa cháy";
            case 2: return "Môi trường - Vệ sinh công cộng";
            case 3: return "Đô thị - Giao thông";
            case 4: return "Hạ tầng - Đô thị";
            default: return "Lĩnh vực khác";
        }
    }

    public int addFeedback(Feedback fb, int streetId, int typeId) {
        int memoryId = MEMORY_ID_COUNTER.getAndIncrement();
        Feedback memFb = new Feedback();
        memFb.setId(memoryId);
        memFb.setVoterName(fb.getVoterName());
        memFb.setPhone(fb.getPhone());
        memFb.setEmail(fb.getEmail());
        memFb.setDate(fb.getDate());
        memFb.setThon(getStreetNameById(streetId));
        memFb.setType(getTypeNameById(typeId));
        memFb.setStatus(fb.getStatus());
        memFb.setStatusLabel(fb.getStatusLabel());
        memFb.setContent(fb.getContent());
        memFb.setReply(fb.getReply());
        memFb.setAttachedFile(fb.getAttachedFile());
        
        MEMORY_FEEDBACKS.add(0, memFb);

        if (connection == null) {
            return memoryId;
        }

        ensureTablesExist();
        int validStreetId = getValidStreetId(streetId);
        int validTypeId = getValidTypeId(typeId);

        try {
            boolean isPostgres = false;
            try {
                if (connection.getMetaData() != null && connection.getMetaData().getDatabaseProductName() != null) {
                    isPostgres = connection.getMetaData().getDatabaseProductName().toLowerCase().contains("postgresql");
                }
            } catch(Exception ex) {}

            String sql = "INSERT INTO feedback (voter_name, phone, email, feedback_date, street_id, type_id, status, status_label, content, reply, attached_file, is_deleted) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)";
            
            if (isPostgres) {
                try (PreparedStatement st = connection.prepareStatement(sql + " RETURNING id")) {
                    st.setString(1, fb.getVoterName());
                    st.setString(2, fb.getPhone());
                    st.setString(3, fb.getEmail() != null ? fb.getEmail().trim() : "");
                    st.setString(4, fb.getDate());
                    st.setInt(5, validStreetId);
                    st.setInt(6, validTypeId);
                    st.setString(7, fb.getStatus());
                    st.setString(8, fb.getStatusLabel());
                    st.setString(9, fb.getContent());
                    st.setString(10, fb.getReply() != null ? fb.getReply() : "");
                    st.setString(11, fb.getAttachedFile() != null ? fb.getAttachedFile() : "");
                    ResultSet rs = st.executeQuery();
                    if (rs.next()) {
                        int dbId = rs.getInt(1);
                        memFb.setId(dbId);
                        return dbId;
                    }
                } catch(Exception pgEx) {
                    System.out.println("Lỗi PostgreSQL RETURNING id: " + pgEx.getMessage());
                }
            }

            try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                st.setString(1, fb.getVoterName());
                st.setString(2, fb.getPhone());
                st.setString(3, fb.getEmail() != null ? fb.getEmail().trim() : "");
                st.setString(4, fb.getDate());
                st.setInt(5, validStreetId);
                st.setInt(6, validTypeId);
                st.setString(7, fb.getStatus());
                st.setString(8, fb.getStatusLabel());
                st.setString(9, fb.getContent());
                st.setString(10, fb.getReply() != null ? fb.getReply() : "");
                st.setString(11, fb.getAttachedFile() != null ? fb.getAttachedFile() : "");

                int affectedRows = st.executeUpdate();
                if (affectedRows > 0) {
                    try {
                        ResultSet rs = st.getGeneratedKeys();
                        if (rs != null && rs.next()) {
                            int dbId = rs.getInt(1);
                            memFb.setId(dbId);
                            return dbId;
                        }
                    } catch (Exception ex) {}
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi addFeedback DB: " + e.getMessage());
        } finally {
            close();
        }
        return memoryId;
    }

    private int getValidStreetId(int requestedId) {
        try {
            PreparedStatement st = connection.prepareStatement("SELECT id FROM streets WHERE id = ?");
            st.setInt(1, requestedId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return requestedId;
        } catch(Exception e) {}
        return 1;
    }

    private int getValidTypeId(int requestedId) {
        try {
            PreparedStatement st = connection.prepareStatement("SELECT id FROM feedback_type WHERE id = ?");
            st.setInt(1, requestedId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return requestedId;
        } catch(Exception e) {}
        return 1;
    }

    public List<Category> getAllFeedbackTypes() {
        List<Category> list = new ArrayList<>();
        if (connection != null) {
            String sql = "SELECT id, name FROM feedback_type";
            try {
                PreparedStatement st = connection.prepareStatement(sql);
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
                    Category cat = new Category();
                    cat.setCode(String.valueOf(rs.getInt("id")));
                    cat.setName(rs.getString("name"));
                    list.add(cat);
                }
            } catch (Exception e) {
                System.out.println("Lỗi getAllFeedbackTypes: " + e.getMessage());
            } finally {
                close();
            }
        }
        if (list.isEmpty()) return getFallbackTypes();
        return list;
    }

    private List<Category> getFallbackTypes() {
        List<Category> list = new ArrayList<>();
        String[] types = {"An ninh trật tự - Phòng cháy chữa cháy", "Môi trường - Vệ sinh công cộng", "Đô thị - Giao thông", "Hạ tầng - Đô thị", "Lĩnh vực khác"};
        for (int i = 0; i < types.length; i++) {
            Category cat = new Category();
            cat.setCode(String.valueOf(i + 1));
            cat.setName(types[i]);
            list.add(cat);
        }
        return list;
    }

    public int getOrCreateFeedbackType(String typeName) {
        if (typeName == null || typeName.trim().isEmpty()) {
            return -1;
        }
        if (connection != null) {
            String selectSql = "SELECT id FROM feedback_type WHERE name = ?";
            try {
                PreparedStatement st = connection.prepareStatement(selectSql);
                st.setString(1, typeName.trim());
                ResultSet rs = st.executeQuery();
                if (rs.next()) {
                    int foundId = rs.getInt("id");
                    close();
                    return foundId;
                }
            } catch (SQLException e) {
                System.out.println("Lỗi check feedback_type: " + e.getMessage());
            }

            String insertSql = "INSERT INTO feedback_type (name) VALUES (?)";
            try {
                PreparedStatement st = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS);
                st.setString(1, typeName.trim());
                int affectedRows = st.executeUpdate();
                if (affectedRows > 0) {
                    ResultSet rs = st.getGeneratedKeys();
                    if (rs.next()) {
                        int newId = rs.getInt(1);
                        close();
                        return newId;
                    }
                }
            } catch (SQLException e) {
                System.out.println("Lỗi insert feedback_type: " + e.getMessage());
            } finally {
                close();
            }
        }
        return 1;
    }

    public boolean updateFeedbackStatusAndReply(int id, String status, String statusLabel, String reply) {
        for (Feedback fb : MEMORY_FEEDBACKS) {
            if (fb.getId() == id) {
                fb.setStatus(status);
                fb.setStatusLabel(statusLabel);
                fb.setReply(reply);
                break;
            }
        }
        if (connection != null) {
            String sql = "UPDATE feedback SET status = ?, status_label = ?, reply = ? WHERE id = ?";
            try {
                PreparedStatement st = connection.prepareStatement(sql);
                st.setString(1, status);
                st.setString(2, statusLabel);
                st.setString(3, reply);
                st.setInt(4, id);
                return st.executeUpdate() > 0;
            } catch (SQLException e) {
                System.out.println("Lỗi updateFeedbackStatusAndReply: " + e.getMessage());
            } finally {
                close();
            }
        }
        return true;
    }

    public boolean deleteFeedback(int id) {
        MEMORY_FEEDBACKS.removeIf(fb -> fb.getId() == id);
        if (connection != null) {
            String sql = "UPDATE feedback SET is_deleted = 1 WHERE id = ?";
            try {
                PreparedStatement st = connection.prepareStatement(sql);
                st.setInt(1, id);
                return st.executeUpdate() > 0;
            } catch (SQLException e) {
                System.out.println("Lỗi deleteFeedback: " + e.getMessage());
            } finally {
                close();
            }
        }
        return true;
    }
}
