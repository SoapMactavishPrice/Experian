public class CaseGroupAttributeHandler {
    
    private static Boolean isRunning = false;
    
    public static void handleCases(List<Case> newList, Map<Id, Case> oldMap) {
        
        if (isRunning) return;
        isRunning = true;
        
        // =========================
        // STEP 1: FILTER RECORDS (FLAG CHANGE ONLY)
        // =========================
        List<Case> validCases = new List<Case>();
        
        for (Case c : newList) {
            
            Case oldRec = oldMap.get(c.Id);
            
            if (
                c.Create_Parent_Record__c == true && oldRec.Create_Parent_Record__c != true &&
                c.Dis_Ern__c != null &&
                c.Status == 'Open' &&
                c.Case_Identifier_Type__c == null
            ) {
                validCases.add(c);
            }
        }
        
        if (validCases.isEmpty()) return;
        
        // =========================
        // STEP 2: GROUP BY ACCOUNT NUMBER
        // =========================
        Map<String, List<Case>> acctMap = new Map<String, List<Case>>();
        
        for (Case c : validCases) {
            if (!acctMap.containsKey(c.Displayed_Account_number__c)) {
                acctMap.put(c.Displayed_Account_number__c, new List<Case>());
            }
            acctMap.get(c.Displayed_Account_number__c).add(c);
        }
        
        // =========================
        // STEP 3: FETCH EXISTING PARENTS
        // =========================
        Map<String, Case> acctToParent = new Map<String, Case>();
        
        for (Case c : [
            SELECT Id, Displayed_Account_number__c, Attribute_Type__c
            FROM Case
            WHERE Case_Identifier_Type__c = 'Account Number'
            //AND CreatedDate = TODAY
            AND Displayed_Account_number__c IN :acctMap.keySet()
        ]) {
            acctToParent.put(c.Displayed_Account_number__c, c);
        }
        
        // =========================
        // STEP 4: CREATE MISSING PARENTS
        // =========================
        List<Case> parentsToInsert = new List<Case>();
        
        for (String acct : acctMap.keySet()) {
            
            if (!acctToParent.containsKey(acct)) {
                
                Case sample = acctMap.get(acct)[0];
                
                parentsToInsert.add(new Case(
                    Status = 'Open',
                    Origin = sample.Origin,
                    Case_Identifier_Type__c = 'Account Number',
                    AccountId = sample.AccountId,
                    Name_of_Consumer__c = sample.Name_of_Consumer__c,
                    Displayed_Account_number__c = sample.Displayed_Account_number__c,
                    Displayed_Bank_Name__c = sample.Displayed_Bank_Name__c,
                    Displayed_Account_Type__c = sample.Displayed_Account_Type__c,
                    Dis_Ern__c = sample.Dis_Ern__c,
                    Account_Level_Status__c = 'Unassigned',
                    OwnerId = sample.OwnerId,
                    Date_of_the_email_received__c = sample.Date_of_the_email_received__c,
                    Account_Date_Reported__c = sample.Account_Date_Reported__c,
                    Forward_to_Bank_Date__c = sample.Forward_to_Bank_Date__c,
                    Contact_Name__c = sample.Contact_Name__c
                ));
            }
        }
        
        if (!parentsToInsert.isEmpty()) {
            insert parentsToInsert;
            
            for (Case p : parentsToInsert) {
                acctToParent.put(p.Displayed_Account_number__c, p);
            }
        }
        
        // =========================
        // STEP 5: CHILD + ATTRIBUTE UPDATE
        // =========================
        List<Case> childUpdates = new List<Case>();
        Map<Id, Case> parentUpdates = new Map<Id, Case>();
        
        for (String acct : acctMap.keySet()) {
            
            Case parent = acctToParent.get(acct);
            
            for (Case c : acctMap.get(acct)) {
                
                // CHILD UPDATE
                c.Parent_Account_Number_Case__c = parent.Id;
                c.Case_Identifier_Type__c = 'Attribute';
                
                childUpdates.add(c);
                
                // ATTRIBUTE UPDATE (ONLY ONCE)
                if (String.isBlank(parent.Attribute_Type__c)) {
                    
                    String value;
                    
                    if (c.Sub_Type_1_Name__c == 'Matching/CI - Account does not belong to me') {
                        value = 'Matching/CI - Account does not belong to me';
                    } else if (c.Sub_Type_1_Name__c == 'Matching/CI - Credit Enquiry does not belong to me') {
                        value = 'Matching/CI - Credit Enquiry does not belong to me';
                    } else if (c.Sub_Type_1_Name__c == 'Account does not belong to me') {
                        value = 'Account does not belong to me';
                    } else if (c.Sub_Type_1_Name__c == 'Credit Enquiry does not belong to me') {
                        value = 'Credit Enquiry does not belong to me';
                    } else if (c.Sub_Type_Name__c == 'Enquiry Changes') {
                        value = 'Enquiry Changes';
                    } else if (c.Sub_Type_Name__c == 'Account not reflecting') {
                        value = 'Account Not Reflecting';
                    } else {
                        value = 'Other';
                    }
                    
                    parentUpdates.put(parent.Id, new Case(
                        Id = parent.Id,
                        Attribute_Type__c = value
                    ));
                }
            }
        }
        
        if (!childUpdates.isEmpty()) {
            update childUpdates;
        }
        
        if (!parentUpdates.isEmpty()) {
            update parentUpdates.values();
        }
    }
}