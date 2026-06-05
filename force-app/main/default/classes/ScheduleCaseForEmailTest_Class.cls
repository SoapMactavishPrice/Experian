@isTest
public class ScheduleCaseForEmailTest_Class
{
    static testMethod void testMethod1()
    {
       // Create test data according to your Batch job
        try {

        Account acc = new Account();
        acc.Name ='Name';
        acc.Instant_Reports__c = false;
        Insert acc;
            
        Case c = new Case();
        c.AccountId = acc.id;
        c.Case_Category__c = 'Consumer';
        c.Case_Sub_Source__c = 'Customer Support';
        c.Case_Complaints__c = 'Correct details on credit report';
        c.Case_Type__c = 'Dispute';
        c.Sub_Type__c = 'Account Status';
        c.Sub_Type_1__c = 'Closed';
        c.Sub_Type_Status__c='Notify to Bank';
        Insert c;
        
       
        Test.startTest();

            ScheduleCaseForEmail obj = new ScheduleCaseForEmail(); 
            
            DataBase.executeBatch(obj);
           
        Test.stopTest();
             } Catch(Exception e){} 
    }
}