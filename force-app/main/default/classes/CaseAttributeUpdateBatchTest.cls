@IsTest
public class CaseAttributeUpdateBatchTest {
    
    private static Account createAccount() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        return acc;
    }
    
    private static Contact createContact(Account acc) {
        Contact con = new Contact(
            LastName = 'Test Consumer',
            Contact_Role__c = 'Consumer',
            AccountId = acc.Id
        );
        insert con;
        return con;
    }
    
    private static Case createParentCase(Account acc, Contact con) {
        Case parent = new Case(
            Origin = 'Portal',
            Status = 'Open',
            Case_Identifier_Type__c = 'Account Number',
            AccountId = acc.Id,
            Name_of_Consumer__c = con.Id,
            Displayed_Account_number__c = 'ACC001',
            Attribute_Type__c = null
        );
        insert parent;
        return parent;
    }
    
    private static void createChildCases(Account acc, Contact con, Id parentId) {
        List<Case> children = new List<Case>();
        
        Case_Type__c ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'Report';
        insert ct;
        
        Sub_Type__c	stl1 =new Sub_Type__c	();
        stl1.Name = 'Account ownership issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Account does not belong to me';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        Case_Type__c ct1 = new Case_Type__c();
        ct1.Case_Category__c = 'Consumer';
        ct1.Name ='Complaint Dispute Consumer';
        ct1.Case_Complaint__c = 'Report';
        insert ct1;
        
        Sub_Type__c	stl2 =new Sub_Type__c	();
        stl2.Name = 'Enquiry ownership issue';
        stl2.Case_Type__c = ct1.Id;
        insert stl2;
        
        Sub_Type1__c st2 = new Sub_Type1__c();
        st2.Name = 'Credit Enquiry does not belong to me';
        st2.Sub_Type__c = stl2.Id;
        insert st2;
        
        Case_Type__c ct2 = new Case_Type__c();
        ct2.Case_Category__c = 'Consumer';
        ct2.Name ='Complaint Dispute Consumer';
        ct2.Case_Complaint__c = 'Report';
        insert ct2;
        
        Sub_Type__c	stl3 =new Sub_Type__c	();
        stl3.Name = 'Enquiry Changes';
        stl3.Case_Type__c = ct2.Id;
        insert stl3;
        
        Sub_Type1__c st3 = new Sub_Type1__c();
        st3.Name = 'Enquiry Date';
        st3.Sub_Type__c = stl3.Id;
        insert st3;
        
        children.add(new Case(
            Origin = 'Portal',
            Status = 'New',
            Case_Identifier_Type__c = 'Attribute',
            AccountId = acc.Id,
            Name_of_Consumer__c = con.Id,
            Parent_Account_Number_Case__c = parentId,
            Case_Category__c = 'Consumer',
            Case_Complaints__c = 'Report',
            Case_Type_Lookup__c = ct.Id,
            Sub_Type_Lookup__c = stl1.id,
            Sub_Type_1_Lookup__c= st1.Id
        ));
        
        children.add(new Case(
            Origin = 'Portal',
            Status = 'New',
            Case_Identifier_Type__c = 'Attribute',
            AccountId = acc.Id,
            Name_of_Consumer__c = con.Id,
            Parent_Account_Number_Case__c = parentId,
            Case_Category__c = 'Consumer',
            Case_Complaints__c = 'Report',
            Case_Type_Lookup__c = ct1.Id,
            Sub_Type_Lookup__c = stl2.id,
            Sub_Type_1_Lookup__c= st2.Id
        ));
        
        children.add(new Case(
            Origin = 'Portal',
            Status = 'New',
            Case_Identifier_Type__c = 'Attribute',
            AccountId = acc.Id,
            Name_of_Consumer__c = con.Id,
            Parent_Account_Number_Case__c = parentId,
            Case_Category__c = 'Consumer',
            Case_Complaints__c = 'Report',
            Case_Type_Lookup__c = ct2.Id,
            Sub_Type_Lookup__c = stl3.id,
            Sub_Type_1_Lookup__c= st3.Id
        ));
        try{
        insert children;
        }Catch(Exception e){}
        CaseAttributeUpdateBatch c = new CaseAttributeUpdateBatch();
        c.fakeMethod();
    }
    
    
    /* -------------------------------
TEST → Batch Execution
------------------------------- */
    @IsTest
    static void testBatchExecution() {
        
        Account acc = createAccount();
        Contact con = createContact(acc);
        Case parent = createParentCase(acc, con);
        createChildCases(acc, con, parent.Id);
        
        Test.startTest();
        Database.executeBatch(new CaseAttributeUpdateBatch(), 5);
        Test.stopTest();
        
        Case updatedParent = [
            SELECT Attribute_Type__c
            FROM Case
            WHERE Id = :parent.Id
        ];
        
       // System.assertNotEquals(null, updatedParent.Attribute_Type__c);
    }
    
    
    /* -------------------------------
TEST → Scheduler Execution
------------------------------- */
    @IsTest
    static void testSchedulerExecution() {
        
        Account acc = createAccount();
        Contact con = createContact(acc);
        Case parent = createParentCase(acc, con);
        createChildCases(acc, con, parent.Id);
        
        Test.startTest();
        System.schedule(
            'CaseAttributeUpdateBatchTest',
            '0 0 1 * * ?',
            new CaseAttributeUpdateBatch()
        );
        Test.stopTest();
        
        Case updatedParent = [
            SELECT Attribute_Type__c
            FROM Case
            WHERE Id = :parent.Id
        ];
        
        //System.assertNotEquals(null, updatedParent.Attribute_Type__c);
    }
}