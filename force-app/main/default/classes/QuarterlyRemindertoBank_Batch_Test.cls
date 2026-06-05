@isTest
public class QuarterlyRemindertoBank_Batch_Test {
    @isTest
    public static void isValidate(){
        List<Case> cslist = new List<Case>();
        
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
        
        System.debug('Account--->'+acc);
        Contact cn = new Contact();
        cn.AccountId = acc.id;
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Fax = '1234567';
        cn.Contact_Role__c = 'Consumer';
        cn.Email = 'tsetas@gmail.com';
        cn.Birthdate=system.today();
        
        Contact con=new  Contact();
        con.AccountId =acc.Id;
        con.LastName='Test';
        con.Email = 'abc@gmail.com';
        con.Contact_Role__c = 'Dispute Manager – Escalation Level 3';
        
        insert con;
        
        insert cn;
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Balance Issue';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Current Balance';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.AccountId = acc.id;
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Dispute_Raised_Date__c = date.today();
        cse.Email_Received_Date__c = date.today();
        cse.Dispute_Detail__c = 'cvbnm';
        insert cse;
        cse.Forward_to_bank__c=true;
        update cse;
        
       
        cse.Account_s_Parent_Case__c = true;
        update cse;
        
        cslist.add(cse);
        
        QuarterlyRemindertoBank_Batch dt = new QuarterlyRemindertoBank_Batch(cslist);
        database.executeBatch(dt,1);
    }
}