trigger OneXPCaseTrigger on Case (after insert, after update) {
        
    //Create Missing Parent Record and Atttribute tagging
    //if (Trigger.isAfter && Trigger.isUpdate) {
        //CaseGroupAttributeHandler.handleCases(Trigger.new, Trigger.oldMap);
    //}
    
    
    // Update Parent Case - Pending With Experian
    if(Trigger.isAfter && Trigger.isUpdate){
        ParentStatusHandler.updateParentStatus(Trigger.new, Trigger.oldMap);
    }
    
    // Update ECICI Remarks
    if(Trigger.isAfter && Trigger.isUpdate){
        OneXPCaseTriggerHandler.updateECICIRemarks(Trigger.new, Trigger.oldMap);
    }
    
    // Dispute Lifecycle record creation for various types
    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            DisputeLifecycleService.handleInsert(Trigger.new);
        }
        
        if(Trigger.isUpdate){
            DisputeLifecycleService.handleUpdate(Trigger.new, Trigger.oldMap);
        }
    }
    
    // Condition 1: Forward_to_Bank_Date__c update and Condition 2: Dispute_Raised_Date__c update
    if(Trigger.isAfter && Trigger.isUpdate){
        OneXPCaseTriggerHandler.syncParentDates(Trigger.new, Trigger.oldMap);
    }
    
    //ParentCaseResolution
    if(Trigger.isAfter && Trigger.isUpdate){
        
        Set<Id> parentCaseIds = new Set<Id>();
       
        for (Case c : Trigger.new) {
            Case oldC = Trigger.oldMap.get(c.Id);
            if (c.Case_Identifier_Type__c == 'Attribute' && c.Status == 'Resolved' && oldC.Status != 'Resolved' && 
                c.Parent_Account_Number_Case__c != null) {
                    parentCaseIds.add(c.Parent_Account_Number_Case__c);
                }
        }
        
        if (!parentCaseIds.isEmpty()) {
            System.enqueueJob(new ParentCaseResolutionJob(parentCaseIds));
        }
    }
    
    //Refer to IO 
    if(Trigger.isAfter && Trigger.isUpdate){
        
        Set<Id> caseIdsToProcess = new Set<Id>();

        for (Case c : Trigger.new) {
    
            Case oldCase = Trigger.oldMap.get(c.Id);
            System.debug('Refer to IO Cases to process '+c.Id);
    
            Boolean condition1 =
                c.Maker_Status__c == 'Reject' &&
                c.Maker_Sub_Status__c == 'Fully Rejected' &&
                c.Checker_Status__c == 'Accept' &&
                (oldCase.Checker_Status__c == null || oldCase.Checker_Status__c != 'Accept');
    
            Boolean condition2 =
                c.Maker_Status__c == 'Accept' &&
                c.Maker_Sub_Status__c == 'Partially Accepted' &&
                c.Checker_Status__c == 'Accept' &&
                (oldCase.Checker_Status__c == null || oldCase.Checker_Status__c != 'Accept');
    
            if (condition1 || condition2) {
                caseIdsToProcess.add(c.Id);
            }
        }
    
        if (!caseIdsToProcess.isEmpty()) {
            OneXPCaseTriggerHandler.processReferToIOAsync(caseIdsToProcess);
        }
    }
    
    //Forward to Bank Dispute Lifecycle
    if (Trigger.isAfter && Trigger.isUpdate) {
        CaseTATHandler.createOrUpdateTAT(Trigger.new, Trigger.oldMap);
    }
    
}