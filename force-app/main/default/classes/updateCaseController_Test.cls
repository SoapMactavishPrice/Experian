@isTest
public class updateCaseController_Test {
    
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
        
        Account acc = new Account();
        acc.Name = 'Kabib';
        acc.Instant_Reports__c  = true;
        acc.Email_Dispute__c='abc@gmail.com';
        acc.Bureau_Member_Id__c = '1234';
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
        string js2 = '[{"Serial_No":203,"CaseNumber":"'+cs.CaseNumber+'","enquiry_User_Id":"2","enquiry_Loan_Amount":"123","Id":"'+cs.Id+'","Last_Reply_from_Bank_Team":"","OwnerId":"'+userInfo.getUserId()+'","sendEmailtoConsumer":true,"MatchingCommentsub":"test","LastReplyFromMatchingTeamforSub":"10-02-2025","MatchingComment":"1234","LastReplyFromMatchingTeam":"10-02-2024","incidentNo":"13","forwardToMatechTeam":true,"sendEmailtoConsumerInc":true,"referToIO":true,"temp_forward_to_bank":true,"forward_to_bank":true,"Consumer_Dispute_Status":"Resolved not in favour of the Consumer","Rejection_Reason":"Rejected by Lender","Status":"","Last_Reply_from_Bank_Team":"30-10-2024","Message":"","url":"/lightning/r/3662660/view","index":202}]';
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.txt',
            VersionData = Blob.valueOf('This is a test file content')
        );
        insert contentVersion;

        // Retrieve the ContentDocumentId from the inserted ContentVersion
          ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];
        String contentDocumentId = cv.ContentDocumentId;
        
        ContentDocument contentDocument = [SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId LIMIT 1];

        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = cn.Id,  // Linking to the Account
            ContentDocumentId = contentDocument.Id, // Use the ContentDocumentId from ContentVersion
            ShareType = 'V',  // Viewer permissions (you can use 'V', 'C', or 'I' for 'Viewer', 'Collaborator', 'Inferred')
            Visibility = 'AllUsers'  // Example visibility
        );

        // Insert the ContentDocumentLink
        insert cdl;

        
        updateCaseController.updateCase(true,js2,'vc Attach File to the Case');
        
        string js1 = '[{"Id":"'+cs.Id+'","ContentDocumentId":"'+contentDocument.Id+'","caseCSTComment":"abc-c","ShareType":"V","Visibility":"AllUsers"}]';
        
        updateCaseController.updateCase(true,js1,'Attach File to the Case');
        
    }
    
    @isTest
    public static void isValidate2(){
        
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
        acc.Bureau_Member_Id__c = '1234';
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
        string js2 = '[{"Serial_No":203,"CaseNumber":"'+cs.CaseNumber+'","enquiry_User_Id":"2","enquiry_Loan_Amount":"123","Id":"'+cs.Id+'","Last_Reply_from_Bank_Team":"","OwnerId":"'+userInfo.getUserId()+'","sendEmailtoConsumer":true,"MatchingCommentsub":"test","LastReplyFromMatchingTeamforSub":"10-02-2025","MatchingComment":"1234","LastReplyFromMatchingTeam":"10-02-2024","incidentNo":"13","forwardToMatechTeam":true,"sendEmailtoConsumerInc":true,"referToIO":true,"temp_forward_to_bank":true,"forward_to_bank":true,"lastReplyFromBacnkTeam_ref":"02-03-2025","Consumer_Dispute_Status":"Resolved not in favour of the Consumer","Rejection_Reason":"Rejected by Lender","Status":"","Last_Reply_from_Bank_Team":"30-10-2024","Message":"","url":"/lightning/r/3662660/view","index":202}]';
        
        
        updateCaseController.updateCase(true,js2,'Resolved in favour of the Consumer');
        
        
        string js3 = '[{"Serial_No":203,"CaseNumber":"'+cs.CaseNumber+'","caseCSTComment":"abc-c","caseCSTCommentv1":"abc-c","Contact_Address":"abc-c","enquiry_User_Id":"2","enquiry_Loan_Amount":"123","Id":"'+cs.Id+'","Last_Reply_from_Bank_Team":"","OwnerId":"'+userInfo.getUserId()+'","sendEmailtoConsumer":true,"MatchingCommentsub":"test","LastReplyFromMatchingTeamforSub":"10-02-2025","MatchingComment":"1234","LastReplyFromMatchingTeam":"10-02-2024","incidentNo":"13","forwardToMatechTeam":true,"sendEmailtoConsumerInc":true,"referToIO":true,"temp_forward_to_bank":true,"forward_to_bank":true,"Consumer_Dispute_Status":"Resolved in favour of the Consumer","Rejection_Reason":"Rejected by Lender","Status":"","Last_Reply_from_Bank_Team":"30-10-2024","Message":"","url":"/lightning/r/3662660/view","index":202}]';
        
        
        updateCaseController.updateCase(true,js3,'Resolved in favour of the Consumer');
        
        
    }

}