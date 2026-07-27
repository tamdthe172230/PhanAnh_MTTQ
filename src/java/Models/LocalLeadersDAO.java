package Models;

import dal.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class LocalLeadersDAO extends DBContext {

    public Map<String, District> getDistrictWardsMap() {
        Map<String, District> map = new LinkedHashMap<>();
        if (connection == null) return getFallbackDistricts();
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
        } catch (Exception e) {
            System.out.println("Lỗi getDistrictWardsMap: " + e.getMessage());
        } finally {
            close();
        }
        if (map.isEmpty()) return getFallbackDistricts();
        return map;
    }

    private Map<String, District> getFallbackDistricts() {
        Map<String, District> map = new LinkedHashMap<>();
        String[] defaults = {"Khu phố Lưu Khê", "Khu phố Liên Hòa 1", "Khu phố Liên Hòa 2", "Khu phố Vĩnh Hòa"};
        for (int i = 0; i < defaults.length; i++) {
            Map<String, Ward> wardContainer = new LinkedHashMap<>();
            wardContainer.put("main", new Ward(defaults[i], new ArrayList<>()));
            map.put(String.valueOf(i + 1), new District(defaults[i], wardContainer));
        }
        return map;
    }
}
