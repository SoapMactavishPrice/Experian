trigger DPD_Detail on DPD_Detail__c (after insert,after Update) {
    
    DPD_Detail_Handler dpsd = new DPD_Detail_Handler();
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        dpsd.getUpdate_DPDInsert(trigger.new);
    }
    
    if(trigger.isAfter && trigger.isInsert){
    	Set<Id> recordIds = new Set<Id>();

        for (DPD_Detail__c record : Trigger.new) {
            if (String.isBlank(record.DPD_External_Id__c)) {
                recordIds.add(record.Id);
            }
        }

        if (!recordIds.isEmpty()) {
            System.enqueueJob(new DPD_Detail_Queueable(recordIds));
        }
    }
}