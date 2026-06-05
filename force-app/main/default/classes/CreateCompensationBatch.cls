public class CreateCompensationBatch implements Database.Batchable<SObject>, Schedulable {
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new CreateCompensationBatch(), 5);
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, Contact_Name__c, Displayed_Account_number__c, 
            Date_of_the_email_received__c, Dis_Ern__c,
            Name_of_Consumer__c, CreatedDate
            FROM Case
            //WHERE CreatedDate = YESTERDAY
            WHERE CreatedDate >= LAST_N_DAYS:23
            AND CreatedDate < TODAY
            AND Contact_Name__c != NULL
            AND Dis_Ern__c != NULL
            AND Displayed_Account_number__c != NULL
            AND Date_of_the_email_received__c != NULL
            AND Name_of_Consumer__c != NULL
            AND Case_Identifier_Type__c = 'Attribute'
            ORDER by CreatedDate asc
        ]);
    }
    
    public void execute(Database.BatchableContext bc, List<Case> scope) {
        
        Set<String> uniqueKeys = new Set<String>();
        Set<String> accountNumbers = new Set<String>();
        
        Map<String, Case> keyToCaseMap = new Map<String, Case>();
        
        // Step 1: Prepare keys
        for (Case c : scope) {
            String formattedDate = c.Date_of_the_email_received__c.format();
            String key = c.Contact_Name__c + ' - ' + formattedDate;
            
            uniqueKeys.add(key);
            accountNumbers.add(c.Displayed_Account_number__c);
            keyToCaseMap.put(key, c);
        }
        
        // Step 2: Existing compensation check (today)
        Map<String, Compensation__c> existingMap = new Map<String, Compensation__c>();
        
        for (Compensation__c comp : [
            SELECT Id, Unique_Key__c
            FROM Compensation__c
            WHERE Unique_Key__c IN :uniqueKeys
            //AND CreatedDate = TODAY
        ]) {
            existingMap.put(comp.Unique_Key__c, comp);
        }
        
        // Step 3: Create new Compensation
        List<Compensation__c> toInsert = new List<Compensation__c>();
        
        for (String key : uniqueKeys) {
            if (!existingMap.containsKey(key)) {
                Case c = keyToCaseMap.get(key);
                
                Compensation__c comp = new Compensation__c();
                comp.Name = key;
                comp.Unique_Key__c = key;
                comp.Name_of_Consumer__c = c.Name_of_Consumer__c;
                comp.Dispute_Received_Date__c = c.Date_of_the_email_received__c;
                toInsert.add(comp);
            }
        }
        
        if (!toInsert.isEmpty()) {
            //insert toInsert;
           
            Database.SaveResult[] results = Database.insert(toInsert, false);
            
            for (Database.SaveResult sr : results) {
                if (!sr.isSuccess()) {
                    for (Database.Error err : sr.getErrors()) {
                        if (err.getStatusCode() == StatusCode.DUPLICATE_VALUE) {
                            System.debug('Duplicate avoided: ' + err.getMessage());
                        } else {
                            System.debug('Other error: ' + err.getMessage());
                        }
                    }
                }
            }
            
            // Add newly inserted to map
            for (Compensation__c c : toInsert) {
                existingMap.put(c.Unique_Key__c, c);
            }
        }
        
        // Step 4: Fetch Parent Cases (Account Number type)
        Map<String, Case> accountToParentCase = new Map<String, Case>();
        
        for (Case parent : [
            SELECT Id, Displayed_Account_number__c, Compensation__c
            FROM Case
            WHERE Case_Identifier_Type__c = 'Account Number'
            AND CreatedDate = YESTERDAY
            AND Displayed_Account_number__c IN :accountNumbers
        ]) {
            accountToParentCase.put(parent.Displayed_Account_number__c, parent);
        }
        
        // Step 5: Update Parent Cases
        Map<Id, Case> parentUpdateMap = new Map<Id, Case>();
        
        for (String key : keyToCaseMap.keySet()) {
            Case child = keyToCaseMap.get(key);
            
            if (accountToParentCase.containsKey(child.Displayed_Account_number__c)
                && existingMap.containsKey(key)) {
                    
                    Case parent = accountToParentCase.get(child.Displayed_Account_number__c);
                    
                    // ✅ SAFETY CHECK - do not overwrite existing compensation
                    if (parent.Compensation__c == null) {
                        parent.Compensation__c = existingMap.get(key).Id;
                        parentUpdateMap.put(parent.Id, parent);
                    }
                }
        }
        
        if (!parentUpdateMap.isEmpty()) {
            update parentUpdateMap.values();
        }
    }
    
    public void finish(Database.BatchableContext bc) {}
}