package avito;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        String adIdStr = req.getParameter("adId");
        if (adIdStr == null) {
            resp.sendRedirect("home");
            return;
        }

        int adId;
        try {
            adId = Integer.parseInt(adIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("home");
            return;
        }

        String title = null;
        BigDecimal price = null;
        String deliveryMethod = null;
        int sellerId = -1;
        String adStatus = null;

        try (Connection conn = DbUtil.getConnection()) {

            String sql =
                    "SELECT TITLE, PRICE, DELIVERY_METHOD, USER_ID, " +
                            "       STATUS AS AD_STATUS " +        // <--- алиас, а не новый столбец
                            "FROM ADVERTISEMENTS " +
                            "WHERE ID = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, adId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        title          = rs.getString("TITLE");
                        price          = rs.getBigDecimal("PRICE");
                        deliveryMethod = rs.getString("DELIVERY_METHOD");
                        sellerId       = rs.getInt("USER_ID");
                        adStatus       = rs.getString("AD_STATUS"); // читаем по алиасу
                    } else {
                        resp.sendRedirect("home");
                        return;
                    }
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Ошибка при загрузке объявления для заказа", e);
        }

        int currentUserId = (int) session.getAttribute("userId");
        if (currentUserId == sellerId) {
            resp.sendRedirect("view-ad?id=" + adId);
            return;
        }

        // если товар зарезервирован – не даём оформить ещё один заказ
        if ("reserved".equalsIgnoreCase(adStatus)) {
            resp.sendRedirect("view-ad?id=" + adId);
            return;
        }

        req.setAttribute("adId", adId);
        req.setAttribute("title", title);
        req.setAttribute("price", price);
        req.setAttribute("deliveryMethod", deliveryMethod);

        req.getRequestDispatcher("/order.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }
        int buyerId = (int) session.getAttribute("userId");

        req.setCharacterEncoding("UTF-8");

        String adIdStr       = req.getParameter("adId");
        String delivery      = req.getParameter("deliveryMethod");
        String payment       = req.getParameter("paymentMethod");
        String pickupPoint   = req.getParameter("pickupPoint");
        String deliveryPrice = req.getParameter("deliveryPrice");

        if (adIdStr == null || delivery == null || payment == null) {
            resp.sendRedirect("home");
            return;
        }

        int adId;
        try {
            adId = Integer.parseInt(adIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("home");
            return;
        }

        BigDecimal itemPrice;
        BigDecimal deliveryCost = BigDecimal.ZERO;
        if (deliveryPrice != null && !deliveryPrice.isEmpty()) {
            try {
                deliveryCost = new BigDecimal(deliveryPrice);
            } catch (NumberFormatException ignored) {
                deliveryCost = BigDecimal.ZERO;
            }
        }

        try (Connection conn = DbUtil.getConnection()) {

            conn.setAutoCommit(false);
            try {
                // 1. Проверяем актуальное состояние объявления
                String adStatusNow;

                try (PreparedStatement ps = conn.prepareStatement(
                        "SELECT PRICE, STATUS AS AD_STATUS " +  // опять алиас
                                "FROM ADVERTISEMENTS WHERE ID = ?")) {
                    ps.setInt(1, adId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            resp.sendRedirect("home");
                            return;
                        }
                        itemPrice   = rs.getBigDecimal("PRICE");
                        adStatusNow = rs.getString("AD_STATUS");
                    }
                }

                if ("reserved".equalsIgnoreCase(adStatusNow)) {
                    conn.rollback();
                    resp.sendRedirect("view-ad?id=" + adId);
                    return;
                }

                // 2. Создаём заказ
                BigDecimal totalAmount = itemPrice.add(deliveryCost);

                String sql = "INSERT INTO ORDERS " +
                        "(ADVERTISEMENT_ID, BUYER_ID, ORDER_DATE, DELIVERY_METHOD, " +
                        " PAYMENT_METHOD, STATUS, TOTAL_AMOUNT, PICKUP_POINT) " +
                        "VALUES (?, ?, CURRENT_TIMESTAMP, ?, ?, 'pending', ?, ?)";

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, adId);
                    ps.setInt(2, buyerId);
                    ps.setString(3, delivery);
                    ps.setString(4, payment);
                    ps.setBigDecimal(5, totalAmount);
                    ps.setString(6, pickupPoint);
                    ps.executeUpdate();
                }

                // 3. Помечаем объявление как зарезервированное
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE ADVERTISEMENTS " +
                                "SET STATUS = 'reserved' " +    // <--- обновляем реальный столбец STATUS
                                "WHERE ID = ?")) {
                    ps.setInt(1, adId);
                    ps.executeUpdate();
                }

                conn.commit();

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (SQLException e) {
            throw new ServletException("Ошибка при оформлении заказа", e);
        }

        resp.sendRedirect("my-orders");
    }
}
