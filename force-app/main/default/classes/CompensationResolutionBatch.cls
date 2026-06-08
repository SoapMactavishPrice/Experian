global class CompensationResolutionBatch implements Database.Batchable<SObject>, Schedulable {
    
    // 🔹 START
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id
            FROM Compensation__c
            WHERE CreatedDate < TODAY
            AND Resolved_Date__c = NULL
        ]);
    }
    
    // 🔹 EXECUTE
    global void execute(Database.BatchableContext bc, List<Compensation__c> scope) {
        
        Set<Id> compIds = new Set<Id>();
        for (Compensation__c comp : scope) {
            compIds.add(comp.Id);
        }
        
        Map<Id, List<Case>> compToCasesMap = new Map<Id, List<Case>>();
        
        for (Case c : [
            SELECT Id, Status, Resolve_Date__c, Compensation__c
            FROM Case
            WHERE Case_Identifier_Type__c = 'Account Number' AND Compensation__c IN :compIds
        ]) {
            if (!compToCasesMap.containsKey(c.Compensation__c)) {
                compToCasesMap.put(c.Compensation__c, new List<Case>());
            }
            compToCasesMap.get(c.Compensation__c).add(c);
        }
        
        List<Compensation__c> updateList = new List<Compensation__c>();
        
        for (Compensation__c comp : scope) {
            
            List<Case> childCases = compToCasesMap.get(comp.Id);
            
            if (childCases == null || childCases.isEmpty()) {
                continue;
            }
            
            Boolean allResolved = true;
            Date maxResolveDate;
            
            for (Case c : childCases) {
                
                if (c.Status != 'Resolved') {
                    allResolved = false;
                    break;
                }
                
                if (c.Resolve_Date__c != null) {
                    if (maxResolveDate == null || c.Resolve_Date__c > maxResolveDate) {
                        maxResolveDate = c.Resolve_Date__c;
                    }
                }
            }
            
            if (allResolved && maxResolveDate != null) {
                updateList.add(new Compensation__c(
                    Id = comp.Id,
                    Resolved_Date__c = maxResolveDate
                ));
            }
        }
        
        if (!updateList.isEmpty()) {
            update updateList;
        }
    }
    
    // 🔹 FINISH
    global void finish(Database.BatchableContext bc) {
        // Optional logging
    }
    
    // 🔹 SCHEDULER ENTRY POINT
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CompensationResolutionBatch(), 5);
    }
}