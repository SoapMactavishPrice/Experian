@isTest
public class DisputeLifecycleServiceTest {
    
    @isTest
    static void testHandleInsert() {
        
        // -----------------------------------------
        // Create Case
        // -----------------------------------------
        Case cs = new Case(
            Subject = 'Portal Case',
            Status = 'New',
            Origin = 'Portal',
            Date_of_the_email_received__c = Date.today(),
            Dispute_Raised_Date__c = Date.today(),
            Consumer_Dispute_Status__c =
                'Acknowledgement sent to Consumer',
            First_Time_Referred_To_IO__c = true,
            IO_Status__c =
                'Seeking Further Information - Member'
        );
        
        insert cs;
        
        // -----------------------------------------
        // Execute
        // -----------------------------------------
        Test.startTest();
        
        DisputeLifecycleService.handleInsert(
            new List<Case>{ cs }
        );
        
        Test.stopTest();
        
        // -----------------------------------------
        // Verify Records
        // -----------------------------------------
        List<Dispute_Lifecycle__c> dlList = [
            SELECT Id,
                   Type__c,
                   Case__c
            FROM Dispute_Lifecycle__c
            WHERE Case__c = :cs.Id
        ];
        
        System.assert(dlList.size() > 0);
    }
    
    
    @isTest
    static void testHandleUpdate() {
        
        // -----------------------------------------
        // Create Initial Case
        // -----------------------------------------
        Case cs = new Case(
            Subject = 'Update Case',
            Status = 'New',
            Origin = 'Portal'
        );
        
        insert cs;
        
        // OLD MAP SIMULATION
        Case oldCase =
            cs.clone(false, true, false, false);
        
        // -----------------------------------------
        // Update Values
        // -----------------------------------------
        cs.Dispute_Raised_Date__c = Date.today();
        
        cs.Consumer_Dispute_Status__c =
            'Resolved in favour of the Consumer';
        
        cs.IO_Status__c =
            'Seeking Further Information - Consumer';
        
        cs.Status = 'Resolved';
        
        cs.First_Time_Referred_To_IO__c = true;
        
        cs.Date_of_the_email_received__c =
            Date.today();
        
        // -----------------------------------------
        // Execute
        // -----------------------------------------
        Test.startTest();
        
        DisputeLifecycleService.handleUpdate(
            new List<Case>{ cs },
            new Map<Id, Case>{
                cs.Id => oldCase
            }
        );
        
        Test.stopTest();
        
        // -----------------------------------------
        // Verify Lifecycle Created
        // -----------------------------------------
        List<Dispute_Lifecycle__c> dlList = [
            SELECT Id,
                   Type__c
            FROM Dispute_Lifecycle__c
            WHERE Case__c = :cs.Id
        ];
        
        System.assert(dlList.size() > 0);
    }
    
    
    @isTest
    static void testDuplicateLifecyclePrevention() {
        
        // -----------------------------------------
        // Create Case
        // -----------------------------------------
        Case cs = new Case(
            Subject = 'Duplicate Test',
            Status = 'Resolved',
            Origin = 'Portal'
        );
        
        insert cs;
        
        // Existing lifecycle
        insert new Dispute_Lifecycle__c(
            Case__c = cs.Id,
            Type__c = 'Resolved',
            Actioned_By_Type__c = 'User',
            Actioned_By_User__c = UserInfo.getUserId(),
            Actioned_Date__c = Date.today()
        );
        
        Case oldCase =
            cs.clone(false, true, false, false);
        
        // Trigger same condition again
        cs.Status = 'Resolved';
        
        Test.startTest();
        
        DisputeLifecycleService.handleUpdate(
            new List<Case>{ cs },
            new Map<Id, Case>{
                cs.Id => oldCase
            }
        );
        
        Test.stopTest();
    }
    
    
    @isTest
    static void testNonPortalCase() {
        
        // -----------------------------------------
        // Origin != Portal
        // -----------------------------------------
        Case cs = new Case(
            Subject = 'Phone Case',
            Status = 'New',
            Origin = 'Phone'
        );
        
        insert cs;
        
        Test.startTest();
        
        DisputeLifecycleService.handleInsert(
            new List<Case>{ cs }
        );
        
        Test.stopTest();
        
        // Verify nothing created
        Integer countLifecycle = [
            SELECT COUNT()
            FROM Dispute_Lifecycle__c
            WHERE Case__c = :cs.Id
        ];
        
        System.assertEquals(0, countLifecycle);
    }
}