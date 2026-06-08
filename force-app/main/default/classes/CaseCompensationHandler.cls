public class CaseCompensationHandler {
    
    public static void handleCompensation(List<Case> newList, Map<Id, Case> oldMap) {
        
        Map<String, List<Case>> keyToCasesMap = new Map<String, List<Case>>();
        Set<String> uniqueKeys = new Set<String>();
        
        // =========================
        // STEP 1: FILTER VALID CASES
        // =========================
        for (Case c : newList) {
            
            Case oldC = oldMap.get(c.Id);
            
            if (
                c.Case_Identifier_Type__c == 'Attribute' &&
                c.Status == 'Resolved' &&
                oldC.Status != 'Resolved' &&
                c.Parent_Account_Number_Case__c != null &&
                c.Resolve_Date__c != null &&
                c.Date_of_the_email_received__c != null
            ) {
                
                Integer days = c.Date_of_the_email_received__c.daysBetween(c.Resolve_Date__c);
                
                if (days > 30) {
                    
                    String key = c.Contact_Name__c + ' - ' + c.Date_of_the_email_received__c.format();//Dis_Ern__c
                    
                    uniqueKeys.add(key);
                    
                    if (!keyToCasesMap.containsKey(key)) {
                        keyToCasesMap.put(key, new List<Case>());
                    }
                    keyToCasesMap.get(key).add(c);
                }
            }
        }
        
        if (uniqueKeys.isEmpty()) return;
        
        // =========================
        // STEP 2: FETCH EXISTING COMPENSATION
        // =========================
        Map<String, Compensation__c> compMap = new Map<String, Compensation__c>();
        
        for (Compensation__c comp : [
            SELECT Id, Unique_Key__c
            FROM Compensation__c
            WHERE Unique_Key__c IN :uniqueKeys
        ]) {
            compMap.put(comp.Unique_Key__c, comp);
        }
        
        // =========================
        // STEP 3: CREATE MISSING COMPENSATION
        // =========================
        List<Compensation__c> toInsert = new List<Compensation__c>();
        
        for (String key : uniqueKeys) {
            
            if (!compMap.containsKey(key)) {
                
                Case sample = keyToCasesMap.get(key)[0];
                
                Compensation__c comp = new Compensation__c();
                comp.Name = key;
                comp.Unique_Key__c = key;
                comp.Name_of_Consumer__c = sample.Name_of_Consumer__c;
                comp.Dispute_Received_Date__c = sample.Date_of_the_email_received__c;
                toInsert.add(comp);
            }
        }
        
        if (!toInsert.isEmpty()) {
            insert toInsert;
            
            for (Compensation__c c : toInsert) {
                compMap.put(c.Unique_Key__c, c);
            }
        }
        
        // =========================
        // STEP 4: LINK PARENT CASE → COMPENSATION
        // =========================
        Map<Id, Case> parentUpdatesMap = new Map<Id, Case>();
        
        for (String key : keyToCasesMap.keySet()) {
            
            Id compId = compMap.get(key).Id;
            
            for (Case child : keyToCasesMap.get(key)) {
                
                Id parentId = child.Parent_Account_Number_Case__c;
                
                if (parentId != null && !parentUpdatesMap.containsKey(parentId)) {
                    
                    parentUpdatesMap.put(parentId, new Case(
                        Id = parentId,
                        Compensation__c = compId
                    ));
                }
            }
        }
        
        if (!parentUpdatesMap.isEmpty()) {
            update parentUpdatesMap.values();
        }
    }
}