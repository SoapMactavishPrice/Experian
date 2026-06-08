public class CaseHelper {
    
    @future
    public static void updateForwardToBank(List<Id> caseIds){
        List<Case> casesToUpdate = new List<Case>();
        
        for(Case c : [SELECT Id FROM Case WHERE Id IN :caseIds]){
            c.Forward_to_Bank__c = true;
            c.Temp_Forward_to_Bank__c = true;
            casesToUpdate.add(c);
        }
        
        if(!casesToUpdate.isEmpty()){
            update casesToUpdate;
        }
    }
}