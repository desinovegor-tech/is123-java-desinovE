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

        .header {
            background: rgba(255,255,255,0.94);
            border-bottom: 1px solid var(--border-color);
            padding: 12px 15px;
            margin-bottom: 22px;
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

        .top-nav {
            margin-top: 7px;
            font-size: 14px;
            color: #94a3b8;
        }

        .top-nav a {
            margin-right: 12px;
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

        .layout {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 15px 45px;
        }

        h1 {
            margin: 10px 0 20px;
            font-size: 28px;
            color: #134e4a;
            letter-spacing: -0.4px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 18px;
            padding: 22px 24px;
            border: 1px solid var(--border-color);
            box-shadow: 0 8px 22px rgba(15,118,110,0.08);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 2fr 1.4fr;
            gap: 26px;
        }

        .field {
            margin-bottom: 15px;
        }

        .field label {
            display: block;
            font-size: 13px;
            color: var(--muted-color);
            margin-bottom: 6px;
            font-weight: 600;
        }

        .field input[type="text"],
        .field input[type="number"],
        .field input[type="file"],
        .field select,
        .field textarea {
            width: 100%;
            box-sizing: border-box;
            padding: 9px 10px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            font-size: 14px;
            background: #ffffff;
            color: var(--text-color);
        }

        .field input[type="file"] {
            padding: 8px;
            background: #f8fafc;
        }

        .field input:focus,
        .field select:focus,
        .field textarea:focus {
            outline: none;
            border-color: var(--main-color);
            box-shadow: 0 0 0 3px rgba(15,118,110,0.16);
        }

        .field textarea {
            resize: vertical;
            min-height: 130px;
            line-height: 1.45;
        }

        .price-row {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .price-row span {
            font-size: 15px;
            color: var(--muted-color);
            font-weight: 700;
        }

        .sub-title {
            font-size: 17px;
            font-weight: 800;
            margin: 8px 0 12px;
            color: #134e4a;
        }

        .photos-hint {
            font-size: 12px;
            color: var(--muted-color);
            margin-top: 6px;
            line-height: 1.4;
            background: #f0fdfa;
            border: 1px solid #ccfbf1;
            padding: 8px 10px;
            border-radius: 10px;
        }

        .error-box {
            margin-bottom: 16px;
            padding: 11px 13px;
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #b91c1c;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
        }

        .side-panel {
            background: #f8fafc;
            border: 1px solid #eef2f7;
            border-radius: 16px;
            padding: 16px;
        }

        .form-actions {
            margin-top: 22px;
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .btn-primary {
            border: none;
            border-radius: 10px;
            padding: 11px 23px;
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            background: var(--main-color);
            color: #fff;
            box-shadow: 0 4px 12px rgba(15,118,110,0.25);
        }

        .btn-primary:hover {
            background: var(--main-color-hover);
        }

        .btn-secondary {
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 10px 19px;
            font-size: 14px;
            cursor: pointer;
            background: #f0fdfa;
            color: #134e4a;
            font-weight: 700;
        }

        .btn-secondary:hover {
            background: #ccfbf1;
        }

        .small-note {
            margin-top: 14px;
            font-size: 12px;
            color: var(--muted-color);
            line-height: 1.5;
        }

        @media (max-width: 800px) {
            .header-inner {
                flex-direction: column;
                align-items: flex-start;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            h1 {
                font-size: 24px;
            }

            .card {
                padding: 18px;
            }

            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .btn-primary,
            .btn-secondary {
                width: 100%;
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

        <form method="post" action="create-ad" enctype="multipart/form-data">
            <div class="form-grid">

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

                    <div class="small-note">
                        Опишите товар понятно: состояние, комплект, особенности и причину продажи.
                    </div>
                </div>

                <div class="side-panel">
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

                    <div class="sub-title" style="margin-top:20px;">Фотографии</div>

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