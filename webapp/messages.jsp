<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.controller.MessagesServlet.MessageView" %>

<%
    Integer adId       = (Integer) request.getAttribute("adId");
    String adTitle     = (String) request.getAttribute("adTitle");
    String sellerName  = (String) request.getAttribute("sellerName");
    List<MessageView> msgs =
            (List<MessageView>) request.getAttribute("messages");

    Integer currentUserId = (Integer) session.getAttribute("userId");
    String login          = (String) session.getAttribute("login");
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Чат по объявлению — <%= adTitle != null ? adTitle : "" %></title>
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

        .chat-header {
            margin-bottom: 14px;
        }

        .chat-header a.back-link {
            display: inline-block;
            font-size: 13px;
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 999px;
            padding: 8px 13px;
            box-shadow: 0 4px 12px rgba(15,118,110,0.06);
        }

        .chat-title {
            margin-top: 12px;
            font-size: 24px;
            font-weight: 800;
            color: #134e4a;
        }

        .chat-subtitle {
            font-size: 13px;
            color: var(--muted-color);
            margin-top: 4px;
        }

        .chat-wrapper {
            display: flex;
            flex-direction: column;
            background: var(--card-bg);
            border-radius: 18px;
            padding: 14px 16px;
            border: 1px solid var(--border-color);
            box-shadow: 0 8px 22px rgba(15,118,110,0.08);
            height: 540px;
        }

        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 8px 4px;
            border-bottom: 1px solid #eef2f7;
        }

        .msg-row {
            display: flex;
            margin: 8px 0;
        }

        .msg-row.mine {
            justify-content: flex-end;
        }

        .msg-row.other {
            justify-content: flex-start;
        }

        .msg-bubble {
            max-width: 70%;
            padding: 9px 11px;
            border-radius: 14px;
            font-size: 13px;
            line-height: 1.45;
            box-shadow: 0 2px 8px rgba(15,118,110,0.08);
            position: relative;
        }

        .msg-row.mine .msg-bubble {
            background: var(--main-color);
            color: #fff;
            border-bottom-right-radius: 4px;
        }

        .msg-row.other .msg-bubble {
            background: #f0fdfa;
            color: #1f2937;
            border: 1px solid #ccfbf1;
            border-bottom-left-radius: 4px;
        }

        .msg-meta {
            font-size: 11px;
            margin-bottom: 4px;
            opacity: 0.85;
        }

        .msg-text {
            white-space: pre-wrap;
        }

        .chat-empty {
            text-align: center;
            font-size: 13px;
            color: var(--muted-color);
            margin-top: 30px;
        }

        .chat-input-block {
            padding-top: 11px;
        }

        .chat-input-block textarea {
            width: 100%;
            box-sizing: border-box;
            border-radius: 12px;
            border: 1px solid #cbd5e1;
            padding: 10px 11px;
            font-size: 13px;
            resize: vertical;
            min-height: 64px;
            max-height: 160px;
            color: var(--text-color);
            background: #ffffff;
        }

        .chat-input-block textarea:focus {
            outline: none;
            border-color: var(--main-color);
            box-shadow: 0 0 0 3px rgba(15,118,110,0.16);
        }

        .chat-input-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 8px;
        }

        .btn-primary {
            border: none;
            border-radius: 10px;
            padding: 9px 18px;
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

        @media (max-width: 760px) {
            .header-inner {
                flex-direction: column;
                align-items: flex-start;
            }

            .chat-wrapper {
                height: 78vh;
            }

            .msg-bubble {
                max-width: 85%;
            }

            .chat-title {
                font-size: 21px;
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
    <div class="chat-header">
        <a class="back-link" href="my-messages">← Назад к списку диалогов</a>
        <div class="chat-title"><%= adTitle != null ? adTitle : "Переписка" %></div>
        <div class="chat-subtitle">
            Объявление №<%= adId %>
            <% if (sellerName != null) { %>
            · Продавец: <b><%= sellerName %></b>
            <% } %>
        </div>
    </div>

    <div class="chat-wrapper">
        <div class="chat-messages" id="chatMessages">
            <%
                if (msgs == null || msgs.isEmpty()) {
            %>
            <div class="chat-empty">
                Сообщений пока нет. Напишите первое!
            </div>
            <%
            } else {
                for (MessageView m : msgs) {
                    boolean mine = (currentUserId != null && currentUserId == m.getSenderId());
            %>
            <div class="msg-row <%= mine ? "mine" : "other" %>">
                <div class="msg-bubble">
                    <div class="msg-meta">
                        <b><%= mine ? "Вы" : m.getSenderName() %></b>
                        · <%= m.getDateTimeStr() %>
                    </div>
                    <div class="msg-text"><%= m.getText() %></div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>

        <div class="chat-input-block">
            <form method="post" action="messages">
                <input type="hidden" name="adId" value="<%= adId %>">
                <textarea name="text" required
                          placeholder="Напишите сообщение..."></textarea>
                <div class="chat-input-actions">
                    <button type="submit" class="btn-primary">Отправить</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    window.addEventListener('load', function () {
        var box = document.getElementById('chatMessages');
        if (box) {
            box.scrollTop = box.scrollHeight;
        }
    });
</script>

</body>
</html>