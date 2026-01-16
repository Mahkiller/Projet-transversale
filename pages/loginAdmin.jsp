<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Connexion - Admin</title>
    <link rel="stylesheet" href="/Chaussures/css/loginAdmin.css">
</head>
<body>
  <main class="admin-login-wrap">
    <form class="admin-login-form" action="/Chaussures/loginAdmin" method="post">
      <h1>Administration</h1>
      <label>Email
        <input type="email" name="email" placeholder="admin@exemple.com" required>
      </label>
      <label>Mot de passe
        <input type="password" name="password" required>
      </label>
      <div class="actions">
        <button class="primary" type="submit">Se connecter</button>
        <a class="cancel" href="/Chaussures/pages/listShoes.jsp">Retour</a>
      </div>
      <% String err = (String) request.getAttribute("error"); if(err!=null){ %>
        <div class="error"><%= err %></div>
      <% } %>
    </form>
  </main>
</body>
</html>
