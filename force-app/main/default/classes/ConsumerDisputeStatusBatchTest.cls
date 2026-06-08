@isTest
public class ConsumerDisputeStatusBatchTest {
    
    @testSetup
    static void createTestData() {

        Account acc = new Account(
            Name = 'Kabib',
            Instant_Reports__c = true,
            Email_1_Dispute__c = 'adfg@dfdg.com',
            Bureau_Member_Id__c = '1'
        );
        insert acc;

        Contact cn1 = new Contact(
            AccountId = acc.Id,
            FirstName = 'Aj',
            LastName = 'style',
            Phone = '1234567890',
            Fax = '1234567',
            Contact_Role__c = 'Consumer',
            Email = 'test@gmail.com',
            Birthdate = System.today()
        );
        insert cn1;
        
        Sub_Type1__c subType = new Sub_Type1__c(
            Name = 'Account does not belong to me'
        );
        insert subType;
        
        // Parent Case
        Case parentCase = new Case(
            Subject = 'Parent Case',
            Status = 'New',
            Origin = 'Portal',
            Account_Level_Status__c = 'Processing Passed'
        );
        insert parentCase;
        
        List<Case> cases = new List<Case>();
        
        /*
         * CASE 1
         * Eligible for STEP 2 update
         */
        cases.add(new Case(
            Subject = 'Test Case 1',
            Status = 'Open',
            Origin = 'Portal',
            Maker_Status__c = 'Accept',
            Maker_Sub_Status__c = 'Fully Accepted',
            Checker_Status__c = 'Accept',
            Account_Level_Status__c = 'Processing Passed',
            Parent_Account_Number_Case__c = parentCase.Id,
            Maker_Sub_Status_Date_Time__c = System.now().addHours(-10),
            Consumer_Dispute_Status__c = 'Acknowledgement sent to Consumer',
            Sub_Type_1_Lookup__c = subType.Id,
            Sub_Type_1__c = 'Account does not belong to me',
            stgOneHitId__c = '12234',
            Credit_Report_Link__c = 'www.test.com',
            Name_of_Consumer__c = cn1.Id
        ));
        
        
        /*
         * CASE 2
         * Eligible for STEP 1 API call
         */
        cases.add(new Case(
            Subject = 'Test Case 2',
            Status = 'Open',
            Origin = 'Portal',
            Maker_Status__c = 'Accept',
            Maker_Sub_Status__c = 'Fully Accepted',
            Checker_Status__c = 'Accept',
            Account_Level_Status__c = 'Processing Passed',
            Parent_Account_Number_Case__c = parentCase.Id,
            Maker_Sub_Status_Date_Time__c = System.now().addHours(-2),
            Consumer_Dispute_Status__c = 'Acknowledgement sent to Consumer',
            Sub_Type_1_Lookup__c = subType.Id,
            Sub_Type_1__c = 'Account does not belong to me',
            Name_of_Consumer__c = cn1.Id
        ));
        
        
        /*
         * CASE 3
         * Should NOT process
         */
        cases.add(new Case(
            Subject = 'Test Case 3',
            Status = 'Open',
            Origin = 'Portal',
            Maker_Status__c = 'Accept',
            Maker_Sub_Status__c = 'Fully Accepted',
            Checker_Status__c = 'Accept',
            Account_Level_Status__c = 'Processing Passed',
            Parent_Account_Number_Case__c = parentCase.Id,
            Maker_Sub_Status_Date_Time__c = System.now(),
            Consumer_Dispute_Status__c = 'Acknowledgement sent to Consumer',
            Sub_Type_1_Lookup__c = subType.Id,
            Sub_Type_1__c = 'Account does not belong to me',
            Name_of_Consumer__c = cn1.Id
        ));
        
        insert cases;
    }
    
    
    @isTest
    static void testBatchExecution() {

        Test.setMock(
            HttpCalloutMock.class,
            new IntegrationHandlerMock()
        );
        
        Test.startTest();
        
        Database.executeBatch(
            new ConsumerDisputeStatusBatch(),
            200
        );
        
        Test.stopTest();
        
        
        List<Case> updatedCases = [
            SELECT Id,
                   Subject,
                   Consumer_Dispute_Status__c,
                   Account_Level_Status__c,
                   Last_Reply_from_Bank_Team__c,
                   stgOneHitId__c,
                   Credit_Report_Link__c
            FROM Case
            WHERE Subject LIKE 'Test Case%'
            ORDER BY Subject
        ];
        
        
        /*
         * CASE 1 ASSERTION
         */
        System.assertEquals(
            'Resolved in favour of the Consumer',
            updatedCases[0].Consumer_Dispute_Status__c
        );
        
        System.assertEquals(
            'Pending With Experian',
            updatedCases[0].Account_Level_Status__c
        );
        
        
        /*
         * CASE 2 ASSERTION
         * API path covered
         */
        System.assertEquals(
            'Acknowledgement sent to Consumer',
            updatedCases[1].Consumer_Dispute_Status__c
        );
        
        
        /*
         * CASE 3 ASSERTION
         * No processing
         */
        System.assertEquals(
            'Acknowledgement sent to Consumer',
            updatedCases[2].Consumer_Dispute_Status__c
        );
    }
}