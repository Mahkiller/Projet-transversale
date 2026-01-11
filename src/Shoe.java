package chauss;

public class Shoe {
    private int id;
    private String name;
    private String brand;
    private int size;
    private String color;
    private String type;
    private double price;
    private String description;
    private String image;

    public Shoe() {}

    public Shoe(int id, String name, String brand, int size, String color, String type, double price, String description, String image) {
        this.id = id;
        this.name = name;
        this.brand = brand;
        this.size = size;
        this.color = color;
        this.type = type;
        this.price = price;
        this.description = description;
        this.image = image;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBrand() { return brand; }
    public void setBrand(String brand) { this.brand = brand; }

    public int getSize() { return size; }
    public void setSize(int size) { this.size = size; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
}