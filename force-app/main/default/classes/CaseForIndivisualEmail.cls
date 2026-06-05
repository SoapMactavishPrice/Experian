public class CaseForIndivisualEmail {

  
    public static void sendemail(Map<Id, Case> maiIdCse){ 
        
       
         List < Messaging.SingleEmailMessage > mailList = new List < Messaging.SingleEmailMessage > ();
        
          For(Case cs : [SELECT  AccountId, Account.ownerId,CaseNumber,ContactPhone,ContactMobile,ContactEmail,Dispute_Detail__c,Account_Number__c,Account_Type__c,
                                    Consumer_Name__c, Contact.Pan_no__c, Consumer_Name__r.Name, Account.Name, Contact.Birthdate, Loan_Account_Type__c, 
                                    Contact.Name, Case_Category__c, Owner.Name, Owner.Title, Owner.Phone, Owner.Email 
                                    FROM Case 
                                    WHERE Sub_Type_Status__c =: 'Notify to Bank' 
                                    And Account.Instant_Reports__c = true
                                    And Id In : maiIdCse.keyset()]) {
                                        
                system.debug('****'+cs);
                                      
           
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
                message.setSubject('Case');

                String StrBdy = '<style>table{border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #ddd}td,th{padding:10px;border:1px solid #ddd}';
                Strbdy += 'th{font-size:13px;font-weight:100;text-align:center;background-color:#00f;color:#fff}td{font-size:11px;font-weight:100;text-align:center}</style>';
                Strbdy += '<p>Dear Team,</p>';
                Strbdy += '<p>As per RBI we are mandated by a 21 days (for banks) and 30 days (for CIC) TAT which we will breach in case we do not receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed. </p>';
                Strbdy += '<table border="1px"><tr><th>Case No</th><th>Customer name</th><th>Date of Birth</th><th>Contact no</th><th>Email ID</th><th>PAN Detail</th><th>Dispute Detail</th><th>Member Name</th><th>Account Type</th><th>Account No</th></tr>';
                    
                    DateTime dt = cs.Contact.Birthdate; //BirthDate is a date field, it will be converted to datetime automatically.
                    String DOB;
                    if(!Test.isrunningTest()){
                         DOB = dt.format('MM/dd/yyyy');
                    }
                    else{
                        DOB = '2018-01-16';
                    }
                    

                Strbdy += '<tr><td>' + cs.CaseNumber + '</td><td>' + cs.Contact.Name + '</td><td>' + DOB + '</td><td>' + cs.ContactPhone + '</td><td>' + cs.ContactEmail + '</td><td>' + cs.Contact.Pan_no__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Account.Name + '</td><td>' + cs.Loan_Account_Type__c + '</td><td>' + cs.Account_Number__c + '</td></tr>';
                Strbdy += '</table>';
                Strbdy += '<br/><p>If we have not addressed this to the right team, please help us with the right contacts within your organisation for this.<br /><br />Please treat this with high priority<br /><br />Please feel free to contact us for any further queries.<br /><br />Regards,<br /></p><p><br />';
                Strbdy += '<p>'+cs.Owner.Name+'\n'+cs.Owner.Title+'\n Experian Credit Information Company of India Pvt. Ltd.\nT:' +cs.Owner.Phone+'\nE: '+cs.Owner.Email+'\n www.experian.in \n Get your Experian Credit Report & Score today, <a href="https://consumer.experian.in/ECV-OLN/#/experianHome">click here</a></p>';
               
                if(!Test.isrunningTest()){
                    message.toAddresses = new String[] {cs.ContactEmail};
                }
                else{
                     message.toAddresses = new String[] {
                       'rahul@finesseme.com'
                    };
                } 
                message.setHtmlBody(Strbdy);
                mailList.add(message);
            }
            
            Messaging.sendEmail(mailList);
           
        }  
    }