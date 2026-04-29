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
import java.sql.SQLException;

@WebServlet("/delete-favorite")
public class DeleteFavoriteServlet extends HttpServlet {

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
        String from = req.getParameter("from"); // откуда вызвали

        if (idStr == null) {
            resp.sendRedirect("favorites");
            return;
        }

        int adId;
        try {
            adId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect("favorites");
            return;
        }

        String sql = "DELETE FROM FAVORITES WHERE USER_ID = ? AND ADVERTISEMENT_ID = ?";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, adId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new ServletException("Ошибка при удалении из избранного", e);
        }

        if ("view".equals(from)) {
            // вернуться на объявление + сообщение
            resp.sendRedirect("view-ad?id=" + adId + "&fav=removed");
        } else {
            resp.sendRedirect("favorites");
        }
    }
}











//База данных
//
//Таблица ADVERTISEMENTS
//
//Добавляешь новый столбец, например:
//
//ALTER TABLE ADVERTISEMENTS
//ADD SIZE VARCHAR(50);
//
//
//Это можно сделать в RedExpert. После этого у объявления появляется новое поле SIZE.
//
//        2. JSP-страница создания объявления
//
//Файл: create_ad.jsp
//
//В форму добавляешь новое поле, например после цены/состояния:
//
//<label for="size">Размер</label>
//<input type="text" id="size" name="size" placeholder="Например, 48, L, 42.5">
//
//
//Главное – name="size": по этому имени сервлет заберёт параметр.
//
//        3. Сервлет CreateAdServlet
//
//Файл: CreateAdServlet.java
//
//Считать параметр:
//
//String size = req.getParameter("size");
//
//
//Добавить его в SQL-вставку:
//
//Сейчас у тебя что-то вроде:
//
//String sql =
//        "INSERT INTO ADVERTISEMENTS " +
//                "(USER_ID, TITLE, DESCRIPTION, PRICE, CATEGORY_ID, STATUS, " +
//                " PUBLICATION_DATE, LOCATION, CONDITION, DELIVERY_METHOD) " +
//                "VALUES (?, ?, ?, ?, ?, 'active', CURRENT_TIMESTAMP, ?, ?, ?) " +
//                "RETURNING ID";
//
//
//Нужно добавить SIZE:
//
//String sql =
//        "INSERT INTO ADVERTISEMENTS " +
//                "(USER_ID, TITLE, DESCRIPTION, PRICE, CATEGORY_ID, STATUS, " +
//                " PUBLICATION_DATE, LOCATION, CONDITION, DELIVERY_METHOD, SIZE) " +
//                "VALUES (?, ?, ?, ?, ?, 'active', CURRENT_TIMESTAMP, ?, ?, ?, ?) " +
//                "RETURNING ID";
//
//
//И не забыть дополнительный ps.setString(...):
//
//        ps.setInt(1, userId);
//ps.setString(2, title);
//ps.setString(3, description);
//ps.setDouble(4, price);
//ps.setInt(5, categoryId);
//ps.setString(6, location);
//ps.setString(7, condition);
//ps.setString(8, delivery);
//ps.setString(9, size);   // новый параметр
//
//4. Просмотр объявления
//ViewAdServlet
//
//Нужно добавить чтение поля SIZE из результата:
//
//String size = rs.getString("SIZE");
//req.setAttribute("size", size);
//
//view_ad.jsp
//
//Показать размер в блоке «Характеристики», например:
//
//<tr>
//    <td>Размер</td>
//    <td><b><%= (String) request.getAttribute("size") %></b></td>
//</tr>
//
//        5. (Опционально) Фильтр по размеру
//
//Если экзаменатор спросит про фильтр:
//
//В home.jsp добавить поле size в форму.
//
//В HomeServlet:
//
//считать size из request,
//
//добавить условие в SQL: AND UPPER(a.SIZE) LIKE ?,
//
//передать параметр в PreparedStatement.