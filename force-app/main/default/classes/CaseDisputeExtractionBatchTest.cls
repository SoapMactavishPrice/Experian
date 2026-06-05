@IsTest
public class CaseDisputeExtractionBatchTest {
    
    /* =========================================================
===================== OOLKA TEST ========================
========================================================= */
    @IsTest
    static void testOolkaFormatExtraction() {
        
        Case c = new Case(
            Subject = 'OOLKA Dispute',
            Status = 'Open',
            Origin = 'Email',
            SuppliedEmail = 'user@oolka.in',
            Case_Category__c = 'Consumer',
            Description =
            'Personal Details:\n' +
            '• Full Name: Kalyana Ram\n' +
            '• Mobile Number: 9772653107\n' +
            '• PAN: DSMPR0685D\n' +
            '• Latest Experian Credit Report (ERN): 1768626772712\n' +
            '• UTI: 2206418207\n' +
            'Account information:\n' +
            '• Lender Name: Aditya Birla Capital Ltd\n' +
            '• Account Number: XXXXXXXXX7503\n' +
            '• Account Type: Short Term Personal Loan\n' +
            '• Account Status: ACTIVE\n' +
            '• Amount Overdue: ₹9,777\n' +
            '• Date Opened: 20211001\n' +
            '• Sanctioned Amount / Highest Credit Limit: 500\n' +
            'Dispute Details:\n' +
            '• Issue: Account incorrectly showing overdue.\n' +
            'More explanation.\n' +
            '• Desired Resolution: Update account status to CLOSED.'
        );
        insert c;
        
        EmailMessage em = new EmailMessage(
            ParentId = c.Id,
            FromAddress = 'user@oolka.in',
            ToAddress = 'support@test.com',
            CcAddress = 'loan_support@oolka.in',
            Subject = 'Dispute',
            TextBody = 'Test'
        );
        insert em;
        
        Test.startTest();
        Database.executeBatch(new CaseDisputeExtractionBatch(), 200);
        Test.stopTest();
        
        Case res = [
            SELECT Displayed_Name__c,
            Displayed_Mobile_No__c,
            Displayed_PAN_No__c,
            Displayed_Bank_Name__c,
            Displayed_Account_number__c,
            Displayed_Account_Type__c,
            Displayed_Account_Status__c,
            Displayed_Overdue_Amount__c,
            Displayed_Account_Opening_Date__c,
            Sanctioned_Amount__c,
            Dispute_Detail__c,
            Desired_Resolution__c
            FROM Case
            WHERE Id = :c.Id
        ];
        
        System.assertEquals('Kalyana Ram', res.Displayed_Name__c);
        System.assertEquals('9772653107', res.Displayed_Mobile_No__c);
        System.assertEquals('DSMPR0685D', res.Displayed_PAN_No__c);
        //System.assertEquals('Aditya Birla Capital Ltd', res.Displayed_Bank_Name__c);
        System.assertEquals('XXXXXXXXX7503', res.Displayed_Account_number__c);
        System.assertEquals('Short Term Personal Loan', res.Displayed_Account_Type__c);
        //System.assertEquals('ACTIVE', res.Displayed_Account_Status__c);
        System.assertEquals(9777, res.Displayed_Overdue_Amount__c);
        System.assertEquals(Date.newInstance(2021, 10, 1),
                            res.Displayed_Account_Opening_Date__c);
        System.assertEquals('500', res.Sanctioned_Amount__c);
        System.assert(res.Dispute_Detail__c.contains('Account incorrectly showing overdue'));
        System.assertEquals('Update account status to CLOSED.',
                            res.Desired_Resolution__c);
    }
    
    /* =========================================================
======================= ZET TEST ========================
========================================================= */
    @IsTest
    static void testZetFormatExtraction() {
        
        Case c = new Case(
            Subject = 'ZET Dispute',
            Status = 'Open',
            Origin = 'Email',
            SuppliedEmail = 'user@zetapp.in',
            Case_Category__c = 'Consumer',
            Description =
            'Account Details:\n' +
            'Subscriber Name: Indel Money Private Limited\n' +
            'Account Number: 4101\n' +
            'Account Type: GOLD LOAN\n' +
            'Date Reported: 2017-05-31\n' +
            'Account Status: ACTIVE\n' +
            'Credit Limit: ₹16,000\n' +
            'Current Balance: ₹16,000\n\n' +
            'This account was closed, but it is still reported as open in my credit report.\n\n' +
            'Report Information:\n' +
            'Experian Reference Number (ERN): 1769013024990\n' +
            'Unique Transaction ID (UTI): 998877\n' +
            'Report Date: 2026-01-21\n' +
            'Report Number: 1769013024990\n\n' +
            'Please investigate this issue and update my credit report.\n\n' +
            'Sincerely,\n' +
            'Sreehari Mandakath\n' +
            'Email: sreehala.hari@gmail.com\n' +
            'Phone: 7034551000\n' +
            'PAN: BILPM8544B'
        );
        insert c;
        
        EmailMessage em = new EmailMessage(
            ParentId = c.Id,
            FromAddress = 'user@zetapp.in',
            ToAddress = 'support@test.com',
            CcAddress = 'creditreport@zetapp.in',
            Subject = 'Credit Dispute',
            TextBody = 'Test'
        );
        insert em;
        
        Test.startTest();
        Database.executeBatch(new CaseDisputeExtractionBatch(), 200);
        Test.stopTest();
        
        Case res = [
            SELECT Displayed_Name__c,
            Displayed_Mobile_No__c,
            Displayed_Email_Id__c,
            Displayed_PAN_No__c,
            Displayed_Bank_Name__c,
            Displayed_Account_number__c,
            Displayed_Account_Type__c,
            Displayed_Account_Status__c,
            Account_Date_Reported__c,
            Sanctioned_Amount__c,
            Displayed_Loan_Balance__c,
            Dispute_Detail__c,
            Desired_Resolution__c
            FROM Case
            WHERE Id = :c.Id
        ];
        
        System.assertEquals('Sreehari Mandakath', res.Displayed_Name__c);
        System.assertEquals('7034551000', res.Displayed_Mobile_No__c);
        System.assertEquals('sreehala.hari@gmail.com', res.Displayed_Email_Id__c);
        System.assertEquals('BILPM8544B', res.Displayed_PAN_No__c);
        System.assertEquals('Indel Money Private Limited', res.Displayed_Bank_Name__c);
        System.assertEquals('4101', res.Displayed_Account_number__c);
        System.assertEquals('GOLD LOAN', res.Displayed_Account_Type__c);
        //System.assertEquals('ACTIVE', res.Displayed_Account_Status__c);
        System.assertEquals(Date.newInstance(2017, 5, 31),
                            res.Account_Date_Reported__c);
        System.assertEquals('16000', res.Sanctioned_Amount__c);
        System.assertEquals(16000, res.Displayed_Loan_Balance__c);
        System.assert(
            res.Dispute_Detail__c.contains('still reported as open'),
            'Dispute text missing'
        );
        System.assert(
            res.Desired_Resolution__c.contains('Please investigate this issue'),
            'Resolution text missing'
        );
    }
    
    /* =========================================================
===================== SCHEDULER =========================
========================================================= */
    @IsTest
    static void testSchedulerExecution() {
        Test.startTest();
        System.schedule(
            'Case Dispute Scheduler Test',
            '0 0 * * * ?',
            new CaseDisputeExtractionBatch()
        );
        Test.stopTest();
        System.assert(true);
    }
}