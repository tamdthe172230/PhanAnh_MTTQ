package Models;

public class Document {
    private int id;
    private String title;
    private String category;
    private String docDate;
    private String filePath;
    private String fileData;
    private String description;
    private int isDeleted;

    public Document() {
    }

    public Document(int id, String title, String category, String docDate, String filePath, String fileData, String description, int isDeleted) {
        this.id = id;
        this.title = title;
        this.category = category;
        this.docDate = docDate;
        this.filePath = filePath;
        this.fileData = fileData;
        this.description = description;
        this.isDeleted = isDeleted;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getDocDate() {
        return docDate;
    }

    public void setDocDate(String docDate) {
        this.docDate = docDate;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFileData() {
        return fileData;
    }

    public void setFileData(String fileData) {
        this.fileData = fileData;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(int isDeleted) {
        this.isDeleted = isDeleted;
    }
}
