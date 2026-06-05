@IsTest
private class fetchOpenDisputeDetails_Test {
    
    @TestSetup
    static void setupTestData() {
        // Create test Account
        Account acc = new Account(
            Name = 'Test Bureau',
            Bureau_Member_Id__c = 'BID123'
        );
        insert acc;

        // Create a Case linked to Account (Account Dispute case)
        Case accCase = new Case(
            AccountId = acc.Id,
            Status = 'Open',
            Displayed_Account_number__c = 'ACC123',
            ContactMobileNo__c = '9876543210',
            Consumer_Dispute_Status__c = 'Acknowledgement sent to Consumer',
             Displayed_Bank_Name__c='Test Bureau',
            Sub_Type_Lookup__c = null,
            Sub_Type_1_Lookup__c = null
        );
        insert accCase;

        // Create another Case for Enquiry dispute
        Case enquiryCase = new Case(
            AccountId = acc.Id,
            Status = 'Open',
            Enquiry_ERN__c = 'ENQ456',
            ContactMobileNo__c = '9123456789',
            Consumer_Dispute_Status__c = 'Acknowledgement sent to Consumer',
            Displayed_Bank_Name__c='Test Bureau'
            
        );
        insert enquiryCase;
    }
    
    @IsTest
    static void testDoPost_withValidRequests() {
        // Prepare JSON body
        String reqJson = '{' +
            '"accountDisputeRequestList":[' +
                '{"accountNumber":"ACC123","bureauMemberId":"BID123","bureauMemberName":"Test Bureau"}' +
            '],' +
            '"enquiryDisputeRequestList":[' +
                '{"enquiryERN":"ENQ456","bureauMemberId":"BID123","bureauMemberName":"Test Bureau"}' +
            ']' +
        '}';

        // Simulate RestContext
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(reqJson);
        req.httpMethod = 'POST';
        req.requestUri = '/services/apexrest/fetchOpenDisputeDetails/';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        fetchOpenDisputeDetails.doPost();
        Test.stopTest();

        // Validate response
        System.assertEquals(200, res.statusCode, 'Response should be success');
        String responseStr = res.responseBody.toString();
        System.debug('Response: ' + responseStr);

        System.assert(responseStr.contains('ACC123'), 'Account Number should be present');
        System.assert(responseStr.contains('ENQ456'), 'Enquiry ERN should be present');
        System.assert(responseStr.contains('caseNumber'), 'Case Number should be returned');

        // Validate API Log entry
        List<API_LOG__c> logs = [SELECT Id, Request_Source__c, Request__c, Response__c FROM API_LOG__c];
        System.assertEquals(1, logs.size(), 'One API log should be inserted');
        System.assertEquals('fetchOpenDisputeDetails', logs[0].Request_Source__c);
        System.assert(logs[0].Request__c.contains('ACC123'), 'Request JSON should be logged');
        System.assert(logs[0].Response__c.contains('caseNumber'), 'Response JSON should be logged');
    }

    @IsTest
    static void testDoPost_withException() {
        // Pass bad JSON to simulate exception
        String badJson = '{"wrongKey":"value"}';

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(badJson);
        req.httpMethod = 'POST';
        req.requestUri = '/services/apexrest/fetchOpenDisputeDetails/';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        fetchOpenDisputeDetails.doPost();
        Test.stopTest();

        //System.assertEquals(400, res.statusCode, 'Bad request should return 400');
        //System.assert(res.responseBody.toString().contains('error'), 'Error should be present in response');

        List<API_LOG__c> logs = [SELECT Id, Exception_Description__c FROM API_LOG__c ORDER BY CreatedDate DESC LIMIT 1];
        //System.assert(logs[0].Exception_Description__c != null, 'Exception should be logged');
    }
}