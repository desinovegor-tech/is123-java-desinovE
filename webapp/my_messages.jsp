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
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 15px 40px;
        }

        h1 {
            margin: 10px 0 20px;
            font-size: 24px;
        }

        .card {
            background: #ffffff;
            border-radius: 10px;
            padding: 15px 18px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .conversation-list {
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .conversation-item {
            display: flex;
            padding: 10px 6px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
        }
        .conversation-item:last-child {
            border-bottom: none;
        }

        .conv-main {
            flex: 1;
        }

        .conv-title {
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 3px;
            color: #222;
        }

        .conv-preview {
            font-size: 13px;
            color: #666;
            margin-bottom: 2px;
            max-height: 32px;
            overflow: hidden;
        }

        .conv-time {
            font-size: 12px;
            color: #999;
        }

        .conv-link {
            display: flex;
            align-items: center;
            font-size: 13px;
            white-space: nowrap;
            margin-left: 10px;
            color: #3366cc;
        }

        .conv-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .empty-box {
            padding: 20px;
            text-align: center;
            font-size: 14px;
            color: #777;
        }

        .conversation-item:hover {
            background: #f8f8ff;
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
    <h1>Сообщения</h1>

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
