@IsTest
public class AIUtility_Test{
    @isTest
    static void testSendResponseEmail() {
        // Setup test data
         Account acc = new Account();
        acc.Name = 'Kabib';
        acc.Instant_Reports__c  = true; 
        insert acc; 
        
         Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u_a = new User(Alias = 'standt1', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8',
                            LastName='Rajput', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='Deepshikha@testorg.com');
        insert u_a;
        System.debug('u '+u_a); 
        
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

   /*     Case caseRecord = new Case(
            AccountId = acc.Id,
            Subject = 'Test Subject',
            SuppliedEmail = 'test@example.com'
        );
        insert caseRecord;*/
        
        Case caseRecord = new Case();
        caseRecord.Displayed_Loan_Balance__c =Decimal.valueof(5000);
        caseRecord.Displayed_EMI_Amount__c =Decimal.valueof(9000);
        caseRecord.Status = 'Open';
        caseRecord.OwnerId=u_a.id;
        caseRecord.AccountId = acc.id;
        caseRecord.Subject = 'Update';
        caseRecord.Case_Category__c = 'Consumer';
        caseRecord.Case_Complaints__c = null;
        caseRecord.Origin = 'Email';
        caseRecord.Consumer_Dispute_Status__c= 'Resolved not in favour of the Consumer';
        caseRecord.Rejection_Reason__c = 'Rejected by Experian';
        insert caseRecord;

        // Query for an existing OrgWideEmailAddress
        OrgWideEmailAddress owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'consumer.support@in.experian.com' LIMIT 1];

        // Mock Callout
        Test.setMock(HttpCalloutMock.class, new MockEinsteinLLMResponse());

        // Test method
        Test.startTest();
        AIUtility.sendResponseEmail(new Set<Id>{caseRecord.Id});
        Test.stopTest();

        // Assertions
        // Verify the Case exists
        Case fetchedCase = [SELECT Id, Subject, SuppliedEmail FROM Case WHERE Id = :caseRecord.Id];
        System.assertNotEquals(null, fetchedCase, 'Case record should exist.');

        // Additional validation for OrgWideEmailAddress and email logic can be added
    }
    
    @isTest
    static void testInspectResults() {
        // Mock SendEmailResult objects
        Messaging.SendEmailResult resultSuccess = (Messaging.SendEmailResult) JSON.deserialize(
            '{"success":true,"errors":[]}', Messaging.SendEmailResult.class
        );
        Messaging.SendEmailResult resultFailure = (Messaging.SendEmailResult) JSON.deserialize(
            '{"success":false,"errors":[{"message":"Email failed"}]}', Messaging.SendEmailResult.class
        );

        // Create an array of results
        Messaging.SendEmailResult[] results = new List<Messaging.SendEmailResult> { resultSuccess, resultFailure };

        // Call the helper method
        Boolean sendResult = AIUtility.inspectResults(results);

        // Assertions
        System.assertEquals(false, sendResult, 'Expected sendResult to be false due to failure in one of the results');
    }
    
     @isTest
    static void testCaseClassification() {
        // Create test data: Case_Type__c record
 Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Balance Issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Current Balance';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        Sub_Type__c	 sub1 =new Sub_Type__c	();
        sub1.Name = 'Enquiry Changes';
        sub1.Case_Type__c = ct.Id;
        insert sub1;
        
        Sub_Type1__c sub2 = new Sub_Type1__c();
        sub2.Name = 'Enquiry Date';
        sub2.Sub_Type__c = sub1.Id;
        insert sub2;
        
        Sub_Type1__c sub3 = new Sub_Type1__c();
        sub3.Name = 'Loan Type';
        sub3.Sub_Type__c = sub1.Id;
        insert sub3;
        
        Sub_Type1__c sub4 = new Sub_Type1__c();
        sub4.Name = 'Changes';
        sub4.Sub_Type__c = sub1.Id;
        insert sub4;
        
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

       
        Case testCase1 = new Case(
            Subject = 'Test Case 1',
            Case_Type_Lookup__c = ct.Id,
            Sub_Type_Lookup__c = stl1.Id,
            Sub_Type_1_Lookup__c = st1.Id,
            SuppliedName = 'John Doe',
            Case_Category__c = 'Consumer',
            Origin = 'Email',
            Junk_Case__c = false
        );
        insert testCase1;

        Case testCase2 = new Case(
            Subject = 'Test Case 2',
            Case_Type_Lookup__c = ct.Id, 
            Sub_Type_Lookup__c = stl1.Id,
            Sub_Type_1_Lookup__c = st1.Id,
            SuppliedName = 'Jane Doe',
            Case_Category__c = 'Consumer',
            Origin = 'Email',
            Junk_Case__c = false
        );
        insert testCase2;

      /*  
        CaseClassificationBatch batch = new CaseClassificationBatch();

        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();*/
        
        Test.startTest();
        Database.executeBatch(new CaseClassificationBatch(), 100); // Optional scope size
        Test.stopTest();

    }
    
    // Mock for Einstein API Response
    
    private class MockEinsteinLLMResponse implements HttpCalloutMock {
        public HTTPResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody(
                '{"generations": [{"text": "Mock AI Response"}], "generationErrors": []}'
            );
            return res;
        }
    }
}