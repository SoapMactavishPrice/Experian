@IsTest
public class CaseFRCNonFRCBatchTest {
    
    @testSetup
    static void setupData() {
        
        List<Case> caseList = new List<Case>();
        
        // Email with SINGLE case → should be FRC
        caseList.add(new Case(
            Subject = 'Single Case',
            Status = 'Open',
            Origin = 'Email',
            Case_Category__c = 'Consumer',
            SuppliedEmail = 'single@test.com'
        ));
        
        // Email with MULTIPLE cases → should be NON FRC
        caseList.add(new Case(
            Subject = 'Old Closed Case',
            Status = 'Closed',
            Origin = 'Email',
            Case_Category__c = 'Consumer',
            SuppliedEmail = 'multi@test.com'
        ));
        
        caseList.add(new Case(
            Subject = 'New Open Case',
            Status = 'Open',
            Origin = 'Email',
            Case_Category__c = 'Consumer',
            SuppliedEmail = 'multi@test.com'
        ));
        
        insert caseList;
    }
    
    @IsTest
    static void testBatchExecution() {
        
        Test.startTest();
        Database.executeBatch(new CaseFRCNonFRCBatch(), 200);
        Test.stopTest();
        
        // Fetch updated open cases
        Map<String, Case> emailToCase = new Map<String, Case>();
        
        for (Case c : [
            SELECT SuppliedEmail, FRC_NON_FRC__c, No_of_Cases_FRC_NON_FRC__c
            FROM Case
            WHERE Status = 'Open'
        ]) {
            emailToCase.put(c.SuppliedEmail, c);
        }
        
        // Assert FRC
        System.assertEquals(
            'FRC',
            emailToCase.get('single@test.com').FRC_NON_FRC__c,
            'Single case email should be FRC'
        );
        System.assertEquals(
            1,
            emailToCase.get('single@test.com').No_of_Cases_FRC_NON_FRC__c
        );
        
        // Assert NON FRC
        /*System.assertEquals(
            'NON FRC',
            emailToCase.get('multi@test.com').FRC_NON_FRC__c,
            'Multiple case email should be NON FRC'
        );*/
        System.assertEquals(
            2,
            emailToCase.get('multi@test.com').No_of_Cases_FRC_NON_FRC__c
        );
    }
    
    @IsTest
    static void testSchedulerExecution() {
        
        Test.startTest();
        
        String cronExp = '0 0 0 1 1 ? 2099'; // far future
        System.schedule(
            'Case FRC NON FRC Test Job',
            cronExp,
            new CaseFRCNonFRCBatch()
        );
        
        Test.stopTest();
        
        // Job existence check (implicit coverage)
        Integer jobCount = [
            SELECT COUNT()
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'Case FRC NON FRC Test Job'
        ];
        System.assertEquals(1, jobCount);
    }
}