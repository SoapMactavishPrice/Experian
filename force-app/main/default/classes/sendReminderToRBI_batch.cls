global class sendReminderToRBI_batch implements Database.Batchable<sObject>,schedulable{
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new sendReminderToRBI_batch(),1);
    }
    
    
    global List<Case> start(Database.BatchableContext BC){
        
        string query= 'Select Id,Send_Mail_for_RBI_Complaint__c From Case Where (Case_Type_Name__c = \'Complaint Dispute Consumer\' OR Case_Type_Name__c = \'Complaint Dispute Commercial\') AND ( status = \'Open\' OR status = \'ReOpen\') AND ( Case_Origin_2__c= \'RBI\' OR Case_Origin_2__c= \'Presidential\' OR Case_Origin_2__c= \'Legal\')';
        
        if(test.isRunningTest()){   
            
        }else{
            query+= ' and Owner.Name =\'Bank Team\' ';
        } 
        
        
        List<Case> csList = database.query(query);
        return csList;
    }
    
    global void execute(Database.BatchableContext BC , List<Case>Scope){
        set<Id> trueCseId  = new set<Id>();
        set<Id> falseId  = new set<Id>();
        List<Case> updateTrueCases = new List<Case>();
        for(Case cs : scope){
            if(cs.Send_Mail_for_RBI_Complaint__c){
                cs.Send_Mail_for_RBI_Complaint__c = false;
                updateTrueCases.add(cs);
                //trueCseId.add(cs.Id);
            }
           falseId.add(cs.Id);
        }
        
        Database.SaveResult[] result = database.update(updateTrueCases,false);
        for (Database.SaveResult sr : result) {
            if (sr.isSuccess()) {
                trueCseId.add(sr.getId());
            }
        }
        
        List<Case> cseList = [select Id,Send_Mail_for_RBI_Complaint__c from Case where ID IN : falseId and Send_Mail_for_RBI_Complaint__c =: false];
        List<Case> updateList = new List<Case>();
        for(Case cs :  cseList){
            if(!cs.Send_Mail_for_RBI_Complaint__c){
                cs.Send_Mail_for_RBI_Complaint__c = true;
                updateList.add(cs);
            }
        }
        
        if(updateList.size()> 0){
          update updateList;  
        }
        
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
    
    
    
    
}