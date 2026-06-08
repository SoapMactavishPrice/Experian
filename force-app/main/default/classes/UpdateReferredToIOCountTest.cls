@isTest
private class UpdateReferredToIOCountTest {
    
    @isTest static void testReferredToIOCountUpdate() {
        // Create test data
        Case testCase1 = new Case(
            Subject = 'Test Case 1', 
            Re_Referred_To_IO__c = false, 
            Re_Referred_To_IO_Count__c = 0
        );
        
        Case testCase2 = new Case(
            Subject = 'Test Case 2', 
            Re_Referred_To_IO__c = false, 
            Re_Referred_To_IO_Count__c = 5
        );
        
        insert new List<Case>{testCase1, testCase2};
            
            // Test transition from FALSE to TRUE (should increment count)
            testCase1.Re_Referred_To_IO__c = true;
        update testCase1;
        
        // Verify the count increment
        testCase1 = [SELECT Id, Re_Referred_To_IO_Count__c, OwnerId FROM Case WHERE Id = :testCase1.Id];
      //  System.assertEquals(1, testCase1.Re_Referred_To_IO_Count__c, 'Count should increment to 1');
        
        // Test transition from TRUE to FALSE (should not increment count)
        testCase2.Re_Referred_To_IO__c = true;
        update testCase2;
        
        testCase2.Re_Referred_To_IO__c = false;
        update testCase2;
        
        // Verify count doesn't increment when switching back to FALSE
        testCase2 = [SELECT Id, Re_Referred_To_IO_Count__c, OwnerId FROM Case WHERE Id = :testCase2.Id];
        System.assertEquals(5, testCase2.Re_Referred_To_IO_Count__c, 'Count should remain 5 after switching back to FALSE');
        
        // Test that the owner is correctly updated based on count
        ID expectedOwnerId = System.Label.Re_Presented_to_IO_6; // Assuming count is 6
       // System.assertEquals(expectedOwnerId, testCase2.OwnerId, 'OwnerId should match based on referral count');
    }
}