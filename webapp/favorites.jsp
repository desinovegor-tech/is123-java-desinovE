<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.model.Advertisement" %>

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
        :root {
            --main-color: #0f766e;
            --main-color-hover: #0d5f59;
            --accent-color: #14b8a6;
            --page-bg: #eef7f6;
            --card-bg: #ffffff;
            --border-color: #d7e7e5;
            --text-color: #1f2937;
            --muted-color: #64748b;
            --danger-color: #dc2626;
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

        .layout {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px 40px;
        }

        .header {
            background: rgba(255,255,255,0.94);
            border-bottom: 1px solid var(--border-color);
            padding: 12px 15px;
            margin-bottom: 18px;
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

        .top-nav {
            margin-top: 7px;
            font-size: 14px;
            color: #94a3b8;
        }

        .top-nav a {
            margin-right: 12px;
        }

        .page-title {
            margin-top: 15px;
            font-size: 25px;
            font-weight: 800;
            color: #134e4a;
            letter-spacing: -0.3px;
        }

        .page-subtitle {
            margin-top: 6px;
            font-size: 13px;
            color: var(--muted-color);
        }

        .fav-list {
            margin-top: 18px;
        }

        .fav-empty {
            margin-top: 20px;
            background: var(--card-bg);
            border-radius: 16px;
            padding: 24px;
            text-align: center;
            font-size: 14px;
            color: var(--muted-color);
            border: 1px solid var(--border-color);
            box-shadow: 0 6px 18px rgba(15,118,110,0.06);
        }

        .fav-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            background: var(--card-bg);
            border-radius: 16px;
            padding: 12px;
            margin-bottom: 12px;
            border: 1px solid var(--border-color);
            box-shadow: 0 5px 16px rgba(15,118,110,0.06);
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }

        .fav-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 24px rgba(15,118,110,0.12);
        }

        .fav-photo {
            width: 130px;
            height: 96px;
            flex-shrink: 0;
            border-radius: 12px;
            overflow: hidden;
            background: #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: var(--muted-color);
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
            font-size: 16px;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .fav-title a {
            color: #111827;
        }

        .fav-title a:hover {
            color: var(--main-color);
        }

        .fav-price {
            font-size: 19px;
            font-weight: 800;
            margin-bottom: 5px;
            color: var(--main-color);
        }

        .fav-location {
            font-size: 13px;
            color: var(--muted-color);
        }

        .fav-actions {
            font-size: 13px;
            text-align: right;
            white-space: nowrap;
        }

        .fav-actions a {
            margin-left: 8px;
        }

        .btn-open {
            display: inline-block;
            padding: 8px 12px;
            border-radius: 10px;
            background: #f0fdfa;
            border: 1px solid var(--border-color);
            color: #134e4a;
            font-weight: 700;
        }

        .btn-open:hover {
            background: #ccfbf1;
            text-decoration: none;
        }

        .btn-link-danger {
            color: var(--danger-color);
            font-weight: 700;
        }

        .btn-link-danger:hover {
            color: #b91c1c;
        }

        @media (max-width: 768px) {
            .header-inner {
                flex-direction: column;
                align-items: flex-start;
            }

            .fav-card {
                flex-direction: column;
                align-items: stretch;
            }

            .fav-photo {
                width: 100%;
                height: 180px;
            }

            .fav-actions {
                text-align: left;
                white-space: normal;
            }

            .fav-actions a {
                margin-left: 0;
                margin-right: 10px;
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
                <a href="favorites"><b>Избранное</b></a> |
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

    <div class="page-title">Избранные объявления</div>
    <div class="page-subtitle">Здесь собраны объявления, которые вы добавили в избранное.</div>

    <div class="fav-list">
        <%
            if (ads == null || ads.isEmpty()) {
        %>
        <div class="fav-empty">
            У вас пока нет избранных объявлений.<br>
            <a href="home">Перейти к объявлениям</a>
        </div>
        <%
        } else {
            for (Advertisement ad : ads) {
        %>

        <div class="fav-card">
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
                <a class="btn-open" href="view-ad?id=<%= ad.getId() %>">Открыть</a>
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