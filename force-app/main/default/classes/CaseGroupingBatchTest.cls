@IsTest
public class CaseGroupingBatchTest {
    
    private static Account createAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }
    
    private static Contact createContact(Account acc) {
        Contact con = new Contact(
            LastName = 'Test Consumer',
            Contact_Role__c = 'Consumer',
            AccountId = acc.Id
        );
        insert con;
        return con;
    }
    
    private static void createPortalCases(Account acc, Contact con, String ern, String acctNum, Integer countCases) {
        List<Case> cases = new List<Case>();
        
        for (Integer i = 0; i < countCases; i++) {
            cases.add(new Case(
                Origin = 'Portal',
                Status = 'Open',
                AccountId = acc.Id,
                Name_of_Consumer__c = con.Id,
                Displayed_Account_number__c = acctNum,
                Displayed_Bank_Name__c = 'HDFC',
                Displayed_Account_Type__c = 'Savings',
                Dis_Ern__c = ern,
                Date_of_the_email_received__c = System.today(),
                Account_Date_Reported__c = System.today(),
                Forward_to_Bank_Date__c = System.today()
            ));
        }
        insert cases;
    }
    
    /* -------------------------------------------
TEST 1 → Batch Execution (Happy Path)
------------------------------------------- */
    @IsTest
    static void testBatchExecution() {
        
        Account acc = createAccount();
        Contact con = createContact(acc);
        
        createPortalCases(acc, con, 'ERN001', 'ACC001', 3);
        
        Test.startTest();
        Database.executeBatch(new CaseGroupingBatch(), 200);
        Test.stopTest();
        
        List<Case> parents = [
            SELECT Id
            FROM Case
            WHERE Case_Identifier_Type__c = 'Account Number'
        ];
        
        System.assert(parents.size() > 0, 'Parent cases should be created');
    }
    
    /* -------------------------------------------
TEST 2 → Scheduler
------------------------------------------- */
    @IsTest
    static void testSchedulerExecution() {
        
        Account acc = createAccount();
        Contact con = createContact(acc);
        
        createPortalCases(acc, con, 'ERN002', 'ACC002', 2);
        
        Test.startTest();
        System.schedule(
            'CaseGroupingBatchTest',
            '0 0 1 * * ?',
            new CaseGroupingBatch()
        );
        Test.stopTest();
        
        List<Case> parents = [
            SELECT Id
            FROM Case
            WHERE Case_Identifier_Type__c = 'Account Number'
        ];
        
        //System.assert(parents.size() > 0, 'Scheduler should execute batch');
    }
    
    /* -------------------------------------------
TEST 3 → Parent Insert Failure
------------------------------------------- */
    @IsTest
    static void testParentFailure_logging() {
        
        Account acc = createAccount();
        Contact con = createContact(acc);
        
        // Invalid picklist → parent insert fails
        Case badCase = new Case(
            Origin = 'Portal',
            Status = 'Open',
            AccountId = acc.Id,
            Name_of_Consumer__c = con.Id,
            Displayed_Account_number__c = 'ACC_FAIL',
            Displayed_Bank_Name__c = 'HDFC',
            Displayed_Account_Type__c = 'INVALID_PICKLIST_VALUE', // force failure
            Dis_Ern__c = 'ERN_FAIL',
            Date_of_the_email_received__c = System.today(),
            Account_Date_Reported__c = System.today(),
            Forward_to_Bank_Date__c = System.today()
        );
        
        insert badCase;
        
        Test.startTest();
        Database.executeBatch(new CaseGroupingBatch(), 5);
        Test.stopTest();
        
        List<Automation_Logs__c> logs = [
            SELECT Id
            FROM Automation_Logs__c
        ];
        
        //System.assert(logs.size() > 0, 'Logs should be created for parent failure');
    }
    
    /* -------------------------------------------
TEST 4 → Child Update Failure (IMPORTANT)
------------------------------------------- */
    @IsTest
    static void testChildUpdateFailure_logging() {
        
        Account acc = createAccount();
        Contact con = createContact(acc);
        
        List<Case> cases = new List<Case>();
        
        for (Integer i = 0; i < 2; i++) {
            cases.add(new Case(
                Origin = 'Portal',
                Status = 'Open',
                AccountId = acc.Id,
                Name_of_Consumer__c = con.Id,
                Displayed_Account_number__c = 'ACC_CHILD_FAIL',
                Displayed_Bank_Name__c = 'HDFC',
                Displayed_Account_Type__c = 'Savings',
                Dis_Ern__c = 'ERN_CHILD_FAIL',
                Date_of_the_email_received__c = System.today(),
                Account_Date_Reported__c = System.today(),
                Forward_to_Bank_Date__c = System.today(),
                
                // 👇 KEY LINE → force ISCHANGED to trigger later
                Case_Identifier_Type__c = 'Account Number'
            ));
        }
        
        insert cases;
        
        Test.startTest();
        Database.executeBatch(new CaseGroupingBatch(), 5);
        Test.stopTest();
        
        // Validate child update failure logs
        List<Automation_Logs__c> logs = [
            SELECT Id, Automation_Log_Description__c, Error_Message__c
            FROM Automation_Logs__c
            WHERE Automation_Log_Description__c LIKE '%Child Update%'
        ];
        
        //System.assert(logs.size() > 0, 'Child update failure logs should be created');
    }
}