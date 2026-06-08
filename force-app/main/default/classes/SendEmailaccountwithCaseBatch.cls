//public class SendEmailaccountwithCaseBatch  implements Queueable, Database.AllowsCallouts{
/*public integer i = 5;
    
public List <Case> accountsToParseSet = new List<Case>();

   public SendEmailaccountwithCaseBatch(List<Case> accountsToParseGet,){
      accountsToParseSet = accountsToParseGet; 
       //i = ListSize;
   }

    public void execute(QueueableContext qc){
        update accountsToParseSet;
        system.debug('update list size'+accountsToParseSet.size());
        system.debug('accountsToParseSet'+accountsToParseSet);
    }


*/

  /*  public static List<Object> slice(List<Object> input, Integer ge, Integer l)
        
   {
        
        List<Object> output = input.clone();
        for (Integer i = 0; i < ge; i++) output.remove(0);
        
           Integer elements = l - ge;
        
        while (output.size() > elements) output.remove(elements);
        
        return output;
        
    }
}
*/


global class SendEmailaccountwithCaseBatch  implements Database.Batchable<sObject>{

public List <Case> accountsToParseSet = new List<Case>();

   global SendEmailaccountwithCaseBatch(List<Case> accountsToParseGet){
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