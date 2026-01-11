package chauss;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 20 * 1024 * 1024)
public class AddModeleServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Load data for dropdowns
        List<String> genres = GenreDAO.getAll();
        List<String> marques = MarqueDAO.getAll();
        List<String> types = TypeDAO.getAll();
        List<String> tranches = TrancheAgeDAO.getAll();
        List<String> couleurs = CouleurDAO.getAll();
        List<String> pointures = PointureDAO.getAll();

        request.setAttribute("genres", genres);
        request.setAttribute("marques", marques);
        request.setAttribute("types", types);
        request.setAttribute("tranches", tranches);
        request.setAttribute("couleurs", couleurs);
        request.setAttribute("pointures", pointures);

        request.getRequestDispatcher("/pages/addModele.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle form submission with optional file upload
        String modele = request.getParameter("modele");
        String marque = request.getParameter("marque");
        String type = request.getParameter("type");
        String genre = request.getParameter("genre");
        String trancheAge = request.getParameter("trancheAge");
        String couleur = request.getParameter("couleur");
        String pointure = request.getParameter("pointure");
        String prixStr = request.getParameter("prix");
        String imageField = request.getParameter("image"); // generated filename from client
        String quantiteStr = request.getParameter("quantite");

        String error = null;
        double prix = 0;
        int quantite = 0;
        try {
            prix = Double.parseDouble(prixStr);
            quantite = Integer.parseInt(quantiteStr);
        } catch (Exception e) {
            error = "Prix ou quantité invalide";
        }
        if (modele == null || modele.isEmpty()) error = "Modèle requis";
        else if (marque == null || marque.isEmpty()) error = "Marque requise";
        else if (type == null || type.isEmpty()) error = "Type requis";
        else if (genre == null || genre.isEmpty()) error = "Genre requis";
        else if (trancheAge == null || trancheAge.isEmpty()) error = "Tranche d'âge requise";
        else if (couleur == null || couleur.isEmpty()) error = "Couleur requise";
        else if (pointure == null || pointure.isEmpty()) error = "Pointure requise";

        if (error != null) {
            request.setAttribute("error", error);
            doGet(request, response);
            return;
        }

        // Normalize and sanitize filename, then move uploaded file if provided
        Part filePart = null;
        try {
            filePart = request.getPart("imageFile");
        } catch (IllegalStateException | IOException | ServletException ex) {
            filePart = null;
        }

        String finalImageFilename = null;

        if (filePart != null && filePart.getSize() > 0) {
            // Generate filename base: modele_marque_couleur
            String base = (modele + "_" + marque + "_" + couleur).toLowerCase();
            finalImageFilename = normalizeFilename(base);
            if (!finalImageFilename.endsWith(".jpg") && !finalImageFilename.endsWith(".png") && !finalImageFilename.endsWith(".jpeg")) {
                finalImageFilename = finalImageFilename + ".jpg";
            }

            // correct common typos
            finalImageFilename = correctCommonTypos(finalImageFilename);

            // Ensure images folder exists
            String imagesPath = getServletContext().getRealPath("/images");
            File imagesDir = new File(imagesPath);
            if (!imagesDir.exists()) imagesDir.mkdirs();

            // Ensure unique name to avoid conflicts
            File dest = new File(imagesDir, finalImageFilename);
            String nameOnly = finalImageFilename;
            int counter = 1;
            while (dest.exists()) {
                int dot = finalImageFilename.lastIndexOf('.');
                String name = finalImageFilename.substring(0, dot);
                String ext = finalImageFilename.substring(dot);
                nameOnly = name + "_" + counter + ext;
                dest = new File(imagesDir, nameOnly);
                counter++;
            }
            finalImageFilename = dest.getName();

            // Move file
            try (InputStream in = filePart.getInputStream()) {
                Path target = dest.toPath();
                Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                e.printStackTrace();
                request.setAttribute("error", "Impossible d'enregistrer l'image");
                doGet(request, response);
                return;
            }
        } else if (imageField != null && !imageField.trim().isEmpty()) {
            finalImageFilename = normalizeFilename(imageField);
            finalImageFilename = correctCommonTypos(finalImageFilename);
            if (!finalImageFilename.endsWith(".jpg") && !finalImageFilename.endsWith(".png") && !finalImageFilename.endsWith(".jpeg")) {
                finalImageFilename += ".jpg";
            }
            // Note: no file was uploaded, so the admin must ensure the file exists in images/
        } else {
            request.setAttribute("error", "Image requise");
            doGet(request, response);
            return;
        }

        // Get IDs
        int idGenre = GenreDAO.getIdByName(genre);
        int idMarque = MarqueDAO.getIdByName(marque);
        int idType = TypeDAO.getIdByName(type);
        int idTrancheAge = TrancheAgeDAO.getIdByName(trancheAge);
        int idCouleur = CouleurDAO.getIdByName(couleur);
        int idPointure = PointureDAO.getIdByName(pointure);

        if (idGenre == -1 || idMarque == -1 || idType == -1 || idTrancheAge == -1 || idCouleur == -1 || idPointure == -1) {
            request.setAttribute("error", "Valeur invalide");
            doGet(request, response);
            return;
        }

        // Insert modele if not exists
        ModeleDAO.insertIfNotExists(modele);
        int idModele = ModeleDAO.getIdByName(modele);

        // Insert modele_chaussure and get its id
        int modeleChaussureId = ModeleChaussureDAO.insertAndGetId(idGenre, idMarque, idType, idModele, idTrancheAge, "");
        if (modeleChaussureId == -1) {
            request.setAttribute("error", "Erreur d'insertion du modèle");
            doGet(request, response);
            return;
        }

        // Insert into t_chaussure and get generated id
        int chaussureId = -1;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pst = conn.prepareStatement("INSERT INTO t_chaussure (idChaussure, idCouleur, idPointure, image, prix) VALUES (?, ?, ?, ?, ?) RETURNING id");
            pst.setInt(1, modeleChaussureId);
            pst.setInt(2, idCouleur);
            pst.setInt(3, idPointure);
            pst.setString(4, finalImageFilename);
            pst.setDouble(5, prix);
            rs = pst.executeQuery();
            if (rs.next()) chaussureId = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); if (pst != null) pst.close(); if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }

        if (chaussureId == -1) {
            request.setAttribute("error", "Erreur lors de l'ajout de la chaussure");
            doGet(request, response);
            return;
        }

        // Insert stock entry
        try (Connection c2 = DBUtil.getConnection(); PreparedStatement s2 = c2.prepareStatement("INSERT INTO t_stock (idChaussure, quantite) VALUES (?, ?)") ) {
            s2.setInt(1, chaussureId);
            s2.setInt(2, quantite);
            s2.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("shoes");
    }

    private String normalizeFilename(String raw) {
        if (raw == null) return "image.jpg";
        String s = raw.trim().toLowerCase();
        s = s.replaceAll("\\s+", "_");
        s = s.replaceAll("[^a-z0-9_\\.-]", "_");
        // collapse multiple underscores
        s = s.replaceAll("_+", "_");
        // ensure extension
        if (!s.endsWith(".jpg") && !s.endsWith(".png") && !s.endsWith(".jpeg")) {
            s = s + ".jpg";
        }
        return s;
    }

    private String correctCommonTypos(String s) {
        if (s == null) return null;
        // simple map of typos
        s = s.replaceAll("doncin", "doncic");
        s = s.replaceAll("doncinic", "doncic");
        return s;
    }
}