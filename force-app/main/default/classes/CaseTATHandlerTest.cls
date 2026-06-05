@isTest
public class CaseTATHandlerTest {
    
    @isTest
    static void testFullFlow() {
        
        // Step 1: Create Case WITHOUT Forward field
        Case c = new Case(
            Subject = 'Test Case',
            Status = 'New',
            Origin = 'Phone'
        );
        insert c;
        
        // -------------------------------------------------
        // Step 2: Update Forward_to_Bank_Date__c → CREATE
        // -------------------------------------------------
        c = [SELECT Id, Forward_to_Bank_Date__c FROM Case WHERE Id = :c.Id];
        
        c.Forward_to_Bank_Date__c = Date.today();
        
        Test.startTest();
        update c;
        //Test.stopTest();
        
        // Verify creation
        List<Dispute_Lifecycle__c> dlList = [
            SELECT Id, Case__c
            FROM Dispute_Lifecycle__c
            WHERE Case__c = :c.Id
        ];
        
        //System.assertEquals(1, dlList.size(), 'Record should be created');
        
        // -------------------------------------------------
        // Step 3: Update Last_Reply_from_Bank_Team__c → UPDATE
        // -------------------------------------------------
        c = [SELECT Id, Last_Reply_from_Bank_Team__c FROM Case WHERE Id = :c.Id];
        
        c.Last_Reply_from_Bank_Team__c = Date.today();
        CaseTATHandler.throwTestException = true;
        //Test.startTest();
        update c;
        Test.stopTest();
        
        dlList = [
            SELECT Last_Reply_Date__c
            FROM Dispute_Lifecycle__c
            WHERE Case__c = :c.Id
        ];
        
        System.assertEquals(Date.today(), dlList[0].Last_Reply_Date__c, 'Reply date should be updated');
    }
}