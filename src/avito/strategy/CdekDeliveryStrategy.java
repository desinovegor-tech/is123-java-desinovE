package avito.strategy;

import java.math.BigDecimal;

public class CdekDeliveryStrategy implements DeliveryCostStrategy {

    @Override
    public BigDecimal calculateDeliveryCost() {
        return new BigDecimal("500");
    }

    @Override
    public String getDeliveryName() {
        return "СДЭК";
    }
}