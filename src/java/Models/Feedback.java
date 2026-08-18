package Models;

public class Feedback {
    private int id;
    private String voterName;
    private String phone;
    private String date;
    private String thon;
    private String type;
    private String status;
    private String statusLabel;
    private String content;
    private String reply;
    private String attachedFile;
    private String email;

    public Feedback() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getVoterName() { return voterName; }
    public void setVoterName(String voterName) { this.voterName = voterName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }
    public String getThon() { return thon; }
    public void setThon(String thon) { this.thon = thon; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getStatusLabel() { return statusLabel; }
    public void setStatusLabel(String statusLabel) { this.statusLabel = statusLabel; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }
    public String getAttachedFile() { return attachedFile; }
    public void setAttachedFile(String attachedFile) { this.attachedFile = attachedFile; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
