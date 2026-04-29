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

@WebServlet("/my-ads")
public class MyAdsServlet extends HttpServlet {

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

        String sql = "SELECT ID, TITLE, PRICE, LOCATION " +
                "FROM ADVERTISEMENTS " +
                "WHERE USER_ID = ? AND STATUS IN ('active', 'reserved')" +
                "ORDER BY PUBLICATION_DATE DESC";



        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("ID");
                    String title = rs.getString("TITLE");
                    double price = rs.getDouble("PRICE");
                    String location = rs.getString("LOCATION");

                    ads.add(new Advertisement(id, title, price, location));
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Ошибка при загрузке ваших объявлений", e);
        }

        req.setAttribute("ads", ads);
        req.getRequestDispatcher("/my_ads.jsp").forward(req, resp);
    }
}
