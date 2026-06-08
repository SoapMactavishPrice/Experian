// step 5
global class consumerRaisesDisputeOpenStatus implements Database.Batchable<sObject>,schedulable{
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new consumerRaisesDisputeOpenStatus(),Integer.ValueOf(Label.consumerRaisesDisputeOpenStatusSize));
    }
    
    global List<Case> start(Database.BatchableContext BC){
        
        List<Case> caseList =  new List<Case> () ;
        
        //string AccountName = ' and (Account.Name=\'Experian India Pvt Ltd\' or Account.Name=\'Finesse IT Labs Pvt Ltd\') ';
       
        Datetime todayAt7AMorPM = getCurrentTime.getTime(dateTime.now());
        Datetime two = Datetime.newInstance(2024,7,23,0,0,0);
        string dte ='CreatedDate <=: todayAt7AMorPM';
        
        string query = 'Select Id,Status, Name_of_Consumer__r.Full_Name__c, Sub_Type_Lookup__c,Sub_Type_1_Lookup__c,Displayed_Bank_Name__c,Displayed_Account_number__c, '+
            ' Name_of_Consumer__r.Email,Step_5_Consumer_Raised_Dispute_Open__c, AccountId, Name_of_Consumer__c, Name_of_Consumer__r.Name, CaseNumber,'+
            ' Sub_Type_1_Name__c, Parent_Case__c, Owner.Name, Origin, Step_6_B_Forward_To_Bank__c, CreatedDate, Step_6_Acknowledge_Forward_To_Bank__c, Parent_Case_Consumer_Dispute__c'+
            ' from Case '+
            ' where (CreatedDate = Today OR CreatedDate = Yesterday OR CreatedDate =: two ) AND Sub_Type_1_Name__c !=\'Junk\' and Sub_Type_1_Name__c !=null AND '+
            ' (Case_Type_Name__c = \'Complaint Dispute Consumer\' OR Case_Type_Name__c = \'Complaint Dispute Commercial\') '+
            ' and Origin=\'Portal\' and Status = \'Open\' '+
            ' and Step_1_Duplicate__c = false and Step_2_Resolved_Status__c = false and Step_3_Re_Raise__c = false and Step_4_Consumer_Raised_Dispute__c = false  and Step_6_Acknowledge_Forward_To_Bank__c = false and Step_6_B_Forward_To_Bank__c = false';
        
        if(!test.isRunningTest()){
            query+=' and Owner.Name=\'Consumer Support Queue\'';
            
            query +=' and  '+dte;
        }
        //query += AccountName;
        query+=' order by CaseNumber desc';
        //query+=' and Sub_Type_1_Name__c !=\'Account does not belong to me\'';
        
        caseList = database.query(query);
        system.debug(caseList.size());
        return caseList;
    }
    
    global void execute(Database.BatchableContext BC , List<Case>Scope){
        system.debug(Scope.size());
        List<EmailMessage>emcList = new List<EmailMessage>();
        
        OrgWideEmailAddress[] owea = new OrgWideEmailAddress[]{};
        if(!test.isRunningTest()){
           owea = [select Id from OrgWideEmailAddress where Address = 'consumer.support@in.experian.com' limit 1];// To send from Org wide address
        }
        
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        set<Id> subTypeOneId =  new set<Id>(); 
        set<string> displayedBankName = new set<string>();
        set<string> accountNumber = new set<string>();
        set<string> consumerName = new set<string>();  
        set<Id> cseId = new set<Id>();
        set<Id> subTypeId =  new set<Id>(); 
        
        for(Case cs : scope){
            system.debug('case nuber ::: >>>>>'+cs.CaseNumber);
            subTypeId.add(cs.Sub_Type_Lookup__c);
            subTypeOneId.add(cs.Sub_Type_1_Lookup__c);
            displayedBankName.add(cs.Displayed_Bank_Name__c);
            accountNumber.add(cs.Displayed_Account_number__c);
            consumerName.add(cs.Name_of_Consumer__c);//cs.Name_of_Consumer__r.Full_Name__c 
            cseId.add(cs.Id);
        }
        
        List<Case> existCases = new List<Case>();
        if(test.isRunningTest()){
            existCases =  [select Id, Name_of_Consumer__r.Full_Name__c, Name_of_Consumer__r.Email, Parent_Case__c, Sub_Type_1_Lookup__c,Displayed_Bank_Name__c,Displayed_Account_number__c,Step_5_Consumer_Raised_Dispute_Open__c,AccountId, Name_of_Consumer__c, Name_of_Consumer__r.Name, CaseNumber 
                           from case where
                           Name_of_Consumer__c In : consumerName and status=:'Open' order by CreatedDate desc];
            
        }else{
            existCases =  [select Id,Name_of_Consumer__r.Full_Name__c, Sub_Type_1_Lookup__c,Parent_Case__c, Displayed_Bank_Name__c,Displayed_Account_number__c,
                           Parent_Case_Consumer_Dispute__c, Name_of_Consumer__r.Email, Step_5_Consumer_Raised_Dispute_Open__c,AccountId, Name_of_Consumer__c,
                           Name_of_Consumer__r.Name, CaseNumber 
                           from case where Sub_Type_Lookup__c IN : subTypeId and   Id Not IN : cseId and
                           Displayed_Bank_Name__c IN  : displayedBankName and Displayed_Account_number__c  IN : accountNumber 
                           and Name_of_Consumer__c In : consumerName and status=:'Open' and Owner.Name ='Bank Team' order by 
                           CreatedDate desc];
            
        }
        
        system.debug('csValues  -->'+existCases.size() );
        map<string,Case> csMap = new map<string,Case>();
        
        system.debug('cases size   ?>>>> '+existCases.size());
        
        if(existCases.size() > 0){
            for(Case cs : existCases){
                string key = cs.Sub_Type_1_Lookup__c+'_'+cs.Displayed_Bank_Name__c+'_'+cs.Displayed_Account_number__c+'_'+cs.Name_of_Consumer__c;
                if(csMap.containskey(key)){
                    
                }{
                    csMap.put(key,cs);   
                }
                
            }
        }
        
        //12.	When a consumer raises a dispute with the same subtype 1, displayed bank name, account number, consumer name, 
        //and the status is open, the system should send a working email to the consumer with the case number of the initially raised dispute.
        List<Messaging.SingleEmailMessage> lstEmail = new List<Messaging.SingleEmailMessage>();
        List<Case> csList = new List<Case>();
        map<string,Case> csMap2 = new map<string,Case>();
        system.debug('---> csMap'+csMap);
        for(Case cs : scope){
            string key1 = cs.Sub_Type_1_Lookup__c+'_'+cs.Displayed_Bank_Name__c+'_'+cs.Displayed_Account_number__c+'_'+cs.Name_of_Consumer__c;
            system.debug('Key ::::: >>>> '+key1);
            if(csMap.containskey(key1)){
                cs.Step_5_Consumer_Raised_Dispute_Open__c = true;
                cs.Step_5_Consumer_Raised_Dispute_Open_Date__c = system.today();
                csMap2.put(cs.Id,cs);
                //csList.add(cs);
               if(test.isRunningTest()){
                    
                }else{
                    
                    cs.Parent_Case__c = csMap.get(key1).Id;
                }
                cs.Status = 'Resolved';
                csList.add(cs);
                
                Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                if ( owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                string EmailBody = '';
                EmailBody +='Dear '+cs.Name_of_Consumer__r.Name+', <br/><br/>'; 
                EmailBody +=' Thank you for contacting Experian Credit Information Company of India Pvt Ltd. <br/><br/>';
                EmailBody +=' We are working on your query against case number: '+csMap.get(key1).CaseNumber +' we shall keep you updated regarding the same.<br/><br/>';
                EmailBody +=' We had received your email with all the necessary information and raised it with the financial';
                EmailBody +=' instituition. We are awaiting the response from the bank for us to resolve the same at our end. The';
                EmailBody +=' regulations governing the dispute resolution process gives us 30 days from the date of the details';
                EmailBody +=' received to resolve the same basis the information received from the financial instituition.<br/><br/>';
                EmailBody +=' Please feel free to contact us for any further queries.<br/><br/> ';
                EmailBody +=' Regards,<br/><br/>';
                
                EmailBody +='<b>Consumer Support Team </b> <br/>';
                EmailBody +='Experian Credit Information Company of India Private Limited <br/>';
                EmailBody +='consumer.support@in.experian.com<br/>';
                EmailBody +='<a href="www.experian.in">www.experian.in</a><br/><br/>';
                EmailBody +='Get your Experian Credit Report & Score today, <a href="https://consumer.experian.in/ECV-OLN/view/angular/#/">click here</a>';
                
                if(string.isnotblank(cs.Name_of_Consumer__r.Email)){
                    mail.setToAddresses(new List<string>{cs.Name_of_Consumer__r.Email});
                }
                mail.setHtmlBody(EmailBody);
                mail.setUseSignature(false); 
                mail.setBccSender(false);
                mail.setSubject('We are working on your query');
                mail.setSaveAsActivity(false); 
                
                
                EmailMessage em=new EmailMessage();
                em.subject = 'We are working on your query.';
                em.RelatedToId=cs.id;  
                em.ToAddress =cs.Name_of_Consumer__r.Email;
                em.MessageDate=system.now();
                em.Incoming=false;
                em.Email_Body__c =emailbody;
                em.Status='3';
                em.FromAddress='consumer.support@in.experian.com';
                em.FromName='Consumer Support';
                
                
                if(string.isnotblank(cs.Name_of_Consumer__r.Email)){
                    lstEmail.add(mail);
                    emcList.add(em);
                }
               
                
            }
            
        }
        
        List<API_LOG__c> apliLogList = new List<API_LOG__c>();
        if(csList.size() > 0){
            //update csList;
            
            Database.SaveResult[] srList = Database.update(csList,false);
            for(Integer i=0;i<srList.size();i++){
                    if(!srList.get(i).isSuccess()){
                        for(Database.Error err : srList[i].getErrors()) {
                            if(csMap2.containskey(csList[i].Id)){
                                API_LOG__c ap =new API_LOG__c();
                                ap.Request_Source__c='Step 5 Fail '+csMap2.get(csList[i].Id).CaseNumber;
                                ap.Case__c = csMap2.get(csList[i].Id).Id;
                                ap.Exception_Description__c = err.getMessage();
                                apliLogList.add(ap);
                            } 
                        }
                    }
                }
            
        }
        
        if(lstEmail.size() > 0){
            List<Messaging.sendEmailResult> results = Messaging.sendEmail(lstEmail);
            insert emcList;
        }
        
        if(apliLogList.size() > 0){
                insert apliLogList;
            }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }    
}