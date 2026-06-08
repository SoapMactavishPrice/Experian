//Process  6
global class SendConsumerDisputeEmail  implements Database.Batchable<sObject>,schedulable,Database.AllowsCallouts,Database.Stateful {
    //add by rishikesh
    Set<Id> csReceivedIds=new Set<Id>();  
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new SendConsumerDisputeEmail(),Integer.ValueOf(Label.SendConsumerDisputeEmailSize));
    }
    
    global  List<Case> start(Database.BatchableContext bc){
        
        List<Case> cselist = new List<Case> ();
        
        Datetime two = Datetime.newInstance(2024,7,23,0,0,0);
        Datetime todayAt7AMorPM = getCurrentTime.getTime(dateTime.now());
        
        
        string dte ='CreatedDate <=: todayAt7AMorPM';
        
        string query= 'Select Id,caseNumber, Status, Sub_Type_Lookup__c,Sub_Type_1_Lookup__c,Step_6_Acknowledge_Forward_To_Bank__c,Step_6_B_Forward_To_Bank__c,Displayed_Bank_Name__c,Displayed_Account_number__c, '+
            ' Name_of_Consumer__c, Sub_Type_1_Name__c, Owner.Name, Origin,Dispute_Raised_Date__c,Send_Email_to_Consumer__c,Forward_to_bank__c,Temp_Forward_to_Bank__c '+
            ' from Case  '+
            ' where Sub_Type_1_Name__c !=\'Junk\' '+
            ' and Sub_Type_1_Name__c !=null AND  '+
            ' (Case_Type_Name__c = \'Complaint Dispute Consumer\' OR Case_Type_Name__c = \'Complaint Dispute Commercial\') '+ 
            ' and Origin=\'Portal\' and AccountId !=null '+ 
            ' and Name_of_Consumer__c !=null  '+
            ' and Displayed_Bank_Name__c !=null  '+
            ' and Displayed_Account_number__c !=null and  '+
            ' Date_of_the_email_received__c !=null AND Send_Email_to_Consumer__c = false and Status = \'Open\' '+ 
            ' and Step_1_Duplicate__c = false and Step_2_Resolved_Status__c = false and Step_3_Re_Raise__c = false and Step_4_Consumer_Raised_Dispute__c = false '+
            ' and Step_5_Consumer_Raised_Dispute_Open__c =false ';
        
        if(!test.isRunningTest()){
            query+=' and Owner.Name=\'Consumer Support Queue\'';
            query +=' and  '+dte;
        }
        query+=' order by CaseNumber asc';
        //(CreatedDate = Today OR CreatedDate = Yesterday OR CreatedDate =: two ) AND - by Balram on 19-02-2026
        
        cselist = database.query(query);
        system.debug('cselist-->'+cselist.size());
        return cselist;
    }
    
    global void  execute (Database.BatchableContext bc , List<Case> Scope){
        
        map<Id,Case> csMap = new map<Id,Case>();
        map<Id,Case> csMap1 = new map<Id,Case>();
        map<Id,Case> csMap2 = new map<Id,Case>();
        List<Case> csList = Scope;
        
        for(Case cs : Scope){
            
            if(cs.Dispute_Raised_Date__c == null){
                cs.Dispute_Raised_Date__c = system.today();
                csMap.put(cs.Id,cs);
                //csReceivedIds.add(cs.Id) ;
            }
            else if(cs.Dispute_Raised_Date__c != null && cs.Dispute_Raised_Date__c != system.today() ||
                    cs.Dispute_Raised_Date__c != null && cs.Dispute_Raised_Date__c == system.today()){
                        cs.Dispute_Raised_Date__c = system.today();
                        csMap.put(cs.Id,cs);
                        //csReceivedIds.add(cs.Id) ;
                    } 
        }
        
        List<API_LOG__c> apliLogList = new List<API_LOG__c>();
        if(csMap.size() > 0){
            Database.SaveResult[] srList = Database.update(csMap.values(),false);
            
            for(Integer i=0;i<srList.size();i++){
                    if(!srList.get(i).isSuccess()){
                        /* for(Database.Error err : srList[i].getErrors()) {
                            if(csMap.containskey(csList[i].Id)){
                                API_LOG__c ap =new API_LOG__c();
                                ap.Request_Source__c='Step 6 Fail '+csMap.get(csList[i].Id).CaseNumber;
                                ap.Case__c = csMap.get(csList[i].Id).Id;
                                ap.Exception_Description__c = err.getMessage();
                                apliLogList.add(ap);
                            } 
                        } */
                    }
                }
            
            for(Case cs : csMap.values()){
                if(cs.Dispute_Raised_Date__c == system.today()){
                    cs.Send_Email_to_Consumer__c = true;
                    cs.Step_6_Acknowledge_Forward_To_Bank__c = true;
                    cs.Step_6_A_Acknowledgement_To_Cons_Date__c = system.today();
                    csMap1.put(cs.Id,cs);
                }
            }
        }
        
        if(csMap1.size() > 0){
            Database.SaveResult[] srList = Database.update(csMap1.values(),false);
            
            for(Integer i=0;i<srList.size();i++){
                    //if(!srList.get(i).isSuccess()){
                       /* for(Database.Error err : srList[i].getErrors()) {
                            if(csMap1.containskey(csList[i].Id)){
                                API_LOG__c ap =new API_LOG__c();
                                ap.Request_Source__c='Step 6 Fail '+csMap1.get(csList[i].Id).CaseNumber;
                                ap.Case__c = csMap1.get(csList[i].Id).Id;
                                ap.Exception_Description__c = err.getMessage();
                                apliLogList.add(ap);
                            } 
                        } */
                    //}
                    if(srList.get(i).isSuccess()){
                        Id csId = srList.get(i).getId();
                        csReceivedIds.add(csId) ;
                    }
                }
        }

        if (!csReceivedIds.isEmpty()) {
            System.debug('Sending SMS for cases (Queueable): ' + csReceivedIds);
            System.enqueueJob(new SendSmsQueueable(new Set<Id>(csReceivedIds), 'received'));
            csReceivedIds.clear(); // Clear so next chunk doesn’t resend
        }
        
        if(apliLogList.size() > 0){
                insert apliLogList;
            }
        
    }
    global void finish(Database.BatchableContext bc){
        System.debug('Batch finished. All SMS were triggered via queueable inside execute()');
        // if(csReceivedIds.size()>0){
        //     //SendSmsGupshup.sendSMSBatch(csReceivedIds,'received');
        //     SendSmsOnextel.sendSMSBatch(csReceivedIds,'received');
        // } 
    }
    
}