public class BatchLogger {

    // public static Auto_Dispute_Batch_Logs__c createLog(String batchName) {
    //     Auto_Dispute_Batch_Logs__c log = new Auto_Dispute_Batch_Logs__c(
    //         Batch_Name__c = batchName,
    //         Start_Time__c = System.now(),
    //         Status__c = 'Started',
    //         Records_Processed__c = 0
    //     );
    //     insert log;
    //     return log;
    // }

    // public static void updateLogSuccess(Auto_Dispute_Batch_Logs__c log, Integer count) {
    //     if(log == null) return;
    //     log.End_Time__c = System.now();
    //     log.Status__c = 'Completed';
    //     log.Records_Processed__c = count != null ? count : 0;
    //     update log;
    // }

    // public static void updateLogFailure(Auto_Dispute_Batch_Logs__c log, String errorMsg) {
    //     if(log == null) return;
    //     log.End_Time__c = System.now();
    //     log.Status__c = 'Failed';
    //     log.Error_Message__c = errorMsg;
    //     update log;
    // }
}