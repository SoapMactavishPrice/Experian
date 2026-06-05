trigger CaseMasterTrigger on Case (after insert) {
    
    if (Trigger.isAfter && Trigger.isInsert) {
        CaseMasterTriggerHandler.updateDemogMatching(Trigger.new);
    }
    
}