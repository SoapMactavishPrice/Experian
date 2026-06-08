public class CaseOwnerUpdate_Batch implements Database.Batchable<sObject>{
    
    public Set<Id> ids {get;set;}
    
    public CaseOwnerUpdate_Batch(Set<Id> caseIds) {
        ids = caseIds;
        System.debug('CaseOwnerUpdate_Batch ids==========> '+ids);        
    }
    
    public Iterable<sObject> start(Database.BatchableContext bc) {
        
        List<Case> caseRecordList = [SELECT Id, CaseNumber, OwnerId from Case WHERE Id IN :ids AND (Status = 'Open' OR Status = 'ReOpen')];
        
        return caseRecordList;
    }
    
    public void execute(Database.BatchableContext bc, List<Case> records){
        
        Id ConSupId = System.Label.Consumer_Support_Queue_Id;
        List<Case> childCaseList = new List<Case>();
        
        for (Case cs: records) {
            cs.OwnerId = ConSupId;
            cs.Last_Reply_from_Bank_Team__c = system.today();
            if(test.isRunningTest()){
                cs.Send_Email_to_Consumer__c = true; 
            }
            childCaseList.add(cs);
        }
        
        if(childCaseList.size() > 0){
            try{
                UPDATE childCaseList;
            }catch(Exception e){
                // Catch the exception and collect error details
                String errorType = e.getTypeName();
                String errorMessage = e.getMessage();
                Integer errorLineNumber = e.getLineNumber();
                
                // Log the error (optional)
                System.debug('Error Type: ' + errorType);
                System.debug('Error Message: ' + errorMessage+' ' + errorLineNumber);
                System.debug('Error errorLineNumber: ' + errorLineNumber);
                
                API_log__c api_log = new API_Log__c();
                api_log.Request_Source__c = 'CaseOwnerUpdate_Batch';
                api_log.Exception_Description__c = errorLineNumber +''+ errorType +''+ errorMessage;
                INSERT api_log;
            }
        } 
    }
    
    public void finish(Database.BatchableContext bc){
        
    }
    
}