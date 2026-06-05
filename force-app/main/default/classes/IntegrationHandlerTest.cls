@isTest
public class IntegrationHandlerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test Cases
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 2; i++) {
            Case cs = new Case(
                Contact_Gender__c = 'Male',
                Contact_Address__c = '123 Main St 560001',
                Contact_Name__c = 'John Doe',
                ContactMobileNo__c = '9876543210',
                ContactEmailId__c = 'test@example.com',
                ContactPan__c = 'ABCDE1234F',
                Contact_Date_of_Birth__c = Date.newInstance(1990, 1, 1)
            );
            cases.add(cs);
        }
        insert cases;
        Circle__c c=new Circle__c();
        c.Name='test';
        insert c;
        // Create Pincode Master Data
        Pincode_Master__c pm = new Pincode_Master__c(
            Name = '560001',
            City__c = 'Bangalore',
            State_Code__c = 'KA',
            Circle__c=c.Id
        );
        insert pm;
    }

    @isTest
    static void testGetAccessToken1() {
        Test.startTest();
        String s='';
        Set<Id> caseIds = new Set<Id>();
        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 2; i++) {
            Case cs = new Case(
                Contact_Gender__c = 'Male',
                
                Contact_Name__c = 'John Doe',
                ContactMobileNo__c = '9876543210',
                ContactEmailId__c = 'test@example.com',
                ContactPan__c = 'ABCDE1234F',
                Contact_Date_of_Birth__c = Date.newInstance(1990, 1, 1)
            );
            cases.add(cs);
        }
        for (Case cs : [SELECT Id FROM Case]) {
            s=cs.Id;
            caseIds.add(cs.Id);
        }
        
        TestAccessTokenMock mock = new TestAccessTokenMock();
        Test.setMock(HttpCalloutMock.class, mock);
        
       	IntegrationHandler.getAccessToken1(caseIds,new Map<Id,String>());
       // IntegrationHandler.getAccessToken(caseIds);
        
        IntegrationHandler.seneCreditReport(s,'');
        Test.stopTest();
        
        // Validate API Logs
       // System.assertEquals(2, [SELECT COUNT() FROM API_LOG__c]);
    }
    
     @isTest
    static void testGetAccessToken1Error() {
        
        String s='';
        Set<Id> caseIds = new Set<Id>();
        for (Case cs : [SELECT Id FROM Case]) {
            s=cs.Id;
            caseIds.add(cs.Id);
        }
        
        TestAccessTokenMockError mock = new TestAccessTokenMockError();
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
       	IntegrationHandler.getAccessToken1(caseIds,new Map<Id,String>());
        Test.stopTest();
      
        
        
        // Validate API Logs
       // System.assertEquals(2, [SELECT COUNT() FROM API_LOG__c]);
    }
    
     @isTest
    static void testGetAccessToken2Error() {
        
         Case cs = new Case(
                Contact_Gender__c = 'Male',
                Contact_Address__c = '123 Main St 560001',
                Contact_Name__c = 'John Doe',
                ContactMobileNo__c = '9876543210',
                ContactEmailId__c = 'test@example.com',
                ContactPan__c = 'ABCDE1234F',
                Contact_Date_of_Birth__c = Date.newInstance(1990, 1, 1),
              Credit_Report_Link__c='test'
             );
        insert cs;
      
        
        Test.startTest();
       	IntegrationHandler.seneCreditReport(cs.Id,'');
        Test.stopTest();
    }
    
  
     @isTest
    static void testGetAccessToken3Error() {
        
         Case cs = new Case(
                Contact_Gender__c = 'Male',
                Contact_Address__c = '123 Main St 560001',
                Contact_Name__c = 'John Doe',
                ContactMobileNo__c = '9876543210',
                ContactEmailId__c = 'test@example.com',
                ContactPan__c = 'ABCDE1234F',
                Contact_Date_of_Birth__c = Date.newInstance(1990, 1, 1),
              Credit_Report_Link__c='test'
             );
        insert cs;
      
        List<case> caseList = new List<case>();
        caseList.add(cs);
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.txt',
            VersionData = Blob.valueOf('This is a test file content')
        );
        insert contentVersion;

        // Retrieve the ContentDocumentId from the inserted ContentVersion
          ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];
        String contentDocumentId = cv.ContentDocumentId;
        
        ContentDocument contentDocument = [SELECT Id FROM ContentDocument WHERE Id = :contentDocumentId LIMIT 1];

        ContentDocumentLink cdl = new ContentDocumentLink(
            LinkedEntityId = cs.Id,  // Linking to the Account
            ContentDocumentId = contentDocument.Id, // Use the ContentDocumentId from ContentVersion
            ShareType = 'V',  // Viewer permissions (you can use 'V', 'C', or 'I' for 'Viewer', 'Collaborator', 'Inferred')
            Visibility = 'AllUsers'  // Example visibility
        );

        // Insert the ContentDocumentLink
        //insert cdl;

        Map<String,ContentVersion> mpContentversion = new Map<String,ContentVersion>();
        mpContentversion.put(cs.Id,contentVersion);
       List<API_LOG__c> apiLogList =  new List<API_LOG__c>();
        set<Id> csId = new set<Id>();
        csId.add(cs.Id);
        Test.startTest();
         System.enqueueJob(new ProcessDMLQueueable(caseList,mpContentversion,apiLogList,csId));
        Test.stopTest();
    }
    
    
    
}