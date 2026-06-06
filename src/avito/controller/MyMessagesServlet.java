package avito;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/my-messages")
public class MyMessagesServlet extends HttpServlet {

    // Один “чат” по объявлению
    public static class ConversationItem {
        private final int adId;
        private final String adTitle;
        private final String lastText;
        private final Timestamp lastDateTime;

        public ConversationItem(int adId, String adTitle,
                                String lastText, Timestamp lastDateTime) {
            this.adId = adId;
            this.adTitle = adTitle;
            this.lastText = lastText;
            this.lastDateTime = lastDateTime;
        }

        public int getAdId() { return adId; }
        public String getAdTitle() { return adTitle; }
        public String getLastText() { return lastText; }
        public Timestamp getLastDateTime() { return lastDateTime; }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }
        int userId = (int) session.getAttribute("userId");

        // LinkedHashMap, чтобы сохранить порядок (по дате)
        Map<Integer, ConversationItem> convMap = new LinkedHashMap<>();

        String sql =
                "SELECT m.ADVERTISEMENT_ID, a.TITLE, " +
                        "       m.MESSAGE_TEXT, m.MESSAGE_DATE, m.MESSAGE_TIME " +
                        "FROM MESSAGES m " +
                        "JOIN ADVERTISEMENTS a ON m.ADVERTISEMENT_ID = a.ID " +
                        "WHERE m.SENDER_ID = ? OR m.RECEIVER_ID = ? " +
                        "ORDER BY m.MESSAGE_DATE DESC, m.MESSAGE_TIME DESC";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int adId = rs.getInt("ADVERTISEMENT_ID");

                    // Сообщения отсортированы DESC,
                    // первое для adId — самое свежее
                    if (convMap.containsKey(adId)) {
                        continue;
                    }

                    String adTitle = rs.getString("TITLE");
                    String text = rs.getString("MESSAGE_TEXT");

                    java.sql.Date d = rs.getDate("MESSAGE_DATE");
                    java.sql.Time t = rs.getTime("MESSAGE_TIME");
                    Timestamp dt = null;
                    if (d != null && t != null) {
                        dt = Timestamp.valueOf(d.toString() + " " + t.toString());
                    }

                    ConversationItem item =
                            new ConversationItem(adId, adTitle, text, dt);
                    convMap.put(adId, item);
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Ошибка при загрузке списка чатов", e);
        }

        List<ConversationItem> conversations =
                new ArrayList<>(convMap.values());

        req.setAttribute("conversations", conversations);
        req.getRequestDispatcher("/my_messages.jsp").forward(req, resp);
    }
}
