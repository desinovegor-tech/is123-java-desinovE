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
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
        }

        a {
            color: #3366cc;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }

        .header {
            background: #ffffff;
            border-bottom: 1px solid #e0e0e0;
            padding: 10px 15px;
            margin-bottom: 15px;
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
            font-size: 24px;
            font-weight: 700;
            color: #2c2c2c;
        }
        .logo span {
            color: #6c2cff;
        }
        .top-nav {
            margin-top: 5px;
            font-size: 14px;
        }
        .top-nav a {
            margin-right: 12px;
        }
        .user-block {
            font-size: 13px;
            color: #555;
        }
        .user-block a {
            margin-left: 10px;
        }

        .layout {
            max-width: 1200px;
            margin: 0 auto 40px;
            padding: 0 15px;
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 20px;
        }
        @media (max-width: 900px) {
            .layout {
                grid-template-columns: 1fr;
            }
        }

        .card {
            background: #ffffff;
            border-radius: 10px;
            padding: 18px 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .profile-main {
            display: flex;
            align-items: flex-start;
            gap: 16px;
        }

        .avatar {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: linear-gradient(135deg, #6c2cff, #ff8a00);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            font-weight: 700;
            flex-shrink: 0;
        }

        .profile-name {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .profile-login {
            font-size: 13px;
            color: #777;
            margin-bottom: 8px;
        }

        .profile-city {
            font-size: 14px;
            color: #555;
            margin-bottom: 4px;
        }

        .profile-phone {
            font-size: 14px;
            color: #555;
        }

        .reg-date {
            margin-top: 12px;
            font-size: 12px;
            color: #888;
        }

        .card h2 {
            margin: 0 0 12px;
            font-size: 18px;
        }

        .form-group {
            margin-bottom: 12px;
        }
        .form-group label {
            display: block;
            font-size: 13px;
            color: #666;
            margin-bottom: 4px;
        }
        .form-group input {
            width: 100%;
            box-sizing: border-box;
            padding: 7px 9px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        .form-group input:focus {
            outline: none;
            border-color: #6c2cff;
            box-shadow: 0 0 0 1px rgba(108,44,255,0.2);
        }

        .btn-primary {
            border: none;
            border-radius: 6px;
            padding: 8px 18px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            background: #6c2cff;
            color: #fff;
        }
        .btn-primary:hover {
            background: #5a22e0;
        }

        .alerts {
            margin-bottom: 12px;
        }
        .alert-success {
            background: #e8f9f0;
            color: #1b7f44;
            border-radius: 6px;
            padding: 8px 10px;
            font-size: 13px;
        }
        .alert-error {
            background: #ffeaea;
            color: #c72525;
            border-radius: 6px;
            padding: 8px 10px;
            font-size: 13px;
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
                <a href="profile">Профиль</a>
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

    <!-- Левая колонка — карточка пользователя -->
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

    <!-- Правая колонка — редактирование профиля -->
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
