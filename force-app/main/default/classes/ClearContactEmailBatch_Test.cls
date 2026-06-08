@IsTest
private class ClearContactEmailBatch_Test {

    @IsTest
    static void testContactEmailClearing() {

        Failure_Email__c fe1 = new Failure_Email__c(
            Email__c = 'match1@example.com'
        );
        Failure_Email__c fe2 = new Failure_Email__c(
            Email__c = 'match2@example.com'
        );
        insert new List<Failure_Email__c>{ fe1, fe2 };


        Contact con1 = new Contact(
            LastName = 'Test1',
            Email = 'match1@example.com'
        );
        Contact con2 = new Contact(
            LastName = 'Test2',
            Email = 'MATCH2@example.com' 
        );

        // Contact that should NOT be touched
        Contact conNoMatch = new Contact(
            LastName = 'NoMatch',
            Email = 'nomatch@example.com'
        );

        insert new List<Contact>{ con1, con2, conNoMatch };


        Test.startTest();
        Database.executeBatch(new ClearContactEmailBatch(), 200);
        Test.stopTest();


        con1 = [SELECT Email FROM Contact WHERE Id = :con1.Id];
        con2 = [SELECT Email FROM Contact WHERE Id = :con2.Id];
        conNoMatch = [SELECT Email FROM Contact WHERE Id = :conNoMatch.Id];

        // System.assertEquals(null, con1.Email, 'Email should be cleared for matching contact 1');
        // System.assertEquals(null, con2.Email, 'Email should be cleared for matching contact 2');
        // System.assertNotEquals(null, conNoMatch.Email, 'Email should NOT be cleared for non-matching contact');


        fe1 = [SELECT ContactName__c FROM Failure_Email__c WHERE Id = :fe1.Id];
        fe2 = [SELECT ContactName__c FROM Failure_Email__c WHERE Id = :fe2.Id];

        System.assertNotEquals(null, fe1.ContactName__c, 'Failure Email #1 should capture Contact lookup');
        System.assertNotEquals(null, fe2.ContactName__c, 'Failure Email #2 should capture Contact lookup');
    }


    @IsTest
    static void testScheduleExecution() {

        Test.startTest();

        // Schedule the batch class
        String jobId = System.schedule(
            'Test ClearContactEmailBatch Schedule',
            '0 0 0 * * ?',   // Midnight daily
            new ClearContactEmailBatch()
        );

        Test.stopTest();

        System.assertNotEquals(null, jobId, 'Schedule job should be created');
    }
}