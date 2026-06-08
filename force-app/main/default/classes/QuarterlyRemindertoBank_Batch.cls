global class QuarterlyRemindertoBank_Batch implements Database.Batchable<sObject>{
    
global List <Case> accountsToParseSet = new List<Case>();

   global QuarterlyRemindertoBank_Batch(List<Case> accountsToParseGet){
      accountsToParseSet = accountsToParseGet;          
   }

   public List<SObject> start(Database.BatchableContext context){
    return accountsToParseSet;
   }


   global void execute(Database.BatchableContext BC, 
                       List<Case> scope){
      update scope;
   }

   global void finish(Database.BatchableContext BC){

   }
}