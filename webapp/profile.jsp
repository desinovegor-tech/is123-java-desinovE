<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Timestamp" %>

<%
    String login   = (String) session.getAttribute("login");

    String name    = (String) request.getAttribute("name");
    String city    = (String) request.getAttribute("city");
    String phone   = (String) request.getAttribute("phone");

    Timestamp regDate = (Timestamp) request.getAttribute("regDate");

    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Профиль — Avito Mini</title>
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

        a {
            color: var(--main-color);
            text-decoration: none;
            font-weight: 500;
        }

        a:hover {
            color: var(--main-color-hover);
            text-decoration: underline;
        }

        .header {
            background: rgba(255,255,255,0.94);
            border-bottom: 1px solid var(--border-color);
            padding: 12px 15px;
            margin-bottom: 22px;
            box-shadow: 0 2px 12px rgba(15,118,110,0.08);
        }

        .header-inner {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }

        .logo {
            font-size: 25px;
            font-weight: 800;
            color: #111827;
            letter-spacing: -0.5px;
        }

        .logo span {
            color: var(--main-color);
        }

        .top-nav {
            margin-top: 7px;
            font-size: 14px;
            color: #94a3b8;
        }

        .top-nav a {
            margin-right: 12px;
        }

        .user-block {
            font-size: 13px;
            color: var(--muted-color);
            background: #f0fdfa;
            padding: 8px 10px;
            border-radius: 10px;
        }

        .user-block a {
            margin-left: 10px;
        }

        .layout {
            max-width: 1200px;
            margin: 0 auto 45px;
            padding: 0 15px;
            display: grid;
            grid-template-columns: 330px 1fr;
            gap: 20px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 18px;
            padding: 20px 22px;
            border: 1px solid var(--border-color);
            box-shadow: 0 8px 22px rgba(15,118,110,0.08);
        }

        .profile-main {
            display: flex;
            align-items: flex-start;
            gap: 16px;
        }

        .avatar {
            width: 74px;
            height: 74px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--main-color), var(--accent-color));
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 29px;
            font-weight: 800;
            flex-shrink: 0;
            box-shadow: 0 6px 16px rgba(15,118,110,0.25);
        }

        .profile-name {
            font-size: 21px;
            font-weight: 800;
            margin-bottom: 4px;
            color: #111827;
        }

        .profile-login {
            font-size: 13px;
            color: var(--muted-color);
            margin-bottom: 10px;
        }

        .profile-city,
        .profile-phone {
            font-size: 14px;
            color: #334155;
            margin-bottom: 5px;
        }

        .reg-date {
            margin-top: 16px;
            font-size: 12px;
            color: var(--muted-color);
            background: #f0fdfa;
            border: 1px solid #ccfbf1;
            border-radius: 12px;
            padding: 10px 12px;
        }

        .card h2 {
            margin: 0 0 15px;
            font-size: 20px;
            color: #134e4a;
        }

        .form-group {
            margin-bottom: 14px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            color: var(--muted-color);
            margin-bottom: 6px;
            font-weight: 700;
        }

        .form-group input {
            width: 100%;
            box-sizing: border-box;
            padding: 10px 11px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            font-size: 14px;
            color: var(--text-color);
            background: #ffffff;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--main-color);
            box-shadow: 0 0 0 3px rgba(15,118,110,0.16);
        }

        .btn-primary {
            border: none;
            border-radius: 10px;
            padding: 11px 22px;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            background: var(--main-color);
            color: #fff;
            box-shadow: 0 4px 12px rgba(15,118,110,0.25);
        }

        .btn-primary:hover {
            background: var(--main-color-hover);
        }

        .alerts {
            margin-bottom: 14px;
        }

        .alert-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
            border-radius: 10px;
            padding: 9px 11px;
            font-size: 13px;
            font-weight: 700;
        }

        .alert-error {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
            border-radius: 10px;
            padding: 9px 11px;
            font-size: 13px;
            font-weight: 700;
        }

        @media (max-width: 900px) {
            .layout {
                grid-template-columns: 1fr;
            }

            .header-inner {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>

<div class="header">
    <div class="header-inner">
        <div>
            <div class="logo">Avito<span>Mini</span></div>
            <div class="top-nav">
                <a href="home">Главная</a> |
                <a href="create-ad">Создать объявление</a> |
                <a href="my-ads">Мои объявления</a> |
                <a href="my-messages">Сообщения</a> |
                <a href="favorites">Избранное</a> |
                <a href="my-orders">Мои заказы</a> |
                <a href="profile"><b>Профиль</b></a>
            </div>
        </div>
        <div class="user-block">
            Вы вошли как
            <b><%= login != null ? login : "Гость" %></b>
            <a href="logout">Выход</a>
        </div>
    </div>
</div>

<div class="layout">

    <div class="card">
        <div class="profile-main">
            <div class="avatar">
                <%
                    String initials = "";
                    if (name != null && !name.isEmpty()) {
                        initials = name.substring(0,1).toUpperCase();
                    } else if (login != null && !login.isEmpty()) {
                        initials = login.substring(0,1).toUpperCase();
                    }
                %>
                <%= initials %>
            </div>
            <div>
                <div class="profile-name"><%= name != null ? name : "Имя не указано" %></div>
                <div class="profile-login">@<%= login != null ? login : "user" %></div>

                <div class="profile-city">
                    <%= city != null && !city.isEmpty() ? city : "Город не указан" %>
                </div>

                <div class="profile-phone">
                    <%= phone != null && !phone.isEmpty() ? phone : "Телефон не указан" %>
                </div>
            </div>
        </div>

        <div class="reg-date">
            На Avito Mini с
            <b><%= regDate != null
                    ? regDate.toLocalDateTime().toLocalDate().toString()
                    : "неизвестно" %></b>
        </div>
    </div>

    <div class="card">
        <h2>Настройки профиля</h2>

        <div class="alerts">
            <% if (success != null) { %>
            <div class="alert-success"><%= success %></div>
            <% } %>
            <% if (error != null) { %>
            <div class="alert-error"><%= error %></div>
            <% } %>
        </div>

        <form method="post" action="profile">
            <div class="form-group">
                <label for="name">Имя и фамилия</label>
                <input type="text" id="name" name="name"
                       value="<%= name != null ? name : "" %>">
            </div>

            <div class="form-group">
                <label for="city">Город</label>
                <input type="text" id="city" name="city"
                       value="<%= city != null ? city : "" %>">
            </div>

            <div class="form-group">
                <label for="phone">Телефон</label>
                <input type="text" id="phone" name="phone"
                       value="<%= phone != null ? phone : "" %>">
            </div>

            <button type="submit" class="btn-primary">Сохранить изменения</button>
        </form>
    </div>

</div>

</body>
</html>