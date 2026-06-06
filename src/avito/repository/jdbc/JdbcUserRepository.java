package avito.repository.jdbc;

import avito.model.User;
import avito.repository.interfaces.UserRepository;
import avito.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class JdbcUserRepository implements UserRepository {

    @Override
    public User findByLogin(String login) {
        String sql = "SELECT ID, LOGIN, \"PASSWORD\", NAME, CITY, PHONE FROM USERS WHERE LOGIN = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, login);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при поиске пользователя по логину", e);
        }

        return null;
    }

    @Override
    public User findById(int id) {
        String sql = "SELECT ID, LOGIN, \"PASSWORD\", NAME, CITY, PHONE FROM USERS WHERE ID = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapUser(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при поиске пользователя по ID", e);
        }

        return null;
    }

    @Override
    public boolean existsByLogin(String login) {
        String sql = "SELECT ID FROM USERS WHERE LOGIN = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, login);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при проверке логина", e);
        }
    }

    @Override
    public void save(User user) {
        String sql = "INSERT INTO USERS (LOGIN, \"PASSWORD\", NAME, CITY, PHONE) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getLogin());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getName());
            ps.setString(4, user.getCity());
            ps.setString(5, user.getPhone());

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при сохранении пользователя", e);
        }
    }

    @Override
    public void updateProfile(int userId, String name, String city, String phone) {
        String sql = "UPDATE USERS SET NAME = ?, CITY = ?, PHONE = ? WHERE ID = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, city);
            ps.setString(3, phone);
            ps.setInt(4, userId);

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Ошибка при обновлении профиля", e);
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();

        user.setId(rs.getInt("ID"));
        user.setLogin(rs.getString("LOGIN"));
        user.setPassword(rs.getString("PASSWORD"));
        user.setName(rs.getString("NAME"));
        user.setCity(rs.getString("CITY"));
        user.setPhone(rs.getString("PHONE"));

        return user;
    }
}