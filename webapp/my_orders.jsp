<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.MyOrdersServlet.OrderView" %>
<%@ page import="avito.MyOrdersServlet.SellerOrderView" %>

<%
    List<OrderView> buyerOrders =
            (List<OrderView>) request.getAttribute("orders");
    List<SellerOrderView> sellerOrders =
            (List<SellerOrderView>) request.getAttribute("sales");
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Мои заказы</title>
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
        a:hover { text-decoration: underline; }

        .layout {
            max-width: 1100px;
            margin: 0 auto;
            padding: 20px 15px 40px;
        }
        .page-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            margin: 20px 0 10px;
        }

        .order-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .order-card {
            background: #fff;
            border-radius: 8px;
            padding: 12px 15px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.06);
            display: flex;
            justify-content: space-between;
            gap: 15px;
            font-size: 14px;
        }

        .order-main {
            flex: 1;
        }

        .order-title {
            font-size: 15px;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .order-meta {
            color: #777;
            margin-bottom: 2px;
        }

        .order-status {
            margin-top: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        .status-pending { color: #f39c12; }
        .status-cancelled { color: #e74c3c; }
        .status-done { color: #2ecc71; }

        .order-amount {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .order-actions {
            text-align: right;
            min-width: 140px;
        }
        .btn-secondary {
            border: 1px solid #ccc;
            border-radius: 6px;
            background: #fff;
            padding: 6px 10px;
            font-size: 13px;
            cursor: pointer;
        }
        .btn-danger {
            border-color: #e74c3c;
            color: #e74c3c;
        }
        .btn-danger:hover {
            background: #fdecea;
        }

        .empty-text {
            padding: 12px 15px;
            background: #fff;
            border-radius: 8px;
            color: #777;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div class="layout">

    <p><a href="home">← К объявлениям</a></p>

    <div class="page-title">Мои заказы</div>

    <!-- Я покупатель -->
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
                if ("cancelled".equalsIgnoreCase(status)) {
                    statusClass = "status-cancelled";
                } else if ("done".equalsIgnoreCase(status)) {
                    statusClass = "status-done";
                }
        %>
        <div class="order-card">
            <div class="order-main">
                <div class="order-title"><%= o.getAdTitle() %></div>
                <div class="order-meta">
                    Продавец: <%= o.getSellerName() %>
                </div>
                <div class="order-meta">
                    Дата: <%= o.getOrderDate() != null ? o.getOrderDate().toString() : "" %>
                </div>
                <div class="order-meta">
                    Доставка:
                    <%= "pickup".equalsIgnoreCase(o.getDeliveryMethod()) ? "самовывоз" : "через ПВЗ" %>,
                    оплата: <%= o.getPaymentMethod() %>
                </div>
                <div class="order-status <%= statusClass %>">
                    Статус: <%= status %>
                </div>
            </div>
            <div class="order-actions">
                <div class="order-amount">
                    <%= o.getTotalAmount() != null ? o.getTotalAmount().toString() + " ₽" : "" %>
                </div>

                <% if (!"cancelled".equalsIgnoreCase(status)) { %>
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

    <!-- Я продавец -->
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
                if ("cancelled".equalsIgnoreCase(status)) {
                    statusClass = "status-cancelled";
                } else if ("done".equalsIgnoreCase(status)) {
                    statusClass = "status-done";
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
                    Покупатель: <%= s.getBuyerName() %>
                </div>
                <div class="order-meta">
                    Дата: <%= s.getOrderDate() != null ? s.getOrderDate().toString() : "" %>
                </div>
                <div class="order-meta">
                    <%= deliveryText %>
                </div>
                <div class="order-status <%= statusClass %>">
                    Статус: <%= status %>
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
