@isTest(SeeAllData=true)
private class ProfilePermissionBatchTest {
    
    @isTest
    static void testBatchExecution() {
        
        // 🔹 Step 1: Create Permission Master Data (REQUIRED)
        List<Permission_Master__c> masters = new List<Permission_Master__c>{
            new Permission_Master__c(Name='API Enabled', API_Name__c='PermissionsApiEnabled'),
                new Permission_Master__c(Name='Run Reports', API_Name__c='PermissionsRunReports'),
                new Permission_Master__c(Name='View All Data', API_Name__c='PermissionsViewAllData')
                };
                    insert masters;
        
        // 🔹 Step 2: Clean old matrix data
        delete [SELECT Id FROM Permission_Matrix__c];
        
        Test.startTest();
        
        // 🔥 IMPORTANT: Large batch size to avoid multiple execute calls
        Database.executeBatch(new ProfilePermissionBatch(), 2000);
        
        Test.stopTest();
        
        // 🔹 Step 3: Validate data created
        List<Permission_Matrix__c> results = [
            SELECT Id, Profile_Name__c, Has_Access__c
            FROM Permission_Matrix__c
        ];
        
        System.assert(results.size() > 0, 'No Permission Matrix records created');
        
        // 🔹 Step 4: Validate sample record
        Permission_Matrix__c sample = results[0];
        
        System.assertNotEquals(null, sample.Profile_Name__c, 'Profile name should not be null');
    }
}