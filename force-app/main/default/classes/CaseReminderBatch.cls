global class CaseReminderBatch implements Database.Batchable<sObject>, Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        return Database.getQueryLocator([
            SELECT Id, Open_Days_for_Reminder__c, Send_7th_Day_Draft__c, Send_15th_Day_Draft__c, Send_21st_Day_Draft__c, 
            Send_31st_Day_Draft__c  FROM Case  WHERE Status = 'Open' And Case_Category__c ='Consumer' 
            And Case_Type_Name__c = 'Complaint Dispute Consumer' And Consumer_Dispute_Status__c ='Acknowledgement sent to Consumer' 
            And Open_Days_for_Reminder__c > 5 and Open_Days_for_Reminder__c < 32
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Case> caseList) {
        
        List<Case> casesToUpdate = new List<Case>();
        
        for (Case c : caseList) {
            
            if (c.Open_Days_for_Reminder__c == 7  && c.Send_7th_Day_Draft__c  == false) {
                c.Send_7th_Day_Draft__c = true;
            }
            if (c.Open_Days_for_Reminder__c == 15 && c.Send_15th_Day_Draft__c == false) {
                c.Send_15th_Day_Draft__c = true;
            }
            if (c.Open_Days_for_Reminder__c == 21 && c.Send_21st_Day_Draft__c == false) {
                c.Send_21st_Day_Draft__c = true;
            }
            if (c.Open_Days_for_Reminder__c == 31 && c.Send_31st_Day_Draft__c == false) {
                c.Send_31st_Day_Draft__c = true;
            }
            casesToUpdate.add(c);
        }
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext BC) {}
    
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new CaseReminderBatch(), 1);
    }
}