<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Connexion - Client</title>
    <link rel="stylesheet" href="/Chaussures/css/loginClient.css">
</head>
<body>
  <main class="login-wrap">
    <form class="login-form" action="/Chaussures/loginClient" method="post">
      <h1>Connexion Client</h1>
      <label>Email
        <input type="email" name="email" placeholder="vous@exemple.com" required>
      </label>
      <label>Mot de passe
        <input type="password" name="password" required>
      </label>
      <button type="submit">Se connecter</button>
      <% String err = (String) request.getAttribute("error"); if(err!=null){ %>
        <div class="error"><%= err %></div>
      <% } %>
      <p class="muted">Pas encore de compte ? Contactez le support.</p>
    </form>
  </main>
</body>
</html>
