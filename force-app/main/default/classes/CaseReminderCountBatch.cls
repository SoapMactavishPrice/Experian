global class CaseReminderCountBatch implements Database.Batchable<sObject>, Schedulable {
    global Database.querylocator start(Database.BatchableContext BC) { 
        
        Date today = Date.today();
        string query =  'SELECT Id,' +
                        ' Email_1_Dispute__c, Email_2_Dispute__c, Email_3_Dispute__c, Email_4_Dispute__c, Email_5_Dispute__c,' +
                        ' Email_6_Dispute__c, Email_7_Dispute__c, Email_8_Dispute__c, Email_9_Dispute__c, Email_10_Dispute__c,' +
                        ' CC_Address_1__c, CC_Address_2__c, CC_Address_3__c, CC_Address_4__c, CC_Address_5__c,' +
                        ' CC_Address_6__c, CC_Address_7__c, CC_Address_8__c, CC_Address_9__c, CC_Address_10__c ' +
                        ' From Account where Id IN (select AccountId from Case where Status=\'open\'';
        if(!test.isRunningTest()){
            query+=  ' and (Owner.Name =\'Bank Team\' OR Owner.Name =\'Bank Team-Blank/Incorrect Reject Reason\' OR Owner.Name =\'Bank Team-IO Seeking Further Information\') and Account_s_Parent_Case__c = false ';
            query+=' and CreatedDate <: today '; 
        }
        query+=') and ID IN (Select AccountId from Case where Account_s_Parent_Case__c =true) and Do_Not_Send_Auto_Reminder__c =false';
        
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        Map<Id, Account> accMap = new Map<Id, Account>();
        string accId ='';
        for(Account ac : scope){
            accId = ac.Id;
            accMap.put(ac.Id, ac);
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
            AND Status='Open' AND (Owner.Name ='Bank Team' OR Owner.Name ='Bank Team-Blank/Incorrect Reject Reason' OR Owner.Name ='Bank Team-IO Seeking Further Information' ) and Account_s_Parent_Case__c = false
            AND Date_of_the_email_received__c >= :cutoffDateafter     
            AND AccountId IN :accMap.keyset()
        ];
        
        caseCountsAfter.put(accId,agrResultAfter.size());
        
        
       //List<Case_Reminder__c> crList = new List<Case_Reminder__c>();
       //crList = [Select Id,Total_Open_Cases_Count__c,Reminder_Period__c, Account__c from Case_Reminder__c where Account__c IN : accMap.keyset()];        
        
        List<Case_Reminder__c> upsertList = new List<Case_Reminder__c>();
        //if(crList.size() ==0){
            for(string key : accMap.keyset()){
                Account acc = accMap.get(key);
                Case_Reminder__c crBefore = new Case_Reminder__c();
                crBefore.Reminder_Period__c = 'Pre April 26, 2024';
                crBefore.Account__c = key;
                crBefore.Reminder_Date__c=  date.today();
                crBefore.Total_Open_Cases_Count__c = caseCountsBefore.containsKey(key) ? caseCountsBefore.get(key) : 0;
                // EMAIL MAPPING
                crBefore.Email_1_Dispute__c = acc.Email_1_Dispute__c;
                crBefore.Email_2_Dispute__c = acc.Email_2_Dispute__c;
                crBefore.Email_3_Dispute__c = acc.Email_3_Dispute__c;
                crBefore.Email_4_Dispute__c = acc.Email_4_Dispute__c;
                crBefore.Email_5_Dispute__c = acc.Email_5_Dispute__c;
                crBefore.Email_6_Dispute__c = acc.Email_6_Dispute__c;
                crBefore.Email_7_Dispute__c = acc.Email_7_Dispute__c;
                crBefore.Email_8_Dispute__c = acc.Email_8_Dispute__c;
                crBefore.Email_9_Dispute__c = acc.Email_9_Dispute__c;
                crBefore.Email_10_Dispute__c = acc.Email_10_Dispute__c;

                // CC MAPPING
                crBefore.CC_Address_1__c = acc.CC_Address_1__c;
                crBefore.CC_Address_2__c = acc.CC_Address_2__c;
                crBefore.CC_Address_3__c = acc.CC_Address_3__c;
                crBefore.CC_Address_4__c = acc.CC_Address_4__c;
                crBefore.CC_Address_5__c = acc.CC_Address_5__c;
                crBefore.CC_Address_6__c = acc.CC_Address_6__c;
                crBefore.CC_Address_7__c = acc.CC_Address_7__c;
                crBefore.CC_Address_8__c = acc.CC_Address_8__c;
                crBefore.CC_Address_9__c = acc.CC_Address_9__c;
                crBefore.CC_Address_10__c = acc.CC_Address_10__c;

                upsertList.add(crBefore);
                
                Case_Reminder__c crAfter = new Case_Reminder__c();
                crAfter.Reminder_Period__c = 'From April 26, 2024';
                crAfter.Account__c = key;
                crAfter.Reminder_Date__c=  date.today();
                crAfter.Total_Open_Cases_Count__c = caseCountsAfter.containsKey(key) ? caseCountsAfter.get(key) : 0;
                // EMAIL MAPPING
                crAfter.Email_1_Dispute__c = acc.Email_1_Dispute__c;
                crAfter.Email_2_Dispute__c = acc.Email_2_Dispute__c;
                crAfter.Email_3_Dispute__c = acc.Email_3_Dispute__c;
                crAfter.Email_4_Dispute__c = acc.Email_4_Dispute__c;
                crAfter.Email_5_Dispute__c = acc.Email_5_Dispute__c;
                crAfter.Email_6_Dispute__c = acc.Email_6_Dispute__c;
                crAfter.Email_7_Dispute__c = acc.Email_7_Dispute__c;
                crAfter.Email_8_Dispute__c = acc.Email_8_Dispute__c;
                crAfter.Email_9_Dispute__c = acc.Email_9_Dispute__c;
                crAfter.Email_10_Dispute__c = acc.Email_10_Dispute__c;

                // CC MAPPING
                crAfter.CC_Address_1__c = acc.CC_Address_1__c;
                crAfter.CC_Address_2__c = acc.CC_Address_2__c;
                crAfter.CC_Address_3__c = acc.CC_Address_3__c;
                crAfter.CC_Address_4__c = acc.CC_Address_4__c;
                crAfter.CC_Address_5__c = acc.CC_Address_5__c;
                crAfter.CC_Address_6__c = acc.CC_Address_6__c;
                crAfter.CC_Address_7__c = acc.CC_Address_7__c;
                crAfter.CC_Address_8__c = acc.CC_Address_8__c;
                crAfter.CC_Address_9__c = acc.CC_Address_9__c;
                crAfter.CC_Address_10__c = acc.CC_Address_10__c;
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
        // if(upsertList.size() > 0){
        //     upsert upsertList;
        // }
        
        List<API_LOG__c> apiLogList = new List<API_LOG__c>();
        Database.UpsertResult[] srList = Database.upsert(upsertList, false);
        for (Integer i = 0; i < srList.size(); i++) {   
            if (!srList[i].isSuccess()) {
                Case_Reminder__c failedRec = upsertList[i];
                for (Database.Error err : srList[i].getErrors()) {
                    API_LOG__c log = new API_LOG__c();
                    log.Request_Source__c = 'CaseReminderCountBatch Failure';
                    log.Exception_Description__c = 'AccountId: ' + failedRec.Account__c + ' | Error: ' + err.getMessage();
                    apiLogList.add(log); 
                }
            }
        }

        if (!apiLogList.isEmpty()) {
            insert apiLogList;
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        
    }

    global void execute(SchedulableContext sc) {
        CaseReminderCountBatch sm = new CaseReminderCountBatch();
        Database.executeBatch(sm,1);
    }
    
}