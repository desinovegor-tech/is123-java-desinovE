<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.MessagesServlet.MessageView" %>

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

        .chat-header {
            margin-bottom: 10px;
        }
        .chat-header a.back-link {
            font-size: 13px;
        }
        .chat-title {
            margin-top: 8px;
            font-size: 20px;
            font-weight: 600;
        }
        .chat-subtitle {
            font-size: 13px;
            color: #666;
        }

        .chat-wrapper {
            display: flex;
            flex-direction: column;
            background: #ffffff;
            border-radius: 10px;
            padding: 12px 14px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            height: 520px;
        }

        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 8px 4px;
            border-bottom: 1px solid #eee;
        }

        .msg-row {
            display: flex;
            margin: 6px 0;
        }
        .msg-row.mine {
            justify-content: flex-end;
        }
        .msg-row.other {
            justify-content: flex-start;
        }

        .msg-bubble {
            max-width: 70%;
            padding: 8px 10px;
            border-radius: 10px;
            font-size: 13px;
            line-height: 1.4;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
            position: relative;
        }
        .msg-row.mine .msg-bubble {
            background: #6c2cff;
            color: #fff;
            border-bottom-right-radius: 2px;
        }
        .msg-row.other .msg-bubble {
            background: #f1f0f0;
            color: #222;
            border-bottom-left-radius: 2px;
        }

        .msg-meta {
            font-size: 11px;
            margin-bottom: 4px;
            opacity: 0.8;
        }
        .msg-text {
            white-space: pre-wrap;
        }

        .chat-empty {
            text-align: center;
            font-size: 13px;
            color: #999;
            margin-top: 30px;
        }

        .chat-input-block {
            padding-top: 10px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .chat-input-block textarea {
            width: 100%;
            box-sizing: border-box;
            border-radius: 8px;
            border: 1px solid #ccc;
            padding: 8px 10px;
            font-size: 13px;
            resize: vertical;
            min-height: 60px;
            max-height: 160px;
        }
        .chat-input-block textarea:focus {
            outline: none;
            border-color: #6c2cff;
            box-shadow: 0 0 0 1px rgba(108,44,255,0.2);
        }

        .chat-input-actions {
            display: flex;
            justify-content: flex-end;
        }
        .btn-primary {
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            background: #6c2cff;
            color: #fff;
        }
        .btn-primary:hover {
            background: #5a22e0;
        }

        @media (max-width: 700px) {
            .chat-wrapper {
                height: 80vh;
            }
            .msg-bubble {
                max-width: 85%;
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
        <!-- Сообщения -->
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

        <!-- Ввод сообщения -->
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
    // автопрокрутка в самый низ чата
    window.addEventListener('load', function () {
        var box = document.getElementById('chatMessages');
        if (box) {
            box.scrollTop = box.scrollHeight;
        }
    });
</script>

</body>
</html>
