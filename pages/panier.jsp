<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="chauss.Shoe" %>
<%@ page import="chauss.ShoeData" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Panier</title>
  <link rel="stylesheet" href="/Chaussures/css/listShoes.css">
  <link rel="stylesheet" href="/Chaussures/css/panier.css">
  <style>.cart-actions{display:flex;gap:8px;margin-top:12px}.totals{margin-top:18px;padding:14px;background:#fff;border-radius:10px}</style>
</head>
<body>
  <div class="container">
    <header><h1>Votre panier</h1><a class="add-btn" href="/Chaussures/pages/listShoes.jsp">Continuer vos achats</a></header>
    <%
      @SuppressWarnings("unchecked")
      Map<Integer,Integer> cart = (Map<Integer,Integer>) session.getAttribute("cart");
      if(cart == null || cart.isEmpty()){ %>
        <div class="no-results"><p>Votre panier est vide.</p></div>
      <% } else {
          double subtotal = 0.0;
          int totalItems = 0;
          java.util.Map<Integer, Double> lineAmount = new java.util.HashMap<>();

          // first pass: compute line amounts
          for(Integer id : cart.keySet()){
              Shoe s = ShoeData.getShoeById(id);
              if(s==null) continue;
              int qty = cart.get(id);
              double amt = s.getPrice() * qty;
              lineAmount.put(id, amt);
              subtotal += amt;
              totalItems += qty;
          }

          // compute after-item discounts per line
          java.util.Map<Integer, Double> afterBrandLine = new java.util.HashMap<>();
          double afterBrandTotal = 0.0;
          for(Integer id : lineAmount.keySet()){
              double amt = lineAmount.get(id);
              int qty = cart.get(id);
              if(qty >= 2){ amt = amt * 0.90; } // 10% off for qty >=2
              afterBrandLine.put(id, amt);
              afterBrandTotal += amt;
          }

          double bulkDiscount = (totalItems >= 5) ? (afterBrandTotal * 0.20) : 0.0;

          double totalWithRemise = afterBrandTotal - bulkDiscount;
          double brandTotalDiscount = subtotal - afterBrandTotal;

    %>

    <style>
      .cart-table{width:100%;border-collapse:collapse;background:#fff;border-radius:8px;overflow:hidden}
      .cart-table th,.cart-table td{padding:12px 10px;border-bottom:1px solid #eef2f6;text-align:right}
      .cart-table th{background:#f8fafb;text-align:left;color:#334e4b}
      .cart-table td.name{ text-align:left }
    </style>

    <table class="cart-table">
      <thead>
        <tr>
          <th>Chaussure</th>
          <th>Quantité</th>
          <th>Montant (sans remise)</th>
          <th>Montant (avec remise)</th>
          <th>Actions</th>
        </tr>
      </thead>
      <tbody>
      <%
        for(Integer id : cart.keySet()){
            Shoe s = ShoeData.getShoeById(id);
            if(s==null) continue;
            int qty = cart.get(id);
            double amtBefore = lineAmount.get(id);
            double amtAfterBrand = afterBrandLine.get(id);
            // apply proportional part of bulk discount
            double bulkShare = (afterBrandTotal>0) ? (amtAfterBrand / afterBrandTotal) * bulkDiscount : 0.0;
            double amtAfterAll = amtAfterBrand - bulkShare;
      %>
        <tr>
          <td class="name"><%= s.getName() %> <span class="brand">(<%= s.getBrand()!=null? s.getBrand():"" %>)</span></td>
          <td><%= qty %></td>
          <td><%= String.format("%.2f €", amtBefore) %></td>
          <td><%= String.format("%.2f €", amtAfterAll) %></td>
        </tr>
      <%
        }
      %>
      </tbody>
      <tfoot>
        <tr>
          <th colspan="2">Total</th>
          <th><%= String.format("%.2f €", subtotal) %></th>
          <th><%= String.format("%.2f €", totalWithRemise) %></th>
        </tr>
      </tfoot>
    </table>

    <div class="totals" style="margin-top:12px">
      <div>Remise quantité par article: <strong><%= String.format("%.2f €", brandTotalDiscount) %></strong></div>
      <div>Remise quantité (bulk): <strong>- <%= String.format("%.2f €", bulkDiscount) %></strong></div>
      <div style="margin-top:10px"><form action="/Chaussures/cart" method="post" style="display:inline"><input type="hidden" name="action" value="clear"><button type="submit">Vider le panier</button></form></div>
    </div>

    <% } %>
  </div>
</body>
</html>
