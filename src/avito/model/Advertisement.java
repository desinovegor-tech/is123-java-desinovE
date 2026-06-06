package avito.model;

import java.sql.Timestamp;

public class Advertisement {
    private int id;
    private int userId;
    private String title;
    private String description;
    private double price;
    private int categoryId;
    private String status;
    private Timestamp publicationDate;
    private String location;
    private String condition;
    private String deliveryMethod;
    private String mainImageUrl;
    private String mainPhoto;

    public Advertisement() {
    }

    public Advertisement(int id, String title, double price, String location) {
        this.id = id;
        this.title = title;
        this.price = price;
        this.location = location;
    }

    public Advertisement(int id, String title, double price, String location, String mainImageUrl) {
        this(id, title, price, location);
        this.mainImageUrl = mainImageUrl;
    }

    public Advertisement(int id, int userId, String title, String description, double price,
                         int categoryId, String status, Timestamp publicationDate,
                         String location, String condition, String deliveryMethod) {
        this.id = id;
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.price = price;
        this.categoryId = categoryId;
        this.status = status;
        this.publicationDate = publicationDate;
        this.location = location;
        this.condition = condition;
        this.deliveryMethod = deliveryMethod;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }


    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }


    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }


    public Timestamp getPublicationDate() {
        return publicationDate;
    }

    public void setPublicationDate(Timestamp publicationDate) {
        this.publicationDate = publicationDate;
    }


    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }


    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }


    public String getDeliveryMethod() {
        return deliveryMethod;
    }

    public void setDeliveryMethod(String deliveryMethod) {
        this.deliveryMethod = deliveryMethod;
    }


    public String getMainImageUrl() {
        return mainImageUrl;
    }

    public void setMainImageUrl(String mainImageUrl) {
        this.mainImageUrl = mainImageUrl;
    }


    public String getMainPhoto() {
        return mainPhoto;
    }

    public void setMainPhoto(String mainPhoto) {
        this.mainPhoto = mainPhoto;
    }
}