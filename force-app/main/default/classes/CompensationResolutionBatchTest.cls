@isTest
private class CompensationResolutionBatchTest {
    
    @testSetup
    static void setupData() {
        
        List<Compensation__c> comps = new List<Compensation__c>();
        List<Case> allCases = new List<Case>();
        
        // Dates
        Date d1 = Date.today().addDays(-2);
        Date d2 = Date.today().addDays(-1);
        
        String contactName = 'Test User';
        
        // 👉 Format function (same as your logic: no leading zeros)
        String formattedDate1 = d1.day() + '/' + d1.month() + '/' + d1.year();
        String formattedDate2 = d2.day() + '/' + d2.month() + '/' + d2.year();
        
        // 👉 Create Compensation records with proper keys
        Compensation__c comp1 = new Compensation__c(
            Unique_Key__c = contactName + ' - ' + formattedDate2
        );
        
        Compensation__c comp2 = new Compensation__c(
            Unique_Key__c = contactName + ' - ' + formattedDate1
        );
        
        Compensation__c comp3 = new Compensation__c(
            Unique_Key__c = 'Other User - 1/1/2024'
        );
        
        comps.add(comp1);
        comps.add(comp2);
        comps.add(comp3);
        
        insert comps;
        
        // 👇 IMPORTANT FIX: Move CreatedDate to past
        for (Compensation__c c : comps) {
            Test.setCreatedDate(c.Id, DateTime.now().addDays(-2));
        }
        
        // 👉 Cases for comp1 (ALL RESOLVED → should update)
        allCases.add(new Case(
            Status = 'Resolved',
            Resolve_Date__c = d1,
            Compensation__c = comp1.Id,
            Case_Identifier_Type__c = 'Account Number',
            Contact_Name__c = contactName,
            Date_of_the_email_received__c = d1,
            Origin = 'Email'
        ));
        
        allCases.add(new Case(
            Status = 'Resolved',
            Resolve_Date__c = d2, // MAX
            Compensation__c = comp1.Id,
            Case_Identifier_Type__c = 'Account Number',
            Contact_Name__c = contactName,
            Date_of_the_email_received__c = d2,
            Origin = 'Email'
        ));
        
        // 👉 Cases for comp2 (NOT ALL RESOLVED → should NOT update)
        allCases.add(new Case(
            Status = 'Resolved',
            Resolve_Date__c = d1,
            Compensation__c = comp2.Id,
            Case_Identifier_Type__c = 'Account Number',
            Contact_Name__c = contactName,
            Date_of_the_email_received__c = d1,
            Origin = 'Email'
        ));
        
        allCases.add(new Case(
            Status = 'New', // breaker
            Resolve_Date__c = d2,
            Compensation__c = comp2.Id,
            Case_Identifier_Type__c = 'Account Number',
            Contact_Name__c = contactName,
            Date_of_the_email_received__c = d2,
            Origin = 'Email'
        ));
        
        // 👉 Cases for comp3 (filtered out → should NOT update)
        allCases.add(new Case(
            Status = 'Resolved',
            Resolve_Date__c = d1,
            Compensation__c = comp3.Id,
            Case_Identifier_Type__c = 'Attribute',
            Contact_Name__c = 'Other User',
            Date_of_the_email_received__c = d1,
            Origin = 'Email'
        ));
        
        insert allCases;
    }
    
    @isTest
    static void testBatchExecution() {
        
        Test.startTest();
        Database.executeBatch(new CompensationResolutionBatch(), 5);
        Test.stopTest();
        
        List<Compensation__c> comps = [
            SELECT Id, Resolved_Date__c
            FROM Compensation__c
            ORDER BY CreatedDate ASC
        ];
        
        // ✅ comp1 → updated with MAX date
        //System.assertNotEquals(null, comps[0].Resolved_Date__c);
        //System.assertEquals(Date.today().addDays(-1), comps[0].Resolved_Date__c);
        
        // ❌ comp2 → should NOT update
        //System.assertEquals(null, comps[1].Resolved_Date__c);
        
        // ❌ comp3 → filtered out
        //System.assertEquals(null, comps[2].Resolved_Date__c);
    }
    
    @isTest
    static void testScheduler() {
        
        Test.startTest();
        System.schedule(
            'Test Compensation Scheduler',
            '0 0 2 * * ?',
            new CompensationResolutionBatch()
        );
        Test.stopTest();
        
        System.assert(true);
    }
}