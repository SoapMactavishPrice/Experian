@istest
public class CreateAndUpdateContactOnCase_Test {
    
    public static testmethod void TestMethod1() {
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
        insert acc;
        
        System.runAs(u) {
            
            List<Case> caseList = new List<Case>();
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
            cs.Displayed_Email_Id__c = 'Vijaiwada1@finessedirect.com';
            cs.Correct_email_id__c = 'Vijaiwada1@finessedirect.com';
            cs.Case_Type_Lookup__c=ct.Id;
            cs.Sub_Type_Lookup__c=st.Id;
            cs.Sub_Type_1_Lookup__c=st1.Id; 
            cs.Case_Category__c='Consumer';
            cs.Case_Complaints__c='Report';
            cs.Origin = 'Portal';
            cs.Name_of_Consumer__c = null;
            cs.OwnerId = U2.Id;
            cs.Displayed_Name__c = 'Balram Prajapati';
            caseList.add(cs);
            //INSERT cs;
            
            Case cs1 = new Case();
            cs1.subject = 'Test on mapping of Consumer';
            cs1.Status = 'Open';
            cs1.Case_Type__c='Complaint';
            cs1.Sub_Type__c='Document';
            cs1.Sub_Type_1__c='Agreement not received';
            cs1.Forward_to_bank__c=false;
            cs1.Junk_Case__c = false;
            cs1.Forward_to_Data_Merger__c = false;
            cs1.Forward_to_GPD_Team__c = false;
            cs1.Displayed_Email_Id__c = 'Vijaiwada3@finessedirect.com';
            cs1.Correct_email_id__c = 'Vijaiwada3@finessedirect.com';
            cs1.Correct_email_id__c = 'Vijaiwada3@finessedirect.com';
            cs1.Case_Type_Lookup__c=ct.Id;
            cs1.Sub_Type_Lookup__c=st.Id;
            cs1.Sub_Type_1_Lookup__c=st1.Id; 
            cs1.Case_Category__c='Consumer';
            cs1.Case_Complaints__c='Report';
            cs1.OwnerId = U2.Id;
            cs1.Origin = 'Portal';
            cs1.Name_of_Consumer__c = null;
            cs1.Displayed_Bank_Name__c = 'ICICI';
            cs1.Displayed_Name__c = 'Balram Prajapati';
            caseList.add(cs1);
            //INSERT cs1;
            
            Case cs2 = new Case();
            cs2.subject = 'Test on mapping of Consumer';
            cs2.Status = 'Open';
            cs2.Case_Type__c='Complaint';
            cs2.Sub_Type__c='Document';
            cs2.Sub_Type_1__c='Agreement not received';
            cs2.Forward_to_bank__c=false;
            cs2.Junk_Case__c = false;
            cs2.Forward_to_Data_Merger__c = false;
            cs2.Forward_to_GPD_Team__c = false;
            cs2.Current_Application_Email__c = 'adityawada@finessedirect.com';
            cs.ContactEmailId__c='Vijaiwada6@finessedirect.com';
            cs2.Case_Type_Lookup__c=ct.Id;
            cs2.Sub_Type_Lookup__c=st.Id;
            cs2.Sub_Type_1_Lookup__c=st1.Id; 
            cs2.Case_Category__c='Consumer';
            cs2.Case_Complaints__c='Report';
            cs2.OwnerId = U2.Id;
            cs2.Origin = 'Portal';
            cs2.Name_of_Consumer__c = null;
            cs2.Displayed_Name__c = 'Balram Prajapati';
            caseList.add(cs2);
            //INSERT cs;
            
            Case cs3 = new Case();
            cs3.subject = 'Test on mapping of Consumer';
            cs3.Status = 'Open';
            cs3.Case_Type__c='Complaint';
            cs3.Sub_Type__c='Document';
            cs3.Sub_Type_1__c='Agreement not received';
            cs3.Forward_to_bank__c=false;
            cs3.Junk_Case__c = false;
            cs3.Forward_to_Data_Merger__c = false;
            cs3.Forward_to_GPD_Team__c = false;
            cs3.Correct_email_id__c = 'Vijaiwada7@finessedirect.com';
            cs3.ContactEmailId__c='Vijaiwada7@finessedirect.com';
            cs3.Case_Type_Lookup__c=ct.Id;
            cs3.Sub_Type_Lookup__c=st.Id;
            cs3.Sub_Type_1_Lookup__c=st1.Id; 
            cs3.Case_Category__c='Consumer';
            cs3.Case_Complaints__c='Report';
            cs3.OwnerId = U2.Id;
            cs3.Origin = 'Portal';
            cs3.Name_of_Consumer__c = null;
            cs3.Displayed_Name__c = 'Balram Prajapati';
            caseList.add(cs3);
            //INSERT cs3;
            
            INSERT caseList;
            
            
            Case inserted = [SELECT Id,Account.Name FROM Case WHERE Id = :cs.Id];
            
            CreateAndUpdateContactOnCase capcase = new CreateAndUpdateContactOnCase();
            capcase.assignRelatedRecordsToCase(caseList);
            //capcase.createRelatedRecords(listOfCase);
            
        }        
    }
    
    public static testmethod void TestMethod2() {
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
        con.Email = 'vijaiwada22@finessedirect.com';
        con.Contact_Role__c = 'Consumer';
        INSERT con;
        
        contact con1 = new contact();
        con1.LastName = 'adityawada';
        con1.Email = 'adityawada22@finessedirect.com';
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
        insert acc1;
        
        System.runAs(u) {
            
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
            cs.Origin = 'Portal';
            cs.Name_of_Consumer__c = null;
            cs.Displayed_Name__c = 'Balram Prajapati';
            INSERT cs;
            
            Case inserted = [SELECT Id,Account.Name FROM Case WHERE Id = :cs.Id];
            
            system.debug('inserted'+inserted);    
            
            CreateAndUpdateContactOnCase capcase = new CreateAndUpdateContactOnCase();
            //capcase.assignRelatedRecordsToCase(caseList);
            //capcase.createRelatedRecords(listOfCase);
        }
        
    }
    
    /*
    public static testmethod void TestMethod3() {
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
            LastName = 'Consumer Support Queue',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = [Select Id from Profile where Name = 'System Administrator'].Id,
            UserName='testff@akshareducation.com');
        INSERT u2;
        
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
        insert acc1;
        
        System.runAs(u) {
            List<Case> caseList = new List<Case>();
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
            cs.Displayed_Email_Id__c = 'Vijaiwada9@finessedirect.com';
            cs.Correct_email_id__c = 'Vijaiwada9@finessedirect.com';
            cs.Case_Type_Lookup__c=ct.Id;
            cs.Sub_Type_Lookup__c=st.Id;
            cs.Sub_Type_1_Lookup__c=st1.Id; 
            cs.Case_Category__c='Consumer';
            cs.Case_Complaints__c='Report';
            cs.Origin = 'Portal';
            cs.Name_of_Consumer__c = null;
            cs.OwnerId = U2.Id;
            cs.Displayed_Name__c = 'Balram Prajapati';
            caseList.add(cs);
            //INSERT cs;
            
            Case cs1 = new Case();
            cs1.subject = 'Test on mapping of Consumer';
            cs1.Status = 'Open';
            cs1.Case_Type__c='Complaint';
            cs1.Sub_Type__c='Document';
            cs1.Sub_Type_1__c='Agreement not received';
            cs1.Forward_to_bank__c=false;
            cs1.Junk_Case__c = false;
            cs1.Forward_to_Data_Merger__c = false;
            cs1.Forward_to_GPD_Team__c = false;
            cs1.Displayed_Email_Id__c = 'Vijaiwada11@finessedirect.com';
            cs1.Correct_email_id__c = 'Vijaiwada11@finessedirect.com';
            cs1.Correct_email_id__c = 'Vijaiwada11@finessedirect.com';
            cs1.Case_Type_Lookup__c=ct.Id;
            cs1.Sub_Type_Lookup__c=st.Id;
            cs1.Sub_Type_1_Lookup__c=st1.Id; 
            cs1.Case_Category__c='Consumer';
            cs1.Case_Complaints__c='Report';
            cs1.OwnerId = U2.Id;
            cs1.Origin = 'Portal';
            cs1.Name_of_Consumer__c = null;
            cs1.Displayed_Bank_Name__c = 'ICICI';
            cs1.Displayed_Name__c = 'Balram Prajapati';
            caseList.add(cs1);
            //INSERT cs1;
            
            Case cs2 = new Case();
            cs2.subject = 'Test on mapping of Consumer';
            cs2.Status = 'Open';
            cs2.Case_Type__c='Complaint';
            cs2.Sub_Type__c='Document';
            cs2.Sub_Type_1__c='Agreement not received';
            cs2.Forward_to_bank__c=false;
            cs2.Junk_Case__c = false;
            cs2.Forward_to_Data_Merger__c = false;
            cs2.Forward_to_GPD_Team__c = false;
            cs2.Current_Application_Email__c = 'adityawada23@finessedirect.com';
            cs.ContactEmailId__c='Vijaiwada14@finessedirect.com';
            cs2.Case_Type_Lookup__c=ct.Id;
            cs2.Sub_Type_Lookup__c=st.Id;
            cs2.Sub_Type_1_Lookup__c=st1.Id; 
            cs2.Case_Category__c='Consumer';
            cs2.Case_Complaints__c='Report';
            cs2.OwnerId = U2.Id;
            cs2.Origin = 'Portal';
            cs2.Name_of_Consumer__c = null;
            cs2.Displayed_Name__c = 'Balram Prajapati';
            caseList.add(cs2);
            //INSERT cs;
            
            Case cs3 = new Case();
            cs3.subject = 'Test on mapping of Consumer';
            cs3.Status = 'Open';
            cs3.Case_Type__c='Complaint';
            cs3.Sub_Type__c='Document';
            cs3.Sub_Type_1__c='Agreement not received';
            cs3.Forward_to_bank__c=false;
            cs3.Junk_Case__c = false;
            cs3.Forward_to_Data_Merger__c = false;
            cs3.Forward_to_GPD_Team__c = false;
            cs3.Correct_email_id__c = 'Vijaiwada15@finessedirect.com';
            cs3.ContactEmailId__c='Vijaiwada15@finessedirect.com';
            cs3.Case_Type_Lookup__c=ct.Id;
            cs3.Sub_Type_Lookup__c=st.Id;
            cs3.Sub_Type_1_Lookup__c=st1.Id; 
            cs3.Case_Category__c='Consumer';
            cs3.Case_Complaints__c='Report';
            cs3.OwnerId = U2.Id;
            cs3.Origin = 'Portal';
            cs3.Name_of_Consumer__c = null;
            cs3.Displayed_Name__c = 'Balram Prajapati';
            caseList.add(cs3);
            //INSERT cs3;
            
            INSERT caseList;
            
            
            Case inserted = [SELECT Id,Account.Name FROM Case WHERE Id = :cs.Id];
            
            system.debug('inserted'+inserted);    
            
            CreateAndUpdateContactOnCase capcase = new CreateAndUpdateContactOnCase();
            capcase.assignRelatedRecordsToCase(caseList);
            //capcase.createRelatedRecords(listOfCase);
            
        }
    }
	*/
}