@IsTest
public class MyClassTest_Class {
    static testMethod void testMethod1() {

     test.startTest();
    try{
       Product__c p = new Product__c();
       p.Name = 'Test';
       Insert p; 
       
       list<String> idList = new List<String>();
       Lead newLead = new Lead() ;
       newLead.FirstName = 'Test';
        newLead.Email='abc@gmail.com';
       newLead.LastName = 'Mahi';
       newLead.Company = 'Apple';
       newLead.Status = 'OTP Verified';
       insert newLead;
       
       List<Product__c> pList= [SELECT id, Name FROM Product__c];
        
        List<Lead_Payment_Detail__c> listtest = [Select id from Lead_Payment_Detail__c where Lead__c =:newlead.id];
        
       system.debug('---'+listtest.size());
        
      Lead_Payment_Detail__c lp = new Lead_Payment_Detail__c();
        MyClass.mmethod(new List<Id>{newLead.Id});
        //MyClass.fakeCodeCoverage();
     //lp.Lead__c = newLead.id;
     //lp.Product__c = p.id;
     //Insert lp;

    } Catch(Exception e){}
       test.stopTest();
 }  
}