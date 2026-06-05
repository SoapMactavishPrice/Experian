@isTest
public class MembershipDocumentControllerTest {

    @testSetup
    static void setupTestData() {
        // Create lookup dependency records just in case they are required by system triggers/validation
        Case_Type__c ct = new Case_Type__c(
            Name = 'Query',
            Case_Category__c = 'Consumer',
            Case_Complaint__c = 'Report'
        );
        insert ct;
        
        Sub_Type__c st = new Sub_Type__c(
            Name = 'Status of Dispute',
            Case_Type__c = ct.Id,
            isActive__c = true
        );
        insert st;
        
        Sub_Type1__c st21 = new Sub_Type1__c(
            Name = 'Duplicate',
            Sub_Type__c = st.Id,
            isActive__c = true
        );
        insert st21;

        // Create a test Lead record (this should automatically invoke the trigger to create 6 Membership_Document__c records)
        Lead l = new Lead(
            First_Name_Nodal__c = 'Test First',
            Last_Name_Nodal__c = 'Test Last',
            Last_Name_AuSig__c = 'Test Auth',
            Last_Name_Web_User__c = 'Test Web',
            LastName = 'Test Lead',
            Company = 'Test Company Pvt Ltd',
            Status = 'Open',
            Tel_No_Nodal__c = '1234567890',
            Official_Email_Address_Nodal__c = 'test@example.com',
            Job_Title_Nodal__c = 'Manager',
            Fax_No_Nodal__c = '1234567890',
            CIN_Company_Identification_Number__c = 'FIRT1234TY',
            Pan_no__c = 'AAAJT1724E',
            GST_No__c = '19AAAJT1724E1Z8',
            RBI_Certificate_No__c = '19AAAJT1724E1Z8'
        );
        insert l;
    }

    @isTest
    static void testGetMembershipDocuments() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        
        Test.startTest();
        List<Membership_Document__c> docs = MembershipDocumentController.getMembershipDocuments(testLead.Id);
        Test.stopTest();
        
        System.assertNotEquals(0, docs.size(), 'There should be membership documents created for the Lead.');
    }

    @isTest
    static void testGetPicklistValues() {
        Test.startTest();
        Map<String, List<String>> picklists = MembershipDocumentController.getPicklistValues();
        Test.stopTest();
        
        System.assert(picklists.containsKey('Executive'), 'Map should contain Executive status values');
        System.assert(picklists.containsKey('TL'), 'Map should contain TL status values');
        System.assert(picklists.containsKey('Admin'), 'Map should contain Admin status values');
    }

    @isTest
    static void testSaveMembershipDocuments() {
        Lead testLead = [SELECT Id FROM Lead LIMIT 1];
        List<Membership_Document__c> docs = MembershipDocumentController.getMembershipDocuments(testLead.Id);
        
        System.assertNotEquals(0, docs.size(), 'Docs list should not be empty');
        
        // Update first doc fields
        Membership_Document__c firstDoc = docs[0];
        firstDoc.Executive_Comments__c = 'Test Exec Comment';
        firstDoc.TL_Comments__c = 'Test TL Comment';
        firstDoc.Admin_Comments__c = 'Test Admin Comment';
        firstDoc.Is_Exception__c = true;
        firstDoc.Exception_Valid_Till__c = System.today().addDays(30);
        firstDoc.Exception_Notes__c = 'Test exception notes';
        
        Test.startTest();
        MembershipDocumentController.saveMembershipDocuments(new List<Membership_Document__c>{ firstDoc });
        Test.stopTest();
        
        // Query again to verify
        List<Membership_Document__c> updatedDocs = MembershipDocumentController.getMembershipDocuments(testLead.Id);
        Membership_Document__c updatedFirstDoc;
        for (Membership_Document__c doc : updatedDocs) {
            if (doc.Id == firstDoc.Id) {
                updatedFirstDoc = doc;
                break;
            }
        }
        
        System.assertNotEquals(null, updatedFirstDoc, 'Updated document should be found');
        System.assertEquals('Test Exec Comment', updatedFirstDoc.Executive_Comments__c, 'Executive comments should be updated');
        System.assertEquals('Test TL Comment', updatedFirstDoc.TL_Comments__c, 'TL comments should be updated');
        System.assertEquals(true, updatedFirstDoc.Is_Exception__c, 'Is Exception should be true');
    }

    @isTest
    static void testInitializeDocuments() {
        // Create a new Lead but bypass automatic doc creation or manually delete them to test initialization
        Lead l2 = new Lead(
            First_Name_Nodal__c = 'Test First2',
            Last_Name_Nodal__c = 'Test Last2',
            Last_Name_AuSig__c = 'Test Auth2',
            Last_Name_Web_User__c = 'Test Web2',
            LastName = 'Test Lead 2',
            Company = 'Test Company 2',
            Status = 'Open',
            Tel_No_Nodal__c = '1234567890',
            Official_Email_Address_Nodal__c = 'test2@example.com',
            Job_Title_Nodal__c = 'Manager',
            Fax_No_Nodal__c = '1234567890',
            CIN_Company_Identification_Number__c = 'FIRT1234TZ',
            Pan_no__c = 'AAAJT1724F',
            GST_No__c = '19AAAJT1724E1Z9',
            RBI_Certificate_No__c = '19AAAJT1724E1Z9'
        );
        insert l2;

        // Delete automatically created documents for l2 to simulate a Lead with no documents
        List<Membership_Document__c> docsToDelete = [SELECT Id FROM Membership_Document__c WHERE Lead__c = :l2.Id];
        delete docsToDelete;

        Test.startTest();
        List<Membership_Document__c> docs = MembershipDocumentController.initializeDocuments(l2.Id);
        Test.stopTest();

        System.assertNotEquals(0, docs.size(), 'Documents should have been initialized');
    }
}
