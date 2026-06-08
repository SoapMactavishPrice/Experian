global class ScheduleCaseForEmail implements Database.Batchable < Sobject > {

    global Database.QueryLocator Start(Database.BatchableContext bc) {

        // For getting Record Type via Name for Account without Query
        // Id CustrecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
        // Id ConsrecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Consumer').getRecordTypeId(); 
        // and (RecordType.Name='Customer' OR RecordType.Name= 'Consumer')
        return Database.getQueryLocator([select id, Name, OwnerId,(SELECT AccountId,CaseNumber,ContactPhone,ContactMobile,ContactEmail,Dispute_Detail__c,Account_Number__c,Account_Type__c,Consumer_Name__c, Contact.Pan_no__c,
                                  Consumer_Name__r.Name, Account.Name, Contact.Birthdate, Loan_Account_Type__c, Contact.Name, Case_Category__c, Owner.Name, Owner.Title, Owner.Phone,
                                  Owner.Email from Cases where Sub_Type_Status__c=:'Notify to Bank') from Account where Instant_Reports__c = false]);
    }
    global void execute(Database.BatchableContext bc, List < Account > scope) {


        //EmailTemplate emailTemplate = [Select Id, Subject, Description, HtmlValue, DeveloperName, Body from EmailTemplate where name = 'Email Bulk VF Page'];
        List < Messaging.SingleEmailMessage > mailList = new List < Messaging.SingleEmailMessage > ();
        System.debug('Scope===>' + scope.size());
        For(Account a: scope) {
            // caseBankNew cbn = new caseBankNew();
            // cbn.createTab(a.id);
            
            List<Case> caseList = a.Cases; 

            if (caseList.size() != 0) {
                // Set<Id> cId= new Set<id>();
                // for (Case cs: cbn.caseList) {
                //     cId.add(cs.id);
                // }

                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                // String[] toAddress = new String[] {cs.ContactEmail};
                // message.setTargetObjectId(a.OwnerId);
                message.setSenderDisplayName('Experian Customer Support');
                message.setReplyTo('No-reply@Experian.com');
                message.setUseSignature(false);
                message.setBccSender(false);
                message.setSaveAsActivity(false);
                // message.setTemplateID(emailTemplate.Id);
                // message.setWhatId(cId);
                message.setSubject('List of Cases');

                String StrBdy = '<style>table{border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #ddd}td,th{padding:10px;border:1px solid #ddd}';
                Strbdy += 'th{font-size:13px;font-weight:100;text-align:center;background-color:#00f;color:#fff}td{font-size:11px;font-weight:100;text-align:center}</style>';
                Strbdy += '<p>Dear Team,</p>';
                Strbdy += '<p>As per RBI we are mandated by a 21 days (for banks) and 30 days (for CIC) TAT which we will breach in case we do not receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed. </p>';
                Strbdy += '<table border="1px"><tr><th>Case No</th><th>Customer name</th><th>Date of Birth</th><th>Contact no</th><th>Email ID</th><th>PAN Detail</th><th>Dispute Detail</th><th>Member Name</th><th>Account Type</th><th>Account No</th></tr>';
                // Strbdy += ''+<c:CaseList_Component />;

                

                for (Case cs: caseList) {
                
                
                

                    DateTime dt = cs.Contact.Birthdate; //BirthDate is a date field, it will be converted to datetime automatically.
                    String DOB;
                    
                    if(!test.isRunningTest()){
                        DOB = dt.format('MM/dd/yyyy'); 
                    }
                    else{
                        datetime dt1 =cs.Contact.Birthdate; 
                        DOB = String.valueof(dt1); 
                    }
                    

                    Strbdy += '<tr><td>' + cs.CaseNumber + '</td><td>' + cs.Contact.Name + '</td><td>' + DOB + '</td><td>' + cs.ContactPhone + '</td><td>' + cs.ContactEmail + '</td><td>' + cs.Contact.Pan_no__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Account.Name + '</td><td>' + cs.Loan_Account_Type__c + '</td><td>' + cs.Account_Number__c + '</td></tr>';
                }
                Strbdy += '</table>';
                Strbdy += '<br/><p>If we have not addressed this to the right team, please help us with the right contacts within your organisation for this.<br /><br />Please treat this with high priority<br /><br />Please feel free to contact us for any further queries.<br /><br />Regards,<br /></p><p><br />';
                Strbdy += '<p>'+caseList[0].Owner.Name+'\n'+caseList[0].Owner.Title+'\n Experian Credit Information Company of India Pvt. Ltd.\nT:' +caseList[0].Owner.Phone+'\nE: '+caseList[0].Owner.Email+'\n www.experian.in \n Get your Experian Credit Report & Score today, <a href="https://consumer.experian.in/ECV-OLN/#/experianHome">click here</a></p>';
                
                
                //Contact manager = [Select Id, Title, email from Contact where AccountId =: a.Id limit 1];
                Contact manager = [Select Id, Title, email from Contact where AccountId =: a.id and Title = 'Manager' limit 1];
                
                //message.toAddresses = new String[] {
                 //    'rahul@finesseme.com'
                //};

                message.toAddresses = new String[] {manager.email};
                message.setHtmlBody(Strbdy);
                mailList.add(message);
            } 
        }

        Messaging.sendEmail(mailList);

    }

    global void finish(Database.BatchableContext BC) {

    }

}