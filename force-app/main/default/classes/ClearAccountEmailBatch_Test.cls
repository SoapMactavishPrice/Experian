@isTest
public class ClearAccountEmailBatch_Test {

    @isTest
    public static void testBatchExecution() {

        // Create Accounts
        Account acc1 = new Account(
            Name = 'Test Acc 1',
            Email_1_Dispute__c = 'test1@email.com',
            CC_Address_2__c = 'other@mail.com'
        );
        
        Account acc2 = new Account(
            Name = 'Test Acc 2',
            Email_3_Dispute__c = 'test1@email.com'
        );

        insert new List<Account>{ acc1, acc2 };

        // Create Failure Emails
        Failure_Email__c fe = new Failure_Email__c(
            Email__c = 'test1@email.com'
        );
        insert fe;

        Test.startTest();
        Database.executeBatch(new ClearAccountEmailBatch(), 200);
        Test.stopTest();

        // Reload Accounts
        acc1 = [SELECT Email_1_Dispute__c FROM Account WHERE Id = :acc1.Id];
        acc2 = [SELECT Email_3_Dispute__c FROM Account WHERE Id = :acc2.Id];
        
        // Reload Failure Email
        fe = [SELECT AccountName__c FROM Failure_Email__c WHERE Id = :fe.Id];

        System.assertEquals(null, acc1.Email_1_Dispute__c, 'Email_1 should be cleared');
        System.assertEquals(null, acc2.Email_3_Dispute__c, 'Email_3 should be cleared');
        System.assertNotEquals(null, fe.AccountName__c, 'AccountName__c should be set');
    }


    @isTest
    public static void testSchedulerExecution() {

        ClearAccountEmailBatch scheduler = new ClearAccountEmailBatch();

        Test.startTest();
        String jobId = System.schedule('Test Job', '0 0 12 * * ?', scheduler);
        Test.stopTest();

        System.assertNotEquals(null, jobId, 'Scheduler JobId should not be null');
    }
}