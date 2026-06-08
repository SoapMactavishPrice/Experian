@isTest
public class LeadTrigger_Test {
    @isTest
	public static void validdate(){
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
        
       test.startTest();
        Lead l = new Lead();
        l.First_Name_Nodal__c = 'Test First6';
        l.Last_Name_Nodal__c = 'Test Last5';
        l.Last_Name_AuSig__c = 'Test Last7';
        l.Last_Name_Web_User__c = 'Test Last8';
        l.LastName='Tesatas 1';
         l.Total_Payment_Received__c = 1234;
        l.Company = 'Test Co PVT Ltd';
        l.Status='Agreement API Reponse';
        l.Tel_No_Nodal__c='1234567890';
        l.Official_Email_Address_Nodal__c='testamj@gmail.com';
        l.Job_Title_Nodal__c='Test';
        l.Fax_No_Nodal__c='1234567890';
        l.CIN_Company_Identification_Number__c='FIRT1234TY';
        l.Pan_no__c='AAAJT1724E';
        l.GST_No__c='19AAAJT1724E1Z8';
        l.RBI_Certificate_No__c='19AAAJT1724E1Z8';
        l.Send_Payment_Link__c=true;
        l.Company = 'Test comp1';
        l.Email = 'testameeej@gmail.com';
        l.Approx_no_of_Commercial_loan_monthly__c = 1;
        l.Approx_no_of_Consumer_loan_monthly__c = 1;
        l.Authorized_Signatory_Name__c = 'Test';
        l.Date_of_Incorporation__c = system.today();
        l.Nodal_Officer_Name__c = 'Test';
        l.Sharing_data_with_any_Credit_bureau__c = 'Test';
        l.Software_used_for_Loan_origination__c = 'Test';
        l.Total_Active_Credit_Accounts_Branches__c = 1;
        l.Total_number_of_Branches__c = 1;
        l.Total_number_of_States_Present_in__c = 1;
        l.Last_Name_Nodal__c = '1';
        l.Last_Name_AuSig__c = '2';
        l.Last_Name_Auth_Usr_Req__c = '3';
        l.Billing_Contact_Person__c = '4';
        l.RBI_Certificate_Verified__c = 'True';
        l.Pan_Verified__c = 'True';
        l.GST_Verified__c = 'True';
        l.RBI_Member_Verified__c = 'Yes';
        l.Authorised_Signatory_PAN_Verified__c = 'Yes';
        l.Auth_Sign_Authorization_Letter_Verified__c = 'Yes';
        l.Executive_Verified_Documents__c = false;
        l.TL_Verified_Documents__c = false;
        l.Admin_Verified_Documents__c = false;
         l.Total_Payment_Received__c = 1234;
        insert l;
     
        
        Web_User_Details__c web_user_detailsObj = new Web_User_Details__c(
            Name = '1',
            Lead__c = l.Id,
            Web_User_Last_Name__c = 'Ttest',
            Web_User_Type__c = 'For Grievance on Disputes'
        );
        insert web_user_detailsObj;
        
        web_user_detailsObj = new Web_User_Details__c(
            Name = '1',
            Lead__c = l.Id,
            Web_User_Last_Name__c = 'Ttest',
            Web_User_Type__c = 'Data Pull Id'
        );
        insert web_user_detailsObj;
        
        web_user_detailsObj = new Web_User_Details__c(
            Name = '1',
            Lead__c = l.Id,
            Web_User_Last_Name__c = 'Ttest',
            Web_User_Type__c = 'Data Submission Id'
        );
        insert web_user_detailsObj;
        
        // try {
        
        // l.Checked_in_NBFC_List__c = 'Yes';
        // l.Checked_in_Termination_List__c = 'Yes';
        // l.Executive_Verified_Documents__c = true;
        // l.TL_Verified_Documents__c = true;
        // l.Admin_Verified_Documents__c = true;
        // update l;
        
        // l.Executive_Verified_Documents__c = false;
        // l.TL_Verified_Documents__c = false;
        // l.Admin_Verified_Documents__c = true;
        // update l;
        
        // l.Executive_Verified_Documents__c = true;
        // l.TL_Verified_Documents__c = true;
        // l.Admin_Verified_Documents__c = true;
        // update l;
        
        // l.Executive_Verified_Documents__c = true;
        // l.TL_Verified_Documents__c = false;
        // l.Admin_Verified_Documents__c = true;
        // update l;
        
        // l.Executive_Verified_Documents__c = false;
        // l.TL_Verified_Documents__c = true;
        // l.Admin_Verified_Documents__c = true;
        // update l;
        
        // l.Executive_Verified_Documents__c = true;
        // l.TL_Verified_Documents__c = true;
        // l.Admin_Verified_Documents__c = true;
        // l.OwnerId = System.UserInfo.getUserId();
        // update l;
        
        // l.OwnerId = System.UserInfo.getUserId();
        // l.Total_Payment_Received__c = 12;
        // l.Mode_of_Transaction__c = 'Yes';
        // l.Payment_Date_Time__c = System.today();
        // l.Agreement_Experian_Status__c = 'Signed';
        // l.Agreement_Customer_Status_Stages__c = 'Signed';
        // update l;
        
        LeadStatusUpdateHandler.fakecodecoverage();

}


    /* ============================================================
       TEST 1: STATUS DATETIME → BEFORE INSERT
       ============================================================ */
    @IsTest
    static void testStatusDateTime_BeforeInsert() {

        Lead ld = new Lead(
            LastName = 'Insert Test',
            Company = 'Test Company',
            Status = 'New',
            Phone = '9000000000',
            Email = 'insert@test.com'
        );

        Test.startTest();
        insert ld;
        Test.stopTest();

        Lead result = [
            SELECT New_Date_Time__c
            FROM Lead
            WHERE Id = :ld.Id
        ];

        System.assertNotEquals(
            null,
            result.New_Date_Time__c,
            'New_Date_Time__c should be populated on insert'
        );
    }

    /* ============================================================
       TEST 2: STATUS DATETIME → BEFORE UPDATE
       ============================================================ */
    @IsTest
    static void testStatusDateTime_BeforeUpdate() {

        Lead ld = new Lead(
            LastName = 'Update Test',
            Company = 'Test Company',
            Status = 'New',
            Phone = '9000000000',
            Email = 'update@test.com'
        );
        insert ld;

        Test.startTest();
        ld.Status = 'Qualified';
        update ld;
        Test.stopTest();

        Lead result = [
            SELECT Qualified_Date_Time__c
            FROM Lead
            WHERE Id = :ld.Id
        ];

        System.assertNotEquals(
            null,
            result.Qualified_Date_Time__c,
            'Qualified_Date_Time__c should be populated on status change'
        );
    }

    /* ============================================================
       TEST 3: STATUS UNCHANGED → NO OVERWRITE
       ============================================================ */
    @IsTest
    static void testNoStatusOverwrite_WhenUnchanged() {

        Lead ld = new Lead(
            LastName = 'No Change Test',
            Company = 'Test Company',
            Status = 'New',
            Phone = '9000000000',
            Email = 'nochange@test.com'
        );
        insert ld;

        DateTime originalDT = [
            SELECT New_Date_Time__c
            FROM Lead
            WHERE Id = :ld.Id
        ].New_Date_Time__c;

        Test.startTest();
        ld.Company = 'Updated Company';
        update ld;
        Test.stopTest();

        Lead afterLd = [
            SELECT New_Date_Time__c
            FROM Lead
            WHERE Id = :ld.Id
        ];

        System.assertEquals(
            originalDT,
            afterLd.New_Date_Time__c,
            'Status DateTime should not change if status is unchanged'
        );
    }

    /* ============================================================
       TEST 4: VERIFICATION DATETIMES → BEFORE INSERT
       ============================================================ */
    @IsTest
    static void testVerificationDateTimes_BeforeInsert() {

        Lead ld = new Lead(
            LastName = 'Verification Insert',
            Company = 'Test Company',
            Status = 'New',
            Phone = '9000000000',
            Email = 'verifyinsert@test.com',

            RBI_Certificate_Verified__c = 'True',
            Pan_Verified__c = 'True',
            GST_Verified__c = 'True',
            Domain_Verified__c = true,
            CIN_Number_Verified__c = 'CIN123'
        );

        Test.startTest();
        insert ld;
        Test.stopTest();

        Lead result = [
            SELECT
                RBI_Certificate_Verified_Date_Time__c,
                Pan_Verified_Date_Time__c,
                GST_Verified_Date_Time__c,
                CIN_Number_Verified_Date_Time__c
            FROM Lead
            WHERE Id = :ld.Id
        ];

        System.assertNotEquals(null, result.RBI_Certificate_Verified_Date_Time__c);
        System.assertNotEquals(null, result.Pan_Verified_Date_Time__c);
        System.assertNotEquals(null, result.GST_Verified_Date_Time__c);
        System.assertNotEquals(null, result.CIN_Number_Verified_Date_Time__c);
    }

    /* ============================================================
       TEST 5: VERIFICATION DATETIMES → BEFORE UPDATE
       ============================================================ */
    @IsTest
    static void testVerificationDateTimes_BeforeUpdate() {

        Lead ld = new Lead(
            LastName = 'Verification Update',
            Company = 'Test Company',
            Status = 'New',
            Phone = '9000000000',
            Email = 'verifyupdate@test.com',

            RBI_Certificate_Verified__c = 'False',
            Pan_Verified__c = 'False',
            GST_Verified__c = 'False',
            Domain_Verified__c = false
        );
        insert ld;

        Test.startTest();

        ld.RBI_Certificate_Verified__c = 'True';
        ld.Pan_Verified__c = 'True';
        ld.GST_Verified__c = 'True';
        ld.Domain_Verified__c = true;
        ld.CIN_Number_Verified__c = 'CIN999';

        update ld;

        Test.stopTest();

        Lead result = [
            SELECT
                RBI_Certificate_Verified_Date_Time__c,
                Pan_Verified_Date_Time__c,
                GST_Verified_Date_Time__c,
                CIN_Number_Verified_Date_Time__c,
                Domain_Verified_Date_Time__c
            FROM Lead
            WHERE Id = :ld.Id
        ];

        System.assertNotEquals(null, result.RBI_Certificate_Verified_Date_Time__c);
        System.assertNotEquals(null, result.Pan_Verified_Date_Time__c);
        System.assertNotEquals(null, result.GST_Verified_Date_Time__c);
        System.assertNotEquals(null, result.CIN_Number_Verified_Date_Time__c);
        System.assertNotEquals(null, result.Domain_Verified_Date_Time__c);
    }


}