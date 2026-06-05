global class UpdateContactSC implements Schedulable, Database.Batchable<sObject> {
    
    // After 3 months -> First Monday -> Morning 9am
    // 0 0 10 1 1/4 ? *
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateContactSC());
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String contactRole = 'Authorized User Id';
        String accountMemberStatus = 'Active';
        String query = 'select Id, FirstName, LastName, Email, Email_2__c, Update_Contact_Link_Sent__c, Update_Contact_Link_Sent_Date__c, Response_Received__c,'+
            'Account.Member_Status__c, Contact_Role__c'+
            ' from Contact where Email != \'\' and Contact_Role__c =: contactRole and Account.Member_Status__c =: accountMemberStatus and Response_Received__c = false and Update_Contact_Link_Sent__c = false';
            //' and Id = \'0036D00000RtCTw\''; // FOR SANDBOX TESTING
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> contacts) {
        List<Contact> newContacts = new List<Contact>();
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        
        Set<Id> accIds = new Set<Id>();
        for(Contact con: contacts) {
            accIds.add(con.AccountId);
        }
        
        List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address = 'customer.support@in.experian.com'];
        // customer.support@in.experian.com
        
        List<Contact> nodalContacts = [select Id, Email, Email_2__c, AccountId from Contact where AccountId in: accIds and Contact_Role__c = 'Nodal Officer'];
        
        Map<Id, List<String>> mapAccIdListEmail = new Map<Id, List<String>>();
        
        
        for(Contact con : nodalContacts) {
            
            Pattern p = Pattern.compile( '([a-zA-Z0-9_\\-\\.]+)@(((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}))');
            
            if(mapAccIdListEmail.containsKey(con.AccountId)) {
                List<String> tempList = mapAccIdListEmail.get(con.AccountId);
                
                if(con.Email != null) {
                    Matcher m = p.matcher(con.Email);
                    if(m.matches())
                        tempList.add(con.Email);
                } else if(con.Email_2__c != null) {
                    Matcher m = p.matcher(con.Email_2__c);
                    if(m.matches())
                        tempList.add(con.Email_2__c);
                }
                
                mapAccIdListEmail.put(con.AccountId, tempList);
            } else {
                if(con.Email != null) {
                    Matcher m = p.matcher(con.Email);
                    if(m.matches())
                        mapAccIdListEmail.put(con.AccountId, new List<String> {con.Email});
                } else if(con.Email_2__c != null) {
                    Matcher m = p.matcher(con.Email_2__c);
                    if(m.matches())
                        mapAccIdListEmail.put(con.AccountId, new List<String> {con.Email_2__c});
                }
            }
        }
        
        for(String key : mapAccIdListEMail.keySet()) {
            System.debug(key+' : '+mapAccIdListEmail.get(key));
        }
        
        EmailTemplate emailTemplate = [Select Id, Subject, HtmlValue, DeveloperName, Description, Body
                                       from EmailTemplate where DeveloperName = 'Contact_Validation_Form'];
        
        List<Id> contactSequenceIds = new List<Id>();
        
        for(Contact con : contacts) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.targetObjectId = con.Id;
            mail.setToAddresses(new List<String> {con.Email});
            if(mapAccIdListEmail.containsKey(con.AccountId)) {
                mail.setCcAddresses(mapAccIdListEmail.get(con.AccountId));
            }
            mail.setTemplateId(emailTemplate.Id);
            mail.setUseSignature(false);
            // mail.setSaveAsActivity(false);
            if(owea.size() > 0) {
                mail.setOrgWideEmailAddressId(owea[0].Id);
            }
            contactSequenceIds.add(con.Id);
            allMails.add(mail);
            /*
            newContacts.add(new Contact(
                Id = con.Id,
                Update_Contact_Link_Sent__c = true,
                Update_Contact_Link_Sent_Date__c = System.today()
            ));
            */
        }
        
        List<Contact> contactsToUpdate = new List<Contact>();
        
        if(allMails.size() > 0) {
            Integer index = 0;
            List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails, false);
            for(Messaging.SendEmailResult result : results) {
                System.debug(result);
                if(result.isSuccess()) {
                    contactsToUpdate.add(new Contact(
                        Id = contactSequenceIds[index],
                        Update_Contact_Link_Sent__c = true,
                        Update_Contact_Link_Sent_Date__c = System.today()
                    ));
                } else {
                    contactsToUpdate.add(new Contact(
                        Id = contactSequenceIds[index],
                        Email_Error_Message__c = String.valueOf(result.getErrors())
                    ));
                }
                index += 1;
            }
        }
        if(contactsToUpdate.size() > 0) {
            List<Database.SaveResult> results = Database.update(contactsToUpdate, true);
            for(Database.SaveResult result : results) {
                System.debug(result);
            }
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
    
}