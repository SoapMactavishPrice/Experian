@isTest
public class AllOpenCaseConsolidatedBatch_Test {
    @isTest 
    public static void isValidate(){
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        Sub_Type__c	 stl01 =new Sub_Type__c	();
        stl01.Name = 'Account ownership issue';
        stl01.Case_Type__c = ct.Id;
        insert stl01;
        
       
        
        Sub_Type1__c st01 = new Sub_Type1__c();
        st01.Name = 'Account does not belong to me';
        st01.Sub_Type__c = stl01.Id;
        
        insert st01;
        
        Sub_Type1__c st02 = new Sub_Type1__c();
        st02.Name = 'Matching - Account does not belong to me';
        st02.Sub_Type__c = stl01.Id;
        insert st02;
        
        Account acc = new Account();
        acc.Name = 'WHIZDM FINANCE PRIVATE LIMITED';
        acc.Instant_Reports__c  = true;
        acc.Email_Dispute__c='abc@gmail.com';
        acc.Email_1_Dispute__c='efg@gmail.com';
        acc.Email_2_Dispute__c='e@gmail.com';
        acc.Email_3_Dispute__c='p@gmail.com';
        acc.Email_4_Dispute__c='a@gmail.com';
        acc.Email_5_Dispute__c='b@gmail.com';
        acc.Email_6_Dispute__c='c@gmail.com';
        acc.Email_7_Dispute__c = 'abc@gmail.com';
        acc.Email_8_Dispute__c = 'abc@gmail.com';
        acc.Email_9_Dispute__c = 'abc@gmail.com';
        acc.Email_10_Dispute__c = 'abc@gmail.com';
        // Add other info on account which is requred to create it.
        insert acc;
        
        Case_Type__c ct12 = new Case_Type__c();
        ct12.Name = 'Query';
        ct12.Case_Category__c = 'Consumer';
        ct12.Case_Complaint__c = 'Report';
        Insert ct12;
        
        Sub_Type__c st12 = new Sub_Type__c();
        st12.Name = 'Status of Dispute';
        st12.Case_Type__c = ct12.id;
        st12.isActive__c = true;
        Insert st12;
        
        Sub_Type1__c st21 = new Sub_Type1__c();
        st21.Name = 'Duplicate';
        st21.Sub_Type__c = st12.id;
        st21.isActive__c = true;
        Insert st21;
        
        
        
        Sub_Type__c	 stl1234 =new Sub_Type__c	();
        stl1234.Name = 'Matching';
        stl1234.Case_Type__c = ct.Id;
        
        insert stl1234;
        
        Sub_Type1__c st1234 = new Sub_Type1__c();
        st1234.Name = 'Account does not belong to me';
        st1234.Sub_Type__c = stl1234.Id;
        insert st1234;
        
        Sub_Type1__c st12345 = new Sub_Type1__c();
        st12345.Name = 'Credit Enquiry does not belong to me';
        st12345.Sub_Type__c = stl1234.Id;
        insert st12345;
        
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
        
        
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Enquiry Ownership Issue';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Credit Enquiry does not belong to me';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        Sub_Type1__c st03 = new Sub_Type1__c();
        st03.Name = 'Matching - Credit Enquiry does not belong to me';
        st03.Sub_Type__c = stl.Id;
        insert st03;
        
        
        
       /*Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Enquiry Ownership Issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Credit Enquiry does not belong to me';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        */
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
        cse.Forward_to_Bank_Date__c = date.today().addDays(-1);
        cse.Temp_Forward_to_Bank__c = true;
        cse.Date_of_the_email_received__c = date.today();
        insert cse;
        
        
        
        
        cse.Forward_to_bank__c = true;
        update cse;
        
        AllOpenCaseConsolidatedBatch sdh =  new AllOpenCaseConsolidatedBatch();
        ID batchprocessid = Database.executeBatch(sdh,2);
        
    }
    
}