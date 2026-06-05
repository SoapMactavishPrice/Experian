trigger FeedbackTrigger on Feedback__c (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        FeedbackTriggerHandler.afterInsert(Trigger.new);
    }
}