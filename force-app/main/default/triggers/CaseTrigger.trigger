trigger CaseTrigger on Case (before insert,before Update,after insert ,After Update) {

    if(Trigger.isBefore && Trigger.isInsert){ //Vijai Added on 17-06-2024
        //CreateAndUpdateContactOnCase cst = new CreateAndUpdateContactOnCase();
        //cst.assignRelatedRecordsToCase(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isInsert){ //Balram Added on 22-06-2024
        CreateAndUpdateContactOnCase cst = new CreateAndUpdateContactOnCase();
        cst.updateAccount(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        CaseTriggerHandler cst = new CaseTriggerHandler();
        cst.mapAccounts(trigger.new);
    }
    if(Trigger.isBefore && Trigger.isUpdate){
        CaseTriggerHandler cst = new CaseTriggerHandler();
        cst.updateAccountName(trigger.new);
    }
    if (Trigger.isBefore && Trigger.isInsert) { //|| Trigger.isBefore && Trigger.isUpdate
        CaseTriggerHandler cst = new CaseTriggerHandler();
        cst.updateCaseState(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isInsert) {
        CaseTriggerHandler cst = new CaseTriggerHandler();
        cst.updateCaseTagging(Trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isInsert){
		CaseTriggerHandler cst = new CaseTriggerHandler();
        cst.updateMatchingCases(Trigger.new);
	}
    
    /*if (Trigger.isAfter && Trigger.isInsert) {//added on 21/05/24 by Balram //|| Trigger.isUpdate
        CaseTriggerHandler cst = new CaseTriggerHandler();
        cst.updateMatchingCases(Trigger.new);
        Set<Id> cIds= new set<Id>();
		if(System.Label.ActivateGenAI=='true') 
        {
            for(case c:trigger.new)
            {
                if(c.Case_Category__c=='Consumer' && c.SuppliedEmail!=null && c.Junk_Case__c==false)
                {
                    cIds.add(c.id);
                }
            }
            if(cIds.size()>0)
            {
                cst.updateCaseCategory(cIds);
                //AIUtility.sendResponseEmail(cIds);   
            }
        }
    }*/

    if(Trigger.isBefore && Trigger.isUpdate) {
        CaseTriggerHandler cst = new CaseTriggerHandler();
        cst.updateConsumerDisputeStatus(Trigger.new, Trigger.oldMap);
    } 
    
    
  /*  if(Trigger.isBefore){
        If(Trigger.isInsert){
            CaseTriggerHandler cst = new CaseTriggerHandler();
            cst.mapAccounts(trigger.new);
            cst.wrapDescription(trigger.new);
            cst.getDIS_Dtl_Id(trigger.new);
            
            //cst.UpdateCaseOwner(trigger.new,trigger.oldMap);
        }
        
        if(Trigger.isUpdate){
            CaseTriggerHandler cst = new CaseTriggerHandler();
            cst.updateAssignedCaseDateTime(trigger.new,trigger.oldMap);   
            cst.updateDisupteEmailAddress(trigger.new); 
            cst.sendSFTPEmail(trigger.new,trigger.oldMap);
            cst.sendRBIComplaintMail(trigger.new,trigger.oldMap);
            cst.wrapDescription(trigger.new);
            cst.UpdateCaseOwner(trigger.new,trigger.oldMap);
            cst.CaseAsDuplicate(trigger.new,trigger.oldMap);
            cst.validateDispute(trigger.new,trigger.oldMap);
            cst.caseUpdated_Date_calculation(trigger.new, trigger.oldMap);
            cst.validateForwardingToBank(trigger.new);
            if(RecursiveTriggerHandler.isFirstTime) {
                RecursiveTriggerHandler.isFirstTime = false;
                cst.RestrictOwnerChange(trigger.new,trigger.oldMap);
            }
            
        }
        
    }
    
    if(Trigger.IsAfter){
        if(Trigger.isInsert){
            CaseTriggerHandler cst = new CaseTriggerHandler();
            cst.getCloneCase(trigger.new);
        }
        if(Trigger.isUpdate){
            
        }
    }
    */
}