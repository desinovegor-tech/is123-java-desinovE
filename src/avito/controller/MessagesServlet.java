package avito.controller;

import avito.util.DbUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/messages")
public class MessagesServlet extends HttpServlet {


    public static class MessageView {
        private final int id;
        private final int senderId;
        private final String senderName;
        private final String text;
        private final LocalDate date;
        private final LocalTime time;

        public MessageView(int id, int senderId, String senderName,
                           String text, LocalDate date, LocalTime time) {
            this.id = id;
            this.senderId = senderId;
            this.senderName = senderName;
            this.text = text;
            this.date = date;
            this.time = time;
        }

        public int getId() { return id; }
        public int getSenderId() { return senderId; }
        public String getSenderName() { return senderName; }
        public String getText() { return text; }
        public String getDateTimeStr() { return date + " " + time; }
    }

    // Показать чат
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }
        int currentUserId = (Integer) session.getAttribute("userId");

        String adIdStr = req.getParameter("adId");
        if (adIdStr == null) {
            resp.sendRedirect("home");
            return;
        }
        int adId = Integer.parseInt(adIdStr);

        String adTitle;
        int sellerId;
        String sellerName;

        try (Connection conn = DbUtil.getConnection()) {


            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT a.TITLE, u.ID AS SELLER_ID, u.NAME AS SELLER_NAME " +
                            "FROM ADVERTISEMENTS a " +
                            "JOIN USERS u ON u.ID = a.USER_ID " +
                            "WHERE a.ID = ?")) {

                ps.setInt(1, adId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        resp.sendRedirect("home");
                        return;
                    }
                    adTitle   = rs.getString("TITLE");
                    sellerId  = rs.getInt("SELLER_ID");
                    sellerName = rs.getString("SELLER_NAME");
                }
            }

            // Все сообщения по объявлению, где участвует текущий пользователь
            List<MessageView> list = new ArrayList<>();

            String sql =
                    "SELECT m.ID, m.SENDER_ID, u.NAME AS SENDER_NAME, " +
                            "       m.MESSAGE_TEXT, m.MESSAGE_DATE, m.MESSAGE_TIME " +
                            "FROM MESSAGES m " +
                            "JOIN USERS u ON u.ID = m.SENDER_ID " +
                            "WHERE m.ADVERTISEMENT_ID = ? " +
                            "  AND (m.SENDER_ID = ? OR m.RECEIVER_ID = ?) " +
                            "ORDER BY m.MESSAGE_DATE, m.MESSAGE_TIME";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, adId);
                ps.setInt(2, currentUserId);
                ps.setInt(3, currentUserId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int id        = rs.getInt("ID");
                        int senderId  = rs.getInt("SENDER_ID");
                        String sName  = rs.getString("SENDER_NAME");
                        String text   = rs.getString("MESSAGE_TEXT");
                        LocalDate date = rs.getDate("MESSAGE_DATE").toLocalDate();
                        LocalTime time = rs.getTime("MESSAGE_TIME").toLocalTime();

                        list.add(new MessageView(id, senderId, sName, text, date, time));
                    }
                }
            }

            req.setAttribute("adId", adId);
            req.setAttribute("adTitle", adTitle);
            req.setAttribute("sellerName", sellerName);
            req.setAttribute("messages", list);

            getServletContext()
                    .getRequestDispatcher("/messages.jsp")
                    .forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Ошибка при загрузке сообщений", e);
        }
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }
        int currentUserId = (Integer) session.getAttribute("userId");

        req.setCharacterEncoding("UTF-8");

        String adIdStr = req.getParameter("adId");
        String text    = req.getParameter("text");

        if (adIdStr == null || text == null || text.trim().isEmpty()) {
            resp.sendRedirect("home");
            return;
        }
        int adId = Integer.parseInt(adIdStr);

        try (Connection conn = DbUtil.getConnection()) {

            // Ищем продавца объявления — ему и пишем
            int sellerId;
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT USER_ID FROM ADVERTISEMENTS WHERE ID = ?")) {
                ps.setInt(1, adId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        resp.sendRedirect("home");
                        return;
                    }
                    sellerId = rs.getInt("USER_ID");
                }
            }

            int receiverId = sellerId;

            String sql =
                    "INSERT INTO MESSAGES " +
                            " (SENDER_ID, RECEIVER_ID, ADVERTISEMENT_ID, " +
                            "  MESSAGE_TEXT, MESSAGE_DATE, MESSAGE_TIME, IS_READ) " +
                            "VALUES (?, ?, ?, ?, CURRENT_DATE, CURRENT_TIME, FALSE)";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, currentUserId);
                ps.setInt(2, receiverId);
                ps.setInt(3, adId);
                ps.setString(4, text);
                ps.executeUpdate();
            }

        } catch (SQLException e) {
            throw new ServletException("Ошибка при отправке сообщения", e);
        }

        resp.sendRedirect("messages?adId=" + adId);
    }
}
