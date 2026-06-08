@isTest(SeeAllData=true)
private class ProfileObjectPermissionBatchTest {
    
    @isTest
    static void testBatchExecution() {
        
        // 🔹 Clean existing test data
        delete [SELECT Id FROM Object_Permission__c limit 1000];
        
        Test.startTest();
        
        // 🔹 Execute batch
        Database.executeBatch(new ProfileObjectPermissionBatch(), 2000);
        
        Test.stopTest();
        
        // 🔹 Validate records created
        List<Object_Permission__c> results = [
            SELECT Id, Profile_Name__c, Name, Permission_Type__c, Has_Access__c
            FROM Object_Permission__c
        ];
        
        System.assert(results.size() > 0, 'No Object Permission records were created');
        
        // 🔹 Validate sample data integrity
        Object_Permission__c sample = results[0];
        
        System.assertNotEquals(null, sample.Profile_Name__c, 'Profile Name should not be null');
        System.assertNotEquals(null, sample.Name, 'Object Name should not be null');
        System.assertNotEquals(null, sample.Permission_Type__c, 'Permission Type should not be null');
    }
}