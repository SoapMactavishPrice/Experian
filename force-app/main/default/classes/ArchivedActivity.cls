public with sharing class ArchivedActivity {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getArchivedRecords(Id caseId) {
        Map<String, Object> result = new Map<String, Object>();

        
        List<Devsalesforce_email_archive__x> archivedEmails = [
            SELECT Id, bcc_address_c__c, case_id_c__c, cc_address_c__c, html_body_c__c,
                   to_address_c__c, from_name_c__c, subject_c__c,createddate__c,text_body_c__c
            FROM Devsalesforce_email_archive__x 
            where case_id_c__c = :caseId
            ORDER BY message_date_c__c DESC
        ];

        result.put('emails', archivedEmails);
        return result;
    }
}