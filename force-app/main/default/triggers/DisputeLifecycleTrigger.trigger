trigger DisputeLifecycleTrigger on Dispute_Lifecycle__c (after insert) {
    
    if(trigger.isAfter && trigger.isInsert){
        List<Dispute_Lifecycle__c> recordsToUpdate = new List<Dispute_Lifecycle__c>();
        
        for (Dispute_Lifecycle__c record : Trigger.new) {
            if (String.isBlank(record.External_ID__c)) {
                Dispute_Lifecycle__c recToUpdate = new Dispute_Lifecycle__c(
                    Id = record.Id,
                    External_ID__c  = record.Id
                );
                recordsToUpdate.add(recToUpdate);
            }
        }
        
        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }
    }
}