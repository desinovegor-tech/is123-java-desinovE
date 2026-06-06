package avito;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/view-ad")
public class ViewAdServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr == null) {
            req.getRequestDispatcher("/view_ad.jsp").forward(req, resp);
            return;
        }

        int adId;
        try {
            adId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            req.getRequestDispatcher("/view_ad.jsp").forward(req, resp);
            return;
        }

        String sql =
                "SELECT a.ID, a.TITLE, a.DESCRIPTION, a.PRICE, a.LOCATION, " +
                        "       a.CONDITION, a.DELIVERY_METHOD, a.PUBLICATION_DATE, " +
                        "       a.STATUS AS AD_STATUS, " +             // <<< АЛИАС ДЛЯ СТАТУСА
                        "       a.USER_ID AS SELLER_ID, " +
                        "       u.NAME AS SELLER_NAME, u.CITY AS SELLER_CITY, " +
                        "       c.NAME AS CATEGORY_NAME " +
                        "FROM ADVERTISEMENTS a " +
                        "JOIN USERS u ON a.USER_ID = u.ID " +
                        "LEFT JOIN CATEGORIES c ON a.CATEGORY_ID = c.ID " +
                        "WHERE a.ID = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    req.setAttribute("title", rs.getString("TITLE"));
                    req.setAttribute("description", rs.getString("DESCRIPTION"));
                    req.setAttribute("price", rs.getDouble("PRICE"));
                    req.setAttribute("location", rs.getString("LOCATION"));
                    req.setAttribute("condition", rs.getString("CONDITION"));
                    req.setAttribute("delivery", rs.getString("DELIVERY_METHOD"));
                    req.setAttribute("pubDate", rs.getTimestamp("PUBLICATION_DATE"));
                    req.setAttribute("sellerName", rs.getString("SELLER_NAME"));
                    req.setAttribute("sellerCity", rs.getString("SELLER_CITY"));
                    req.setAttribute("categoryName", rs.getString("CATEGORY_NAME"));
                    req.setAttribute("adId", adId);
                    req.setAttribute("sellerId", rs.getInt("SELLER_ID"));
                    // ВАЖНО: читаем именно AD_STATUS, как в алиасе
                    req.setAttribute("status", rs.getString("AD_STATUS"));
                }
            }

            // ---- грузим фотки ----
            List<String> photos = new ArrayList<>();
            try (PreparedStatement psPhoto = conn.prepareStatement(
                    "SELECT IMAGE_URL FROM ADVERTISEMENT_PHOTOS " +
                            "WHERE ADVERTISEMENT_ID = ? ORDER BY SORT_ORDER")) {
                psPhoto.setInt(1, adId);
                try (ResultSet rsP = psPhoto.executeQuery()) {
                    while (rsP.next()) {
                        photos.add(rsP.getString("IMAGE_URL"));
                    }
                }
            }
            req.setAttribute("photos", photos);

        } catch (SQLException e) {
            throw new ServletException("Ошибка при загрузке объявления", e);
        }

        req.getRequestDispatcher("/view_ad.jsp").forward(req, resp);
    }
}
