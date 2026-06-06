package avito.controller;

import avito.util.DbUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/my-orders")
public class MyOrdersServlet extends HttpServlet {

    // Заказы, где пользователь — покупатель
    public static class OrderView {
        private int id;
        private String adTitle;
        private String sellerName;
        private Timestamp orderDate;
        private String deliveryMethod;
        private String paymentMethod;
        private String status;
        private BigDecimal totalAmount;

        // геттеры/сеттеры
        public int getId() { return id; }
        public void setId(int id) { this.id = id; }

        public String getAdTitle() { return adTitle; }
        public void setAdTitle(String adTitle) { this.adTitle = adTitle; }

        public String getSellerName() { return sellerName; }
        public void setSellerName(String sellerName) { this.sellerName = sellerName; }

        public Timestamp getOrderDate() { return orderDate; }
        public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

        public String getDeliveryMethod() { return deliveryMethod; }
        public void setDeliveryMethod(String deliveryMethod) { this.deliveryMethod = deliveryMethod; }

        public String getPaymentMethod() { return paymentMethod; }
        public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public BigDecimal getTotalAmount() { return totalAmount; }
        public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    }

    // Заказы, где пользователь — продавец
    public static class SellerOrderView {
        private int id;
        private String adTitle;
        private String buyerName;
        private Timestamp orderDate;
        private String deliveryMethod;
        private String pickupPoint;
        private String status;
        private BigDecimal totalAmount;

        public int getId() { return id; }
        public void setId(int id) { this.id = id; }

        public String getAdTitle() { return adTitle; }
        public void setAdTitle(String adTitle) { this.adTitle = adTitle; }

        public String getBuyerName() { return buyerName; }
        public void setBuyerName(String buyerName) { this.buyerName = buyerName; }

        public Timestamp getOrderDate() { return orderDate; }
        public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

        public String getDeliveryMethod() { return deliveryMethod; }
        public void setDeliveryMethod(String deliveryMethod) { this.deliveryMethod = deliveryMethod; }

        public String getPickupPoint() { return pickupPoint; }
        public void setPickupPoint(String pickupPoint) { this.pickupPoint = pickupPoint; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public BigDecimal getTotalAmount() { return totalAmount; }
        public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }
        int userId = (int) session.getAttribute("userId");

        List<OrderView> buyerOrders = new ArrayList<>();
        List<SellerOrderView> sellerOrders = new ArrayList<>();

        try (Connection conn = DbUtil.getConnection()) {

            // ----- Я ПОКУПАТЕЛЬ -----
            String sqlBuyer =
                    "SELECT o.ID, a.TITLE, u.NAME AS SELLER_NAME, o.ORDER_DATE, " +
                            "       o.DELIVERY_METHOD, o.PAYMENT_METHOD, o.STATUS, o.TOTAL_AMOUNT " +
                            "FROM ORDERS o " +
                            "JOIN ADVERTISEMENTS a ON o.ADVERTISEMENT_ID = a.ID " +
                            "JOIN USERS u ON a.USER_ID = u.ID " +
                            "WHERE o.BUYER_ID = ? " +
                            "ORDER BY o.ORDER_DATE DESC";

            try (PreparedStatement ps = conn.prepareStatement(sqlBuyer)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        OrderView v = new OrderView();
                        v.setId(rs.getInt("ID"));
                        v.setAdTitle(rs.getString("TITLE"));
                        v.setSellerName(rs.getString("SELLER_NAME"));
                        v.setOrderDate(rs.getTimestamp("ORDER_DATE"));
                        v.setDeliveryMethod(rs.getString("DELIVERY_METHOD"));
                        v.setPaymentMethod(rs.getString("PAYMENT_METHOD"));
                        v.setStatus(rs.getString("STATUS"));
                        v.setTotalAmount(rs.getBigDecimal("TOTAL_AMOUNT"));
                        buyerOrders.add(v);
                    }
                }
            }

            // ----- Я ПРОДАВЕЦ -----
            String sqlSeller =
                    "SELECT o.ID, a.TITLE, u.NAME AS BUYER_NAME, o.ORDER_DATE, " +
                            "       o.DELIVERY_METHOD, o.PICKUP_POINT, o.STATUS, o.TOTAL_AMOUNT " +
                            "FROM ORDERS o " +
                            "JOIN ADVERTISEMENTS a ON o.ADVERTISEMENT_ID = a.ID " +
                            "JOIN USERS u ON o.BUYER_ID = u.ID " +
                            "WHERE a.USER_ID = ? " +
                            "ORDER BY o.ORDER_DATE DESC";

            try (PreparedStatement ps = conn.prepareStatement(sqlSeller)) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        SellerOrderView v = new SellerOrderView();
                        v.setId(rs.getInt("ID"));
                        v.setAdTitle(rs.getString("TITLE"));
                        v.setBuyerName(rs.getString("BUYER_NAME"));
                        v.setOrderDate(rs.getTimestamp("ORDER_DATE"));
                        v.setDeliveryMethod(rs.getString("DELIVERY_METHOD"));
                        v.setPickupPoint(rs.getString("PICKUP_POINT"));
                        v.setStatus(rs.getString("STATUS"));
                        v.setTotalAmount(rs.getBigDecimal("TOTAL_AMOUNT"));
                        sellerOrders.add(v);
                    }
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Ошибка при загрузке заказов", e);
        }

        req.setAttribute("orders", buyerOrders);
        req.setAttribute("sales", sellerOrders);
        req.getRequestDispatcher("/my_orders.jsp").forward(req, resp);
    }

    // doPost с отменой заказа оставь таким, как он у тебя уже есть
}
