public with sharing class PPACFormController {

    @AuraEnabled
    public static Id createPPACRecord(PPAC__c record, List<Id> contentDocumentIds, List<Id> approverIds) {

        if (record == null) {
            throw new AuraHandledException('Invalid data received');
        }

        // Optional: Basic validation
        if (String.isBlank(record.Entity__c) ||
            String.isBlank(record.Document_Type__c) ||
            String.isBlank(record.Category__c) ||
            record.Date_of_PPAC_Meeting__c == null ||
            String.isBlank(record.ARB_Applicability__c) ||
            String.isBlank(record.PSA_Applicability__c)) {

            throw new AuraHandledException('Please fill all required fields');
        }

        // FETCH RISK TEAM QUEUE
        Group riskQueue = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'Risk_Team' LIMIT 1];

        // ASSIGN OWNER
        record.OwnerId = riskQueue.Id;

        insert record;

         // LINK FILES
        if(contentDocumentIds != null && !contentDocumentIds.isEmpty()) {

            List<ContentDocumentLink> links = new List<ContentDocumentLink>();

            for(Id docId : contentDocumentIds) {
                links.add(
                    new ContentDocumentLink(
                        LinkedEntityId = record.Id,
                        ContentDocumentId = docId,
                        ShareType = 'V',
                        Visibility = 'AllUsers'
                    )
                );
            }
            insert links;
        }

        // INSERT APPROVERS
        if(approverIds != null && !approverIds.isEmpty()) {

            List<PPAC_Approving_Authorities__c> approvers = new List<PPAC_Approving_Authorities__c>();

            for(Id approverId : approverIds) {
                approvers.add(
                    new PPAC_Approving_Authorities__c(
                        PPAC__c = record.Id,
                        Approving_Authority__c = approverId
                    )
                );
            }
            insert approvers;
        }
        
        return record.Id;
    }
}