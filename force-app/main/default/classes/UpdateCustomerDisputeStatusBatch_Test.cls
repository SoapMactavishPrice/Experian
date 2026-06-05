@isTest
public class UpdateCustomerDisputeStatusBatch_Test {
    
    @isTest
    public static void updateCaseStatus(){
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
        // Add other info on account which is requred to create it.
        insert acc;
        
        Case_Type__c ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Case_Complaint__c = 'Call Center';
        ct.isActive__c = true;
        ct.Name = 'Complaint Dispute Consumer';
        insert ct;
        
        system.debug('sel'+[Select Id ,Name from Case_Type__c limit 1].Name);
        
        Sub_Type__c sb = new Sub_Type__c();
        sb.Case_Type__c = ct.Id;
        sb.Name = 'Test';
        sb.isActive__c = true;
        insert sb;
        
        Sub_Type1__c sub = new Sub_Type1__c();
        sub.Sub_Type__c = sb.Id;
        sub.Name = 'Test 01';
        insert sub;
        
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.Contact_Role__c = 'Consumer';
        con.LastName = 'test';
        con.Email = 'test@gmail.com';
        insert con;
        
        Id bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;        
        Case cs1 = new Case();
        
        
        
        cs1.Status = 'Open';
        cs1.AccountId = acc.id;
        cs1.Subject = 'Update Oracle Id';
        cs1.Case_Category__c = 'Consumer';
        cs1.Name_of_Consumer__c = con.Id;
        cs1.Case_Complaints__c = 'Call Center';
        cs1.Case_Type__c = null;
        cs1.Case_Type_Lookup__c = ct.Id;
        cs1.Sub_Type_Lookup__c = sb.Id;
        cs1.Sub_Type_1_Lookup__c = sub.Id;
        cs1.Sub_Type__c=null;
        cs1.Sub_Type_1__c=null;
        cs1.Sub_Type_Status__c =null;
        cs1.Origin = 'Web';
        cs1.OwnerId = bankteamId ; 
        cs1.Case_Type__c = 'Customer Complaint';
        cs1.Date_of_the_email_received__c = system.today().addDays(-30);
        cs1.Status = 'Open';
        cs1.Consumer_Dispute_Status__c = 'Acknowledgement sent to Consumer';
        insert cs1;
        
        cs1.Forward_to_bank__c = true;
        update cs1;
        
        system.debug('Dispute Days'+[select Id,Case_Type_Name__c from Case limit 1].Case_Type_Name__c);
        
        test.startTest();
        DataBase.executeBatch(new UpdateCustomerDisputeStatusBatch());
        test.stopTest(); 
    }
    
}