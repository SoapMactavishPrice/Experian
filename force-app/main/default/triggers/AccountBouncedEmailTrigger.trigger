trigger AccountBouncedEmailTrigger on Account (before update) {

    List<Account> accountsToProcess = new List<Account>();

    for(Account acc : Trigger.new) {

        Account oldAcc = Trigger.oldMap.get(acc.Id);

        if(
            acc.Bounced_Email__c != oldAcc.Bounced_Email__c &&
            String.isNotBlank(acc.Bounced_Email__c)
        ){
            accountsToProcess.add(acc);
        }
    }

    if(!accountsToProcess.isEmpty()) {
        AccountBounceEmailHandler.removeBouncedEmails(accountsToProcess);
    }
}