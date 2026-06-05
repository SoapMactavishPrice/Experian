trigger LeadTrigger on Lead (before insert,after insert, after update) {
    
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
    
    if (Trigger.isAfter && Trigger.isInsert) {
        LeadTriggerHandler.createMembershipDocuments(Trigger.new);
    }
}