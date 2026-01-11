<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="chauss.Shoe" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chaussures - Liste des Chaussures</title>
    <link rel="stylesheet" href="/Chaussures/css/style.css">
</head>
<body>
    <header>
        <h1>Chaussures</h1>
        <a href="/Chaussures/addModele" class="add-btn">Ajouter un Modèle</a>
    </header>

    <div class="container">
        <form class="search-form" action="shoes" method="get">
            <div class="form-group">
                <label for="brand">Marque</label>
                <input type="text" id="brand" name="brand" value="<%= request.getParameter("brand") != null ? request.getParameter("brand") : "" %>" placeholder="Ex: Nike">
            </div>

            <div class="form-group">
                <label for="size">Taille</label>
                <input type="number" id="size" name="size" value="<%= request.getParameter("size") != null ? request.getParameter("size") : "" %>" placeholder="Ex: 42">
            </div>

            <div class="form-group">
                <label for="color">Couleur</label>
                <input type="text" id="color" name="color" value="<%= request.getParameter("color") != null ? request.getParameter("color") : "" %>" placeholder="Ex: Noir">
            </div>

            <div class="form-group">
                <label for="type">Type</label>
                <input type="text" id="type" name="type" value="<%= request.getParameter("type") != null ? request.getParameter("type") : "" %>" placeholder="Ex: Sneakers">
            </div>

            <button type="submit" class="search-btn">Rechercher</button>
        </form>

        <div class="shoe-list">
            <%
                List<Shoe> shoes = (List<Shoe>) request.getAttribute("shoes");
                if (shoes != null && !shoes.isEmpty()) {
                    for (Shoe shoe : shoes) {
            %>
            <div class="shoe-item">
                <div class="shoe-image">
                    <img src="/Chaussures/images/<%= shoe.getImage() %>" alt="<%= shoe.getName() %>" width="200" height="150" style="object-fit: cover; border-radius: 8px;">
                </div>
                <div class="shoe-content">
                    <h2><%= shoe.getName() %></h2>
                    <div class="shoe-details">
                        <div class="shoe-detail">
                            <span class="shoe-detail-label">Marque</span>
                            <span class="shoe-detail-value"><%= shoe.getBrand() %></span>
                        </div>
                        <div class="shoe-detail">
                            <span class="shoe-detail-label">Taille</span>
                            <span class="shoe-detail-value"><%= shoe.getSize() %></span>
                        </div>
                        <div class="shoe-detail">
                            <span class="shoe-detail-label">Couleur</span>
                            <span class="shoe-detail-value"><%= shoe.getColor() %></span>
                        </div>
                        <div class="shoe-detail">
                            <span class="shoe-detail-label">Type</span>
                            <span class="shoe-detail-value"><%= shoe.getType() %></span>
                        </div>
                    </div>
                    <div class="shoe-price"><%= String.format("%.2f", shoe.getPrice()) %> €</div>
                    <p class="shoe-description"><%= shoe.getDescription() %></p>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="no-results">
                <p>Aucune chaussure trouvée pour ces critères.</p>
            </div>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>