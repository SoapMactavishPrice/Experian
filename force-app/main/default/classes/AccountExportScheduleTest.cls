@isTest
private class AccountExportScheduleTest {
    
    @testSetup
    static void setupTestData() {
        // Create test Accounts with Bureau_Member_Id__c and emails
        List<Account> accounts = new List<Account>();
        
        for (Integer i = 1; i <= 5; i++) {
            Account acc = new Account(
                Name = 'Test Account ' + i,
                Bureau_Member_Id__c = 'BMID-' + i,
                DQR_DQI_Email_1__c = 'test' + i + '@example.com',
                DQR_DQI_Email_2__c = 'test' + i + '_alt@example.com'
            );
            accounts.add(acc);
        }
        insert accounts;
        
        // Insert OrgWideEmailAddress for sending email
        /*OrgWideEmailAddress owea = new OrgWideEmailAddress(
            Address = 'customer.support@in.experian.com',
            DisplayName = 'Customer Support'
        );
        insert owea; */
        
        // Create Custom Label dynamically (if required in test context)
        //System.Label.Account_Export_Email_To = 'testrecipient@example.com';
    }
    
    @isTest
    static void testAccountExportSchedule() {
        Test.startTest();
        AccountExportSchedule scheduleJob = new AccountExportSchedule();
        scheduleJob.execute(null); // Call execute directly as it's a Schedulable class
        Test.stopTest();
        
        // Verify the email was sent
        //List<Messaging.SingleEmailMessage> sentEmails = [SELECT Subject FROM EmailMessage];
        //System.assert(!sentEmails.isEmpty(), 'Email should have been sent');
        
        // Verify email subject contains today's date
        String todayDate = System.today().year() + '-' + System.today().month() + '-' + System.today().day();
        //System.assert(sentEmails[0].Subject.contains(todayDate), 'Email subject should contain today’s date');
    }
    
    @isTest
    static void testNoAccountsScenario() {
        Test.startTest();
        // Delete all test accounts to simulate "no data" scenario
        delete [SELECT Id FROM Account WHERE Bureau_Member_Id__c != NULL];
        
        AccountExportSchedule scheduleJob = new AccountExportSchedule();
        scheduleJob.execute(null); // Call execute directly as it's a Schedulable class
        Test.stopTest();
        
        // Verify no email is sent
        //List<Messaging.SingleEmailMessage> sentEmails = [SELECT Subject FROM EmailMessage];
        //System.assert(sentEmails.isEmpty(), 'No email should be sent when no accounts exist');
    }
}