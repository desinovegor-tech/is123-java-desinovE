package avito;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbUtil {
    private static final String URL =
            "jdbc:firebirdsql://localhost:3050/C:/RedDB/avito";
    //C:/RedDB/avito.fdb
    private static final String USER = "Sysdba";
    private static final String PASS = "admin";

    static {
        try {
            Class.forName("org.firebirdsql.jdbc.FBDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Не найден драйвер Firebird", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }
}
