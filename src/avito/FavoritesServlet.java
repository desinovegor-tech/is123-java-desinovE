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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/favorites")
public class FavoritesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        List<Advertisement> ads = new ArrayList<>();

        String sql =
                "SELECT a.ID, a.TITLE, a.PRICE, a.LOCATION, " +
                        "       (SELECT FIRST 1 p.IMAGE_URL " +
                        "          FROM ADVERTISEMENT_PHOTOS p " +
                        "         WHERE p.ADVERTISEMENT_ID = a.ID " +
                        "         ORDER BY p.SORT_ORDER) AS MAIN_PHOTO " +
                        "FROM FAVORITES f " +
                        "JOIN ADVERTISEMENTS a ON f.ADVERTISEMENT_ID = a.ID " +
                        "WHERE f.USER_ID = ? " +
                        "ORDER BY f.ADDED_DATE DESC";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("ID");
                    String title = rs.getString("TITLE");
                    double price = rs.getDouble("PRICE");
                    String location = rs.getString("LOCATION");
                    String mainPhoto = rs.getString("MAIN_PHOTO");

                    // используем расширенный конструктор с фото
                    ads.add(new Advertisement(id, title, price, location, mainPhoto));
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Ошибка при загрузке избранных объявлений", e);
        }

        req.setAttribute("ads", ads);
        req.getRequestDispatcher("/favorites.jsp").forward(req, resp);
    }
}
