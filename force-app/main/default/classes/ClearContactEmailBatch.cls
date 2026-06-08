public class ClearContactEmailBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    // Store emails
    private Set<String> failureEmailsLower = new Set<String>();
    private Map<String, Failure_Email__c> feByEmailLower = new Map<String, Failure_Email__c>();

    public Database.QueryLocator start(Database.BatchableContext bc) {

        // 1. Load Failure Email records
        List<Failure_Email__c> failures = [
            SELECT Id, Email__c, ContactName__c
            FROM Failure_Email__c   
            WHERE Email__c != null AND ContactName__c = null
        ];

        for (Failure_Email__c fe : failures) {
            if (String.isBlank(fe.Email__c)) continue;

            String key = fe.Email__c.trim().toLowerCase();

            failureEmailsLower.add(key);

            if (!feByEmailLower.containsKey(key)) {
                feByEmailLower.put(key, fe);
            }
        }

        // If nothing to process
        if (failureEmailsLower.isEmpty()) {
            return Database.getQueryLocator('SELECT Id FROM Contact WHERE Id = null');
        }

        // Query Contacts
        return Database.getQueryLocator([
            SELECT Id, Email
            FROM Contact
            WHERE Email IN :failureEmailsLower
        ]);
    }


    public void execute(Database.BatchableContext bc, List<Contact> scope) {

        if (scope.isEmpty()) return;

        List<Contact> contactsToUpdate = new List<Contact>();
        Map<Id, Failure_Email__c> feUpdates = new Map<Id, Failure_Email__c>();

        for (Contact con : scope) {

            if (String.isBlank(con.Email)) continue;

            String key = con.Email.trim().toLowerCase();
            if (!failureEmailsLower.contains(key)) continue;

            // Null the contact email
            // con.Email = null;
            // contactsToUpdate.add(con);

            // Mark failure email record with Contact
            Failure_Email__c fe = feByEmailLower.get(key);
            if (fe != null && fe.ContactName__c == null) {
                fe.ContactName__c = con.Id;
                feUpdates.put(fe.Id, fe);
            }
        }

        // if (!contactsToUpdate.isEmpty()) update contactsToUpdate;
        if (!feUpdates.isEmpty()) update feUpdates.values();
    }


    public void finish(Database.BatchableContext bc) {
        System.debug('ClearContactEmailBatch finished.');
    }


    // Schedulable logic
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new ClearContactEmailBatch(), 200);
    }
}