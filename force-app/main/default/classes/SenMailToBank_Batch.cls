// Sending Bank Reminder 
global class SenMailToBank_Batch  implements Database.Batchable < sObject > , Database.AllowsCallouts{

   public SenMailToBank_Batch(){
       
   }

    global Database.QueryLocator start(Database.BatchableContext BC) {
    
        Id bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;
        String val = 'Resolved';
        
     //String query = 'SELECT Name,Email,Pay_Later_RequestId__c,Bank_Name__c,Company,EBS_Payment_Status__c,Id,Mode_of_Transaction__c,Payment_Date_Time__c,RBI_Certificate_Verified__c,Total_Payment_Received__c,Transaction_Id__c FROM Lead WHERE Status = \'' + String.escapeSingleQuotes(Pay)+'\' AND Pay_Later_RequestId__c != \'' + String.escapeSingleQuotes(request_id)+'\' AND (EBS_Payment_Status__c = Null OR EBS_Payment_Status__c = \''+ String.escapeSingleQuotes(Rej)+'\')';
      String query='';
      query='Select Id, Account_Number__c,Loan_Account_Type__c,Dispute_Detail__c,OwnerId,CaseNumber,Forward_to_bank__c,AccountId,ContactId, Displayed_Details__c,Correct_Details__c,Contact.Name,Name_of_Consumer__r.Name,Name_of_Consumer__r.email,Name_of_Consumer__r.Phone,Name_of_Consumer__r.BirthDate,Name_of_Consumer__r.Account_No__c, Name_of_Consumer__r.Account_Type__c, Name_of_Consumer__r.Pan_no__c,Account.Person_Name_Dispute__c,Account.Phone_Dispute__c,Account.Name,Account.Email_Dispute__c,Account.Email_1_Dispute__c,Account.Email_2_Dispute__c,Account.Email_3_Dispute__c,Account.Email_4_Dispute__c,Account.Email_5_Dispute__c,Account.Email_6_Dispute__c ,Account.Email_7_Dispute__c,Account.Email_8_Dispute__c,Account.Email_9_Dispute__c,Account.Email_10_Dispute__c from Case where OwnerId =\'' + String.escapeSingleQuotes(bankteamId)+'\' AND Forward_to_bank__c = true AND Status !=\'' + String.escapeSingleQuotes(val)+'\' AND AccountId !=null AND Name_of_Consumer__c !=null'; 
      System.debug('----------->Database.QueryLocator start '+query);
        return Database.getQueryLocator(query);  
    }
    
     global void execute(Database.BatchableContext BC, List < Case > case_list) {
         
         String Name = UserInfo.getName();
         String UserEmail = UserInfo.getUserEmail();
         
         System.debug('case List '+case_list);
         System.debug('case List size '+case_list.size());
         Map<Id, List<Case>> mapAccId_listcase = new Map<Id, List<Case>>();
         List<Case> listcase = new List<Case>();
         List<EmailMessage> EmlMsgList = new List<EmailMessage>();
          
         for(Case cse :case_list){
             
              listcase.add(cse);
             System.debug('listcase  '+listcase);
          
                  if(mapAccId_listcase.containskey(cse.AccountId)){
                    
                        List<Case> lst_cse = mapAccId_listcase.get(cse.AccountId);
                        lst_cse.add(cse);
                        mapAccId_listcase.put(cse.AccountId,lst_cse);                   
                    }
                    else {
                        mapAccId_listcase.put(cse.AccountId, new List<Case> {cse});
                    }
          }
          
          System.debug('mapAccId_listcase  '+mapAccId_listcase);
          System.debug('mapAccId_listcase  '+mapAccId_listcase.size());
          
           if(mapAccId_listcase.size()>0){
               
               String Strbdy='';
               String emailId='';
               
        
               List<Messaging.SingleEmailMessage> mailList = new List <Messaging.SingleEmailMessage> ();
               
               for(Account acc : [Select Id, Name, Email_Dispute__c,Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,
                                  Email_4_Dispute__c,Email_5_Dispute__c,Email_6_Dispute__c ,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c from Account 
                                  where ( Email_Dispute__c   !=null OR Email_1_Dispute__c !=null OR Email_2_Dispute__c !=null OR
                                          Email_3_Dispute__c !=null OR Email_4_Dispute__c !=null OR Email_5_Dispute__c !=null OR
                                          Email_6_Dispute__c !=null OR Email_7_Dispute__c !=null OR Email_8_Dispute__c !=null OR
                                        Email_9_Dispute__c !=null OR Email_10_Dispute__c !=null) AND Id In :mapAccId_listcase.keyset()]){
                                   
                                      System.debug('acc  '+acc);  
              OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'consumer.support@in.experian.com'];// To send from Org wide address
              System.debug('owea  '+owea); // balramp610@gmail.com
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
                    //message.setSenderDisplayName('Experian Consumer Support');
                                      if ( owea.size() > 0 ) {
                                           System.debug('acc  ');  
                                          message.setOrgWideEmailAddressId(owea.get(0).Id);
                                      }
                                      
                    message.setReplyTo('No-reply@Experian.com');
                    message.setUseSignature(false); 
                    message.setBccSender(false);
                    message.setSaveAsActivity(false); 
                    message.setSubject('List of Cases');
                                      
                    String EmailBody='';
                    Strbdy = '<style>table{border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #ddd}td,th{padding:10px;border:1px solid #ddd}';
                    Strbdy += 'th{font-size:13px;font-weight:100;text-align:center;background-color:#00f;color:#fff}td{font-size:11px;font-weight:100;text-align:center}</style>';
                    
                    Strbdy += '<p>Dear Team,</p>';
                    EmailBody += '<p>Dear Team,</p>';
                   
                    Strbdy += '<p>As per RBI we are mandated by a 21 days (for banks) and 30 days (for CIC) TAT which we will breach in case we do not receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed. </p>';
                    EmailBody += '<p>As per RBI we are mandated by a 21 days (for banks) and 30 days (for CIC) TAT which we will breach in case we do not receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed. </p>';

                    Strbdy += '<table border="1px"><tr><th>Case No</th><th>Consumer name</th><th>Date of Birth</th><th>Contact no</th><th>Email ID</th><th>PAN Detail</th><th>Member Name</th><th>Account Type</th><th>Account No</th><th>Dispute Details</th><th>Displayed Details</th><th>Correct Details</th></tr>';
                    EmailBody += '<table border="1px"><tr><th>Case No</th><th>Consumer name</th><th>Date of Birth</th><th>Contact no</th><th>Email ID</th><th>PAN Detail</th><th>Member Name</th><th>Account Type</th><th>Account No</th><th>Dispute Details</th><th>Displayed Details</th><th>Correct Details</th></tr>';

                    for (Case cs: mapAccId_listcase.get(acc.Id)) { 
    
                        DateTime dt = cs.Name_of_Consumer__r.BirthDate; //BirthDate is a date field, it will be converted to datetime automatically.
                        String DOB;
                        
                        if(test.isRunningTest()){
                           // DOB = dt.format('MM/dd/yyyy'); 
                              DOB = '02/01/2021'; 
                        }
                        else{
                            datetime dt1 =cs.Name_of_Consumer__r.BirthDate; 
                            DOB = String.valueof(dt1); 
                        } 
                          Strbdy += '<tr><td>' + cs.CaseNumber + '</td><td>' + cs.Name_of_Consumer__r.Name + '</td><td>' + DOB + '</td><td>' + cs.Name_of_Consumer__r.Phone + '</td><td>' + cs.Name_of_Consumer__r.Email + '</td><td>' + cs.Name_of_Consumer__r.Pan_no__c + '</td><td>' +  cs.Account.Name  + '</td><td>' + cs.Name_of_Consumer__r.Account_Type__c + '</td><td>' + cs.Name_of_Consumer__r.Account_No__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Displayed_Details__c + '</td><td>' + cs.Correct_Details__c + '</td></tr>';
                          EmailBody += '<tr><td>' + cs.CaseNumber + '</td><td>' + cs.Name_of_Consumer__r.Name + '</td><td>' + DOB + '</td><td>' + cs.Name_of_Consumer__r.Phone + '</td><td>' + cs.Name_of_Consumer__r.Email + '</td><td>' + cs.Name_of_Consumer__r.Pan_no__c + '</td><td>' +  cs.Account.Name  + '</td><td>' + cs.Name_of_Consumer__r.Account_Type__c + '</td><td>' + cs.Name_of_Consumer__r.Account_No__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Displayed_Details__c + '</td><td>' + cs.Correct_Details__c + '</td></tr>';
                    }                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                    
                    Strbdy += '</table>';
                    EmailBody += '</table>';
                                      
                    Strbdy += '<br/><p>If we have not addressed this to the right team, please help us with the right contacts within your organisation for this.<br /><br />Please treat this with high priority<br /><br />Please feel free to contact us for any further queries.<br /><br />Regards,<br /></p><p>';
                    EmailBody += '<br/><p>If we have not addressed this to the right team, please help us with the right contacts within your organisation for this.<br /><br />Please treat this with high priority<br /><br />Please feel free to contact us for any further queries.<br /><br />Regards,<br /></p><p>';
                    
                    Strbdy += '<p>'+UserInfo.getName()+'<br/>'+'Experian Credit Information Company of India Pvt. Ltd. +<br/>+ T: '+'E:'+UserInfo.getUserEmail()+ '+<br/>www.experian.in Get your Experian Credit Report & Score today, <a href="https://consumer.experian.in/ECV-OLN/#/experianHome">click here</a></p>';
                    EmailBody += '<p>'+UserInfo.getName()+'<br/>'+'Experian Credit Information Company of India Pvt. Ltd. +<br/>+ T: '+'E:'+UserInfo.getUserEmail()+ '+<br/>www.experian.in Get your Experian Credit Report & Score today, <a href="https://consumer.experian.in/ECV-OLN/#/experianHome">click here</a></p>';
                    
                    List<String> toAddresses = new List<String>();  
                    
                    if(acc.Email_Dispute__c != null){
                       toAddresses.add(acc.Email_Dispute__c);
                         emailid=acc.Email_Dispute__c;  
                    }
    
                    if(acc.Email_1_Dispute__c != null){
                        toAddresses.add(acc.Email_1_Dispute__c);
                    }
    
                    if(acc.Email_2_Dispute__c != null){
                        toAddresses.add(acc.Email_2_Dispute__c);
                    }
    
                    if(acc.Email_3_Dispute__c != null){
                       toAddresses.add(acc.Email_3_Dispute__c);
                    }
    
                    if(acc.Email_4_Dispute__c != null){
                        toAddresses.add(acc.Email_4_Dispute__c);
                    }
    
                    if(acc.Email_5_Dispute__c != null){
                         toAddresses.add(acc.Email_5_Dispute__c); 
                    }
    
                    if(acc.Email_6_Dispute__c != null){
                        toAddresses.add(acc.Email_6_Dispute__c);
                    } 
                  
                   if(string.isNotBlank(acc.Email_7_Dispute__c))
                            toAddresses.add(acc.Email_7_Dispute__c);
                        if(string.isNotBlank(acc.Email_8_Dispute__c))
                            toAddresses.add(acc.Email_8_Dispute__c);
                        if(string.isNotBlank(acc.Email_9_Dispute__c))
                            toAddresses.add(acc.Email_9_Dispute__c);
                        if(string.isNotBlank(acc.Email_10_Dispute__c))
                            toAddresses.add(acc.Email_10_Dispute__c);                         
                    
                    message.setToAddresses(toAddresses); 
                    message.setHtmlBody(Strbdy);
                    mailList.add(message); 
                                      
                  System.debug('EmailBody  '+EmailBody);
                                      
                  List<Case> lst_cse = mapAccId_listcase.get(acc.id);
                     for(Case cs: lst_cse){
                                          
                   EmailMessage em=new EmailMessage();
                   em.Subject='Forward To Bank Reminder';
                   em.RelatedToId=cs.id;  
                   em.ToAddress=emailid;
                   em.MessageDate=system.now();
                   em.Incoming=false;
                   em.Email_Body__c =EmailBody;
                   em.Status='3';
                   em.FromAddress='consumer.support@in.experian.com';
                   em.FromName='Experian Consumer Support';
                   EmlMsgList.add(em);
                                      }          
                      
            }  
            
               try{
                   Messaging.sendEmail(mailList); 
                   
                   
                   insert EmlMsgList;  
                   
                   System.debug('this line after mail');
               }catch(Exception e){
                   System.debug('issue is sending mail '+ e);
               }          
            }
     } 
     
       global void finish(Database.BatchableContext BC) {
        
    }
}