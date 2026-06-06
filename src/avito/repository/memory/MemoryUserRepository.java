package avito.repository.memory;

import avito.model.User;
import avito.repository.interfaces.UserRepository;

import java.util.ArrayList;
import java.util.List;

public class MemoryUserRepository implements UserRepository {

    private final List<User> users = new ArrayList<>();

    @Override
    public User findByLogin(String login) {
        for (User user : users) {
            if (user.getLogin() != null && user.getLogin().equals(login)) {
                return user;
            }
        }
        return null;
    }

    @Override
    public User findById(int id) {
        for (User user : users) {
            if (user.getId() == id) {
                return user;
            }
        }
        return null;
    }

    @Override
    public boolean existsByLogin(String login) {
        return findByLogin(login) != null;
    }

    @Override
    public void save(User user) {
        users.add(user);
    }

    @Override
    public void updateProfile(int userId, String name, String city, String phone) {
        User user = findById(userId);

        if (user != null) {
            user.setName(name);
            user.setCity(city);
            user.setPhone(phone);
        }
    }
}