public class FeedbackTriggerHandler {
    public static void afterInsert(List<Feedback__c> newList){
        List<Feedback__c> updateList = new List<Feedback__c>();
        
        for(Feedback__c fb : newList){
            if(String.isBlank(fb.Feedback_External_Id__c)){
                // create a clone record with Id reference
                Feedback__c fbToUpdate = new Feedback__c(
                    Id = fb.Id,
                    Feedback_External_Id__c = fb.Id
                );
                updateList.add(fbToUpdate);
            }
        }
        
        if(!updateList.isEmpty()){
            update updateList;
        }
    }
}