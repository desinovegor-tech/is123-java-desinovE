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

@WebServlet("/deactivate-ad")
public class DeleteAdServlet extends HttpServlet {

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

        if (idStr == null) {
            resp.sendRedirect("my-ads");
            return;
        }

        int adId;
        try {
            adId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("my-ads");
            return;
        }

        // вместо DELETE просто меняем статус
        String sql = "UPDATE ADVERTISEMENTS " +
                "SET STATUS = 'inactive' " +
                "WHERE ID = ? AND USER_ID = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adId);
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Ошибка при снятии объявления с публикации", e);
        }

        // возвращаемся в список своих объявлений
        resp.sendRedirect("my-ads");
    }
}
