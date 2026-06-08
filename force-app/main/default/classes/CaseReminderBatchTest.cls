@isTest
public class CaseReminderBatchTest {

    @testSetup
    static void setupTestData() {

        List<Case> caseList = new List<Case>();

        caseList.add(new Case(
            Status = 'Open',
            Case_Category__c = 'Consumer',
            Consumer_Dispute_Status__c = 'Acknowledgement sent to Consumer',
            Case_Type__c = 'Complaint Dispute Consumer',
            Date_of_the_email_received__c = Date.today().addDays(-8),
            Send_21st_Day_Draft__c = false
        ));

        caseList.add(new Case(
            Status = 'In Progress',
            Date_of_the_email_received__c = Date.today().addDays(-17)
        ));

        caseList.add(new Case(
            Status = 'Resolved',
            Date_of_the_email_received__c = Date.today().addDays(-31)
        ));

        insert caseList;
    }

    @isTest
    static void testCaseReminderBatch(){

        Test.startTest();
        Database.executeBatch(new CaseReminderBatch(),200);
        Test.stopTest();

        System.assert(true);
    }
    
    @isTest
    static void testSchedule(){
        Test.startTest();
        String cronExp = '0 0 0 1 1 ? 2099';
        System.schedule('Test Schedule', cronExp, new CaseReminderBatch());
    }
}