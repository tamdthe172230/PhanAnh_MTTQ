package Models;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO extends DBContext {

    public List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.id, f.voter_name, f.phone, f.feedback_date, s.name AS street_name, t.name AS type_name, f.status, f.status_label, f.content, f.reply, f.attached_file " +
                     "FROM feedback f " +
                     "JOIN streets s ON f.street_id = s.id " +
                     "JOIN feedback_type t ON f.type_id = t.id " +
                     "WHERE f.is_deleted = 0 " +
                     "ORDER BY f.id DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setId(rs.getInt("id"));
                fb.setVoterName(rs.getString("voter_name"));
                fb.setPhone(rs.getString("phone"));
                fb.setDate(rs.getString("feedback_date"));
                fb.setThon(rs.getString("street_name"));
                fb.setType(rs.getString("type_name"));
                fb.setStatus(rs.getString("status"));
                fb.setStatusLabel(rs.getString("status_label"));
                fb.setContent(rs.getString("content"));
                fb.setReply(rs.getString("reply"));
                fb.setAttachedFile(rs.getString("attached_file"));
                list.add(fb);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getAllFeedbacks: " + e.getMessage());
        } finally {
            close();
        }
        return list;
    }

    public int addFeedback(Feedback fb, int streetId, int typeId) {
        String sql = "INSERT INTO feedback (voter_name, phone, feedback_date, street_id, type_id, status, status_label, content, reply, attached_file) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, fb.getVoterName());
            st.setString(2, fb.getPhone());
            st.setString(3, fb.getDate());
            st.setInt(4, streetId);
            st.setInt(5, typeId);
            st.setString(6, fb.getStatus());
            st.setString(7, fb.getStatusLabel());
            st.setString(8, fb.getContent());
            st.setString(9, fb.getReply() != null ? fb.getReply() : "");
            st.setString(10, fb.getAttachedFile() != null ? fb.getAttachedFile() : "");
            
            int affectedRows = st.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = st.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi addFeedback: " + e.getMessage());
        } finally {
            close();
        }
        return -1;
    }

    public List<Category> getAllFeedbackTypes() {
        List<Category> list = new ArrayList<>();
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
        } catch (SQLException e) {
            System.out.println("Lỗi getAllFeedbackTypes: " + e.getMessage());
        } finally {
            close();
        }
        return list;
    }

    public int getOrCreateFeedbackType(String typeName) {
        if (typeName == null || typeName.trim().isEmpty()) {
            return -1;
        }
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
        return -1;
    }

    public boolean updateFeedbackStatusAndReply(int id, String status, String statusLabel, String reply) {
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
        return false;
    }

    public boolean deleteFeedback(int id) {
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
        return false;
    }
}
