package avito.repository.memory;

import avito.model.Order;
import avito.repository.interfaces.OrderRepository;

import java.util.ArrayList;
import java.util.List;

public class MemoryOrderRepository implements OrderRepository {

    private final List<Order> orders = new ArrayList<>();
    private int nextId = 1;

    @Override
    public Order findById(int id) {
        for (Order order : orders) {
            if (order.getId() == id) {
                return order;
            }
        }
        return null;
    }

    @Override
    public List<Order> findByBuyerId(int buyerId) {
        List<Order> result = new ArrayList<>();

        for (Order order : orders) {
            if (order.getBuyerId() == buyerId) {
                result.add(order);
            }
        }

        return result;
    }

    @Override
    public void save(Order order) {
        order.setId(nextId++);
        if (order.getStatus() == null) {
            order.setStatus("pending");
        }
        orders.add(order);
    }

    @Override
    public void cancelOrder(int orderId) {
        Order order = findById(orderId);

        if (order != null) {
            order.setStatus("canceled");
        }
    }

    @Override
    public boolean existsActiveOrderForAdvertisement(int advertisementId) {
        for (Order order : orders) {
            if (order.getAdvertisementId() == advertisementId
                    && !"canceled".equalsIgnoreCase(order.getStatus())) {
                return true;
            }
        }

        return false;
    }
}