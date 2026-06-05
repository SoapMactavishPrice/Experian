@IsTest
private class EmailMessageControllerTest {
    @IsTest
    static void testListAndDetail() {
        Case c = new Case(Subject='Test', Origin='Phone');
        insert c;

        EmailMessage em = new EmailMessage(
            Subject = 'Hello',
            FromAddress = 'from@test.com',
            ToAddress = 'to@test.com',
            Status = '3', // '3' maps to Sent in many orgs; adjust if needed
            ParentId = c.Id
        );
        insert em;

        Test.startTest();
        List<EmailMessageController.EmailRowDTO> rows = EmailMessageController.getEmails(c.Id, 10, 0);
        System.assertEquals(1, rows.size());
        EmailMessageController.EmailDetailDTO d = EmailMessageController.getEmailDetail(rows[0].id);
        System.assertEquals('Hello', d.subject);
        Test.stopTest();
    }
}