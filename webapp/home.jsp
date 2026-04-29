<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.Category" %>
<%@ page import="avito.HomeServlet.AdView" %>

<%
    String q               = (String) request.getAttribute("q");
    String cityFilter      = (String) request.getAttribute("cityFilter");
    String minPrice        = (String) request.getAttribute("minPrice");
    String maxPrice        = (String) request.getAttribute("maxPrice");
    String conditionFilter = (String) request.getAttribute("conditionFilter");
    String deliveryFilter  = (String) request.getAttribute("deliveryFilter");
    String categoryIdFilter= (String) request.getAttribute("categoryIdFilter");

    List<Category> categories = (List<Category>) request.getAttribute("categories");
    List<AdView>   ads        = (List<AdView>)   request.getAttribute("ads");

    String login = (String) session.getAttribute("login");
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Объявления — Avito Mini</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            margin: 0;
        }

        a {
            color: #3366cc;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }

        .layout {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px 40px;
        }

        /* Шапка */
        .header {
            background: #ffffff;
            border-bottom: 1px solid #e0e0e0;
            padding: 10px 15px;
            margin-bottom: 15px;
        }
        .header-inner {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
        }
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #2c2c2c;
        }
        .logo span {
            color: #6c2cff;
        }
        .user-block {
            font-size: 13px;
            color: #555;
        }
        .user-block a {
            margin-left: 10px;
        }

        /* Верхнее меню */
        .top-nav {
            margin-top: 5px;
            font-size: 14px;
        }
        .top-nav a {
            margin-right: 12px;
        }

        /* Поиск и фильтры */
        .search-panel {
            margin: 15px 0;
            background: #ffffff;
            border-radius: 8px;
            padding: 15px 15px 5px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
        }

        .search-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 10px;
        }
        .search-row .field {
            flex: 1 1 220px;
        }
        .search-row label {
            display: block;
            font-size: 12px;
            color: #666;
            margin-bottom: 3px;
        }
        .search-row input[type="text"],
        .search-row select {
            width: 100%;
            box-sizing: border-box;
            padding: 7px 8px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 13px;
        }
        .search-row input:focus,
        .search-row select:focus {
            outline: none;
            border-color: #6c2cff;
            box-shadow: 0 0 0 1px rgba(108,44,255,0.2);
        }

        .price-range {
            display: flex;
            gap: 6px;
        }
        .price-range input {
            width: 100%;
        }

        .search-actions {
            margin-top: 5px;
            display: flex;
            gap: 10px;
            align-items: center;
        }
        .btn-primary {
            border: none;
            border-radius: 6px;
            padding: 8px 16px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            background: #6c2cff;
            color: #fff;
        }
        .btn-primary:hover {
            background: #5a22e0;
        }
        .link-reset {
            font-size: 13px;
        }

        /* Список объявлений */
        .content {
            margin-top: 10px;
        }

        .ads-list {
            margin-top: 10px;
        }

        .ad-empty {
            padding: 20px;
            background: #ffffff;
            border-radius: 8px;
            text-align: center;
            font-size: 14px;
            color: #777;
        }

        .ad-card {
            display: flex;
            gap: 15px;
            background: #ffffff;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 10px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.05);
        }

        .ad-photo {
            width: 140px;
            height: 110px;
            flex-shrink: 0;
            border-radius: 6px;
            overflow: hidden;
            background: #eee;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #777;
        }
        .ad-photo img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .ad-main {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .ad-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .ad-title a {
            color: #222;
        }

        .ad-price {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .ad-info-line {
            font-size: 13px;
            color: #666;
            margin-bottom: 2px;
        }

        .ad-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 6px;
            font-size: 12px;
            color: #888;
        }

        .ad-actions a {
            font-size: 13px;
            margin-right: 8px;
        }

        .favorite-label {
            font-size: 12px;
            color: #e67e22;
        }

        @media (max-width: 768px) {
            .ad-card {
                flex-direction: column;
                align-items: stretch;
            }
            .ad-photo {
                width: 100%;
                height: 180px;
            }
        }
        .ad-reserved {
            display:inline-block;
            margin-top:4px;
            padding:2px 6px;
            border-radius:4px;
            background:#ffe9c2;
            color:#b96500;
            font-size:11px;
            font-weight:600;}
    </style>
</head>
<body>

<div class="header">
    <div class="header-inner">
        <div>
            <div class="logo">Avito<span>Mini</span></div>
            <div class="top-nav">
                <a href="home">Главная</a>
                |
                <a href="create-ad">Создать объявление</a>
                |
                <a href="my-ads">Мои объявления</a>
                |
                <a href="my-messages">Сообщения</a>
                |
                <a href="favorites">Избранное</a>
                |
                <a href="my-orders">Мои заказы</a>
                |
                <a href="profile">Профиль</a>
            </div>
        </div>
        <div class="user-block">
            Вы вошли как
            <b><%= (login != null ? login : "Гость") %></b>
            <a href="logout">Выход</a>
        </div>
    </div>
</div>

<div class="layout">

    <!-- Поиск и фильтры -->
    <div class="search-panel">
        <form method="get" action="home">

            <div class="search-row">
                <div class="field">
                    <label for="q">Название или текст объявления</label>
                    <input type="text" id="q" name="q"
                           value="<%= q == null ? "" : q %>">
                </div>

                <div class="field">
                    <label for="city">Город</label>
                    <input type="text" id="city" name="city"
                           value="<%= cityFilter == null ? "" : cityFilter %>">
                </div>

                <div class="field">
                    <label>Цена (₽)</label>
                    <div class="price-range">
                        <input type="text" name="minPrice" placeholder="от"
                               value="<%= minPrice == null ? "" : minPrice %>">
                        <input type="text" name="maxPrice" placeholder="до"
                               value="<%= maxPrice == null ? "" : maxPrice %>">
                    </div>
                </div>
            </div>

            <div class="search-row">
                <div class="field">
                    <label for="categoryId">Категория</label>
                    <select name="categoryId" id="categoryId">
                        <option value="">Любая</option>
                        <%
                            if (categories != null) {
                                for (Category c : categories) {
                                    String selected =
                                            (categoryIdFilter != null &&
                                                    categoryIdFilter.equals(String.valueOf(c.getId())))
                                                    ? "selected" : "";
                        %>
                        <option value="<%= c.getId() %>" <%= selected %>><%= c.getName() %></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>

                <div class="field">
                    <label for="condition">Состояние</label>
                    <select name="condition" id="condition">
                        <option value="">Любое</option>
                        <option value="new"    <%= "new".equals(conditionFilter) ? "selected" : "" %>>Новый</option>
                        <option value="used"   <%= "used".equals(conditionFilter) ? "selected" : "" %>>Б/у</option>
                        <option value="broken" <%= "broken".equals(conditionFilter) ? "selected" : "" %>>Неисправен</option>
                    </select>
                </div>

                <div class="field">
                    <label for="delivery">Способ доставки</label>
                    <select name="delivery" id="delivery">
                        <option value="">Любой</option>
                        <option value="pickup"   <%= "pickup".equals(deliveryFilter) ? "selected" : "" %>>Самовывоз</option>
                        <option value="delivery" <%= "delivery".equals(deliveryFilter) ? "selected" : "" %>>Доставка</option>
                        <option value="both"     <%= "both".equals(deliveryFilter) ? "selected" : "" %>>Самовывоз или доставка</option>
                    </select>
                </div>
            </div>

            <div class="search-actions">
                <button type="submit" class="btn-primary">Найти</button>
                <a href="home" class="link-reset">Сбросить фильтры</a>
            </div>
        </form>
    </div>

    <!-- Список объявлений -->
    <div class="content">
        <h2>Объявления</h2>

        <div class="ads-list">
            <%
                if (ads == null || ads.isEmpty()) {
            %>
            <div class="ad-empty">
                По выбранным условиям объявлений не найдено.
                Попробуйте изменить фильтры.
            </div>
            <%
            } else {
                for (AdView ad : ads) {
            %>
            <div class="ad-card">

                <!-- Фото -->
                <div class="ad-photo">
                    <%
                        String img = ad.getMainPhoto();
                        if (img != null && !img.isEmpty()) {
                    %>
                    <img src="uploads/<%= img %>" alt="Фото объявления">
                    <%
                    } else {
                    %>
                    нет фото
                    <%
                        }
                    %>
                </div>

                <!-- Основная информация -->
                <div class="ad-main">
                    <div>
                        <div class="ad-title">
                            <a href="view-ad?id=<%= ad.getId() %>"><%= ad.getTitle() %></a>
                        </div>
                        <div class="ad-price">
                            <%= String.format("%.2f ₽", ad.getPrice()) %>
                        </div>
                        <%
                            String st = ad.getStatus();
                            if ("reserved".equalsIgnoreCase(st)) {
                        %>
                        <div class="ad-reserved">Товар зарезервирован</div>
                        <%
                            }
                        %>
                        <div class="ad-info-line">
                            <%= ad.getLocation() != null ? ad.getLocation() : "" %>
                        </div>
                        <div class="ad-info-line">
                            Продавец: <%= ad.getSellerName() %>
                            <% if (ad.getSellerCity() != null) { %>
                            (<%= ad.getSellerCity() %>)
                            <% } %>
                        </div>
                    </div>

                    <div class="ad-bottom">
                        <div class="ad-actions">
                            <a href="view-ad?id=<%= ad.getId() %>">Подробнее</a>
                            <% if (ad.isFavorite()) { %>
                            <span class="favorite-label">В избранном</span>
                            <% } %>
                        </div>
                        <div>
                            <%
                                java.sql.Timestamp dt = ad.getPublicationDate();
                                if (dt != null) {
                            %>
                            <span>Размещено: <%= dt.toString() %></span>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>

            </div>
            <%
                    }
                }
            %>
        </div>
    </div>

</div>
</body>
</html>
