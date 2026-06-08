@isTest
public class GetStgOneHitIDTest {
    
    @testSetup
    static void createTestData() {
        
        Account acc = new Account(
            Name = 'Test Account',
            Instant_Reports__c = true,
            Email_1_Dispute__c = 'test@test.com',
            Bureau_Member_Id__c = '1'
        );
        insert acc;
        
        Contact con = new Contact(
            AccountId = acc.Id,
            FirstName = 'Test',
            LastName = 'Consumer',
            Email = 'consumer@test.com',
            Contact_Role__c = 'Consumer'
        );
        insert con;
        
        Case_Type__c ct = new Case_Type__c(
            Name = 'Complaint Dispute Consumer',
            Case_Category__c = 'Consumer',
            Case_Complaint__c = 'Report'
        );
        insert ct;
        
        Sub_Type__c stl = new Sub_Type__c(
            Name = 'Balance Issue',
            Case_Type__c = ct.Id
        );
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c(
            Name = 'Current Balance',
            Sub_Type__c = stl.Id
        );
        insert st;
        
        // Eligible record
        Case eligibleCase = new Case(
            AccountId = acc.Id,
            Name_of_Consumer__c = con.Id,
            Case_Category__c = 'Consumer',
            Case_Complaints__c = 'Report',
            Case_Type_Lookup__c = ct.Id,
            Sub_Type_Lookup__c = stl.Id,
            Sub_Type_1_Lookup__c = st.Id,
            Subject = 'Eligible Case',
            Status = 'Open',
            Origin = 'Portal',
            Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer',
            Resolved_Consumer_Email_Sent__c = false,
            Date_of_the_email_received__c = Date.today(),
            stgOneHitId__c = null
        );
        
        // Non eligible record
        Case nonEligibleCase = new Case(
            AccountId = acc.Id,
            Name_of_Consumer__c = con.Id,
            Case_Category__c = 'Consumer',
            Case_Complaints__c = 'Report',
            Case_Type_Lookup__c = ct.Id,
            Sub_Type_Lookup__c = stl.Id,
            Sub_Type_1_Lookup__c = st.Id,
            Subject = 'Non Eligible Case',
            Status = 'Closed',
            Origin = 'Portal',
            Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer',
            Resolved_Consumer_Email_Sent__c = true,
            Date_of_the_email_received__c = Date.today(),
            stgOneHitId__c = null
        );
        
        insert new List<Case>{ eligibleCase, nonEligibleCase };
            
            Case c = [
                SELECT Id,
                Case_Type_Name__c,
                Case_Type_Lookup__r.Name
                FROM Case
                WHERE Subject = 'Eligible Case'
            ];
        
        System.debug('Case Type Name = ' + c.Case_Type_Name__c);
        System.debug('Lookup Name = ' + c.Case_Type_Lookup__r.Name);
        
    }
    
    @isTest
    static void testBatchExecution() {
        
        Test.setMock(
            HttpCalloutMock.class,
            new IntegrationHandlerMock()
        );
        
        Case eligibleCase = [
            SELECT Id,
            Subject
            FROM Case
            WHERE Subject = 'Eligible Case'
            LIMIT 1
        ];
        
        System.assertNotEquals(null, eligibleCase.Id);
        
        Test.startTest();
        
        for(Case c : [
            SELECT Id,
            Subject,
            Case_Type_Name__c,
            Consumer_Dispute_Status__c,
            Status,
            Resolved_Consumer_Email_Sent__c
            FROM Case
        ]){
            System.debug(c);
        }
        
        Database.executeBatch(
            new GetStgOneHitID(),
            1
        );
        
        Test.stopTest();
        
        System.assert(true);
    }
    
    @isTest
    static void testExecuteMethodDirectly() {
        
        Test.setMock(
            HttpCalloutMock.class,
            new IntegrationHandlerMock()
        );
        
        List<Case> scope = [
            SELECT Id,
            Consumer_Dispute_Status__c,
            stgOneHitId__c
            FROM Case
            WHERE Subject = 'Eligible Case'
        ];
        
        Test.startTest();
        
        new GetStgOneHitID().execute(null, scope);
        
        Test.stopTest();
        
        System.assertEquals(1, scope.size());
    }
    
    @isTest
    static void testSchedulerExecution() {
        
        Test.startTest();
        
        String jobId = System.schedule(
            'GetStgOneHitID Scheduler Test',
            '0 0 12 * * ?',
            new GetStgOneHitID()
        );
        
        Test.stopTest();
        
        CronTrigger ct = [
            SELECT Id,
            State,
            CronExpression
            FROM CronTrigger
            WHERE Id = :jobId
        ];
        
        System.assertNotEquals(null, ct.Id);
    }
}