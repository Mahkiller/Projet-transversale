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
            String sql = "SELECT c.id, m.modele, mar.marque, t.type, col.nom as couleur, p.valeur as pointure, c.prix, mc.description, c.image, COALESCE(s.quantite,0) as stock " +
                         "FROM t_chaussure c " +
                         "JOIN t_modele_chaussure mc ON c.idChaussure = mc.id " +
                         "JOIN t_modele m ON mc.idModele = m.id " +
                         "JOIN t_marque mar ON mc.idMarque = mar.id " +
                         "JOIN t_type t ON mc.idType = t.id " +
                         "JOIN t_couleur col ON c.idCouleur = col.id " +
                         "JOIN t_pointure p ON c.idPointure = p.id " +
                         "LEFT JOIN t_stock s ON c.id = s.idChaussure " +
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
                    try { shoe.setStock(rs.getInt("stock")); } catch(Exception ex) { shoe.setStock(0); }
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
        if(result.isEmpty()){
            return demoData();
        }
        return result;
    }


    // If DB is unavailable or returns no results, provide fallback demo data
    static {
        // no-op static block to keep class loader happy
    }

    private static List<Shoe> demoData(){
        List<Shoe> demo = new ArrayList<>();
        Shoe s1 = new Shoe(1,"AirMax Classic","Nike",42,"Noir","Sport",120.00,"AirMax classique, amorti optimal.","airmax_nike_noir.jpg");
        s1.setStock(20);
        Shoe s2 = new Shoe(2,"AirForce Street","Nike",41,"Blanc","Ville",110.00,"Design rétro urbain.","airforce_nike_blanc.jpg");
        s2.setStock(15);
        Shoe s3 = new Shoe(3,"Ultraboost Comfort","Adidas",43,"Bleu","Running",150.00,"Semelle réactive.","ultraboost_adidas_noir.jpg");
        s3.setStock(25);
        demo.add(s1); demo.add(s2); demo.add(s3);
        return demo;
    }

    public static Shoe getShoeById(int idChaussure){
        Shoe shoe = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try{
            conn = DBUtil.getConnection();
            String sql = "SELECT c.id, m.modele, mar.marque, t.type, col.nom as couleur, p.valeur as pointure, c.prix, mc.description, c.image, COALESCE(s.quantite,0) as stock " +
                         "FROM t_chaussure c " +
                         "JOIN t_modele_chaussure mc ON c.idChaussure = mc.id " +
                         "JOIN t_modele m ON mc.idModele = m.id " +
                         "JOIN t_marque mar ON mc.idMarque = mar.id " +
                         "JOIN t_type t ON mc.idType = t.id " +
                         "JOIN t_couleur col ON c.idCouleur = col.id " +
                         "JOIN t_pointure p ON c.idPointure = p.id " +
                         "LEFT JOIN t_stock s ON c.id = s.idChaussure " +
                         "WHERE c.id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, idChaussure);
            rs = stmt.executeQuery();
            if(rs.next()){
                shoe = new Shoe(
                    rs.getInt("id"),
                    rs.getString("modele"),
                    rs.getString("marque"),
                    rs.getInt("pointure"),
                    rs.getString("couleur"),
                    rs.getString("type"),
                    rs.getDouble("prix"),
                    rs.getString("description"),
                    rs.getString("image")
                );
                shoe.setStock(rs.getInt("stock"));
            }
        }catch(SQLException e){ e.printStackTrace(); }
        finally{ try{ if(rs!=null) rs.close(); if(stmt!=null) stmt.close(); if(conn!=null) conn.close(); }catch(SQLException e){ e.printStackTrace(); } }
        return shoe;
    }

    // If DB fetch fails or returns null, try demo data
    public static Shoe getShoeDemoFallback(int id){
        for(Shoe s : demoData()) if(s.getId() == id) return s;
        return null;
    }
}