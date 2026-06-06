package avito.strategy;

import java.math.BigDecimal;

public class YandexDeliveryStrategy implements DeliveryCostStrategy {

    @Override
    public BigDecimal calculateDeliveryCost() {
        return new BigDecimal("250");
    }

    @Override
    public String getDeliveryName() {
        return "Яндекс Маркет";
    }
}