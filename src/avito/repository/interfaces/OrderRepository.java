package avito.repository.interfaces;

import avito.model.Order;

import java.util.List;

public interface OrderRepository {

    Order findById(int id);

    List<Order> findByBuyerId(int buyerId);

    void save(Order order);

    void cancelOrder(int orderId);

    boolean existsActiveOrderForAdvertisement(int advertisementId);
}