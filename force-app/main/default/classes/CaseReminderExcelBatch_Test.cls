@isTest
public class CaseReminderExcelBatch_Test {
     @isTest
    public static void valiadate(){
        
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
        system.debug('Account Id  5001s000007ZBK0AAO ++ >>. '+acc.Id);
        
        
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
        cs.status = 'Open';
        
        cs.Origin = 'Web';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl1.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs;
        system.debug('Case owne r Id'+cs.Owner.Name);
        //cs.OwnerId='00G6D000001rpbg';
        cs.Forward_to_bank__c=true;
        update cs;
        
        
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Account ownership issue';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Current Balance';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        Case cs1 = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs1.Status = 'Open';
        cs1.AccountId = acc.id;
        cs1.Subject = 'UpdateId';
        cs1.Case_Category__c = 'Consumer';
        cs1.Case_Complaints__c = 'Call Center';
        cs1.Case_Type__c='Dispute';
        cs1.Sub_Type__c='Account Status';
        cs1.Sub_Type_1__c='Active';
        cs1.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs1.Account_s_Parent_Case__c = true;
        //cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st.Id;
        
        cs1.Origin = 'Web';
        
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs1;
        system.debug('Case owne r Id'+cs.Owner.Name);
        
        
        
        cs.Account_s_Parent_Case__c = false;
        update cs;
        
        Case_Reminder__c cr  = new Case_Reminder__c();
        cr.Account__c = acc.Id;
        cr.Total_Open_Cases_Count__c = 1;
        cr.Reminder_Period__c = 'Pre April 26, 2024';
                cr.Reminder_Date__c = system.today();
        insert cr;
        
        test.startTest();
        CaseReminderExcelBatch updater = new CaseReminderExcelBatch();
        Database.executeBatch(updater,1);
        test.stopTest();
        
        
        
    }

}