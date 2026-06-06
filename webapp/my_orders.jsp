<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.controller.MyOrdersServlet.OrderView" %>
<%@ page import="avito.controller.MyOrdersServlet.SellerOrderView" %>

<%
    List<OrderView> buyerOrders =
            (List<OrderView>) request.getAttribute("orders");
    List<SellerOrderView> sellerOrders =
            (List<SellerOrderView>) request.getAttribute("sales");

    String login = (String) session.getAttribute("login");
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Мои заказы — Avito Mini</title>
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
            padding: 0 15px 45px;
        }

        .back-link {
            margin: 10px 0 16px;
            font-size: 14px;
        }

        .back-link a {
            display: inline-block;
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 999px;
            padding: 8px 13px;
            box-shadow: 0 4px 12px rgba(15,118,110,0.06);
        }

        .page-title {
            font-size: 27px;
            font-weight: 800;
            margin-bottom: 6px;
            color: #134e4a;
            letter-spacing: -0.3px;
        }

        .page-subtitle {
            font-size: 13px;
            color: var(--muted-color);
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 20px;
            font-weight: 800;
            margin: 24px 0 12px;
            color: #134e4a;
        }

        .order-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .order-card {
            background: var(--card-bg);
            border-radius: 16px;
            padding: 15px 17px;
            border: 1px solid var(--border-color);
            box-shadow: 0 6px 18px rgba(15,118,110,0.06);
            display: flex;
            justify-content: space-between;
            gap: 18px;
            font-size: 14px;
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }

        .order-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 24px rgba(15,118,110,0.12);
        }

        .order-main {
            flex: 1;
        }

        .order-title {
            font-size: 17px;
            font-weight: 800;
            margin-bottom: 7px;
            color: #111827;
        }

        .order-meta {
            color: var(--muted-color);
            margin-bottom: 4px;
            line-height: 1.45;
        }

        .order-meta b {
            color: #334155;
        }

        .order-status {
            display: inline-block;
            margin-top: 7px;
            font-size: 12px;
            font-weight: 800;
            border-radius: 999px;
            padding: 5px 10px;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-cancelled {
            background: #fee2e2;
            color: #b91c1c;
        }

        .status-done {
            background: #dcfce7;
            color: #166534;
        }

        .order-actions {
            text-align: right;
            min-width: 170px;
        }

        .order-amount {
            font-size: 18px;
            font-weight: 800;
            color: var(--main-color);
            margin-bottom: 10px;
        }

        .btn-cancel {
            border: 1px solid #fecaca;
            border-radius: 10px;
            background: #fef2f2;
            color: var(--danger-color);
            padding: 8px 12px;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
        }

        .btn-cancel:hover {
            background: #fee2e2;
            color: #b91c1c;
        }

        .empty-text {
            padding: 22px;
            background: var(--card-bg);
            border-radius: 16px;
            color: var(--muted-color);
            font-size: 14px;
            text-align: center;
            border: 1px solid var(--border-color);
            box-shadow: 0 6px 18px rgba(15,118,110,0.06);
        }

        @media (max-width: 760px) {
            .header-inner {
                flex-direction: column;
                align-items: flex-start;
            }

            .order-card {
                flex-direction: column;
            }

            .order-actions {
                text-align: left;
                min-width: 100%;
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
                <a href="my-orders"><b>Мои заказы</b></a> |
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

    <p class="back-link">
        <a href="home">← К объявлениям</a>
    </p>

    <div class="page-title">Мои заказы</div>
    <div class="page-subtitle">
        Здесь отображаются ваши покупки и заказы, которые оформили на ваши объявления.
    </div>

    <div class="section-title">Мои покупки</div>
    <div class="order-list">
        <%
            if (buyerOrders == null || buyerOrders.isEmpty()) {
        %>
        <div class="empty-text">
            Вы ещё ничего не покупали.
        </div>
        <%
        } else {
            for (OrderView o : buyerOrders) {
                String status = o.getStatus() != null ? o.getStatus() : "";

                String statusClass = "status-pending";
                String statusText = status;

                if ("cancelled".equalsIgnoreCase(status) || "canceled".equalsIgnoreCase(status)) {
                    statusClass = "status-cancelled";
                    statusText = "Отменён";
                } else if ("done".equalsIgnoreCase(status) || "completed".equalsIgnoreCase(status)) {
                    statusClass = "status-done";
                    statusText = "Завершён";
                } else if ("pending".equalsIgnoreCase(status)) {
                    statusText = "Ожидает обработки";
                }

                String paymentText;
                if ("cash".equalsIgnoreCase(o.getPaymentMethod())) {
                    paymentText = "наличными при получении";
                } else if ("card".equalsIgnoreCase(o.getPaymentMethod())) {
                    paymentText = "картой при получении";
                } else {
                    paymentText = o.getPaymentMethod();
                }
        %>

        <div class="order-card">
            <div class="order-main">
                <div class="order-title"><%= o.getAdTitle() %></div>

                <div class="order-meta">
                    Продавец: <b><%= o.getSellerName() %></b>
                </div>

                <div class="order-meta">
                    Дата: <b><%= o.getOrderDate() != null ? o.getOrderDate().toString() : "" %></b>
                </div>

                <div class="order-meta">
                    Доставка:
                    <b><%= "pickup".equalsIgnoreCase(o.getDeliveryMethod()) ? "самовывоз" : "через ПВЗ" %></b>,
                    оплата: <b><%= paymentText %></b>
                </div>

                <div class="order-status <%= statusClass %>">
                    Статус: <%= statusText %>
                </div>
            </div>

            <div class="order-actions">
                <div class="order-amount">
                    <%= o.getTotalAmount() != null ? o.getTotalAmount().toString() + " ₽" : "" %>
                </div>

                <% if (!"cancelled".equalsIgnoreCase(status) && !"canceled".equalsIgnoreCase(status)) { %>
                <form method="post" action="cancel-order"
                      onsubmit="return confirm('Отменить этот заказ?');">
                    <input type="hidden" name="orderId" value="<%= o.getId() %>">
                    <button type="submit" class="btn-cancel">Отменить заказ</button>
                </form>
                <% } %>
            </div>
        </div>

        <%
                }
            }
        %>
    </div>

    <div class="section-title">Мои продажи</div>
    <div class="order-list">
        <%
            if (sellerOrders == null || sellerOrders.isEmpty()) {
        %>
        <div class="empty-text">
            У вас пока нет заказов на ваши объявления.
        </div>
        <%
        } else {
            for (SellerOrderView s : sellerOrders) {
                String status = s.getStatus() != null ? s.getStatus() : "";

                String statusClass = "status-pending";
                String statusText = status;

                if ("cancelled".equalsIgnoreCase(status) || "canceled".equalsIgnoreCase(status)) {
                    statusClass = "status-cancelled";
                    statusText = "Отменён";
                } else if ("done".equalsIgnoreCase(status) || "completed".equalsIgnoreCase(status)) {
                    statusClass = "status-done";
                    statusText = "Завершён";
                } else if ("pending".equalsIgnoreCase(status)) {
                    statusText = "Ожидает обработки";
                }

                String deliveryText;
                if ("delivery".equalsIgnoreCase(s.getDeliveryMethod())) {
                    deliveryText = "Отправьте товар через ПВЗ: " +
                            (s.getPickupPoint() != null ? s.getPickupPoint() : "(пункт не указан)");
                } else {
                    deliveryText = "Самовывоз. Свяжитесь с покупателем и договоритесь о встрече.";
                }
        %>

        <div class="order-card">
            <div class="order-main">
                <div class="order-title"><%= s.getAdTitle() %></div>

                <div class="order-meta">
                    Покупатель: <b><%= s.getBuyerName() %></b>
                </div>

                <div class="order-meta">
                    Дата: <b><%= s.getOrderDate() != null ? s.getOrderDate().toString() : "" %></b>
                </div>

                <div class="order-meta">
                    <%= deliveryText %>
                </div>

                <div class="order-status <%= statusClass %>">
                    Статус: <%= statusText %>
                </div>
            </div>

            <div class="order-actions">
                <div class="order-amount">
                    <%= s.getTotalAmount() != null ? s.getTotalAmount().toString() + " ₽" : "" %>
                </div>
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