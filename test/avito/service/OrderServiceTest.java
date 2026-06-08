package avito.service;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class OrderServiceTest {

    @Test
    public void calculateDeliveryCostShouldReturnPostPrice() {
        OrderService orderService = new OrderService();

        BigDecimal result = orderService.calculateDeliveryCost("post");

        assertEquals(new BigDecimal("350"), result);
    }

    @Test
    public void calculateDeliveryCostShouldReturnPickupPrice() {
        OrderService orderService = new OrderService();

        BigDecimal result = orderService.calculateDeliveryCost("pickup");

        assertEquals(BigDecimal.ZERO, result);
    }

    @Test
    public void calculateTotalAmountShouldAddItemPriceAndDeliveryCost() {
        OrderService orderService = new OrderService();

        BigDecimal itemPrice = new BigDecimal("1500");
        BigDecimal result = orderService.calculateTotalAmount(itemPrice, "cdek");

        assertEquals(new BigDecimal("2000"), result);
    }

    @Test
    public void calculateTotalAmountWithPickupShouldReturnOnlyItemPrice() {
        OrderService orderService = new OrderService();

        BigDecimal itemPrice = new BigDecimal("1500");
        BigDecimal result = orderService.calculateTotalAmount(itemPrice, "pickup");

        assertEquals(new BigDecimal("1500"), result);
    }
}