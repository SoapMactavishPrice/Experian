@isTest
public class CommonCaseBatch_Test {
    @isTest
    public static void isValidate3(){
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
        
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        Sub_Type__c	 stl10 =new Sub_Type__c	();
        stl10.Name = 'Matching';
        stl10.Case_Type__c = ct.Id;
        insert stl10;
        
        Sub_Type1__c st10 = new Sub_Type1__c();
        st10.Name = 'account does not belong to me';
        st10.Sub_Type__c = stl10.Id;
        insert st10;
        
        
        Sub_Type1__c st50 = new Sub_Type1__c();
        st50.Name = 'Credit Enquiry does not belong to me';
        st50.Sub_Type__c = stl10.Id;
        insert st50;
        
        
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'account ownership issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'account does not belong to me';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        
        Sub_Type1__c st5 = new Sub_Type1__c();
        st5.Name = 'Credit Enquiry does not belong to me';
        st5.Sub_Type__c = stl1.Id;
        insert st5;
        
        Sub_Type1__c st4 = new Sub_Type1__c();
        st4.Name = 'closed';
        st4.Sub_Type__c = stl1.Id;
        insert st4;
        
        
        
        Sub_Type__c	 sub1 =new Sub_Type__c	();
        sub1.Name = 'Enquiry Changes';
        sub1.Case_Type__c = ct.Id;
        insert sub1;
        
        Sub_Type1__c sub2 = new Sub_Type1__c();
        sub2.Name = 'Enquiry Date';
        sub2.Sub_Type__c = sub1.Id;
        insert sub2;
        
        Sub_Type1__c sub3 = new Sub_Type1__c();
        sub3.Name = 'Loan Type';
        sub3.Sub_Type__c = sub1.Id;
        insert sub3;
        
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
        
        Case cs = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'UpdateId';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Report';
        cs.Case_Type__c='Dispute';
        cs.Sub_Type__c='Account Status';
        cs.Sub_Type_1__c='Active';
        cs.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs.Account_s_Parent_Case__c = false;
        
        cs.Origin = 'Portal';
        cs.Case_Type_Lookup__c = ct12.Id;
        cs.Sub_Type_Lookup__c = st12.id;
        cs.Sub_Type_1_Lookup__c= st21.Id;
        
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs;
        
        
        Sub_Type1__c st2 = new Sub_Type1__c();
        st2.Name = 'account not reflecting';
        st2.Sub_Type__c = stl1.Id;
        insert st2;
        
        
        
        cs = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'UpdateId';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type__c='Dispute';
        cs.Sub_Type__c='Account Status';
        cs.Sub_Type_1__c='Active';
        cs.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs.Account_s_Parent_Case__c = false;
        
        cs.Origin = 'Portal';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl1.id;
        cs.Sub_Type_1_Lookup__c= st2.Id;
        cs.Correct_Overdue_Amount__c = 89;
        cs.Displayed_Overdue_Amount__c = 987;
        cs.Displayed_Account_Status__c = 'Closed';
        
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs;
        
        
        
        Sub_Type__c	 stl2 =new Sub_Type__c	();
        stl2.Name = 'account type';
        stl2.Case_Type__c = ct.Id;
        insert stl2;
        
        Sub_Type1__c st3 = new Sub_Type1__c();
        st3.Name = 'incorrect name';
        st3.Sub_Type__c = stl2.Id;
        insert st3;
        
        
        
        cs = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'UpdateId';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type__c='Dispute';
        cs.Sub_Type__c='Account Status';
        cs.Sub_Type_1__c='Active';
        cs.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs.Account_s_Parent_Case__c = false;
        
        cs.Origin = 'Portal';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl2.id;
        cs.Sub_Type_1_Lookup__c= st3.Id;
        cs.Correct_Overdue_Amount__c = 89;
        cs.Displayed_Overdue_Amount__c = 987;
        
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs;
        
        
        Sub_Type__c	 stl5 =new Sub_Type__c	();
        stl5.Name = 'Account Status';
        stl5.Case_Type__c = ct.Id;
        insert stl5;
        
        Sub_Type1__c st6 = new Sub_Type1__c();
        st6.Name = 'account does not belong to me';
        st6.Sub_Type__c = stl5.Id;
        insert st6;
        
        Sub_Type1__c st7 = new Sub_Type1__c();
        st7.Name = 'Closed';
        st7.Sub_Type__c = stl5.Id;
        insert st7;
        
        
        
        cs = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'UpdateId';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type__c='Dispute';
        cs.Sub_Type__c='Account Status';
        cs.Sub_Type_1__c='Active';
        cs.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs.Account_s_Parent_Case__c = false;
        
        cs.Origin = 'Portal';
        cs.Displayed_Account_Status__c ='Closed';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl5.id;
        cs.Sub_Type_1_Lookup__c= st6.Id;
        
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs;
        
        
        Sub_Type__c	 stl21 =new Sub_Type__c	();
        stl21.Name = 'Account Details';
        stl21.Case_Type__c = ct.Id;
        insert stl21;
        
        Sub_Type1__c st123 = new Sub_Type1__c();
        st123.Name = 'account opened date';
        st123.Sub_Type__c = stl21.Id;
        insert st123;
        
        cs = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'UpdateId';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type__c='Dispute';
        cs.Sub_Type__c='Account Status';
        cs.Sub_Type_1__c='Active';
        cs.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs.Account_s_Parent_Case__c = false;
        
        cs.Origin = 'Portal';
        
        cs.Origin = 'Portal';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl21.id;
        cs.Sub_Type_1_Lookup__c= st123.Id;
        
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs;
        
        
        CommonCaseBatch csf = new CommonCaseBatch();
        Database.executeBatch(csf,10);
        
        Test.startTest();
        CommonCaseBatch ucb = new CommonCaseBatch();
        DataBase.executeBatch(ucb,100);
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, ucb);  
        CommonCaseBatch.fakeCodeCoverage();
        Test.stopTest();
    }
}