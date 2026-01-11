package chauss;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShoeData {

    public static List<Shoe> getAllShoes() {
        return searchShoes(null, null, null, null);
    }

    public static List<Shoe> searchShoes(String brand, Integer size, String color, String type) {
        List<Shoe> result = new ArrayList<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT c.id, m.modele, mar.marque, t.type, col.nom as couleur, p.valeur as pointure, c.prix, mc.description, c.image " +
                         "FROM t_chaussure c " +
                         "JOIN t_modele_chaussure mc ON c.idChaussure = mc.id " +
                         "JOIN t_modele m ON mc.idModele = m.id " +
                         "JOIN t_marque mar ON mc.idMarque = mar.id " +
                         "JOIN t_type t ON mc.idType = t.id " +
                         "JOIN t_couleur col ON c.idCouleur = col.id " +
                         "JOIN t_pointure p ON c.idPointure = p.id " +
                         "WHERE (? IS NULL OR mar.marque ILIKE ?) " +
                         "AND (? IS NULL OR p.valeur = ?) " +
                         "AND (? IS NULL OR col.nom ILIKE ?) " +
                         "AND (? IS NULL OR t.type ILIKE ?)";

            stmt = conn.prepareStatement(sql);
            // Bind brand params
            if (brand != null) {
                stmt.setString(1, brand);
                stmt.setString(2, "%" + brand + "%");
            } else {
                stmt.setNull(1, java.sql.Types.VARCHAR);
                stmt.setNull(2, java.sql.Types.VARCHAR);
            }
            // Bind size (numeric) params
            if (size != null) {
                stmt.setInt(3, size);
                stmt.setInt(4, size);
            } else {
                stmt.setNull(3, java.sql.Types.NUMERIC);
                stmt.setNull(4, java.sql.Types.NUMERIC);
            }
            // Bind color params
            if (color != null) {
                stmt.setString(5, color);
                stmt.setString(6, "%" + color + "%");
            } else {
                stmt.setNull(5, java.sql.Types.VARCHAR);
                stmt.setNull(6, java.sql.Types.VARCHAR);
            }
            // Bind type params
            if (type != null) {
                stmt.setString(7, type);
                stmt.setString(8, "%" + type + "%");
            } else {
                stmt.setNull(7, java.sql.Types.VARCHAR);
                stmt.setNull(8, java.sql.Types.VARCHAR);
            }

            rs = stmt.executeQuery();
            while (rs.next()) {
                Shoe shoe = new Shoe(
                    rs.getInt("id"),
                    rs.getString("modele"),
                    rs.getString("marque"),
                    rs.getInt("pointure"), // assuming int
                    rs.getString("couleur"),
                    rs.getString("type"),
                    rs.getDouble("prix"),
                    rs.getString("description"),
                    rs.getString("image")
                );
                result.add(shoe);
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
        return result;
    }
}