@isTest
public class GenAIControllerTest {

    @isTest
    static void testGetCaseClassificationMaster() {
         Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;

        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Balance Issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Current Balance';
        st1.Sub_Type__c = stl1.Id;
        insert st1;

        List<GenAIController.Request> requests = new List<GenAIController.Request>();
        GenAIController.Request req = new GenAIController.Request();
        requests.add(req);

        Test.startTest();
        List<GenAIController.Response> responses = GenAIController.getCaseClassificationMaster(requests);
        Test.stopTest();

        
    }
}