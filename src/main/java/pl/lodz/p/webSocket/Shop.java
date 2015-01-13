package pl.lodz.p.webSocket;

/**
 * Created by Łukasz Ochmański on 1/13/2015.
 */

public class Shop {

    String name;

    String staffName[];
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String[] getStaffName() {
        return staffName;
    }
    public void setStaffName(String[] staffName) {
        this.staffName = staffName;
    }
    public Shop() {
    }

}