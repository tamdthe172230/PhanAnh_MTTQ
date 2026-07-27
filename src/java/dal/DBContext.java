package dal;

import java.net.URI;
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

            if (dbUrl != null && !dbUrl.trim().isEmpty()) {
                String cleanUrl = dbUrl.trim();
                if (cleanUrl.startsWith("postgres://") || cleanUrl.startsWith("postgresql://")) {
                    try {
                        URI dbUri = new URI(cleanUrl);
                        String pgUser = dbUri.getUserInfo() != null ? dbUri.getUserInfo().split(":")[0] : username;
                        String pgPass = dbUri.getUserInfo() != null && dbUri.getUserInfo().contains(":") ? dbUri.getUserInfo().split(":")[1] : password;
                        String host = dbUri.getHost();
                        int port = dbUri.getPort();
                        String path = dbUri.getPath();

                        String jdbcUrl = "jdbc:postgresql://" + host + (port != -1 ? ":" + port : "") + path;
                        Class.forName("org.postgresql.Driver");
                        connection = DriverManager.getConnection(jdbcUrl, pgUser, pgPass);
                        return;
                    } catch (Exception ex) {
                        System.out.println("Lỗi URI parse PostgreSQL: " + ex.getMessage());
                    }
                }
            }

            String url;
            if (dbHost != null && !dbHost.trim().isEmpty()) {
                url = "jdbc:sqlserver://" + dbHost + ";databaseName=" + dbName + ";encrypt=false;trustServerCertificate=true;";
            } else {
                url = "jdbc:sqlserver://localhost:1433;databaseName=UBND_MatTranLienHoa;encrypt=false;trustServerCertificate=true;";
            }

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
