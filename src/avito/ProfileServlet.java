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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT LOGIN, NAME, PHONE, CITY FROM USERS WHERE ID = ?")) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    req.setAttribute("login", rs.getString("LOGIN"));
                    req.setAttribute("name", rs.getString("NAME"));
                    req.setAttribute("phone", rs.getString("PHONE"));
                    req.setAttribute("city", rs.getString("CITY"));
                } else {
                    req.setAttribute("error", "Пользователь не найден");
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Ошибка при загрузке профиля", e);
        }

        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        String name  = req.getParameter("name");
        String phone = req.getParameter("phone");
        String city  = req.getParameter("city");

        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Имя не может быть пустым");
            // загрузим текущие данные и покажем ошибку
            doGet(req, resp);
            return;
        }

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "UPDATE USERS SET NAME = ?, PHONE = ?, CITY = ? WHERE ID = ?")) {

            ps.setString(1, name.trim());
            ps.setString(2, phone != null ? phone.trim() : null);
            ps.setString(3, city != null ? city.trim() : null);
            ps.setInt(4, userId);

            ps.executeUpdate();

            req.setAttribute("success", "Изменения сохранены");

        } catch (SQLException e) {
            req.setAttribute("error", "Ошибка при сохранении профиля: " + e.getMessage());
        }

        // снова показать профиль с обновлёнными данными
        doGet(req, resp);
    }
}
