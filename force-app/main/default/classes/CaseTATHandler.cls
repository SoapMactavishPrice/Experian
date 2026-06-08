public class CaseTATHandler {

    public static Boolean throwTestException = false;
    
    public static void createOrUpdateTAT(List<Case> newList, Map<Id, Case> oldMap) {
        
        List<Dispute_Lifecycle__c> tatToInsert = new List<Dispute_Lifecycle__c>();
        List<Dispute_Lifecycle__c> tatToUpdate = new List<Dispute_Lifecycle__c>();
        
        // Collect Case Ids
        Set<Id> caseIds = new Set<Id>();
        for (Case c : newList) {
            caseIds.add(c.Id);
        }
        
        // Fetch ONLY Seq_No__c = 1 (Forward to Bank record)
        Map<Id, Dispute_Lifecycle__c> tatMap = new Map<Id, Dispute_Lifecycle__c>();
        for (Dispute_Lifecycle__c tat : [
            SELECT Id, Case__c, Actioned_Date__c, Last_Reply_Date__c, Seq_No__c
            FROM Dispute_Lifecycle__c
            WHERE Case__c IN :caseIds
            AND Seq_No__c = 1
        ]) {
            tatMap.put(tat.Case__c, tat);
        }
        
        for (Case c : newList) {
            Case oldCase = oldMap.get(c.Id);
            
            // ---------------------------------------------------------
            // 1️⃣ CREATE RECORD (Forward to Bank)
            // ---------------------------------------------------------
            if (oldCase.Forward_to_Bank_Date__c == null && c.Forward_to_Bank_Date__c != null) {
                    
                    // Prevent duplicate creation
                    if (!tatMap.containsKey(c.Id)) {
                        
                        Dispute_Lifecycle__c tat = new Dispute_Lifecycle__c();
                        tat.Case__c = c.Id;
                        tat.Actioned_Date__c = Date.today();
                        tat.Type__c = 'Forward to Bank';
                        tat.Actioned_By_User__c = UserInfo.getUserId();
                        tat.Actioned_By_Type__c = 'User';
                        tat.Seq_No__c = 1;
                        
                        tatToInsert.add(tat);
                    }
                }
            
            // ---------------------------------------------------------
            // 2️⃣ UPDATE LAST REPLY DATE (ONLY FIRST TIME)
            // ---------------------------------------------------------
            Boolean replyChanged = oldCase.Last_Reply_from_Bank_Team__c != c.Last_Reply_from_Bank_Team__c;
            
            if (replyChanged && c.Last_Reply_from_Bank_Team__c != null) {
                
                Dispute_Lifecycle__c tat = tatMap.get(c.Id);
                
                // IMPORTANT → update only once
                if (tat != null && tat.Last_Reply_Date__c == null) {
                    tat.Last_Reply_Date__c = Date.today();
                    tatToUpdate.add(tat);
                }
            }
        }
        
         try {
            
            if (!tatToInsert.isEmpty()) {
                insert tatToInsert;
            }

            if (Test.isRunningTest() && throwTestException) {
                throw new AuraHandledException('Forced Exception');
            }
            
        } catch (Exception err) {
            
            List<Automation_Logs__c> apiLogList = new List<Automation_Logs__c>();
            
            for (Dispute_Lifecycle__c tat : tatToInsert) {
                
                apiLogList.add(new Automation_Logs__c(
                    Batch_Class_Name__c = 'OneXPCaseTrigger',
                    Automation_Log_Description__c = 'CaseTATHandler - Step: TAT Insert',
                    Case__c = tat.Case__c,
                    Error_Message__c = err.getMessage()
                ));
            }
            
            if (!apiLogList.isEmpty()) {
                insert apiLogList;
            }
        }
        
        // UPDATE + AUTOMATION LOGS
        try {
            
            if (!tatToUpdate.isEmpty()) {
                update tatToUpdate;
            }

            if (Test.isRunningTest() && throwTestException) {
                throw new AuraHandledException('Forced Exception');
            }
            
        } catch (Exception err) {
            
            List<Automation_Logs__c> apiLogList =
                new List<Automation_Logs__c>();
            
            for (Dispute_Lifecycle__c tat : tatToUpdate) {
                
                apiLogList.add(new Automation_Logs__c(
                    Batch_Class_Name__c = 'OneXPCaseTrigger',
                    Automation_Log_Description__c = 'CaseTATHandler - Step: TAT Update',
                    Case__c = tat.Case__c,
                    Error_Message__c = err.getMessage()
                ));
            }
            
            if (!apiLogList.isEmpty()) {
                insert apiLogList;
            }
        }
    }
}