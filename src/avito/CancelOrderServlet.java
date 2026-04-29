package avito;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/cancel-order")
public class CancelOrderServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }
        int buyerId = (int) session.getAttribute("userId");

        String orderIdStr = req.getParameter("orderId");
        if (orderIdStr == null) {
            resp.sendRedirect("my-orders");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("my-orders");
            return;
        }

        try (Connection conn = DbUtil.getConnection()) {
            conn.setAutoCommit(false);

            try {
                int adId;
                String orderStatus;

                // 1. Берём заказ и проверяем, что он принадлежит этому пользователю
                //    и ещё в статусе pending
                String selectSql =
                        "SELECT ADVERTISEMENT_ID, STATUS " + // <-- только STATUS, без AD_STATUS
                                "FROM ORDERS " +
                                "WHERE ID = ? AND BUYER_ID = ?";

                try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, buyerId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            conn.rollback();
                            resp.sendRedirect("my-orders");
                            return;
                        }
                        adId = rs.getInt("ADVERTISEMENT_ID");
                        orderStatus = rs.getString("STATUS");
                    }
                }

                // если уже не pending — не трогаем
                if (!"pending".equalsIgnoreCase(orderStatus)) {
                    conn.rollback();
                    resp.sendRedirect("my-orders");
                    return;
                }

                // 2. Ставим заказу статус cancelled
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE ORDERS SET STATUS = 'cancelled' WHERE ID = ?")) {
                    ps.setInt(1, orderId);
                    ps.executeUpdate();
                }

                // 3. Возвращаем объявление в активные (товар снова можно купить)
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE ADVERTISEMENTS SET STATUS = 'active' WHERE ID = ?")) {
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
            throw new ServletException("Ошибка при отмене заказа", e);
        }

        resp.sendRedirect("my-orders");
    }
}
