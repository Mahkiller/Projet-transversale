package chauss;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ModeleDAO {
    public static List<String> getAll() {
        List<String> list = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT modele FROM t_modele ORDER BY modele");
            while (rs.next()) {
                list.add(rs.getString("modele"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return list;
    }

    public static int getIdByName(String modele) {
        int id = -1;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            stmt = conn.prepareStatement("SELECT id FROM t_modele WHERE modele = ?");
            stmt.setString(1, modele);
            rs = stmt.executeQuery();
            if (rs.next()) {
                id = rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return id;
    }

    public static void insertIfNotExists(String modele) {
        if (getIdByName(modele) == -1) {
            Connection conn = null;
            PreparedStatement stmt = null;
            try {
                conn = DBUtil.getConnection();
                stmt = conn.prepareStatement("INSERT INTO t_modele (modele) VALUES (?)");
                stmt.setString(1, modele);
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}