@isTest
public class DisputeTrackerClassTest {
    @isTest
    public static void dispute(){
        
        string bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;
        string consumerteamId = System.Label.Consumer_Support_Queue_Id;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(
            Alias = 'testu',
            Email = 'test34567890@gmail.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = p.Id,
            UserName='test34567890@gmail.com'
        );
        
        INSERT u;
        
        User u1 = new User(
            Alias = 'testu',
            Email = 'test34567890@gmail.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Bank Team',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = p.Id,
            UserName='test345678901@gmail.com'
        );
        
        INSERT u1;
        
        Account acc = new Account();
        acc.Name = 'SBI - AHMEDABAD';
        acc.Instant_Reports__c  = true;
        // Add other info on account which is requred to create it.
        acc.Email_1_Dispute__c = 'adfg@dfdg.com';
        acc.Email_2_Dispute__c = 'adfg@dfdg.com';
        acc.Email_3_Dispute__c = 'adfg@dfdg.com';
        acc.Email_4_Dispute__c = 'adfg@dfdg.com';
        acc.Email_5_Dispute__c = 'adfg@dfdg.com';
        acc.Email_6_Dispute__c = 'adfg@dfdg.com';
        acc.Email_Dispute__c = 'adfg@dfdg.com';
        insert acc;
        
        Contact cn = new Contact();
        cn.AccountId = acc.id;
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Fax = '1234567';
        cn.Contact_Role__c = 'Consumer';
        cn.Email = 'tsetas@gmail.com';
        cn.Birthdate=system.today();
        insert cn;
        
        
        Case_Type__c ct1 = new Case_Type__c();
        ct1.Name = 'Query';
        ct1.Case_Category__c = 'Consumer';
        ct1.Case_Complaint__c = 'Report';
        Insert ct1;
        
        Sub_Type__c st1 = new Sub_Type__c();
        st1.Name = 'Status of Dispute';
        st1.Case_Type__c = ct1.id;
        st1.isActive__c = true;
        Insert st1;
        
        Sub_Type1__c st21 = new Sub_Type1__c();
        st21.Name = 'Duplicate';
        st21.Sub_Type__c = st1.id;
        st21.isActive__c = true;
        Insert st21;
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Balance Issue';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Current Balance';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        Case cs = new Case();
        cs.OwnerId = u.Id;
        cs.Subject = 'Om Test';  
        cs.Status ='Resolved';
        cs.Priority = 'Medium';
        cs.Origin = 'Email';
        cs.AccountId = acc.Id;
        cs.Name_of_Consumer__c = cn.id;
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st.Id;
        insert cs;
        
     
        //cs.Forward_to_bank__c = true;
        //update cs;
        
        cs.Forward_to_CST_Team__c = true;
        cs.Case_Category__c = 'Consumer';
        upsert cs;
        
        cs.Forward_to_Score_Team__c = true;
        cs.OwnerId=u1.id;
        update cs;
        
        cs.Forward_to_Data_Submission__c = true;
        update cs;
        
        cs.Forward_to_GPD_Team__c = true;
        update cs;
        cs.Forward_to_NG_Team__c = true;
        update cs;
        cs.Forward_to_ECV_Team__c = true;
        update cs;
        
        cs.Forward_to_OLM__c = true;
        update cs;
        
        cs.Forward_to_Data_Merger__c = true;
        update cs;
        
        CaseHistory csh = new CaseHistory();
        csh.CaseId = cs.Id;
        csh.Field ='Owner';
        insert csh;
        
        List<Map<Id,Case>> caselist = new List<Map<Id,Case>>();
        Map<Id,Case>caseMap = new Map<Id,Case>();
        caseMap.put(cs.Id,cs);
        
        set<Id> ids = new set<Id>(); 
        ids.add(cs.Id);
        
        DisputeTrackerClass dt = new DisputeTrackerClass();
        test.startTest();
        DisputeTrackerClass.UpdateDates(ids,json.serializePretty(caseMap));
        test.stopTest();
        
    }
    
    
    
    @isTest
    public static void dispute2(){
        
        string bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;
        string consumerteamId = System.Label.Consumer_Support_Queue_Id;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(
            Alias = 'testu',
            Email = 'test34567890@gmail.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = p.Id,
            UserName='test34567890@gmail.com'
        );
        
        INSERT u;
        
        User u1 = new User(
            Alias = 'testu',
            Email = 'test34567890@gmail.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Bank Team',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = p.Id,
            UserName='test345678901@gmail.com'
        );
        
        INSERT u1;
        
        Account acc = new Account();
        acc.Name = 'SBI - AHMEDABAD';
        acc.Instant_Reports__c  = true;
        // Add other info on account which is requred to create it.
        acc.Email_1_Dispute__c = 'adfg@dfdg.com';
        acc.Email_2_Dispute__c = 'adfg@dfdg.com';
        acc.Email_3_Dispute__c = 'adfg@dfdg.com';
        acc.Email_4_Dispute__c = 'adfg@dfdg.com';
        acc.Email_5_Dispute__c = 'adfg@dfdg.com';
        acc.Email_6_Dispute__c = 'adfg@dfdg.com';
        acc.Email_Dispute__c = 'adfg@dfdg.com';
        insert acc;
        
        Contact cn = new Contact();
        cn.AccountId = acc.id;
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Fax = '1234567';
        cn.Contact_Role__c = 'Consumer';
        cn.Email = 'tsetas@gmail.com';
        cn.Birthdate=system.today();
        insert cn;
        
        Case_Type__c ct1 = new Case_Type__c();
        ct1.Name = 'Query';
        ct1.Case_Category__c = 'Consumer';
        ct1.Case_Complaint__c = 'Report';
        Insert ct1;
        
        Sub_Type__c st1 = new Sub_Type__c();
        st1.Name = 'Status of Dispute';
        st1.Case_Type__c = ct1.id;
        st1.isActive__c = true;
        Insert st1;
        
        Sub_Type1__c st21 = new Sub_Type1__c();
        st21.Name = 'Duplicate';
        st21.Sub_Type__c = st1.id;
        st21.isActive__c = true;
        Insert st21;
        
        
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Balance Issue';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Current Balance';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        Case cs = new Case();
        cs.OwnerId = u.Id;
        cs.Subject = 'Om Test';  
        cs.Status ='Resolved';
        cs.Priority = 'Medium';
        cs.Origin = 'Email';
        cs.AccountId = acc.Id;
        cs.Name_of_Consumer__c = cn.id;
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st.Id;
        insert cs;
        
     
        //cs.Forward_to_bank__c = true;
        //update cs;

cs.Forward_to_ECV_Team__c = true;
        update cs;
        
        cs.Forward_to_NG_Team__c = true;
        update cs;
                
        cs.Forward_to_OLM__c = true;
        update cs;
        
        cs.Forward_to_Data_Merger__c = true;
        update cs;
        
        //cs.Forward_to_bank__c = true;
        //update cs;
        
        CaseHistory csh = new CaseHistory();
        csh.CaseId = cs.Id;
        csh.Field ='Owner';
        insert csh;
        
        List<Map<Id,Case>> caselist = new List<Map<Id,Case>>();
        Map<Id,Case>caseMap = new Map<Id,Case>();
        caseMap.put(cs.Id,cs);
        
        
        //cs.Forward_to_bank__c = true;
        //update cs;
        
        set<Id> ids = new set<Id>(); 
        ids.add(cs.Id);
        
        DisputeTrackerClass dt = new DisputeTrackerClass();
        test.startTest();
        DisputeTrackerClass.UpdateDates(ids,json.serializePretty(caseMap));
        test.stopTest();
        
    }
    
}