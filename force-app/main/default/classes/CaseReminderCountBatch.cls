global class CaseReminderCountBatch implements Database.Batchable<sObject> {
    global Database.querylocator start(Database.BatchableContext BC) { 
        
        Date today = Date.today();
        string query = 'Select Id from Account where Id IN (select AccountId from Case where Status=\'open\'';
        if(!test.isRunningTest()){
            query+=  ' and Owner.Name =\'Bank Team\' and Account_s_Parent_Case__c = false ';
            query+=' and CreatedDate <: today '; 
        }
        query+=') and ID IN (Select AccountId from Case where Account_s_Parent_Case__c =true) and Do_Not_Send_Auto_Reminder__c =false';
        
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        map<Id,Id> accMap = new map<Id,Id> ();
        string accId ='';
        for(Account ac : scope){
            accId = ac.Id;
            accMap.put(ac.Id,ac.Id);
        }
        
        Date cutoffDate = Date.newInstance(2024, 4, 26);      
        List<Case> agrResult = [
            SELECT Id, AccountId, CreatedDate
            FROM Case
            WHERE AccountId != NULL 
            AND CreatedDate < :system.today() 
            AND Status='Open' AND Owner.Name ='Bank Team' and Account_s_Parent_Case__c = false
            AND Date_of_the_email_received__c < :cutoffDate     
            AND AccountId IN :accMap.keyset()
        ];
        
        map<Id,Integer>  caseCountsBefore = new map<Id,Integer>();
        caseCountsBefore.put(accId,agrResult.size());
        map<Id,Integer>  caseCountsAfter = new map<Id,Integer>();
        
        
        
        Date cutoffDateafter = Date.newInstance(2024, 4, 26);      
        List<Case> agrResultAfter = [
            SELECT Id, AccountId, CreatedDate
            FROM Case
            WHERE AccountId != NULL 
            AND CreatedDate < :system.today() 
            AND Status='Open' AND Owner.Name ='Bank Team' and Account_s_Parent_Case__c = false
            AND Date_of_the_email_received__c >= :cutoffDateafter     
            AND AccountId IN :accMap.keyset()
        ];
        
        caseCountsAfter.put(accId,agrResultAfter.size());
        
        
       //List<Case_Reminder__c> crList = new List<Case_Reminder__c>();
       //crList = [Select Id,Total_Open_Cases_Count__c,Reminder_Period__c, Account__c from Case_Reminder__c where Account__c IN : accMap.keyset()];        
        
        List<Case_Reminder__c> upsertList = new List<Case_Reminder__c>();
        //if(crList.size() ==0){
            for(string key : accMap.keyset()){
                Case_Reminder__c crBefore = new Case_Reminder__c();
                crBefore.Reminder_Period__c = 'Pre April 26, 2024';
                crBefore.Account__c = key;
                crBefore.Reminder_Date__c=  date.today();
                crBefore.Total_Open_Cases_Count__c = (Integer)caseCountsBefore.get(key);
                upsertList.add(crBefore);
                
                Case_Reminder__c crAfter = new Case_Reminder__c();
                crAfter.Reminder_Period__c = 'From April 26, 2024';
                crAfter.Account__c = key;
                crAfter.Reminder_Date__c=  date.today();
                crAfter.Total_Open_Cases_Count__c = (Integer)caseCountsAfter.get(key);
                upsertList.add(crAfter);
            }
            
        //}
        
        /*else if(crList.size() > 0){
            for(Case_Reminder__c crd : crList){
                if(caseCountsBefore.containsKey(crd.Account__c) && crd.Reminder_Period__c == 'Pre April 26, 2024'){
                    Case_Reminder__c crdm = new Case_Reminder__c();
                    crdm.Id = crd.Id;
                    crdm.Reminder_Date__c=  date.today().addDays(-1);
                    crdm.Total_Open_Cases_Count__c = (Integer)caseCountsBefore.get(crd.Account__c);
                    upsertList.add(crdm);
                }
                
                if(caseCountsAfter.containsKey(crd.Account__c) && crd.Reminder_Period__c == 'From April 26, 2024'){
                    Case_Reminder__c crds = new Case_Reminder__c();
                    crds.Id = crd.Id;
                    crds.Reminder_Date__c=  date.today().addDays(-1);
                    crds.Total_Open_Cases_Count__c = (Integer)caseCountsAfter.get(crd.Account__c);
                    upsertList.add(crds);
                }
            }
        }
        */
        system.debug('insert' + upsertList.size());
        if(upsertList.size() > 0){
            upsert upsertList;
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}