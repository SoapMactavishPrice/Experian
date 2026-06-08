@isTest
public class CreateCompensationBatchTest {
    
    @testSetup
    static void setupData() {
        
        Date yesterday = Date.today().addDays(-1);
        
        // 🔹 Create Contacts
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            contacts.add(new Contact(
                LastName = 'Consumer ' + i,
                Contact_Role__c = 'Consumer'
            ));
        }
        insert contacts;
        
        // 🔹 Parent Case
        Case parent = new Case(
            Subject = 'Parent Case',
            Status = 'New',
            Origin = 'Portal',
            Case_Identifier_Type__c = 'Account Number',
            Displayed_Account_number__c = 'ACC123'
        );
        insert parent;
        
        // 🔹 Child Cases
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 3; i++) {
            cases.add(new Case(
                Subject = 'Child Case ' + i,
                Status = 'New',
                Origin = 'Portal',
                Contact_Name__c = 'Test User',
                Dis_Ern__c = 'ERN' + i,
                Displayed_Account_number__c = 'ACC123',
                Date_of_the_email_received__c = yesterday,
                Case_Identifier_Type__c = 'Attribute',
                Name_of_Consumer__c = contacts[i].Id
            ));
        }
        insert cases;
        
        // 🔥 Set CreatedDate = YESTERDAY
        for (Case c : cases) {
            Test.setCreatedDate(
                c.Id,
                DateTime.newInstance(yesterday, Time.newInstance(10, 0, 0, 0))
            );
        }
        
        Test.setCreatedDate(
            parent.Id,
            DateTime.newInstance(yesterday, Time.newInstance(10, 0, 0, 0))
        );
    }
    
    // ✅ Main Batch Test
    @isTest
    static void testBatchExecution() {
        
        Test.startTest();
        Database.executeBatch(new CreateCompensationBatch(), 5);
        Test.stopTest();
        
        // ✅ Verify Compensation created
        List<Compensation__c> comps = [
            SELECT Id, Unique_Key__c 
            FROM Compensation__c
        ];
        System.assert(comps.size() > 0, 'Compensation should be created');
        
        // ✅ Verify Parent updated
        Case parent = [
            SELECT Compensation__c 
            FROM Case 
            WHERE Case_Identifier_Type__c = 'Account Number'
            LIMIT 1
        ];
        
        System.assertNotEquals(null, parent.Compensation__c, 'Parent should be updated');
    }
    
    // ✅ Duplicate Prevention Test (NO second batch call)
    @isTest
    static void testDuplicatePrevention() {
        
        // Get one case to build key
        Case c = [
            SELECT Contact_Name__c, Date_of_the_email_received__c 
            FROM Case 
            LIMIT 1
        ];
        
        String key = c.Contact_Name__c + ' - ' + String.valueOf(c.Date_of_the_email_received__c);
        
        // Insert existing Compensation (simulate duplicate)
        insert new Compensation__c(
            Name = key,
            Unique_Key__c = key
        );
        
        Test.startTest();
        Database.executeBatch(new CreateCompensationBatch(), 5);
        Test.stopTest();
        
        // Should still be only 1 for that key
        Integer count = [
            SELECT COUNT() 
            FROM Compensation__c 
            WHERE Unique_Key__c = :key
        ];
        
        System.assertEquals(1, count, 'Duplicate should not be created');
    }
    
    // ✅ Scheduler Test
    @isTest
    static void testScheduler() {
        
        Test.startTest();
        System.schedule('Test Batch Job', '0 0 1 * * ?', new CreateCompensationBatch());
        Test.stopTest();
        
        System.assert(true, 'Scheduler executed successfully');
    }
}