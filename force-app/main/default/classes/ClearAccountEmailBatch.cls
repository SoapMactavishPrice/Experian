public class ClearAccountEmailBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    // All Account email fields to scan
    private static final List<String> EMAIL_FIELDS = new List<String>{
        'Email_1_Dispute__c','Email_2_Dispute__c','Email_3_Dispute__c','Email_4_Dispute__c','Email_5_Dispute__c',
        'Email_6_Dispute__c','Email_7_Dispute__c','Email_8_Dispute__c','Email_9_Dispute__c','Email_10_Dispute__c',
        'CC_Address_1__c','CC_Address_2__c','CC_Address_3__c','CC_Address_4__c','CC_Address_5__c',
        'CC_Address_6__c','CC_Address_7__c','CC_Address_8__c','CC_Address_9__c','CC_Address_10__c'
    };

    // State carried across chunks
    private Set<String> failureEmailsLower = new Set<String>();
    private Map<String, Failure_Email__c> feByEmailLower = new Map<String, Failure_Email__c>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        // 1) Load all failure emails (≈2000)
        List<Failure_Email__c> failures = [
            SELECT Id, Email__c, AccountName__c
            FROM Failure_Email__c
            WHERE Email__c != null AND AccountName__c = null
        ];

        // Normalize emails to lowercase for case-insensitive matching
        for (Failure_Email__c fe : failures) {
            String e = fe.Email__c != null ? fe.Email__c.trim().toLowerCase() : null;
            if (String.isBlank(e)) continue;
            failureEmailsLower.add(e);
            // If duplicates exist, keep the first one found. (You can switch to Map<String, List<Failure_Email__c>> if needed.)
            if (!feByEmailLower.containsKey(e)) {
                feByEmailLower.put(e, fe);
            }
        }

        if (failureEmailsLower.isEmpty()) {
            // No emails to act on; return a zero-row locator safely
            return Database.getQueryLocator('SELECT Id FROM Account WHERE Id = null');
        }

        // 2) Build a single QueryLocator for Accounts that have ANY of those emails
        //    WHERE (Email_1__c IN :failureEmailsLower OR Email_2__c IN :failureEmailsLower OR ...)
        String whereClause = '';
        for (String f : EMAIL_FIELDS) {
            whereClause += f + ' IN :failureEmailsLower OR ';
        }
        whereClause = whereClause.removeEnd(' OR ');

        String soql =
            'SELECT Id, ' + String.join(EMAIL_FIELDS, ',') +
            ' FROM Account WHERE ' + whereClause;

        return Database.getQueryLocator(soql);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        if (scope.isEmpty()) return;

        List<Account> accountsToUpdate = new List<Account>();
        // Update only the FE rows we actually touched in this execute
        Map<Id, Failure_Email__c> feTouched = new Map<Id, Failure_Email__c>();

        for (Account acc : scope) {
            Boolean changed = false;

            for (String fieldName : EMAIL_FIELDS) {
                String val = (String) acc.get(fieldName);
                if (String.isBlank(val)) continue;

                String key = val.trim().toLowerCase();
                if (!failureEmailsLower.contains(key)) continue;

                // Null the account field
                acc.put(fieldName, null);
                changed = true;

                // If the FE row exists and has no AccountName__c, set the first matched account
                Failure_Email__c fe = feByEmailLower.get(key);
                if (fe != null && fe.AccountName__c == null) {
                    fe.AccountName__c = acc.Id;
                    feTouched.put(fe.Id, fe);
                }
            }

            if (changed) {
                accountsToUpdate.add(acc);
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
        if (!feTouched.isEmpty()) {
            update feTouched.values();
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('ClearAccountEmailsBatch finished.');
    }

    // Scheduler Implementation
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new ClearAccountEmailBatch(), 200);
    }
}