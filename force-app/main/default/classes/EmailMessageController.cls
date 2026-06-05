public with sharing class EmailMessageController {
    // Make base DTO virtual so it can be extended
    public virtual class EmailRowDTO {
        @AuraEnabled public Id id;
        @AuraEnabled public String subject;
        @AuraEnabled public String fromAddress;
        @AuraEnabled public String toAddress;
        @AuraEnabled public String status;
        @AuraEnabled public Datetime messageDate;
        @AuraEnabled public Boolean hasAttachment;
    }

    public class EmailDetailDTO extends EmailRowDTO {
        @AuraEnabled public String ccAddress;
        @AuraEnabled public String bccAddress;
        @AuraEnabled public String textBody;
        @AuraEnabled public String htmlBody;
        @AuraEnabled public List<AttachmentDTO> attachments;
    }

    public class AttachmentDTO {
        @AuraEnabled public Id contentDocumentId;
        @AuraEnabled public String title;
        @AuraEnabled public Long contentSize;
        @AuraEnabled public String fileType;
        @AuraEnabled public String downloadUrl; // /sfc/servlet.shepherd/document/download/{id}
    }

    @AuraEnabled(cacheable=true)
    public static List<EmailRowDTO> getEmails(Id parentId, Integer limitSize, Integer offsetSize) {
        if (parentId == null) return new List<EmailRowDTO>();
        Integer l = (limitSize == null || limitSize <= 0) ? 50 : limitSize;
        Integer o = (offsetSize == null || offsetSize < 0) ? 0 : offsetSize;

        List<EmailRowDTO> rows = new List<EmailRowDTO>();
        

        for(Devsalesforce_email_archive__x archivedEmail : [
            SELECT Id, bcc_address_c__c, case_id_c__c, cc_address_c__c, html_body_c__c,from_address_c__c,message_date_c__c,sfid__c,
                   to_address_c__c, from_name_c__c, subject_c__c,createddate__c,text_body_c__c, status_c__c
            FROM Devsalesforce_email_archive__x WHERE case_id_c__c = :parentId
            ORDER BY message_date_c__c DESC
            LIMIT :l OFFSET :o
        ]) {
            EmailRowDTO r = new EmailRowDTO();
            r.id = archivedEmail.sfid__c;
            r.subject = archivedEmail.subject_c__c;
            r.fromAddress = archivedEmail.from_address_c__c;
            r.toAddress = archivedEmail.to_address_c__c;
            r.status = archivedEmail.status_c__c;
            r.messageDate = archivedEmail.message_date_c__c;
            r.hasAttachment = false;
            r.subject = archivedEmail.subject_c__c;
            rows.add(r);
        }

        
        return rows;
    }

    @AuraEnabled(cacheable=true)
    public static EmailDetailDTO getEmailDetail(Id emailMessageId) {
        if (emailMessageId == null) return null;

        
        Devsalesforce_email_archive__x em = [
            SELECT Id, bcc_address_c__c, case_id_c__c, cc_address_c__c, html_body_c__c,from_address_c__c,message_date_c__c,sfid__c,
                   to_address_c__c, from_name_c__c, subject_c__c,createddate__c,text_body_c__c, status_c__c
            FROM Devsalesforce_email_archive__x WHERE sfid__c = :emailMessageId
            LIMIT 1
        ];

        EmailDetailDTO d = new EmailDetailDTO();
        d.id = em.sfid__c;
        d.subject = em.subject_c__c;
        d.fromAddress = em.from_address_c__c;
        d.toAddress = em.to_address_c__c;
        d.ccAddress = em.cc_address_c__c;
        d.bccAddress = em.bcc_address_c__c;
        d.status = em.status_c__c;
        d.messageDate = em.message_date_c__c;
        d.hasAttachment = false;
        d.textBody = em.text_body_c__c;
        d.htmlBody = em.html_body_c__c;

        /*d.attachments = new List<AttachmentDTO>();
        for (ContentDocumentLink cdl : [
            SELECT ContentDocumentId, ContentDocument.Title, ContentDocument.FileType, ContentDocument.ContentSize
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :emailMessageId
            ORDER BY ContentDocument.Title
        ]) {
            AttachmentDTO a = new AttachmentDTO();
            a.contentDocumentId = cdl.ContentDocumentId;
            a.title = cdl.ContentDocument.Title;
            a.fileType = cdl.ContentDocument.FileType;
            a.contentSize = cdl.ContentDocument.ContentSize;
            a.downloadUrl = '/sfc/servlet.shepherd/document/download/' + cdl.ContentDocumentId;
            d.attachments.add(a);
        }*/
        return d;
    }
}