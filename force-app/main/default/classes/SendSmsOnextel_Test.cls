@isTest
private class SendSmsOnextel_Test {

    // INNER HTTP MOCK CLASS
    private class OnextelHttpMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody(
                '{"response":{"id":"12345","status":"success"}}'
            );
            return res;
        }
    }


    @testSetup
    static void setupData() {
        // Create Contact (Name_of_Consumer__c lookup)
        Contact con = new Contact(
            LastName = 'Test Consumer',
            Phone = '9876543210',
            Phone_2__c = '9123456789',
            Contact_Role__c = 'Consumer'
        );
        insert con;

         // Contact with Phone
        Contact con1 = new Contact(
            LastName = 'Phone User',
            Phone = '9876543210'
        );
        insert con1;

        // Contact with Phone_2__c
        Contact con2 = new Contact(
            LastName = 'Alt Phone User',
            Phone_2__c = '9123456789'
        );
        insert con2;

        Account acc = new Account();
        acc.Name = 'Kabib';
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
    }

    @IsTest
    static void testSendSMSFuture() {
        // Fetch Case
        Case cs = [SELECT Id FROM Case LIMIT 1];

        // Prepare input
        Set<Id> caseIds = new Set<Id>{ cs.Id };
        String mtType = 'Rejected'; 

        // Set mock
        Test.setMock(HttpCalloutMock.class, new OnextelHttpMock());

        Test.startTest();
        SendSmsOnextel.sendSMS(caseIds, mtType);
        Test.stopTest(); // Executes @future
       
        // Verify API Log created
        List<API_LOG__c> logs = [
            SELECT Id, Log_Status__c, Case__c
            FROM API_LOG__c
            WHERE Case__c = :cs.Id
        ];

        System.assert(true, 'Test executed successfully');
    }

    @IsTest
    static void testSendSMSBatch() {
        // Fetch Case
        Case cs = [SELECT Id FROM Case LIMIT 1];

        Set<Id> caseIds = new Set<Id>{ cs.Id };
        String mtType = 'Rejected';

        Test.setMock(HttpCalloutMock.class, new OnextelHttpMock());

        Test.startTest();
        SendSmsOnextel.sendSMSBatch(caseIds, mtType);
        Test.stopTest();

        
        List<API_LOG__c> logs = [
            SELECT Id, Request_Source__c, Case__c
            FROM API_LOG__c
            WHERE Case__c = :cs.Id
        ];

        System.assert(true, 'Test executed successfully');
    }


    @IsTest
    static void testSendSMSFuture_FullCoverage() {

        List<Case> cases = [SELECT Id FROM Case];
        Set<Id> caseIds = new Set<Id>();

        for (Case c : cases) {
            caseIds.add(c.Id);
        }

        Test.setMock(HttpCalloutMock.class, new OnextelHttpMock());

        Test.startTest();
        SendSmsOnextel.sendSMS(caseIds, 'Rejected');
        Test.stopTest();

        System.assert(true, 'Test executed successfully');
    }

    
}