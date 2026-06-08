@isTest
public class LeadConverterTestClass {
    
    public static Id leadId;
    
    static testMethod void convertLead() {
        test.startTest();
        Lead l = new Lead();
        l.First_Name_Nodal__c = 'Test First6';
        l.Last_Name_Nodal__c = 'Test Last5';
        l.Last_Name_AuSig__c = 'Test Last7';
        l.Last_Name_Web_User__c = 'Test Last8';
        l.LastName='Tesatas 1';
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
        l.RBI_Certificate_Verified__c = 'true';
        l.Pan_Verified__c = 'True';
        l.GST_Verified__c = 'True';
        l.RBI_Member_Verified__c = 'Yes';
        l.Authorised_Signatory_PAN_Verified__c = 'Yes';
        l.Auth_Sign_Authorization_Letter_Verified__c = 'Yes';
        l.Executive_Verified_Documents__c = true;
        l.TL_Verified_Documents__c = true;
        l.Admin_Verified_Documents__c = true;
        l.Checked_in_NBFC_List__c = 'Yes';
        l.Checked_in_Termination_List__c = 'Yes';
        insert l;
        
        l.Authorised_Signatory_Same_As_Nodal_Offic__c = true;
        update l;
        
        
        leadId = l.Id;
        
        
        /*Contact cn = new Contact();
cn.AccountId = l.ConvertedAccountId;
cn.Title = l.Job_Title_Nodal__c;
cn.FirstName = l.First_Name_Nodal__c;
system.debug('****'+l.Last_Name_Nodal__c);
cn.LastName = l.Last_Name_Nodal__c;
cn.Phone = l.Tel_No_Nodal__c;
cn.Fax = l.Fax_No_Nodal__c;
cn.Contact_Role__c = 'Nodal Officer';
cn.Contact_on_lead_conversion__c = true;
cn.Email = l.Official_Email_Address_Nodal__c;
insert cn;*/
        
        try{
            System.debug('Created and inserted lead');
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(leadId);
            
            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
        } Catch(Exception e){}
        
        test.stopTest();
    }
    
    static testMethod void convertLead2() {
        test.startTest();
        Lead l = new Lead();
        l.First_Name_Nodal__c = 'Test First';
        l.Company = 'Test comp1';
        l.LastName = 'Test123';
        l.Last_Name_Nodal__c = 'Test Last 1';
        l.Last_Name_AuSig__c = 'Test Last2';
        l.Last_Name_Web_User__c = 'Test Last3';
        //l.LastName='Tesatas';
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
        l.Authorised_Signatory_Same_As_Nodal_Offic__c = true;
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
        l.Executive_Verified_Documents__c = true;
        l.TL_Verified_Documents__c = true;
        l.Admin_Verified_Documents__c = true;
        l.Checked_in_NBFC_List__c = 'Yes';
        l.Checked_in_Termination_List__c = 'Yes';
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
        
        
        l.Status = 'Qualified';
        l.Authorised_Signatory_Same_As_Nodal_Offic__c = true;
        update l;
        
        leadId = l.Id;
        
        /*Contact cn = new Contact();
cn.AccountId = l.ConvertedAccountId;
cn.Title = l.Job_Title_Nodal__c;
cn.FirstName = l.First_Name_Nodal__c;
system.debug('****'+l.Last_Name_Nodal__c);
cn.LastName = l.Last_Name_Nodal__c;
cn.Phone = l.Tel_No_Nodal__c;
cn.Fax = l.Fax_No_Nodal__c;
cn.Contact_Role__c = 'Nodal Officer';
cn.Contact_on_lead_conversion__c = true;
cn.Email = l.Official_Email_Address_Nodal__c;
insert cn;*/
        
        try{
            System.debug('Created and inserted lead');
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(LeadId);
            
            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
        } Catch(Exception e){
            system.debug('line Is'+e.getlineNumber());
        }        
        test.stopTest();
    }
    
    static testMethod void ConvertLeadSuccessfully() {
       test.startTest();
        Lead l = new Lead();
        l.First_Name_Nodal__c = 'Test First6';
        l.Last_Name_Nodal__c = 'Test Last5';
        l.Last_Name_AuSig__c = 'Test Last7';
        l.Last_Name_Web_User__c = 'Test Last8';
        l.LastName='Tesatas 1';
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
        insert l;
        
        leadId = l.Id;
        
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

        System.debug([select Id, OwnerId from Lead]);
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(leadId);
        
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        /*
        }
        Catch(Exception e){
            System.debug(e.getMessage());
        }
*/
        System.debug('contact -> '+[select count() from Contact]);
        test.stopTest();
        
        System.debug('contact -> '+[select count() from Contact]);
    }
    
}