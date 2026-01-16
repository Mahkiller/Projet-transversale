<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="chauss.Shoe" %>
<%@ page import="chauss.ShoeData" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chaussures</title>
    <link rel="stylesheet" href="/Chaussures/css/listShoes.css">
</head>
<body>
    <header>
        <h1>Chaussures</h1>
        <a href="/Chaussures/addModele" class="add-btn">Ajouter un Modèle</a>
    </header>

    <div class="container">
        <form class="search-form" action="/Chaussures/shoes" method="get">
            <div class="form-group">
                <label for="brand">Marque</label>
                <input type="text" id="brand" name="brand" 
                       value="<%= request.getParameter("brand") != null ? request.getParameter("brand") : "" %>" 
                       placeholder="Ex: Nike">
            </div>

            <div class="form-group">
                <label for="size">Taille</label>
                <input type="number" id="size" name="size" 
                       value="<%= request.getParameter("size") != null ? request.getParameter("size") : "" %>" 
                       placeholder="Ex: 42">
            </div>

            <div class="form-group">
                <label for="color">Couleur</label>
                <input type="text" id="color" name="color" 
                       value="<%= request.getParameter("color") != null ? request.getParameter("color") : "" %>" 
                       placeholder="Ex: Noir">
            </div>

            <div class="form-group">
                <label for="type">Type</label>
                <input type="text" id="type" name="type" 
                       value="<%= request.getParameter("type") != null ? request.getParameter("type") : "" %>" 
                       placeholder="Ex: Sneakers">
            </div>

            <button type="submit" class="search-btn">Rechercher</button>
        </form>

        <%
            List<Shoe> shoes = (List<Shoe>) request.getAttribute("shoes");
            if (shoes == null || shoes.isEmpty()) {
                try { 
                    shoes = ShoeData.getAllShoes(); 
                } catch(Exception ex) { 
                    shoes = new java.util.ArrayList<Shoe>(); 
                }
            }
            
            if (shoes != null && !shoes.isEmpty()) {
                // Grouper par marque
                Map<String, List<Shoe>> shoesByBrand = new HashMap<>();
                for (Shoe shoe : shoes) {
                    String brand = shoe.getBrand() != null ? shoe.getBrand() : "Autres";
                    if (!shoesByBrand.containsKey(brand)) {
                        shoesByBrand.put(brand, new java.util.ArrayList<Shoe>());
                    }
                    shoesByBrand.get(brand).add(shoe);
                }
                
                // Afficher chaque marque
                for (Map.Entry<String, List<Shoe>> entry : shoesByBrand.entrySet()) {
        %>
        <section class="brand-section">
            <h2 class="brand-title"><%= entry.getKey() %></h2>
            <div class="brand-scroll">
                <%
                    for (Shoe sh : entry.getValue()) {
                        boolean inStock = sh.getStock() > 0;
                %>
                <div class="shoe-item">
                    <a class="card-link" href="/Chaussures/pages/product.jsp?id=<%= sh.getId() %>">
                        <div class="shoe-image">
                            <img src="/Chaussures/images/<%= (sh.getImage()!=null && !sh.getImage().isEmpty())? sh.getImage() : "placeholder.jpg" %>" 
                                 alt="<%= sh.getName() != null ? sh.getName() : "Chaussure" %>">
                            <div class="stock-badge <%= inStock ? "" : "out" %>">
                                <%= inStock ? "En stock" : "Rupture" %>
                            </div>
                        </div>
                        
                        <div class="shoe-content">
                            <h2><%= sh.getName() != null ? sh.getName() : "Produit" %></h2>
                            
                            <div class="shoe-details">
                                <div class="shoe-detail">
                                    <span class="shoe-detail-label">Marque:</span>
                                    <span class="shoe-detail-value"><%= sh.getBrand() != null ? sh.getBrand() : "—" %></span>
                                </div>
                                <div class="shoe-detail">
                                    <span class="shoe-detail-label">Type:</span>
                                    <span class="shoe-detail-value"><%= sh.getType() != null ? sh.getType() : "—" %></span>
                                </div>
                                <div class="shoe-detail">
                                    <span class="shoe-detail-label">Stock:</span>
                                    <span class="shoe-detail-value">
                                        <%= sh.getStock() %> unités
                                    </span>
                                </div>
                            </div>
                            
                            <div class="add-cart-section">
                                <div class="shoe-price"><%= String.format("%.2f", sh.getPrice()) %> €</div>
                                <form action="/Chaussures/cart" method="post" style="margin: 0;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="id" value="<%= sh.getId() %>">
                                    <input type="hidden" name="qty" value="1">
                                    <button type="submit" class="add-cart-btn" <%= inStock ? "" : "disabled" %>>
                                        Ajouter
                                    </button>
                                </form>
                            </div>
                            
                            <% if (sh.getDescription() != null && !sh.getDescription().isEmpty()) { %>
                                <p class="shoe-description"><%= sh.getDescription() %></p>
                            <% } %>
                        </div>
                    </a>
                </div>
                <%
                    }
                %>
            </div>
        </section>
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
</body>
</html>