trigger ContactTrigger on Contact (after insert, after update) {
    
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Collect Email + Phone keys from new/updated Contacts
        Map<String, Contact> newContactsMap = new Map<String, Contact>();
        for (Contact con : Trigger.new) {
            if (!String.isBlank(con.Email) && !String.isBlank(con.Phone)) {
                String key = con.Email.trim().toLowerCase() + '|' + con.Phone.trim();
                newContactsMap.put(key, con);
            }
        }
        
        if (newContactsMap.isEmpty()) return;
        
        // Collect all email and phone values to search existing contacts
        Set<String> emails = new Set<String>();
        Set<String> phones = new Set<String>();
        for (String key : newContactsMap.keySet()) {
            List<String> parts = key.split('\\|');
            emails.add(parts[0]);
            phones.add(parts[1]);
        }
        
        // Query existing Contacts matching any of these Email and Phone combinations
        List<Contact> existingContacts = [
            SELECT Id, AccountId, Email, Phone
            FROM Contact
            WHERE Email IN :emails
            AND Phone IN :phones
            AND Id NOT IN :Trigger.newMap.keySet()
        ];
        
        // Build a lookup map: key = email|phone, value = set of account IDs
        Map<String, Set<Id>> comboToAccountMap = new Map<String, Set<Id>>();
        for (Contact existing : existingContacts) {
            String key = existing.Email.trim().toLowerCase() + '|' + existing.Phone.trim();
            if (!comboToAccountMap.containsKey(key)) {
                comboToAccountMap.put(key, new Set<Id>());
            }
            comboToAccountMap.get(key).add(existing.AccountId);
        }
        
        // Validate new or updated Contacts
        for (Contact con : Trigger.new) {
            if (!String.isBlank(con.Email) && !String.isBlank(con.Phone)) {
                String key = con.Email.trim().toLowerCase() + '|' + con.Phone.trim();
                
                if (comboToAccountMap.containsKey(key)) {
                    Set<Id> accountIds = comboToAccountMap.get(key);
                    if (!accountIds.contains(con.AccountId)) {
                        con.addError('A contact with the same Email and Phone already exists under another Account.');
                    }
                }
            }
        }
    }
    
    if (Trigger.isAfter && (Trigger.isInsert)){
        
        // Collect AccountIds for Contacts with non-empty Member_Role__c
        Set<Id> accountIds = new Set<Id>();
        for (Contact con : Trigger.new) {
            if (con.Member_Role__c != null && con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
        
        if (accountIds.isEmpty()) return;
        
        // Query Accounts to get Bureau_Member_Id__c
        Map<Id, String> accountToBMID = new Map<Id, String>();
        for (Account acc : [
            SELECT Id, Bureau_Member_Id__c
            FROM Account
            WHERE Id IN :accountIds
        ]) {
            if (!String.isBlank(acc.Bureau_Member_Id__c)) {
                accountToBMID.put(acc.Id, acc.Bureau_Member_Id__c.trim());
            }
        }
        
        // Prepare list for update
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for (Contact con : Trigger.new) {
            if (con.Member_Role__c != null && con.AccountId != null && accountToBMID.containsKey(con.AccountId)) {
                
                String bmid = accountToBMID.get(con.AccountId);
                String firstNamePart = con.FirstName != null ? con.FirstName.trim().left(20) : '';
                String lastNamePart = con.LastName != null ? con.LastName.trim().left(20) : '';
                
                String herokuUsername = bmid + '_' + firstNamePart + lastNamePart;
                
                // Only update if field is blank or needs initialization
                if (String.isBlank(con.Heroku_Username__c)) {
                    Contact cUpdate = new Contact(Id = con.Id);
                    cUpdate.Heroku_Username__c = herokuUsername;
                    contactsToUpdate.add(cUpdate);
                }
            }
        }
        
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }      
    }
}