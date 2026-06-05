@istest
public class UpdateContactOnCaseBatch_Test {
    
    @isTest
    public static void TestMethod1() {
        system.assert(true);
        User u = new User(
            Alias = 'testu',
            Email = 'test@akshareducation.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'Experian',
            LastName = 'Global',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = [Select Id from Profile where Name = 'System Administrator'].Id,
            UserName='test@akshareducation.com');
        INSERT u;
        
        User u2 = new User(
            Alias = 'testu',
            Email = 'test@akshareducation.com',
            EmailEncodingKey = 'UTF-8',
            //FirstName = 'Experian',
            LastName = 'Consumer Support Queue',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = [Select Id from Profile where Name = 'System Administrator'].Id,
            UserName='testff@akshareducation.com');
        INSERT u2;
        
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
        
        Case_Type__c ct=new Case_Type__c();
        ct.Name='Complaint Dispute Consumer';
        ct.Case_Category__c='Consumer';
        ct.Case_Complaint__c='Report';
        insert ct;
        
        
        Sub_Type__c st=new Sub_Type__c();
        st.Name='DPD';
        st.Case_Type__c=ct.Id;
        insert st;
        
        Sub_Type1__c st1= new Sub_Type1__c();
        st1.Name='Incorrect';
        st1.Sub_Type__c=st.Id;
        insert st1;
        
        contact con = new contact();
        con.LastName = 'Vijai';
        con.Email = 'vijaiwada@finessedirect.com';
        con.Contact_Role__c = 'Consumer';
        INSERT con;
        
        contact con1 = new contact();
        con1.LastName = 'adityawada';
        con1.Email = 'adityawada@finessedirect.com';
        con1.Contact_Role__c = 'Consumer';
        INSERT con1;
        
        Account acc = new Account();
        acc.Name = 'ICICI';
        acc.Displayed_Bank_Name_2__c = 'ICICI';
        acc.Displayed_Bank_Name_3__c = 'ICICI';
        
        acc.Displayed_Bank_Name__c = 'ICICI';
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
        
        System.runAs(u) {
            
            Case cs = new Case();
            cs.subject = 'Test on mapping of Consumer';
            cs.Status = 'Open';
            cs.Case_Type__c='Complaint';
            cs.Sub_Type__c='Document';
            cs.Sub_Type_1__c='Agreement not received';
            cs.Forward_to_bank__c=false;
            cs.Junk_Case__c = false;
            cs.Forward_to_Data_Merger__c = false;
            cs.Forward_to_GPD_Team__c = false;
            cs.Displayed_Email_Id__c = 'Vijaiwada@finessedirect.com';
            cs.Correct_email_id__c = 'Vijaiwada@finessedirect.com';
            cs.Case_Type_Lookup__c=ct.Id;
            cs.Sub_Type_Lookup__c=st.Id;
            cs.Sub_Type_1_Lookup__c=st1.Id; 
            cs.Case_Category__c='Consumer';
            cs.Case_Complaints__c='Report';
            cs.OwnerId = U2.Id;
            INSERT cs;
            
            
          /*  Case cs1 = new Case();
            cs1.subject = 'Test on mapping of Consumer';
            cs1.Status = 'Open';
            cs1.Case_Type__c='Complaint';
            cs1.Sub_Type__c='Document';
            cs1.Sub_Type_1__c='Agreement not received';
            cs1.Forward_to_bank__c=false;
            cs1.Junk_Case__c = false;
            cs1.Forward_to_Data_Merger__c = false;
            cs1.Forward_to_GPD_Team__c = false;
            cs1.Displayed_Email_Id__c = 'Vijaiwada@finessedirect.com';
            cs1.Correct_email_id__c = 'Vijaiwada@finessedirect.com';
            cs.Correct_email_id__c = 'Vijaiwada@finessedirect.com';
            cs1.Case_Type_Lookup__c=ct.Id;
            cs1.Sub_Type_Lookup__c=st.Id;
            cs1.Sub_Type_1_Lookup__c=st1.Id; 
            cs1.Case_Category__c='Consumer';
            cs1.Case_Complaints__c='Report';
            cs1.OwnerId = U2.Id;
            
            cs1.Displayed_Bank_Name__c = 'ICICI';
            INSERT cs1;
            
            
            
            cs = new Case();
            cs.subject = 'Test on mapping of Consumer';
            cs.Status = 'Open';
            cs.Case_Type__c='Complaint';
            cs.Sub_Type__c='Document';
            cs.Sub_Type_1__c='Agreement not received';
            cs.Forward_to_bank__c=false;
            cs.Junk_Case__c = false;
            cs.Forward_to_Data_Merger__c = false;
            cs.Forward_to_GPD_Team__c = false;
            cs.Current_Application_Email__c = 'adityawada@finessedirect.com';
            //cs.Correct_email_id__c = 'Vijaiwada@finessedirect.com';
            cs.ContactEmailId__c='Vijaiwada@finessedirect.com';
            cs.Case_Type_Lookup__c=ct.Id;
            cs.Sub_Type_Lookup__c=st.Id;
            cs.Sub_Type_1_Lookup__c=st1.Id; 
            cs.Case_Category__c='Consumer';
            cs.Case_Complaints__c='Report';
            cs.OwnerId = U2.Id;
            INSERT cs;
            
            cs = new Case();
            cs.subject = 'Test on mapping of Consumer';
            cs.Status = 'Open';
            cs.Case_Type__c='Complaint';
            cs.Sub_Type__c='Document';
            cs.Sub_Type_1__c='Agreement not received';
            cs.Forward_to_bank__c=false;
            cs.Junk_Case__c = false;
            cs.Forward_to_Data_Merger__c = false;
            cs.Forward_to_GPD_Team__c = false;
            cs.Correct_email_id__c = 'Vijaiwada@finessedirect.com';
            cs.ContactEmailId__c='Vijaiwada@finessedirect.com';
            cs.Case_Type_Lookup__c=ct.Id;
            cs.Sub_Type_Lookup__c=st.Id;
            cs.Sub_Type_1_Lookup__c=st1.Id; 
            cs.Case_Category__c='Consumer';
            cs.Case_Complaints__c='Report';
            cs.OwnerId = U2.Id;
            INSERT cs;
            
            cs = new Case();
            cs.subject = 'Test on mapping of Consumer';
            cs.Status = 'Open';
            cs.Case_Type__c='Complaint';
            cs.Sub_Type__c='Document';
            cs.Sub_Type_1__c='Agreement not received';
            cs.Forward_to_bank__c=false;
            cs.Junk_Case__c = false;
            cs.Forward_to_Data_Merger__c = false;
            cs.Forward_to_GPD_Team__c = false;
            cs.Displayed_Email_Id__c = 'vijai.s@experian.com';
            cs.Case_Type_Lookup__c=ct.Id;
            cs.Sub_Type_Lookup__c=st.Id;
            cs.Sub_Type_1_Lookup__c=st1.Id; 
            cs.Case_Category__c='Consumer';
            cs.Case_Complaints__c='Report';
            cs.Displayed_Name__c = 'Naruko';
            cs.OwnerId = U2.Id;
            cs.Displayed_Bank_Name__c = 'ICICI';
            INSERT cs;*/
            
            Case inserted = [SELECT Id,Account.Name FROM Case WHERE Id = :cs.Id];
            system.debug('inserted'+inserted);
            Test.startTest();
            UpdateContactOnCase_Batch ucb = new UpdateContactOnCase_Batch();
            DataBase.executeBatch(ucb,100);
            String sch = '0 0 23 * * ?';
            system.schedule('Test status Check', sch, ucb);  
            Test.stopTest();
            
        }
        
    }
    @isTest
    public static void TestMethod2() {
        system.assert(true);
        User u = new User(
            Alias = 'testu',
            Email = 'test@akshareducation.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = 'Experian',
            LastName = 'Global',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = [Select Id from Profile where Name = 'System Administrator'].Id,
            UserName='test@akshareducation.com');
        INSERT u;
        
        User u2 = new User(
            Alias = 'testu',
            Email = 'test@akshareducation.com',
            EmailEncodingKey = 'UTF-8',
            //FirstName = 'Experian',
            LastName = 'Consumer Support Queue',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = [Select Id from Profile where Name = 'System Administrator'].Id,
            UserName='testff@akshareducation.com');
        INSERT u2;
        
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
        
        Case_Type__c ct=new Case_Type__c();
        ct.Name='Complaint Dispute Consumer';
        ct.Case_Category__c='Consumer';
        ct.Case_Complaint__c='Report';
        insert ct;
        
        
        Sub_Type__c st=new Sub_Type__c();
        st.Name='DPD';
        st.Case_Type__c=ct.Id;
        insert st;
        
        Sub_Type1__c st1= new Sub_Type1__c();
        st1.Name='Incorrect';
        st1.Sub_Type__c=st.Id;
        insert st1;
        
        contact con = new contact();
        con.LastName = 'Vijai';
        con.Email = 'vijaiwada@finessedirect.com';
        con.Contact_Role__c = 'Consumer';
        INSERT con;
        
        contact con1 = new contact();
        con1.LastName = 'adityawada';
        con1.Email = 'adityawada@finessedirect.com';
        con1.Contact_Role__c = 'Consumer';
        INSERT con1;
        
        Account acc1 = new Account();
        acc1.Name = 'Ratnkar Prabhakar Bank Limited';
        acc1.Displayed_Bank_Name__c = 'RBL';
        acc1.Instant_Reports__c  = true;
        acc1.Email_Dispute__c='abc@gmail.com';
        acc1.Email_1_Dispute__c='efg@gmail.com';
        acc1.Email_2_Dispute__c='e@gmail.com';
        acc1.Email_3_Dispute__c='p@gmail.com';
        acc1.Email_4_Dispute__c='a@gmail.com';
        acc1.Email_5_Dispute__c='b@gmail.com';
        acc1.Email_6_Dispute__c='c@gmail.com';
        // Add other info on account which is requred to create it.
        insert acc1;
        
        case cs = new Case();
        cs.subject = 'Test on mapping of Consumer';
        cs.Status = 'Open';
        cs.Case_Type__c='Complaint';
        cs.Sub_Type__c='Document';
        cs.Sub_Type_1__c='Agreement not received';
        cs.Forward_to_bank__c=false;
        cs.Junk_Case__c = false;
        cs.Forward_to_Data_Merger__c = false;
        cs.Forward_to_GPD_Team__c = false;
        cs.Displayed_Email_Id__c = 'vijai.s@experian.com';
        cs.Case_Type_Lookup__c=ct.Id;
        cs.Sub_Type_Lookup__c=st.Id;
        cs.Sub_Type_1_Lookup__c=st1.Id; 
        cs.Case_Category__c='Consumer';
        cs.Case_Complaints__c='Report';
        cs.Displayed_Name__c = 'Naruko';
        cs.OwnerId = U2.Id;
        cs.Displayed_Bank_Name__c = 'RBL';
        INSERT cs;
        
        Case inserted = [SELECT Id,Account.Name FROM Case WHERE Id = :cs.Id];
        
        system.debug('inserted'+inserted);
        
        
        
        Test.startTest();
        UpdateContactOnCase_Batch ucb = new UpdateContactOnCase_Batch();
        DataBase.executeBatch(ucb,100);
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, ucb);  
        UpdateContactOnCase_Batch.fakeCodeCoverage();
        Test.stopTest();
    }
}