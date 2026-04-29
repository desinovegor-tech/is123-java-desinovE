<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.math.BigDecimal" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Оформление заказа</title>
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

        .page {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px 15px 40px;
        }

        .back-link {
            font-size: 13px;
            margin-bottom: 10px;
        }

        h1 {
            margin: 0 0 20px;
            font-size: 24px;
        }

        .order-card {
            background: #ffffff;
            border-radius: 10px;
            padding: 20px 22px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .order-title {
            font-size: 16px;
            margin-bottom: 10px;
        }
        .order-title b {
            font-weight: 600;
        }

        .order-price {
            margin-bottom: 15px;
            font-size: 15px;
        }
        .order-price-main {
            font-weight: 700;
            font-size: 18px;
        }

        .field {
            margin-bottom: 12px;
        }
        .field label {
            display: block;
            font-size: 13px;
            color: #555;
            margin-bottom: 4px;
        }
        select {
            width: 100%;
            box-sizing: border-box;
            padding: 8px 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }
        select:focus {
            outline: none;
            border-color: #6c2cff;
            box-shadow: 0 0 0 1px rgba(108,44,255,0.2);
        }

        .delivery-point {
            margin-top: 8px;
        }

        .summary-block {
            margin-top: 15px;
            padding-top: 12px;
            border-top: 1px solid #eee;
            font-size: 14px;
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 4px;
        }
        .summary-total {
            font-weight: 700;
            font-size: 18px;
            margin-top: 6px;
        }

        .btn-primary {
            margin-top: 18px;
            width: 100%;
            border: none;
            border-radius: 8px;
            padding: 10px 0;
            background: #6c2cff;
            color: #fff;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
        }
        .btn-primary:hover {
            background: #5a22e0;
        }
    </style>
</head>
<body>

<%
    Integer adId = (Integer) request.getAttribute("adId");
    String title = (String) request.getAttribute("title");
    BigDecimal price = (BigDecimal) request.getAttribute("price");
    String deliveryMethod = (String) request.getAttribute("deliveryMethod");

    BigDecimal priceSafe = (price != null ? price : BigDecimal.ZERO);
%>

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
            <!-- сюда положим код ПВЗ (post / yandex / cdek) -->
            <input type="hidden" name="pickupPoint" id="pickupPointField" value="">

            <!-- Способ доставки -->
            <div class="field">
                <label for="deliveryMethod">Способ доставки</label>
                <select name="deliveryMethod" id="deliveryMethod" required>
                    <%
                        // deliveryMethod у объявления: "pickup", "delivery", "both"
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

            <!-- ПВЗ (виден только если выбрана доставка) -->
            <div class="field" id="pickupPointWrapper" style="display:none;">
                <label for="pickupPointSelect">Пункт выдачи заказа</label>
                <select id="pickupPointSelect">
                    <option value="">Выберите пункт выдачи</option>
                    <option value="post"   data-cost="350">
                        г. Муром, ПВЗ «Почта России», Московская 118 (+350 ₽)
                    </option>
                    <option value="yandex" data-cost="250">
                        г. Муром, ПВЗ «Яндекс Маркет», ТЦ «Крокодил», Кленовая 32 (+250 ₽)
                    </option>
                    <option value="cdek"   data-cost="500">
                        г. Муром, ПВЗ «СДЭК», Московская 108 (+500 ₽)
                    </option>
                </select>
            </div>

            <!-- Способ оплаты -->
            <div class="field">
                <label for="paymentMethod">Способ оплаты</label>
                <select name="paymentMethod" id="paymentMethod" required>
                    <option value="cash">Наличными при получении</option>
                    <option value="card">Картой при получении</option>
                </select>
            </div>

            <!-- Итоговая сумма -->
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
                    Итоговая сумма:
                    <span id="summaryTotal"><%= priceSafe %> ₽</span>
                </div>
            </div>

            <button type="submit" class="btn-primary">
                Подтвердить заказ
            </button>
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
                pickupField.value = option.value; // post / yandex / cdek
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
        summaryTotal.textContent    = formatRuble(total);
    }

    deliverySel.addEventListener('change', recalc);
    pickupSel.addEventListener('change', recalc);

    // первый пересчёт при загрузке
    recalc();
</script>

</body>
</html>
