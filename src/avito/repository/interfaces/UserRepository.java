package avito.repository.interfaces;

import avito.model.User;

public interface UserRepository {

    User findByLogin(String login);

    User findById(int id);

    boolean existsByLogin(String login);

    void save(User user);

    void updateProfile(int userId, String name, String city, String phone);
}