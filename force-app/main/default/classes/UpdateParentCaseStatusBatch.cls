global class UpdateParentCaseStatusBatch implements Database.Batchable<SObject>, Schedulable {
    
    // START METHOD
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator([
            SELECT Id,
            Account_Level_Status__c,
            Account.Name
            FROM Case
            WHERE Case_Identifier_Type__c = 'Account Number'
            AND Account_Level_Status__c = 'With Checker'
        ]);
    }
    
    // EXECUTE METHOD - BATCH
    global void execute(Database.BatchableContext bc, List<Case> scope) {
        
        // Store Parent Case Ids
        Set<Id> parentCaseIds = new Set<Id>();
        
        for (Case parentCase : scope) {
            parentCaseIds.add(parentCase.Id);
        }
        
        // Fetch Child Cases
        List<Case> childCases = [
            SELECT Id,
            Parent_Account_Number_Case__c,
            Account_Level_Status__c
            FROM Case
            WHERE Parent_Account_Number_Case__c IN :parentCaseIds
            AND Case_Identifier_Type__c = 'Attribute'
        ];
        
        // Parent -> Child Map
        Map<Id, List<Case>> parentToChildrenMap = new Map<Id, List<Case>>();
        
        for (Case child : childCases) {
            
            if (!parentToChildrenMap.containsKey(child.Parent_Account_Number_Case__c)) {
                
                parentToChildrenMap.put(
                    child.Parent_Account_Number_Case__c,
                    new List<Case>()
                );
            }
            
            parentToChildrenMap.get(child.Parent_Account_Number_Case__c).add(child);
        }
        
        // Parent Cases to Update
        List<Case> parentCasesToUpdate = new List<Case>();
        
        for (Case parentCase : scope) {
            
            Boolean allChildrenPending = true;
            
            List<Case> children = parentToChildrenMap.get(parentCase.Id);
            
            // Skip if no child records found
            if (children == null || children.isEmpty()) {
                continue;
            }
            
            // Validate all child statuses
            for (Case child : children) {
                
                if (child.Account_Level_Status__c != 'Pending With Experian') {
                    
                    allChildrenPending = false;
                    break;
                }
            }
            
            // Update Parent Status
            if (allChildrenPending) {
                
                parentCase.Account_Level_Status__c = 'Pending With Experian';
                parentCasesToUpdate.add(parentCase);
            }
        }
        
        // Update Records
        if (!parentCasesToUpdate.isEmpty()) {
            
            update parentCasesToUpdate;
            
            System.debug('Updated Parent Cases Count: ' + parentCasesToUpdate.size());
        }
    }
    
    // FINISH METHOD
    global void finish(Database.BatchableContext bc) {
        
        System.debug('Batch Execution Completed');
    }
    
    // SCHEDULABLE METHOD
    global void execute(SchedulableContext sc) {
        
        Database.executeBatch(new UpdateParentCaseStatusBatch(), 1);
    }
}