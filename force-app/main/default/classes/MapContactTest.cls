@IsTest
public class MapContactTest {
    
    static testMethod void testMethod1() {
		Account acc= new Account();
        acc.name = 'Test';
        insert acc;
        
        Contact con = new Contact();
        con.AccountId = acc.id;
        con.LastName = 'test';
        con.Email = 'abc@gmail.com';
        con.Email_2__c = 'cdf@gmail.com';
        insert con;
        
        Case ca = new Case();
        ca.SuppliedEmail='abc@gmail.com';
        ca.ContactId= con.id;
        insert ca;
    }
    
    static testMethod void testMethod2() {
		Account acc= new Account();
        acc.name = 'Test';
        insert acc;
        
        Contact con = new Contact();
        con.AccountId = acc.id;
        con.LastName = 'test';
        con.Email = 'abc@gmail.com';
        con.Email_2__c = 'cdf@gmail.com';
        insert con;
        
        Case ca = new Case();
        ca.SuppliedEmail='cdf@gmail.com';
        ca.ContactId= con.id;
        insert ca;
    }
}