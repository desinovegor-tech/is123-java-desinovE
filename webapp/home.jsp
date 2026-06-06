<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.model.Category" %>
<%@ page import="avito.controller.HomeServlet.AdView" %>

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
        :root {
            --main-color: #0f766e;
            --main-color-hover: #0d5f59;
            --accent-color: #14b8a6;
            --page-bg: #eef7f6;
            --card-bg: #ffffff;
            --border-color: #d7e7e5;
            --text-color: #1f2937;
            --muted-color: #64748b;
        }

        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(180deg, #e0f2f1 0%, var(--page-bg) 260px, #f8fafc 100%);
            margin: 0;
            color: var(--text-color);
        }

        a {
            color: var(--main-color);
            text-decoration: none;
            font-weight: 500;
        }

        a:hover {
            color: var(--main-color-hover);
            text-decoration: underline;
        }

        .layout {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px 40px;
        }

        .header {
            background: rgba(255,255,255,0.94);
            border-bottom: 1px solid var(--border-color);
            padding: 12px 15px;
            margin-bottom: 18px;
            box-shadow: 0 2px 12px rgba(15,118,110,0.08);
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
            font-size: 25px;
            font-weight: 800;
            color: #111827;
            letter-spacing: -0.5px;
        }

        .logo span {
            color: var(--main-color);
        }

        .user-block {
            font-size: 13px;
            color: var(--muted-color);
            background: #f0fdfa;
            padding: 8px 10px;
            border-radius: 10px;
        }

        .user-block a {
            margin-left: 10px;
        }

        .top-nav {
            margin-top: 7px;
            font-size: 14px;
            color: #94a3b8;
        }

        .top-nav a {
            margin-right: 12px;
        }

        .search-panel {
            margin: 15px 0 20px;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 18px 18px 12px;
            box-shadow: 0 8px 22px rgba(15,118,110,0.08);
        }

        .search-row {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 12px;
        }

        .search-row .field {
            flex: 1 1 220px;
        }

        .search-row label {
            display: block;
            font-size: 12px;
            color: var(--muted-color);
            margin-bottom: 5px;
            font-weight: 600;
        }

        .search-row input[type="text"],
        .search-row select {
            width: 100%;
            box-sizing: border-box;
            padding: 9px 10px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            font-size: 13px;
            background: #ffffff;
        }

        .search-row input:focus,
        .search-row select:focus {
            outline: none;
            border-color: var(--main-color);
            box-shadow: 0 0 0 3px rgba(15,118,110,0.16);
        }

        .price-range {
            display: flex;
            gap: 8px;
        }

        .price-range input {
            width: 100%;
        }

        .search-actions {
            margin-top: 6px;
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .btn-primary {
            border: none;
            border-radius: 10px;
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            background: var(--main-color);
            color: #fff;
            box-shadow: 0 4px 12px rgba(15,118,110,0.25);
        }

        .btn-primary:hover {
            background: var(--main-color-hover);
        }

        .link-reset {
            font-size: 13px;
        }

        .content {
            margin-top: 10px;
        }

        .content h2 {
            margin: 0 0 12px;
            color: #134e4a;
        }

        .ads-list {
            margin-top: 10px;
        }

        .ad-empty {
            padding: 24px;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            text-align: center;
            font-size: 14px;
            color: var(--muted-color);
            box-shadow: 0 5px 16px rgba(15,118,110,0.06);
        }

        .ad-card {
            display: flex;
            gap: 16px;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 12px;
            margin-bottom: 12px;
            box-shadow: 0 5px 16px rgba(15,118,110,0.06);
            transition: transform 0.15s ease, box-shadow 0.15s ease;
        }

        .ad-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 24px rgba(15,118,110,0.12);
        }

        .ad-photo {
            width: 145px;
            height: 112px;
            flex-shrink: 0;
            border-radius: 12px;
            overflow: hidden;
            background: #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: var(--muted-color);
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
            font-size: 17px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .ad-title a {
            color: #111827;
        }

        .ad-title a:hover {
            color: var(--main-color);
        }

        .ad-price {
            font-size: 19px;
            font-weight: 800;
            margin-bottom: 6px;
            color: #0f766e;
        }

        .ad-info-line {
            font-size: 13px;
            color: var(--muted-color);
            margin-bottom: 3px;
        }

        .ad-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 8px;
            font-size: 12px;
            color: #94a3b8;
        }

        .ad-actions a {
            font-size: 13px;
            margin-right: 8px;
        }

        .favorite-label {
            font-size: 12px;
            color: #0f766e;
            background: #ccfbf1;
            padding: 3px 7px;
            border-radius: 999px;
            font-weight: 700;
        }

        .ad-reserved {
            display:inline-block;
            margin-top:4px;
            margin-bottom:4px;
            padding:4px 8px;
            border-radius:999px;
            background:#fef3c7;
            color:#92400e;
            font-size:11px;
            font-weight:700;
        }

        @media (max-width: 768px) {
            .header-inner {
                flex-direction: column;
                align-items: flex-start;
            }

            .ad-card {
                flex-direction: column;
                align-items: stretch;
            }

            .ad-photo {
                width: 100%;
                height: 180px;
            }

            .ad-bottom {
                flex-direction: column;
                align-items: flex-start;
                gap: 6px;
            }
        }
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