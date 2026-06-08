public class UpdateContactSitePage {
    
    Public String contactId {get;set;}
    public Integer responseSize {get;set;}
    public Contact_Response__c lResponses{get;set;}
    public Contact lResponses1{get;set;} 
    public Boolean isExpired {get;set;}
    
    public UpdateContactSitePage() {
        contactId = ApexPages.currentPage().getParameters().get('recordId');
        
        /*List<Contact_Response__c> lResponses = [SELECT Id,Salutation__c,First_Name__c,Last_Name__c,Email__c,Email_2__c,Phone_2__c,Job_Title__c
                                                FROM Contact_Response__c WHERE Contact__c =: contactId];*/
        
        lResponses1 = [SELECT Id ,Salutation,FirstName,LastName,Account.Name,Email,Title,Department,Email_2__c,
                       MobilePhone,Phone,Phone_2__c,MailingStreet,MailingCity,MailingPostalCode,MailingState,MailingCountry, Birthdate,Job_Title__c,
                       Update_Contact_Link_Sent__c,Update_Contact_Link_Sent_Date__c,Response_Received__c
                       FROM Contact WHERE ID =: contactId];
        
        if(lResponses1.Update_Contact_Link_Sent_Date__c != null) {
            Date sendDate = lResponses1.Update_Contact_Link_Sent_Date__c;
            if(sendDate.addDays(30) < System.today()) {
                system.debug('send date'+sendDate.addDays(15));
                system.debug('today date'+System.today());
                isExpired = true;
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'The page you are trying to access is expired now.'));
            }
        }
        responseSize = 0;
    }
    
    
    @RemoteAction
    public static Boolean updateAWPLead(String json, String contactId) {
        
        AWPJSON awpData = parseAWP(json);
        
        Contact_Response__c lResponse = new Contact_Response__c();
        lResponse.Contact__c =contactId;
        lResponse.Salutation__c = awpData.Salutation;
        lResponse.First_Name__c= awpData.FirstName;
        lResponse.Last_Name__c= awpData.LastName;
        lResponse.Email__c= awpData.Email;
        lResponse.Email_2__c= awpData.Personal_Email;
        lResponse.Phone__c= awpData.Mobile;
        lResponse.Phone_2__c= awpData.Alternate_Mobile;
        Insert lResponse;
        return true;
    }
    
    public class AWPJSON {
        public String Salutation;
        public String FirstName;
        public String LastName;
        public String Company;
        public String Email;
        public String Personal_Email;   
        public String Alternate_Mobile;
        public String Mobile;
    }
    
    public static AWPJSON parseAWP(String json) {
        return (AWPJSON) System.JSON.deserialize(json, AWPJSON.class);
    }
    
}