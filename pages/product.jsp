<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="chauss.Shoe" %>
<%@ page import="chauss.ShoeData" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiche produit - Chaussure</title>
    <link rel="stylesheet" href="/Chaussures/css/product.css">
    <style>
        .product-wrap{max-width:1100px;margin:28px auto;padding:18px;display:grid;grid-template-columns:1fr 1fr;gap:24px}
        .product-gallery{border-radius:12px;overflow:hidden}
        .product-gallery img{width:100%;height:480px;object-fit:cover}
        .product-info h1{margin:0 0 8px}
        .product-info .price{font-size:1.6rem;color:#2e7d61;font-weight:800;margin:8px 0}
        .sizes{display:flex;gap:8px;flex-wrap:wrap;margin:10px 0}
        .sizes button{padding:8px 10px;border-radius:8px;border:1px solid #ddd;background:#fff;cursor:pointer}
        .reviews{margin-top:18px}
        .related{margin-top:20px}
        @media(max-width:900px){.product-wrap{grid-template-columns:1fr}}
    </style>
</head>
<body>
    <header>
        <h1>Chaussures</h1>
        <a href="/Chaussures/pages/listShoes.jsp" class="add-btn">Retour</a>
    </header>
    <div class="container">
        <%
            String idParam = request.getParameter("id");
            int id = 0;
            try { id = Integer.parseInt(idParam); } catch(Exception ex) { id = 0; }
            Shoe prod = null;
            if(id > 0) prod = ShoeData.getShoeById(id);
            if(prod == null && id>0) prod = ShoeData.getShoeDemoFallback(id);
            if(prod == null){ %>
                <div class="no-results"><p>Produit introuvable.</p></div>
            <% } else { %>
        <div id="product" class="product-wrap">
            <div class="product-gallery">
                <div class="img-wrap"><img src="/Chaussures/images/<%= (prod.getImage()!=null && !prod.getImage().isEmpty()) ? prod.getImage() : "placeholder.jpg" %>" alt="<%= prod.getName() != null ? prod.getName() : "Chaussure" %>"></div>
            </div>
            <div class="product-info">
                <h1 id="prodName"><%= prod.getName() %></h1>
                <div class="meta" id="prodMeta"><%= prod.getBrand() %> • <%= prod.getType() %></div>
                <div class="price" id="prodPrice"><%= String.format("%.2f", prod.getPrice()) %> €</div>
                <p id="prodDesc"><%= prod.getDescription() %></p>
                <form action="/Chaussures/cart" method="post" style="margin-top:12px">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="id" value="<%= prod.getId() %>">
                    <label>Quantité <input type="number" name="qty" value="1" min="1" style="width:72px;padding:6px;margin-left:6px"></label>
                    <button style="margin-left:12px;padding:8px 12px;background:#0f6fff;color:#fff;border:none;border-radius:8px" type="submit">Ajouter au panier</button>
                </form>
                <div class="product-stock"><%= (prod.getStock()>0) ? ("En stock: " + prod.getStock()) : "Rupture de stock" %></div>
                <label>Tailles (exemple)</label>
                <div id="prodSizes" class="sizes">
                    <button><%= prod.getSize() %></button>
                </div>
                <div class="reviews" id="prodReviews">
                    <h3>Aperçu du stock</h3>
                    <p><%= (prod.getStock()>0) ? ("En stock: " + prod.getStock()) : "Rupture de stock" %></p>
                </div>
                <div class="related" id="prodRelated"></div>
            </div>
        </div>
        <% } %>
    </div>
</body>
</html>
