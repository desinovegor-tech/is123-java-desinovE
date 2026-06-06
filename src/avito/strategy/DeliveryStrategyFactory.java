package avito.strategy;

public class DeliveryStrategyFactory {

    public static DeliveryCostStrategy getStrategy(String deliveryMethod) {
        if (deliveryMethod == null) {
            return new PickupDeliveryStrategy();
        }

        switch (deliveryMethod) {
            case "post":
                return new PostDeliveryStrategy();

            case "yandex":
                return new YandexDeliveryStrategy();

            case "cdek":
                return new CdekDeliveryStrategy();

            case "pickup":
            default:
                return new PickupDeliveryStrategy();
        }
    }
}