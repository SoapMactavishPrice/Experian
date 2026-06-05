@RestResource(urlMapping='/saveAgreementSignedcopyAPi/*')
global class saveAgreementSignedcopyAPi{
    
    @HttpPost
    global static void doPost(){
        API_LOG__c ap=new API_LOG__c();
        ap.Request_Source__c='Save Agreement Signed Copy';
        
        
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        system.debug('***'+jSONRequestBody);
         Lead ld =new Lead();
         try{ 
           JSON2Apex jta = JSON2Apex.parse(jSONRequestBody);
           ld = [SELECT Id,Legal_desk_docket_id__c, name,Company,Official_Email_Address_AuSig__c, LegalDesk_Agreement_Document_Id__c,Agreement_Customer_Status_Stages__c,Agreement_Experian_Status__c
                   FROM Lead WHERE LegalDesk_Agreement_Document_Id__c =: jta.document_id];
       
            ap.Company_Name__c=ld.Company;
             if(jta.signer_info.email ==ld.Official_Email_Address_AuSig__c){
                  ld.Agreement_Customer_Status_Stages__c = 'signed';
                 
                /* Attachment attachment = new Attachment(); 
                 attachment.Body = EncodingUtil.Base64Decode(jta.file_content); 
                 attachment.Name = String.valueOf('Agreement Copy_signedByCustomer.pdf');
                 attachment.ParentId = ld.Id;
                 insert attachment;  */
                 
                 ContentVersion contentVersion = new ContentVersion();
                 contentVersion.ContentLocation = 'S'; // S = Stored in Salesforce
                 contentVersion.PathOnClient = String.valueOf('Agreement Copy_signedByCustomer.pdf');
                 contentVersion.Title = String.valueOf('Agreement Copy_signedByCustomer.pdf');
                 contentVersion.isMajorVersion = false;
                 contentVersion.VersionData = EncodingUtil.base64Decode(jta.file_content);
                 
                 upsert contentVersion;
                 
                 contentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id];
                 
                 ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
                 contentDocumentLink.ContentDocumentId = contentVersion.ContentDocumentId;
                 contentDocumentLink.LinkedEntityId = ld.Id;
                 contentDocumentLink.ShareType = 'V';
                 
                 upsert contentDocumentLink;
             }
             
             //if(jta.signer_info.email ==system.label.Experian_signer_email || jta.signer_info.email =='saikrishnan.srinivasan@experian.com' ||  jta.signer_info.email =='balram@finesseme.com'){
             if(jta.signer_info.email ==system.label.Experian_signer_email || jta.signer_info.email =='saikrishnan.srinivasan@experian.com'){
                 ld.Aggrement_API_Status__c = 'Success';
                 ld.Agreement_Experian_Status__c = 'signed';
                 ld.Status = 'Agreement Received';
                 
                 /*Attachment attachment = new Attachment(); 
                 attachment.Body = EncodingUtil.Base64Decode(jta.file_content); 
                 attachment.Name = String.valueOf('Agreement Copy_signedByBothParty.pdf');
                 attachment.ParentId = ld.Id;
                 insert attachment; */
                 
                 ContentVersion contentVersion = new ContentVersion();
                 contentVersion.ContentLocation = 'S'; // S = Stored in Salesforce
                 contentVersion.PathOnClient = String.valueOf('Agreement Copy_signedByBothParty.pdf');
                 contentVersion.Title = String.valueOf('Agreement Copy_signedByBothParty.pdf');
                 contentVersion.isMajorVersion = false;
                 contentVersion.VersionData = EncodingUtil.base64Decode(jta.file_content);
                 
                 upsert contentVersion;
                 
                 contentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id];
                 
                 ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
                 contentDocumentLink.ContentDocumentId = contentVersion.ContentDocumentId;
                 contentDocumentLink.LinkedEntityId = ld.Id;
                 contentDocumentLink.ShareType = 'V';
                 
                 upsert contentDocumentLink;
             }
             if(!Test.isRunningTest()){
                 update ld;
             }
            // String resp = '{"status":"success","Message":"Document uploaded successfully."}';
            String resp = '{"status":"success","docket_id":"'+ld.Legal_desk_docket_id__c+'","document_id":"'+ld.LegalDesk_Agreement_Document_Id__c+'","error":"NA","error_code":"NA"}';
            response.responseBody = Blob.valueOf(resp);
            response.addHeader('Content-Type', 'application/json');
            response.statusCode = 200;
            ap.Request__c=String.valueOf(ld);
            ap.Response__c=resp;
        }
        catch(Exception e){
            //String resp = '{"Status":"Failed","Message":"Document not inserted successfully "}';
            String resp = '{"status":"failed","docket_id":"'+ld.Legal_desk_docket_id__c+'","document_id":"'+ld.LegalDesk_Agreement_Document_Id__c+'","error":"Not Uploaded","error_code":"404"}';
            response.responseBody = Blob.valueOf(resp);
            response.addHeader('Content-Type', 'application/json');
            response.statusCode = 404;
            ap.Response__c=resp;
            ap.Exception_Description__c=e.getMessage();
        } 
        insert ap;  
    } 
    
    public class JSON2Apex {
        
        public String docket_id;
        public String document_id;
        public String file_content;
        public String reference_id;
        public String signer_ref_id;   
        public Signer_info signer_info;
    }
    public class Signer_info {
		public String name;
		public String email;
		public String mobile;
		public String signer_id;
	}

   
    
    public static JSON2Apex parse(String json) {
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    }
    
    
}