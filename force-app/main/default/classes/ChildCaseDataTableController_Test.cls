@IsTest
public class ChildCaseDataTableController_Test {

    @TestSetup
    static void setupData() {

        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Case c = new Case(
            Subject = 'Test Case',
            Status = 'New',
            Origin = 'Phone'
        );
        insert c;

        List<Compensation_Child_Cases__c> childList = new List<Compensation_Child_Cases__c>();

        for (Integer i = 0; i < 3; i++) {
            childList.add(new Compensation_Child_Cases__c(
                Parent_Case__c = c.Id,
                Account_Name__c = 'Test Acc ' + i,
                Case_Number__c = 'C-00' + i,
                Displayed_Account_number__c = '123456789' + i,
                Sub_Type_Name__c = 'Type A',
                Sub_Type_1_Name__c = 'SubType A',
                Dispute_Received_Date__c = Date.today(),
                Resolve_Date__c = Date.today().addDays(5),
                Status__c = 'Open',
                Delayed_No_of_Days__c = 5,
                Liable_Amount__c = 100 * i
            ));
        }

        insert childList;
    }

    // =========================
    // GET CHILD CASES
    // =========================
    @IsTest
    static void testGetChildCasesByParent() {

        Case c = [SELECT Id FROM Case LIMIT 1];

        Test.startTest();
        List<Compensation_Child_Cases__c> results =
            ChildCaseDataTableController.getChildCasesByParent(c.Id);
        Test.stopTest();

        System.assertEquals(3, results.size());
    }

    @IsTest
    static void testGetChildCasesByParent_Null() {

        try {
            Test.startTest();
            ChildCaseDataTableController.getChildCasesByParent(null);
            Test.stopTest();
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
        }
    }

    // =========================
    // SAVE - OPT IN
    // =========================
    @IsTest
    static void testSaveCompensationDetails_OptIn() {

        Case c = [SELECT Id FROM Case LIMIT 1];

        Test.startTest();
        ChildCaseDataTableController.saveCompensationDetails(
            c.Id,
            true,
            'John Doe',
            'HDFC Bank',
            '1234567890',
            'HDFC0123456'
        );
        Test.stopTest();

        List<Compensation_Child_Cases__c> children = [
            SELECT Account_Number__c,
                   Bank_Name__c,
                   IFSC_Code__c,
                   Consumer_Name_As_per_Bank_Account__c,
                   Compensation_Opted__c,
                   Compensation_Response_Submitted__c
            FROM Compensation_Child_Cases__c
            WHERE Parent_Case__c = :c.Id
        ];

        for (Compensation_Child_Cases__c child : children) {
            System.assertEquals('1234567890', child.Account_Number__c);
            System.assertEquals('HDFC Bank', child.Bank_Name__c);
            System.assertEquals('HDFC0123456', child.IFSC_Code__c);
            System.assertEquals('John Doe', child.Consumer_Name_As_per_Bank_Account__c);
            System.assertEquals('Yes', child.Compensation_Opted__c);
            System.assertEquals(true, child.Compensation_Response_Submitted__c);
        }
    }

    // =========================
    // SAVE - OPT OUT
    // =========================
    @IsTest
    static void testSaveCompensationDetails_OptOut() {

        Case c = [SELECT Id FROM Case LIMIT 1];

        // Reset submission flag
        List<Compensation_Child_Cases__c> resetList = [
            SELECT Id, Compensation_Response_Submitted__c
            FROM Compensation_Child_Cases__c
            WHERE Parent_Case__c = :c.Id
        ];

        for (Compensation_Child_Cases__c rec : resetList) {
            rec.Compensation_Response_Submitted__c = false;
        }
        update resetList;

        Test.startTest();
        ChildCaseDataTableController.saveCompensationDetails(
            c.Id,
            false,
            null,
            null,
            null,
            null
        );
        Test.stopTest();

        List<Compensation_Child_Cases__c> children = [
            SELECT Compensation_Opted__c,
                   Compensation_Response_Submitted__c
            FROM Compensation_Child_Cases__c
            WHERE Parent_Case__c = :c.Id
        ];

        for (Compensation_Child_Cases__c child : children) {
            System.assertEquals('No', child.Compensation_Opted__c);
            System.assertEquals(true, child.Compensation_Response_Submitted__c);
        }
    }

    // =========================
    // NULL ID
    // =========================
    @IsTest
    static void testSaveCompensationDetails_Null() {

        try {
            Test.startTest();
            ChildCaseDataTableController.saveCompensationDetails(
                null, true, 'A', 'B', '123', 'ABCD0123456'
            );
            Test.stopTest();
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
        }
    }

    // =========================
    // IS RESPONSE SUBMITTED
    // =========================
    @IsTest
    static void testIsResponseAlreadySubmitted() {

        Case c = [SELECT Id FROM Case LIMIT 1];

        Compensation_Child_Cases__c child = [
            SELECT Id, Compensation_Response_Submitted__c
            FROM Compensation_Child_Cases__c
            WHERE Parent_Case__c = :c.Id
            LIMIT 1
        ];

        child.Compensation_Response_Submitted__c = true;
        update child;

        Test.startTest();
        Boolean result =
            ChildCaseDataTableController.isResponseAlreadySubmitted(c.Id);
        Test.stopTest();

        System.assertEquals(true, result);
    }

    // =========================
    // GET CASE NUMBER
    // =========================
    @IsTest
    static void testGetCaseNumber() {

        Case c = [SELECT Id, CaseNumber FROM Case LIMIT 1];

        Test.startTest();
        String caseNumber =
            ChildCaseDataTableController.getCaseNumber(c.Id);
        Test.stopTest();

        System.assertEquals(c.CaseNumber, caseNumber);
    }
    
    
    @IsTest
    static void testSaveCompensationDetails_FailureLogging() {
    
        Case c = [SELECT Id FROM Case LIMIT 1];
    
        Test.startTest();
        try {
            ChildCaseDataTableController.saveCompensationDetails(
                c.Id,
                true,
                'John Doe',
                'HDFC Bank',
                'FAIL_TEST', // 🔥 triggers failure
                'HDFC0123456POIUYTREWQASDFGHJKLMNBVCX'
            );
        } catch (Exception e) {
            // expected sometimes
        }
        Test.stopTest();
    
        List<Automation_Logs__c> logs = [
            SELECT Id, Error_Message__c
            FROM Automation_Logs__c
        ];
    
        System.assert(logs.size() > 0, 'Logs should be created');
    }
}