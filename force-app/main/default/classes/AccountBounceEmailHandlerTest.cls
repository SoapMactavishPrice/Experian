@isTest
private class AccountBounceEmailHandlerTest {

    @isTest
    static void testRemoveBouncedEmails() {

        // Create Account
        Account acc = new Account(
            Name = 'Test Account',
            DA_Level_1_Email_1__c = 'test1@example.com',
            DA_Level_2_Email_1__c = 'test2@example.com',
            DQR_DQI_Email_1__c   = 'test3@example.com'
        );

        insert acc;

        // Update bounced emails
        acc.Bounced_Email__c = 'test1@example.com;test3@example.com';

        Test.startTest();
        update acc;
        Test.stopTest();

        Account updatedAcc = [
            SELECT
                DA_Level_1_Email_1__c,
                DA_Level_2_Email_1__c,
                DQR_DQI_Email_1__c,
                Bounced_Email__c
            FROM Account
            WHERE Id = :acc.Id
        ];

        // Matching emails should be removed
        System.assertEquals(
            null,
            updatedAcc.DA_Level_1_Email_1__c,
            'DA_Level_1_Email_1__c should be cleared'
        );

        System.assertEquals(
            null,
            updatedAcc.DQR_DQI_Email_1__c,
            'DQR_DQI_Email_1__c should be cleared'
        );

        // Non-matching email should remain
        System.assertEquals(
            'test2@example.com',
            updatedAcc.DA_Level_2_Email_1__c,
            'DA_Level_2_Email_1__c should remain unchanged'
        );
    }

    @isTest
    static void testEmailComparisonIsCaseInsensitive() {

        Account acc = new Account(
            Name = 'Case Test',
            DA_Level_1_Email_1__c = 'TEST@EXAMPLE.COM'
        );

        insert acc;

        acc.Bounced_Email__c = 'test@example.com';

        Test.startTest();
        update acc;
        Test.stopTest();

        Account updatedAcc = [
            SELECT DA_Level_1_Email_1__c
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assertEquals(
            null,
            updatedAcc.DA_Level_1_Email_1__c,
            'Email comparison should be case-insensitive'
        );
    }

    @isTest
    static void testNoMatchingEmail() {

        Account acc = new Account(
            Name = 'No Match Test',
            DA_Level_1_Email_1__c = 'keepme@example.com'
        );

        insert acc;

        acc.Bounced_Email__c = 'other@example.com';

        Test.startTest();
        update acc;
        Test.stopTest();

        Account updatedAcc = [
            SELECT DA_Level_1_Email_1__c
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assertEquals(
            'keepme@example.com',
            updatedAcc.DA_Level_1_Email_1__c
        );
    }

    @isTest
    static void testBlankBouncedEmail() {

        Account acc = new Account(
            Name = 'Blank Test',
            DA_Level_1_Email_1__c = 'keepme@example.com'
        );

        insert acc;

        acc.Bounced_Email__c = '';

        Test.startTest();
        update acc;
        Test.stopTest();

        Account updatedAcc = [
            SELECT DA_Level_1_Email_1__c
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assertEquals(
            'keepme@example.com',
            updatedAcc.DA_Level_1_Email_1__c
        );
    }
}