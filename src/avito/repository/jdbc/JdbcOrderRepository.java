package avito.repository.jdbc;

import avito.model.Order;
import avito.repository.interfaces.OrderRepository;
import avito.util.DbUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JdbcOrderRepository implements OrderRepository {

    @Override
    public Order findById(int id) {
        String sql = "SELECT ID, ADVERTISEMENT_ID, BUYER_ID, ORDER_DATE, DELIVERY_METHOD, " +
                "PICKUP_POINT, PAYMENT_METHOD, STATUS, TOTAL_AMOUNT " +
                "FROM ORDERS WHERE ID = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapOrder(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при поиске заказа по ID", e);
        }

        return null;
    }

    @Override
    public List<Order> findByBuyerId(int buyerId) {
        List<Order> orders = new ArrayList<>();

        String sql = "SELECT ID, ADVERTISEMENT_ID, BUYER_ID, ORDER_DATE, DELIVERY_METHOD, " +
                "PICKUP_POINT, PAYMENT_METHOD, STATUS, TOTAL_AMOUNT " +
                "FROM ORDERS WHERE BUYER_ID = ? ORDER BY ORDER_DATE DESC";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, buyerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrder(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при получении заказов пользователя", e);
        }

        return orders;
    }

    @Override
    public void save(Order order) {
        String sql = "INSERT INTO ORDERS " +
                "(ADVERTISEMENT_ID, BUYER_ID, ORDER_DATE, DELIVERY_METHOD, PICKUP_POINT, " +
                "PAYMENT_METHOD, STATUS, TOTAL_AMOUNT) " +
                "VALUES (?, ?, CURRENT_TIMESTAMP, ?, ?, ?, ?, ?)";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, order.getAdvertisementId());
            ps.setInt(2, order.getBuyerId());
            ps.setString(3, order.getDeliveryMethod());
            ps.setString(4, order.getPickupPoint());
            ps.setString(5, order.getPaymentMethod());
            ps.setString(6, order.getStatus());
            ps.setBigDecimal(7, order.getTotalAmount());

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при сохранении заказа", e);
        }
    }

    @Override
    public void cancelOrder(int orderId) {
        String sql = "UPDATE ORDERS SET STATUS = 'canceled' WHERE ID = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при отмене заказа", e);
        }
    }

    @Override
    public boolean existsActiveOrderForAdvertisement(int advertisementId) {
        String sql = "SELECT ID FROM ORDERS " +
                "WHERE ADVERTISEMENT_ID = ? AND STATUS <> 'canceled'";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, advertisementId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при проверке активного заказа", e);
        }
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();

        order.setId(rs.getInt("ID"));
        order.setAdvertisementId(rs.getInt("ADVERTISEMENT_ID"));
        order.setBuyerId(rs.getInt("BUYER_ID"));
        order.setOrderDate(rs.getTimestamp("ORDER_DATE"));
        order.setDeliveryMethod(rs.getString("DELIVERY_METHOD"));
        order.setPickupPoint(rs.getString("PICKUP_POINT"));
        order.setPaymentMethod(rs.getString("PAYMENT_METHOD"));
        order.setStatus(rs.getString("STATUS"));
        order.setTotalAmount(rs.getBigDecimal("TOTAL_AMOUNT"));

        return order;
    }
}