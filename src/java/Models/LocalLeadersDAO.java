package Models;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class LocalLeadersDAO extends DBContext {

    public Map<String, District> getDistrictWardsMap() {
        Map<String, District> map = new LinkedHashMap<>();
        String sql = "SELECT id, name FROM streets";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                Map<String, Ward> wardContainer = new LinkedHashMap<>();
                wardContainer.put("main", new Ward(name, new ArrayList<>()));
                map.put(String.valueOf(id), new District(name, wardContainer));
            }
        } catch (SQLException e) {
            System.out.println("Lỗi getDistrictWardsMap: " + e.getMessage());
        } finally {
            close();
        }
        return map;
    }
}
