package chauss;

import java.util.List;

public class TestFetch {
    public static void main(String[] args) {
        try {
            List<Shoe> shoes = ShoeData.getAllShoes();
            if (shoes == null || shoes.isEmpty()) {
                System.out.println("No shoes returned from DB.");
            } else {
                for (Shoe s : shoes) {
                    System.out.println("ID:" + s.getId() + " Name:" + s.getName() + " Brand:" + s.getBrand() + " Size:" + s.getSize() + " Color:" + s.getColor() + " Type:" + s.getType() + " Price:" + s.getPrice() + " Desc:" + s.getDescription());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
