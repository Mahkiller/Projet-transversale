package chauss;

import java.sql.*;

public class DBUtil {
    private static final String URL = "jdbc:postgresql://localhost:5432/madb";
    private static final String USER = "mah";
    private static final String PASSWORD = "mahery"; 

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL Driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}