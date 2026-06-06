package avito.controller;

import avito.util.DbUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/add-favorite")
public class AddFavoriteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String idStr = req.getParameter("id");
        String from = req.getParameter("from"); // "view", "favorites", "home"

        if (idStr == null) {
            resp.sendRedirect("home");
            return;
        }

        int adId;
        try {
            adId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("home");
            return;
        }

        String sql = "INSERT INTO FAVORITES (USER_ID, ADVERTISEMENT_ID, ADDED_DATE) " +
                "VALUES (?, ?, CURRENT_TIMESTAMP)";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, adId);
            ps.executeUpdate();

        } catch (SQLException e) {
            // если уже есть в избранном (уникальный индекс), можно тихо проигнорировать
            // e.printStackTrace();
        }

        // --- КУДА ВОЗВРАЩАЕМСЯ ---
        if ("view".equals(from)) {
            // остаёмся на странице объявления + показываем сообщение
            resp.sendRedirect("view-ad?id=" + adId + "&fav=added");
        } else if ("favorites".equals(from)) {
            resp.sendRedirect("favorites");
        } else {
            resp.sendRedirect("home");
        }
    }
}
