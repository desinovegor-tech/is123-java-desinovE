package avito.strategy;

import java.math.BigDecimal;

public class PickupDeliveryStrategy implements DeliveryCostStrategy {

    @Override
    public BigDecimal calculateDeliveryCost() {
        return BigDecimal.ZERO;
    }

    @Override
    public String getDeliveryName() {
        return "Самовывоз";
    }
}