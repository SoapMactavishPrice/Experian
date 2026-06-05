@IsTest
public class SendCancellationOfExpMembershipEmailTest {

    /* ---------------------------------------------------
       TEST 1: Direct Batch Execution
    --------------------------------------------------- */
    @IsTest
    static void testBatchExecution() {

        List<Account> testAccounts = new List<Account>();

        testAccounts.add(new Account(
            Name = 'Test Account 1',
            Date_of_Cancellation_of_CoR_by_RBI__c = Date.today().addMonths(-1),
            Send_Cancellation_of_Experian_Membership__c = false
        ));

        testAccounts.add(new Account(
            Name = 'Test Account 2',
            Include_in_Termination_List_CoR_by_RBI__c = true,
            Send_Cancellation_of_Experian_Membership__c = false
        ));

        insert testAccounts;

        Test.startTest();
        Database.executeBatch(
            new SendCancellationOfExpMembershipEmail(),
            200
        );
        Test.stopTest();
    }

    /* ---------------------------------------------------
       TEST 2: Scheduler Execution (NO direct batch call)
    --------------------------------------------------- */
    @IsTest
    static void testSchedulerExecution() {

        List<Account> testAccounts = new List<Account>();

        testAccounts.add(new Account(
            Name = 'Scheduler Test Account',
            Include_in_Termination_List_CoR_by_RBI__c = true,
            Send_Cancellation_of_Experian_Membership__c = false
        ));

        insert testAccounts;

        Test.startTest();

        String cronExp = '0 0 0 1 1 ? 2099';

        System.schedule(
            'Test Cancellation Scheduler',
            cronExp,
            new SendCancellationOfExpMembershipEmail()
        );

        Test.stopTest();

    }
}