@IsTest
public class AccountTriggerTest {

    @testSetup
    static void setupData() {
        Account acc = new Account(
            Name = 'Old Account Name',
            Send_Invoice_Email__c = false
        );
        insert acc;
    }

    /**
     * Test: Account Name Change Email
     */
    @IsTest
    static void testAccountNameChangeEmail() {

        Account acc = [
            SELECT Id, Name
            FROM Account
            LIMIT 1
        ];

        Test.startTest();

        acc.Name = 'New Account Name';
        update acc;

        Test.stopTest();

    }

    /**
     * Test: Send Invoice Email Logic
     */
    @IsTest
    static void testInvoiceEmailLogic() {

        Account acc = [
            SELECT Id, Send_Invoice_Email__c
            FROM Account
            LIMIT 1
        ];

        Test.startTest();

        acc.Send_Invoice_Email__c = true;
        update acc;

        Test.stopTest();

    }

    /**
     * Test: Both Name Change and Invoice Email Together
     */
    @IsTest
    static void testBothLogicsTogether() {

        Account acc = [
            SELECT Id, Name, Send_Invoice_Email__c
            FROM Account
            LIMIT 1
        ];

        Test.startTest();

        acc.Name = 'Another New Name';
        acc.Send_Invoice_Email__c = true;
        update acc;

        Test.stopTest();


    }
}