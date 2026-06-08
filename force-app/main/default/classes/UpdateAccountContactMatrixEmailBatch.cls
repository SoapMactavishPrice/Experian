global class UpdateAccountContactMatrixEmailBatch implements Database.Batchable<sObject>, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext bc) {

        Id rtId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'Customer' LIMIT 1].Id;

        String soql = 'SELECT Id, Name, Last_Contact_Matrix_Sent_Date__c FROM Account ' +
                      'WHERE Send_Contact_Matrix__c = false AND Do_Not_Send_Contact_Matrix__c = false ' +
                      'AND FormC_DQREmailPresent__c = true ' +
                      'AND RecordTypeId = :rtId';

        return Database.getQueryLocator(soql);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope) {

        Date yesterday = Date.today().addDays(-1);
        Date dayBeforeYesterday = Date.today().addDays(-2);

        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : scope) {
            if (acc.Last_Contact_Matrix_Sent_Date__c != yesterday &&
                acc.Last_Contact_Matrix_Sent_Date__c != dayBeforeYesterday) {

                acc.Send_Contact_Matrix__c = true;
                accountsToUpdate.add(acc);
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    global void finish(Database.BatchableContext bc) {}

    global void execute(SchedulableContext sc) {

        Date today = Date.today();

        Integer dayOfMonth = today.day();
        if (Test.isRunningTest()) {
            dayOfMonth = 1;
        }

        Integer month = today.month();
        Integer dayOfWeek = today.toStartOfWeek().daysBetween(today) + 1;

        Boolean isQuarterMonth = (month == 3 || month == 6 || month == 9 || month == 12);

        Boolean shouldRun = false;

        // Case 1: 1st weekday of quarter month
        if (isQuarterMonth && dayOfMonth == 1 && dayOfWeek >= 2 && dayOfWeek <= 6) {
            shouldRun = true;
        }

        // Case 2: Monday shift if 1st was weekend
        if (isQuarterMonth && dayOfWeek == 2) {

            Date yesterday = today.addDays(-1);
            Date twoDaysAgo = today.addDays(-2);

            if (yesterday.day() == 1 || twoDaysAgo.day() == 1) {
                shouldRun = true;
            }
        }

        if (shouldRun) {
            Database.executeBatch(new UpdateAccountContactMatrixEmailBatch(), 1);
        }
    }
}