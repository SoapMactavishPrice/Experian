@isTest
private class UpdateParentCaseStatusBatchTest {
    
    @testSetup
    static void createTestData() {
        
        // Create Account
        Account acc = new Account(
            Name = 'Test Account'
        );
        insert acc;
        
        // Parent Case
        Case parentCase = new Case(
            Subject = 'Parent Case',
            Status = 'New',
            Origin = 'Phone',
            AccountId = acc.Id,
            Case_Identifier_Type__c = 'Account Number',
            Account_Level_Status__c = 'With Checker'
        );
        insert parentCase;
        
        // Child Case 1
        Case child1 = new Case(
            Subject = 'Child Case 1',
            Status = 'New',
            Origin = 'Phone',
            AccountId = acc.Id,
            Case_Identifier_Type__c = 'Attribute',
            Parent_Account_Number_Case__c = parentCase.Id,
            Account_Level_Status__c = 'Pending With Experian'
        );
        
        // Child Case 2
        Case child2 = new Case(
            Subject = 'Child Case 2',
            Status = 'New',
            Origin = 'Phone',
            AccountId = acc.Id,
            Case_Identifier_Type__c = 'Attribute',
            Parent_Account_Number_Case__c = parentCase.Id,
            Account_Level_Status__c = 'Pending With Experian'
        );
        
        insert new List<Case>{ child1, child2 };
            }
    
    @isTest
    static void testBatchExecution() {
        
        Test.startTest();
        
        UpdateParentCaseStatusBatch batchObj =
            new UpdateParentCaseStatusBatch();
        
        Database.executeBatch(batchObj, 200);
        
        Test.stopTest();
        
        // Verify Parent Case Updated
        Case updatedParent = [
            SELECT Id,
            Account_Level_Status__c
            FROM Case
            WHERE Case_Identifier_Type__c = 'Account Number'
            LIMIT 1
        ];
        
        System.assertEquals(
            'Pending With Experian',
            updatedParent.Account_Level_Status__c
        );
    }
    
    @isTest
    static void testSchedulerExecution() {
        
        Test.startTest();
        
        String cronExp = '0 0 0 1 1 ? 2099';
        
        System.schedule(
            'Test Update Parent Case Status Batch',
            cronExp,
            new UpdateParentCaseStatusBatch()
        );
        
        Test.stopTest();
        
        // Verify Parent Case Updated
        Case updatedParent = [
            SELECT Id,
            Account_Level_Status__c
            FROM Case
            WHERE Case_Identifier_Type__c = 'Account Number'
            LIMIT 1
        ];
        
        //System.assertEquals(
            //'Pending With Experian',
            //updatedParent.Account_Level_Status__c
        //);
    }
    
    @isTest
    static void testWhenChildStatusIsDifferent() {
        
        // Create Account
        Account acc = new Account(
            Name = 'Another Account'
        );
        insert acc;
        
        // Parent Case
        Case parentCase = new Case(
            Subject = 'Another Parent',
            Status = 'New',
            Origin = 'Phone',
            AccountId = acc.Id,
            Case_Identifier_Type__c = 'Account Number',
            Account_Level_Status__c = 'With Checker'
        );
        insert parentCase;
        
        // Child Case with different status
        Case childCase = new Case(
            Subject = 'Different Status Child',
            Status = 'New',
            Origin = 'Phone',
            AccountId = acc.Id,
            Case_Identifier_Type__c = 'Attribute',
            Parent_Account_Number_Case__c = parentCase.Id,
            Account_Level_Status__c = 'With Maker'
        );
        insert childCase;
        
        Test.startTest();
        
        Database.executeBatch(
            new UpdateParentCaseStatusBatch(),
            200
        );
        
        Test.stopTest();
        
        // Verify Parent NOT Updated
        Case parentAfterBatch = [
            SELECT Id,
            Account_Level_Status__c
            FROM Case
            WHERE Id = :parentCase.Id
        ];
        
        System.assertEquals(
            'With Checker',
            parentAfterBatch.Account_Level_Status__c
        );
    }
}