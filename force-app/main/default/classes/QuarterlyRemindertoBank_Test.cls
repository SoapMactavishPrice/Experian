@isTest
public class QuarterlyRemindertoBank_Test {
    public static testMethod void isValidate(){
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
        
        
        Case_Type__c  ct1 = new Case_Type__c();
        ct1.Case_Category__c = 'Consumer';
        ct1.Name ='Query';
        ct1.Case_Complaint__c = 'Report';
        
        insert ct1;
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Dispute Data';
        stl1.Case_Type__c = ct1.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Monthly / Quarterly';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
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
        insert cse;
        
        
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
        
        con=new  Contact();
        con.AccountId =acc.Id;
        con.LastName='Test';
        con.Email = 'abc4@gmail.com';
        con.Contact_Role__c = 'Nodal Officer';
        
        insert con;
        
        insert cn;
        system.debug('Account Id  5001s000007ZBK0AAO ++ >>. '+acc.Id);
        Case cs = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'UpdateId';
        cs.Case_Category__c = 'Consumer';
        
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st.Id;
        //cs.Owner.Name = 'Bank Team';
        cs.Account_s_Parent_Case__c = false;
        cs.Dispute_Raised_Date__c = date.today();
        cs.Email_Received_Date__c = date.today();
        cs.Dispute_Detail__c = 'cvbnm';
        cs.Origin = 'Web';
        
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs;
        system.debug('Case owne r Id'+cs.Owner.Name);
        //cs.OwnerId='00G6D000001rpbg';
        cs.Forward_to_bank__c=true;
        update cs;
        
        
         
        cs.Account_s_Parent_Case__c = false;
        update cs;
        
         String input = '[{"'+acc.Id+'":"'+cs.Id+'"}]';
        
        EmailMessage em = new EmailMessage();
        em.ParentId = cs.Id;
        em.Email_Body__c = 'test';
        em.Subject = 'rcvbnm';
        insert em;
        
        EmailMessage em1 = new EmailMessage();
        em1.ParentId = csE.Id;
        em1.Email_Body__c = null;
        em1.Subject = 'rcvbnm';
        insert em1;
        
      
        List<string> strlist = new List<string>();
        strlist.add('Dispute Manager – Escalation Level 1');
        strlist.add('Dispute Manager – Escalation Level 2');
        strlist.add('Dispute Manager – Escalation Level 3');
        strlist.add('Dispute Manager – Escalation Level 4');
        
        Map<string, List<string>> maplist = new Map<string, List<string>>();
        List<string> str = new List<string>();
        str.add(cs.Id);
        maplist.put(acc.Id,str);
        
        OLM_Format__c olm = new OLM_Format__c();
        insert olm;
        
        QuarterlyRemindertoBank.getEmail(json.serialize(strlist),acc.Id);
        QuarterlyRemindertoBank.getAccount_server('5','5','Kabib');
        QuarterlyRemindertoBank.checkNodalOfficerexistOrNot(acc.Id);
        QuarterlyRemindertoBank.getCaseDetail(acc.Id,date.today().addDays(-100),date.today().addDays(100));
        try{
            QuarterlyRemindertoBank.SendEmail(JSON.serializePretty(maplist),'abc@gmail.com',new List<string>{'abc@gmail.com'});
            
        }catch(exception e){}
    }
    
}