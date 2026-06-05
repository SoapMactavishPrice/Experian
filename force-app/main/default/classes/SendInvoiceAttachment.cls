public class SendInvoiceAttachment {
    public Invoice__c inv {get;set;}
    public Account a {get;set;}
    public Contact c {get;set;}
    public string currentRecordId {get;set;} 
    public SendInvoiceAttachment(){
       currentRecordId  =ApexPages.CurrentPage().getparameters().get('id');
       inv=new Invoice__c();
       c=new Contact();
       //a=[select id, name, (select id, name, Email from Contacts where Contact_Role__c='Nodal Officer') from account];
       inv=[select id,Name,Email_Address__c,Invoice__c.OwnerId,Account__c from Invoice__c where id=:currentRecordId]; 
       Id accid = inv.Account__c;
       c=[select id, name, Email from Contact where Contact_Role__c='Nodal Officer' AND AccountId =:accid];
        system.debug('currentRecordId>>>>>'+currentRecordId);
    }
    public pageReference Send() {
        //for(Invoice__c oppr : inv){
            if(c.Email != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{c.Email };
                // String[] toAddresses = 'oppr.SMEs_Email__c';
                mail.setToAddresses(toAddresses);
                mail.setReplyTo('mjdsd7@gmail.com');
                mail.setSenderDisplayName('Experian Support');
                mail.setSubject('Invoices Attahment');
                mail.setBccSender(false);
                mail.setUseSignature(false);
                mail.setPlainTextBody('Please find the Attachments'); 
               // mail.setTargetObjectId(oppr.Id);
               //mail.setTemplateId('00XQ0000000QULj');
                mail.saveAsActivity = false;
          		mail.setSaveAsActivity(true); 
                
                //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                //Set email file attachments
                
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                //for (Attachment a : [select Name, Body, BodyLength from Attachment where ParentId = :oppr.Id])
               for (ContentDocumentLink  a : [SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.title,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId in (SELECT Id FROM Invoice__c where id =:currentRecordId ) and LinkedEntity.Type='Invoice__c'])
                {
                   ContentDistribution dpu = new ContentDistribution();  
                   ContentVersion cv = new ContentVersion();
                   cv = [SELECT ContentUrl,PathOnCLient,VersionNumber,CreatedDate,ContentBodyId,VersionData,FileType,Title FROM ContentVersion WHERE ContentDocumentId = :a.ContentDocumentId AND IsLatest = true];
                   dpu = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId =: cv.Id];
                   system.debug('ContentVersion----->'+cv);
                   system.debug('ContentDistribution----->'+dpu);
                   system.debug('ContentDocumentLink----->'+a);
                    // Add to attachment file list
                    Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                    system.debug('Body--->'+mail);
                    efa.setFileName(cv.Title+'.'+cv.FileType);
                    efa.setBody(cv.VersionData);
                    fileAttachments.add(efa);
                }
                mail.setFileAttachments(fileAttachments);
                system.debug('Attchment Cheking--->'+fileAttachments);
                system.debug('mail chehk--->'+mail);
                //Send email
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
               //Messaging.Emailfileattachment(new Messaging.Emailfileattachment[] { mail });
            }       
       //} 
       PageReference pageRef = new PageReference('/' + currentRecordId);
       pageRef.setRedirect(true);
       return pageRef;
   }
}