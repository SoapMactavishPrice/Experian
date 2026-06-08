/*@istest
public class saveAgreementSignedcopyAPi_Test {
     private static testMethod void doPostTest(){ 
         try{
         
        saveAgreementSignedcopyAPi restPost = new saveAgreementSignedcopyAPi();
                String js =    '{ \"Data\": [ {\"EmpID\": \"123\", \"OpptyId\": \"'+'\",\"InvNo\": \"Inv123\", \"ESMEAddr\": \"esme123\",\"AccType\": \"Fix\", \"DefaultESSMEAddr\": \"\",\"ParentOrg\": \"Just checking\",\"AmountWithTax\": \"1200\",\"PendingAmount\": \"600\",\"InvDate\": \"12/02/2019\",\"RevenueMonth\": \"May\",\"BillEndDate\": \"2019-02-02\",\"AccountId\": \"\", \"PaymentTerm\": \"Term1\", \"Quantity\": \"01\",\"Rate\": \"12\"}, {\"EmpID\": \"345\",\"OpptyId\": \"006N000000DHhwJ\",\"InvNo\": \"inv125\",\"ESMEAddr\": \"esme123\", \"AccType\": \"Fixed\",  \"DefaultESSMEAddr\": \"\",\"ParentOrg\": \"Same\",\"AmountWithTax\": \"2600\",\"PendingAmount\": \"300\",\"InvDate\": \"12/02/2019\",\"RevenueMonth\": \"June\",\"BillEndDate\": \"2019-02-02\",\"AccountId\": \"\",\"PaymentTerm\": \"Term1\",\"Quantity\": \"01\",\"Rate\": \"13\"} ]}';

        String JsonMsg=JSON.serialize(restPost);
       
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/saveAgreementSignedcopyAPi/*';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(js);
        RestContext.request = req;
        RestContext.response= res;
         
         Test.startTest();
         saveAgreementSignedcopyAPi.doPost();
         Test.stopTest();   
         } Catch(Exception e){}
     }

}*/
@istest
public class saveAgreementSignedcopyAPi_Test{

 static testMethod void  updateMethodTest(){   
     try{
       Lead newLead = new Lead() ;
       newLead.FirstName = 'Test';
       newLead.LastName = 'Mahi';
       newLead.Company = 'Apple';
       newLead.Status = 'Sent for Agreement';
       insert newLead;
         
   Test.startTest();
   saveAgreementSignedcopyAPi reqst=new saveAgreementSignedcopyAPi();
   String JsonMsg=JSON.serialize(reqst);

   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/saveAgreementSignedcopyAPi';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    saveAgreementSignedcopyAPi.doPost();
    update newLead;
    Test.stopTest();
   } Catch(Exception e){}
   }
    
     static testMethod void  updateMethodTest2(){   
     try{
       Lead newLead = new Lead() ;
       newLead.FirstName = 'Test';
       newLead.LastName = 'Mahi';
       newLead.Company = 'Apple';
       newLead.Status = 'Sent for Agreement';
       newLead.LegalDesk_Agreement_Document_Id__c='1234';
       newLead.Official_Email_Address_AuSig__c = 'saikrishnan.srinivasan@experian.com';
      // newLead.email = 'sonu@finessedirect.com';
       insert newLead;
         
   Test.startTest();
   saveAgreementSignedcopyAPi reqst=new saveAgreementSignedcopyAPi();
         String JsonMsg='{"document_id":"1234","file_content":"asd","signer_info" : { "email" : "saikrishnan.srinivasan@experian.com"}}';

   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/saveAgreementSignedcopyAPi';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    saveAgreementSignedcopyAPi.doPost();
    //update newLead;
    Test.stopTest();
   } Catch(Exception e){}
   }
   
}