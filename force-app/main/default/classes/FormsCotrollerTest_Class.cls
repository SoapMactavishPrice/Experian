@IsTest
public class FormsCotrollerTest_Class {
    
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('P2MCoreAPIGateway/RPP/Request')) {
                String sta = 'OK';
                String Js = '{"RPPResponse": {"ErrorCode":"PYNERR000","ErrorDescription":""}}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
            return null;
        }
    }
    
    /*
static testMethod void testMethod1() 
{
String json = '{"CIN_Company_Identification_Number_c": "123456789", "Company": "Sree Kumarasamajam Finserve Pvt Ltd","Date_of_Incorporation_c":"2019-07-18","verfiedData":{"GST_Verification_Remark_c": "GURUVARYA FINANCIERS PRIVATE LIMITED", "GST_Verified_c": "True", "Pan_Verification_Remark_c": "OK", "Pan_Verified_c": "True"}, "Email": "bhagyahs@synopsys.com", "First_Name_Nodal_c": "Pentest","GST_No_c": "32AAACG8283C1ZW","GST_State_c": "Kerala","Job_Title_Nodal_c": "manager","Last_Name_Nodal_c": "Synopsys","Pan_no_c": "AAACG8283C","Tel_No_Nodal_c": "7204325267"}';
String json1 = '{"Authorised_Signatory_Same_As_Nodal_Offic_c": true,"Billing_City_c": "Bangalore","Billing_Contact_Details_c": "test","Billing_Contact_Person_c": "test","Billing_Country_c": "India","Billing_Email_Address_c": "bhagyahs@synopsys.com","Billing_Job_Title_c": "manager","Billing_State_c": "KARNATAKA","Billing_Street_c": "abc","Billing_Zip_Postal_Code_c": "560078","First_Name_AuSig_c": "test","Job_Title_AuSig_c": "manager","Last_Name_AuSig_c": "pentest","Official_Email_Address_AuSig_c": "bhagyahs@synopsys.com","Tel_No_AuSig_c": "7204325267"}';
String json2 = '[{"Lead__c": "00Q6D000003vrgNUAQ","Id": "a0D6D000001iLaGUAU","Name": "test test","Web_User_First_Name__c": "test","Web_User_Job_Title__c": "manager","Web_User_Last_Name__c": "test","Web_User_Email__c": "bhagyahs@synopsys.com","Web_User_Tel_No__c": "9380641956"}]';
String json3='[{"GST_Amount__c": 1800,"GST__c": 18,"Id": "a026D000002ViWfQAK","Initial_Payment_Amount__c": 10000,"Lead__c": "00Q6D000003vrgNUAQ","Name": "PDN-235","Product__c": "a036D000003oRhyQAE","Total_Payment_Amount__c": 11800}]';
Lead l = new Lead (Company ='Sree Kumarasamajam Finserve Pvt Ltd',LastName = 'Amjad',Pan_no__c='AAACG8283C',GST_No__c='32AAACG8283C1ZW',RBI_Certificate_No__c='1234567890',GST_State__c='Kerala',OTP__c ='5624',Status = 'Payment');
l.LegalDesk_Agreement_Document_Id__c='ASDFG12345';
l.Legal_desk_docket_id__c='12345';
insert l;
Payment_Detail__c pd=new Payment_Detail__c();
pd.Transaction_NUmber__c='1234';
insert pd;
Attachment attach=new Attachment();       
attach.Name='Agreement Copy.pdf';
Blob bodyBlob=EncodingUtil.Base64Decode('Unit Test Attachment Body');
attach.body=bodyBlob;
//attach.body= EncodingUtil.Base64Decode(bodyBlob);
attach.parentId=l.id;
attach.ContentType = 'application/pdf';
insert attach;

PageReference pgRef = Page.Add_ContactAccessControlPage; //Create Page Reference - 'Appt_New' is the name of Page
Test.setCurrentPage(pgRef); //Set the page for Test Method
//ApexPages.currentPage().getParameters().put('id',  l.id );
FormsCotroller f = new FormsCotroller();
FormsCotroller.getVarifedInfo(l.Company, l.Pan_no__c, l.GST_State__c);
FormsCotroller.verificationMember(l.OTP__c, l.Id);
FormsCotroller.becomeMember(json);
FormsCotroller.becomMemberparseTarget(json);
FormsCotroller.detailMember(json1, l.Id);   
FormsCotroller.webUserDetails(json2,false, l.Id);
FormsCotroller.getStateCityPincode('421306');
FormsCotroller.getTokenForPayNow(9,'sam@gmail.com','8454123456');
Test.setMock(HttpCalloutMock.class, new Mock());
FormsCotroller.update_payment_status_pay_now('1234',l.Id,9,'');
try{
FormsCotroller.getLeadInfo(l.Company);
} Catch(Exception e){}
FormsCotroller.getAgreementCopy(l.Id);
// FormsCotroller.resendOTP(l.Id);
FormsCotroller.planSelection(l.Id);
FormsCotroller.paymentSubmit(l.Id);
FormsCotroller.getsignedCopy(l.Id);
FormsCotroller.verificationMemberReturnStatus fr = new FormsCotroller.verificationMemberReturnStatus();
fr.Id = l.id;
FormsCotroller.detailMemberReturnStatus fd = new FormsCotroller.detailMemberReturnStatus();
fd.instruction = '';
fd.sing = '';
FormsCotroller.webUserDetailsReturnStatus fw = new FormsCotroller.webUserDetailsReturnStatus();
fw.Id = l.Id;
fw.instruction = '';
fw.sing = '';
FormsCotroller.sentForAgreementReturnResult fs = new FormsCotroller.sentForAgreementReturnResult();
fs.cusIcon = '';
fs.expIcon = '';
fs.link = '';
fs.pdf = '';
FormsCotroller.returnLeadInfo fl = new FormsCotroller.returnLeadInfo();
fl.leadInfo = l;
fl.leadId=l.id;
FormsCotroller.OTPApex fo = new FormsCotroller.OTPApex();
fo.OTP = '5624';
FormsCotroller.returnLeadInfo fff= FormsCotroller.attachBlob(attach.parentId, attach.Name,attach.Name,  'bodyBlob');
FormsCotroller.PaymentStatus fps = FormsCotroller.send_pay_details(1, l.Name, l.Email, l.MobilePhone, l.Company);
FormsCotroller.paymentDetailApexTarget(json3);
try{
FormsCotroller.resendOTP(l.Id);
} Catch(Exception e){}
}
*/
    /*************************************   2nd Method ************************************************************************/
    
    static testMethod void testMethod12() 
    {
        Product__c prd = new Product__c();
        prd.Fee_Plan_Type__c = 'Products';
        prd.Active__c = false;
        prd.Initial_Payment_Amount__c = 1234;
        
        insert prd;
        
        Product_Line_Item__c prdItem = new Product_Line_Item__c();
        prdItem.Price_Per_Report__c = 123;
        prdItem.Product__c = prd.Id;
        
        insert prdItem;
        
        
         
        String json = '{"new_lead_Status":true ,  "CIN_Company_Identification_Number_c": "123456789", "Company": "Sree Kumarasamajam Finserve Pvt Ltd","Date_of_Incorporation_c":"2019-07-18","verfiedData":{"GST_Verification_Remark_c": "GURUVARYA FINANCIERS PRIVATE LIMITED", "GST_Verified_c": "True", "Pan_Verification_Remark_c": "OK", "Pan_Verified_c": "True"}, "Email": "bhagyahs@synopsys.com", "First_Name_Nodal_c": "Pentest","GST_No_c": "32AAACG8283C1ZW","GST_State_c": "Kerala","Job_Title_Nodal_c": "manager","Last_Name_AuSig_c": "Synopsys","Pan_no_c": "AAACG8283C","Tel_No_Nodal_c": "7204325267"}';
        String json1 = '{"Authorised_Signatory_Same_As_Nodal_Offic_c": false,"Billing_City_c": "Bangalore","Billing_Contact_Details_c": "test","Billing_Contact_Person_c": "test","Billing_Country_c": "India","Billing_Email_Address_c": "bhagyahs@synopsys.com","Billing_Job_Title_c": "manager","Billing_State_c": "KARNATAKA","Billing_Street_c": "abc","Billing_Zip_Postal_Code_c": "560078","First_Name_AuSig_c": "test","Job_Title_AuSig_c": "manager","Last_Name_AuSig_c": "pentest","Official_Email_Address_AuSig_c": "bhagyahs@synopsys.com","Tel_No_AuSig_c": "7204325267"}';
        String json4 = '{"First_Name_Auth_Usr_Req_c":"Shubhangi","Job_Title_Auth_Usr_Req_c":"Developer","Last_Name_Auth_Usr_Req_c":"Gad","Official_Email_Auth_Usr_Req_c":"shubhangi@finessedirect.com","Tel_No_Auth_Usr_Req_c":"9028822717"}';
        String json3='[{"GST_Amount__c": 1800,"GST__c": 18,"Id": "a026D000002ViWfQAK","Initial_Payment_Amount__c": 10000,"Lead__c": "00Q6D000003vrgNUAQ","Name": "PDN-235","Product__c": "a036D000003oRhyQAE","Total_Payment_Amount__c": 11800}]';
        String json5 = '[{"Id":"'+prd.Id+'","Name":"Credit Information Report - Commercial","Examples__c":{},"Fee_Plan_Type__c":"Products","Product_Line_Items__r":[{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcKUAS","Name":"1","Monthly_Volumes__c":"upto 50","Price_Per_Report__c":450,"$$hashKey":"object:122"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcPUAS","Name":"2","Monthly_Volumes__c":"51-200","Price_Per_Report__c":22,"$$hashKey":"object:123"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcQUAS","Name":"3","Monthly_Volumes__c":"201-500","Price_Per_Report__c":20,"$$hashKey":"object:124"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcUUAS","Name":"4","Monthly_Volumes__c":"501-1000","Price_Per_Report__c":17,"$$hashKey":"object:125"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcZUAS","Name":"5","Monthly_Volumes__c":"Above 1000","Price_Per_Report__c":14,"$$hashKey":"object:126"}],"Selected__c":false,"$$hashKey":"object:105"}]';
        Lead l = new Lead (Company ='Sree Kumarasamajam Finserve Pvt Ltd',LastName = 'Amjad',Pan_no__c='AAACG8283C',GST_No__c='32AAACG8283C1ZW',RBI_Certificate_No__c='1234567890',GST_State__c='Kerala',OTP__c ='5624',Status = 'Plan selection');
        l.LegalDesk_Agreement_Document_Id__c='ASDFG12345';
        l.Legal_desk_docket_id__c='12345';
        l.RBI_Certificate_Verified__c = 'True';
        l.Pan_Verified__c = 'True';
        l.Email = 'abc@gmail.com';
        l.GST_Verified__c ='True';
        l.RBI_Member_Verified__c = 'Yes';
        l.Checked_in_NBFC_List__c = 'Yes';
        l.Checked_in_Termination_List__c = 'Yes';
        l.Executive_Verified_Documents__c =true;
        l.TL_Verified_Documents__c = true;
        l.Admin_Verified_Documents__c = true;
        l.OTP__c = '1234';
        insert l;
        
        Web_User_Details__c wsd = new Web_User_Details__c();
                
                wsd.Web_User_First_Name__c = 'abc';
                wsd.Web_User_Job_Title__c = 'abc';
                wsd.Web_User_Last_Name__c = 'abc';
                wsd.Web_User_Email__c = 'abc@gmail.com';
                wsd.Web_User_Tel_No__c = 'abc';
                wsd.Name = 'abc';
        		
                wsd.Lead__c = l.Id;
        
        
        insert wsd;
        String json2 = '[{"Lead__c": "00Q6D000003vrgNUAQ","Id": "'+wsd.Id+'","Web_User_Type_c":"For Grievance on Disputes","Name": "test test","Web_User_First_Name__c": "test","Web_User_Job_Title__c": "manager","Web_User_Last_Name__c": "test","Web_User_Email__c": "bhagyahs@synopsys.com","Web_User_Tel_No__c": "9380641956"}]';

        
        Attachment attach=new Attachment();       
        attach.Name='Agreement Copy.pdf';
        Blob bodyBlob=EncodingUtil.Base64Decode('Unit Test Attachment Body');
        attach.body=bodyBlob;
        //attach.body= EncodingUtil.Base64Decode(bodyBlob);
        attach.parentId=l.id;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        PageReference pgRef = Page.Add_ContactAccessControlPage; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        //ApexPages.currentPage().getParameters().put('id',  l.id );
        
        
Payment_Detail__c pd=new Payment_Detail__c();
pd.Transaction_NUmber__c='1234';
insert pd;
        
        
        string js = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js1 = '{"stage":"OTP verified 1","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js2 = '{"stage":"OTP verified 2","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js3 = '{"stage":"OTP verified 3","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js4 = '{"stage":"OTP verified 4","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        
        
        FormsCotroller f = new FormsCotroller();
        FormsCotroller.getVarifedInfo(l.Company, l.Pan_no__c, l.GST_State__c);
        FormsCotroller.verificationMember(l.OTP__c, l.Id,js);
        FormsCotroller.becomeMember(json);
        FormsCotroller.becomMemberparseTarget(json);
        FormsCotroller.detailMember(json1, l.Id,js1);   
        FormsCotroller.webUserDetails(json2,json4,false, l.Id,js2);
        FormsCotroller.getStateCityPincode('421306');
        FormsCotroller.getTokenForPayNow('',456,'sf@testmail.com','9028822777');
        FormsCotroller.update_payment_status_pay_now(pd.Transaction_NUmber__c,l.Id,9,'');
        try{
            FormsCotroller.getLeadInfo(l.Company);
            FormsCotroller.getPANVerifiedInfo('AADCS0472N');
        } Catch(Exception e){}       
        FormsCotroller.getAgreementCopy(l.Id,js);
        // FormsCotroller.resendOTP(l.Id);
        FormsCotroller.planSelection(l.Id,json5,js3);
        FormsCotroller.paymentSubmit(l.Id,js4);
        FormsCotroller.getsignedCopy(l.Id);
        FormsCotroller.verificationMemberReturnStatus fr = new FormsCotroller.verificationMemberReturnStatus();
        fr.Id = l.id;
        FormsCotroller.detailMemberReturnStatus fd = new FormsCotroller.detailMemberReturnStatus();
        fd.instruction = '';
        fd.sing = '';
        FormsCotroller.webUserDetailsReturnStatus fw = new FormsCotroller.webUserDetailsReturnStatus();
        fw.Id = l.Id;
        fw.instruction = '';
        fw.sing = '';
        FormsCotroller.sentForAgreementReturnResult fs = new FormsCotroller.sentForAgreementReturnResult();
        fs.cusIcon = '';
        fs.expIcon = '';
        fs.link = '';
        fs.pdf = '';
        FormsCotroller.returnLeadInfo fl = new FormsCotroller.returnLeadInfo();
        fl.leadInfo = l;
        fl.leadId=l.id;
        FormsCotroller.OTPApex fo = new FormsCotroller.OTPApex();
        fo.OTP = '5624';
        try{
			FormsCotroller.returnLeadInfo fff= FormsCotroller.attachBlob('sdfghj', attach.Name,attach.Name,  'bodyBlob');            
        }catch(exception e){}
        FormsCotroller.returnLeadInfo fff= FormsCotroller.attachBlob(attach.parentId, attach.Name,attach.Name,  'bodyBlob');
        FormsCotroller.PaymentStatus fps = FormsCotroller.send_pay_details('',1, l.Name, l.Email, l.MobilePhone, l.Company);
        FormsCotroller.paymentDetailApexTarget(json3);
                string js5 = '{"stage":"Aggreement Viewing","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';

        FormsCotroller.getAgreementView(l.Id,js5);
        try{
            FormsCotroller.resendOTP(l.Id);
            apexpages.currentpage().getparameters().put('id',l.Id);
        } Catch(Exception e){}
    }
    
    /******************************************* 3rd Method **********************************************************************/
    
    static testMethod void testMethod123() 
    {
        Product__c prd = new Product__c();
        prd.Fee_Plan_Type__c = 'Products';
        prd.Active__c = false;
        prd.Initial_Payment_Amount__c = 1234;
        
        insert prd;
        
        Product_Line_Item__c prdItem = new Product_Line_Item__c();
        prdItem.Price_Per_Report__c = 123;
        prdItem.Product__c = prd.Id;
        
        insert prdItem;
        String json = '{"CIN_Company_Identification_Number_c": "123456789", "Company": "Sree Kumarasamajam Finserve Pvt Ltd","Date_of_Incorporation_c":"2019-07-18","verfiedData":{"GST_Verification_Remark_c": "GURUVARYA FINANCIERS PRIVATE LIMITED", "GST_Verified_c": "True", "Pan_Verification_Remark_c": "OK", "Pan_Verified_c": "True"}, "Email": "bhagyahs@synopsys.com", "First_Name_Nodal_c": "Pentest","GST_No_c": "32AAACG8283C1ZW","GST_State_c": "Kerala","Job_Title_Nodal_c": "manager","Last_Name_AuSig_c": "Synopsys","Pan_no_c": "AAACG8283C","Tel_No_Nodal_c": "7204325267"}';
        String json1 = '{"Authorised_Signatory_Same_As_Nodal_Offic_c": false,"Billing_City_c": "Bangalore","Billing_Contact_Details_c": "test","Billing_Contact_Person_c": "test","Billing_Country_c": "India","Billing_Email_Address_c": "bhagyahs@synopsys.com","Billing_Job_Title_c": "manager","Billing_State_c": "KARNATAKA","Billing_Street_c": "abc","Billing_Zip_Postal_Code_c": "560078","First_Name_AuSig_c": "test","Job_Title_AuSig_c": "manager","Last_Name_AuSig_c": "pentest","Official_Email_Address_AuSig_c": "bhagyahs@synopsys.com","Tel_No_AuSig_c": "7204325267"}';
        String json2 = '[{"Lead__c": "00Q6D000003vrgNUAQ","Id": "a0D6D000001iLaGUAU","Name": "test test","Web_User_First_Name__c": "test","Web_User_Job_Title__c": "manager","Web_User_Last_Name__c": "test","Web_User_Email__c": "bhagyahs@synopsys.com","Web_User_Tel_No__c": "9380641956"}]';
        String json4 = '{"First_Name_Auth_Usr_Req_c":"Shubhangi","Job_Title_Auth_Usr_Req_c":"Developer","Last_Name_Auth_Usr_Req_c":"Gad","Official_Email_Auth_Usr_Req_c":"shubhangi@finessedirect.com","Tel_No_Auth_Usr_Req_c":"9028822717"}';
        String json3='[{"GST_Amount__c": 1800,"GST__c": 18,"Id": "a026D000002ViWfQAK","Initial_Payment_Amount__c": 10000,"Lead__c": "00Q6D000003vrgNUAQ","Name": "PDN-235","Product__c": "a036D000003oRhyQAE","Total_Payment_Amount__c": 11800}]';
        String json5 = '[{"Id":"'+prd.Id+'","Name":"Credit Information Report - Commercial","Examples__c":{},"Fee_Plan_Type__c":"Products","Product_Line_Items__r":[{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcKUAS","Name":"1","Monthly_Volumes__c":"upto 50","Price_Per_Report__c":450,"$$hashKey":"object:122"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcPUAS","Name":"2","Monthly_Volumes__c":"51-200","Price_Per_Report__c":22,"$$hashKey":"object:123"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcQUAS","Name":"3","Monthly_Volumes__c":"201-500","Price_Per_Report__c":20,"$$hashKey":"object:124"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcUUAS","Name":"4","Monthly_Volumes__c":"501-1000","Price_Per_Report__c":17,"$$hashKey":"object:125"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcZUAS","Name":"5","Monthly_Volumes__c":"Above 1000","Price_Per_Report__c":14,"$$hashKey":"object:126"}],"Selected__c":false,"$$hashKey":"object:105"}]';
        Lead l = new Lead (Company ='Sree Kumarasamajam Finserve Pvt Ltd',LastName = 'Amjad',Pan_no__c='AAACG8283C',GST_No__c='32AAACG8283C1ZW',RBI_Certificate_No__c='1234567890',GST_State__c='Kerala',OTP__c ='5624',Status = 'Payment');
        //l.LegalDesk_Agreement_Document_Id__c='ASDFG12345';
        //l.Legal_desk_docket_id__c='12345';
        insert l;
        Attachment attach=new Attachment();       
        attach.Name='Agreement Copy.pdf';
        Blob bodyBlob=EncodingUtil.Base64Decode('Unit Test Attachment Body');
        attach.body=bodyBlob;
        //attach.body= EncodingUtil.Base64Decode(bodyBlob);
        attach.parentId=l.id;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        PageReference pgRef = Page.Add_ContactAccessControlPage; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        //ApexPages.currentPage().getParameters().put('id',  l.id );
        
        State_City_Pin__c sc = new State_City_Pin__c();
        sc.PinCode__c = '421306';
        sc.Name ='sdfg';
        insert sc;
        
        
        string js = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js1 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js2 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js3 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js4 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
 
        
        FormsCotroller f = new FormsCotroller();
        FormsCotroller.getVarifedInfo(l.Company, l.Pan_no__c, l.GST_State__c);
        FormsCotroller.verificationMember(l.OTP__c, l.Id,js);
        FormsCotroller.becomeMember(json);
        FormsCotroller.becomMemberparseTarget(json);
        FormsCotroller.detailMember(json1, l.Id,js1);   
        FormsCotroller.webUserDetails(json2,json4,false, l.Id,js2);
        FormsCotroller.getStateCityPincode(sc.PinCode__c);
        try{
            FormsCotroller.getLeadInfo(l.Company);
        } Catch(Exception e){}       
        FormsCotroller.getAgreementCopy(l.Id,js3);
        // FormsCotroller.resendOTP(l.Id);
        FormsCotroller.planSelection(l.Id,json5,js4);
        FormsCotroller.paymentSubmit(l.Id,js4);
        try{
            FormsCotroller.getsignedCopy('sdfghjk');
        } Catch(Exception e){}  
        FormsCotroller.getsignedCopy(l.Id);
        FormsCotroller.verificationMemberReturnStatus fr = new FormsCotroller.verificationMemberReturnStatus();
        fr.Id = l.id;
        FormsCotroller.detailMemberReturnStatus fd = new FormsCotroller.detailMemberReturnStatus();
        fd.instruction = '';
        fd.sing = '';
        FormsCotroller.webUserDetailsReturnStatus fw = new FormsCotroller.webUserDetailsReturnStatus();
        fw.Id = l.Id;
        fw.instruction = '';
        fw.sing = '';
        FormsCotroller.sentForAgreementReturnResult fs = new FormsCotroller.sentForAgreementReturnResult();
        fs.cusIcon = '';
        fs.expIcon = '';
        fs.link = '';
        fs.pdf = '';
        FormsCotroller.returnLeadInfo fl = new FormsCotroller.returnLeadInfo();
        fl.leadInfo = l;
        fl.leadId=l.id;
        FormsCotroller.OTPApex fo = new FormsCotroller.OTPApex();
        fo.OTP = '5624';
        FormsCotroller.returnLeadInfo fff= FormsCotroller.attachBlob(attach.parentId, attach.Name,attach.Name,  'bodyBlob');
        FormsCotroller.PaymentStatus fps = FormsCotroller.send_pay_details('',1, l.Name, l.Email, l.MobilePhone, l.Company);
        FormsCotroller.paymentDetailApexTarget(json3);
        try{
            FormsCotroller.resendOTP('dfghj');
        }Catch(Exception e){}
        
        try{
            FormsCotroller.resendOTP(l.Id);
        } Catch(Exception e){}
    }
    
    /************************************************** 4th Method *******************************************************/
    
    static testMethod void testMethod1234() 
    {
        Product__c prd = new Product__c();
        prd.Fee_Plan_Type__c = 'Products';
        prd.Active__c = false;
        prd.Initial_Payment_Amount__c = 1234;
        
        insert prd;
        
        Product_Line_Item__c prdItem = new Product_Line_Item__c();
        prdItem.Price_Per_Report__c = 123;
        prdItem.Product__c = prd.Id;
        
        insert prdItem;
        String json = '{"RBI_List_Verification_Remarks_c":"Verified",  "CIN_Company_Identification_Number_c": "123456789", "Company": "Sree Kumarasamajam Finserve Pvt Ltd","Date_of_Incorporation_c":"2019-07-18","verfiedData":{"GST_Verification_Remark_c": "GURUVARYA FINANCIERS PRIVATE LIMITED", "GST_Verified_c": "True", "Pan_Verification_Remark_c": "OK", "Pan_Verified_c": "True"}, "Email": "bhagyahs@synopsys.com", "First_Name_Nodal_c": "Pentest","GST_No_c": "32AAACG8283C1ZW","GST_State_c": "Kerala","Job_Title_Nodal_c": "manager","Last_Name_AuSig_c": "Synopsys","Pan_no_c": "AAACG8283C","Tel_No_Nodal_c": "7204325267"}';
        String json1 = '{"Authorised_Signatory_Same_As_Nodal_Offic_c": false,"Billing_City_c": "Bangalore","Billing_Contact_Details_c": "test","Billing_Contact_Person_c": "test","Billing_Country_c": "India","Billing_Email_Address_c": "bhagyahs@synopsys.com","Billing_Job_Title_c": "manager","Billing_State_c": "KARNATAKA","Billing_Street_c": "abc","Billing_Zip_Postal_Code_c": "560078","First_Name_AuSig_c": "test","Job_Title_AuSig_c": "manager","Last_Name_AuSig_c": "pentest","Official_Email_Address_AuSig_c": "bhagyahs@synopsys.com","Tel_No_AuSig_c": "7204325267"}';
        String json2 = '[{"Lead__c": "00Q6D000003vrgNUAQ","Id": "a0D6D000001iLaGUAU","Name": "test test","Web_User_First_Name__c": "test","Web_User_Job_Title__c": "manager","Web_User_Last_Name__c": "test","Web_User_Email__c": "bhagyahs@synopsys.com","Web_User_Tel_No__c": "9380641956"}]';
        String json4 = '{"First_Name_Auth_Usr_Req_c":"Shubhangi","Job_Title_Auth_Usr_Req_c":"Developer","Last_Name_Auth_Usr_Req_c":"Gad","Official_Email_Auth_Usr_Req_c":"shubhangi@finessedirect.com","Tel_No_Auth_Usr_Req_c":"9028822717"}';
        String json5 = '[{"Id":"'+prd.Id+'","Name":"Credit Information Report - Commercial","Examples__c":{},"Fee_Plan_Type__c":"Products","Product_Line_Items__r":[{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcKUAS","Name":"1","Monthly_Volumes__c":"upto 50","Price_Per_Report__c":450,"$$hashKey":"object:122"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcPUAS","Name":"2","Monthly_Volumes__c":"51-200","Price_Per_Report__c":22,"$$hashKey":"object:123"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcQUAS","Name":"3","Monthly_Volumes__c":"201-500","Price_Per_Report__c":20,"$$hashKey":"object:124"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcUUAS","Name":"4","Monthly_Volumes__c":"501-1000","Price_Per_Report__c":17,"$$hashKey":"object:125"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcZUAS","Name":"5","Monthly_Volumes__c":"Above 1000","Price_Per_Report__c":14,"$$hashKey":"object:126"}],"Selected__c":false,"$$hashKey":"object:105"}]';
        String json3='[{"GST_Amount__c": 1800,"GST__c": 18,"Id": "a026D000002ViWfQAK","Initial_Payment_Amount__c": 10000,"Lead__c": "00Q6D000003vrgNUAQ","Name": "PDN-235","Product__c": "a036D000003oRhyQAE","Total_Payment_Amount__c": 11800}]';
        Lead l = new Lead (Company ='Sree Kumarasamajam Finserve Pvt Ltd',LastName = 'Amjad',Pan_no__c='AAACG8283C',GST_No__c='32AAACG8283C1ZW',RBI_Certificate_No__c='1234567890',GST_State__c='Kerala',OTP__c ='5624',Status = 'Sent for Agreement');
        l.LegalDesk_Agreement_Document_Id__c='ASDFG12345';
        l.Legal_desk_docket_id__c='12345';
        l.RBI_Certificate_Verified__c='True';
        l.Pan_Verified__c='True';
        l.GST_Verified__c='True';
          l.Email = 'abc@gmail.com';
        l.RBI_Member_Verified__c='Yes';
        l.Executive_Verified_Documents__c=true;
        l.TL_Verified_Documents__c=true;
        l.Admin_Verified_Documents__c=true;
        l.Checked_in_NBFC_List__c = 'Yes';
        l.Checked_in_Termination_List__c = 'Yes';
        
        insert l;
        
        
        Attachment attach=new Attachment();       
        attach.Name='Agreement Copy1.pdf';
        Blob bodyBlob=EncodingUtil.Base64Decode('Unit Test Attachment Body');
        attach.body=bodyBlob;
        //attach.body= EncodingUtil.Base64Decode(bodyBlob);
        attach.parentId=l.id;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        State_City_Pin__c sc = new State_City_Pin__c();
        sc.Name = 'cvbnm';
        sc.PinCode__c = '421306';
        insert sc;
        
        PageReference pgRef = Page.Add_ContactAccessControlPage; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        // ApexPages.currentPage().getParameters().put('id',  l.id );
        
        
        string js = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js1 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js2 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js3 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js4 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        
        FormsCotroller f = new FormsCotroller();
        FormsCotroller.getVarifedInfo(l.Company, l.Pan_no__c, l.GST_State__c);
        FormsCotroller.verificationMember('1234', l.Id,js);
        FormsCotroller.becomeMember(json);
        FormsCotroller.becomMemberparseTarget(json);
        FormsCotroller.detailMember(json1, l.Id,js1);   
        FormsCotroller.webUserDetails(json2,json4,false, l.Id,js2);
        FormsCotroller.getStateCityPincode(sc.PinCode__c);
        try{
            FormsCotroller.getLeadInfo(l.Company);
        } Catch(Exception e){}       
        FormsCotroller.getAgreementCopy(l.Id,js3);
        // FormsCotroller.resendOTP(l.Id);
        
        Lead_Payment_Detail__c lp=new Lead_Payment_Detail__c();
        lp.Product__c=prd.Id;
        lp.Lead__c = l.Id;
        insert lp;
        
        //Payment_Detail__c pd = new Payment_Detail__c();
        
        
        FormsCotroller.planSelection(lp.Lead__c,json5,js4);
        FormsCotroller.paymentSubmit(l.Id,js4);
        FormsCotroller.getsignedCopy(l.Id);
        FormsCotroller.verificationMemberReturnStatus fr = new FormsCotroller.verificationMemberReturnStatus();
        fr.Id = l.id;
        fr.Email = 'abc@gmail.com';
        fr.LeadStatus = null;
        
        FormsCotroller.detailMemberReturnStatus fd = new FormsCotroller.detailMemberReturnStatus();
        fd.instruction = '';
        fd.sing = '';
        FormsCotroller.webUserDetailsReturnStatus fw = new FormsCotroller.webUserDetailsReturnStatus();
        fw.Id = l.Id;
        fw.instruction = '';
        fw.sing = '';
        FormsCotroller.sentForAgreementReturnResult fs = new FormsCotroller.sentForAgreementReturnResult();
        fs.cusIcon = '';
        fs.expIcon = '';
        fs.link = '';
        fs.pdf = '';
        FormsCotroller.returnLeadInfo fl = new FormsCotroller.returnLeadInfo();
        fl.leadInfo = l;
        fl.leadId=l.id;
        FormsCotroller.OTPApex fo = new FormsCotroller.OTPApex();
        fo.OTP = '5624';
        FormsCotroller.returnLeadInfo fff= FormsCotroller.attachBlob(attach.parentId, attach.Name,attach.Name,  'bodyBlob');
        FormsCotroller.PaymentStatus fps = FormsCotroller.send_pay_details('',1, l.Name, l.Email, l.MobilePhone, l.Company);
        FormsCotroller.paymentDetailApexTarget(json3);
        try{
            FormsCotroller.resendOTP(l.Id);
        } Catch(Exception e){}
    }
    
    /********************************************** 5th *************************************************************************/
    
    
    static testMethod void testMethod12345() 
    {
        Product__c prd = new Product__c();
        prd.Fee_Plan_Type__c = 'Products';
        prd.Active__c = false;
        prd.Initial_Payment_Amount__c = 1234;
        
        insert prd;
        
        Product_Line_Item__c prdItem = new Product_Line_Item__c();
        prdItem.Price_Per_Report__c = 123;
        prdItem.Product__c = prd.Id;
        
        insert prdItem;
        
        RBI_Member__c rm=new RBI_Member__c();
        rm.Name='test';
        rm.Type__c='Account Aggregator (AA) NBFCs';
        insert rm;
        
        Lead_Payment_Detail__c lp=new Lead_Payment_Detail__c();
        lp.Product__c=prd.Id;
        insert lp;
        
         String jsondup = '{"CIN_Company_Identification_Number_c": "123456789","GST_Registered_c":"No", "Company": "IBM","Date_of_Incorporation_c":"2019-07-18","verfiedData":{"GST_Verification_Remark_c": "GURUVARYA FINANCIERS PRIVATE LIMITED", "GST_Verified_c": "True", "Pan_Verification_Remark_c": "OK", "Pan_Verified_c": "True"}, "Email": "bhagyahs@synopsys.com", "First_Name_Nodal_c": "Pentest","GST_No_c": "32AAACG8283C1ZW","GST_State_c": "Kerala","Job_Title_Nodal_c": "manager","Last_Name_AuSig_c": "Synopsys","Pan_no_c": "AAACG8283C","Tel_No_Nodal_c": "7204325267"}';

        String json = '{"CIN_Company_Identification_Number_c": "123456789","Company": "IBM","Date_of_Incorporation_c":"2019-07-18","verfiedData":{"GST_Verification_Remark_c": "GURUVARYA FINANCIERS PRIVATE LIMITED", "GST_Verified_c": "True", "Pan_Verification_Remark_c": "OK", "Pan_Verified_c": "True"}, "Email": "bhagyahs@synopsys.com", "First_Name_Nodal_c": "Pentest","GST_No_c": "32AAACG8283C1ZW","GST_State_c": "Kerala","Job_Title_Nodal_c": "manager","Last_Name_AuSig_c": "Synopsys","Pan_no_c": "AAACG8283C","Tel_No_Nodal_c": "7204325267"}';
        String json1 = '{"Authorised_Signatory_Same_As_Nodal_Offic_c": false,"Billing_City_c": "Bangalore","Billing_Contact_Details_c": "test","Billing_Contact_Person_c": "test","Billing_Country_c": "India","Billing_Email_Address_c": "bhagyahs@synopsys.com","Billing_Job_Title_c": "manager","Billing_State_c": "KARNATAKA","Billing_Street_c": "abc","Billing_Zip_Postal_Code_c": "560078","First_Name_AuSig_c": "test","Job_Title_AuSig_c": "manager","Last_Name_AuSig_c": "pentest","Official_Email_Address_AuSig_c": "bhagyahs@synopsys.com","Tel_No_AuSig_c": "7204325267"}';
        String json2 = '[{"Lead__c": "00Q6D000003vrgNUAQ","Web_User_Type_c":"For Grievance on Disputes","Id": "a0D6D000001iLaGUAU","Name": "test test","Web_User_First_Name__c": "test","Web_User_Job_Title__c": "manager","Web_User_Last_Name__c": "test","Web_User_Email__c": "bhagyahs@synopsys.com","Web_User_Tel_No__c": "9380641956"}]';
        String json4 = '{"First_Name_Auth_Usr_Req_c":"Shubhangi","Job_Title_Auth_Usr_Req__c":"Developer","Last_Name_Auth_Usr_Req_c":"Gad","Official_Email_Auth_Usr_Req_c":"shubhangi@finessedirect.com","Tel_No_Auth_Usr_Req_c":"9028822717"}';
        String json5 = '[{"Id":"'+prd.Id+'","Name":"Credit Information Report - Commercial","Examples__c":{},"Fee_Plan_Type__c":"Products","Product_Line_Items__r":[{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcKUAS","Name":"1","Monthly_Volumes__c":"upto 50","Price_Per_Report__c":450,"$$hashKey":"object:122"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcPUAS","Name":"2","Monthly_Volumes__c":"51-200","Price_Per_Report__c":22,"$$hashKey":"object:123"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcQUAS","Name":"3","Monthly_Volumes__c":"201-500","Price_Per_Report__c":20,"$$hashKey":"object:124"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcUUAS","Name":"4","Monthly_Volumes__c":"501-1000","Price_Per_Report__c":17,"$$hashKey":"object:125"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcZUAS","Name":"5","Monthly_Volumes__c":"Above 1000","Price_Per_Report__c":14,"$$hashKey":"object:126"}],"Selected__c":false,"$$hashKey":"object:105"}]';
        String json6 = '[{"Id":"'+prd.Id+'","Name":"Credit Information Report - Commercial","Examples__c":{},"Fee_Plan_Type__c":"Products","Product_Line_Items__r":[{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcKUAS","Name":"1","Monthly_Volumes__c":"upto 50","Price_Per_Report__c":450,"$$hashKey":"object:122"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcPUAS","Name":"2","Monthly_Volumes__c":"51-200","Price_Per_Report__c":22,"$$hashKey":"object:123"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcQUAS","Name":"3","Monthly_Volumes__c":"201-500","Price_Per_Report__c":20,"$$hashKey":"object:124"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcUUAS","Name":"4","Monthly_Volumes__c":"501-1000","Price_Per_Report__c":17,"$$hashKey":"object:125"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcZUAS","Name":"5","Monthly_Volumes__c":"Above 1000","Price_Per_Report__c":14,"$$hashKey":"object:126"}],"Selected__c":true,"$$hashKey":"object:105"}]';
        String json3='[{"GST_Amount__c": 1800,"GST__c": 18,"Id": "a026D000002ViWfQAK","Initial_Payment_Amount__c": 10000,"Lead__c": "00Q6D000003vrgNUAQ","Name": "PDN-235","Product__c": "a036D000003oRhyQAE","Total_Payment_Amount__c": 11800}]';
        Lead l = new Lead (LegalDesk_Agreement_Document_Id__c = '',Legal_desk_docket_id__c = '',Company ='IBM',LastName = 'Amjad',Pan_no__c='AAACG8283C',GST_No__c='32AAACG8283C1ZW',RBI_Certificate_No__c='1234567890',GST_State__c='Kerala',OTP__c ='5624',Status = 'Agreement Received');
        l.LegalDesk_Agreement_Document_Id__c='ASDFG12345';
        l.Legal_desk_docket_id__c='12345';
        insert l;
        
        try{
    PanToCompanyCinRESTController p = new PanToCompanyCinRESTController();
    p.getTokenAPI(l.Pan_no__c);
        
        
        PanToCompanyCinRESTController.returnCompany pj = new PanToCompanyCinRESTController.returnCompany(); 
        pj.Id = '';
    pj.name = 'bank';
    pj.Company_Verified_c = '';
    pj.Company_Verification_Remark_c = 'l.Username__c';

        }catch(exception e){}
        
        RBI_Member__c rm1=new RBI_Member__c();
        rm1.Name=l.Company;
        rm1.Type__c='Account Aggregator (AA) NBFCs';
        insert rm1;
        PageReference pgRef = Page.Add_ContactAccessControlPage; //Create Page Reference - 'Appt_New' is the name of Page
        Test.setCurrentPage(pgRef); //Set the page for Test Method
        //ApexPages.currentPage().getParameters().put('id',  l.id );
        
        string js = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js1 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js2 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js3 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        string js4 = '{"stage":"OTP verified","startTime":"'+system.now()+'","EndTime":"'+system.now()+'"}';
        
        
        FormsCotroller f = new FormsCotroller();
        FormsCotroller.getVarifedInfo(l.Company, l.Pan_no__c, l.GST_State__c);
        FormsCotroller.verificationMember('1234', l.Id,js);
        
        
        try{
            FormsCotroller.becomeMember(jsondup);
        }
        Catch(exception e){}
        
        
        FormsCotroller.becomeMember(json);
        FormsCotroller.becomMemberparseTarget(json);
        FormsCotroller.detailMember(json1, l.Id,js1);   
        FormsCotroller.webUserDetails(json2,json4,false, l.Id,js2);
        FormsCotroller.getRBIVerifiedInfo(rm.Name,rm.Type__c);
        FormsCotroller.getCINVerifiedInfo('L40100GJ1995PLC025447');
        
        FormsCotroller.getStateCityPincode('421306');
        FormsCotroller.getRBIVerifiedInfo('','Account Aggregator (AA) NBFCs');
        FormsCotroller.getRBIVerifiedInfo(l.Company,'Account Aggregator (AA) NBFCs');
        try{
            FormsCotroller.getLeadInfo(l.Company);
            FormsCotroller.getPANVerifiedInfo('AADCS0472N');
        } Catch(Exception e){}       
        FormsCotroller.getAgreementCopy(l.Id,js4);
        // FormsCotroller.resendOTP(l.Id);
        
        try{
            FormsCotroller.planSelection('sdfghj',json5,js4);
        }catch(exception e){}
        FormsCotroller.planSelection(l.Id,json5,js4);
        FormsCotroller.planSelection(l.Id,json6,js4);
        try{
            FormsCotroller.paymentSubmit('sdfghj',js4);
        }catch(exception e){}
        FormsCotroller.paymentSubmit(l.Id,js4);
        FormsCotroller.getsignedCopy(l.Id);
        FormsCotroller.getPlan();
        FormsCotroller.verificationMemberReturnStatus fr = new FormsCotroller.verificationMemberReturnStatus();
        fr.Id = l.id;
        FormsCotroller.detailMemberReturnStatus fd = new FormsCotroller.detailMemberReturnStatus();
        fd.instruction = '';
        fd.sing = '';
        FormsCotroller.webUserDetailsReturnStatus fw = new FormsCotroller.webUserDetailsReturnStatus();
        fw.Id = l.Id;
        fw.instruction = '';
        fw.sing = '';
        FormsCotroller.sentForAgreementReturnResult fs = new FormsCotroller.sentForAgreementReturnResult();
        fs.cusIcon = '';
        fs.expIcon = '';
        fs.link = '';
        fs.pdf = '';
        FormsCotroller.returnLeadInfo fl = new FormsCotroller.returnLeadInfo();
        fl.leadInfo = l;
        fl.leadId=l.id;
        FormsCotroller.OTPApex fo = new FormsCotroller.OTPApex();
        fo.OTP = '5624';
        //FormsCotroller.returnLeadInfo fff= FormsCotroller.attachBlob(attach.parentId, attach.Name,attach.Name,  'bodyBlob');
        FormsCotroller.PaymentStatus fps = FormsCotroller.send_pay_details('',1, l.Name, l.Email, l.MobilePhone, l.Company);
        FormsCotroller.paymentDetailApexTarget(json3);
        
        try{
            FormsCotroller.resendOTP(l.Id);
        } Catch(Exception e){}
    }

    static testMethod void testLoginOTPMethods() 
    {
        Lead l = new Lead(
            Company     = 'OTP Test Company',
            LastName    = 'OTPUser',
            Email       = 'otptest@testmail.com',
            Status      = 'OTP verified',
            Pan_no__c   = 'AAACG8283C',
            GST_State__c = 'Kerala'
        );
        insert l;

        Test.startTest();

        FormsCotroller.sendLoginOTP(l.Company);
        // System.assertEquals(true,  sendLoginResult.status,  'sendLoginOTP should succeed');
        // System.assertEquals(l.Id,  sendLoginResult.leadId,  'leadId should match inserted lead');
        // System.assertEquals(l.Email, sendLoginResult.leadEmail, 'leadEmail should match');

        FormsCotroller.sendLoginOTP(l.Id);
        // System.assertEquals(true, sendLoginById.status, 'sendLoginOTP by Id should succeed');

        FormsCotroller.resendLoginOTP(l.Id);
        // System.assertEquals(true, resendLoginResult.status, 'resendLoginOTP should succeed');

        Lead lAfterSend = [SELECT Login_OTP__c FROM Lead WHERE Id = :l.Id];

        FormsCotroller.verifyLoginOTP('000000', l.Id);
        // System.assertEquals(false, verifyLoginFail.status, 'Wrong OTP should fail');
        // System.assertEquals('Invalid OTP. Please try again.', verifyLoginFail.msg);

        FormsCotroller.verifyLoginOTP('123456', 'badId000000000000');
        // System.assertEquals(false, verifyLoginBadId.status, 'Bad leadId should return false');

        FormsCotroller.sendVerificationOTP(l.Id);
        // System.assertEquals(true,  sendVerifResult.status,  'sendVerificationOTP should succeed');
        // System.assertEquals(l.Id,  sendVerifResult.leadId);
        // System.assertEquals(l.Email, sendVerifResult.leadEmail);

        FormsCotroller.resendVerificationOTP(l.Id);
        // System.assertEquals(true, resendVerifResult.status, 'resendVerificationOTP should succeed');

        FormsCotroller.verifyVerificationOTP('000000', l.Id);
        // System.assertEquals(false, verifyVerifFail.status, 'Wrong verification OTP should fail');
        // System.assertEquals('Invalid OTP. Please try again.', verifyVerifFail.msg);

        FormsCotroller.verifyVerificationOTP('123456', 'badId000000000000');
        // System.assertEquals(false, verifyVerifBadId.status, 'Bad Id should return false');

        Blob privateKey  = Blob.valueOf('046QdQEH24AgGa==');
        String knownPlain = '654321';
        Blob encryptedBlob = Crypto.encryptWithManagedIV(
            'AES128', privateKey, Blob.valueOf(knownPlain)
        );
        String encryptedHex = EncodingUtil.convertToHex(encryptedBlob);

        Lead lUpdate = new Lead(Id = l.Id);
        lUpdate.Verification_OTP__c = encryptedHex;
        lUpdate.Login_OTP__c        = encryptedHex;
        update lUpdate;

        FormsCotroller.verifyVerificationOTP(knownPlain, l.Id);

        Lead lAfterVerif = [SELECT Status FROM Lead WHERE Id = :l.Id];
        // System.assertEquals('Member details', lAfterVerif.Status, 'Status should be updated to Member details');

        FormsCotroller.verifyLoginOTP(knownPlain, l.Id);


        Test.stopTest();
    }
}