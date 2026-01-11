package chauss;

import java.sql.*;

public class ModeleChaussureDAO {
    public static boolean insert(int idGenre, int idMarque, int idType, int idModele, int idTrancheAge, String description, String image) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            conn = DBUtil.getConnection();
            stmt = conn.prepareStatement("INSERT INTO t_modele_chaussure (idGenre, idMarque, idType, idModele, idTrancheAge, description) VALUES (?, ?, ?, ?, ?, ?)");
            stmt.setInt(1, idGenre);
            stmt.setInt(2, idMarque);
            stmt.setInt(3, idType);
            stmt.setInt(4, idModele);
            stmt.setInt(5, idTrancheAge);
            stmt.setString(6, description);
            // Note: image not in table, perhaps store filename separately or add to table
            int rows = stmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // Insert and return the generated id of t_modele_chaussure, or -1 on error
    public static int insertAndGetId(int idGenre, int idMarque, int idType, int idModele, int idTrancheAge, String description) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            // Use RETURNING id for PostgreSQL
            stmt = conn.prepareStatement("INSERT INTO t_modele_chaussure (idGenre, idMarque, idType, idModele, idTrancheAge, description) VALUES (?, ?, ?, ?, ?, ?) RETURNING id");
            stmt.setInt(1, idGenre);
            stmt.setInt(2, idMarque);
            stmt.setInt(3, idType);
            stmt.setInt(4, idModele);
            stmt.setInt(5, idTrancheAge);
            stmt.setString(6, description);
            rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}