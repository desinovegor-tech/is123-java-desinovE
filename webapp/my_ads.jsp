<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.model.Advertisement" %>

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
            max-width: 1100px;
            margin: 0 auto;
            padding: 0 15px 40px;
        }

        h1 {
            margin: 10px 0 8px;
            font-size: 26px;
            color: #134e4a;
            letter-spacing: -0.3px;
        }

        .subtitle {
            font-size: 13px;
            color: var(--muted-color);
            margin-bottom: 18px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 18px;
            padding: 18px 20px;
            border: 1px solid var(--border-color);
            box-shadow: 0 8px 22px rgba(15,118,110,0.08);
        }

        .ads-list {
            margin-top: 5px;
        }

        .ad-empty {
            padding: 24px;
            text-align: center;
            font-size: 14px;
            color: var(--muted-color);
            background: #f8fafc;
            border-radius: 14px;
            border: 1px dashed #cbd5e1;
        }

        .ad-empty a {
            display: inline-block;
            margin-top: 8px;
            padding: 8px 12px;
            border-radius: 10px;
            background: var(--main-color);
            color: #ffffff;
            font-weight: 800;
        }

        .ad-empty a:hover {
            background: var(--main-color-hover);
            text-decoration: none;
        }

        .ad-row {
            display: flex;
            flex-wrap: wrap;
            padding: 13px 8px;
            border-bottom: 1px solid #eef2f7;
            gap: 12px;
            align-items: center;
            transition: background 0.12s ease;
        }

        .ad-row:hover {
            background: #f8fafc;
            border-radius: 12px;
        }

        .ad-row:last-child {
            border-bottom: none;
        }

        .ad-main {
            flex: 2;
            min-width: 260px;
        }

        .ad-main-title {
            font-size: 17px;
            font-weight: 800;
            margin-bottom: 5px;
        }

        .ad-main-title a {
            color: #111827;
        }

        .ad-main-title a:hover {
            color: var(--main-color);
        }

        .ad-main-price {
            font-size: 19px;
            font-weight: 800;
            margin-bottom: 5px;
            color: var(--main-color);
        }

        .ad-main-info {
            font-size: 13px;
            color: var(--muted-color);
        }

        .ad-actions {
            flex: 1;
            min-width: 230px;
            text-align: right;
            font-size: 13px;
            align-self: center;
        }

        .ad-actions a {
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

        .btn-danger {
            color: var(--danger-color);
            font-weight: 700;
        }

        .btn-danger:hover {
            color: #b91c1c;
        }

        @media (max-width: 800px) {
            .header-inner {
                flex-direction: column;
                align-items: flex-start;
            }

            .ad-row {
                flex-direction: column;
                align-items: flex-start;
            }

            .ad-actions {
                text-align: left;
                margin-top: 5px;
                min-width: 100%;
            }

            .ad-actions a {
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
                <a href="my-ads"><b>Мои объявления</b></a> |
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
    <div class="subtitle">Здесь отображаются ваши активные объявления, которые доступны для просмотра и продажи.</div>

    <div class="card">
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

                <div class="ad-actions">
                    <a class="btn-open" href="view-ad?id=<%= ad.getId() %>">Открыть</a>

                    <a class="btn-danger"
                       href="deactivate-ad?id=<%= ad.getId() %>"
                       onclick="return confirm('Снять объявление с публикации?');">
                        Снять с публикации
                    </a>
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