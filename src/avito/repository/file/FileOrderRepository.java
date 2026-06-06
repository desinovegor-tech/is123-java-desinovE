package avito.repository.file;

import avito.model.Order;
import avito.repository.interfaces.OrderRepository;

import java.io.*;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class FileOrderRepository implements OrderRepository {

    private final String filePath = "data/orders.txt";

    @Override
    public Order findById(int id) {
        for (Order order : readOrders()) {
            if (order.getId() == id) {
                return order;
            }
        }
        return null;
    }

    @Override
    public List<Order> findByBuyerId(int buyerId) {
        List<Order> result = new ArrayList<>();

        for (Order order : readOrders()) {
            if (order.getBuyerId() == buyerId) {
                result.add(order);
            }
        }

        return result;
    }

    @Override
    public void save(Order order) {
        List<Order> orders = readOrders();

        int newId = getNextId(orders);
        order.setId(newId);

        if (order.getStatus() == null) {
            order.setStatus("pending");
        }

        orders.add(order);
        writeOrders(orders);
    }

    @Override
    public void cancelOrder(int orderId) {
        List<Order> orders = readOrders();

        for (Order order : orders) {
            if (order.getId() == orderId) {
                order.setStatus("canceled");
                break;
            }
        }

        writeOrders(orders);
    }

    @Override
    public boolean existsActiveOrderForAdvertisement(int advertisementId) {
        for (Order order : readOrders()) {
            if (order.getAdvertisementId() == advertisementId
                    && !"canceled".equalsIgnoreCase(order.getStatus())) {
                return true;
            }
        }

        return false;
    }

    private List<Order> readOrders() {
        List<Order> orders = new ArrayList<>();

        File file = new File(filePath);
        if (!file.exists()) {
            return orders;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;

            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(";");

                if (parts.length >= 9) {
                    Order order = new Order();

                    order.setId(Integer.parseInt(parts[0]));
                    order.setAdvertisementId(Integer.parseInt(parts[1]));
                    order.setBuyerId(Integer.parseInt(parts[2]));

                    if (!"null".equals(parts[3]) && !parts[3].isEmpty()) {
                        order.setOrderDate(Timestamp.valueOf(parts[3]));
                    }

                    order.setDeliveryMethod(parts[4]);
                    order.setPickupPoint(parts[5]);
                    order.setPaymentMethod(parts[6]);
                    order.setStatus(parts[7]);
                    order.setTotalAmount(new BigDecimal(parts[8]));

                    orders.add(order);
                }
            }

        } catch (IOException e) {
            throw new RuntimeException("Ошибка при чтении заказов из файла", e);
        }

        return orders;
    }

    private void writeOrders(List<Order> orders) {
        File file = new File(filePath);
        file.getParentFile().mkdirs();

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (Order order : orders) {
                writer.write(
                        order.getId() + ";" +
                                order.getAdvertisementId() + ";" +
                                order.getBuyerId() + ";" +
                                order.getOrderDate() + ";" +
                                safe(order.getDeliveryMethod()) + ";" +
                                safe(order.getPickupPoint()) + ";" +
                                safe(order.getPaymentMethod()) + ";" +
                                safe(order.getStatus()) + ";" +
                                order.getTotalAmount()
                );
                writer.newLine();
            }

        } catch (IOException e) {
            throw new RuntimeException("Ошибка при записи заказов в файл", e);
        }
    }

    private int getNextId(List<Order> orders) {
        int maxId = 0;

        for (Order order : orders) {
            if (order.getId() > maxId) {
                maxId = order.getId();
            }
        }

        return maxId + 1;
    }

    private String safe(String value) {
        if (value == null) {
            return "";
        }
        return value.replace(";", ",");
    }
}