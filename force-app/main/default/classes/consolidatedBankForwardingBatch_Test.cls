@isTest
public class consolidatedBankForwardingBatch_Test {
    
    @isTest 
    public static void isValidate(){
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
        acc.CC_Address_10__c = 'abc@gmail.com';
         acc.CC_Address_1__c = 'abc1@gmail.com';
         acc.CC_Address_2__c = 'abc2@gmail.com';
         acc.CC_Address_3__c = 'abc3@gmail.com';
         acc.CC_Address_4__c = 'abc4@gmail.com';
         acc.CC_Address_5__c = 'abc5@gmail.com';
         acc.CC_Address_6__c = 'abc6@gmail.com';
         acc.CC_Address_7__c = 'abc7@gmail.com';
         acc.CC_Address_8__c = 'abc8@gmail.com';
         acc.CC_Address_9__c = 'abc9@gmail.com';
         acc.CC_Address_10__c = 'abc12@gmail.com';
        acc.Bureau_Member_Id__c = '1';
        
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

         Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c   stl1234 =new Sub_Type__c  ();
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
        
       
        Sub_Type__c   stl =new Sub_Type__c  ();
        stl.Name = 'Balance Issue';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Current Balance';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        
        Sub_Type__c   stl1 =new Sub_Type__c  ();
        stl1.Name = 'Demographic Details';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Current Balance';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
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
        insert cse;
        
        //cse.Forward_to_bank__c = true;
        //update cse
        
        consolidatedBankForwardingBatch sdh =  new consolidatedBankForwardingBatch();
        ID batchprocessid = Database.executeBatch(sdh,2);
        
    }
    
    @isTest 
    public static void isValidate2(){
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
        acc.CC_Address_10__c = 'abc@gmail.com';
         acc.CC_Address_1__c = 'abc1@gmail.com';
         acc.CC_Address_2__c = 'abc2@gmail.com';
         acc.CC_Address_3__c = 'abc3@gmail.com';
         acc.CC_Address_4__c = 'abc4@gmail.com';
         acc.CC_Address_5__c = 'abc5@gmail.com';
         acc.CC_Address_6__c = 'abc6@gmail.com';
         acc.CC_Address_7__c = 'abc7@gmail.com';
         acc.CC_Address_8__c = 'abc8@gmail.com';
         acc.CC_Address_9__c = 'abc9@gmail.com';
         acc.CC_Address_10__c = 'abc12@gmail.com';
        acc.Bureau_Member_Id__c = '1';
        
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

         Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c   stl1234 =new Sub_Type__c  ();
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
        
       
        Sub_Type__c   stl =new Sub_Type__c  ();
        stl.Name = 'Demographic Details';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Current Balance';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        
        Sub_Type__c   stl1 =new Sub_Type__c  ();
        stl1.Name = 'Account ownership issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Current Balance';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.AccountId = acc.id;
        cse.Priority = 'Medium';
        cse.Displayed_Bank_Name__c='ICICI Bankaass';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Account_Date_Reported__c = date.today();
        cse.Contact_Date_of_Birth__c = date.today().addDays(-567);
        cse.Date_of_the_email_received__c = date.today();
        //cse.Enquiry_Date__c = date.today();
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Dispute_Raised_Date__c = date.today();
        cse.Email_Received_Date__c = date.today();
        cse.Dispute_Detail__c = 'cvbnm';
        cse.Forward_to_Bank_Date__c = date.today().addDays(-1);
        cse.Temp_Forward_to_Bank__c = true;
        insert cse;
        
        //cse.Forward_to_bank__c = true;
        //update cse
        
        consolidatedBankForwardingBatch sdh =  new consolidatedBankForwardingBatch();
        ID batchprocessid = Database.executeBatch(sdh,2);
        
    }
    
    @isTest 
    public static void isValidate3(){
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
        acc.CC_Address_10__c = 'abc@gmail.com';
         acc.CC_Address_1__c = 'abc1@gmail.com';
         acc.CC_Address_2__c = 'abc2@gmail.com';
         acc.CC_Address_3__c = 'abc3@gmail.com';
         acc.CC_Address_4__c = 'abc4@gmail.com';
         acc.CC_Address_5__c = 'abc5@gmail.com';
         acc.CC_Address_6__c = 'abc6@gmail.com';
         acc.CC_Address_7__c = 'abc7@gmail.com';
         acc.CC_Address_8__c = 'abc8@gmail.com';
         acc.CC_Address_9__c = 'abc9@gmail.com';
         acc.CC_Address_10__c = 'abc12@gmail.com';
        acc.Bureau_Member_Id__c = '1';
        
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

         Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c   stl1234 =new Sub_Type__c  ();
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
        
       
        Sub_Type__c   stl =new Sub_Type__c  ();
        stl.Name = 'Demographic Details';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Current Balance';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        
        Sub_Type__c   stl1 =new Sub_Type__c  ();
        stl1.Name = 'Account ownership issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Current Balance';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.AccountId = acc.id;
        cse.Priority = 'Medium';
        cse.Displayed_Bank_Name__c='ICICI Bankawerthjk';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl1.id;
        cse.Sub_Type_1_Lookup__c= st1.Id;
        cse.Dispute_Raised_Date__c = date.today();
        cse.Email_Received_Date__c = date.today();
        cse.Dispute_Detail__c = 'cvbnm';
        cse.Forward_to_Bank_Date__c = date.today().addDays(-1);
        cse.Temp_Forward_to_Bank__c = true;
        insert cse;
        
        //cse.Forward_to_bank__c = true;
        //update cse
        
        consolidatedBankForwardingBatch sdh =  new consolidatedBankForwardingBatch();
        ID batchprocessid = Database.executeBatch(sdh,2);
        
    }
}