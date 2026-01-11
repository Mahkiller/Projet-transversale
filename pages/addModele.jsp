<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ajouter un Modèle de Chaussure</title>
    <link rel="stylesheet" href="/Chaussures/css/style.css">
    <script>
        function validateForm() {
            const description = document.getElementById('description').value;
            if (description.length > 500) {
                alert('Description trop longue (max 500 caractères)');
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <header>
        <h1>Ajouter un Modèle de Chaussure</h1>
    </header>

    <div class="container">
        <div style="max-width: 600px; margin: 0 auto;">
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
                <div style="color: red; margin-bottom: 20px;"><%= error %></div>
            <% } %>

            <form action="addModele" method="post" onsubmit="return validateForm()" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="modele">Modèle *</label>
                    <input type="text" id="modele" name="modele" required>
                </div>

                <div class="form-group">
                    <label for="marque">Marque *</label>
                    <select id="marque" name="marque" required>
                        <option value="">Sélectionner</option>
                        <% List<String> marques = (List<String>) request.getAttribute("marques");
                           if (marques != null) for (String m : marques) { %>
                            <option value="<%= m %>"><%= m %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="type">Type *</label>
                    <select id="type" name="type" required>
                        <option value="">Sélectionner</option>
                        <% List<String> types = (List<String>) request.getAttribute("types");
                           if (types != null) for (String t : types) { %>
                            <option value="<%= t %>"><%= t %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="genre">Genre *</label>
                    <select id="genre" name="genre" required>
                        <option value="">Sélectionner</option>
                        <% List<String> genres = (List<String>) request.getAttribute("genres");
                           if (genres != null) for (String g : genres) { %>
                            <option value="<%= g %>"><%= g %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="trancheAge">Tranche d'âge *</label>
                    <select id="trancheAge" name="trancheAge" required>
                        <option value="">Sélectionner</option>
                        <% List<String> tranches = (List<String>) request.getAttribute("tranches");
                           if (tranches != null) for (String tr : tranches) { %>
                            <option value="<%= tr %>"><%= tr %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="couleur">Couleur *</label>
                    <select id="couleur" name="couleur" required>
                        <option value="">Sélectionner</option>
                        <% List<String> couleurs = (List<String>) request.getAttribute("couleurs");
                           if (couleurs != null) for (String c : couleurs) { %>
                            <option value="<%= c %>"><%= c %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="pointure">Pointure *</label>
                    <select id="pointure" name="pointure" required>
                        <option value="">Sélectionner</option>
                        <% List<String> pointures = (List<String>) request.getAttribute("pointures");
                           if (pointures != null) for (String p : pointures) { %>
                            <option value="<%= p %>"><%= p %></option>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label for="prix">Prix (€) *</label>
                    <input type="number" id="prix" name="prix" step="0.01" min="0" required>
                </div>

                <div class="form-group">
                    <label for="imageFile">Image (sélectionnez un fichier) *</label>
                    <input type="file" id="imageFile" name="imageFile" accept="image/*" required onchange="onImageSelected(event)">
                    <div id="imagePreview" style="margin-top:10px; display:none;">
                        <img id="previewImg" src="#" alt="prévisualisation" style="max-width:200px; max-height:200px; border-radius:8px; box-shadow:0 4px 12px rgba(0,0,0,0.08)">
                        <div style="margin-top:6px; font-size:0.9em; color:#555;">Le fichier sera automatiquement renommé et publié.</div>
                    </div>
                    <!-- fallback text field preserved for compatibility -->
                    <input type="hidden" id="image" name="image">
                </div>

                <div class="form-group">
                    <label for="quantite">Quantité initiale *</label>
                    <input type="number" id="quantite" name="quantite" min="0" required>
                </div>

                <div style="margin-top: 20px; display:flex; gap:10px; align-items:center;">
                    <button type="submit" id="submitBtn" class="search-btn">Soumettre</button>
                    <a href="shoes" style="margin-left: 10px; color: #007bff;">Annuler</a>
                </div>
            </form>
        </div>
    </div>
    <script>
        function onImageSelected(e) {
            const file = e.target.files[0];
            if (!file) return;
            const preview = document.getElementById('imagePreview');
            const img = document.getElementById('previewImg');
            img.src = URL.createObjectURL(file);
            preview.style.display = 'block';

            // Auto-generate filename from model + brand + color when possible
            const modele = (document.getElementById('modele')||{}).value || '';
            const marque = (document.getElementById('marque')||{}).value || '';
            const couleur = (document.getElementById('couleur')||{}).value || '';
            const base = (modele + '_' + marque + '_' + couleur).trim().toLowerCase();
            // simple normalization: replace spaces and non-alphanum -> underscore
            const norm = base.replace(/[^a-z0-9]+/g, '_').replace(/^_+|_+$/g, '');
            const filename = norm ? norm + '.jpg' : file.name.replace(/\s+/g,'_');
            document.getElementById('image').value = filename;

            // Auto-submit after short delay to allow preview to render
            setTimeout(()=>{
                // if user explicitly wants to submit manually, they can click submit;
                // otherwise submit automatically to publish the model right away
                document.getElementById('submitBtn').disabled = true;
                document.forms[0].submit();
            }, 900);
        }
    </script>
</body>
</html>