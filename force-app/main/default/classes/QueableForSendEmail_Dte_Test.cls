@isTest
public class QueableForSendEmail_Dte_Test {
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
        
        OLM_Format__c off = new OLM_Format__c();
        insert off;
        
        map<Integer,List<Sobject>>  newMapTemp =new map<Integer,List<Sobject>>();
        newMapTemp.put(1,acclist);
        test.startTest();
        QueableForSendEmail_Dte updater = new QueableForSendEmail_Dte(acclist,'SEND',1);
        ID jobID = System.enqueueJob(updater);
        test.stopTest();
        
    }
    
    @isTest
    public static void test2() {
        Case_Type__c ct1 = new Case_Type__c();
        ct1.Name = 'Query';
        ct1.Case_Category__c = 'Consumer';
        ct1.Case_Complaint__c = 'Report';
        Insert ct1;
        
        Sub_Type__c st = new Sub_Type__c();
        st.Name = 'Status of Dispute';
        st.Case_Type__c = ct1.id;
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
            
         Sub_Type__c	 stl2 =new Sub_Type__c	();
        stl2.Name = 'Demographic Details';
        stl2.Case_Type__c = ct.Id;
        insert stl2;
        
         Sub_Type1__c st3 = new Sub_Type1__c();
        st3.Name = 'incorrect name';
        st3.Sub_Type__c = stl2.Id;
        insert st3;

        Sub_Type1__c stMatch = new Sub_Type1__c();
        stMatch.Name = 'Matching - Incorrect Name';
        stMatch.Sub_Type__c = stl2.Id;   // use existing st
        stMatch.isActive__c = true;
        insert stMatch;
        
        
        Case cs1 = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        // cs1.Status = 'Open';
        cs1.Status = 'Closed'; 
        cs1.AccountId = acc.id;
        cs1.Subject = 'UpdateId';
        cs1.Case_Category__c = 'Consumer';
        cs1.Case_Complaints__c = 'Call Center';
        cs1.Case_Type__c='Dispute';
        cs1.Sub_Type__c='Account Status';
        cs1.Sub_Type_1__c='Active';
        cs1.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs1.Account_s_Parent_Case__c = false;
        
        cs1.Origin = 'Web';
        cs1.Case_Type_Lookup__c = ct.Id;
        cs1.Sub_Type_Lookup__c = stl2.id;
        cs1.Sub_Type_1_Lookup__c= st3.Id;
        cs1.Correct_Overdue_Amount__c = 89;
        cs1.Displayed_Overdue_Amount__c = 987;
        
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs1;
        
        
        OLM_Format__c off = new OLM_Format__c();
        insert off;
        
        map<Integer,List<Sobject>>  newMapTemp =new map<Integer,List<Sobject>>();
        newMapTemp.put(1,acclist);

        // ADD THIS BLOCK
        Case parentCase = new Case(
            AccountId = acc.Id,
            Account_s_Parent_Case__c = true
        );
        insert parentCase;

        // Create Compensation records
        List<Compensation_Child_Cases__c> compList = new List<Compensation_Child_Cases__c>();

        for(Integer i=0; i<3; i++){
            compList.add(new Compensation_Child_Cases__c(
                Parent_Case__c = parentCase.Id,
                Liable_Party_Account_Id__c = acc.Id,
                Consumer_Name__c = 'Test',
                Consumer_Email_ID__c = 'test@gmail.com',
                Case_Number__c = 'C'+i,
                Displayed_Account_number__c = '12345',
                Sub_Type_Name__c = 'Type',
                Sub_Type_1_Name__c = 'SubType',
                Account_Name__c = acc.Name,
                Dispute_Received_Date__c = System.today(),
                Resolve_Date__c = System.today(),
                Status__c = 'Closed',
                Delayed_No_of_Days__c = 5,
                Liable_Amount__c = 100,
                Experian_Liability_Amt__c = 50,
                Compensation_Opted__c = 'Yes',
                Bank_Name__c = 'Bank',
                Account_Number__c = '123',
                IFSC_Code__c = 'IFSC',
                Consumer_Name_As_per_Bank_Account__c = 'Test Name'
            ));
        }

        insert compList;
        
        test.startTest();
        QueableForSendEmail_Dte updater = new QueableForSendEmail_Dte(newMapTemp, 'SEND', 1, 1,1);
        ID jobID = System.enqueueJob(updater);
        test.stopTest();
        
    }



}