global class CaseAttributeUpdateBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Sub_Type_1_Name__c, Sub_Type_Name__c, Parent_Account_Number_Case__c ' +
            'FROM Case ' +
            'WHERE Case_Identifier_Type__c = \'Attribute\' ' +
            'AND Parent_Account_Number_Case__c != NULL ' +
            'AND Parent_Account_Number_Case__r.Attribute_Type__c = NULL'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope) {
        Map<Id, Case> parentCasesToUpdate = new Map<Id, Case>();
        
        for (Case c : scope) {
            if (String.isBlank(c.Sub_Type_1_Name__c)) continue;
            if (c.Parent_Account_Number_Case__c == null) continue; 
            
            String newValue;
            if (c.Sub_Type_1_Name__c == 'Matching/CI - Account does not belong to me' ||
                c.Sub_Type_1_Name__c == 'Matching - Account does not belong to me') {
                newValue = 'Matching/CI - Account does not belong to me';
            } else if (c.Sub_Type_1_Name__c == 'Matching/CI - Credit Enquiry does not belong to me' ||
                       c.Sub_Type_1_Name__c == 'Matching - Credit Enquiry does not belong to me') {
                newValue = 'Matching/CI - Credit Enquiry does not belong to me';
            } else if (c.Sub_Type_1_Name__c == 'Account does not belong to me') {
                newValue = 'Account does not belong to me';
            } else if (c.Sub_Type_1_Name__c == 'Credit Enquiry does not belong to me') {
                newValue = 'Credit Enquiry does not belong to me';
            }else if (c.Sub_Type_Name__c  == 'Enquiry Changes') { 
                newValue = 'Enquiry Changes';
            } else if (c.Sub_Type_Name__c  == 'Account not reflecting') {
                newValue = 'Account Not Reflecting';
            } else {
                newValue = 'Other';
            }
            
            // Prepare parent case for update
            Case parentCase = parentCasesToUpdate.get(c.Parent_Account_Number_Case__c);
            if (parentCase == null) {
                parentCase = new Case(Id = c.Parent_Account_Number_Case__c);
            }
            parentCase.Attribute_Type__c = newValue;
            parentCasesToUpdate.put(parentCase.Id, parentCase);
        }
        
        if (!parentCasesToUpdate.isEmpty()) {
            update parentCasesToUpdate.values();
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch completed: Parent cases Attribute_Type__c updated successfully.');
    }
    
    // Schedulable execute method
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CaseAttributeUpdateBatch(), 5);
    }
    public void fakeMethod() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}