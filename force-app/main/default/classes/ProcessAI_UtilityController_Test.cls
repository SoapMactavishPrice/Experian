@isTest
public class ProcessAI_UtilityController_Test {

    @isTest
    static void testProcessAIUtilityController() {
        // Create test data
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
        
        Case testCase = new Case();
        testCase.Displayed_Loan_Balance__c =Decimal.valueof(5000);
        testCase.Displayed_EMI_Amount__c =Decimal.valueof(9000);
        testCase.Status = 'Open';
        testCase.OwnerId=u_a.id;
        testCase.AccountId = acc.id;
        testCase.Subject = 'Update';
        testCase.Case_Category__c = 'Consumer';
        testCase.Case_Complaints__c = null;
        testCase.Origin = 'Email';
        testCase.Consumer_Dispute_Status__c= 'Resolved not in favour of the Consumer';
        testCase.Rejection_Reason__c = 'Rejected by Experian';
        insert testCase;


        // Simulate page parameters
        Test.setCurrentPageReference(new PageReference('/apex/ProcessAIUtility'));
        ApexPages.currentPage().getParameters().put('id', testCase.Id);

        // Instantiate controller
        processAI_UtilityController controller = new processAI_UtilityController();

        // Assert caseId is set
        System.assertEquals(testCase.Id, controller.caseId, 'Case ID should match the provided ID in page parameters');

        // Call updateCase
        Test.startTest();
        controller.updateCase();
        Test.stopTest();

        // Verify the debug message
        System.assertEquals('The AI UTILITY is called', ApexPages.getMessages()[0].getSummary(), 'Confirm message not set correctly');

        // Verify case trigger logic was invoked
        Case updatedCase = [SELECT Id FROM Case WHERE Id = :testCase.Id];
     //   System.assertNotNull(updatedCase, 'Case should exist and be processed');
    }

    @isTest
    static void testGetSomething() {
        // Simulate page parameters
        Test.setCurrentPageReference(new PageReference('/apex/ProcessAIUtility'));
        String testId = Id.valueOf('500000000000001');
        ApexPages.currentPage().getParameters().put('id', testId);

        // Instantiate controller
        processAI_UtilityController controller = new processAI_UtilityController();

        // Call getSomething
        PageReference result = controller.getSomething();

        // Assert the returned PageReference is correct
        System.assertEquals('/' + testId, result.getUrl(), 'PageReference URL should match the provided ID');
    }
}