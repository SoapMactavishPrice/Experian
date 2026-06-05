@isTest
public class updateCaseController_Test {

     // Utility method to create Account
    private static Account createAccount() {
        Account a = new Account(Name = 'Test Account' + Math.random());
        insert a;
        return a;
    }

    // Utility method to create Case
    private static Case createCase() {

        // Create Account because validation requires AccountId
        Account a = createAccount();

        Case_Type__c cType = new Case_Type__c(Name = 'Test CR', Case_Category__c = 'Consumer', Case_Complaint__c = 'Report', isActive__c = true);
        insert cType;

        Sub_Type__c sType = new Sub_Type__c(Case_Type__c = cType.Id, isActive__c = true, Name = 'Sub Type Test');
        insert sType;

        Sub_Type1__c s1Type = new Sub_Type1__c(Name = 'Test Stype1', Sub_Type__c = sType.Id, isActive__c = true);
        insert s1Type;

        Contact con = new Contact(LastName = 'Test Con 1', Contact_Role__c = 'Consumer', Email = 'Test@gmail.com');
        insert con;

        Case c = new Case(
            Origin = 'Web',
            Status = 'New',
            Subject = 'Test Case',
            AccountId = a.Id,                    
            Send_Email_to_Consumer__c = false    
        );
        insert c;

        c.Displayed_Bank_Name__c = 'HDFC Bank';               
        c.Displayed_Account_number__c = '1234567890';          
        c.Displayed_Account_Type__c = 'Savings';     
        c.Date_of_the_email_received__c = Date.today();          
        c.Dispute_Detail__c = 'Test dispute details';            
        c.Case_Category__c = 'Consumer';
        c.Case_Complaints__c = 'Report';
        c.Case_Type_Lookup__c = cType.Id;
        c.Sub_Type_Lookup__c = sType.Id;
        c.Sub_Type_1_Lookup__c = s1Type.id;
        c.Name_of_Consumer__c = con.Id;
        c.Contact_Name__c = 'Test Con Name';
        c.ContactMobileNo__c = '9876543021';
        c.ContactEmailId__c = 'test123@gmail.com';
        c.Send_Email_to_Consumer__c = true; 

        update c; 

        return c;
    }

    // Utility method to create ContentDocument
    private static ContentDocument createDocument() {
        ContentVersion cv = new ContentVersion(
            Title = 'TestFile',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('Test content')
        );
        insert cv;

        cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        return [SELECT Id FROM ContentDocument WHERE Id = :cv.ContentDocumentId];
    }

    private static List<Case_Upload_Checker_Item__c> createCheckerWithChildren(Integer count) {

        Case_Upload_Checker__c parent = new Case_Upload_Checker__c(
            File_Type__c = 'Resolved in favour of the Consumer',
            File_Uploaded_By__c = UserInfo.getUserId(),
            File_Uploaded_Date_Time__c = System.now()
        );
        insert parent;

        List<Case_Upload_Checker_Item__c> items = new List<Case_Upload_Checker_Item__c>();

        for (Integer i = 0; i < count; i++) {
            Case c = createCase();
            Case_Upload_Checker_Item__c item = new Case_Upload_Checker_Item__c(
                Case_Upload_Checker__c = parent.Id,
                Case_Number__c = c.Id,
                Case_ID__c = c.Id,
                Last_Reply_from_Bank_Team__c = Date.today()
            );
            items.add(item);
        }

        insert items;
        return items;
    }

    @isTest
    static void test_updateCase_updateScenario() {

        Case c1 = createCase();

        String jsonString = '[{"Id":"' + c1.Id + '","Consumer_Dispute_Status":"Acknowledgement sent to Consumer"}]';

        Test.startTest();
        List<Object> response = updateCaseController.updateCase(true, jsonString, 'Resolved in favour of the Consumer');
        Test.stopTest();

        System.assertEquals('Success', ((Map<String,Object>)response[0]).get('Status'));
    }

   
    @isTest
    static void test_updateCase_attachFile() {

        Case c1 = createCase();
        ContentDocument cd = createDocument();

        String jsonString = '[{"Id":"' + c1.Id + '","ContentDocumentId":"' + cd.Id + '","ShareType":"V","Visibility":"AllUsers"}]';

        Test.startTest();
        List<Object> response = updateCaseController.updateCase(false, jsonString, 'Attach File to the Case');
        Test.stopTest();

        System.assertEquals('Success', ((Map<String,Object>)response[0]).get('Status'));
    }

    
    @isTest
    static void test_insertCaseUploadChecker() {

        Case c = createCase();  

        List<Map<String, String>> records = new List<Map<String, String>>();
        Map<String, String> row = new Map<String, String>();
        row.put('Id', c.Id);
        row.put('Last_Reply_from_Bank_Team__c', '2024-12-25');
        records.add(row);

        String csvText = 'Id,Last_Reply_from_Bank_Team__c\n' + c.Id + ',2024-12-25';
        String csvBase64 = EncodingUtil.base64Encode(Blob.valueOf(csvText));

        Test.startTest();
        String result = updateCaseController.insertCaseUploadChecker(
            'Resolved in favour of the Consumer',
            records,
            csvBase64,
            'TestUpload.csv'
        );
        Test.stopTest();

        System.assertEquals('Success', result);

        Case_Upload_Checker__c parent = [
            SELECT Id, File_Type__c
            FROM Case_Upload_Checker__c
            LIMIT 1
        ];
        System.assertEquals('Resolved in favour of the Consumer', parent.File_Type__c);

        List<Case_Upload_Checker_Item__c> items = [
            SELECT Case_ID__c, Case_Number__c
            FROM Case_Upload_Checker_Item__c
        ];

        System.assertEquals(1, items.size(), 'One child record expected');
        System.assertEquals(c.Id, items[0].Case_ID__c);
        System.assertEquals(c.Id, items[0].Case_Number__c);

        ContentDocumentLink cdl = [
            SELECT Id, LinkedEntityId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :parent.Id
            LIMIT 1
        ];

        System.assertEquals(parent.Id, cdl.LinkedEntityId);
    }


    @isTest
    static void test_getUploads() {

        Case_Upload_Checker__c parent = new Case_Upload_Checker__c(
            File_Type__c = 'Resolved in favour of the Consumer',  
            File_Uploaded_By__c = UserInfo.getUserId(),
            File_Uploaded_Date_Time__c = System.now()
        );
        insert parent;

        Test.startTest();
        List<Case_Upload_Checker__c> uploads = updateCaseController.getUploads();
        Test.stopTest();

        System.assert(uploads.size() > 0);
    }


    private class DummyHttpCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"status":"success"}');
            return res;
        }
    }

    @isTest
    static void test_approveUpload() {

        Test.setMock(HttpCalloutMock.class, new DummyHttpCalloutMock());

        List<Case_Upload_Checker_Item__c> items = createCheckerWithChildren(2);
        Id parentId = items[0].Case_Upload_Checker__c;

        Test.startTest();
        updateCaseController.approveUpload(parentId);
        Test.stopTest();

        Case_Upload_Checker__c parent =
            [SELECT Status__c FROM Case_Upload_Checker__c WHERE Id = :parentId];

        System.assertEquals('Approved', parent.Status__c);
    }


    @isTest
    static void test_updateStatus() {

        Case_Upload_Checker__c parent = new Case_Upload_Checker__c(
            File_Type__c = 'Resolved in favour of the Consumer',  
            File_Uploaded_By__c = UserInfo.getUserId(),
            File_Uploaded_Date_Time__c = System.now()
        );
        insert parent;

        Test.startTest();
        updateCaseController.updateStatus(parent.Id, 'Rejected');
        Test.stopTest();

        Case_Upload_Checker__c updated = [
            SELECT Status__c FROM Case_Upload_Checker__c WHERE Id = :parent.Id
        ];

        System.assertEquals('Rejected', updated.Status__c);
    }


    @isTest
    static void test_getChildRecords() {

        List<Case_Upload_Checker_Item__c> items = createCheckerWithChildren(1);
        Id parentId = items[0].Case_Upload_Checker__c;

        Test.startTest();
        List<Case_Upload_Checker_Item__c> result =
            updateCaseController.getChildRecords(parentId);
        Test.stopTest();

        System.assertEquals(1, result.size());
    }


    @isTest
    static void testUpdateCaseMethod() {

        Case c1 = new Case(
            Subject = 'Test Case 1',
            Origin = 'Phone',
            Contact_Name__c = 'Test User',
            ContactMobileNo__c = '9999999999',
            ContactEmailId__c = 'test@example.com'
        );
        insert c1;

        Case c2 = new Case(
            Subject = 'Test Case 2',
            Origin = 'Email',
            Contact_Name__c = 'Test User2',
            ContactMobileNo__c = '8888888888',
            ContactEmailId__c = 'test2@example.com'
        );
        insert c2;


        List<Map<String,Object>> jsonList = new List<Map<String,Object>>();
        
        Map<String,Object> rec1 = new Map<String,Object>();
        rec1.put('Id', c1.Id);
        rec1.put('Consumer_Dispute_Status', 'Resolved in favour of the Consumer');
        rec1.put('Last_Reply_from_Bank_Team', '01/11/2024');
        rec1.put('sendEmailtoConsumer', true);  

        Map<String,Object> rec2 = new Map<String,Object>();
        rec2.put('Id', c2.Id);
        rec2.put('Consumer_Dispute_Status', 'Complaint Withdrawn by Consumer');
        rec2.put('caseCSTComment', 'Some;Comment');

        jsonList.add(rec1);
        jsonList.add(rec2);

        String jsonString = JSON.serialize(jsonList);

        Test.startTest();
        List<Object> results = updateCaseController.updateCase(true, jsonString, 'Resolved in favour of the Consumer');
        Test.stopTest();

        System.assertNotEquals(null, results, 'Results should not be null');
        System.assert(results.size() > 0, 'Results list must return entries');
    }

    @isTest
    static void testUpdateCase_AttachFile() {
        // Create a Case
        Case c = new Case(
            Subject = 'Test Attach File',
            Origin = 'Web',
            Contact_Name__c = 'User',
            ContactMobileNo__c = '9999999999',
            ContactEmailId__c = 'u@x.com'
        );
        insert c;

        // Create ContentDocument + Version
        ContentVersion cv = new ContentVersion(
            Title = 'TestDoc',
            PathOnClient = 'test.pdf',
            VersionData = Blob.valueOf('Test')
        );
        insert cv;

        Id docId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;

        // Build JSON for Attach File
        List<Map<String,Object>> listJson = new List<Map<String,Object>>();
        Map<String,Object> map1 = new Map<String,Object>();
        map1.put('Id', c.Id);
        map1.put('ContentDocumentId', docId);
        map1.put('ShareType', 'V');
        map1.put('Visibility', 'AllUsers');

        listJson.add(map1);

        Test.startTest();
        List<Object> results = updateCaseController.updateCase(false, JSON.serialize(listJson), 'Attach File to the Case');
        Test.stopTest();

        System.assertNotEquals(null, results);
        System.assert(results.size() == 1);
    }

    @isTest
    static void testUpdateCase_AlreadyExecutedBranch() {

        // Case with Credit_Report_Generation_Date__c populated
        Case c = new Case(
            Subject = 'Exec Branch',
            Origin = 'Phone',
            Contact_Name__c = 'A',
            ContactMobileNo__c = '1111111111',
            ContactEmailId__c = 'a@a.com',
            Credit_Report_Generation_Date__c = Date.today(),  // triggers Already Executed
            Is_Error__c = true,
            Error__c = 'Some error'
        );
        insert c;

        // JSON List Input
        Map<String,Object> mapData = new Map<String,Object>{
            'Id' => c.Id,
            'Consumer_Dispute_Status' => 'Resolved in favour of the Consumer',
            'Last_Reply_from_Bank_Team' => '01/01/2024'
        };

        List<Map<String,Object>> jsonList = new List<Map<String,Object>>{ mapData };

        Test.startTest();
        List<Object> res = updateCaseController.updateCase(true, JSON.serialize(jsonList),
                                                        'Resolved in favour of the Consumer');
        Test.stopTest();

        System.assertNotEquals(null, res, 'Response should not be null');
        System.assert(res.size() == 1, 'Should return 1 result');
    }

    @isTest
    static void testUpdateCase_FullCoveragePaths() {

        Case c = new Case(
            Subject = 'Full Case',
            Origin = 'Email',
            Contact_Name__c = 'Full User',
            ContactMobileNo__c = '7777777777',
            ContactEmailId__c = 'full@x.com'
        );
        insert c;

        Map<String,Object> rec = new Map<String,Object>();
        rec.put('Id', c.Id);
        rec.put('MatchingCommentsub', 'matching');
        rec.put('LastReplyFromMatchingTeamforSub', '02/01/2024');
        rec.put('MatchingComment', 'cm1');
        rec.put('LastReplyFromMatchingTeam', '03/01/2024');

        rec.put('incidentNo', 'INC1001');
        rec.put('forwardToMatechTeam', true);

        rec.put('referToIO', true);
        rec.put('lastReplyFromBacnkTeam_ref', '04/01/2024');
        rec.put('RejectedRegion_ref', 'Reject');
        rec.put('disputeRejectedRegion_ref', 'RegionReject');

        rec.put('caseCSTComment', 'CST;Test');
        rec.put('caseCSTCommentv1', 'Hello;World');

        rec.put('telConversionDate', '05/01/2024');
        rec.put('ComplaintConsumerStatus', 'Resolved not in favour of the Consumer');

        rec.put('Junkcase', true);
        rec.put('JunkStatus', true);

        rec.put('Update_Open_to_Resolved', true);
        rec.put('Send_Email_Acknowledgement', true);

        rec.put('Contact_Name', 'New Name');
        rec.put('ContactEmailId', 'new@mail.com');
        rec.put('ContactMobileNo', '9999999999');
        rec.put('Contact_Gender', 'Male');
        rec.put('ContactPan', 'ABCDE1234F');
        rec.put('Contact_Date_of_Birth', '10/02/1995');
        rec.put('Contact_Address', 'Line1;Line2');

        rec.put('isSendEmail', true);
        rec.put('reSend', true);

        List<Map<String,Object>> jsonList = new List<Map<String,Object>>{ rec };

        Test.startTest();
        List<Object> result = updateCaseController.updateCase(true, JSON.serialize(jsonList), 'SomeOtherType');
        Test.stopTest();

        System.assert(result.size() == 1);
    }

    // Utility → Create a file + link to parent (needed for download URL)
    private static ContentVersion createTestFile(Id parentId) {
        Blob body = Blob.valueOf('Sample File Content');
        ContentVersion cv = new ContentVersion(
            Title = 'TestCSV',
            PathOnClient = 'TestCSV.csv',
            VersionData = body,
            IsMajorVersion = true
        );
        insert cv;

        cv = [
            SELECT Id, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :cv.Id
        ];

        // Link to parent
        insert new ContentDocumentLink(
            LinkedEntityId = parentId,
            ContentDocumentId = cv.ContentDocumentId,
            ShareType = 'V'
        );

        return cv;
    }


    //------------------------------------------------------------
    // 1️⃣ TEST getChildCaseUploadCheckerItemRecords
    //------------------------------------------------------------
    @IsTest
    static void test_getChildCaseUploadCheckerItemRecords() {

        // Create Parent
        Case_Upload_Checker__c parent = new Case_Upload_Checker__c(
            File_Type__c = 'Resolved in favour of the Consumer',
            File_Uploaded_By__c = UserInfo.getUserId(),
            File_Uploaded_Date_Time__c = System.now()
        );
        insert parent;

        // Create Child records
        insert new Case_Upload_Checker_Item__c(
            Case_Upload_Checker__c = parent.Id,
            Last_Reply_from_Bank_Team__c = Date.today()
        );

        insert new Case_Upload_Checker_Item__c(
            Case_Upload_Checker__c = parent.Id,
            Last_Reply_from_Bank_Team__c = Date.today().addDays(-1)
        );

        Test.startTest();
        List<Case_Upload_Checker_Item__c> result =
            updateCaseController.getChildCaseUploadCheckerItemRecords(parent.Id);
        Test.stopTest();

        System.assertEquals(2, result.size(), 'Should return 2 child records');
    }



    //------------------------------------------------------------
    // 2️⃣ TEST getUploadedCsvDownloadUrl
    //------------------------------------------------------------
    @IsTest
    static void test_getUploadedCsvDownloadUrl() {

        // Create Parent
        Case_Upload_Checker__c parent = new Case_Upload_Checker__c(
            File_Type__c = 'Resolved in favour of the Consumer',
            File_Uploaded_By__c = UserInfo.getUserId(),
            File_Uploaded_Date_Time__c = System.now()
        );
        insert parent;

        // Create & link file
        ContentVersion cv = createTestFile(parent.Id);

        Test.startTest();
        String url = updateCaseController.getUploadedCsvDownloadUrl(parent.Id);
        Test.stopTest();

        System.assert(
            url.contains('/sfc/servlet.shepherd/version/download/'),
            'URL must contain Salesforce download path'
        );

        System.assert(
            url.contains(cv.Id),
            'Returned URL should include the ContentVersion Id'
        );
    }



    //------------------------------------------------------------
    // 3️⃣ TEST approveUploadChunk
    //------------------------------------------------------------
    @IsTest
    static void test_approveUploadChunk() {

        // Create user
        User u = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];

        // Create Parent record
        Case_Upload_Checker__c parent = new Case_Upload_Checker__c(
            File_Type__c = 'Resolved in favour of the Consumer',
            File_Uploaded_By__c = UserInfo.getUserId(),
            File_Uploaded_Date_Time__c = System.now()
        );
        insert parent;

        // Create Case for success path
        Case c = new Case(Origin = 'Phone');
        insert c;

        // Child 1 → Success Path
        Case_Upload_Checker_Item__c child1 = new Case_Upload_Checker_Item__c(
            Case_Upload_Checker__c = parent.Id,
            Case_Number__c = c.Id,
            Last_Reply_from_Bank_Team__c = Date.today()
        );
        insert child1;

        // Child 2 → Failure (No Case lookup)
        Case_Upload_Checker_Item__c child2 = new Case_Upload_Checker_Item__c(
            Case_Upload_Checker__c = parent.Id
        );
        insert child2;

        Test.startTest();
        List<Id> childIds = new List<Id>{ child1.Id, child2.Id };

        List<updateCaseController.ChunkResult> results =
            updateCaseController.approveUploadChunk(childIds, parent.Id);
        Test.stopTest();

        System.assertEquals(2, results.size(), 'Should return results for each child');
    }



}