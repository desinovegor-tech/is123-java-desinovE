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
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    // Модель для вывода объявлений на главной
    public static class AdView {
        private int id;
        private String title;
        private double price;
        private Timestamp publicationDate;
        private String location;
        private String sellerName;
        private String sellerCity;
        private boolean favorite;

        // НОВОЕ: имя первой фотки
        private String mainPhoto;
        private String status;

        // геттеры/сеттеры
        public int getId() {
            return id;
        }
        public void setId(int id) {
            this.id = id;
        }

        public String getTitle() {
            return title;
        }
        public void setTitle(String title) {
            this.title = title;
        }

        public double getPrice() {
            return price;
        }
        public void setPrice(double price) {
            this.price = price;
        }

        public Timestamp getPublicationDate() {
            return publicationDate;
        }
        public void setPublicationDate(Timestamp publicationDate) {
            this.publicationDate = publicationDate;
        }

        public String getLocation() {
            return location;
        }
        public void setLocation(String location) {
            this.location = location;
        }

        public String getSellerName() {
            return sellerName;
        }
        public void setSellerName(String sellerName) {
            this.sellerName = sellerName;
        }

        public String getSellerCity() {
            return sellerCity;
        }
        public void setSellerCity(String sellerCity) {
            this.sellerCity = sellerCity;
        }

        public boolean isFavorite() {
            return favorite;
        }
        public void setFavorite(boolean favorite) {
            this.favorite = favorite;
        }

        // НОВОЕ: геттер/сеттер для первой фотки
        public String getMainPhoto() {
            return mainPhoto;
        }
        public void setMainPhoto(String mainPhoto) {
            this.mainPhoto = mainPhoto;
        }
        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }
    }


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // --- проверка сессии ---
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login");
            return;
        }
        int userId = (int) session.getAttribute("userId");
        String userName = (String) session.getAttribute("userName");
        req.setAttribute("userName", userName);

        // --- читаем параметры фильтра ---
        String q = req.getParameter("q");
        String city = req.getParameter("city");
        String minPriceStr = req.getParameter("minPrice");
        String maxPriceStr = req.getParameter("maxPrice");
        String categoryIdStr = req.getParameter("categoryId");
        String condition = req.getParameter("condition");
        String delivery = req.getParameter("delivery");

        // прокидываем обратно в JSP, чтобы значения сохранялись в форме
        req.setAttribute("q", q);
        req.setAttribute("cityFilter", city);
        req.setAttribute("minPrice", minPriceStr);
        req.setAttribute("maxPrice", maxPriceStr);
        req.setAttribute("conditionFilter", condition);
        req.setAttribute("deliveryFilter", delivery);
        req.setAttribute("categoryIdFilter", categoryIdStr);

        List<Category> categories = new ArrayList<>();
        List<AdView> ads = new ArrayList<>();

        try (Connection conn = DbUtil.getConnection()) {

            // ---------- Загрузка категорий для выпадающего списка ----------
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT ID, NAME FROM CATEGORIES ORDER BY NAME")) {
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int id = rs.getInt("ID");
                        String name = rs.getString("NAME");
                        categories.add(new Category(id, name));
                    }
                }
            }
            req.setAttribute("categories", categories);

            // ---------- Построение SQL для объявлений с фильтрами ----------

            String baseSql =
                    "SELECT a.ID, a.TITLE, a.PRICE, a.PUBLICATION_DATE, " +
                            "       a.LOCATION, " +
                            "       u.NAME AS SELLER_NAME, u.CITY AS SELLER_CITY, " +
                            "       (SELECT FIRST 1 p.IMAGE_URL " +
                            "          FROM ADVERTISEMENT_PHOTOS p " +
                            "         WHERE p.ADVERTISEMENT_ID = a.ID " +
                            "         ORDER BY p.SORT_ORDER) AS MAIN_PHOTO, " +
                            "       a.STATUS AS AD_STATUS, " +           // <── статус
                            "       CASE WHEN f.ID IS NULL THEN 0 ELSE 1 END AS IS_FAVORITE " +
                            "FROM ADVERTISEMENTS a " +
                            "JOIN USERS u ON a.USER_ID = u.ID " +
                            "LEFT JOIN FAVORITES f ON f.ADVERTISEMENT_ID = a.ID AND f.USER_ID = ? " +
                            "WHERE a.STATUS IN ('active', 'reserved')";

            StringBuilder sql = new StringBuilder(baseSql);
            List<Object> params = new ArrayList<>();

            // первый параметр всегда userId (для таблицы FAVORITES)
            params.add(userId);

            // поиск по названию/описанию
            if (q != null && !q.trim().isEmpty()) {
                sql.append(" AND (UPPER(a.TITLE) LIKE ? OR UPPER(a.DESCRIPTION) LIKE ?)");
                String like = "%" + q.trim().toUpperCase() + "%";
                params.add(like);
                params.add(like);
            }

            // фильтр по городу (по LOCATION)
            if (city != null && !city.trim().isEmpty()) {
                sql.append(" AND UPPER(a.LOCATION) LIKE ?");
                params.add("%" + city.trim().toUpperCase() + "%");
            }

            // фильтр по цене "от"
            if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
                try {
                    double minPrice = Double.parseDouble(minPriceStr.trim());
                    sql.append(" AND a.PRICE >= ?");
                    params.add(minPrice);
                } catch (NumberFormatException ignored) { }
            }

            // фильтр по цене "до"
            if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
                try {
                    double maxPrice = Double.parseDouble(maxPriceStr.trim());
                    sql.append(" AND a.PRICE <= ?");
                    params.add(maxPrice);
                } catch (NumberFormatException ignored) { }
            }

            // категория
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                try {
                    int categoryId = Integer.parseInt(categoryIdStr);
                    sql.append(" AND a.CATEGORY_ID = ?");
                    params.add(categoryId);
                } catch (NumberFormatException ignored) { }
            }

            // состояние товара
            if (condition != null && !condition.isEmpty()) {
                sql.append(" AND a.CONDITION = ?");
                params.add(condition);
            }

            // способ доставки
            if (delivery != null && !delivery.isEmpty()) {
                if ("both".equals(delivery)) {
                    // ищем объявления, где доступен и самовывоз, и доставка
                    sql.append(" AND a.DELIVERY_METHOD = 'both'");
                } else {
                    // либо строго указанный способ, либо both
                    sql.append(" AND (a.DELIVERY_METHOD = ? OR a.DELIVERY_METHOD = 'both')");
                    params.add(delivery);
                }
            }

            sql.append(" ORDER BY a.PUBLICATION_DATE DESC");

            // ---------- Выполнение запроса ----------
            try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    ps.setObject(i + 1, params.get(i));
                }

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        AdView ad = new AdView();
                        ad.setId(rs.getInt("ID"));
                        ad.setTitle(rs.getString("TITLE"));
                        ad.setPrice(rs.getDouble("PRICE"));
                        ad.setPublicationDate(rs.getTimestamp("PUBLICATION_DATE"));
                        ad.setLocation(rs.getString("LOCATION"));
                        ad.setSellerName(rs.getString("SELLER_NAME"));
                        ad.setSellerCity(rs.getString("SELLER_CITY"));
                        ad.setFavorite(rs.getInt("IS_FAVORITE") == 1);
                        ad.setMainPhoto(rs.getString("MAIN_PHOTO"));
                        ad.setStatus(rs.getString("AD_STATUS"));

                        ads.add(ad);
                    }
                }
            }

        } catch (SQLException e) {
            throw new ServletException("Ошибка при загрузке объявлений", e);
        }

        req.setAttribute("ads", ads);
        req.getRequestDispatcher("/home.jsp").forward(req, resp);
    }
}
