global class GetStgOneHitID implements Database.Batchable<SObject>, Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator([
            SELECT id, CaseNumber, Origin, Date_of_the_email_received__c, Consumer_Dispute_Status__c, Last_Reply_from_Bank_Team__c,
            stgOneHitId__c, Case_Type_Name__c, Resolved_Consumer_Email_Sent__c 
            FROM Case 
            WHERE Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer' 
            AND stgOneHitId__c = NULL
            AND Resolved_Consumer_Email_Sent__c = FALSE AND Status = 'Open' AND Case_Type_Name__c = 'Complaint Dispute Consumer' 
            AND Date_of_the_email_received__c > 2024-04-26 
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope) {
        
        Map<Id,String> mpCaseIds = new Map<Id,String>();
        Set<Id> cirApiCaseIds = new Set<Id>();
        
        for (Case c : scope) {
            
            if(c.stgOneHitId__c == null) {
                cirApiCaseIds.add(c.Id);
                mpCaseIds.put(c.Id, c.Consumer_Dispute_Status__c);
            }            
        }
        
        if (!cirApiCaseIds.isEmpty()) {
            
            System.enqueueJob( new IntegrationHandlerQueueable( cirApiCaseIds,mpCaseIds));
        }
    }
    
    global void finish(Database.BatchableContext bc) {}
    
    global void execute(SchedulableContext sc) {
        
        Database.executeBatch( new GetStgOneHitID(),1);
    }
}