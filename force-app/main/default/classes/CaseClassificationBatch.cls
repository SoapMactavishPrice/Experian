public class CaseClassificationBatch implements Database.Batchable<sObject>{


   public Database.QueryLocator start(Database.BatchableContext bc){
      String category='Consumer';
      String Origin='Email';
      String Query ='Select id,subject,Case_Type_Lookup__c,SuppliedName,Case_Category__c,Origin,Junk_Case__c FROM case where Case_Category__c=:category and Origin=:Origin And Junk_Case__c=false limit 100';
      return Database.getQueryLocator(query);
   }

   public void execute(Database.BatchableContext bc, List<Case> scope){
     System.debug('scope'+scope);
     for(case s : scope){
        CaseTriggerHandler cst = new CaseTriggerHandler();
        Set<id> ids=new Set<id>();
        ids.add(s.id);
        cst.updateCaseCategory(ids);
     }
    }

   public void finish(Database.BatchableContext bc){
   }
}