package avito.repository.interfaces;

import avito.model.Advertisement;

import java.util.List;

public interface AdvertisementRepository {

    Advertisement findById(int id);

    List<Advertisement> findAllActive();

    List<Advertisement> findByUserId(int userId);

    int save(Advertisement advertisement);

    void updateStatus(int advertisementId, String status);

    void deleteById(int advertisementId);
}