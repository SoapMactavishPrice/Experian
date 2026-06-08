@IsTest
public class UpdateAccountSendFormCEmailBatch_Test {

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

        // Only ONE eligible record
        accList.add(new Account(
            Name = 'Test Customer Account',
            RecordTypeId = customerRt.Id,
            DA_Level_1_Email_1__c = 'test@gmail.com',
            Send_Form_C_Email__c = false,
            Do_Not_Send_Fortnightly_Email__c = false,
            Form_C_Level_1_Email_1__c = 'test@gmail.com'
        ));

        insert accList;
    }

    @IsTest
    static void testBatchExecution() {

        Test.startTest();

        Database.executeBatch(
            new UpdateAccountSendFormCEmailBatch(),
            200   // Ensure single execution
        );

        Test.stopTest();

    }

    @IsTest
    static void testSchedulerExecution() {

        Test.startTest();

        System.schedule(
            'Test_UpdateAccountSendFormCEmailBatch',
            '0 0 0 1 1 ? 2099',
            new UpdateAccountSendFormCEmailBatch()
        );

        Test.stopTest();
    }
}