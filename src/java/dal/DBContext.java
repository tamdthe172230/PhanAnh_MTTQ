package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            String dbHost   = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "localhost:1433";
            String dbName   = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "UBND_MatTranLienHoa";
            String username = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "sa";
            String password = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "123";

            String url = "jdbc:sqlserver://" + dbHost + ";databaseName=" + dbName + ";encrypt=false;trustServerCertificate=true;";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("Lỗi DBContext: " + ex.getMessage());
        }
    }

    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException ex) {
            System.out.println("Lỗi đóng DBContext: " + ex.getMessage());
        }
    }
}
