package avito.factory;

import avito.repository.file.FileAdvertisementRepository;
import avito.repository.file.FileOrderRepository;
import avito.repository.file.FileUserRepository;
import avito.repository.interfaces.AdvertisementRepository;
import avito.repository.interfaces.OrderRepository;
import avito.repository.interfaces.UserRepository;
import avito.repository.jdbc.JdbcAdvertisementRepository;
import avito.repository.jdbc.JdbcOrderRepository;
import avito.repository.jdbc.JdbcUserRepository;
import avito.repository.memory.MemoryAdvertisementRepository;
import avito.repository.memory.MemoryOrderRepository;
import avito.repository.memory.MemoryUserRepository;

public class RepositoryFactory {

    public enum RepositoryType {
        JDBC,
        MEMORY,
        FILE
    }

    private static final RepositoryType DEFAULT_TYPE = RepositoryType.JDBC;

    public static UserRepository getUserRepository() {
        return getUserRepository(DEFAULT_TYPE);
    }

    public static UserRepository getUserRepository(RepositoryType type) {
        switch (type) {
            case MEMORY:
                return new MemoryUserRepository();
            case FILE:
                return new FileUserRepository();
            case JDBC:
            default:
                return new JdbcUserRepository();
        }
    }

    public static AdvertisementRepository getAdvertisementRepository() {
        return getAdvertisementRepository(DEFAULT_TYPE);
    }

    public static AdvertisementRepository getAdvertisementRepository(RepositoryType type) {
        switch (type) {
            case MEMORY:
                return new MemoryAdvertisementRepository();
            case FILE:
                return new FileAdvertisementRepository();
            case JDBC:
            default:
                return new JdbcAdvertisementRepository();
        }
    }

    public static OrderRepository getOrderRepository() {
        return getOrderRepository(DEFAULT_TYPE);
    }

    public static OrderRepository getOrderRepository(RepositoryType type) {
        switch (type) {
            case MEMORY:
                return new MemoryOrderRepository();
            case FILE:
                return new FileOrderRepository();
            case JDBC:
            default:
                return new JdbcOrderRepository();
        }
    }
}