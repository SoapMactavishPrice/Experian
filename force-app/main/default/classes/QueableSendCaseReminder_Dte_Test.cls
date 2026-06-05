@isTest
public class QueableSendCaseReminder_Dte_Test {
    
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
        insert acc;
        acclist.add(acc);
        
        Contact con = new Contact();
        con.Email = 'abcsdfgh@gmail.com';
        con.FirstName = 'dfghj';
        con.LastName = 'dfghjk';
        con.AccountId= acc.Id;
        insert con;
        
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
        
        OLM_Format__c off = new OLM_Format__c();
        insert off;
        
        map<Integer,List<Sobject>>  newMapTemp =new map<Integer,List<Sobject>>();
        newMapTemp.put(1,acclist);
        test.startTest();
        QueableSendCaseReminder_Dte updater = new QueableSendCaseReminder_Dte(acclist,'UPDATE',1,off.Id,'',acclist);
        ID jobID = System.enqueueJob(updater);
        test.stopTest();
        
    }
    
    @isTest
    public static void test2() {
        
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
        insert acc;
        acclist.add(acc);
        
        Contact con = new Contact();
        con.Email = 'abcsdfgh@gmail.com';
        con.FirstName = 'dfghj';
        con.LastName = 'dfghjk';
        con.AccountId= acc.Id;
        insert con;
        
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
        
        OLM_Format__c off = new OLM_Format__c();
        insert off;
        
        map<Integer,List<Sobject>>  newMapTemp =new map<Integer,List<Sobject>>();
        newMapTemp.put(1,acclist);
        test.startTest();
        QueableSendCaseReminder_Dte updater = new QueableSendCaseReminder_Dte(newMapTemp, 'UPDATE', 1, 1, '', off.Id, 1, acclist);
        ID jobID = System.enqueueJob(updater);
        test.stopTest();
        
    }
    
    
    
     @isTest
    public static void test3() {
        
        
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
        insert acc;
        acclist.add(acc);
        
        Contact con = new Contact();
        con.Email = 'abcsdfgh@gmail.com';
        con.FirstName = 'dfghj';
        con.LastName = 'dfghjk';
        con.AccountId= acc.Id;
        insert con;
        
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
        
        OLM_Format__c off = new OLM_Format__c();
        insert off;
        
        map<Integer,List<Sobject>>  newMapTemp =new map<Integer,List<Sobject>>();
        newMapTemp.put(1,acclist);
        test.startTest();
        QueableSendCaseReminder_Dte updater = new QueableSendCaseReminder_Dte(newMapTemp, 'UPSERT', 1, 1, '', off.Id, 1, acclist);
        ID jobID = System.enqueueJob(updater);
        test.stopTest();
        
    }
    
     @isTest
    public static void test4() {
        
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
        insert acc;
        acclist.add(acc);
        
        Contact con = new Contact();
        con.Email = 'abcsdfgh@gmail.com';
        con.FirstName = 'dfghj';
        con.LastName = 'dfghjk';
        con.AccountId= acc.Id;
        insert con;
        
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
        
        OLM_Format__c off = new OLM_Format__c();
        insert off;
        
        map<Integer,List<Sobject>>  newMapTemp =new map<Integer,List<Sobject>>();
        newMapTemp.put(1,acclist);
        test.startTest();
        QueableSendCaseReminder_Dte updater = new QueableSendCaseReminder_Dte(newMapTemp, 'DELETE', 1, 1, '', off.Id, 1, acclist);
        ID jobID = System.enqueueJob(updater);
        test.stopTest();
        
    }


}