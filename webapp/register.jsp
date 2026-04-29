<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Регистрация — Avito Mini</title>
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
            width: 420px;
            max-width: 95%;
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
            margin: 0 0 15px;
        }
        p.subtitle {
            font-size: 13px;
            margin: 0 0 20px;
            color: #666;
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
        .row-2 {
            display: flex;
            gap: 10px;
        }
        .row-2 .col {
            flex: 1;
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
        <h1>Регистрация</h1>
        <p class="subtitle">Создайте аккаунт, чтобы размещать объявления и писать продавцам.</p>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="error"><%= error %></div>
        <%
            }
        %>

        <!-- Экшен должен соответствовать @WebServlet("/register") -->
        <form method="post" action="register">
            <label for="login">Логин</label>
            <input type="text" id="login" name="login" required>

            <label for="password">Пароль</label>
            <input type="password" id="password" name="password" required>

            <label for="name">Имя</label>
            <input type="text" id="name" name="name" required>

            <div class="row-2">
                <div class="col">
                    <label for="phone">Телефон</label>
                    <input type="text" id="phone" name="phone">
                </div>
                <div class="col">
                    <label for="city">Город</label>
                    <input type="text" id="city" name="city">
                </div>
            </div>

            <button type="submit" class="btn-primary">Зарегистрироваться</button>
        </form>

        <div class="bottom-text">
            Уже есть аккаунт?
            <a href="login">Войти</a>
        </div>
    </div>
</div>
</body>
</html>
