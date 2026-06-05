@isTest
public class ParentStatusHandlerTest {   
    @isTest
    static void testParentStatusUpdated_FIXED() {
    
        Case parentCase = new Case(
            Subject = 'Parent',
            Status = 'New',
            Origin = 'Phone'
        );
        insert parentCase;
    
        List<Case> children = new List<Case>();
    
        children.add(new Case(
            Subject = 'C1',
            Status = 'New',
            Origin = 'Phone',
            Case_Identifier_Type__c = 'Attribute',
            Parent_Account_Number_Case__c = parentCase.Id,
            Maker_Status__c = 'Reject',
            Checker_Status__c = 'Accept',
            Maker_Sub_Status__c = 'Fully Rejected'
        ));
    
        children.add(new Case(
            Subject = 'C2',
            Status = 'New',
            Origin = 'Phone',
            Case_Identifier_Type__c = 'Attribute',
            Parent_Account_Number_Case__c = parentCase.Id,
            Maker_Status__c = 'Reject',
            Checker_Status__c = 'Accept',
            Maker_Sub_Status__c = 'Fully Rejected'
        ));
    
        insert children;
    
        List<Case> updated = [
            SELECT Id, Checker_Status__c,
                   Maker_Status__c,
                   Maker_Sub_Status__c,
                   Parent_Account_Number_Case__c,
                   Case_Identifier_Type__c
            FROM Case
            WHERE Id IN :children
        ];
    
        Map<Id, Case> oldMap = new Map<Id, Case>();
    
        for(Case c : updated){
    
            Case oldRec = c.clone(false, true, false, false);
            oldRec.Checker_Status__c = 'Reject';
    
            oldMap.put(c.Id, oldRec);
    
            c.Checker_Status__c = 'Accept';
        }
    
        Test.startTest();
    
        ParentStatusHandler.throwTestException = true;
    
        ParentStatusHandler.updateParentStatus(updated, oldMap);
    
        Test.stopTest();
    
        parentCase = [
            SELECT Account_Level_Status__c
            FROM Case
            WHERE Id = :parentCase.Id
        ];
    
        System.assertEquals(
            'Pending With Experian',
            parentCase.Account_Level_Status__c
        );
    }
}