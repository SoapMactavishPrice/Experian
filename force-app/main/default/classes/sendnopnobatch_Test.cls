@isTest
public class sendnopnobatch_Test {
	
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
        cs.Case_Origin_2__c = 'PNO';
        insert cs;
        
        cs.Forward_to_bank__c = true;
        update cs;
        
        Case cs1 = new Case();
        cs1.AccountId = acc.Id;
        cs1.Account_s_Parent_Case__c = true;
        cs1.Case_Category__c = 'Consumer';
        cs1.Case_Complaints__c = 'Call Center';
        cs1.status = 'Open';
        cs1.Case_Type_Lookup__c = ct.Id;
        cs1.Sub_Type_Lookup__c = stl1.id;
        cs1.Sub_Type_1_Lookup__c= st1.Id;
        cs1.Case_Origin_2__c = 'NO';
        insert cs1;
        
        
        Sub_Type__c	 stl2 =new Sub_Type__c	();
        stl2.Name = 'Account ownership issue';
        stl2.Case_Type__c = ct.Id;
        insert stl2;
        
        Sub_Type1__c st3 = new Sub_Type1__c();
        st3.Name = 'Current Balance';
        st3.Sub_Type__c = stl2.Id;
        insert st3;
        
        Case cs2 = new Case();
        cs2.AccountId = acc.Id;
        cs2.status = 'Open';
        cs2.Case_Category__c = 'Consumer';
        cs2.Case_Complaints__c = 'Call Center';
        cs2.Case_Type_Lookup__c = ct.Id;
        cs2.Sub_Type_Lookup__c = stl2.id;
        cs2.Sub_Type_1_Lookup__c= st3.Id;
        cs2.Case_Origin_2__c = 'Escalated Case';
        insert cs2;
        
        OLM_Format__c off = new OLM_Format__c();
        insert off;
        
        map<Integer,List<Sobject>>  newMapTemp =new map<Integer,List<Sobject>>();
        newMapTemp.put(1,acclist);
        test.startTest();
        string schedmon5am = '0 00 05 ? * 2';  
        
        sendnopnobatch updater1 = new sendnopnobatch();
        ID jobID1 = database.executebatch(updater1,10);
        test.stopTest();
        
    }
}