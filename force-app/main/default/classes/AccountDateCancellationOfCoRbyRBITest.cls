@IsTest
public class AccountDateCancellationOfCoRbyRBITest {

    @testSetup
    static void setupData() {
        List<Account> accounts = new List<Account>();

        // Account that SHOULD be picked by the batch (LAST_MONTH & flag = false)
        accounts.add(new Account(
            Name = 'Eligible Account',
            Date_of_Cancellation_of_CoR_by_RBI__c = Date.today().addMonths(-1),
            Send_Date_of_Cancellation_of_CoR_by_RBI__c = false,
            DA_Level_1_Email_1__c = 'Test@gmail.com',
            DA_Level_1_Email_2__c = 'Test1@gmail.com'
        ));

        // Account that should NOT be picked (flag already true)
        accounts.add(new Account(
            Name = 'Already Sent Account',
            Date_of_Cancellation_of_CoR_by_RBI__c = Date.today().addMonths(-1),
            Send_Date_of_Cancellation_of_CoR_by_RBI__c = true,
            DA_Level_1_Email_1__c = 'Test@gmail.com',
            DA_Level_1_Email_2__c = 'Test1@gmail.com'
        ));

        // Account that should NOT be picked (date not last month)
        accounts.add(new Account(
            Name = 'Wrong Date Account',
            Date_of_Cancellation_of_CoR_by_RBI__c = Date.today(),
            Send_Date_of_Cancellation_of_CoR_by_RBI__c = false,
            DA_Level_1_Email_1__c = 'Test@gmail.com',
            DA_Level_1_Email_2__c = 'Test1@gmail.com'
        ));

        insert accounts;
    }

    /**
     * Test Batch Execution
     */
    @IsTest
    static void testBatchExecution() {
        Test.startTest();
        AccountDateCancellationOfCoRbyRBI batch =
            new AccountDateCancellationOfCoRbyRBI();
        Database.executeBatch(batch, 1);
        Test.stopTest();

        // Verify only eligible account was updated
        Account updatedAcc = [
            SELECT Send_Date_of_Cancellation_of_CoR_by_RBI__c
            FROM Account
            WHERE Name = 'Eligible Account'
            LIMIT 1
        ];

        System.assertEquals(
            true,
            updatedAcc.Send_Date_of_Cancellation_of_CoR_by_RBI__c,
            'The flag should be updated to TRUE by the batch'
        );
    }
}