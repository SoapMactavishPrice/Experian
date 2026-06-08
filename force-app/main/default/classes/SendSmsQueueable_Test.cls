@isTest
private class SendSmsQueueable_Test {

    // INNER HTTP MOCK CLASS (Same as your pattern)
    private class OnextelHttpMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"response":{"id":"12345","status":"success"}}');
            return res;
        }
    }

    @testSetup
    static void setupData() {
        // Create Contact
        Contact con = new Contact(
            LastName = 'Test Consumer',
            Phone = '9876543210',
            Phone_2__c = '9123456789',
            Contact_Role__c = 'Consumer'
        );
        insert con;

        // Create Account
        Account acc = new Account(Name = 'Kabib');
        insert acc;

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


        // Create Case
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
        cs.Name_of_Consumer__c = con.Id;
        cs.Displayed_Account_number__c = 'ACC001';
        
        insert cs;

        Onex__mdt smsMeta = [SELECT Id FROM Onex__mdt WHERE DeveloperName = 'received' LIMIT 1];
    }

     @isTest
    static void testQueueableExecution() {

        Set<Id> caseIds = new Set<Id>();
        for (Case c : [SELECT Id FROM Case]) {
            caseIds.add(c.Id);
        }

        Test.setMock(HttpCalloutMock.class, new OnextelHttpMock());

        Test.startTest();
            System.enqueueJob(new SendSmsQueueable(caseIds, 'received'));
        Test.stopTest();

        List<API_LOG__c> logs = [SELECT Id FROM API_LOG__c];

        System.assert(logs.size() > 0, 'API logs should be created for Queueable execution.');
    }

}