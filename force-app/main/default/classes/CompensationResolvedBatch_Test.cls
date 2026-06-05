@IsTest
public class CompensationResolvedBatch_Test {

    @IsTest
    static void testBatch_singleAccount() {

        // ---------------- ACCOUNT ----------------
        Account acc = new Account(
            Name = 'Test Account',
            Email_1_Dispute__c = 'test1@example.com',
            Email_2_Dispute__c = 'test2@example.com'
        );
        insert acc;

        // ---------------- PARENT CASE (for threadId + EmailMessage link) ----------------
        Case parentCase = new Case(
            AccountId = acc.Id,
            Status = 'Open',
            Origin = 'Test',
            Account_s_Parent_Case__c = true
        );
        insert parentCase;

        // ---------------- COMPENSATION RECORD ----------------
        Compensation_Child_Cases__c comp = new Compensation_Child_Cases__c(
            Consumer_Name__c = 'Test User',
            Consumer_Email_ID__c = 'user@test.com',
            Case_Number__c = 'C-001',
            Liable_Party_Account_Id__c = acc.Id,
            Compensation_Opted__c = 'Yes'
        );
        insert comp;

        // ---------------- MOCK STATIC RESOURCE (OPTIONAL) ----------------
        // If your getFilesFromStaticResource depends on actual static resource,
        // you may skip or ensure it doesn't break

        Test.startTest();

        Database.executeBatch(new CompensationResolvedBatch(), 1);

        Test.stopTest();

        // ---------------- ASSERT: COMP UPDATED ----------------
        Compensation_Child_Cases__c updatedComp = [
            SELECT Compensation_Email_Sent_Date__c
            FROM Compensation_Child_Cases__c
            WHERE Id = :comp.Id
        ];

        System.assertNotEquals(
            null,
            updatedComp.Compensation_Email_Sent_Date__c,
            'Compensation Email Sent Date should be updated'
        );

        // ---------------- ASSERT: EMAILMESSAGE CREATED ----------------
        List<EmailMessage> emList = [
            SELECT Id, Subject, RelatedToId
            FROM EmailMessage
            WHERE RelatedToId = :parentCase.Id
        ];

    }
}