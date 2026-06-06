package avito.repository.file;

import avito.model.User;
import avito.repository.interfaces.UserRepository;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FileUserRepository implements UserRepository {

    private final String filePath = "data/users.txt";

    @Override
    public User findByLogin(String login) {
        for (User user : readUsers()) {
            if (user.getLogin() != null && user.getLogin().equals(login)) {
                return user;
            }
        }
        return null;
    }

    @Override
    public User findById(int id) {
        for (User user : readUsers()) {
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
        List<User> users = readUsers();
        users.add(user);
        writeUsers(users);
    }

    @Override
    public void updateProfile(int userId, String name, String city, String phone) {
        List<User> users = readUsers();

        for (User user : users) {
            if (user.getId() == userId) {
                user.setName(name);
                user.setCity(city);
                user.setPhone(phone);
                break;
            }
        }

        writeUsers(users);
    }

    private List<User> readUsers() {
        List<User> users = new ArrayList<>();

        File file = new File(filePath);
        if (!file.exists()) {
            return users;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;

            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(";");

                if (parts.length >= 6) {
                    User user = new User();

                    user.setId(Integer.parseInt(parts[0]));
                    user.setLogin(parts[1]);
                    user.setPassword(parts[2]);
                    user.setName(parts[3]);
                    user.setCity(parts[4]);
                    user.setPhone(parts[5]);

                    users.add(user);
                }
            }

        } catch (IOException e) {
            throw new RuntimeException("Ошибка при чтении пользователей из файла", e);
        }

        return users;
    }

    private void writeUsers(List<User> users) {
        File file = new File(filePath);
        file.getParentFile().mkdirs();

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (User user : users) {
                writer.write(
                        user.getId() + ";" +
                                user.getLogin() + ";" +
                                user.getPassword() + ";" +
                                user.getName() + ";" +
                                user.getCity() + ";" +
                                user.getPhone()
                );
                writer.newLine();
            }

        } catch (IOException e) {
            throw new RuntimeException("Ошибка при записи пользователей в файл", e);
        }
    }
}