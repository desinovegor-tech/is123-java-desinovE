package avito.strategy;

import java.math.BigDecimal;

public interface DeliveryCostStrategy {

    BigDecimal calculateDeliveryCost();

    String getDeliveryName();
}