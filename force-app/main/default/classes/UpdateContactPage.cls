public class UpdateContactPage {
    
    private Id contactId;
    private Contact con;
    private List<Contact> nodalContacts;
    
    public UpdateContactPage(ApexPages.StandardController sc) {
        contactId = sc.getId();
        con = [select Id, FirstName, LastName, Email, Email_2__c, AccountId from Contact where id =: contactId ];
        nodalContacts = [select Id, Email, Email_2__c from Contact where AccountId =: con.AccountId and Contact_Role__c = 'Nodal Officer'];
    }
    
    public PageReference send() {
        System.debug(con);
        List<Messaging.Email> emails = new List<Messaging.Email>();
        
        EmailTemplate emailTemplate = [Select Id, Subject, HtmlValue, DeveloperName, Description, Body
                                       from EmailTemplate where DeveloperName = 'Contact_Validation_Form'];
        
        if(String.isBlank(con.Email)) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'The contact email is blank, please check and try again'));
            return null;
        }
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.targetObjectId = con.Id;
        mail.setSaveAsActivity(false);
        mail.setToAddresses(new List<String> {con.Email});
        
        Pattern p = Pattern.compile( '([a-zA-Z0-9_\\-\\.]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))');
        
        List<String> ccAddresses = new List<String>();
        for(Contact nodalContact: nodalContacts) {
            if(nodalContact.Email != null) {
                Matcher m = p.matcher(con.Email);
                if(m.matches())
                    ccAddresses.add(nodalContact.Email);
            }
            else if(nodalContact.Email_2__c != null) {
                Matcher m = p.matcher(con.Email_2__c);
                if(m.matches())
                    ccAddresses.add(nodalContact.Email_2__c);
            }
        }
        mail.setCcAddresses(ccAddresses);
        mail.setTemplateId(emailTemplate.Id);
        
        List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address = 'customer.support@in.experian.com'];
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea[0].Id);
        }
        
        emails.add(mail);
        
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(emails, false);
        
        List<Contact> contactsToUpdate = new List<Contact>();
        for(Messaging.SendEmailResult result : results) {
            if(result.isSuccess()) {
                contactsToUpdate.add(
                    new Contact(
                        Id = contactId,
                        Update_Contact_Link_Sent__c = true,
                        Update_Contact_Link_Sent_Date__c = System.today()
                    )
                );
            }
            else if(!result.isSuccess()) {
                 contactsToUpdate.add(
                     new Contact(
                         Id = contactId,
                         Email_Error_Message__c = String.valueOf(result.getErrors())
                     )
                 );
            }
        }
        
        update contactsToUpdate;
        
        PageReference pageRef = new PageReference('/'+contactId);
        return pageRef;
    }

}