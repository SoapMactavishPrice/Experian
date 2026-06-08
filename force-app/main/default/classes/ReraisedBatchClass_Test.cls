@isTest
public class ReraisedBatchClass_Test {
@isTest
    public static void isValidate(){
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
        
        Sub_Type1__c st212 = new Sub_Type1__c();
        st212.Name = 'Re-raise';
        st212.Sub_Type__c = st12.id;
        st212.isActive__c = true;
        Insert st212;
        
        
        List<Account> acclist = new List<Account>();
        Account acc = new Account();
        acc.Name = 'Finesse IT Labs Pvt Ltd';
        acc.Email_1_Dispute__c = 'abc@gmail.com';
        acc.Email_2_Dispute__c = 'abc@gmail.com';
        acc.Email_3_Dispute__c = 'abc@gmail.com';
        acc.Email_4_Dispute__c = 'abc@gmail.com';
        acc.Email_5_Dispute__c = 'abc@gmail.com';
        acc.Email_6_Dispute__c = 'abc@gmail.com';
        acc.Email_7_Dispute__c = 'abc@gmail.com';
        acc.Email_8_Dispute__c = 'abc@gmail.com';
        acc.Email_9_Dispute__c = 'abc@gmail.com';
        acc.Email_10_Dispute__c = 'abc@gmail.com';
        insert acc;
        acclist.add(acc);
        
        
        
        Contact con = new Contact();
        con.Email = 'abcsdfgh@gmail.com';
        con.FirstName = 'dfghj';
        con.LastName = 'dfghjk';
        con.AccountId= acc.Id;
        con.Contact_Role__c = 'Consumer';
        insert con;
        
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'Report';
        insert ct;
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Account Details';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'EMI Amounts';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        Case cs = new Case();
        cs.AccountId = acc.Id;
        cs.status = 'Open';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Report';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl1.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Case_Origin_2__c = 'RBI';
        cs.RBI_Complaint_Number__c = '1234567';
        //cs.Send_Mail_for_RBI_Complaint__c = true;
        cs.RBI_Complaint_Number__c = '1234567';
        cs.Displayed_Account_number__c = '1234567890';
        cs.Displayed_Bank_Name__c = 'HDFC';
        cs.Name_of_Consumer__c = con.Id;
        cs.Origin = 'Portal';
        insert cs;
        cs.Date_of_the_email_received__c = system.today();
        cs.Dispute_Detail__c = 'Test';
        cs.Dispute_Raised_Date__c = system.today();
        cs.Forward_to_bank__c = true;
        update cs;
        
        
        Sub_Type__c	 stl2 =new Sub_Type__c	();
        stl2.Name = 'DPD';
        stl2.Case_Type__c = ct.Id;
        insert stl2;
        
        Sub_Type1__c st2 = new Sub_Type1__c();
        st2.Name = 'Incorrect';
        st2.Sub_Type__c = stl2.Id;
        insert st2;
        
        Case cs1 = new Case();
        cs1.AccountId = acc.Id;
        cs1.Account_s_Parent_Case__c = true;
        cs1.Case_Category__c = 'Consumer';
        cs1.Case_Complaints__c = 'Report';
        cs1.status = 'Open';
        cs1.Case_Type_Lookup__c = ct.Id;
        cs1.Sub_Type_Lookup__c = stl2.id;
        cs1.Sub_Type_1_Lookup__c= st2.Id;
        cs1.Case_Origin_2__c = 'RBI';
        cs1.Origin = 'Portal';
        cs1.RBI_Complaint_Number__c = '1234567';
        cs1.Displayed_Account_number__c = '1234567890';
        cs1.Displayed_Bank_Name__c = 'HDFC';
        cs1.Name_of_Consumer__c = con.Id;
        cs1.Dispute_Detail__c = '';
        insert cs1;
        
        
        Case cs2 = new Case();
        cs2.AccountId = acc.Id;
        cs2.Account_s_Parent_Case__c = true;
        cs2.Case_Category__c = 'Consumer';
        cs2.Case_Complaints__c = 'Report';
        cs2.status = 'Open';
        cs2.Case_Type_Lookup__c = ct.Id;
        cs2.Sub_Type_Lookup__c = stl2.id;
        cs2.Sub_Type_1_Lookup__c= st2.Id;
        cs2.Case_Origin_2__c = 'RBI';
        cs2.Origin = 'Portal';
        cs2.RBI_Complaint_Number__c = '1234567';
        cs2.Displayed_Account_number__c = '1234567890';
        cs2.Displayed_Bank_Name__c = 'HDFC';
        cs2.Name_of_Consumer__c = con.Id;
        cs2.Dispute_Detail__c = '';
        insert cs2;
        
        DPD_Detail__c dpd = new DPD_Detail__c();
        dpd.Case__c = cs2.Id;
        dpd.Displayed_EMI_Repayment_Month__c = -1;
        insert dpd;
        
        
        Case_Type__c  ct1 = new Case_Type__c();
        ct1.Case_Category__c = 'Consumer';
        ct1.Name ='Query';
        ct1.Case_Complaint__c = 'Report';
        insert ct1;
        
        Sub_Type__c	 stl3 =new Sub_Type__c	();
        stl3.Name = 'Status of Dispute';
        stl3.Case_Type__c = ct1.Id;
        insert stl3;
        
        Sub_Type1__c st01 = new Sub_Type1__c();
        st01.Name = 'Re-raise';
        st01.Sub_Type__c = stl3.Id;
        insert st01;
        
        
        
        
        test.startTest();
        ReraisedBatchClass updater1 = new ReraisedBatchClass();
        ID jobID1 = database.executebatch(updater1,10);
        test.stopTest();
        
    }
    
    @isTest
    public static void isValidate2(){
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
        
        Sub_Type1__c st212 = new Sub_Type1__c();
        st212.Name = 'Re-raise';
        st212.Sub_Type__c = st12.id;
        st212.isActive__c = true;
        Insert st212;
        
        List<Account> acclist = new List<Account>();
        Account acc = new Account();
        acc.Name = 'Experian India Pvt Ltd';
        acc.Email_1_Dispute__c = 'abc@gmail.com';
        acc.Email_2_Dispute__c = 'abc@gmail.com';
        acc.Email_3_Dispute__c = 'abc@gmail.com';
        acc.Email_4_Dispute__c = 'abc@gmail.com';
        acc.Email_5_Dispute__c = 'abc@gmail.com';
        acc.Email_6_Dispute__c = 'abc@gmail.com';
        acc.Email_7_Dispute__c = 'abc@gmail.com';
        acc.Email_8_Dispute__c = 'abc@gmail.com';
        acc.Email_9_Dispute__c = 'abc@gmail.com';
        //acc.Email_10_Dispute__c = '';
        insert acc;
        acclist.add(acc);
        
        
        
        Contact con = new Contact();
        con.Email = 'abcsdfgh@gmail.com';
        con.FirstName = 'dfghj';
        con.LastName = 'dfghjk';
        con.AccountId= acc.Id;
        con.Contact_Role__c = 'Consumer';
        insert con;
        
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'Report';
        insert ct;
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Balance Issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Current Balance';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        Case cs = new Case();
        cs.AccountId = acc.Id;
        cs.status = 'Open';
        cs.Origin = 'Portal';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Report';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl1.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Case_Origin_2__c = 'RBI';
        cs.RBI_Complaint_Number__c = '1234567';
        //cs.Send_Mail_for_RBI_Complaint__c = true;
        cs.RBI_Complaint_Number__c = '1234567';
        cs.Displayed_Account_number__c = '1234567890';
        cs.Displayed_Bank_Name__c = 'HDFC';
        cs.Name_of_Consumer__c = con.Id;
        cs.Correct_Loan_Balance__c =100;
        cs.Displayed_Loan_Balance__c = 1;
        insert cs;
        cs.Date_of_the_email_received__c = system.today();
        cs.Dispute_Detail__c = 'Test';
        cs.Dispute_Raised_Date__c = system.today();
        cs.Forward_to_bank__c = true;
        update cs;
        
        
        Sub_Type1__c st2 = new Sub_Type1__c();
        st2.Name = 'Over due';
        st2.Sub_Type__c = stl1.Id;
        insert st2;
        
        Case cs1 = new Case();
        cs1.AccountId = acc.Id;
        cs1.Account_s_Parent_Case__c = true;
        cs1.Case_Category__c = 'Consumer';
        cs1.Case_Complaints__c = 'Report';
        cs1.status = 'Open';
        cs1.Origin = 'Portal';
        cs1.Case_Type_Lookup__c = ct.Id;
        cs1.Sub_Type_Lookup__c = stl1.id;
        cs1.Sub_Type_1_Lookup__c= st2.Id;
        cs1.Case_Origin_2__c = 'RBI';
        cs1.RBI_Complaint_Number__c = '1234567';
        cs1.Displayed_Account_number__c = '1234567890';
        cs1.Displayed_Bank_Name__c = 'HDFC';
        cs1.Name_of_Consumer__c = con.Id;
        cs1.Dispute_Detail__c = '';
        cs.Correct_Overdue_Amount__c =100;
        cs.Displayed_Overdue_Amount__c = 1;
        insert cs1;
        
        Case_Type__c  ct1 = new Case_Type__c();
        ct1.Case_Category__c = 'Consumer';
        ct1.Name ='Query';
        ct1.Case_Complaint__c = 'Report';
        insert ct1;
        
        Sub_Type__c	 stl3 =new Sub_Type__c	();
        stl3.Name = 'Status of Dispute';
        stl3.Case_Type__c = ct1.Id;
        insert stl3;
        
        Sub_Type1__c st01 = new Sub_Type1__c();
        st01.Name = 'Re-raise';
        st01.Sub_Type__c = stl3.Id;
        insert st01;
        
        
        
        
        test.startTest();
        ReraisedBatchClass updater1 = new ReraisedBatchClass();
        ID jobID1 = database.executebatch(updater1,10);
        test.stopTest();
        
    }
}