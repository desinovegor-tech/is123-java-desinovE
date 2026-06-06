package avito.controller;

import avito.util.DbUtil;
import avito.util.PasswordUtil;
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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String login = req.getParameter("login");
        String password = req.getParameter("password");

        try (Connection conn = DbUtil.getConnection()) {

            String sql = "SELECT ID, \"PASSWORD\" FROM USERS WHERE LOGIN = ?";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, login);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String storedPassword = rs.getString("PASSWORD");


                        if (PasswordUtil.checkPassword(password, storedPassword)) {

                            HttpSession session = req.getSession();
                            session.setAttribute("userId", rs.getInt("ID"));
                            session.setAttribute("login", login);

                            resp.setContentType("text/html; charset=UTF-8");
                            resp.setCharacterEncoding("UTF-8");

                            resp.sendRedirect("home");
                            return;
                        }
                    }
                }
            }


            req.setAttribute("error", "Неверный логин или пароль");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Ошибка при авторизации", e);
        }
    }
}
