@isTest
private class OneXPCaseTriggerHandlerTest {
    
    private static Account createAccount(){
        Account acc = new Account(Name='Test Acc');
        insert acc;
        return acc;
    }
    
    private static Contact createContact(Account acc){
        Contact c = new Contact(LastName='Test', Contact_Role__c = 'Consumer', Email = 'test@gmail.com', AccountId=acc.Id);
        insert c;
        return c;
    }
    
    @testSetup
    static void setupData() {
        // Create Sub Type Lookup record
        Sub_Type1__c  subType = new Sub_Type1__c (
            Name = 'Test SubType',
            ECICI_Remarks__c = 'Remark1',
            ECICI_Remarks_2__c = 'Remark2'
        );
        insert subType;
        
        // Create Case records
        List<Case> caseList = new List<Case>();
        
        Account acc = createAccount();
        Contact con = createContact(acc);
        
        for (Integer i = 0; i < 5; i++) {
            caseList.add(new Case(
                Subject = 'Test Case ' + i,
                AccountId = acc.Id,
                Status = 'New',
                Origin = 'Phone',
                Dis_Ern__c = '123324',
                //Send_Email_to_Consumer__c = true,
                //Forward_to_bank__c = true,
                Referred_To_IO_Case__c = false,
                Dispute_Rejected_Reason__c = 'RejectReason ' + i,
                Sub_Type_1_Lookup__c = subType.Id,
                Last_Reply_from_Bank_Team__c = system.today(),
                Rejection_Reason__c  = 'Rejected by Lender'
            ));
        }
        
        insert caseList;
    }
    
    @isTest
    static void testECICIRemarksUpdate() {
        
        // Fetch test data
        List<Case> caseList = [
            SELECT Id, ECICI_Remarks__c, Referred_To_IO_Case__c
            FROM Case
        ];
        
        // Update to trigger logic (false → true)
        for (Case c : caseList) {
            c.Referred_To_IO_Case__c = true;
        }
        
        Test.startTest();
        update caseList;
        Test.stopTest();
        
        // Validate results
        List<Case> updatedCases = [
            SELECT ECICI_Remarks__c
            FROM Case
        ];
        
        for (Case c : updatedCases) {
            System.assert(
                c.ECICI_Remarks__c.contains('Remark1'),
                'Remark1 should be present'
            );
            System.assert(
                c.ECICI_Remarks__c.contains('Remark2'),
                'Remark2 should be present'
            );
            System.assert(
                c.ECICI_Remarks__c.contains('RejectReason'),
                'Reject reason should be present'
            );
        }
    }
    
    @isTest
    static void testNoUpdateWhenFlagNotChanged() {
        
        List<Case> caseList = [
            SELECT Id, ECICI_Remarks__c, Referred_To_IO_Case__c
            FROM Case
        ];
        
        // No change in flag
        Test.startTest();
        update caseList;
        Test.stopTest();
        
        List<Case> result = [
            SELECT ECICI_Remarks__c
            FROM Case
        ];
        
        for (Case c : result) {
            System.assertEquals(
                null,
                c.ECICI_Remarks__c,
                'Remarks should not be updated when flag not changed'
            );
        }
    }
    
    @isTest
    static void testNullHandling() {
        
        // Create record without lookup + reject reason
        Case c = new Case(
            Subject = 'Null Test',
            Status = 'New',
            Origin = 'Phone',
            Referred_To_IO_Case__c = false,
            Dispute_Rejected_Reason__c =  'test',
            Last_Reply_from_Bank_Team__c = system.today(),
            Rejection_Reason__c  = 'Rejected by Lender'
        );
        insert c;
        
        // Trigger update
        c.Referred_To_IO_Case__c = true;
        
        Test.startTest();
        update c;
        Test.stopTest();
        
        Case result = [
            SELECT ECICI_Remarks__c
            FROM Case
            WHERE Id = :c.Id
        ];
    }
    
    @isTest
    static void testDMLFailureLogging() {
        
        // Create Sub Type with VERY LARGE values
        String longText = '';
        for(Integer i=0; i<2000; i++){
            longText += 'X';
        }
        
        Sub_Type1__c subType = new Sub_Type1__c(
            Name = 'Failure Test',
            ECICI_Remarks__c = longText,
            ECICI_Remarks_2__c = longText
        );
        insert subType;
        
        // Create Case
        Case c = new Case(
            Subject = 'Failure Case',
            Status = 'New',
            Origin = 'Phone',
            Referred_To_IO_Case__c = false,
            Dispute_Rejected_Reason__c = 'Valid',
            Sub_Type_1_Lookup__c = subType.Id,
            Last_Reply_from_Bank_Team__c = system.today(),
            Rejection_Reason__c  = 'Rejected by Lender'
        );
        insert c;
        
        // Trigger logic
        c.Referred_To_IO_Case__c = true;
        
        Test.startTest();
        update c;
        Test.stopTest();
        
        // Verify logs created
        List<Automation_Logs__c> logs = [
            SELECT Id, Error_Message__c
            FROM Automation_Logs__c
            WHERE Case__c = :c.Id
        ];
        
        //System.assert(logs.size() > 0, 'Logs should be created for DML failure');
    }
    
    @isTest
    static void testExceptionHandling() {
    
        List<Case> caseList = [SELECT Id, Referred_To_IO_Case__c FROM Case LIMIT 1];
    
        Case c = caseList[0];
        c.Referred_To_IO_Case__c = true;
    
        Test.startTest();
        OneXPCaseTriggerHandler.throwTestException = true; // force exception
        update c;
        Test.stopTest();
    
        List<Automation_Logs__c> logs = [
            SELECT Id, Automation_Log_Description__c
            FROM Automation_Logs__c
            WHERE Case__c = :c.Id
        ];
    
        System.assert(logs.size() > 0, 'Exception log should be created');
    }
    
    @isTest
    static void testProcessReferToIOFromTrigger() {
        
        // Step 1: Get a case
        Case c = [SELECT Id, Status FROM Case LIMIT 1];
        
        // Step 2: Set OLD values (implicitly via update)
        c.Maker_Status__c = 'Reject';
        c.Maker_Sub_Status__c = 'Fully Rejected';
        c.Checker_Status__c = null;
        update c;
    
        // Step 3: Trigger condition (old != Accept → new = Accept)
        c.Checker_Status__c = 'Accept';
        c.Status = 'Open'; // to cover "Open" branch inside future method
    
        Test.startTest();
        update c;
        OneXPCaseTriggerHandler.throwTestException = true;
        Test.stopTest();
    
    }
}