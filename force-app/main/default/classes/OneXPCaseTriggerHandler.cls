public class OneXPCaseTriggerHandler {
    
    public static Boolean throwTestException = false;
    
    public static void updateECICIRemarks(List<Case> newList, Map<Id, Case> oldMap) {
        Set<Id> caseIdsToProcess = new Set<Id>();   
        for (Case c : newList) {
            Case oldRec = oldMap.get(c.Id);
            if (c.Referred_To_IO_Case__c == true &&
                oldRec.Referred_To_IO_Case__c == false) {
                    caseIdsToProcess.add(c.Id);
                }
        }
        if (!caseIdsToProcess.isEmpty()) {
            updateECICIRemarksAsync(caseIdsToProcess);
        }
    }
    
    
    public static void updateECICIRemarksAsync(Set<Id> caseIds) {
                
        List<Case> casesToUpdate = [
            SELECT Id,
            Dispute_Rejected_Reason__c,
            Sub_Type_1_Lookup__r.ECICI_Remarks__c,
            Sub_Type_1_Lookup__r.ECICI_Remarks_2__c
            FROM Case
            WHERE Id IN :caseIds
        ];
        
        List<Case> updateList = new List<Case>();
        
        for (Case c : casesToUpdate) {
                
                List<String> parts = new List<String>();
                
                if (c.Sub_Type_1_Lookup__r != null &&
                    String.isNotBlank(c.Sub_Type_1_Lookup__r.ECICI_Remarks__c)) {
                        parts.add(c.Sub_Type_1_Lookup__r.ECICI_Remarks__c);
                    }
                
                if (String.isNotBlank(c.Dispute_Rejected_Reason__c)) {
                    parts.add(c.Dispute_Rejected_Reason__c);
                }
                
                if (c.Sub_Type_1_Lookup__r != null &&
                    String.isNotBlank(c.Sub_Type_1_Lookup__r.ECICI_Remarks_2__c)) {
                        parts.add(c.Sub_Type_1_Lookup__r.ECICI_Remarks_2__c);
                    }
                
                String finalRemark = String.join(parts, ', ');
                
                updateList.add(new Case(
                    Id = c.Id,
                    ECICI_Remarks__c = finalRemark
                ));
        }
        try{
            if (!updateList.isEmpty()) {
                update updateList;
            }
            if (Test.isRunningTest() && throwTestException) {
                throw new AuraHandledException('Forced Exception');
            }
            
        }catch (Exception err) {
        
            List<Automation_Logs__c> apiLogList = new List<Automation_Logs__c>();
            
            for (Case c : updateList) {
                
                apiLogList.add(new Automation_Logs__c(
                    Batch_Class_Name__c = 'OneXPCaseTrigger',
                    Automation_Log_Description__c =
                        'OneXPCaseTriggerHandler - Step: ECICI Remarks Update',
                    Case__c = c.Id,
                    Error_Message__c = err.getMessage()
                ));
            }
            
            if (!apiLogList.isEmpty()) {
                insert apiLogList;
            }
        }
    }   
    
    @future
    public static void processReferToIOAsync(Set<Id> caseIds) {
        
        List<Case> cases = [
            SELECT Id, Status,
            Rejection_Reason_with_Sub_Type__c
            FROM Case
            WHERE Id IN :caseIds
        ];
        
        List<Case> casesToUpdate = new List<Case>();
        
        for (Case c : cases) {
            if (c.Status == 'Open'){
                Case cUpdate = new Case(Id = c.Id);
                cUpdate.Referred_To_IO_Case__c = true;
                cUpdate.Dispute_Rejected_Reason__c = c.Rejection_Reason_with_Sub_Type__c;
                cUpdate.Rejection_Reason__c = 'Rejected by Lender';
                cUpdate.Account_Level_Status__c = 'Pending With Experian';
                cUpdate.Last_Reply_from_Bank_Team__c = System.today();
                System.debug('processReferToIOAsync '+ c.Id);
                casesToUpdate.add(cUpdate);
            }
            else{
                Case cUpdate = new Case(Id = c.Id);
                cUpdate.Account_Level_Status__c = 'Pending With Experian';
                casesToUpdate.add(cUpdate);
            }   
        }

        try {
        
            if (!casesToUpdate.isEmpty()) {
                update casesToUpdate;
            }
            
        } catch (Exception err) {
            
            List<Automation_Logs__c> apiLogList = new List<Automation_Logs__c>();
            
            for (Case c : casesToUpdate) {     
                apiLogList.add(new Automation_Logs__c(
                    Batch_Class_Name__c = 'OneXPCaseTrigger',
                    Automation_Log_Description__c =
                        'OneXPCaseTrigger - Step: processReferToIOAsync Update',
                    Case__c = c.Id,
                    Error_Message__c = err.getMessage()
                ));
            }
            
            if (!apiLogList.isEmpty()) {
                insert apiLogList;
            }
        }
    }

    public static void syncParentDates( List<Case> newList, Map<Id, Case> oldMap) {
        
        Map<Id, Date> parentForwardToBankMap = new Map<Id, Date>();
        
        Map<Id, Date> parentDisputeDateMap = new Map<Id, Date>();
        
        // Collect Parent Updates
        for (Case c : newList) {
            
            Case oldCase = oldMap.get(c.Id);
            
            if (c.Case_Identifier_Type__c == 'Attribute' && c.Parent_Account_Number_Case__c != null) {
                
                // Forward_to_Bank_Date__c
                if (c.Forward_to_Bank_Date__c != oldCase.Forward_to_Bank_Date__c) {
                    parentForwardToBankMap.put( c.Parent_Account_Number_Case__c, c.Forward_to_Bank_Date__c);
                }
                
                // Dispute_Raised_Date__c
                if (c.Dispute_Raised_Date__c != oldCase.Dispute_Raised_Date__c) {    
                    parentDisputeDateMap.put( c.Parent_Account_Number_Case__c, c.Dispute_Raised_Date__c);
                }
            }
        }
        
        Set<Id> parentIds = new Set<Id>();
        
        parentIds.addAll(parentForwardToBankMap.keySet());
        parentIds.addAll(parentDisputeDateMap.keySet());
        
        if (parentIds.isEmpty()) {
            return;
        }
        
        List<Case> parentCasesToUpdate = [
            SELECT Id, Forward_to_Bank_Date__c, Dispute_Raised_Date__c FROM Case
            WHERE Id IN :parentIds
        ];
        
        for (Case parent : parentCasesToUpdate) {
            
            if (parentForwardToBankMap.containsKey(parent.Id)) {
                parent.Forward_to_Bank_Date__c = parentForwardToBankMap.get(parent.Id);
            }
            
            if (parentDisputeDateMap.containsKey(parent.Id)) {
                parent.Dispute_Raised_Date__c = parentDisputeDateMap.get(parent.Id);
            }
        }
        
        // DML + AUTOMATION LOGS
        try {
            
            if (!parentCasesToUpdate.isEmpty()) {
                update parentCasesToUpdate;
            }
            
        } catch (Exception err) {
            
            List<Automation_Logs__c> apiLogList = new List<Automation_Logs__c>();
            
            for (Case c : parentCasesToUpdate) {
                
                apiLogList.add(new Automation_Logs__c(
                    Batch_Class_Name__c = 'OneXPCaseTrigger',
                    Automation_Log_Description__c = 'OneXPCaseTriggerHandler - Step: Parent Date Sync Update',
                    Case__c = c.Id,
                    Error_Message__c = err.getMessage()
                ));
            }
            
            if (!apiLogList.isEmpty()) {
                insert apiLogList;
            }
        }
    }
}