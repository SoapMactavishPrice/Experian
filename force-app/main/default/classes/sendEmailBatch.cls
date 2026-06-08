global class sendEmailBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(DataBase.BatchableContext bc) {
       /* Set<String> Ids = new Set<String>();
       Ids.add('0016D00000fRgVC');
        Ids.add('0016D00000d8fRt');
        Ids.add('0016D00000NVm7k');
        Ids.add('0016D00000bwe78');
        Ids.add('0016D00000UItyV');
        
        Ids.add('0016D00000afLVF');
        Ids.add('0016D00000aliss');
        
        Ids.add('0016D00000afp1P');
        Ids.add('0016D00000G60VS');
        */
        
        
        Boolean btrue = true;
        string query = 'select Id,Name,Person_Name_Dispute__c, Person_Name_2__c,Person_Name_3__c,Person_Name_4__c,Person_Name_5__c,Person_Name_6__c,Person_Name_7__c,Person_Name_8__c,Person_Name_9__c,Person_Name_10__c'+
            ',Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,Email_4_Dispute__c,Email_5_Dispute__c,Email_6_Dispute__c,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c,'+
            'Phone_1__c,Phone_2__c,Phone_3__c,Phone_4__c,Phone_5__c,Phone_6__c,Phone_7__c,Phone_8__c,Phone_9__c,Phone_10__c,'+
            '(select Id,Name,email,Contact_Role__c,Phone from Contacts) from Account where'+
            ' Auth_or_Nodal_or_Auth_User_or_Dispute__c =: btrue and Contact_Information_Email_Sent__c = false limit 1000';
        return database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc,List<Account> scope) {
        
        system.debug('scope'+scope);
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        
        date dt1 = system.today();
        string month = '';
        switch on dt1.month() {
            when 1 {
                month = 'Jan';
            }
            when 2 {
                month = 'Feb';
            }
            when 3 {
                month = 'Mar';
            }
            when 4 {
                month = 'Apr';
            }
            when 5 {
                month = 'May';
            }
            when 6 {
                month = 'Jun';
            }
            when 7 {
                month = 'Jul';
            }
            when 8 {
                month = 'Aug';
            }
            when 9 {
                month = 'Sept';
            }
            when 10 {
                month = 'Oct';
            }
            when 11 {
                month = 'Nov';
            }
            when 12 {
                month = 'Dec';
            }
        }
        
        string todayDate = string.valueOf(dt1.Day()) +'/'+ month +'/'+string.valueOf(dt1.Year());
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'customer.support@in.experian.com'];// To send from Org wide address    
        
        system.debug('scope'+scope);
        List<Account> accList = new List<Account>();
        for(Account acc : scope) {
            
            List<string> emailList = new List<string>();
            List<string> ccemailList = new List<string>();
            
            string auth;
            string Nodalb;
            string authUser;
            string dispatchb = '';
            string AuthEmailId;
            
            for(Contact con : acc.Contacts) {
                if(string.valueOf(con.Contact_Role__c) == 'Authorized Signatory') {
                    
                    if(string.isNotBlank(con.Name) || string.isNotBlank(con.Phone) || string.isNotBlank(con.email)) {
                        if(String.isBlank(auth))
                            auth = '<table border="1" style="border-collapse: collapse;width:80%"><tr style="background-color:#DCDCDC;"><th>Name</th> <th>Email</th> <th>Phone</th> </tr>'; 
                        auth += '<tr><td style="text-align:center">'+checkNull(con.Name)+'</td><td style="text-align:center">'+checkNull(con.email)+'</td><td style="text-align:center">'+checkNull(con.Phone)+'</td></tr>';
                    }
                    if(string.isNotBlank(con.Email)) emailList.add(con.email);
                }
                
                if(string.valueOf( con.Contact_Role__c) == 'Nodal Officer') {
                    
                    if(string.isNotBlank(con.email))
                        emailList.add(con.email);
                    
                    if(string.isNotBlank(con.Name) || string.isNotBlank(con.Phone) || string.isNotBlank(con.email)) {
                        if(String.isBlank(Nodalb))
                            Nodalb = '<table border="1" style="border-collapse: collapse;width:80%"><tr style="background-color:#DCDCDC;"><th>Name</th> <th>Email</th> <th>Phone</th> </tr>'; 
                        Nodalb += '<tr><td style="text-align:center">'+checkNull(con.Name)+'</td><td style="text-align:center">'+checkNull(con.email)+'</td><td style="text-align:center">'+checkNull(con.Phone)+'</td></tr>';
                    }
                    
                }
                
                if(string.valueOf(con.Contact_Role__c) == 'Authorized User Id') {
                    if(string.isNotBlank(con.Name) || string.isNotBlank(con.Phone) || string.isNotBlank(con.email)){
                        if(String.isBlank(authUser))
                            authUser = '<table border="1" style="border-collapse: collapse;width:80%"><tr style="background-color:#DCDCDC;"><th>Name</th> <th>Email</th> <th>Phone</th> </tr>'; 
                        authUser += '<tr><td style="text-align:center">'+checkNull(con.Name)+'</td><td style="text-align:center">'+checkNull(con.email)+'</td><td style="text-align:center">'+checkNull(con.Phone)+'</td></tr>';
                    }   
                    if(string.isNotBlank(con.email))
                        AuthEmailId = con.email;
                    
                }
            }
            
            if(string.isBlank(authUser)) {
                authUser = auth;
            }
            
            if(String.isNotBlank(auth))
                auth += '</table>';
            if(String.isNotBlank(Nodalb))
                Nodalb += '</table>';
            if(String.isNotBlank(authUser))
                authUser += '</table>';
            
            
            
            if(string.isNotBlank(acc.Email_1_Dispute__c)) ccemailList.add(acc.Email_1_Dispute__c);
            if(string.isNotBlank(acc.Person_Name_Dispute__c) || string.isNotBlank(acc.Email_1_Dispute__c)  || string.isNotBlank(acc.Phone_1__c )){
                dispatchb += '<tr><td style="text-align:center">'+checkNull(acc.Person_Name_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_1_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_1__c)+'</td></tr>';
            } 
            if(string.isNotBlank(acc.Email_2_Dispute__c)) ccemailList.add(acc.Email_2_Dispute__c);
            if(string.isNotBlank(acc.Person_Name_2__c) || string.isNotBlank(acc.Email_2_Dispute__c)  || string.isNotBlank(acc.Phone_2__c )){
                dispatchb += '<tr><td style="text-align:center">'+checkNull(acc.Person_Name_2__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_2_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_2__c)+'</td></tr>';
            }
            if(string.isNotBlank(acc.Email_3_Dispute__c)) ccemailList.add(acc.Email_3_Dispute__c);  
            if(string.isNotBlank(acc.Person_Name_3__c) || string.isNotBlank(acc.Email_3_Dispute__c)  || string.isNotBlank(acc.Email_3_Dispute__c )){
                dispatchb += '<tr><td style="text-align:center">'+checkNull(acc.Person_Name_3__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_3_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_3__c)+'</td></tr>';
            }
            if(string.isNotBlank(acc.Email_4_Dispute__c)) ccemailList.add(acc.Email_4_Dispute__c);
            if(string.isNotBlank(acc.Person_Name_4__c) || string.isNotBlank(acc.Phone_4__c)  || string.isNotBlank(acc.Email_4_Dispute__c )){
                dispatchb += '<tr><td style="text-align:center">'+checkNull(acc.Person_Name_4__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_4_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_4__c)+'</td></tr>';
            }
            
            if(string.isNotBlank(acc.Email_5_Dispute__c)) ccemailList.add(acc.Email_5_Dispute__c);
            if(string.isNotBlank(acc.Person_Name_5__c) || string.isNotBlank(acc.Phone_5__c)  || string.isNotBlank(acc.Email_5_Dispute__c )){
                dispatchb += '<tr><td style="text-align:center">'+checkNull(acc.Person_Name_5__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_5_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_5__c)+'</td></tr>';
            }
            if(string.isNotBlank(acc.Email_6_Dispute__c)) ccemailList.add(acc.Email_6_Dispute__c);
            if(string.isNotBlank(acc.Person_Name_6__c) || string.isNotBlank(acc.Phone_6__c)  || string.isNotBlank(acc.Email_6_Dispute__c )){
                dispatchb += '<tr><td style="text-align:center">'+checkNull(acc.Person_Name_6__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_6_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_6__c)+'</td></tr>';
            }
            
            if(string.isNotBlank(acc.Email_7_Dispute__c)) ccemailList.add(acc.Email_7_Dispute__c);
            if(string.isNotBlank(acc.Person_Name_7__c) || string.isNotBlank(acc.Phone_7__c)  || string.isNotBlank(acc.Email_7_Dispute__c )){
                dispatchb += '<tr><td style="text-align:center">'+checkNull(acc.Person_Name_7__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_7_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_7__c)+'</td></tr>';
            }
            
            if(string.isNotBlank(acc.Email_8_Dispute__c)) ccemailList.add(acc.Email_8_Dispute__c);
            if(string.isNotBlank(acc.Person_Name_8__c) || string.isNotBlank(acc.Phone_8__c)  || string.isNotBlank(acc.Email_8_Dispute__c )){
                dispatchb += '<tr><td style="text-align:center">'+checkNull(acc.Person_Name_8__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_8_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_8__c)+'</td></tr>';
            }
            
            if(string.isNotBlank(acc.Email_9_Dispute__c)) ccemailList.add(acc.Email_9_Dispute__c);
            if(string.isNotBlank(acc.Person_Name_9__c) || string.isNotBlank(acc.Phone_9__c)  || string.isNotBlank(acc.Email_9_Dispute__c )){
                dispatchb += '<tr><td style="text-align:center">'+checkNull(acc.Person_Name_9__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_9_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_9__c)+'</td></tr>';
            }
            
            if(string.isNotBlank(acc.Email_10_Dispute__c)) ccemailList.add(acc.Email_10_Dispute__c);
            if(string.isNotBlank(acc.Person_Name_10__c) || string.isNotBlank(acc.Phone_10__c)  || string.isNotBlank(acc.Email_10_Dispute__c )){
                dispatchb += '<tr><td style="text-align:center">'+checkNull(acc.Person_Name_10__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_10_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_10__c)+'</td></tr>';
            }
            
            
            
            if(String.isNotBlank(dispatchb)) {
                dispatchb = '<table border="1" style="border-collapse: collapse;width:80%"><tr style="background-color:#DCDCDC;"> <th>Name</th> <th>Email</th> <th>Phone</th> </tr> ' + dispatchb;
                dispatchb += '</table>';
            }
            
            if(string.isNotBlank(AuthEmailId)) ccemailList.add(AuthEmailId);
            
            string finalBody = '';
            
            finalBody = 'Thank you for your patronage and Membership with us at Experian.<br/><br/>'+
                'We want to update the relevant contact information periodically. The details available with us as on '+todayDate +' '+
                ' are';
            if(String.isNotBlank(auth)) {
            finalBody += '<p><b>Authorised Signatory</b></p>'+
                ' ' +auth+ ' ';
            }
            if(String.isNotBlank(Nodalb)) {
                finalBody += '<p> <b>Nodal Officer</b></p>' +
                ' '+Nodalb+' ';
            }
            system.debug('dispatchb'+dispatchb);
            if(String.isNotBlank(dispatchb)) {
                finalBody += '<p> <b>Dispute Manager</b></p>'+
                ' '+dispatchb+' ';
            }
            if(String.isNotBlank(authUser))  {
                finalBody += '<p><b>Authorised User id requestor</b></p>'+
                '' +authUser+'<br />';
            }
            finalBody += '<p>In case there is a change in the Authorised Signatory / Nodal Officer / Authorised user id requestor '+
                'we would require the following</p>'+
                '<p>(a) A document on the letter head stating that the company authorizes XYZ as Authorised Signatory/ '+
                'Nodal Officer / Authorised user id requestor of the organization who can send / approve the request of '+
                'the user ID and also is reachable in case of any escalations. This needs to be signed by Company '+  
                'Secretary / MD / Authorized Signatory. </p>'+  
                '<p>(b) Self attested PAN card copy / Passport copy / Driving license accepted as Original Verified Document '+  
                'by RBI. This document is required of the person who is being appointed as Authorised Signatory/ Nodal '+  
                'Officer / Authorised user id requestor. </p>'+  
                '<p>(c) Employee Identity proof : This document is required of the person who is being appointed as a Authorised Signatory/ Nodal Officer / Authorised user id requestor</p>'+   
                
                'Please send in the documents to Customer.Support@in.experian.com. '+
                'We will revert with clarifications, if any before updation of the same in the database. <br /> <br />'+
                
                'Regards,<br/>'+  
                'Customer Support <br />'+
                'Experian Credit Information Company of India Private Limited <br />'+
                'www.experian.in <br />'+
                'India STS link - https://data.experian.in <br />'+
                'Nextgen link- https://nxg-india.experian.com/nextgen-ind-pds/';
            
            if(emailList.size()  == 0){
                if(ccemailList.size() > 0){
                    string sisoute1Email = ccemailList[0];
                    emailList.add(sisoute1Email);
                }
            }
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.subject = 'Contact Information Update : '+acc.Name;
            mail.setUseSignature(false);
            if ( owea.size() > 0 ) {
                System.debug('inside');  
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            } 
            mail.setToAddresses(emailList);
            mail.setCcAddresses(ccemailList);
            mail.setSaveAsActivity(true); 
            //mail.setTargetObjectId(param1);
            mail.htmlbody = finalBody;
            allMails.add(mail);
        }
        
        List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
        system.debug('results'+results);
        List<Account> accLists = new List<Account>();
        for(Account acc : scope ){
            acc.Contact_Information_Email_Sent__c = true;
            acc.Contact_Information_Email_Sent_Date__c = Date.today();
            accLists.add(acc);
        }
        
        if(accLists.size()> 0)
            update accLists;
       
    }
    
    global void finish(DataBase.BatchableContext bc) {
        
    }
    
    private static String checkNull(Object str) {
        if(String.isNotBlank(String.valueOf(str)))
            return String.valueOf(str);
        else
            return ' ';
    }
    
}