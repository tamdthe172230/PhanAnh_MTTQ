package Models;
import java.util.Map;

public class District {
    private String name;
    private Map<String, Ward> wards;

    public District() {}
    public District(String name, Map<String, Ward> wards) { this.name = name; this.wards = wards; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Map<String, Ward> getWards() { return wards; }
    public void setWards(Map<String, Ward> wards) { this.wards = wards; }
}
