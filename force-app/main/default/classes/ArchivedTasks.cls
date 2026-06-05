public with sharing class ArchivedTasks {
    @AuraEnabled(cacheable=true)
    public static  Map<String, Object> getArchivedTasks(Id caseId) {
        Map<String, Object> result = new Map<String, Object>();

        if (caseId == null) {
            return new  Map<String, Object>();
        }
        
        List<Devsalesforce_task_archive__x> archivedTasks = [
            SELECT Id,
                   subject_c__c,
                   priority_c__c,
                   status_c__c,
                   related_to_c__c,
                   case_id__c,
                   created_by_c__c,created_at__c
            FROM Devsalesforce_task_archive__x
            Where case_id__c = :caseId
            
        ];

        result.put('emails', archivedTasks);
        return result;
    }
}