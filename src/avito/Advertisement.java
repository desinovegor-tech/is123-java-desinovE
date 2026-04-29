package avito;

public class Advertisement {
    private int id;
    private String title;
    private double price;
    private String location;
    private String mainImageUrl;

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
    public String getMainImageUrl() {
        return mainImageUrl;
    }

    public void setMainImageUrl(String mainImageUrl) {
        this.mainImageUrl = mainImageUrl;
    }
    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public double getPrice() {
        return price;
    }

    public String getLocation() {
        return location;
    }
    private String mainPhoto;   // имя файла первой фотки

    public String getMainPhoto() {
        return mainPhoto;
    }

    public void setMainPhoto(String mainPhoto) {
        this.mainPhoto = mainPhoto;
    }

}
