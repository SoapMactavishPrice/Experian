@IsTest
public class AccountNameChangeEmailHelperTest {

    @IsTest
    static void testSendNameChangeEmail() {

        Account acc = new Account(
            Name = 'Old Account Name'
        );
        insert acc;

        Account oldAcc = acc.clone(false, false, false, false);

        acc.Name = 'New Account Name';
        update acc;

        Account updatedAcc = [
            SELECT Id, Name, LastModifiedById
            FROM Account
            WHERE Id = :acc.Id
        ];

        List<Account> newAccounts = new List<Account>{ updatedAcc };
        Map<Id, Account> oldMap = new Map<Id, Account>{
            updatedAcc.Id => oldAcc
        };

        Test.startTest();

        AccountNameChangeEmailHelper.sendNameChangeEmail(
            newAccounts,
            oldMap
        );

        Test.stopTest();

    }
}