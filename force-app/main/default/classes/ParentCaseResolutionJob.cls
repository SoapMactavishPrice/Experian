public class ParentCaseResolutionJob implements Queueable {

    public static Boolean throwTestException = false;
   
    Set<Id> parentCaseIds;
   
    public ParentCaseResolutionJob(Set<Id> parentCaseIds) {
        this.parentCaseIds = parentCaseIds;
    }
    
    public void execute(QueueableContext qc) {
      
        Map<Id, List<Case>> parentToChildren = new Map<Id, List<Case>>();
        for (Case child : [
            SELECT Id, Status, Parent_Account_Number_Case__c, Last_Reply_from_Bank_Team__c 
            FROM Case
            WHERE Parent_Account_Number_Case__c IN :parentCaseIds
            AND Case_Identifier_Type__c = 'Attribute'
        ]) {
            if (!parentToChildren.containsKey(child.Parent_Account_Number_Case__c)) {
                parentToChildren.put(child.Parent_Account_Number_Case__c, new List<Case>());
            }
            parentToChildren.get(child.Parent_Account_Number_Case__c).add(child);
        }
        
        List<Case> parentsToUpdate = new List<Case>();
        for (Id parentId : parentToChildren.keySet()) {
            Boolean allResolved = true;
            for (Case ch : parentToChildren.get(parentId)) {
                if (ch.Status != 'Resolved') {
                    allResolved = false;
                    break;
                }
            }
            if (allResolved) {
                parentsToUpdate.add(new Case(
                    Id = parentId,
                    Status = 'Resolved'
                    //Last_Reply_from_Bank_Team__c = 
                ));
            }
        }
        
         try {
            
            if (!parentsToUpdate.isEmpty()) {
                update parentsToUpdate;
            }

             if(Test.isRunningTest() && throwTestException){
                throw new AuraHandledException('Forced Exception');
            }
            
        } catch (Exception err) {
            
            List<Automation_Logs__c> apiLogList = new List<Automation_Logs__c>();
            
            for (Case c : parentsToUpdate) {
                
                apiLogList.add(new Automation_Logs__c(
                    Batch_Class_Name__c = 'OneXPCaseTrigger',
                    Automation_Log_Description__c =
                        'ParentCaseResolutionJob - Step: Parent Case Resolution Update',
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