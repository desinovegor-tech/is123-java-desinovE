<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Регистрация — Avito Mini</title>
    <style>
        :root {
            --main-color: #0f766e;
            --main-color-hover: #0d5f59;
            --accent-color: #14b8a6;
            --page-bg: #eef7f6;
            --card-bg: #ffffff;
            --border-color: #d7e7e5;
            --text-color: #1f2937;
            --muted-color: #64748b;
        }

        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(180deg, #e0f2f1 0%, var(--page-bg) 260px, #f8fafc 100%);
            margin: 0;
            color: var(--text-color);
        }

        .page {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 25px 15px;
            box-sizing: border-box;
        }

        .card {
            background: var(--card-bg);
            border-radius: 18px;
            padding: 32px 38px;
            box-shadow: 0 10px 28px rgba(15,118,110,0.12);
            border: 1px solid var(--border-color);
            width: 440px;
            max-width: 100%;
        }

        .logo {
            font-size: 27px;
            font-weight: 800;
            margin-bottom: 22px;
            color: #111827;
            letter-spacing: -0.5px;
        }

        .logo span {
            color: var(--main-color);
        }

        h1 {
            font-size: 22px;
            margin: 0 0 6px;
            color: #134e4a;
        }

        p.subtitle {
            font-size: 13px;
            margin: 0 0 22px;
            color: var(--muted-color);
            line-height: 1.45;
        }

        label {
            display: block;
            font-size: 13px;
            margin-bottom: 6px;
            color: var(--muted-color);
            font-weight: 600;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            box-sizing: border-box;
            padding: 10px 11px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            font-size: 14px;
            margin-bottom: 15px;
            color: var(--text-color);
            background: #ffffff;
        }

        input[type="text"]:focus,
        input[type="password"]:focus {
            outline: none;
            border-color: var(--main-color);
            box-shadow: 0 0 0 3px rgba(15,118,110,0.16);
        }

        .row-2 {
            display: flex;
            gap: 12px;
        }

        .row-2 .col {
            flex: 1;
        }

        .btn-primary {
            width: 100%;
            border: none;
            border-radius: 10px;
            padding: 11px 0;
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            background: var(--main-color);
            color: #fff;
            margin-top: 5px;
            box-shadow: 0 4px 12px rgba(15,118,110,0.25);
        }

        .btn-primary:hover {
            background: var(--main-color-hover);
        }

        .error {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #b91c1c;
            padding: 9px 11px;
            border-radius: 10px;
            font-size: 13px;
            margin-bottom: 16px;
            font-weight: 600;
        }

        .bottom-text {
            margin-top: 17px;
            font-size: 13px;
            color: var(--muted-color);
            text-align: center;
        }

        .bottom-text a {
            color: var(--main-color);
            text-decoration: none;
            font-weight: 700;
        }

        .bottom-text a:hover {
            color: var(--main-color-hover);
            text-decoration: underline;
        }

        @media (max-width: 520px) {
            .row-2 {
                flex-direction: column;
                gap: 0;
            }

            .card {
                padding: 28px 24px;
            }
        }
    </style>
</head>
<body>
<div class="page">
    <div class="card">
        <div class="logo">Avito<span>Mini</span></div>

        <h1>Регистрация</h1>
        <p class="subtitle">Создайте аккаунт, чтобы размещать объявления, писать продавцам и оформлять заказы.</p>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="error"><%= error %></div>
        <%
            }
        %>

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