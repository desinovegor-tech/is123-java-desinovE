package avito;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    // Создать хеш пароля: SALT:HASH (обе части в Base64)
    public static String hashPassword(String plainPassword) {
        if (plainPassword == null) {
            throw new IllegalArgumentException("password is null");
        }

        byte[] salt = new byte[16];
        RANDOM.nextBytes(salt);

        byte[] hash = sha256(salt, plainPassword);

        String saltB64 = Base64.getEncoder().encodeToString(salt);
        String hashB64 = Base64.getEncoder().encodeToString(hash);

        return saltB64 + ":" + hashB64;
    }

    // Проверка пароля
    public static boolean checkPassword(String plainPassword, String storedValue) {
        if (plainPassword == null || storedValue == null) {
            return false;
        }

        String[] parts = storedValue.split(":");
        if (parts.length != 2) {
            // в БД лежит что-то не в формате SALT:HASH
            return false;
        }

        byte[] salt = Base64.getDecoder().decode(parts[0]);
        byte[] expectedHash = Base64.getDecoder().decode(parts[1]);

        byte[] actualHash = sha256(salt, plainPassword);

        // сравнение "без подсказок" по времени
        if (actualHash.length != expectedHash.length) return false;
        int diff = 0;
        for (int i = 0; i < actualHash.length; i++) {
            diff |= actualHash[i] ^ expectedHash[i];
        }
        return diff == 0;
    }

    private static byte[] sha256(byte[] salt, String value) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            md.update(value.getBytes(StandardCharsets.UTF_8));
            return md.digest();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }
}
