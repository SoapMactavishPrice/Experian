@isTest
public class NewCaseLwcController_Test {
    
    @isTest
    static void testCreateCase_AllTrueFlags() {
        // Insert required records
        RecordType csRecType = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND Name = 'Consumer Support Layout' LIMIT 1];
        
        // Queue
        Group queue = new Group(Name = 'Consumer Support Queue', Type = 'Queue');
        insert queue;
        
        // Related lookup values (mocking)
        Case_Type__c ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        
        // Create JSON payload with all flags true
        String json = JSON.serialize(new List<Map<String, Object>>{
            new Map<String, Object>{
                'index' => 1,
                    'Case_Category' => 'Consumer',
                    'Case_Complaints' => 'Report',
                    'Case_Type_Lookup' => ct.Id,
                    'Sub_Type_Lookup' => 'a0LBi000000oIubMAE',
                    'Sub_Type_1_Lookup' => 'a0MBi000000CIQzMAO',
                    'AccountId' => UserInfo.getUserId(),
                    'Displayed_Account_number' => 'ACC1234567',
                    'Displayed_Account_Type' => 'Home Loan',
                    'Contact_Name' => 'John Doe',
                    'ContactPan' => 'ABCDE1234F',
                    'ContactMobileNo' => '9876543210',
                    'DisplayedMobileNo' => '9876543210',
                    'CorrectMobileNo' => '9876543211',
                    'DisplayedEmail' => 'test@example.com',
                    'CorrectEmail' => 'correct@example.com',
                    'DisplayedKYC' => 'OLDPAN1234',
                    'CorrectKYC' => 'NEWPAN5678',
                    'Contact_Date_of_Birth' => '1990-01-01',
                    'Contact_Address' => '123 Test St',
                    'ContactEmailId' => 'contact@example.com',
                    'Contact_Gender' => 'Male',
                    'Displayed_Loan_Balance' => '50000',
                    'Correct_Loan_Balance' => '45000',
                    'Displayed_Overdue_Amount' => '1000',
                    'Correct_Overdue_Amount' => '800',
                    'Displayed_Account_Status' => 'Active',
                    'Correct_Account_Status' => 'Closed',
                    'Correct_Account_Opening_Date' => '2010-05-10',
                    'Displayed_Account_Opening_Date' => '2010-05-01',
                    'Displayed_loan_ownership' => 'Self',
                    'Correct_loan_ownership' => 'Joint',
                    'Displayed_loan_type' => 'Type A',
                    'Correct_loan_type' => 'Type B',
                    'Corrected_Credit_Facility_Status' => 'Corrected',
                    'Displayed_Credit_Facility_Status' => 'Displayed',
                    'Correct_Name' => 'Correct John Doe',
                    'Displayed_Name' => 'John Doe',
                    'Correct_Date_of_Birth' => '1990-01-01',
                    'Displayed_Date_of_Birth' => '1990-01-01',
                    'Displayed_Gender' => 'Male',
                    'Correct_Gender' => 'Male',
                    'Displayed_Mobile_No' => '9876543210',
                    'Correct_Mobile_No' => '9876543211',
                    'Displayed_Address' => 'Old Address',
                    'Correct_Address' => 'New Address',
                    'Origin' => 'Phone',
                    'Date_of_the_email_received' => '2025-07-30',
                    // Boolean flags (all true)
                    'isLoanBalance' => true,
                    'isOverDue' => true,
                    'isAccountStatus' => true,
                    'isAccOpenDate' => true,
                    'isLoanOwner' => true,
                    'isLoanType' => true,
                    'isCredit' => true,
                    'isDName' => true,
                    'isDOB' => true,
                    'isDG' => true,
                    'isMN' => true,
                    'isA1' => true,
                    'isMobileNo' => true,
                    'isEmail' => true,
                    'isKYC' => true
                    }
        });
        
        
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Balance';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Current Balance';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        ProdReusableLookup.SearchWrapper input = new ProdReusableLookup.SearchWrapper();
        input.objectApiName = 'Sub_Type__c';
        input.fieldApiName = 'Name';
        input.searchString = 'Current Balance';
        input.selectedRecordId = stl1.Id;
        
        Test.startTest();
        Map<String, Object> result = NewCaseLwcController.createCase(json);
        List<ProdReusableLookup.ResultWrapper> result1 = ProdReusableLookup.fetchRecords(input);
        ProdReusableLookup.fakeCode();
        Test.stopTest();
        
        
    }


 @isTest
static void testCreateCaseCSV_success() {

    Case_Type__c ct = new Case_Type__c(
        Name='Query',
        Case_Category__c='Consumer',
        Case_Complaint__c='Report'
    );
    insert ct;

    Sub_Type__c st = new Sub_Type__c(
        Name='Status of Dispute',
        Case_Type__c=ct.Id,
        isActive__c=true
    );
    insert st;

    Sub_Type1__c st1 = new Sub_Type1__c(
        Name='Duplicate',
        Sub_Type__c=st.Id,
        isActive__c=true
    );
    insert st1;

    Map<String,Object> row = new Map<String,Object>{
        'Case_Category__c'=>'Consumer',
        'Case_Complaints__c'=>'Report',
        'Case_Type_Lookup__c'=>'Query',
        'Sub_Type_Lookup__c'=>'Status of Dispute',
        'Sub_Type_1_Lookup__c'=>'Duplicate',
        'Date_of_the_email_received__c'=>'23-01-2026',
        'Contact_Date_of_Birth__c'=>'01-01-1990',
        'Displayed_Bank_Name__c'=>'Bank',
        'Displayed_Account_number__c'=>'123',
        'Displayed_Account_Type__c'=>'Loan',
        'Dispute_Detail__c'=>'Test',
        'Contact_Name__c'=>'User',
        'ContactPan__c'=>'ABCDE1234F',
        'ContactMobileNo__c'=>'9999999999',
        'Contact_Address__c'=>'Addr',
        'ContactEmailId__c'=>'test@test.com',
        'Contact_Gender__c'=>'Male',
        'Dis_Ern__c'=>'123'
    };

    String js = JSON.serialize(new List<Object>{row});

    Test.startTest();
    List<Object> result = NewCaseLwcController.createCaseCSV(js);
    Test.stopTest();

    Map<String,Object> res = (Map<String,Object>) result[0];
    System.assertEquals('Success', res.get('Status'));
}


    
}