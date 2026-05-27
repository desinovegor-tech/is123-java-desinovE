<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.MyMessagesServlet.ConversationItem" %>

<%
    List<ConversationItem> conversations =
            (List<ConversationItem>) request.getAttribute("conversations");
    String login = (String) session.getAttribute("login");
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Сообщения — Avito Mini</title>
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
            margin-bottom: 20px;
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
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 15px 45px;
        }

        h1 {
            margin: 10px 0 6px;
            font-size: 27px;
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
            padding: 15px 18px;
            border: 1px solid var(--border-color);
            box-shadow: 0 8px 22px rgba(15,118,110,0.08);
        }

        .conversation-list {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .conversation-item {
            display: flex;
            padding: 13px 8px;
            border-bottom: 1px solid #eef2f7;
            cursor: pointer;
            border-radius: 12px;
            transition: background 0.12s ease, transform 0.12s ease;
        }

        .conversation-item:last-child {
            border-bottom: none;
        }

        .conversation-item:hover {
            background: #f0fdfa;
            transform: translateY(-1px);
        }

        .conv-main {
            flex: 1;
        }

        .conv-title {
            font-size: 16px;
            font-weight: 800;
            margin-bottom: 5px;
            color: #111827;
        }

        .conv-preview {
            font-size: 13px;
            color: #334155;
            margin-bottom: 3px;
            max-height: 34px;
            overflow: hidden;
            line-height: 1.35;
        }

        .conv-time {
            font-size: 12px;
            color: var(--muted-color);
        }

        .conv-link {
            display: flex;
            align-items: center;
            font-size: 13px;
            white-space: nowrap;
            margin-left: 10px;
            color: var(--main-color);
            font-weight: 800;
        }

        .empty-box {
            padding: 22px;
            text-align: center;
            font-size: 14px;
            color: var(--muted-color);
            background: #f8fafc;
            border: 1px dashed #cbd5e1;
            border-radius: 14px;
        }

        @media (max-width: 760px) {
            .header-inner {
                flex-direction: column;
                align-items: flex-start;
            }

            .conversation-item {
                flex-direction: column;
                gap: 8px;
            }

            .conv-link {
                margin-left: 0;
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
                <a href="my-messages"><b>Сообщения</b></a> |
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
    <h1>Сообщения</h1>
    <div class="subtitle">Список ваших диалогов с продавцами и покупателями.</div>

    <div class="card">
        <%
            if (conversations == null || conversations.isEmpty()) {
        %>
        <div class="empty-box">
            У вас пока нет переписок. Напишите продавцу из карточки объявления.
        </div>
        <%
        } else {
        %>
        <ul class="conversation-list">
            <%
                for (ConversationItem c : conversations) {
                    java.sql.Timestamp ts = c.getLastDateTime();
                    String dt = (ts != null) ? ts.toString() : "";
            %>
            <li onclick="location.href='messages?adId=<%= c.getAdId() %>'"
                class="conversation-item">
                <div class="conv-main">
                    <div class="conv-title"><%= c.getAdTitle() %></div>
                    <div class="conv-preview">
                        <%= c.getLastText() != null ? c.getLastText() : "" %>
                    </div>
                    <div class="conv-time"><%= dt %></div>
                </div>
                <div class="conv-link">
                    Перейти к диалогу →
                </div>
            </li>
            <%
                }
            %>
        </ul>
        <%
            }
        %>
    </div>
</div>

</body>
</html>