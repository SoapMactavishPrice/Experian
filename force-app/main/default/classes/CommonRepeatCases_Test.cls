@isTest
public class CommonRepeatCases_Test {
    @isTest
    public static void validate(){
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
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Balance';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Current Balance';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        Case cs = new Case();
        cs.AccountId = acc.Id;
        cs.status = 'Open';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl1.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Case_Origin_2__c = 'RBI';
        cs.RBI_Complaint_Number__c = '1234567';
        cs.Send_Mail_for_RBI_Complaint__c = true;
        cs.RBI_Complaint_Number__c = '1234567';
        cs.Displayed_Account_number__c = '1234567890';
        cs.Displayed_Bank_Name__c = 'HDFC';
        cs.Name_of_Consumer__c = con.Id;
        cs.Origin = 'Portal';
        insert cs;	
        
         Case cs2 = new Case();
        cs2.AccountId = acc.Id;
        cs2.status = 'Open';
        cs2.Case_Category__c = 'Consumer';
        cs2.Case_Complaints__c = 'Call Center';
        cs2.Case_Type_Lookup__c = ct.Id;
        cs2.Sub_Type_Lookup__c = stl1.id;
        cs2.Sub_Type_1_Lookup__c= st1.Id;
        cs2.Case_Origin_2__c = 'Portal';
        cs2.RBI_Complaint_Number__c = '1234567';
        cs2.Send_Mail_for_RBI_Complaint__c = true;
        cs2.RBI_Complaint_Number__c = '1234567';
        cs2.Displayed_Account_number__c = '1234567890';
        cs2.Displayed_Bank_Name__c = 'HDFC';
        cs2.Name_of_Consumer__c = con.Id;
        cs2.Origin = 'Portal';
        //insert cs2;	
        
        
        test.startTest();
        CommonRepeatCases updater1 = new CommonRepeatCases();
        ID jobID1 = database.executebatch(updater1,1);
        test.stopTest();
        
    }
    
    public static void validate2(){
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
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Balance';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Current Balance';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        Case cs = new Case();
        cs.AccountId = acc.Id;
        cs.status = 'Open';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl1.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Case_Origin_2__c = 'NO';
        cs.RBI_Complaint_Number__c = '1234567';
        cs.Send_Mail_for_RBI_Complaint__c = true;
        cs.RBI_Complaint_Number__c = '1234567';
        cs.Displayed_Account_number__c = '1234567890';
        cs.Displayed_Bank_Name__c = 'HDFC';
        cs.Name_of_Consumer__c = con.Id;
        cs.Origin = 'Portal';
        insert cs;	
        
         Case cs2 = new Case();
        cs2.AccountId = acc.Id;
        cs2.status = 'Open';
        cs2.Case_Category__c = 'Consumer';
        cs2.Case_Complaints__c = 'Call Center';
        cs2.Case_Type_Lookup__c = ct.Id;
        cs2.Sub_Type_Lookup__c = stl1.id;
        cs2.Sub_Type_1_Lookup__c= st1.Id;
        cs2.Case_Origin_2__c = 'RBI';
        cs2.RBI_Complaint_Number__c = '1234567';
        cs2.Send_Mail_for_RBI_Complaint__c = true;
        cs2.RBI_Complaint_Number__c = '1234567';
        cs2.Displayed_Account_number__c = '1234567890';
        cs2.Displayed_Bank_Name__c = 'HDFC';
        cs2.Name_of_Consumer__c = con.Id;
        cs2.Origin = 'Portal';
        //insert cs2;	
        
        
        test.startTest();
        CommonRepeatCases updater1 = new CommonRepeatCases();
        ID jobID1 = database.executebatch(updater1,1);
        test.stopTest();
        
    }
}