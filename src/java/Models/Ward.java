package Models;
import java.util.List;

public class Ward {
    private String name;
    private List<String> hamlets;

    public Ward() {}
    public Ward(String name, List<String> hamlets) { this.name = name; this.hamlets = hamlets; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public List<String> getHamlets() { return hamlets; }
    public void setHamlets(List<String> hamlets) { this.hamlets = hamlets; }
}
