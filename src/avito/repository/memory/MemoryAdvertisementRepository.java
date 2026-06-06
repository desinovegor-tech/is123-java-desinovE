package avito.repository.memory;

import avito.model.Advertisement;
import avito.repository.interfaces.AdvertisementRepository;

import java.util.ArrayList;
import java.util.List;

public class MemoryAdvertisementRepository implements AdvertisementRepository {

    private final List<Advertisement> advertisements = new ArrayList<>();
    private int nextId = 1;

    @Override
    public Advertisement findById(int id) {
        for (Advertisement advertisement : advertisements) {
            if (advertisement.getId() == id) {
                return advertisement;
            }
        }
        return null;
    }

    @Override
    public List<Advertisement> findAllActive() {
        List<Advertisement> result = new ArrayList<>();

        for (Advertisement advertisement : advertisements) {
            if ("active".equalsIgnoreCase(advertisement.getStatus())) {
                result.add(advertisement);
            }
        }

        return result;
    }

    @Override
    public List<Advertisement> findByUserId(int userId) {
        List<Advertisement> result = new ArrayList<>();

        for (Advertisement advertisement : advertisements) {
            if (advertisement.getUserId() == userId) {
                result.add(advertisement);
            }
        }

        return result;
    }

    @Override
    public int save(Advertisement advertisement) {
        advertisement.setId(nextId++);
        advertisement.setStatus("active");
        advertisements.add(advertisement);

        return advertisement.getId();
    }

    @Override
    public void updateStatus(int advertisementId, String status) {
        Advertisement advertisement = findById(advertisementId);

        if (advertisement != null) {
            advertisement.setStatus(status);
        }
    }

    @Override
    public void deleteById(int advertisementId) {
        updateStatus(advertisementId, "archived");
    }
}