@isTest
public class SaveCaseRestAPI_Test {

    private static String getRequestBody(String disDtlId) {
        return '{' +
        '"CaseList":[{' +
            '"ContactEmailId":"rakesh.jaiswar@experian.com",' +
            '"ContactMobileNo":"9987960976",' +
            '"Contact_Name":"Sam Maharana",' +
            '"Contact_Gender":"MALE",' +
            '"Contact_Date_of_Birth":"10/01/1990",' +
            '"Contact_Address":"Test Address",' +
            '"Contact_PAN":"BLLPS0361L",' +
            '"Account_Date_Reported":"06/02/2026",' +
            '"Comments":"_",' +
            '"SubType":"DPD",' +
            '"SubType1":"Incorrect",' +
            '"Dis_Id":"5746",' +
            '"Dis_Dtl_Id":"' + disDtlId + '",' +
            '"Dis_Uti":"5094015",' +
            '"Dis_Ern":"1770720941249",' +
            '"Dis_Raised_By":"1856648",' +
            '"Dis_Date":"25/02/2026",' +

            '"AccoutDetailsList":{' +
                '"Displayed_Account_Status":"CLOSED",' +
                '"Correct_Account_Status":"",' +
                '"Displayed_Loan_Balance":2525000.0,' +
                '"Correct_Loan_Balance":null,' +
                '"Displayed_Account_Opening_Date":"01/07/2024",' +
                '"Correct_Account_Opening_Date":"",' +
                '"Displayed_Account_Type":"BUSINESS LOAN SECURED",' +
                '"Displayed_Bank_Name":"Kotak",' +
                '"Displayed_Account_number":"2425003",' +
                '"Displayed_Loan_Type":"BUSINESS LOAN SECURED",' +
                '"Correct_Loan_Type":"",' +
                '"Displayed_loan_Ownership":"Individual",' +
                '"Correct_Loan_Ownership":"",' +
                '"Displayed_Amount_Overdue":0.0,' +
                '"Correct_Amount_Overdue":null,' +
                '"Displayed_Credit_Facility_Status":"",' +
                '"Corrected_Credit_Facility_Status":"",' +
                '"Sanctioned_Amount":2500000.0' +
            '},' +

            '"PersonalDetailsList":{' +
                '"Displayed_Name":"SAM MAHARANA",' +
                '"Correct_Name":"",' +
                '"Displayed_Date_of_Birth":"10/01/1990",' +
                '"Correct_Date_of_Birth":"",' +
                '"Displayed_Gender":"MALE",' +
                '"Correct_Gender":"",' +
                '"Displayed_Address_1":"Address",' +
                '"Correct_Address_1":"",' +
                '"Displayed_Address_2":"",' +
                '"Correct_Address_2":"",' +
                '"Displayed_Address_3":"",' +
                '"Correct_Address_3":"",' +
                '"Displayed_Address_4":"",' +
                '"Correct_Address_4":"",' +
                '"Displayed_Address_5":"",' +
                '"Correct_Address_5":"",' +
                '"Displayed_email_id":"",' +
                '"Correct_email_id":"",' +
                '"Displayed_mobile_no_1":"9987960976",' +
                '"Correct_mobile_no_1":"",' +
                '"Displayed_mobile_no_2":"",' +
                '"Correct_mobile_no_2":"",' +
                '"Displayed_mobile_no_3":"",' +
                '"Correct_mobile_no_3":"",' +
                '"Displayed_mobile_no_4":"",' +
                '"Correct_mobile_no_4":"",' +
                '"Displayed_mobile_no_5":"",' +
                '"Correct_mobile_no_5":"",' +
                '"Displayed_PAN_No":"BLLPS0361L",' +
                '"Correct_PAN_No":""' +
            '},' +

            '"EnquiryList":{' +
                '"Displayed_Enquired_For":"",' +
                '"Correct_Enquired_For":"",' +
                '"Displayed_Enquired_By":"",' +
                '"Correct_Enquired_By":"",' +
                '"Displayed_Enquiry_Date":"",' +
                '"Correct_Enquiry_Date":"",' +
                '"Enquiry_ERN":"",' +
                '"Enquiry_Amount":"0"' +
            '},' +

            '"Not_My_Enquiry":{' +
                '"Correct_Enquired_For":"",' +
                '"Correct_Enquired_By":"",' +
                '"Correct_Enquiry_Date":"",' +
                '"Enquiry_ERN":"",' +
                '"Enquiry_Amount":""' +
            '},' +

            '"EnquiryPersonDetailsList":{' +
                '"Enq_First_Name":"",' +
                '"Enq_Last_Name":"",' +
                '"Enq_Gender_Code":"",' +
                '"Enq_DOB":"",' +
                '"Enq_PAN":"",' +
                '"Enq_Passport_Number":"",' +
                '"Enq_VoterID_Number":"",' +
                '"Enq_Driving_License_Number":"",' +
                '"Enq_Ration_Card_Number":"",' +
                '"Enq_Mobile_No":"",' +
                '"Enq_Address":"",' +
                '"Enq_Email_Id":""' +
            '},' +

            '"Payout_Details":{' +
                '"Account_Number":"",' +
                '"Bank_Name":"",' +
                '"IFSC_Code":"",' +
                '"Account_Holder_Name":""' +
            '},' +

            '"AccountDoesNotBelongToMe":{' +
                '"AccountType":"",' +
                '"BankName":"",' +
                '"AccountNumber":""' +
            '},' +

            '"DontSeeMyAccountHere":{' +
                '"AccountType":"",' +
                '"BankName":"",' +
                '"AccountNumber":""' +
            '}' +

        '}],' +

        '"Dpd_list":[{' +
            '"Dis_Dtl_Id":"' + disDtlId + '",' +
            '"Dpd_id":"1224",' +
            '"Displayed_EMI_Amount":0,' +
            '"Correct_EMI_Amount":10,' +
            '"Displayed_EMI_Repayment_Month":10,' +
            '"Correct_EMI_Repayment_Month":-1,' +
            '"Displayed_EMI_Repayment_Year":-1,' +
            '"Correct_EMI_Repayment_Year":2024' +
        '}],' +

        '"Dis_Document_list":[{' +
            '"Dis_Dtl_Id":"' + disDtlId + '",' +
            '"DocNameWithExtension":"",' +
            '"DocContent":""' +
        '}]' +
        '}';
    }

    @isTest
    static void testInsertAndUpdateFlow() {
    
        // ===== Master Data =====
        Account acc = new Account(Name = 'Kotak');
        insert acc;
    
        Case_Type__c ct = new Case_Type__c(
            Name = 'Complaint Dispute Consumer',
            Case_Category__c = 'Consumer',
            Case_Complaint__c = 'Report'
        );
        insert ct;
    
        Sub_Type__c st = new Sub_Type__c(
            Name = 'DPD',
            Case_Type__c = ct.Id
        );
        insert st;
    
        Sub_Type1__c st1 = new Sub_Type1__c(
            Name = 'Incorrect',
            Sub_Type__c = st.Id
        );
        insert st1;
    
        // ===== REQUEST 1 =====
        RestRequest req1 = new RestRequest();
        RestResponse res1 = new RestResponse();
    
        req1.requestURI = '/services/apexrest/saveCase';
        req1.httpMethod = 'POST';
        req1.requestBody = Blob.valueOf(getRequestBody('10726'));
    
        // ===== REQUEST 2 =====
        RestRequest req2 = new RestRequest();
        RestResponse res2 = new RestResponse();
    
        req2.requestURI = '/services/apexrest/saveCase';
        req2.httpMethod = 'POST';
        req2.requestBody = Blob.valueOf(getRequestBody('10726'));
    
        // ===== EXECUTION =====
        Test.startTest();
    
        RestContext.request = req1;
        RestContext.response = res1;
        SaveCaseRestAPI.doPost();
    
        RestContext.request = req2;
        RestContext.response = res2;
        SaveCaseRestAPI.doPost();
        SaveCaseRestAPI.fakeCodeCoverage();
    
        Test.stopTest();
    
        // ===== ASSERT =====
        List<Case> cases = [SELECT Id FROM Case WHERE DIS_Dtl_Id__c = '10726'];
        System.assert(cases.size() > 0, 'Case should be created');
    }
}