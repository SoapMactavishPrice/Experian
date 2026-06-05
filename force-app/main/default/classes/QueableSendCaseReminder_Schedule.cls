global  class QueableSendCaseReminder_Schedule implements Database.batchable<sObject>,Schedulable{
    global void execute(SchedulableContext SC) {
 	     database.executebatch(new QueableSendCaseReminder_Schedule(),1);
    }
    
    global Database.querylocator start(Database.BatchableContext BC) {
        Date cutoffDate = Date.newInstance(2024, 4, 26);      
        string query ='Select Id, Name, Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,'+
            ' Email_4_Dispute__c,Email_5_Dispute__c,Email_6_Dispute__c'+
           ' From Account where Id IN (SELECT AccountId From Case Where (status = \'Open\' or status = \'Customer Notified\') ';
        
        if(!test.isRunningTest()){
          query+=  ' and Owner.Name =\'Bank Team\' and Account_s_Parent_Case__c = false ';
            query+=' and Date_of_the_email_received__c <: cutoffDate '; 
        }
        
        query+=') and ID IN (Select AccountId from Case where Account_s_Parent_Case__c =true) and Do_Not_Send_Auto_Reminder__c =false';
        
        return Database.getQueryLocator(query);
    }
  

    public List<Messaging.Email> allMails;
   global void execute(Database.BatchableContext BC, List<Account> scope){
		List<Account> accList= new List<Account>();
        accList = scope; 
        system.debug('accList'+accList.size());
        
        set<Id> caseIds = new set<Id>();
        set<Id> accIds = new set<Id>();
        
        for(Account ac :  accList){
            accIds.add(ac.Id);
        }
        system.debug(accIds);
                Date cutoffDate = Date.newInstance(2024, 4, 26);      

          string q = 'select Id, Name_of_Consumer__r.Name,Name_of_Consumer__r.BirthDate,Raised_Days__c,Member_TAT__c,'+
            +' Name_of_Consumer__r.Phone,AccountId,Name_of_Consumer__r.Email,Name_of_Consumer__r.Pan_no__c, Dispute_Raised_Date__c, '+
            +' Account.Name, Displayed_Account_Type__c, Displayed_Account_number__c, Dispute_Detail__c,  '+
            +' Displayed_Details__c, Correct_Details__c,Open_Ageing_with_Bank__c, '+
            +'CaseNumber'+
            ' from Case where AccountId IN : accIds and (status = \'Open\' or status = \'Customer Notified\') and Account_s_Parent_Case__c = false';
        
        if(!test.isRunningTest()){
          q+= ' and Owner.Name =\'Bank Team\'';
             q+=' and Date_of_the_email_received__c <: cutoffDate '; 
        }
        
        List<Case> casesList = dataBase.query(q);
        Map<Id,Case> caseMap = new Map<Id,Case>();
        
        List<Case> Caselist = [Select Id, AccountId from Case where Account_s_Parent_Case__c =:true and AccountId IN:accIds];
        
        Id bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;
        List<Case> Up_Parent_CaseList = new List<Case>();
       
        for(Case cs : Caselist){
                caseMap.put(cs.AccountId,cs);
                cs.OwnerId = bankteamId;
                //Up_Parent_CaseList.add(cs);
        }
        system.debug('caseMap'+caseMap.size());
        system.debug('Caselist'+Up_Parent_CaseList);
        
        String threadId;
        
        for(Case cs : casesList) {
                if(caseMap.containskey(cs.accountId)){
                    cs.Reminder_Parent_Case__c = caseMap.get(cs.accountId).Id;
                    Up_Parent_CaseList.add(cs);
                }
            }
            
            system.debug(Up_Parent_CaseList.size());
            system.enqueueJob(new QueableSendCaseReminder(Up_Parent_CaseList,'UPDATE',100,accList[0].Id,'',accList));
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}