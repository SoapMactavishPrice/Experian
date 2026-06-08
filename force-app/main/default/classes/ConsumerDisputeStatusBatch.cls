global class ConsumerDisputeStatusBatch implements Database.Batchable<SObject>, Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        return Database.getQueryLocator([
            SELECT Id,
                   Maker_Sub_Status_Date_Time__c,
                   Consumer_Dispute_Status__c,
                   Account_Level_Status__c,
                   Status,
                   Parent_Account_Number_Case__r.Account_Level_Status__c,
                   Maker_Status__c,
                   Maker_Sub_Status__c,
                   Checker_Status__c,
                   stgOneHitId__c,
                   Credit_Report_Link__c
            FROM Case
            WHERE Maker_Status__c = 'Accept'
            AND Status = 'Open'
            AND Maker_Sub_Status__c = 'Fully Accepted'
            AND Checker_Status__c = 'Accept'
            AND Maker_Sub_Status_Date_Time__c != NULL
            AND Account_Level_Status__c = 'Processing Passed'
            AND Parent_Account_Number_Case__r.Account_Level_Status__c = 'Processing Passed'
            AND Consumer_Dispute_Status__c = 'Acknowledgement sent to Consumer'
        ]);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope) {
        
        List<Case> casesToUpdate = new List<Case>();
        Map<Id,String> mpCaseIds = new Map<Id,String>();
        Set<Id> cirApiCaseIds = new Set<Id>();
        
        Decimal thresholdHours = Decimal.valueOf(System.Label.Maker_Sub_Status_Threshold_Hours);
        Decimal cirThresholdHours = Decimal.valueOf(System.Label.getCIRreportinHrs);
        
        for (Case c : scope) {
            
            Decimal hoursDiff =
                (System.now().getTime() -
                c.Maker_Sub_Status_Date_Time__c.getTime())
                / (1000 * 60 * 60);
            
            /*
             * STEP 1
             * After 1 hour call API
             */
            if (
                hoursDiff >= thresholdHours &&
                c.stgOneHitId__c == null
            ) {
                cirApiCaseIds.add(c.Id);
                mpCaseIds.put(
                    c.Id,
                    c.Consumer_Dispute_Status__c
                );
            }
            
            /*
             * STEP 2
             * After 1.25 hours update status
             * only if API response received
             */
            if (
                hoursDiff >= cirThresholdHours &&
                c.stgOneHitId__c != null &&
                c.Credit_Report_Link__c != null
            ) {
                
                Case cUpdate = new Case(
                    Id = c.Id
                );
                
                cUpdate.Consumer_Dispute_Status__c =  'Resolved in favour of the Consumer';
                cUpdate.Account_Level_Status__c = 'Pending With Experian';
                cUpdate.Last_Reply_from_Bank_Team__c = System.today();
                casesToUpdate.add(cUpdate);
            }
        }
        
        /*
         * Update Cases
         */
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
        
        /*
         * STEP 1 Queueable
         * Call CIR API
         */
        if (!cirApiCaseIds.isEmpty()) {
            
            System.enqueueJob(
                new IntegrationHandlerQueueable(
                    cirApiCaseIds,
                    mpCaseIds
                )
            );
        }
    }
    
    global void finish(Database.BatchableContext bc) {}
    
    global void execute(SchedulableContext sc) {
        
        Database.executeBatch(
            new ConsumerDisputeStatusBatch(),
            1
        );
    }
}