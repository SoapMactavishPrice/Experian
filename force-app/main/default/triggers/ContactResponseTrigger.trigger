// TEST CLASS - UpdateContactSitePageTest

trigger ContactResponseTrigger on Contact_Response__c (after insert) {
    
    if(Trigger.isAfter && Trigger.isInsert) {
        
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        
        Set<Id> contactIds = new Set<Id>();
        for(Contact_Response__c conRes : Trigger.New) {
            contactIds.add(conRes.Contact__c);
        }
        List<Contact> oldContacts = [select Id, Salutation, FirstName, LastName, Email, Email_2__c, Phone, Phone_2__c, Account.Name, Contact_Update_Form_Link__c
                                     from Contact where Id in: contactIds];
        Map<Id, Contact> mapOldContacts = new Map<Id, Contact>();
        mapOldContacts.putAll(oldContacts);
        
        Set<Id> accIds = new Set<Id>();
        for(Contact con : oldContacts) {
             accIds.add(con.AccountId);
        }
        List<Contact> nodalContacts = [select Id, Email, Email_2__c, AccountId from Contact where AccountId in: accIds and Contact_Role__c = 'Nodal Officer'];
        
        Map<Id, List<String>> mapAccIdListEmail = new Map<Id, List<String>>();
        for(Contact con : nodalContacts) {
            if(mapAccIdListEmail.containsKey(con.AccountId)) {
                List<String> tempList = mapAccIdListEmail.get(con.AccountId);
                
                if(con.Email != null)
                    tempList.add(con.Email);
                else if(con.Email_2__c != null)
                    tempList.add(con.Email_2__c);
                
                mapAccIdListEmail.put(con.AccountId, tempList);
            } else {
                if(con.Email != null)
                mapAccIdListEmail.put(con.AccountId, new List<String> {con.Email});
                else if(con.Email_2__c != null)
                    mapAccIdListEmail.put(con.AccountId, new List<String> {con.Email_2__c});
            }
        }
        for(Contact_Response__c conResGlobal: Trigger.New) {
            Contact_Response__c conRes = conResGlobal.clone(true);
            conRes.Salutation__c = String.isBlank(conRes.Salutation__c) ? '' : conRes.Salutation__c;
            conRes.First_Name__c = String.isBlank(conRes.First_Name__c) ? '' : conRes.First_Name__c;
            conRes.Last_Name__c = String.isBlank(conRes.Last_Name__c) ? '' : conRes.Last_Name__c;
            conRes.Email__c = String.isBlank(conRes.Email__c) ? '' : conRes.Email__c;
            conRes.Email_2__c = String.isBlank(conRes.Email_2__c) ? '' : conRes.Email_2__c;
            conRes.Phone__c = String.isBlank(conRes.Phone__c) ? '' : conRes.Phone__c;
            conRes.Phone_2__c = String.isBlank(conRes.Phone_2__c) ? '' : conRes.Phone_2__c;
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new List<String> {conRes.Email__c});
            if(mapAccIdListEmail.containsKey(mapOldContacts.get(conRes.Contact__c).AccountId)) {
                mail.setCcAddresses(mapAccIdListEmail.get(mapOldContacts.get(conRes.Contact__c).AccountId));
            }
            mail.setUseSignature(false);
            mail.setSubject('Contact Information Received and being processed');
            
            Contact con = mapOldContacts.get(conResGlobal.Contact__c);
            con.Salutation = String.isBlank(con.Salutation) ? '' : con.Salutation;
            con.FirstName = String.isBlank(con.FirstName) ? '' : con.FirstName;
            con.LastName = String.isBlank(con.LastName) ? '' : con.LastName;
            con.Email = String.isBlank(con.Email) ? '' : con.Email;
            con.Email_2__c = String.isBlank(con.Email_2__c) ? '' : con.Email_2__c;
            con.Phone = String.isBlank(con.Phone) ? '' : con.Phone;
            con.Phone_2__c = String.isBlank(con.Phone_2__c) ? '' : con.Phone_2__c;
            
            String htmlBody = '<head><style>table {width: 100%;} table, th, td {border: 0.5px solid black;border-collapse: collapse;word-wrap: break-word; margin: 0px; padding: 0px 2px;}</style></head>'+
                '<span>Thank you for your association with Experian.</br>We have received and updated the details as submitted by you in our records.</span>'+
                '<span>Please note the following</span></br></br>'+
                '<p>Company Name : '+con.Account.Name+'</p>'+
                
                '<p><b>Authorised Id requestor – Previous</b></p>'+
                '<table>'+
                '<tr>'+
                '<td style="width: 10%"><b>Name</b></td>'+
                '<td><b>Salutation : </b>'+con.Salutation+'</td>'+
                '<td><b>First Name : </b>'+con.FirstName+'</td>'+
                '<td><b>Last Name : </b>'+con.LastName+'</td>'+
                '</tr>'+
                '<tr>'+
                '<td><b>Email</b></td>'+
                '<td><b>Email id 1 : </b>'+con.Email+'</td>'+
                '<td><b>Email id 2 : </b>'+con.Email_2__c+'</td>'+
                '<td></td>'+
                '</tr>'+
                '<tr>'+
                '<td><b>Telephone Number</td>'+
                '<td><b>Phone 1 : </b>'+con.Phone+'</td>'+
                '<td><b>Phone 2 : </b>'+con.Phone_2__c+'</td>'+
                '<td></td>'+
                '</tr>'+
                '</table>'+
                '</br>'+
                
                '<p><b>Authorised Id requestor – Updated</b></p>'+
                '<table>'+
                '<tr>'+
                '<td style="width: 10%"><b>Name</b></td>'+
                '<td><b>Salutation : </b>'+conRes.Salutation__c+'</td>'+
                '<td><b>First Name : </b>'+conRes.First_Name__c+'</td>'+
                '<td><b>Last Name : </b>'+conRes.Last_Name__c+'</td>'+
                '</tr>'+
                '<tr>'+
                '<td><b>Email</b></td>'+
                '<td><b>Email id 1 : </b>'+conRes.Email__c+'</td>'+
                '<td><b>Email id 2 : </b>'+conRes.Email_2__c+'</td>'+
                '<td></td>'+
                '</tr>'+
                '<tr>'+
                '<td><b>Telephone Number</b></td>'+
                '<td><b>Phone 1 : </b>'+conRes.Phone__c+'</td>'+
                '<td><b>Phone 2 : </b>'+conRes.Phone_2__c+'</td>'+
                '<td></td>'+
                '</tr>'+
                '</table>'+
                '</br>'+
                
                '<p>If you notice any discrepancies, please <a href="'+con.Contact_Update_Form_Link__c+'">click here</a> and update your changes.<p></br>'+
                '<span>Regards,</br>'+
                '<span style="color: navy; font-weight: bold">Customer Support</span></br>'+
                'Experian Credit Information Company of India Pvt. Ltd.</br>'+
                '<a href="www.experian.in">www.experian.in</a></br>'+
                '<span style="color: navy; font-weight: bold">India STS Link</span> –'+
                ' <a href="https://data.experian.in">https://data.experian.in</a></br>'+
                '<span style="color: navy; font-weight: bold">Nextgen Link</span> –'+
                ' <a href="https://nxg-india.experian.com/nextgen-ind-pds/">https://nxg-india.experian.com/nextgen-ind-pds/</a></span>';
            mail.setHtmlBody(htmlBody);
            
            List<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where Address = 'customer.support@in.experian.com'];
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea[0].Id);
            }
            allMails.add(mail);
        }
        
        Messaging.SendEmail(allMails, false);
        
        List<Contact> contacts = new List<Contact>();
        for(Contact_Response__c cr : Trigger.New) {
            Contact con = new Contact();
            con.Id = cr.Contact__c;
            
            con.Salutation = cr.Salutation__c;
            con.FirstName = cr.First_Name__c;
            con.LastName = cr.Last_Name__c;
            
            con.Email = cr.Email__c;
            con.Email_2__c = cr.Email_2__c;
            
            con.Phone = cr.Phone__c;
            con.Phone_2__c = cr.Phone_2__c;
            
            con.Response_Received__c = true;
            con.Response_Received_Date__c = System.today();
            contacts.add(con);
        }
        if(contacts.size() > 0) {
            update contacts;
        }
    }
}