package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            String dbUrl    = System.getenv("DATABASE_URL");
            String dbHost   = System.getenv("DB_HOST");
            String dbName   = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "UBND_MatTranLienHoa";
            String username = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "sa";
            String password = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "123";

            String url;
            if (dbUrl != null && !dbUrl.trim().isEmpty()) {
                url = dbUrl;
                if (url.startsWith("postgres://")) {
                    url = url.replace("postgres://", "jdbc:postgresql://");
                }
            } else if (dbHost != null && !dbHost.trim().isEmpty()) {
                url = "jdbc:sqlserver://" + dbHost + ";databaseName=" + dbName + ";encrypt=false;trustServerCertificate=true;";
            } else {
                url = "jdbc:sqlserver://localhost:1433;databaseName=UBND_MatTranLienHoa;encrypt=false;trustServerCertificate=true;";
            }

            if (url.startsWith("jdbc:postgresql:")) {
                try { Class.forName("org.postgresql.Driver"); } catch(Exception e){}
                connection = DriverManager.getConnection(url);
            } else {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                if (dbUrl != null && !dbUrl.trim().isEmpty()) {
                    connection = DriverManager.getConnection(url);
                } else {
                    connection = DriverManager.getConnection(url, username, password);
                }
            }
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
