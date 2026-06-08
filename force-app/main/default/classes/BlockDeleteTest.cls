@isTest
public class BlockDeleteTest {
    
    @isTest
    static void testDeleteBlocked_AllObjects() {
        
        // Create test data
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        Case cs = new Case(Subject = 'Test Case', Status = 'New', Origin = 'Phone');
        insert cs;
        
        Lead ld = new Lead(LastName = 'Test Lead', Company = 'Test Company');
        insert ld;
        
        Test.startTest();
        
        // Account Delete Test
        try {
            delete acc;
            System.assert(false, 'Account delete should have been blocked');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Deletion is not allowed'));
        }
        
        // Case Delete Test
        try {
            delete cs;
            System.assert(false, 'Case delete should have been blocked');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Deletion is not allowed'));
        }
        
        // Lead Delete Test
        try {
            delete ld;
            System.assert(false, 'Lead delete should have been blocked');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Deletion is not allowed'));
        }
        
        Test.stopTest();
    }
}