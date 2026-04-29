<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.Advertisement" %>

<%
    String login = (String) session.getAttribute("login");
    List<Advertisement> ads = (List<Advertisement>) request.getAttribute("ads");
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Мои объявления — Avito Mini</title>
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

        /* Шапка такая же, как на главной */
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
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 15px 40px;
        }

        h1 {
            margin: 10px 0 20px;
            font-size: 24px;
        }

        /* Карточка контейнер */
        .card {
            background: #ffffff;
            border-radius: 10px;
            padding: 15px 18px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .ads-list {
            margin-top: 5px;
        }

        .ad-empty {
            padding: 20px;
            text-align: center;
            font-size: 14px;
            color: #777;
        }

        .ad-row {
            display: flex;
            flex-wrap: wrap;
            padding: 10px 6px;
            border-bottom: 1px solid #eee;
            gap: 10px;
        }
        .ad-row:last-child {
            border-bottom: none;
        }

        .ad-main {
            flex: 2;
            min-width: 260px;
        }
        .ad-main-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 4px;
        }
        .ad-main-title a {
            color: #222;
        }
        .ad-main-price {
            font-size: 17px;
            font-weight: 700;
            margin-bottom: 4px;
        }
        .ad-main-info {
            font-size: 13px;
            color: #666;
        }

        .ad-actions {
            flex: 1;
            min-width: 180px;
            text-align: right;
            font-size: 13px;
            align-self: center;
        }
        .ad-actions a {
            margin-left: 8px;
        }

        @media (max-width: 800px) {
            .ad-row {
                flex-direction: column;
                align-items: flex-start;
            }
            .ad-actions {
                text-align: left;
                margin-top: 5px;
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
    <h1>Мои объявления</h1>

    <div class="card">
        <div style="margin-bottom: 10px; font-size: 13px; color:#666;">
            Здесь отображаются все объявления, которые вы разместили.
        </div>

        <div class="ads-list">
            <%
                if (ads == null || ads.isEmpty()) {
            %>
            <div class="ad-empty">
                У вас пока нет объявлений.<br>
                <a href="create-ad">Создать объявление</a>
            </div>
            <%
            } else {
                for (Advertisement ad : ads) {
            %>
            <div class="ad-row">
                <!-- Основная информация -->
                <div class="ad-main">
                    <div class="ad-main-title">
                        <a href="view-ad?id=<%= ad.getId() %>">
                            <%= ad.getTitle() %>
                        </a>
                    </div>
                    <div class="ad-main-price">
                        <%= String.format("%.2f ₽", ad.getPrice()) %>
                    </div>
                    <div class="ad-main-info">
                        <%= ad.getLocation() != null ? ad.getLocation() : "" %>
                    </div>
                </div>

                <!-- Действия -->
                <div class="ad-actions">
                    <a href="view-ad?id=<%= ad.getId() %>">Открыть</a>

                    <a href="deactivate-ad?id=<%= ad.getId() %>"
                       onclick="return confirm('Снять объявление с публикации?');">
                        Снять с публикации
                    </a>

                    <%-- если хочешь оставить жёсткое удаление, можно отдельной ссылкой:
                    <a href="delete-ad?id=<%= ad.getId() %>"
                       onclick="return confirm('Точно удалить объявление без возврата?');">
                        Удалить
                    </a>
                    --%>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>
</div>

</body>
</html>
