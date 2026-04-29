<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="avito.Category" %>

<%
    String error = (String) request.getAttribute("error");
    List<Category> categories = (List<Category>) request.getAttribute("categories");

    String title       = request.getParameter("title");
    String description = request.getParameter("description");
    String price       = request.getParameter("price");
    String location    = request.getParameter("location");
    String condition   = request.getParameter("condition");
    String delivery    = request.getParameter("delivery");
    String categoryId  = request.getParameter("categoryId");

    String login = (String) session.getAttribute("login");
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Создать объявление — Avito Mini</title>
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

        /* Шапка (как на главной) */
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
        .top-nav {
            margin-top: 5px;
            font-size: 14px;
        }
        .top-nav a {
            margin-right: 12px;
        }
        .user-block {
            font-size: 13px;
            color: #555;
        }
        .user-block a {
            margin-left: 10px;
        }

        /* Основной лэйаут */
        .layout {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 15px 40px;
        }

        h1 {
            margin: 10px 0 20px;
            font-size: 24px;
        }

        .card {
            background: #ffffff;
            border-radius: 10px;
            padding: 20px 22px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 2fr 1.4fr;
            gap: 24px;
        }

        .field {
            margin-bottom: 14px;
        }
        .field label {
            display: block;
            font-size: 13px;
            color: #555;
            margin-bottom: 4px;
        }
        .field input[type="text"],
        .field input[type="number"],
        .field select,
        .field textarea {
            width: 100%;
            box-sizing: border-box;
            padding: 8px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        .field input:focus,
        .field select:focus,
        .field textarea:focus {
            outline: none;
            border-color: #6c2cff;
            box-shadow: 0 0 0 1px rgba(108,44,255,0.2);
        }
        .field textarea {
            resize: vertical;
            min-height: 120px;
        }

        .price-row {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .price-row span {
            font-size: 14px;
            color: #555;
        }

        .sub-title {
            font-size: 16px;
            font-weight: 600;
            margin: 10px 0 8px;
        }

        .photos-hint {
            font-size: 12px;
            color: #777;
            margin-top: 4px;
        }

        .error-box {
            margin-bottom: 15px;
            padding: 10px 12px;
            background: #ffe6e6;
            border: 1px solid #ffb3b3;
            color: #b30000;
            border-radius: 6px;
            font-size: 13px;
        }

        .form-actions {
            margin-top: 18px;
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .btn-primary {
            border: none;
            border-radius: 6px;
            padding: 10px 22px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            background: #6c2cff;
            color: #fff;
        }
        .btn-primary:hover {
            background: #5a22e0;
        }

        .btn-secondary {
            border: none;
            border-radius: 6px;
            padding: 9px 18px;
            font-size: 14px;
            cursor: pointer;
            background: #f1f1f1;
            color: #333;
        }
        .btn-secondary:hover {
            background: #e2e2e2;
        }

        @media (max-width: 800px) {
            .form-grid {
                grid-template-columns: 1fr;
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
                <a href="home">Главная</a> |
                <a href="create-ad">Создать объявление</a> |
                <a href="my-ads">Мои объявления</a> |
                <a href="my-messages">Сообщения</a> |
                <a href="favorites">Избранное</a> |
                <a href="my-orders">Мои заказы</a> |
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
    <h1>Создать объявление</h1>

    <div class="card">
        <% if (error != null && !error.isEmpty()) { %>
        <div class="error-box"><%= error %></div>
        <% } %>

        <!-- ВАЖНО: enctype для загрузки фото -->
        <form method="post" action="create-ad" enctype="multipart/form-data">
            <div class="form-grid">

                <!-- Левая колонка: основное -->
                <div>
                    <div class="sub-title">Основная информация</div>

                    <div class="field">
                        <label for="title">Заголовок объявления</label>
                        <input type="text" id="title" name="title"
                               value="<%= title != null ? title : "" %>"
                               maxlength="255" required>
                    </div>

                    <div class="field">
                        <label for="categoryId">Категория</label>
                        <select id="categoryId" name="categoryId" required>
                            <option value="">Выберите категорию</option>
                            <%
                                if (categories != null) {
                                    for (Category c : categories) {
                                        String selected =
                                                (categoryId != null &&
                                                        categoryId.equals(String.valueOf(c.getId())))
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
                        <label for="price">Цена</label>
                        <div class="price-row">
                            <input type="text" id="price" name="price"
                                   value="<%= price != null ? price : "" %>"
                                   placeholder="0" required>
                            <span>₽</span>
                        </div>
                    </div>

                    <div class="field">
                        <label for="description">Описание</label>
                        <textarea id="description" name="description"
                                  placeholder="Расскажите подробно о товаре"><%= description != null ? description : "" %></textarea>
                    </div>
                </div>

                <!-- Правая колонка: параметры + фото -->
                <div>
                    <div class="sub-title">Параметры</div>

                    <div class="field">
                        <label for="location">Город</label>
                        <input type="text" id="location" name="location"
                               value="<%= location != null ? location : "" %>" required>
                    </div>

                    <div class="field">
                        <label for="condition">Состояние</label>
                        <select id="condition" name="condition" required>
                            <option value="">Выберите состояние</option>
                            <option value="new"    <%= "new".equals(condition) ? "selected" : "" %>>Новый</option>
                            <option value="used"   <%= "used".equals(condition) ? "selected" : "" %>>Б/у</option>
                            <option value="broken" <%= "broken".equals(condition) ? "selected" : "" %>>Неисправен</option>
                        </select>
                    </div>

                    <div class="field">
                        <label for="delivery">Способ доставки</label>
                        <select id="delivery" name="delivery" required>
                            <option value="">Выберите вариант</option>
                            <option value="pickup"   <%= "pickup".equals(delivery) ? "selected" : "" %>>Самовывоз</option>
                            <option value="delivery" <%= "delivery".equals(delivery) ? "selected" : "" %>>Доставка</option>
                            <option value="both"     <%= "both".equals(delivery) ? "selected" : "" %>>Самовывоз или доставка</option>
                        </select>
                    </div>

                    <div class="sub-title" style="margin-top:18px;">Фотографии</div>
                    <div class="field">
                        <label for="photos">Добавьте фото товара</label>
                        <input type="file" id="photos" name="photos" multiple accept=".jpg,.jpeg,.png">
                        <div class="photos-hint">
                            Можно загрузить до 10 фотографий форматов JPG или PNG.
                        </div>
                    </div>
                </div>

            </div>

            <div class="form-actions">
                <button type="submit" class="btn-primary">Разместить объявление</button>
                <button type="button" class="btn-secondary"
                        onclick="location.href='home'">
                    Отменить
                </button>
            </div>
        </form>
    </div>
</div>

</body>
</html>
