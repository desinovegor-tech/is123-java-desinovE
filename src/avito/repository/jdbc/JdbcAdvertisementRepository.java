package avito.repository.jdbc;

import avito.model.Advertisement;
import avito.repository.interfaces.AdvertisementRepository;
import avito.util.DbUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JdbcAdvertisementRepository implements AdvertisementRepository {

    @Override
    public Advertisement findById(int id) {
        String sql = "SELECT ID, USER_ID, TITLE, DESCRIPTION, PRICE, CATEGORY_ID, STATUS, " +
                "PUBLICATION_DATE, LOCATION, CONDITION, DELIVERY_METHOD " +
                "FROM ADVERTISEMENTS WHERE ID = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAdvertisement(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при поиске объявления по ID", e);
        }

        return null;
    }

    @Override
    public List<Advertisement> findAllActive() {
        List<Advertisement> advertisements = new ArrayList<>();

        String sql = "SELECT ID, USER_ID, TITLE, DESCRIPTION, PRICE, CATEGORY_ID, STATUS, " +
                "PUBLICATION_DATE, LOCATION, CONDITION, DELIVERY_METHOD " +
                "FROM ADVERTISEMENTS WHERE STATUS = 'active' ORDER BY PUBLICATION_DATE DESC";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                advertisements.add(mapAdvertisement(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при получении активных объявлений", e);
        }

        return advertisements;
    }

    @Override
    public List<Advertisement> findByUserId(int userId) {
        List<Advertisement> advertisements = new ArrayList<>();

        String sql = "SELECT ID, USER_ID, TITLE, DESCRIPTION, PRICE, CATEGORY_ID, STATUS, " +
                "PUBLICATION_DATE, LOCATION, CONDITION, DELIVERY_METHOD " +
                "FROM ADVERTISEMENTS WHERE USER_ID = ? ORDER BY PUBLICATION_DATE DESC";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    advertisements.add(mapAdvertisement(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при получении объявлений пользователя", e);
        }

        return advertisements;
    }

    @Override
    public int save(Advertisement advertisement) {
        String sql = "INSERT INTO ADVERTISEMENTS " +
                "(USER_ID, TITLE, DESCRIPTION, PRICE, CATEGORY_ID, STATUS, PUBLICATION_DATE, LOCATION, CONDITION, DELIVERY_METHOD) " +
                "VALUES (?, ?, ?, ?, ?, 'active', CURRENT_TIMESTAMP, ?, ?, ?) RETURNING ID";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, advertisement.getUserId());
            ps.setString(2, advertisement.getTitle());
            ps.setString(3, advertisement.getDescription());
            ps.setDouble(4, advertisement.getPrice());
            ps.setInt(5, advertisement.getCategoryId());
            ps.setString(6, advertisement.getLocation());
            ps.setString(7, advertisement.getCondition());
            ps.setString(8, advertisement.getDeliveryMethod());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при сохранении объявления", e);
        }

        return 0;
    }

    @Override
    public void updateStatus(int advertisementId, String status) {
        String sql = "UPDATE ADVERTISEMENTS SET STATUS = ? WHERE ID = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, advertisementId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при обновлении статуса объявления", e);
        }
    }

    @Override
    public void deleteById(int advertisementId) {
        updateStatus(advertisementId, "archived");
    }

    private Advertisement mapAdvertisement(ResultSet rs) throws SQLException {
        Advertisement advertisement = new Advertisement();

        advertisement.setId(rs.getInt("ID"));
        advertisement.setUserId(rs.getInt("USER_ID"));
        advertisement.setTitle(rs.getString("TITLE"));
        advertisement.setDescription(rs.getString("DESCRIPTION"));
        advertisement.setPrice(rs.getDouble("PRICE"));
        advertisement.setCategoryId(rs.getInt("CATEGORY_ID"));
        advertisement.setStatus(rs.getString("STATUS"));
        advertisement.setPublicationDate(rs.getTimestamp("PUBLICATION_DATE"));
        advertisement.setLocation(rs.getString("LOCATION"));
        advertisement.setCondition(rs.getString("CONDITION"));
        advertisement.setDeliveryMethod(rs.getString("DELIVERY_METHOD"));

        return advertisement;
    }
}