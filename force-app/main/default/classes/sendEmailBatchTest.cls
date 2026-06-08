@isTest
public class sendEmailBatchTest {
    public static testMethod void test1(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        system.assert(true);
        User u = new User(
            Alias = 'testu',
            Email = 'test34567890@gmail.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = p.Id,
            UserName='test34567890@gmail.com'
        );
        
        INSERT u;     
        
        Account acc = new Account();
        acc.Name = 'Kabib';
        acc.Instant_Reports__c  = true;
        acc.Email_Dispute__c='abc@gmail.com';
        acc.Email_1_Dispute__c='efg@gmail.com';
        acc.Email_2_Dispute__c='e@gmail.com';
        acc.Email_3_Dispute__c='p@gmail.com';
        acc.Email_4_Dispute__c='a@gmail.com';
        acc.Email_5_Dispute__c='b@gmail.com';
        acc.Email_6_Dispute__c='c@gmail.com';
        acc.Email_7_Dispute__c='p@gmail.com';
        acc.Email_8_Dispute__c='a@gmail.com';
        acc.Email_9_Dispute__c='b@gmail.com';
        acc.Email_10_Dispute__c='c@gmail.com';
        acc.Authorized_Signatory_Email__c = 'a@gmail.com';
        acc.Nodal_Officer_Email__c = 'a@gmail.com';
        acc.Authorized_User_Id_Email__c = 'a@gmail.com';
        //acc.Auth_or_Nodal_or_Auth_User_or_Dispute__c = true;
        //acc.Authorized_User_Id_Email__c  = 
        acc.Contact_Information_Email_Sent__c = false;
        // Add other info on account which is requred to create it.
        insert acc;
       //system.debug('Auth '+[select Id ,Auth_or_Nodal_or_Auth_User_or_Dispute__c from Account where Id=:acc.Id]); 
        
        Contact cn = new Contact();
        cn.AccountId = acc.id;
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Fax = '1234567';
        cn.Contact_Role__c = 'Authorized Signatory';
        cn.Email = 'tsetas@gmail.com';
        cn.Birthdate=system.today();
        insert cn;
        
        cn = new Contact();
        cn.AccountId = acc.id;
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Fax = '1234567';
        cn.Contact_Role__c = 'Nodal Officer';
        cn.Email = 'tsetas45@gmail.com';
        cn.Birthdate=system.today();
        insert cn;
        
        
        cn = new Contact();
        cn.AccountId = acc.id;
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Fax = '1234567';
        cn.Contact_Role__c = 'Authorized User Id';
        cn.Email = 'tsetas786@gmail.com';
        cn.Birthdate=system.today();
        insert cn;
        
        test.startTest();
        sendEmailBatch sm = new sendEmailBatch();
        DataBase.executeBatch(sm);
        test.stopTest();
        
}
    

}