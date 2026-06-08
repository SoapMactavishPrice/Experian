@IsTest
public class FeedbackTriggerTest {
    
    private static Account createAccount(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }
    
    private static List<Feedback__c> createFeedbackRecords(Id accId, Integer countRec, Boolean withExternalId){
        
        List<Feedback__c> listFb = new List<Feedback__c>();
        
        for(Integer i=0;i<countRec;i++){
            Feedback__c fb = new Feedback__c(
                //Name = 'Test Feedback ' + i,
                Account__c = accId
            );
            
            if(withExternalId){
                fb.Feedback_External_Id__c = 'EXT-' + i;
            }
            
            listFb.add(fb);
        }
        
        return listFb;
    }
    
    /* -----------------------------------------
       TEST → External Id Auto Population
    ----------------------------------------- */
    @IsTest
    static void testExternalIdAutoPopulate(){
        
        Account acc = createAccount();
        List<Feedback__c> listFb = createFeedbackRecords(acc.Id, 5, false);
        
        Test.startTest();
        insert listFb;
        Test.stopTest();
        
        List<Feedback__c> insertedList = [
            SELECT Id, Feedback_External_Id__c
            FROM Feedback__c
            WHERE Id IN :listFb
        ];
        
        for(Feedback__c fb : insertedList){
            System.assertEquals(fb.Id, fb.Feedback_External_Id__c);
        }
    }
    
    /* -----------------------------------------
       TEST → External Id Already Present
    ----------------------------------------- */
    @IsTest
    static void testExternalIdAlreadyPresent(){
        
        Account acc = createAccount();
        List<Feedback__c> listFb = createFeedbackRecords(acc.Id, 3, true);
        
        Test.startTest();
        insert listFb;
        Test.stopTest();
        
        List<Feedback__c> insertedList = [
            SELECT Feedback_External_Id__c
            FROM Feedback__c
            WHERE Id IN :listFb
        ];
        
        for(Feedback__c fb : insertedList){
            System.assert(fb.Feedback_External_Id__c.startsWith('EXT-'));
        }
    }
    
    /* -----------------------------------------
       TEST → Bulk Insert Coverage
    ----------------------------------------- */
    @IsTest
    static void testBulkInsert(){
        
        Account acc = createAccount();
        List<Feedback__c> listFb = createFeedbackRecords(acc.Id, 200, false);
        
        Test.startTest();
        insert listFb;
        Test.stopTest();
        
        Integer countUpdated = [
            SELECT count()
            FROM Feedback__c
            WHERE Feedback_External_Id__c != NULL
        ];
        
        System.assertEquals(200, countUpdated);
    }
}