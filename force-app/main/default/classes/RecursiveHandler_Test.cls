@isTest
public class RecursiveHandler_Test {
    
    static testMethod void CloneCase(){
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        insert cse;
        
        Case cse1=cse.clone();
        insert cse1;
        
    }
    
}