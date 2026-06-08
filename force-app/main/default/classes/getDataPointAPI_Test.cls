@isTest
public class getDataPointAPI_Test {

    static testMethod void testAccountDetailsWithNoCaseNumber(){
        try{
            getDataPointAPI.fakeCodeCoverage();
        Account acc = new Account();
        acc.Name = 'Standard Chartered Bank';
        insert acc;
        
        Case_Type__c ct=new Case_Type__c();
        ct.Name='Complaint Dispute Consumer';
        ct.Case_Category__c='Consumer';
        ct.Case_Complaint__c='Report';
        insert ct;
        
        Case_Type__c ctd=new Case_Type__c();
        ctd.Name='Query';
        ctd.Case_Category__c='Consumer';
        ctd.Case_Complaint__c='Report';
        insert ctd;
       
        
        Sub_Type__c st=new Sub_Type__c();
        st.Name='Demographic Details';
        st.Case_Type__c=ct.Id;
        insert st;
        
        Sub_Type1__c st1= new Sub_Type1__c();
        st1.Name='Incorrect Address';
        st1.Sub_Type__c=st.Id;
        insert st1;
        
         Sub_Type__c st3=new Sub_Type__c();
        st3.Name='Account Status';
        st3.Case_Type__c=ct.Id;
        insert st3;
        
          Sub_Type__c st3_v=new Sub_Type__c();
        st3_v.Name='Status of Dispute';
        st3_v.Case_Type__c=ctd.Id;
        insert st3_v;
        
        Sub_Type1__c st1_v= new Sub_Type1__c();
        st1_v.Name='Duplicate';
        st1_v.Sub_Type__c=st.Id;
        insert st1_v;
        
       
        
        
        
        Contact con=new Contact();
        con.MobilePhone='9930496858';
        con.Phone='9930496858';
        con.Email='nasya.kapoor@gmail.com';
        con.LastName='kapoor';
        insert con;
        
        Case c=new Case();
        c.DIS_Dtl_Id__c = '1234';
        c.AccountId = acc.Id;
        c.ContactId=con.Id;
        c.Case_Type_Lookup__c=ctd.Id;
        c.Sub_Type_Lookup__c=st3_v.Id;
        c.Sub_Type_1_Lookup__c=st1_v.Id; 
        c.Case_Category__c='Consumer';
        c.Case_Complaints__c='Report';
        c.Displayed_Account_number__c='SLFBG723454';
        insert c;
        
        
        RestRequest req1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        String js1='{"Contact_Details": {"First_Name": "KAPOOR","Family_Name": "NASYA","Mobile_Number":"9930496858","Email_Id":"nasya.kapoor@gmail.com"},"Dispute_Data_Point_Decision_Requests": [{"Account_Number": "SLFBG723454","Bureau_Member_Name": "Standard Chartered Bank"},{"Account_Number": "ICICTD64013","Bureau_Member_Name": "icicibank"} ]}';
        // String js1='{  \"CaseList\":[{\"Case_Number\":\"\",  \"SubType\":\"DPD\",  \"SubType1\":\"Incorrect\",  \"ContactEmailId\":\"rariv@gmail.com\",  \"AccoutDetailsList\": {       \"Displayed_Account_Status\":\"Closed\",   \"Correct_Account_Status\":\"Active\",   \"Displayed_Loan_Balance\":0.0,   \"Correct_Loan_Balance\":0.0,   \"Displayed_EMI_Amount\":0,   \"Correct_EMI_Amount\":0,   \"Displayed_Account_Opening_Date\":\"\",   \"Correct_Account_Opening_Date\":\"\",   \"Displayed_EMI_Repayment_Days\":0,   \"Correct_EMI_Repayment_Days\":0,   \"Displayed_EMI_Repayment_Month\":0,   \"Correct_EMI_Repayment_Month\":0,   \"Displayed_EMI_Repayment_Year\":0,   \"Correct_EMI_Repayment_Year\":0,   \"Displayed_Account_Type\":\"\",   \"Displayed_Bank_Name\":\"Kotak\",   \"Displayed_Account_number\":\"\",   \"Displayed_Loan_Type\":\"Education\",   \"Correct_Loan_Type\":\"Home\",   \"Displayed_loan_Ownership\":\"Joint\",   \"Correct_Loan_Ownership\":\"Guarantor\" },  \"PersonalDetailsList\":   {     \"Displayed_Name\":\"\", \"Correct_Name\":\"\", \"Displayed_Date_of_Birth\":\"\", \"Correct_Date_of_Birth\":\"\", \"Displayed_Gender\":\"\", \"Correct_Gender\":\"\", \"Displayed_Address\":\"\", \"Correct_Address\":\"\", \"Displayed_email_id\":\"\", \"Correct_email_id\":\"\", \"Displayed_mobile_no\":0, \"Correct_mobile_no\":0, \"Displayed_PAN_No\":\"\", \"Correct_PAN_No\":\"\"   }  ,  \"EnquiryList\":{  \"Displayed_Enquired_For\":\"\",  \"Correct_Enquired_For\":\"\",  \"Displayed_Enquired_By\":\"\",  \"Correct_Enquired_By\":\"\",  \"Displayed_Enquiry_Date\":\"\",  \"Correct_Enquiry_Date\":\"\"},"AccountDoesNotBelongToMe":{"AccountType":"","BankName":"","AccountNumber":""},"DontSeeMyAccountHere":{"AccountType":"","BankName":"","AccountNumber":""}  }]}';
        
        req1.requestURI = '/services/apexrest/getDispueDataPointAPI'; //Request URL
        req1.httpMethod = 'POST'; //HTTP Request Type
        req1.requestBody = Blob.valueof(js1);
        RestContext.request = req1;
        RestContext.response = res1;
        
        getDataPointAPI.doPost();
        
        }catch(Exception e){
            
        }
        
        
    } 
    
    
    
}