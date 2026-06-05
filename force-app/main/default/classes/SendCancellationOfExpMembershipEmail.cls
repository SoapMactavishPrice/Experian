global class SendCancellationOfExpMembershipEmail implements Database.Batchable<SObject>, Schedulable {
    
    /* ================= BATCH START ================= */
    global Database.QueryLocator start(Database.BatchableContext bc) { 
        String query =
            'SELECT Id, Name, Last_Termination_Sent_Date__c, Send_Cancellation_of_Experian_Membership__c ' +
            'FROM Account ' +
            'WHERE (Date_of_Cancellation_of_CoR_by_RBI__c = LAST_MONTH ' +
            'OR Include_in_Termination_List_CoR_by_RBI__c = true) ' +
            'AND Send_Cancellation_of_Experian_Membership__c = false';
        
        return Database.getQueryLocator(query);
    }
    
    /* ================= BATCH EXECUTE ================= */
    global void execute(Database.BatchableContext bc, List<Account> scope) {

        Date yesterdaydate = Date.today().addDays(-1);
        Date dayBeforeYesterdaydate = Date.today().addDays(-2);

        List<Account> accountsToUpdate = new List<Account>();
        
        for (Account acc : scope) {
            if (acc.Last_Termination_Sent_Date__c != yesterdaydate &&
                acc.Last_Termination_Sent_Date__c != dayBeforeYesterdaydate) {
                    acc.Send_Cancellation_of_Experian_Membership__c = true;
                    accountsToUpdate.add(acc);
            }
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    /* ================= BATCH FINISH ================= */
    global void finish(Database.BatchableContext bc) {}
    
    /* ================= SCHEDULER ================= */
    global void execute(SchedulableContext sc) {
        Date today = Date.today();
        Date firstOfMonth = Date.newInstance(today.year(), today.month(), 1);

        Integer todayDay = today.day();
        Integer firstDayOfWeek = firstOfMonth.toStartOfWeek().daysBetween(firstOfMonth) + 1;
        // 1 = Sunday, 2 = Monday ... 7 = Saturday

        Boolean shouldRun = false;

        if (Test.isRunningTest()) {
            shouldRun = true;
        } 
        else {

            // If 1st is Saturday
            if (firstDayOfWeek == 7 && todayDay == 3) {
                shouldRun = true;
            }
            // If 1st is Sunday
            else if (firstDayOfWeek == 1 && todayDay == 2) {
                shouldRun = true;
            }
            // Normal case: run on 1st (Mon-Fri)
            else if (todayDay == 1 && firstDayOfWeek >= 2 && firstDayOfWeek <= 6) {
                shouldRun = true;
            }
        }

        if (shouldRun) {
            Database.executeBatch(new SendCancellationOfExpMembershipEmail(), 1);
        }
    }
}