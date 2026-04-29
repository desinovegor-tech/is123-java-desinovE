<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Вход — Avito Mini</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
        }
        .page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card {
            background: #fff;
            border-radius: 8px;
            padding: 30px 40px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            width: 360px;
            max-width: 90%;
        }
        .logo {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 20px;
            color: #2c2c2c;
        }
        .logo span {
            color: #6c2cff;
        }
        h1 {
            font-size: 20px;
            margin: 0 0 20px;
        }
        label {
            display: block;
            font-size: 13px;
            margin-bottom: 6px;
            color: #555;
        }
        input[type="text"],
        input[type="password"] {
            width: 100%;
            box-sizing: border-box;
            padding: 9px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
            margin-bottom: 14px;
        }
        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: #6c2cff;
            box-shadow: 0 0 0 1px rgba(108,44,255,0.15);
        }
        .btn-primary {
            width: 100%;
            border: none;
            border-radius: 6px;
            padding: 10px 0;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            background: #6c2cff;
            color: #fff;
            margin-top: 5px;
        }
        .btn-primary:hover {
            background: #5a22e0;
        }
        .error {
            background: #ffe6e6;
            border: 1px solid #ffb3b3;
            color: #b30000;
            padding: 8px 10px;
            border-radius: 6px;
            font-size: 13px;
            margin-bottom: 15px;
        }
        .bottom-text {
            margin-top: 15px;
            font-size: 13px;
            color: #555;
            text-align: center;
        }
        .bottom-text a {
            color: #6c2cff;
            text-decoration: none;
        }
        .bottom-text a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="page">
    <div class="card">
        <div class="logo">Avito<span>Mini</span></div>
        <h1>Вход в аккаунт</h1>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="error"><%= error %></div>
        <%
            }
        %>

        <!-- Экшен должен соответствовать @WebServlet("/login") -->
        <form method="post" action="login">
            <label for="login">Логин</label>
            <input type="text" id="login" name="login" required>

            <label for="password">Пароль</label>
            <input type="password" id="password" name="password" required>

            <button type="submit" class="btn-primary">Войти</button>
        </form>

        <div class="bottom-text">
            Нет аккаунта?
            <a href="register">Зарегистрироваться</a>
        </div>
    </div>
</div>
</body>
</html>
