package avito.controller;

import avito.util.DbUtil;
import avito.util.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String login    = req.getParameter("login");
        String password = req.getParameter("password");
        String name     = req.getParameter("name");
        String phone    = req.getParameter("phone");
        String city     = req.getParameter("city");

        try (Connection conn = DbUtil.getConnection()) {


            try (PreparedStatement check = conn.prepareStatement(
                    "SELECT ID FROM USERS WHERE LOGIN = ?")) {
                check.setString(1, login);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        req.setAttribute("error", "Такой логин уже существует");
                        req.getRequestDispatcher("/register.jsp").forward(req, resp);
                        return;
                    }
                }
            }


            String sql = "INSERT INTO USERS (LOGIN, PASSWORD, NAME, CITY, PHONE) " +
                    "VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {

                String passwordHash = PasswordUtil.hashPassword(password);

                ps.setString(1, login);
                ps.setString(2, passwordHash);
                ps.setString(3, name);
                ps.setString(4, city);
                ps.setString(5, phone);

                ps.executeUpdate();
            }


            resp.sendRedirect("login");

        } catch (SQLException e) {
            throw new ServletException("Ошибка при регистрации", e);
        }
    }
}
