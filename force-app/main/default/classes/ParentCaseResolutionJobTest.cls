@isTest
public class ParentCaseResolutionJobTest {
    
    public static Boolean throwTestException = false;
    
    @isTest
    static void testParentResolvedSuccessfully() {
        
        // -----------------------------------------
        // Create Parent Case
        // -----------------------------------------
        Case parentCase = new Case(
            Subject = 'Parent Case',
            Status = 'New',
            Origin = 'Phone'
        );
        insert parentCase;
        
        // -----------------------------------------
        // Create Child Cases (ALL RESOLVED)
        // -----------------------------------------
        List<Case> childCases = new List<Case>();
        
        childCases.add(new Case(
            Subject = 'Child 1',
            Status = 'Resolved',
            Origin = 'Phone',
            Case_Identifier_Type__c = 'Attribute',
            Parent_Account_Number_Case__c = parentCase.Id
        ));
        
        childCases.add(new Case(
            Subject = 'Child 2',
            Status = 'Resolved',
            Origin = 'Phone',
            Case_Identifier_Type__c = 'Attribute',
            Parent_Account_Number_Case__c = parentCase.Id
        ));
        
        insert childCases;
        
        // -----------------------------------------
        // Execute Queueable
        // -----------------------------------------
        Test.startTest();
        ParentCaseResolutionJob.throwTestException = true;
        System.enqueueJob(
            new ParentCaseResolutionJob(
                new Set<Id>{ parentCase.Id }
            )
        );
        
        Test.stopTest();
        
        // -----------------------------------------
        // Verify Parent Updated
        // -----------------------------------------
        parentCase = [
            SELECT Status
            FROM Case
            WHERE Id = :parentCase.Id
        ];
        
        System.assertEquals(
            'Resolved',
            parentCase.Status
        );
    }
    
    
    @isTest
    static void testParentNotResolved() {
        
        // -----------------------------------------
        // Create Parent Case
        // -----------------------------------------
        Case parentCase = new Case(
            Subject = 'Parent Case',
            Status = 'New',
            Origin = 'Phone'
        );
        insert parentCase;
        
        // -----------------------------------------
        // One child not resolved
        // -----------------------------------------
        List<Case> childCases = new List<Case>();
        
        childCases.add(new Case(
            Subject = 'Child 1',
            Status = 'Resolved',
            Origin = 'Phone',
            Case_Identifier_Type__c = 'Attribute',
            Parent_Account_Number_Case__c = parentCase.Id
        ));
        
        childCases.add(new Case(
            Subject = 'Child 2',
            Status = 'Working',
            Origin = 'Phone',
            Case_Identifier_Type__c = 'Attribute',
            Parent_Account_Number_Case__c = parentCase.Id
        ));
        
        insert childCases;
        
        // -----------------------------------------
        // Execute Queueable
        // -----------------------------------------
        Test.startTest();
        
        System.enqueueJob(
            new ParentCaseResolutionJob(
                new Set<Id>{ parentCase.Id }
            )
        );
        
        Test.stopTest();
        
        // -----------------------------------------
        // Verify Parent NOT Updated
        // -----------------------------------------
        parentCase = [
            SELECT Status
            FROM Case
            WHERE Id = :parentCase.Id
        ];
        
        System.assertNotEquals(
            'Resolved',
            parentCase.Status
        );
    }
    
    
    @isTest
    static void testNoChildCases() {
        
        // -----------------------------------------
        // Create Parent Only
        // -----------------------------------------
        Case parentCase = new Case(
            Subject = 'Parent Only',
            Status = 'New',
            Origin = 'Phone'
        );
        insert parentCase;
        
        // -----------------------------------------
        // Execute Queueable
        // -----------------------------------------
        Test.startTest();
        
        System.enqueueJob(
            new ParentCaseResolutionJob(
                new Set<Id>{ parentCase.Id }
            )
        );
        
        Test.stopTest();
        
        // -----------------------------------------
        // Verify No Change
        // -----------------------------------------
        parentCase = [
            SELECT Status
            FROM Case
            WHERE Id = :parentCase.Id
        ];
        
        System.assertEquals(
            'New',
            parentCase.Status
        );
    }
}