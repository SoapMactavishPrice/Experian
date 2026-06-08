@IsTest
public class becomeMemberControllerTestClass {
    static testMethod void testMethod1() 
    {
        test.startTest();
        becomeMemberController b = new becomeMemberController();
        Lead testAcct = new Lead (LastName = 'Amjad');
        insert testAcct;     
        system.debug('Lead---->'+testAcct);
        becomeMemberController.SubmitLead('[{"Title":"Mr.","FirstName":"Sayyad","LastName":"Amjad","Email":"furkann@finesseme.com","Phone":"1234567890","CompanyName":"RahulCorp"}]');
        
        Lead testAcct1 = new Lead (LastName = 'Amjad');
        insert testAcct1;      
        system.debug('Lead---->'+testAcct);
        becomeMemberController.SubmitLead('[{"Title":"Mr.","FirstName":"Sayyad","LastName":"Amjad","Email":"furkann@finesseme.com","Phone":"1234567890","CompanyName":"RahulCorp"}]');
        
       test.stopTest();
    }
    
     
}