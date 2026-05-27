<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>

<%
    Integer adId = (Integer) request.getAttribute("adId");
    String title = (String) request.getAttribute("title");
    BigDecimal price = (BigDecimal) request.getAttribute("price");
    String deliveryMethod = (String) request.getAttribute("deliveryMethod");

    BigDecimal priceSafe = (price != null ? price : BigDecimal.ZERO);
    String login = (String) session.getAttribute("login");
%>

<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Оформление заказа — Avito Mini</title>
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
            margin-bottom: 20px;
            box-shadow: 0 2px 12px rgba(15,118,110,0.08);
        }

        .header-inner {
            max-width: 1000px;
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

        .page {
            max-width: 850px;
            margin: 0 auto;
            padding: 0 15px 45px;
        }

        .back-link {
            font-size: 14px;
            margin-bottom: 15px;
        }

        .back-link a {
            display: inline-block;
            background: #ffffff;
            border: 1px solid var(--border-color);
            border-radius: 999px;
            padding: 8px 13px;
            box-shadow: 0 4px 12px rgba(15,118,110,0.06);
        }

        h1 {
            margin: 0 0 18px;
            font-size: 27px;
            color: #134e4a;
            letter-spacing: -0.3px;
        }

        .order-card {
            background: var(--card-bg);
            border-radius: 18px;
            padding: 22px 24px;
            border: 1px solid var(--border-color);
            box-shadow: 0 8px 22px rgba(15,118,110,0.08);
        }

        .order-title {
            font-size: 16px;
            margin-bottom: 12px;
            color: var(--muted-color);
        }

        .order-title b {
            font-weight: 800;
            color: #111827;
        }

        .order-price {
            margin-bottom: 18px;
            font-size: 15px;
            color: var(--muted-color);
            padding: 12px 14px;
            border-radius: 14px;
            background: #f8fafc;
            border: 1px solid #eef2f7;
        }

        .order-price-main {
            font-weight: 800;
            font-size: 20px;
            color: var(--main-color);
        }

        .field {
            margin-bottom: 14px;
        }

        .field label {
            display: block;
            font-size: 13px;
            color: var(--muted-color);
            margin-bottom: 6px;
            font-weight: 700;
        }

        select {
            width: 100%;
            box-sizing: border-box;
            padding: 10px 11px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            font-size: 14px;
            background: #ffffff;
            color: var(--text-color);
        }

        select:focus {
            outline: none;
            border-color: var(--main-color);
            box-shadow: 0 0 0 3px rgba(15,118,110,0.16);
        }

        .delivery-point {
            margin-top: 8px;
        }

        .summary-block {
            margin-top: 18px;
            padding: 15px 16px;
            border-radius: 16px;
            background: #f0fdfa;
            border: 1px solid #ccfbf1;
            font-size: 14px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin-bottom: 8px;
            color: #334155;
        }

        .summary-total {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            font-weight: 800;
            font-size: 19px;
            margin-top: 12px;
            padding-top: 12px;
            border-top: 1px solid #99f6e4;
            color: #134e4a;
        }

        .btn-primary {
            margin-top: 20px;
            width: 100%;
            border: none;
            border-radius: 10px;
            padding: 12px 0;
            background: var(--main-color);
            color: #fff;
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(15,118,110,0.25);
        }

        .btn-primary:hover {
            background: var(--main-color-hover);
        }

        .note {
            margin-top: 12px;
            font-size: 12px;
            line-height: 1.45;
            color: var(--muted-color);
        }

        @media (max-width: 650px) {
            .header-inner {
                flex-direction: column;
                align-items: flex-start;
            }

            h1 {
                font-size: 24px;
            }

            .order-card {
                padding: 18px;
            }

            .summary-total {
                flex-direction: column;
                gap: 4px;
            }
        }
    </style>
</head>
<body>

<div class="header">
    <div class="header-inner">
        <div class="logo">Avito<span>Mini</span></div>

        <div class="user-block">
            Вы вошли как
            <b><%= (login != null ? login : "Гость") %></b>
            <a href="logout">Выход</a>
        </div>
    </div>
</div>

<div class="page">

    <p class="back-link">
        <a href="view-ad?id=<%= adId %>">← Назад к объявлению</a>
    </p>

    <h1>Оформление заказа</h1>

    <div class="order-card">
        <div class="order-title">
            Объявление: <b><%= title %></b>
        </div>

        <div class="order-price">
            Стоимость товара:
            <span id="basePrice"
                  class="order-price-main"
                  data-price="<%= priceSafe.toPlainString() %>">
                <%= priceSafe %> ₽
            </span>
        </div>

        <form method="post" action="order">
            <input type="hidden" name="adId" value="<%= adId %>">
            <input type="hidden" name="pickupPoint" id="pickupPointField" value="">

            <div class="field">
                <label for="deliveryMethod">Способ доставки</label>
                <select name="deliveryMethod" id="deliveryMethod" required>
                    <%
                        if ("pickup".equalsIgnoreCase(deliveryMethod)
                                || "both".equalsIgnoreCase(deliveryMethod)) {
                    %>
                    <option value="pickup">Самовывоз</option>
                    <%
                        }
                        if ("delivery".equalsIgnoreCase(deliveryMethod)
                                || "both".equalsIgnoreCase(deliveryMethod)) {
                    %>
                    <option value="delivery">Доставка до ПВЗ</option>
                    <%
                        }
                    %>
                </select>
            </div>

            <div class="field" id="pickupPointWrapper" style="display:none;">
                <label for="pickupPointSelect">Пункт выдачи заказа</label>
                <select id="pickupPointSelect">
                    <option value="">Выберите пункт выдачи</option>
                    <option value="post" data-cost="350">
                        г. Муром, ПВЗ «Почта России», Московская 118 (+350 ₽)
                    </option>
                    <option value="yandex" data-cost="250">
                        г. Муром, ПВЗ «Яндекс Маркет», ТЦ «Крокодил», Кленовая 32 (+250 ₽)
                    </option>
                    <option value="cdek" data-cost="500">
                        г. Муром, ПВЗ «СДЭК», Московская 108 (+500 ₽)
                    </option>
                </select>
            </div>

            <div class="field">
                <label for="paymentMethod">Способ оплаты</label>
                <select name="paymentMethod" id="paymentMethod" required>
                    <option value="cash">Наличными при получении</option>
                    <option value="card">Картой при получении</option>
                </select>
            </div>

            <div class="summary-block">
                <div class="summary-row">
                    <span>Товар:</span>
                    <span id="summaryItem"><%= priceSafe %> ₽</span>
                </div>

                <div class="summary-row">
                    <span>Доставка:</span>
                    <span id="summaryDelivery">0 ₽ (самовывоз)</span>
                </div>

                <div class="summary-total">
                    <span>Итоговая сумма:</span>
                    <span id="summaryTotal"><%= priceSafe %> ₽</span>
                </div>
            </div>

            <button type="submit" class="btn-primary">
                Подтвердить заказ
            </button>

            <div class="note">
                После подтверждения заказ получит статус «ожидает обработки»,
                а объявление будет зарезервировано и станет недоступно для повторного заказа.
            </div>
        </form>
    </div>

</div>

<script>
    const basePrice   = parseFloat(document.getElementById('basePrice').dataset.price || '0');
    const deliverySel = document.getElementById('deliveryMethod');
    const pickupWrap  = document.getElementById('pickupPointWrapper');
    const pickupSel   = document.getElementById('pickupPointSelect');
    const pickupField = document.getElementById('pickupPointField');

    const summaryDelivery = document.getElementById('summaryDelivery');
    const summaryTotal    = document.getElementById('summaryTotal');

    function formatRuble(value) {
        return value.toFixed(2) + ' ₽';
    }

    function recalc() {
        let deliveryCost = 0;
        let deliveryText = '0 ₽ (самовывоз)';

        if (deliverySel.value === 'delivery') {
            pickupWrap.style.display = 'block';

            const option = pickupSel.selectedOptions[0];
            const costAttr = option ? option.getAttribute('data-cost') : null;

            if (costAttr) {
                deliveryCost = parseFloat(costAttr);
                const label = option.textContent || '';
                deliveryText = deliveryCost + ' ₽ (' + label.trim() + ')';
                pickupField.value = option.value;
            } else {
                pickupField.value = '';
            }
        } else {
            pickupWrap.style.display = 'none';
            pickupSel.value = '';
            pickupField.value = '';
        }

        const total = basePrice + deliveryCost;

        summaryDelivery.textContent = deliveryText;
        summaryTotal.textContent = formatRuble(total);
    }

    deliverySel.addEventListener('change', recalc);
    pickupSel.addEventListener('change', recalc);

    recalc();
</script>

</body>
</html>