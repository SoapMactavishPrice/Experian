@IsTest
public class MapContactBatchClass_Test {
    
    static testMethod void testMethod1() {
        
        Account acc= new Account();
        acc.name = 'Test';
        insert acc;
        
        State__c stat = new State__c();
        stat.name= 'Goa';
        insert stat;
        
        Contact con = new Contact();
        con.AccountId = acc.id;
        con.LastName = 'test';
        con.Email = 'abc@gmail.com';
        con.Email_2__c = 'cdf@gmail.com';
        con.Address_1__c = 'Goa';
        con.Contact_Role__c = '';
        insert con;
        
        Case_Type__c ct = new Case_Type__c();
        ct.Name = 'Query';
        ct.Case_Category__c = 'Consumer';
        ct.Case_Complaint__c = 'Report';
        Insert ct;
        
        Sub_Type__c st = new Sub_Type__c();
        st.Name = 'Status of Dispute';
        st.Case_Type__c = ct.id;
        st.isActive__c = true;
        Insert st;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Duplicate';
        st1.Sub_Type__c = st.id;
        st1.isActive__c = true;
        Insert st1;
        
        Case ca = new Case();
        ca.SuppliedEmail='abc@gmail.com';
        ca.Displayed_Email_Id__c = 'abc@gmail.com';
        ca.Correct_email_id__c = 'abc@gmail.com';
        ca.Current_Application_Email__c = 'abc@gmail.com';
        ca.ContactEmailId__c = 'abc@gmail.com';
        insert ca;
        
        Test.startTest(); 
        Database.executeBatch(new MapContactBatchClass());        
        Test.stopTest();
    }
    
}