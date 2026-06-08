global class consumerRaisedDispute_Batch implements Database.Batchable<sObject>,schedulable,Database.AllowsCallouts ,Database.Stateful{
    //add by rishikesh
    Set<Id> csReceivedIds=new Set<Id>();
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new consumerRaisedDispute_Batch(),Integer.ValueOf(Label.consumerRaisedDispute_Size));
    }
    
    
    global List<Case> start(Database.BatchableContext BC){
        
        //string AccountName = ' and (Account.Name=\'Experian India Pvt Ltd\' or Account.Name=\'Finesse IT Labs Pvt Ltd\') ';
        Datetime todayAt7AMorPM = getCurrentTime.getTime(dateTime.now());
        string dte ='CreatedDate <=: todayAt7AMorPM';
        Datetime two = Datetime.newInstance(2024,7,23,0,0,0);
        
        string query = 'Select Id,Sub_Type_1_Lookup__c,Displayed_Bank_Name__c,Name_of_Consumer__c,Dispute_Already_Raised_30__c  '+
            ' ,Name_of_Consumer__r.Email,Forward_to_bank__c,Step_4_Consumer_Raised_Dispute__c,'+
            ' Resolve_Date__c	,Account_Type__c,Displayed_Account_number__c,Dispute_Raised_Date__c,'+
            ' AccountId,Name_of_Consumer__r.Name,CaseNumber,Step_5_Consumer_Raised_Dispute_Open__c,Displayed_Account_Type__c,'+
            ' Parent_Case_Consumer_Dispute__c,Status'+
            ' from Case where Status=\'Open\' and Consumer_Dispute_Status__c = null '+
            ' and Dispute_Already_Raised_30__c = false and Origin=\'Portal\''+
            ' and Step_1_Duplicate__c = false and Step_2_Resolved_Status__c = false and Step_3_Re_Raise__c = false' +
            ' and (CreatedDate = Today OR CreatedDate = Yesterday OR CreatedDate =: two ) ';
        if(!test.isRunningTest()){
            query+=' and Owner.Name=\'Consumer Support Queue\'';
            
            query +=' and  '+dte;
        }
        //query += AccountName;
        query+=' order by CaseNumber desc';
        //query+=' and Sub_Type_1_Name__c !=\'Account does not belong to me\'';
        
        List<Case> cseList = database.query(query);
        system.debug(cseList.size());
        return cseList;
    }
    
    global void execute(Database.BatchableContext BC , List<Case>Scope){
        List<EmailMessage>emcList = new List<EmailMessage>();
        OrgWideEmailAddress[] owea = new OrgWideEmailAddress[]{};
            if(!test.isRunningTest()){
                owea = [select Id from OrgWideEmailAddress where Address = 'consumer.support@in.experian.com' limit 1];// To send from Org wide address
            }
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        set<Id> subTypeOneId =  new set<Id>(); 
        set<string> displayedBankName = new set<string>();
        set<string> accountNumber = new set<string>();
        set<Id> consumerName = new set<Id>();  
        
        for(Case cs : scope){
            system.debug('-->'+cs.Id);
            if(!cs.Dispute_Already_Raised_30__c){
                subTypeOneId.add(cs.Sub_Type_1_Lookup__c);
                displayedBankName.add(cs.Displayed_Bank_Name__c);
                accountNumber.add(cs.Displayed_Account_number__c);
                consumerName.add(cs.Name_of_Consumer__c);
                //string key = cs.Sub_Type_1_Lookup__c+'_'+cs.Displayed_Bank_Name__c+'_'+cs.Displayed_Account_number__c+'_'+cs.Name_of_Consumer__c;
                //parentCaseId.put(key,Cs.Id);
            }
        }
        
        List<Case> caseList = new List<Case>();
        caseList =  [select Id, Name_of_Consumer__r.Email,Forward_to_bank__c,
                     Resolve_Date__c	,Account_Type__c,Displayed_Account_number__c,Dispute_Already_Raised_30__c,Dispute_Raised_Date__c,
                     AccountId,Name_of_Consumer__c,Name_of_Consumer__r.Name,CaseNumber,Sub_Type_1_Lookup__c,
                     Parent_Case_Consumer_Dispute__c,Displayed_Bank_Name__c, Parent_Case__c, Displayed_Account_Type__c
                     from case where 
                     Sub_Type_1_Lookup__c IN : subTypeOneId and 
                     Displayed_Bank_Name__c IN  : displayedBankName and
                     Displayed_Account_number__c  IN : accountNumber and Name_of_Consumer__c In : consumerName and status=:'Resolved'  and
                     Consumer_Dispute_Status__c='Resolved not in favour of the Consumer'
                     and Dispute_Already_Raised_30__c	 = false
                     order by caseNumber desc
                    ];
        
        if(caseList.size() > 0){
            
            map<string,Case> csMap = new map<string,Case>();
            map<string,Case> csMap2 = new map<string,Case>();
            for(Case cs : caseList){
                string key = cs.Sub_Type_1_Lookup__c+'_'+cs.Displayed_Bank_Name__c+'_'+cs.Displayed_Account_number__c+'_'+cs.Name_of_Consumer__c;
                if(csMap.containskey(key)){
                    
                }{
                    csMap.put(key,cs);   
                }
                
            }
            List<Case> csList = new List<Case>();
            List<Case> cssList = new List<Case>();
            
            for(case cs : scope){
                string key1 = cs.Sub_Type_1_Lookup__c+'_'+cs.Displayed_Bank_Name__c+'_'+cs.Displayed_Account_number__c+'_'+cs.Name_of_Consumer__c;
                if(csMap.containsKey(key1)){
                    if(csMap.get(key1).Resolve_Date__c!=null){
                        Integer DateBetween = csMap.get(key1).Resolve_Date__c.daysBetween(system.today());
                        system.debug('Resolve_Date__c'+csMap.get(key1).Resolve_Date__c+' between today is'+DateBetween);
                        if(DateBetween > 30  ){
                            system.debug('inside 30');
                            cs.Send_Email_to_Consumer__c = true;
                            cs.Dispute_Already_Raised_30__c = true;
                            
                            cs.Parent_Case_Consumer_Dispute__c = csMap.get(key1).Id;
                            cs.Dispute_Raised_Date__c = date.today();
                            cs.Step_4_Consumer_Raised_Dispute__c = true;
                            cs.Step_4_Consumer_Raised_Dispute_Date__c = system.today();
                            csReceivedIds.add(cs.Id) ;
                            csList.add(cs);
                            csMap2.put(cs.Id,cs);
                            
                        }else if(DateBetween < 30){
                            system.debug('else  30');
                            cs.Status = 'Resolved';
                            cs.Dispute_Already_Raised_30__c = true;
                            cs.Parent_Case__c = csMap.get(key1).Id;
                            cs.Dispute_Raised_Date__c = date.today();
                            csReceivedIds.add(cs.Id);
                            cs.Step_4_Consumer_Raised_Dispute__c = true;
                            cs.Step_4_Consumer_Raised_Dispute_Date__c = system.today();
                            cssList.add(cs);
                            csMap2.put(cs.Id,cs);
                            string emailbody = '';
                            emailbody+='Dear '+cs.Name_of_Consumer__r.Name + ',<br/><br/>';
                            emailbody+='Thank you for your continued co-operation.<br/><br/>';
                            emailbody+='This is with reference to ticket logged under '+cs.CaseNumber +'.<br/><br/>';
                            emailbody+='We had raised and followed up with the financial instituition through emails and calls.<br/><br/>';
                            emailbody+='We have received confirmation from Financial Institution – '+cs.Displayed_Account_Type__c+' ('+cs.Displayed_Account_number__c +' ) with regards to the dispute raised stating that the account information is correct as reported in the Credit report. We request you to follow up with the respective Financial Institution.<br/><br/>';
                            emailbody+='We would like to inform you that the Experian Credit Information Report is based on the information collated from our member banks / credit institutions with whom you have credit relationship. The information collated provides information of your credit card or loan accounts including your re-payment behaviour in the past 36 months.<br/><br/>';
                            emailbody+='As envisaged by the applicable law, Experian is only a collector and collator of credit information and not the originators of the credit information. Experian cannot make any changes or amendments to the credit information, and any required correction, deletion or addition can be made only after such correction, deletion or addition has been certified as correct by the concerned credit institution.<br/><br/>';
                            emailbody+='The request '+cs.caseNumber+' has been completed and we are closing this as resolved at our end.<br/><br/>'; 
                            emailbody+='In case you want to respond to the same query please write on the same email. Please feel free to write a separate email for any other queries. We will be glad to assist.<br/><br/>';
                            emailbody+='Do let us know if you have any further queries or concerns and we will be happy to assist.<br/><br/>';
                            emailbody+='Regards,<br/>';
                            emailbody +='<b>Consumer Support Team </b> <br/>';
                            emailbody +='Experian Credit Information Company of India Private Limited <br/>';
                            emailbody +='consumer.support@in.experian.com<br/>';
                            emailbody +='<a href="www.experian.in">www.experian.in</a><br/><br/>';
                            emailbody +='Get your Experian Credit Report & Score today, <a href="https://consumer.experian.in/ECV-OLN/view/angular/#/">click here</a>';
                            
                            emailbody+='';
                            
                            
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            mail.setUseSignature(false);
                            //mail.setToAddresses(new List<string>{'rishikesh.korade@finessedirect.com'});
                            mail.setToAddresses(new List<String>{cs.Name_of_Consumer__r.Email});
                            mail.htmlbody = emailbody + '<br /> ';
                            mail.subject = 'Dispute Resolved Follow up with the Institution.';
                            if ( owea.size() > 0 ) {
                                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                            }
                            
                            EmailMessage em=new EmailMessage();
                            em.subject ='Dispute Resolved Follow up with the Institution.';
                            em.RelatedToId=cs.id;  
                            em.ToAddress =cs.Name_of_Consumer__r.Email;
                            em.MessageDate=system.now();
                            em.Incoming=false;
                            em.Email_Body__c =emailbody;
                            em.Status='3';
                            em.FromAddress='consumer.support@in.experian.com';
                            em.FromName='Consumer Support';
                            emcList.add(em);
                            allMails.add(mail);
                        }
                    }
                }
                
                
            }
            
            List<Case> cseUpdate = new List<Case>();
            
            List<API_LOG__c> apliLogList = new List<API_LOG__c>();
            
            if(csList.size() > 0){
                //update csList;
                Database.SaveResult[] srList = Database.update(csList,false);
               /* for(Integer i=0;i<srList.size();i++){
                    if(!srList.get(i).isSuccess()){
                        for(Database.Error err : srList[i].getErrors()) {
                            if(csMap2.containskey(csList[i].Id)){
                                API_LOG__c ap =new API_LOG__c();
                                ap.Request_Source__c='Step 4 Fail '+csMap2.get(csList[i].Id).CaseNumber;
                                ap.Case__c = csMap2.get(csList[i].Id).Id;
                                ap.Exception_Description__c = err.getMessage();
                                apliLogList.add(ap);
                            } 
                        }
                    }
                    
                } */
                for(case cse2 : csList){
                    cse2.Forward_to_bank__c = true;
                    cseUpdate.add(cse2);  
                }
            }
            if(cseUpdate.size() > 0){
                Database.SaveResult[] srList = Database.update(cseUpdate,false);
               /* for(Integer i=0;i<srList.size();i++){
                    if(!srList.get(i).isSuccess()){
                        for(Database.Error err : srList[i].getErrors()) {
                            if(csMap2.containskey(cseUpdate[i].Id)){
                                API_LOG__c ap =new API_LOG__c();
                                ap.Request_Source__c='Step 4 Fail '+csMap2.get(cseUpdate[i].Id).CaseNumber;
                                ap.Case__c = csMap2.get(cseUpdate[i].Id).Id;
                                ap.Exception_Description__c = err.getMessage();
                                apliLogList.add(ap);
                            } 
                        }
                    }
                } */
            }
            
            
            if(cssList.size() > 0){
                system.debug('cssList::>> '+cssList.size());
                //update cssList;
                
                Database.SaveResult[] srList = Database.update(cssList,false);
                if(allMails.size() > 0){
                    List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
                    if(emcList.size() > 0){
                        insert emcList;
                    } 
                }
                for(Integer i=0;i<srList.size();i++){
                   /* if(!srList.get(i).isSuccess()){
                        for(Database.Error err : srList[i].getErrors()) {
                            if(csMap2.containskey(cssList[i].Id)){
                                API_LOG__c ap =new API_LOG__c();
                                ap.Request_Source__c='Step 4 Fail '+csMap2.get(cssList[i].Id).CaseNumber;
                                ap.Case__c = csMap2.get(cssList[i].Id).Id;
                                ap.Exception_Description__c = err.getMessage();
                                apliLogList.add(ap);
                            } 
                        }
                    } */
                    /*
                    }*/
                }
                
            }
            
            if(apliLogList.size() > 0){
                insert apliLogList;
            }
        }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('finish call '+csReceivedIds);
        if(csReceivedIds.size()>0){
            //SendSmsGupshup.sendSMSBatch(csReceivedIds,'received');
        }
    }
}