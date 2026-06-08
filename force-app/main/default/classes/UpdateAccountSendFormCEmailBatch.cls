global class UpdateAccountSendFormCEmailBatch implements Database.Batchable<sObject>, Schedulable {
    
    global Database.queryLocator start(Database.BatchableContext bc) {

        Id rtId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Customer' LIMIT 1].Id;
        String soql = 'SELECT Id, Name, Last_Form_C_Sent_Date__c FROM Account WHERE Member_Status__c != \'Merged\' AND Member_Status__c != \'Closed\' AND Member_Status__c != \'Suppressed for Duplication\' AND Send_Form_C_Email__c = false AND Do_Not_Send_Fortnightly_Email__c = false AND Form_C_Level_1_Email_Present__c  = true  AND RecordTypeId = :rtId';
        return Database.getQueryLocator(soql);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope) {
        
        Date yesterdaydate = Date.today().addDays(-1);
        Date dayBeforeYesterdaydate = Date.today().addDays(-2);

        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account acc : scope) {
            if (acc.Last_Form_C_Sent_Date__c != yesterdaydate && acc.Last_Form_C_Sent_Date__c != dayBeforeYesterdaydate) {
                acc.Send_Form_C_Email__c = true;
                accountsToUpdate.add(acc);
            }
        }
        if (!accountsToUpdate.isEmpty()) {
            Database.update(accountsToUpdate, false);
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        
    }
    
    global void execute(SchedulableContext sc) {
        Date today = Date.today();
        Integer dayOfMonth = today.day();
        if(Test.isRunningTest()){
            dayOfMonth = 1;
        }
        Integer dayOfWeek = today.toStartOfWeek().daysBetween(today) + 1; 
        // 1 = Sunday, 2 = Monday, ... 7 = Saturday
        
        Boolean shouldRun = false;
        
        // Case 1: If today is 1st or 16th and it's a weekday
        if ((dayOfMonth == 1 || dayOfMonth == 16) 
            && dayOfWeek >= 2 && dayOfWeek <= 6) {
                shouldRun = true;
            }
        
        // Case 2: If today is Monday, check if weekend shifted date
        if (dayOfWeek == 2) { // Monday
            
            Date yesterday = today.addDays(-1);
            Date twoDaysAgo = today.addDays(-2);
            
            if (yesterday.day() == 1 || yesterday.day() == 16 ||
                twoDaysAgo.day() == 1 || twoDaysAgo.day() == 16) {
                    shouldRun = true;
                }
        }
        
        if (shouldRun) {
            Database.executeBatch(new UpdateAccountSendFormCEmailBatch(), 1);
        }
    }
}