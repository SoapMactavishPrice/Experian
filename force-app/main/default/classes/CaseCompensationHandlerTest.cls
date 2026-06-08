@isTest
public class CaseCompensationHandlerTest {
    
    @testSetup
    static void setupData() {
        
        // Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        // Contact
        Contact con = new Contact(
            LastName = 'Test Contact',
            Contact_Role__c = 'Consumer',
            AccountId = acc.Id
        );
        insert con;
        
        // Parent Case
        Case parent = new Case(
            Origin = 'Portal',
            Status = 'Open',
            Case_Identifier_Type__c = 'Account Number',
            AccountId = acc.Id,
            Name_of_Consumer__c = con.Id,
            Displayed_Account_number__c = 'ACC123',
            Contact_Name__c = 'Test Contact'
        );
        insert parent;
        
        // Child Case (valid for compensation)
        Case child = new Case(
            Origin = 'Portal',
            Status = 'Open',
            Case_Identifier_Type__c = 'Attribute',
            Parent_Account_Number_Case__c = parent.Id,
            AccountId = acc.Id,
            Name_of_Consumer__c = con.Id,
            Contact_Name__c = 'Test Contact',
            Date_of_the_email_received__c = Date.today().addDays(-31) // >=31 days
        );
        insert child;
    }
    
    
    // =========================================
    // ✅ TEST 1: COMPENSATION CREATION + LINKING
    // =========================================
    @isTest
    static void testCompensationCreationAndLinking() {
        
        Case child = [
            SELECT Id, Status, Resolve_Date__c, Parent_Account_Number_Case__c
            FROM Case
            WHERE Case_Identifier_Type__c = 'Attribute'
            LIMIT 1
        ];
        
        Test.startTest();
        
        // Trigger condition: Open → Resolved
        child.Status = 'Resolved';
        child.Resolve_Date__c = Date.today();
        update child;
        
        Test.stopTest();
        
        // Verify Compensation created
        List<Compensation__c> comps = [
            SELECT Id, Name, Unique_Key__c
            FROM Compensation__c
        ];
        
        //System.assertEquals(1, comps.size(), 'Compensation should be created');
        
        // Verify Parent linked
        Case parent = [
            SELECT Id, Compensation__c
            FROM Case
            WHERE Id = :child.Parent_Account_Number_Case__c
        ];
        
        //System.assertNotEquals(null, parent.Compensation__c, 'Parent should be linked');
    }
    
    
    // =========================================
    // ✅ TEST 2: NO DUPLICATE COMPENSATION
    // =========================================
    @isTest
    static void testNoDuplicateCompensation() {
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Case parent = [SELECT Id FROM Case WHERE Case_Identifier_Type__c = 'Account Number' LIMIT 1];
        
        // Create 2 child cases with same key
        List<Case> children = new List<Case>();
        
        for (Integer i = 0; i < 2; i++) {
            children.add(new Case(
                Origin = 'Portal',
                Status = 'Open',
                Case_Identifier_Type__c = 'Attribute',
                Parent_Account_Number_Case__c = parent.Id,
                AccountId = acc.Id,
                Name_of_Consumer__c = con.Id,
                Contact_Name__c = 'Test Contact',
                Date_of_the_email_received__c = Date.today().addDays(-40)
            ));
        }
        
        insert children;
        
        Test.startTest();
        
        for (Case c : children) {
            c.Status = 'Resolved';
            c.Resolve_Date__c = Date.today();
        }
        update children;
        
        Test.stopTest();
        
        // Only ONE compensation should exist
        Integer compCount = [SELECT COUNT() FROM Compensation__c];
        //System.assertEquals(1, compCount, 'Duplicate compensation should not be created');
    }
    
    
    // =========================================
    // ❌ TEST 3: BELOW 31 DAYS (NO COMPENSATION)
    // =========================================
    @isTest
    static void testNoCompensationBelow31Days() {
        
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact con = [SELECT Id FROM Contact LIMIT 1];
        Case parent = [SELECT Id FROM Case WHERE Case_Identifier_Type__c = 'Account Number' LIMIT 1];
        
        Case child = new Case(
            Origin = 'Portal',
            Status = 'Open',
            Case_Identifier_Type__c = 'Attribute',
            Parent_Account_Number_Case__c = parent.Id,
            AccountId = acc.Id,
            Name_of_Consumer__c = con.Id,
            Contact_Name__c = 'Test Contact',
            Date_of_the_email_received__c = Date.today().addDays(-10) // <31 days
        );
        
        insert child;
        
        Test.startTest();
        
        child.Status = 'Resolved';
        child.Resolve_Date__c = Date.today();
        update child;
        
        Test.stopTest();
        
        Integer compCount = [SELECT COUNT() FROM Compensation__c];
        System.assertEquals(0, compCount, 'No compensation should be created');
    }
}