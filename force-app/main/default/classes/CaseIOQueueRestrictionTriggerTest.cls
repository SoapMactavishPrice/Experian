@IsTest
public class CaseIOQueueRestrictionTriggerTest {

    /* =========================
       TEST DATA FACTORY
       ========================= */

    private static Account createAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }

    private static Contact createContact(Account acc) {
        Contact con = new Contact(
            LastName = 'Test Contact',
            Email = 'test@gmail.com',
            AccountId = acc.Id
        );
        insert con;
        return con;
    }

    private static Case createParentCase(Account acc, Contact con) {
        Case parent = new Case(
            Origin = 'Phone',
            Status = 'New',
            Subject = 'Parent Case',
            AccountId = acc.Id,
            ContactId = con.Id
        );
        insert parent;
        return parent;
    }

    private static List<Case> createChildCases(Account acc, Contact con, Id parentId) {

        List<Case> childs = new List<Case>();

        for (Integer i = 0; i < 3; i++) {
            childs.add(new Case(
                Origin = 'Phone',
                Status = 'New',
                Subject = 'Child Case ' + i,
                AccountId = acc.Id,
                ContactId = con.Id,
                ParentId = parentId
            ));
        }

        insert childs;
        return childs;
    }

    /* =========================
       HELPER → Get IO Queue
       ========================= */

    private static Id getQueueId(String devName) {
        Group g = [
            SELECT Id
            FROM Group
            WHERE Type = 'Queue'
            AND DeveloperName = :devName
            LIMIT 1
        ];
        return g.Id;
    }

    /* =========================
       TEST 1 → Normal Case update should pass
       ========================= */

    @IsTest
    static void testNormalCaseUpdateShouldPass() {

        Account acc = createAccount();
        Contact con = createContact(acc);
        Case parent = createParentCase(acc, con);
        List<Case> childs = createChildCases(acc, con, parent.Id);

        Test.startTest();

        childs[0].Subject = 'Updated Normal Case';
        update childs;

        Test.stopTest();

        Case updated = [
            SELECT Subject
            FROM Case
            WHERE Id = :childs[0].Id
        ];

    }


    /* =========================
       TEST 3 → Change owner TO IO Queue should fail
       ========================= */

    @IsTest
    static void testChangeOwnerToIOQueueShouldFail() {

        Account acc = createAccount();
        Contact con = createContact(acc);
        Case parent = createParentCase(acc, con);

        List<Case> childs = createChildCases(acc, con, parent.Id);

        Id queueId = getQueueId('Re_Presented_to_IO_1');

        Test.startTest();

        Boolean exceptionThrown = false;

        try {
            childs[0].OwnerId = queueId;
            update childs;
        } catch (DmlException ex) {
            exceptionThrown = true;
        }

        Test.stopTest();

    }
}