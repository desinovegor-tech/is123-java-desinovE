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

%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title><%= title != null ? title : "Объявление" %></title>

    <style>
        body {
            font-family: Arial, sans-serif;
        }

        a { color: #3366cc; }

        .page-wrapper {
            max-width: 1100px;
            margin: 0 auto;
        }

        .top-back {
            margin: 10px 0 20px;
        }

        .ad-header {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 15px;
        }

        .top-block {
            display: flex;
            gap: 20px;
            align-items: flex-start;
        }

        .photos-block {
            flex: 2;
        }

        .main-photo {
            width: 100%;
            max-height: 420px;
            object-fit: cover;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: zoom-in;
        }

        .thumbs {
            margin-top: 8px;
            display: flex;
            gap: 6px;
        }

        .thumbs img {
            width: 70px;
            height: 70px;
            object-fit: cover;
            border-radius: 3px;
            border: 1px solid #ccc;
            cursor: pointer;
            transition: transform 0.1s, border-color 0.1s;
        }

        .thumbs img:hover {
            transform: scale(1.05);
            border-color: #ff9900;
        }

        .info-block {
            flex: 1.2;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 15px;
        }

        .price {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .btn {
            display: block;
            width: 100%;
            padding: 10px 0;
            text-align: center;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .btn-primary {
            background-color: #6c2cff;
            color: #fff;
        }

        .btn-secondary {
            background-color: #f1f1f1;
        }

        .section {
            margin-top: 30px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .section h2 {
            font-size: 20px;
            margin-bottom: 10px;
        }

        .chars-table {
            border-collapse: collapse;
            width: 100%;
            max-width: 600px;
        }

        .chars-table td {
            padding: 4px 0;
        }

        .chars-table td:first-child {
            color: #777;
            width: 160px;
        }

        .seller-card {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 12px 15px;
            max-width: 350px;
        }

        .seller-name {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .seller-city {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .seller-actions button {
            margin-right: 8px;
        }

        /* Модальное окно для полноразмерного фото */
        .photo-modal {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.8);
            display: none;           /* изначально скрыто */
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .photo-modal img {
            max-width: 90vw;
            max-height: 90vh;
            border-radius: 4px;
            box-shadow: 0 0 15px rgba(0,0,0,0.5);
        }

        .photo-modal-close {
            position: absolute;
            top: 20px;
            right: 30px;
            color: #fff;
            font-size: 28px;
            cursor: pointer;
        }

        /* стрелки в модальном окне */
        .photo-modal-arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            font-size: 40px;
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
            color: #ffdd66;
        }
        .status-badge {
            display:inline-block;
            margin-top:6px;
            padding:3px 8px;
            border-radius:6px;
            font-size:12px;
            font-weight:600;
        }
        .status-badge.reserved {
            background:#ffe9c2;
            color:#b96500;
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
        <!-- Левая часть: фото -->
        <div class="photos-block">
            <%
                if (photos != null && !photos.isEmpty()) {
                    String main = photos.get(0);
            %>
            <!-- большая фотка -->
            <img id="mainPhoto"
                 src="uploads/<%= main %>"
                 alt="Фото товара"
                 class="main-photo"
                 onclick="openPhotoModal()">

            <!-- миниатюры -->
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

        <!-- Правая часть: цена и кнопка заказа -->
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
            <!-- ОФОРМИТЬ ЗАКАЗ -->
            <%
                if (!"reserved".equalsIgnoreCase(adStatus)) {
            %>
            <form method="get" action="order">
                <input type="hidden" name="adId" value="<%= adId %>">
                <button class="btn btn-primary" type="submit">
                    Оформить заказ
                </button>
            </form>
            <%
            } else {
            %>
            <button class="btn btn-primary" type="button" disabled>
                Товар зарезервирован
            </button>
            <%
                }
            %>
            <% } else { %>
            <p style="color:#e67e22; font-weight:bold; margin:12px 0;">
                Товар зарезервирован. Оформить заказ больше нельзя.
            </p>
            <% } %>

            <p style="margin-top:15px; font-size: 13px; color:#666;">
                Категория: <b><%= categoryName %></b><br>
                Город: <b><%= location %></b><br>
                Дата публикации:
                <b><%= pubDate != null ? pubDate.toString() : "" %></b>
            </p>

            <hr style="margin:10px 0;">

            <p style="font-size: 13px;">
                <a href="add-favorite?id=<%= adId %>&from=view">Добавить в избранное</a>
                |
                <a href="delete-favorite?id=<%= adId %>&from=view">Удалить из избранного</a>
            </p>

            <p style="font-size: 13px;">
                <a href="messages?adId=<%= adId %>">Написать продавцу</a>
            </p>
        </div>
    </div>

    <!-- Характеристики -->
    <div class="section">
        <h2>Характеристики</h2>
        <table class="chars-table">
            <tr>
                <td>Состояние</td>
                <td><b><%= condition %></b></td>
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
                <td><b><%= delivery %></b></td>
            </tr>
        </table>
    </div>

    <!-- Описание -->
    <div class="section">
        <h2>Описание</h2>
        <pre style="font-family: inherit; white-space: pre-wrap;"><%= description %></pre>
    </div>

    <!-- Местоположение -->
    <div class="section">
        <h2>Местоположение</h2>
        <p><b><%= location %></b></p>
    </div>

    <!-- Продавец -->
    <div class="section">
        <h2>Продавец</h2>
        <div class="seller-card">
            <div class="seller-name"><%= sellerName %></div>
            <div class="seller-city"><%= sellerCity %></div>
            <div class="seller-actions">
                <button type="button" class="btn btn-secondary" style="width:auto;"
                        onclick="location.href='messages?adId=<%= adId %>'">
                    Написать
                </button>
            </div>
        </div>
    </div>

</div>

<!-- Модальное окно для полноразмерного фото -->
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
    // массив URL-ов фото и текущий индекс
    let photoUrls = [];
    let currentIndex = 0;

    // инициализация после загрузки DOM
    window.addEventListener('DOMContentLoaded', function() {
        const thumbs = document.querySelectorAll('.thumbs img');
        photoUrls = Array.from(thumbs).map(img => img.getAttribute('src'));

        const main = document.getElementById('mainPhoto');
        if (photoUrls.length > 0 && main) {
            main.src = photoUrls[0];
            currentIndex = 0;
        }
    });

    // показать фото с нужным индексом
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

        // подсветка активной миниатюры
        const thumbs = document.querySelectorAll('.thumbs img');
        thumbs.forEach((img, i) => {
            img.style.borderColor = (i === currentIndex ? '#ff9900' : '#ccc');
        });
    }

    // клик по миниатюре
    function setMainPhoto(idx) {
        showPhoto(idx);
    }

    // открыть модальное окно
    function openPhotoModal() {
        const modal = document.getElementById('photoModal');
        const modalImg = document.getElementById('modalImg');
        if (!modal || !modalImg || !photoUrls.length) return;

        modalImg.src = photoUrls[currentIndex] || '';
        modal.style.display = 'flex';
    }

    // закрытие модалки
    function closePhotoModal(e) {
        const modal = document.getElementById('photoModal');
        if (!modal) return;

        if (!e || e.target.id === 'photoModal' ||
            e.target.classList.contains('photo-modal-close')) {
            modal.style.display = 'none';
        }
    }

    // стрелки
    function showPrevPhoto() {
        showPhoto(currentIndex - 1);
    }

    function showNextPhoto() {
        showPhoto(currentIndex + 1);
    }

    // управление с клавиатуры
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
