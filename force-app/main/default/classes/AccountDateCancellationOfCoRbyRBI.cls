global class AccountDateCancellationOfCoRbyRBI 
    implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext bc) {

        return Database.getQueryLocator([
            SELECT Id,
                   Date_of_Cancellation_of_CoR_by_RBI__c,
                   Send_Date_of_Cancellation_of_CoR_by_RBI__c
            FROM Account
            WHERE Date_of_Cancellation_of_CoR_by_RBI__c = LAST_MONTH
            AND Send_Date_of_Cancellation_of_CoR_by_RBI__c = FALSE
        ]);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope) {

        for (Account acc : scope) {
            acc.Send_Date_of_Cancellation_of_CoR_by_RBI__c = true;
        }

        if (!scope.isEmpty()) {
            update scope;
        }
    }

    global void finish(Database.BatchableContext bc) {
        // Optional: logging, notification, chaining another batch
    }

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new AccountDateCancellationOfCoRbyRBI(), 1);
    }
}