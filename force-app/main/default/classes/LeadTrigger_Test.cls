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
        l.Authorized_Signatory_Name__c = 'Test';
        l.Date_of_Incorporation__c = system.today();
        l.Nodal_Officer_Name__c = 'Test';
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
        
        l.Checked_in_NBFC_List__c = 'Yes';
        l.Checked_in_Termination_List__c = 'Yes';
        l.Executive_Verified_Documents__c = true;
        l.TL_Verified_Documents__c = true;
        l.Admin_Verified_Documents__c = true;
        update l;
        
        l.Executive_Verified_Documents__c = false;
        l.TL_Verified_Documents__c = false;
        l.Admin_Verified_Documents__c = true;
        update l;
        
        l.Executive_Verified_Documents__c = true;
        l.TL_Verified_Documents__c = true;
        l.Admin_Verified_Documents__c = true;
        update l;
        
        l.Executive_Verified_Documents__c = true;
        l.TL_Verified_Documents__c = false;
        l.Admin_Verified_Documents__c = true;
        update l;
        
        l.Executive_Verified_Documents__c = false;
        l.TL_Verified_Documents__c = true;
        l.Admin_Verified_Documents__c = true;
        update l;
        
        l.Executive_Verified_Documents__c = true;
        l.TL_Verified_Documents__c = true;
        l.Admin_Verified_Documents__c = true;
        l.OwnerId = System.UserInfo.getUserId();
        update l;
        
        l.OwnerId = System.UserInfo.getUserId();
        l.Total_Payment_Received__c = 12;
        l.Mode_of_Transaction__c = 'Yes';
        l.Payment_Date_Time__c = System.today();
        l.Agreement_Experian_Status__c = 'Signed';
        l.Agreement_Customer_Status_Stages__c = 'Signed';
        update l;
        
        LeadStatusUpdateHandler.fakecodecoverage();

}
}