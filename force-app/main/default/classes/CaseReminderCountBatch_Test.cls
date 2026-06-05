@isTest
public class CaseReminderCountBatch_Test {
    @isTest
    public static void test1() {
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
        
        
        
        List<Account> acclist = new List<Account>();
        Account acc = new Account();
        acc.Name = 'ertyu';
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
        insert con;
        
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
        cs.AccountId = acc.Id;
        insert cs;
        
        
        
        cs = new Case();
        cs.AccountId = acc.Id;
        cs.Account_s_Parent_Case__c = true;
        insert cs;
        
        
        cs = new Case();
        cs.AccountId = acc.Id;
        insert cs;
        
        
        test.startTest();
        CaseReminderCountBatch updater = new CaseReminderCountBatch();
        Database.executeBatch(updater,1);
        test.stopTest();
        
    }

}