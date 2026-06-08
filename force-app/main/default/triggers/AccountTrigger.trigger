trigger AccountTrigger on Account (after update) {
    
    List<Account> accountsToProcess = new List<Account>();
    List<Account> nameChangedAccounts = new List<Account>();
    
    for (Account acc : Trigger.new) {
        
        Account oldAcc = Trigger.oldMap.get(acc.Id);
        if (acc.Send_Invoice_Email__c == true && oldAcc.Send_Invoice_Email__c != true) {
            accountsToProcess.add(acc);
        }

        if (acc.Name != oldAcc.Name) {
            nameChangedAccounts.add(acc);
        }
    }
    
    if (!accountsToProcess.isEmpty()) { 
        InvoiceEmailHelper.sendInvoiceEmail(accountsToProcess);
    }

    if (!nameChangedAccounts.isEmpty()) {
        AccountNameChangeEmailHelper.sendNameChangeEmail(
            nameChangedAccounts,
            Trigger.oldMap
        );
    }
}