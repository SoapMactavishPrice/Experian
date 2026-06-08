trigger LeadTrigger on Lead (before insert, before update, after insert, after update) {

   if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        LeadStatusUpdateHandler.updateStatusDateTimesBefore(
            Trigger.new,
            Trigger.oldMap
        );

        LeadStatusUpdateHandler.updateVerificationDateTimesBefore(
            Trigger.new,
            Trigger.oldMap
        );
    }

    if(Trigger.isAfter && trigger.isUpdate){
        for(Lead ld: Trigger.new){
            if(Trigger.oldMap.get(ld.Id).status !=ld.Status){
              //LeadStatusUpdateHandler.updateLeadStatus(Trigger.New,Trigger.OldMap);   
            }
            
        }
    }
    
    if(Trigger.isAfter && trigger.isUpdate){
        for(Lead ld: Trigger.new){
            //if(Trigger.oldMap.get(ld.Id).status !=ld.Status){
              LeadStatusUpdateHandler.updateApilogStatus(Trigger.New,Trigger.OldMap);   
            //}
            
        }
    }
    
    if(Trigger.isAfter && trigger.isInsert){
        for(Lead ld: Trigger.new){
            //if(!test.isRunningTest()){
            LeadStatusUpdateHandler.insertApilogStatus(Trigger.New);   
            //}
            
        }
    }
}