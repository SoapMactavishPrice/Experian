global class SendConsumerEmailForwardBank implements Database.Batchable<sObject>,schedulable,Database.AllowsCallouts,Database.Stateful{
    
    Set<Id> csReceivedIds=new Set<Id>();  
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new SendConsumerEmailForwardBank(),Integer.ValueOf(Label.SendConsumerDisputeEmailSize));
    }
    
    global List<Case> start(Database.BatchableContext bc){
        
        List<Case> cselist = new List<Case> ();
        
        string query= 'Select Id, Case_Category__c, CaseNumber, Status, Sub_Type_Lookup__c, Sub_Type_1_Lookup__c,Displayed_Bank_Name__c, Displayed_Account_number__c, '+
            ' Name_of_Consumer__c, CreatedBy.Name, Date_of_the_email_received__c, Sub_Type_1_Name__c, Owner.Name, Origin,Dispute_Raised_Date__c, Send_Email_to_Consumer__c, Forward_to_bank__c, Temp_Forward_to_Bank__c '+
            ' from Case  '+
            ' where (CreatedDate = Today OR CreatedDate = Yesterday) AND Sub_Type_1_Name__c !=\'Junk\' '+
            ' and Sub_Type_1_Name__c !=null AND Case_Category__c = \'Consumer\'  '+
            ' and (Case_Type_Name__c = \'Complaint Dispute Consumer\') '+ 
            ' and Origin=\'Email\' and AccountId !=null '+ 
            ' and Name_of_Consumer__c !=null AND CreatedBy.Name !=\'Integration User\'  '+
            ' and Displayed_Bank_Name__c !=null  '+
            ' and Displayed_Account_number__c !=null and  '+
            ' Date_of_the_email_received__c !=null AND Send_Email_to_Consumer__c = false and Status = \'Open\' ';
        
        if(!test.isRunningTest()){
            query+=' and Owner.Name=\'Consumer Support Queue\'';
        }
        query+=' order by CaseNumber asc';
        
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
            }
            else if(cs.Dispute_Raised_Date__c != null && cs.Dispute_Raised_Date__c != system.today() ||
                    cs.Dispute_Raised_Date__c != null && cs.Dispute_Raised_Date__c == system.today()){
                        cs.Dispute_Raised_Date__c = system.today();
                        csMap.put(cs.Id,cs);
                    } 
        }
        
        if(csMap.size() > 0){
            Database.SaveResult[] srList = Database.update(csMap.values(),false);
            
            for(Case cs : csMap.values()){
                if(cs.Dispute_Raised_Date__c == system.today()){
                    cs.Send_Email_to_Consumer__c = true;
                    csMap1.put(cs.Id,cs);
                }
            }
        }
        
        if(csMap1.size() > 0){
            Database.SaveResult[] srList = Database.update(csMap1.values(),false);
            
            for(Integer i=0;i<srList.size();i++){
                if(srList.get(i).isSuccess()){
                    Id csId = srList.get(i).getId();
                    csReceivedIds.add(csId) ;
                }
            }
            
            for(Case cs : csMap1.values()){
                if(cs.Dispute_Raised_Date__c == system.today() && cs.Send_Email_to_Consumer__c == true){
                    cs.Forward_to_bank__c = true;
                    cs.Temp_Forward_to_Bank__c = true;
                    csMap2.put(cs.Id,cs);
                }
            }
        }
        
        if (!csReceivedIds.isEmpty()) {
            System.debug('Sending SMS for cases (Queueable): ' + csReceivedIds);
            System.enqueueJob(new SendSmsQueueable(new Set<Id>(csReceivedIds), 'received'));
            csReceivedIds.clear(); // Clear so next chunk doesn’t resend
        } 
        if(csMap2.size() > 0){
            Database.SaveResult[] srList = Database.update(csMap2.values(),false);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        System.debug('Batch finished. All SMS were triggered via queueable inside execute()');
    }
}