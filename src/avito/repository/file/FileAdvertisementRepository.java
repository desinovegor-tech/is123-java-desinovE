package avito.repository.file;

import avito.model.Advertisement;
import avito.repository.interfaces.AdvertisementRepository;

import java.io.*;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class FileAdvertisementRepository implements AdvertisementRepository {

    private final String filePath = "data/advertisements.txt";

    @Override
    public Advertisement findById(int id) {
        for (Advertisement advertisement : readAdvertisements()) {
            if (advertisement.getId() == id) {
                return advertisement;
            }
        }
        return null;
    }

    @Override
    public List<Advertisement> findAllActive() {
        List<Advertisement> result = new ArrayList<>();

        for (Advertisement advertisement : readAdvertisements()) {
            if ("active".equalsIgnoreCase(advertisement.getStatus())) {
                result.add(advertisement);
            }
        }

        return result;
    }

    @Override
    public List<Advertisement> findByUserId(int userId) {
        List<Advertisement> result = new ArrayList<>();

        for (Advertisement advertisement : readAdvertisements()) {
            if (advertisement.getUserId() == userId) {
                result.add(advertisement);
            }
        }

        return result;
    }

    @Override
    public int save(Advertisement advertisement) {
        List<Advertisement> advertisements = readAdvertisements();

        int newId = getNextId(advertisements);
        advertisement.setId(newId);
        advertisement.setStatus("active");

        advertisements.add(advertisement);
        writeAdvertisements(advertisements);

        return newId;
    }

    @Override
    public void updateStatus(int advertisementId, String status) {
        List<Advertisement> advertisements = readAdvertisements();

        for (Advertisement advertisement : advertisements) {
            if (advertisement.getId() == advertisementId) {
                advertisement.setStatus(status);
                break;
            }
        }

        writeAdvertisements(advertisements);
    }

    @Override
    public void deleteById(int advertisementId) {
        updateStatus(advertisementId, "archived");
    }

    private List<Advertisement> readAdvertisements() {
        List<Advertisement> advertisements = new ArrayList<>();

        File file = new File(filePath);
        if (!file.exists()) {
            return advertisements;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;

            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(";");

                if (parts.length >= 11) {
                    Advertisement advertisement = new Advertisement();

                    advertisement.setId(Integer.parseInt(parts[0]));
                    advertisement.setUserId(Integer.parseInt(parts[1]));
                    advertisement.setTitle(parts[2]);
                    advertisement.setDescription(parts[3]);
                    advertisement.setPrice(Double.parseDouble(parts[4]));
                    advertisement.setCategoryId(Integer.parseInt(parts[5]));
                    advertisement.setStatus(parts[6]);

                    if (!parts[7].equals("null")) {
                        advertisement.setPublicationDate(Timestamp.valueOf(parts[7]));
                    }

                    advertisement.setLocation(parts[8]);
                    advertisement.setCondition(parts[9]);
                    advertisement.setDeliveryMethod(parts[10]);

                    advertisements.add(advertisement);
                }
            }

        } catch (IOException e) {
            throw new RuntimeException("Ошибка при чтении объявлений из файла", e);
        }

        return advertisements;
    }

    private void writeAdvertisements(List<Advertisement> advertisements) {
        File file = new File(filePath);
        file.getParentFile().mkdirs();

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (Advertisement advertisement : advertisements) {
                writer.write(
                        advertisement.getId() + ";" +
                                advertisement.getUserId() + ";" +
                                safe(advertisement.getTitle()) + ";" +
                                safe(advertisement.getDescription()) + ";" +
                                advertisement.getPrice() + ";" +
                                advertisement.getCategoryId() + ";" +
                                safe(advertisement.getStatus()) + ";" +
                                advertisement.getPublicationDate() + ";" +
                                safe(advertisement.getLocation()) + ";" +
                                safe(advertisement.getCondition()) + ";" +
                                safe(advertisement.getDeliveryMethod())
                );
                writer.newLine();
            }

        } catch (IOException e) {
            throw new RuntimeException("Ошибка при записи объявлений в файл", e);
        }
    }

    private int getNextId(List<Advertisement> advertisements) {
        int maxId = 0;

        for (Advertisement advertisement : advertisements) {
            if (advertisement.getId() > maxId) {
                maxId = advertisement.getId();
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