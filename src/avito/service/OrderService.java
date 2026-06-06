package avito.service;

import avito.strategy.DeliveryCostStrategy;
import avito.strategy.DeliveryStrategyFactory;

import java.math.BigDecimal;

public class OrderService {

    public BigDecimal calculateTotalAmount(BigDecimal itemPrice, String deliveryMethod) {
        DeliveryCostStrategy deliveryStrategy = DeliveryStrategyFactory.getStrategy(deliveryMethod);

        BigDecimal deliveryCost = deliveryStrategy.calculateDeliveryCost();

        return itemPrice.add(deliveryCost);
    }

    public BigDecimal calculateDeliveryCost(String deliveryMethod) {
        DeliveryCostStrategy deliveryStrategy = DeliveryStrategyFactory.getStrategy(deliveryMethod);

        return deliveryStrategy.calculateDeliveryCost();
    }
}