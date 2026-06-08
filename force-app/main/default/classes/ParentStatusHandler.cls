public class ParentStatusHandler {
    
    public static Boolean throwTestException = false;
    
    public static void updateParentStatus(List<Case> newCases, Map<Id, Case> oldMap){
        
        Set<Id> parentIds = new Set<Id>();
        
        // Step 1: Collect Parent Case Ids ONLY when Checker_Status__c changes
        for(Case c : newCases){
            
            Case oldRec = oldMap.get(c.Id);
            
            if(c.Case_Identifier_Type__c == 'Attribute' && c.Parent_Account_Number_Case__c != null &&
               c.Checker_Status__c != oldRec.Checker_Status__c){
                   
                   parentIds.add(c.Parent_Account_Number_Case__c);
               }
        }
        
        if(parentIds.isEmpty()){
            return;
        }
        
        // Step 2: Fetch all child cases
        List<Case> childCases = [
            SELECT Id, Parent_Account_Number_Case__c,
            Maker_Status__c, Checker_Status__c, Maker_Sub_Status__c
            FROM Case
            WHERE Parent_Account_Number_Case__c IN :parentIds
        ];
        
        // Step 3: Group by Parent
        Map<Id, List<Case>> parentToChildren = new Map<Id, List<Case>>();
        
        for(Case c : childCases){
            if(!parentToChildren.containsKey(c.Parent_Account_Number_Case__c)){
                parentToChildren.put(c.Parent_Account_Number_Case__c, new List<Case>());
            }
            parentToChildren.get(c.Parent_Account_Number_Case__c).add(c);
        }
        
        // Step 4: Fetch parent cases (to check existing status)
        Map<Id, Case> parentMap = new Map<Id, Case>(
            [SELECT Id, Account_Level_Status__c
             FROM Case
             WHERE Id IN :parentIds]
        );
        
        List<Case> parentsToUpdate = new List<Case>();
        
        // Step 5: Apply logic
        for(Id parentId : parentToChildren.keySet()){
            
            List<Case> children = parentToChildren.get(parentId);
            Boolean allMatch = true;
            
            for(Case child : children){
                if(!(child.Maker_Status__c == 'Reject' && child.Checker_Status__c == 'Accept' &&
                     child.Maker_Sub_Status__c == 'Fully Rejected')){
                         
                         allMatch = false;
                         break;
                     }
            }
            
            // Step 6: Update ONLY if needed
            if(allMatch){
                
                Case parentRec = parentMap.get(parentId);
                
                if(parentRec != null &&
                   parentRec.Account_Level_Status__c != 'Pending With Experian'){
                       
                       parentsToUpdate.add(new Case(
                           Id = parentId,
                           Account_Level_Status__c = 'Pending With Experian'
                       ));
                   }
            }
        }
        
         try{
            
            if(!parentsToUpdate.isEmpty()){
                update parentsToUpdate;
            }
             
            if (Test.isRunningTest() && throwTestException) {
                throw new AuraHandledException('Forced Exception');
            }
            
        } catch(Exception err){
            
            List<Automation_Logs__c> apiLogList = new List<Automation_Logs__c>();
            
            for(Case c : parentsToUpdate){
                
                apiLogList.add(new Automation_Logs__c(
                    Batch_Class_Name__c = 'OneXPCaseTrigger',
                    Automation_Log_Description__c =
                        'ParentStatusHandler Step: Parent Status Update',
                    Case__c = c.Id,
                    Error_Message__c = err.getMessage()
                ));
            }
            
            if(!apiLogList.isEmpty()){
                insert apiLogList;
            }
        }
    }
}