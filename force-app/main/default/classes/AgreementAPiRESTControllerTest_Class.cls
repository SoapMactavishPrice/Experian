@IsTest
public class AgreementAPiRESTControllerTest_Class {

   private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('getEsignAndEstampRequest')) {
                String sta = 'OK';
                String Js = '{"document_id": "123","docket_id":"1234"}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
            return null;
        }
    }
    static testMethod void  updateMethodTest(){   
     try{
       Lead newLead = new Lead() ;
       newLead.FirstName = 'Test';
       newLead.LastName = 'Mahi';
       newLead.Company = 'Apple';
       insert newLead;
   
     Test.startTest();
     
 
    Test.setMock(HttpCalloutMock.class, new Mock());
         AgreementAPiRESTController.save_pdf_in_attachment('Billing_Contact_Person_c', 'Billing_Contact_Details_c','Billing_Job_Title_c','company_name','Name','designation','phone_number','email','billing_email','billing_address','gst_registration_no',newLead.Id, 'NodalOfficerName', 'NodalEmail', 'TelNoNodal', 'BillingStreet', 'BillingCity', 'BillingZipPostalCode', 'BillingState','BillingCountry','First_Name_Auth_Usr_Req_c','Last_Name_Auth_Usr_Req_c','Job_Title_Auth_Usr_Req_c','Official_Email_Auth_Usr_Req_c','Tel_No_Auth_Usr_Req_c','First_Name_AuSig_c','Last_Name_AuSig_c','Job_Title_AuSig_c','Tel_No_AuSig_c','Official_Email_Address_AuSig_c');
   //AgreementAPiRESTController.save_pdf_in_attachment( '', '', '', '', '', '', '','',newLead.Id, '', '','','', '','', 'maharashtra', 'India');
    
    update newLead;
    Test.stopTest();
   } Catch(Exception e){}
   }

}