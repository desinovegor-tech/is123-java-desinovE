package avito.strategy;

import java.math.BigDecimal;

public class PostDeliveryStrategy implements DeliveryCostStrategy {

    @Override
    public BigDecimal calculateDeliveryCost() {
        return new BigDecimal("350");
    }

    @Override
    public String getDeliveryName() {
        return "Почта России";
    }
}