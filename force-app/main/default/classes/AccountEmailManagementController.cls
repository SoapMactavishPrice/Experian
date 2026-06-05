public with sharing class AccountEmailManagementController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts(String searchKey) {
        String key = '%' + searchKey + '%';

        return [
            Select Id, Name, Phone, Email_1_Dispute__c, Bureau_Member_Id__c,

            DA_Level_1_Email_1__c, DA_Level_1_Email_2__c, DA_Level_1_Email_3__c, 
            DA_Level_1_Email_4__c, DA_Level_1_Email_5__c, DA_Level_1_Email_6__c, 
            DA_Level_1_Email_7__c, DA_Level_1_Email_8__c, DA_Level_1_Email_9__c, 
            DA_Level_1_Email_10__c,

            DA_Level_2_Email_1__c, DA_Level_2_Email_2__c, DA_Level_2_Email_3__c, 
            DA_Level_2_Email_4__c, DA_Level_2_Email_5__c, DA_Level_2_Email_6__c, 
            DA_Level_2_Email_7__c, DA_Level_2_Email_8__c, DA_Level_2_Email_9__c, 
            DA_Level_2_Email_10__c,

            DA_Level_3_Email_1__c, DA_Level_3_Email_2__c, DA_Level_3_Email_3__c, 
            DA_Level_3_Email_4__c, DA_Level_3_Email_5__c, DA_Level_3_Email_6__c, 
            DA_Level_3_Email_7__c, DA_Level_3_Email_8__c, DA_Level_3_Email_9__c, 
            DA_Level_3_Email_10__c

            FROM Account
            WHERE Name LIKE :key
            ORDER BY Name
        ];
    }

    @AuraEnabled
    public static void updateAccount(Account accInput) {
        update accInput;
    }

    @AuraEnabled
    public static void updateAccountsFromCSV(String csvString) {

        List<String> lines = csvString.split('\n');
        if (lines.size() <= 1) return;

        // Header columns
        List<String> headers = lines[0].split(',');

        Map<Id, Account> updates = new Map<Id, Account>();

        for (Integer i = 1; i < lines.size(); i++) {
            if (String.isBlank(lines[i])) continue;

            List<String> cols = lines[i].split(',');

            Id accId = (Id) cols[1];   // Column 2 = AccountId
            Account acc = new Account(Id = accId);

            // LOOP THROUGH ALL COLUMNS
            for (Integer c = 0; c < headers.size(); c++) {
                String header = headers[c].trim();

                // Skip Name, AccountId, BMID
                if (header == 'Account Name' || header == 'Account ID' || header == 'BMID') continue;

                if (header.startsWith('DA_Level')) {
                    acc.put(header, cols[c]);
                }
            }

            updates.put(accId, acc);
        }

        if (!updates.isEmpty()) {
            update updates.values();
        }
    }

}