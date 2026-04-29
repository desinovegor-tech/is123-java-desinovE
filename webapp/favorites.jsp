<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.Advertisement" %>

<%
    List<Advertisement> ads = (List<Advertisement>) request.getAttribute("ads");
    String login = (String) session.getAttribute("login");
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Избранное — Avito Mini</title>
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

        .layout {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px 40px;
        }

        /* Шапка */
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
        .user-block {
            font-size: 13px;
            color: #555;
        }
        .user-block a {
            margin-left: 10px;
        }

        /* Верхнее меню */
        .top-nav {
            margin-top: 5px;
            font-size: 14px;
        }
        .top-nav a {
            margin-right: 12px;
        }

        /* Контент */
        .page-title {
            margin-top: 15px;
            font-size: 22px;
            font-weight: 600;
        }

        .favorites-empty {
            margin-top: 20px;
            background: #ffffff;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            font-size: 14px;
            color: #777;
        }

        .fav-list {
            margin-top: 15px;
        }

        .fav-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            background: #ffffff;
            border-radius: 8px;
            padding: 10px 12px;
            margin-bottom: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
        }
        .fav-photo {
            width: 120px;
            height: 90px;
            flex-shrink: 0;
            border-radius: 6px;
            overflow: hidden;
            background: #eee;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #777;
        }
        .fav-photo img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .fav-main {
            flex: 1;
        }

        .fav-title {
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .fav-price {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .fav-location {
            font-size: 13px;
            color: #666;
        }

        .fav-actions {
            font-size: 13px;
            text-align: right;
            white-space: nowrap;
        }

        .fav-actions a {
            margin-left: 8px;
        }

        .btn-link-danger {
            color: #c0392b;
        }
        .btn-link-danger:hover {
            color: #e74c3c;
        }
    </style>
</head>
<body>

<div class="header">
    <div class="header-inner">
        <div>
            <div class="logo">Avito<span>Mini</span></div>
            <div class="top-nav">
                <a href="home">Главная</a>
                |
                <a href="create-ad">Создать объявление</a>
                |
                <a href="my-ads">Мои объявления</a>
                |
                <a href="my-messages">Сообщения</a>
                |
                <a href="favorites"><b>Избранное</b></a>
                |
                <a href="my-orders">Мои заказы</a>
                |
                <a href="profile">Профиль</a>
            </div>
        </div>
        <div class="user-block">
            Вы вошли как
            <b><%= (login != null ? login : "Гость") %></b>
            <a href="logout">Выход</a>
        </div>
    </div>
</div>

<div class="layout">

    <div class="page-title">Избранные объявления</div>

    <div class="fav-list">
        <%
            if (ads == null || ads.isEmpty()) {
        %>
        <p class="fav-empty">У вас пока нет избранных объявлений.</p>
        <%
        } else {
            for (Advertisement ad : ads) {
        %>

        <div class="fav-card">

            <!-- Мини-фото -->
            <div class="fav-photo">
                <%
                    String img = ad.getMainImageUrl();
                    if (img != null && !img.isEmpty()) {
                %>
                <img src="uploads/<%= img %>" alt="Фото объявления">
                <%
                } else {
                %>
                нет фото
                <%
                    }
                %>
            </div>

            <div class="fav-main">
                <div class="fav-title">
                    <a href="view-ad?id=<%= ad.getId() %>"><%= ad.getTitle() %></a>
                </div>
                <div class="fav-price">
                    <%= String.format("%.2f ₽", ad.getPrice()) %>
                </div>
                <div class="fav-location">
                    <%= ad.getLocation() != null ? ad.getLocation() : "" %>
                </div>
            </div>

            <div class="fav-actions">
                <a href="view-ad?id=<%= ad.getId() %>">Открыть</a>
                <a href="delete-favorite?id=<%= ad.getId() %>&from=favorites"
                   class="btn-link-danger"
                   onclick="return confirm('Убрать это объявление из избранного?');">
                    Удалить
                </a>
            </div>

        </div>

        <%
                }
            }
        %>
    </div>


</div>

</body>
</html>
