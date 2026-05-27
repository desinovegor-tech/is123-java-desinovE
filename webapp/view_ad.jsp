<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>

<%
    String title        = (String) request.getAttribute("title");
    Double price        = (Double) request.getAttribute("price");
    String categoryName = (String) request.getAttribute("categoryName");
    String location     = (String) request.getAttribute("location");
    String condition    = (String) request.getAttribute("condition");
    String delivery     = (String) request.getAttribute("delivery");
    java.sql.Timestamp pubDate =
            (java.sql.Timestamp) request.getAttribute("pubDate");
    String description  = (String) request.getAttribute("description");
    String sellerName   = (String) request.getAttribute("sellerName");
    String sellerCity   = (String) request.getAttribute("sellerCity");
    Integer adId        = (Integer) request.getAttribute("adId");
    Integer sellerId    = (Integer) request.getAttribute("sellerId");

    List<String> photos = (List<String>) request.getAttribute("photos");
    String favStatus = request.getParameter("fav");
    String adStatus    = (String) request.getAttribute("status");
    boolean canOrder   = (adStatus == null || "active".equalsIgnoreCase(adStatus));

    String conditionText;
    if ("new".equalsIgnoreCase(condition)) {
        conditionText = "Новый";
    } else if ("used".equalsIgnoreCase(condition)) {
        conditionText = "Б/у";
    } else if ("broken".equalsIgnoreCase(condition)) {
        conditionText = "Неисправен";
    } else {
        conditionText = condition != null ? condition : "";
    }

    String deliveryText;
    if ("pickup".equalsIgnoreCase(delivery)) {
        deliveryText = "Самовывоз";
    } else if ("delivery".equalsIgnoreCase(delivery)) {
        deliveryText = "Доставка";
    } else if ("both".equalsIgnoreCase(delivery)) {
        deliveryText = "Самовывоз или доставка";
    } else {
        deliveryText = delivery != null ? delivery : "";
    }
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title><%= title != null ? title : "Объявление" %></title>

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
            margin: 0;
            color: var(--text-color);
            background: linear-gradient(180deg, #e0f2f1 0%, var(--page-bg) 260px, #f8fafc 100%);
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

        .page-wrapper {
            max-width: 1100px;
            margin: 0 auto;
            padding: 18px 15px 45px;
        }

        .top-back {
            margin: 5px 0 18px;
            font-size: 14px;
        }

        .top-back a {
            display: inline-block;
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 999px;
            padding: 8px 13px;
            box-shadow: 0 4px 12px rgba(15,118,110,0.06);
        }

        .ad-header {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 18px;
            color: #134e4a;
            letter-spacing: -0.4px;
        }

        .top-block {
            display: flex;
            gap: 22px;
            align-items: flex-start;
        }

        .photos-block {
            flex: 2;
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 18px;
            padding: 12px;
            box-shadow: 0 8px 22px rgba(15,118,110,0.08);
        }

        .main-photo {
            width: 100%;
            max-height: 420px;
            object-fit: cover;
            border: 1px solid var(--border-color);
            border-radius: 14px;
            cursor: zoom-in;
            background: #e2e8f0;
        }

        .thumbs {
            margin-top: 10px;
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .thumbs img {
            width: 72px;
            height: 72px;
            object-fit: cover;
            border-radius: 10px;
            border: 2px solid #cbd5e1;
            cursor: pointer;
            transition: transform 0.12s ease, border-color 0.12s ease, box-shadow 0.12s ease;
        }

        .thumbs img:hover {
            transform: scale(1.05);
            border-color: var(--main-color);
            box-shadow: 0 4px 12px rgba(15,118,110,0.18);
        }

        .info-block {
            flex: 1.2;
            border: 1px solid var(--border-color);
            border-radius: 18px;
            padding: 18px;
            background: var(--card-bg);
            box-shadow: 0 8px 22px rgba(15,118,110,0.08);
        }

        .price {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 12px;
            color: var(--main-color);
        }

        .btn {
            display: block;
            width: 100%;
            padding: 11px 0;
            text-align: center;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 9px;
        }

        .btn-primary {
            background-color: var(--main-color);
            color: #fff;
            box-shadow: 0 4px 12px rgba(15,118,110,0.25);
        }

        .btn-primary:hover {
            background-color: var(--main-color-hover);
        }

        .btn-primary:disabled {
            background: #94a3b8;
            cursor: not-allowed;
            box-shadow: none;
        }

        .btn-secondary {
            background-color: #f0fdfa;
            color: #134e4a;
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background-color: #ccfbf1;
        }

        .info-text {
            margin-top: 15px;
            font-size: 13px;
            color: var(--muted-color);
            line-height: 1.8;
        }

        .info-text b {
            color: #111827;
        }

        .info-links {
            font-size: 13px;
            line-height: 1.8;
        }

        .section {
            margin-top: 24px;
            padding: 18px;
            border: 1px solid var(--border-color);
            border-radius: 18px;
            background: var(--card-bg);
            box-shadow: 0 6px 18px rgba(15,118,110,0.06);
        }

        .section h2 {
            font-size: 20px;
            margin: 0 0 12px;
            color: #134e4a;
        }

        .chars-table {
            border-collapse: collapse;
            width: 100%;
            max-width: 650px;
        }

        .chars-table td {
            padding: 8px 0;
            border-bottom: 1px solid #eef2f7;
        }

        .chars-table tr:last-child td {
            border-bottom: none;
        }

        .chars-table td:first-child {
            color: var(--muted-color);
            width: 170px;
        }

        .description-text {
            font-family: inherit;
            white-space: pre-wrap;
            margin: 0;
            line-height: 1.55;
            color: #334155;
        }

        .seller-card {
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 15px 17px;
            max-width: 350px;
            background: #f8fafc;
        }

        .seller-name {
            font-weight: 800;
            margin-bottom: 6px;
            color: #111827;
        }

        .seller-city {
            color: var(--muted-color);
            font-size: 14px;
            margin-bottom: 12px;
        }

        .seller-actions button {
            margin-right: 8px;
        }

        .photo-modal {
            position: fixed;
            inset: 0;
            background: rgba(15,23,42,0.88);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .photo-modal img {
            max-width: 90vw;
            max-height: 90vh;
            border-radius: 12px;
            box-shadow: 0 0 25px rgba(0,0,0,0.55);
        }

        .photo-modal-close {
            position: absolute;
            top: 20px;
            right: 30px;
            color: #fff;
            font-size: 32px;
            cursor: pointer;
        }

        .photo-modal-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            font-size: 42px;
            color: #fff;
            cursor: pointer;
            user-select: none;
            padding: 10px 15px;
        }

        .photo-modal-arrow.left {
            left: 20px;
        }

        .photo-modal-arrow.right {
            right: 20px;
        }

        .photo-modal-arrow:hover {
            color: #5eead4;
        }

        .status-badge {
            display: inline-block;
            margin-top: 2px;
            margin-bottom: 12px;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
        }

        .status-badge.reserved {
            background: #fef3c7;
            color: #92400e;
        }

        .reserved-text {
            color: #92400e;
            background: #fef3c7;
            border-radius: 10px;
            padding: 10px;
            font-weight: 700;
            margin: 12px 0;
        }

        hr {
            border: none;
            border-top: 1px solid var(--border-color);
            margin: 14px 0;
        }

        @media (max-width: 850px) {
            .top-block {
                flex-direction: column;
            }

            .photos-block,
            .info-block {
                width: 100%;
                box-sizing: border-box;
            }

            .ad-header {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
<div class="page-wrapper">

    <p class="top-back">
        <a href="home">← К списку объявлений</a>
    </p>

    <div class="ad-header"><%= title %></div>

    <div class="top-block">
        <div class="photos-block">
            <%
                if (photos != null && !photos.isEmpty()) {
                    String main = photos.get(0);
            %>
            <img id="mainPhoto"
                 src="uploads/<%= main %>"
                 alt="Фото товара"
                 class="main-photo"
                 onclick="openPhotoModal()">

            <div class="thumbs">
                <%
                    for (int i = 0; i < photos.size(); i++) {
                        String p = photos.get(i);
                %>
                <img src="uploads/<%= p %>"
                     alt="Фото"
                     data-index="<%= i %>"
                     onclick="setMainPhoto(<%= i %>)">
                <%
                    }
                %>
            </div>
            <%
            } else {
            %>
            <p>Фотографии не добавлены.</p>
            <%
                }
            %>
        </div>

        <div class="info-block">
            <div class="price">
                <%= price != null ? String.format("%.2f ₽", price) : "" %>
            </div>

            <%
                if ("reserved".equalsIgnoreCase(adStatus)) {
            %>
            <div class="status-badge reserved">Товар зарезервирован</div>
            <%
                }
            %>

            <% if (canOrder) { %>
            <form method="get" action="order">
                <input type="hidden" name="adId" value="<%= adId %>">
                <button class="btn btn-primary" type="submit">
                    Оформить заказ
                </button>
            </form>
            <% } else { %>
            <div class="reserved-text">
                Товар зарезервирован. Оформить заказ больше нельзя.
            </div>
            <% } %>

            <p class="info-text">
                Категория: <b><%= categoryName %></b><br>
                Город: <b><%= location %></b><br>
                Дата публикации:
                <b><%= pubDate != null ? pubDate.toString() : "" %></b>
            </p>

            <hr>

            <p class="info-links">
                <a href="add-favorite?id=<%= adId %>&from=view">Добавить в избранное</a>
                |
                <a href="delete-favorite?id=<%= adId %>&from=view">Удалить из избранного</a>
            </p>

            <p class="info-links">
                <a href="messages?adId=<%= adId %>">Написать продавцу</a>
            </p>
        </div>
    </div>

    <div class="section">
        <h2>Характеристики</h2>
        <table class="chars-table">
            <tr>
                <td>Состояние</td>
                <td><b><%= conditionText %></b></td>
            </tr>
            <tr>
                <td>Категория</td>
                <td><b><%= categoryName %></b></td>
            </tr>
            <tr>
                <td>Город</td>
                <td><b><%= location %></b></td>
            </tr>
            <tr>
                <td>Доставка</td>
                <td><b><%= deliveryText %></b></td>
            </tr>
        </table>
    </div>

    <div class="section">
        <h2>Описание</h2>
        <pre class="description-text"><%= description %></pre>
    </div>

    <div class="section">
        <h2>Местоположение</h2>
        <p><b><%= location %></b></p>
    </div>

    <div class="section">
        <h2>Продавец</h2>
        <div class="seller-card">
            <div class="seller-name"><%= sellerName %></div>
            <div class="seller-city"><%= sellerCity %></div>
            <div class="seller-actions">
                <button type="button" class="btn btn-secondary" style="width:auto; padding: 10px 18px;"
                        onclick="location.href='messages?adId=<%= adId %>'">
                    Написать
                </button>
            </div>
        </div>
    </div>

</div>

<div id="photoModal" class="photo-modal" onclick="closePhotoModal(event)">
    <div class="photo-modal-close">&times;</div>

    <div class="photo-modal-arrow left"
         onclick="event.stopPropagation(); showPrevPhoto();">
        &#10094;
    </div>

    <img id="modalImg" src="" alt="Фото">

    <div class="photo-modal-arrow right"
         onclick="event.stopPropagation(); showNextPhoto();">
        &#10095;
    </div>
</div>

<script>
    let photoUrls = [];
    let currentIndex = 0;

    window.addEventListener('DOMContentLoaded', function() {
        const thumbs = document.querySelectorAll('.thumbs img');
        photoUrls = Array.from(thumbs).map(img => img.getAttribute('src'));

        const main = document.getElementById('mainPhoto');
        if (photoUrls.length > 0 && main) {
            main.src = photoUrls[0];
            currentIndex = 0;
        }
    });

    function showPhoto(index) {
        if (!photoUrls.length) return;

        if (index < 0) index = photoUrls.length - 1;
        if (index >= photoUrls.length) index = 0;
        currentIndex = index;

        const src = photoUrls[currentIndex];
        const main = document.getElementById('mainPhoto');
        const modalImg = document.getElementById('modalImg');
        if (main) main.src = src;
        if (modalImg) modalImg.src = src;

        const thumbs = document.querySelectorAll('.thumbs img');
        thumbs.forEach((img, i) => {
            img.style.borderColor = (i === currentIndex ? '#0f766e' : '#cbd5e1');
        });
    }

    function setMainPhoto(idx) {
        showPhoto(idx);
    }

    function openPhotoModal() {
        const modal = document.getElementById('photoModal');
        const modalImg = document.getElementById('modalImg');
        if (!modal || !modalImg || !photoUrls.length) return;

        modalImg.src = photoUrls[currentIndex] || '';
        modal.style.display = 'flex';
    }

    function closePhotoModal(e) {
        const modal = document.getElementById('photoModal');
        if (!modal) return;

        if (!e || e.target.id === 'photoModal' ||
            e.target.classList.contains('photo-modal-close')) {
            modal.style.display = 'none';
        }
    }

    function showPrevPhoto() {
        showPhoto(currentIndex - 1);
    }

    function showNextPhoto() {
        showPhoto(currentIndex + 1);
    }

    window.addEventListener('keydown', function(e) {
        const modal = document.getElementById('photoModal');
        if (!modal || modal.style.display !== 'flex') return;

        if (e.key === 'Escape') {
            closePhotoModal(e);
        } else if (e.key === 'ArrowLeft') {
            showPrevPhoto();
        } else if (e.key === 'ArrowRight') {
            showNextPhoto();
        }
    });
</script>

</body>
</html>