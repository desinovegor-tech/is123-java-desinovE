package avito.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Order {
    private int id;
    private int advertisementId;
    private int buyerId;
    private Timestamp orderDate;
    private String deliveryMethod;
    private String pickupPoint;
    private String paymentMethod;
    private String status;
    private BigDecimal totalAmount;

    public Order() {
    }

    public Order(int id, int advertisementId, int buyerId, Timestamp orderDate,
                 String deliveryMethod, String pickupPoint, String paymentMethod,
                 String status, BigDecimal totalAmount) {
        this.id = id;
        this.advertisementId = advertisementId;
        this.buyerId = buyerId;
        this.orderDate = orderDate;
        this.deliveryMethod = deliveryMethod;
        this.pickupPoint = pickupPoint;
        this.paymentMethod = paymentMethod;
        this.status = status;
        this.totalAmount = totalAmount;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public int getAdvertisementId() {
        return advertisementId;
    }

    public void setAdvertisementId(int advertisementId) {
        this.advertisementId = advertisementId;
    }


    public int getBuyerId() {
        return buyerId;
    }

    public void setBuyerId(int buyerId) {
        this.buyerId = buyerId;
    }


    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }


    public String getDeliveryMethod() {
        return deliveryMethod;
    }

    public void setDeliveryMethod(String deliveryMethod) {
        this.deliveryMethod = deliveryMethod;
    }


    public String getPickupPoint() {
        return pickupPoint;
    }

    public void setPickupPoint(String pickupPoint) {
        this.pickupPoint = pickupPoint;
    }


    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }


    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
}