@isTest
public class caseReopen_Trigger_test {

    @isTest
    public static void testEM() { 
        
        // Step 1: Create a User (This is optional if you need a user in the queue)
        User u2 = new User(
           
            LastName = 'Bank Team',
            Username = 'testuserbLICK@example.com',
            Email = 'testuser@example.com',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        INSERT u2;
        
        User us = [SELECT Id, Name, userName, Email FROM USER WHERE Id = :u2.Id];
        
        
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
        
        Group queue = new Group(
            Name = 'Bank Team',
            Type = 'Queue'
        );
        //insert queue;
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Subject = 'Om Test';  
        c.Status ='Resolved';
        c.Priority = 'Medium';
        c.Origin = 'Email';
        c.Case_Category__c = 'Consumer';
        c.Case_Complaints__c = 'Call Center';
        c.Case_Type_Lookup__c = ct.Id;
        c.Sub_Type_Lookup__c = stl.id;
        c.Sub_Type_1_Lookup__c= st.Id;
        
        c.Account_s_Parent_Case__c = true;
        insert c;
        
        
        case c1 = new Case();
        c1.AccountId = acc.Id;
        c1.Subject = 'Om Test';  
        c1.Status ='Resolved';
        c1.Priority = 'Medium';
        c1.Origin = 'a';
        c1.Reminder_Parent_Case__c = c.Id;
        C1.Account_s_Parent_Case__c = false;
        c1.Case_Category__c = 'Customer';
        c1.ownerId = us.Id;
        insert c1;
        
        Case c2 = [SELECT Id, Reminder_Parent_Case__c, Account_s_Parent_Case__c, Owner.Name FROM Case WHERE Id = :c1.Id];
        system.debug('c2 Case -> ' +c2);
        //c1.Forward_to_bank__c = true;
      
        //update c1;

        //Insert emailmessage for case
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'abc@gmail.com';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = c.Id; 
        insert email;
        
    } 
    
   /* @isTest
    public static void testEM3() { 
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
        ct.Case_Category__c = 'Membership';
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
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Subject = 'Om Test';  
        c.Status ='Resolved';
        c.Priority = 'Medium';
        c.Origin = 'Email';
        c.Case_Category__c = 'Membership';
        c.Case_Complaints__c = 'Call Center';
        c.Case_Type_Lookup__c = ct.Id;
        c.Sub_Type_Lookup__c = stl.id;
        c.Sub_Type_1_Lookup__c= st.Id;
        
        c.Account_s_Parent_Case__c = true;
        insert c;
        
        case c1 = new Case();
        c1.AccountId = acc.Id;
        c1.Subject = 'Om Test';  
        c1.Status ='Resolved';
        c1.Priority = 'Medium';
        c1.Origin = 'a';
        c1.Reminder_Parent_Case__c = c.Id;
        c1.Case_Category__c = 'Customer';
        insert c1;
        
        c1.Forward_to_bank__c = true;
        update c1;

        //Insert emailmessage for case
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'abc@gmail.com';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = c.Id; 
        insert email;
        
    } 
    
    @isTest
    public static void testEM2() { 
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
        ct.Case_Category__c = 'Customer';
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
        
        
        Case c = new Case();
        c.AccountId = acc.Id;
        c.Subject = 'Om Test';  
        c.Status ='Resolved';
        c.Priority = 'Medium';
        c.Origin = 'a';
        c.Case_Complaints__c = 'Call Center';
        c.Case_Type_Lookup__c = ct.Id;
        c.Sub_Type_Lookup__c = stl.id;
        c.Sub_Type_1_Lookup__c= st.Id;
        c.Case_Category__c = 'Customer';
        c.Account_s_Parent_Case__c = true;
        insert c;
        
        case c1 = new Case();
        c1.AccountId = acc.Id;
        c1.Subject = 'Om Test';  
        c1.Status ='Resolved';
        c1.Priority = 'Medium';
        c1.Origin = 'a';
        c1.Reminder_Parent_Case__c = c.Id;
        c1.Case_Category__c = 'Customer';
        insert c1;
        
        c1.Forward_to_bank__c = true;
        update c1;
        
        
        //Insert emailmessage for case
        EmailMessage email = new EmailMessage();
        email.FromAddress = 'abc@gmail.com';
        email.Incoming = True;
        email.ToAddress= 'test@xyz.org';
        email.Subject = 'Test email';
        email.HtmlBody = 'Test email body';
        email.ParentId = c.Id; 
        insert email;
        
    } 
   */
   
}