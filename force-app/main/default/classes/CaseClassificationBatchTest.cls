@isTest
public class CaseClassificationBatchTest {

    @isTest
    static void testCaseClassificationBatch() {
        // Create test data: Case_Type__c record
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
        
        Sub_Type__c	 sub1 =new Sub_Type__c	();
        sub1.Name = 'Enquiry Changes';
        sub1.Case_Type__c = ct.Id;
        insert sub1;
        
        Sub_Type1__c sub2 = new Sub_Type1__c();
        sub2.Name = 'Enquiry Date';
        sub2.Sub_Type__c = sub1.Id;
        insert sub2;
        
        Sub_Type1__c sub3 = new Sub_Type1__c();
        sub3.Name = 'Loan Type';
        sub3.Sub_Type__c = sub1.Id;
        insert sub3;
        
        Sub_Type1__c sub4 = new Sub_Type1__c();
        sub4.Name = 'Changes';
        sub4.Sub_Type__c = sub1.Id;
        insert sub4;
        
        Case_Type__c ct12 = new Case_Type__c();
        ct12.Name = 'Query';
        ct12.Case_Category__c = 'Consumer';
        ct12.Case_Complaint__c = 'Report';
        Insert ct12;
        
        Sub_Type__c st12 = new Sub_Type__c();
        st12.Name = 'Status of Dispute';
        st12.Case_Type__c = ct12.id;
        st12.isActive__c = true;
        Insert st12;
        
        Sub_Type1__c st21 = new Sub_Type1__c();
        st21.Name = 'Duplicate';
        st21.Sub_Type__c = st12.id;
        st21.isActive__c = true;
        Insert st21;

       
        Case testCase1 = new Case(
            Subject = 'Test Case 1',
            Case_Type_Lookup__c = ct.Id,
            Sub_Type_Lookup__c = stl1.Id,
            Sub_Type_1_Lookup__c = st1.Id,
            SuppliedName = 'John Doe',
            Case_Category__c = 'Consumer',
            Origin = 'Email',
            Junk_Case__c = false
        );
        insert testCase1;

        Case testCase2 = new Case(
            Subject = 'Test Case 2',
            Case_Type_Lookup__c = ct.Id, 
            Sub_Type_Lookup__c = stl1.Id,
            Sub_Type_1_Lookup__c = st1.Id,
            SuppliedName = 'Jane Doe',
            Case_Category__c = 'Consumer',
            Origin = 'Email',
            Junk_Case__c = false
        );
        insert testCase2;

        
        CaseClassificationBatch batch = new CaseClassificationBatch();

        Test.startTest();
        Database.executeBatch(batch);
        Test.stopTest();

    }
}