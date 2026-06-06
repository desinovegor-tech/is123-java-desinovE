package avito;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/create-ad")
@MultipartConfig
public class CreateAdServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }

        List<Category> categories = new ArrayList<>();

        String sql = "SELECT ID, NAME FROM CATEGORIES ORDER BY NAME";

        try (Connection conn = DbUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("ID");
                String name = rs.getString("NAME");
                categories.add(new Category(id, name));
            }

        } catch (SQLException e) {
            throw new ServletException("Ошибка при загрузке категорий", e);
        }

        req.setAttribute("categories", categories);
        req.getRequestDispatcher("/create_ad.jsp").forward(req, resp);
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

        String title         = req.getParameter("title");
        String description   = req.getParameter("description");
        String priceStr      = req.getParameter("price");
        String location      = req.getParameter("location");
        String condition     = req.getParameter("condition");
        String delivery      = req.getParameter("delivery");
        String categoryIdStr = req.getParameter("categoryId");

        double price;
        try {
            price = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Некорректная цена");
            req.getRequestDispatcher("/create_ad.jsp").forward(req, resp);
            return;
        }

        int categoryId;
        try {
            categoryId = Integer.parseInt(categoryIdStr);
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Категория не выбрана");
            doGet(req, resp);
            return;
        }

        int adId = 0;


        try (Connection conn = DbUtil.getConnection()) {

            String sql =
                    "INSERT INTO ADVERTISEMENTS " +
                            " (USER_ID, TITLE, DESCRIPTION, PRICE, CATEGORY_ID, STATUS, " +
                            "  PUBLICATION_DATE, LOCATION, CONDITION, DELIVERY_METHOD) " +
                            "VALUES (?, ?, ?, ?, ?, 'active', CURRENT_TIMESTAMP, ?, ?, ?) " +
                            "RETURNING ID";

            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setString(2, title);
                ps.setString(3, description);
                ps.setDouble(4, price);
                ps.setInt(5, categoryId);
                ps.setString(6, location);
                ps.setString(7, condition);
                ps.setString(8, delivery);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        adId = rs.getInt(1);
                    }
                }
            }

            if (adId == 0) {
                throw new ServletException("Не удалось получить ID нового объявления");
            }

            try {
                String uploadDir = getServletContext().getRealPath("/uploads");
                Files.createDirectories(Paths.get(uploadDir));

                int sortOrder = 0;
                int photoCount = 0;

                for (Part part : req.getParts()) {
                    // берём только инпут name="photos"
                    if (!"photos".equals(part.getName())) {
                        continue;
                    }


                    if (photoCount >= 10) {
                        break;
                    }


                    if (part.getSize() == 0) {
                        continue;
                    }

                    // проверка content-type
                    String contentType = part.getContentType();
                    if (contentType == null ||
                            !(contentType.equals("image/jpeg") || contentType.equals("image/png"))) {
                        // не jpeg/png — пропускаем
                        continue;
                    }

                    // оригинальное имя файла
                    String submittedFileName = part.getSubmittedFileName();
                    if (submittedFileName == null || submittedFileName.isEmpty()) {
                        continue;
                    }

                    // расширение
                    String ext = "";
                    int dot = submittedFileName.lastIndexOf('.');
                    if (dot >= 0) {
                        ext = submittedFileName.substring(dot).toLowerCase();
                    }

                    // дополнительная проверка по расширению
                    if (!ext.equals(".jpg") && !ext.equals(".jpeg") && !ext.equals(".png")) {
                        continue;
                    }

                    // наше уникальное имя
                    String newFileName = "ad_" + adId + "_" + sortOrder + ext;
                    Path filePath = Paths.get(uploadDir, newFileName);

                    // сохраняем файл на диск
                    try {
                        Files.copy(part.getInputStream(), filePath);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        continue; // если не удалось — просто пропускаем
                    }

                    // пишем запись в ADVERTISEMENT_PHOTOS
                    try (PreparedStatement psPhoto = conn.prepareStatement(
                            "INSERT INTO ADVERTISEMENT_PHOTOS " +
                                    "(ADVERTISEMENT_ID, IMAGE_URL, SORT_ORDER) " +
                                    "VALUES (?, ?, ?)")) {
                        psPhoto.setInt(1, adId);
                        psPhoto.setString(2, newFileName);
                        psPhoto.setInt(3, sortOrder);
                        psPhoto.executeUpdate();
                    }

                    sortOrder++;
                    photoCount++;
                }

            } catch (Exception ex) {
                ex.printStackTrace();
                // не роняем создание объявления, если с фотками проблемы
            }

        } catch (SQLException e) {
            throw new ServletException("Ошибка при сохранении объявления", e);
        }

        // ----- 3. После всего — редирект на главную -----
        resp.sendRedirect("home");
    }
}
