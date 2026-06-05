trigger LeadTriggerLeegalityAgreement on Lead(after update) {

    Set<Id> leadIds = new Set<Id>();
    Set<Id> fetchDocumentLeadIds = new Set<Id>();

    for(Lead l : Trigger.new){

        Lead oldLead = Trigger.oldMap.get(l.Id);

        if(l.Status == 'Sent for Agreement' && oldLead.Status != 'Sent for Agreement'){
            leadIds.add(l.Id);
        }

        /*Logic For Fetching the Document*/
        if(l.Signer_1_Status__c == 'Signed' && l.Signer_2_Status__c == 'Signed' && (oldLead.Signer_1_Status__c != 'Signed' || oldLead.Signer_2_Status__c != 'Signed')){
            fetchDocumentLeadIds.add(l.Id);
        }
    }

    if(!leadIds.isEmpty()){
        System.enqueueJob(new LeegalityAgreementQueueable(leadIds));
    }

    if(!fetchDocumentLeadIds.isEmpty()){
        System.enqueueJob(new LeegalityFetchDocumentQueueable(fetchDocumentLeadIds));
    }

}