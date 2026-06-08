package avito.strategy;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class DeliveryStrategyTest {

    @Test
    public void pickupDeliveryShouldCostZero() {
        DeliveryCostStrategy strategy = new PickupDeliveryStrategy();

        BigDecimal result = strategy.calculateDeliveryCost();

        assertEquals(BigDecimal.ZERO, result);
    }

    @Test
    public void postDeliveryShouldCost350() {
        DeliveryCostStrategy strategy = new PostDeliveryStrategy();

        BigDecimal result = strategy.calculateDeliveryCost();

        assertEquals(new BigDecimal("350"), result);
    }

    @Test
    public void yandexDeliveryShouldCost250() {
        DeliveryCostStrategy strategy = new YandexDeliveryStrategy();

        BigDecimal result = strategy.calculateDeliveryCost();

        assertEquals(new BigDecimal("250"), result);
    }

    @Test
    public void cdekDeliveryShouldCost500() {
        DeliveryCostStrategy strategy = new CdekDeliveryStrategy();

        BigDecimal result = strategy.calculateDeliveryCost();

        assertEquals(new BigDecimal("500"), result);
    }

    @Test
    public void factoryShouldReturnCorrectStrategy() {
        DeliveryCostStrategy strategy = DeliveryStrategyFactory.getStrategy("cdek");

        assertTrue(strategy instanceof CdekDeliveryStrategy);
    }

    @Test
    public void factoryShouldReturnPickupStrategyForUnknownValue() {
        DeliveryCostStrategy strategy = DeliveryStrategyFactory.getStrategy("unknown");

        assertTrue(strategy instanceof PickupDeliveryStrategy);
    }
}