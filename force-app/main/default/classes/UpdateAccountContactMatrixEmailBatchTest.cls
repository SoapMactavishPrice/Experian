@IsTest
public class UpdateAccountContactMatrixEmailBatchTest {

    @TestSetup
    static void setupData() {

        RecordType customerRt = [
            SELECT Id
            FROM RecordType
            WHERE SObjectType = 'Account'
            AND DeveloperName = 'Customer'
            LIMIT 1
        ];

        List<Account> accList = new List<Account>();

        // Eligible record
        accList.add(new Account(
            Name = 'Contact Matrix Test Account',
            RecordTypeId = customerRt.Id,
            Send_Contact_Matrix__c = false,
            Do_Not_Send_Contact_Matrix__c = false,
            Form_C_Level_1_Email_1__c = 'test@gmail.com'
        ));

        insert accList;
    }

    // Batch execution coverage
    @IsTest
    static void testBatchExecution() {

        Test.startTest();

        Database.executeBatch(
            new UpdateAccountContactMatrixEmailBatch(),
            200
        );

        Test.stopTest();
    }

    // Scheduler coverage
    @IsTest
    static void testSchedulerExecution() {

        Test.startTest();

        System.schedule(
            'Test_UpdateAccountContactMatrixEmailBatch',
            '0 0 0 1 1 ? 2099',
            new UpdateAccountContactMatrixEmailBatch()
        );

        Test.stopTest();
    }
}