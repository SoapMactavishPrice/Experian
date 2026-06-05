public class LeegalityWebhookWrapper {

    public String webhookType;
    public String documentId;
    public String documentStatus;
    public String irn;
    public String mac;

    public Verification verification;
    public Request request;
    public List<Object> messages;

    public class Verification {
        public Boolean name;
        public Integer smartName;
        public Boolean pincode;
        public Boolean state;
        public Boolean title;
        public Boolean yob;
        public Boolean gender;
    }

    public class Request {
        public String inviteeType;
        public String name;
        public String email;
        public String phone;
        public String invitationUrl;
        public Boolean active;
        public String action;
        public String error;
        public Boolean expired;
        public String expiryDate;
        public String rejectionMessage;
        public String signType;
    }
}