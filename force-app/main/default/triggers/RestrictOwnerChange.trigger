trigger RestrictOwnerChange on Case (after update, before update) {
    
    if(Trigger.isAfter && Trigger.isUpdate){
        List<Case> casesToUpdate = new List<Case>();
        
        for (Case currentCase : Trigger.new) {
            Case oldCase = Trigger.oldMap.get(currentCase.Id);
            
            if (currentCase.Send_Email_to_Consumer__c == true && currentCase.Dispute_Email_Sent__c == true && (currentCase.Sub_Type_1_Name__c == 'Matching/CI - Account does not belong to me' || 
                 currentCase.Sub_Type_1_Name__c == 'Matching/CI - Credit Enquiry does not belong to me') && (oldCase.Sub_Type_1_Name__c == 'Matching - Account does not belong to me' || oldCase.Sub_Type_1_Name__c == 'Matching - Credit Enquiry does not belong to me' || oldCase.Sub_Type_Name__c == 'Merging')) {
                     
                     // Create new Case object with the field to update
                     casesToUpdate.add(new Case( Id = currentCase.Id,
                         Send_Sub_Type_1_Email__c = true
                     ));
                 }
        }
        
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
    
    System.debug(RecursiveTriggerHandler.isFirstTime);
    
    if(RecursiveTriggerHandler.isFirstTime) {
        RecursiveTriggerHandler.isFirstTime = false;
        if((Trigger.isBefore) && (Trigger.isUpdate)){
            
            String SysAdminIdSand ='00e2v0000034xKFAAY'; //Sandbox
            String SysAdminIdProd ='00e2v0000034xKF';   //Production
            String TLCSIdProd     ='00e2u000000gjdD';   //Production
            String TLCSandbox     ='00e6D000000k85S';   //Sandbox
            string AutomatedUser = '0052v00000ZrO4mAAF'; // sandbox
            
            String ConvertedTLCSandbox=String.valueof(userinfo.getProfileId()).substring(0,15);
            System.debug('ConvertedTLCSandbox^^'+ConvertedTLCSandbox);
            String ConvertedTLCSIdProd=String.valueof(userinfo.getProfileId()).substring(0,15);
            System.debug('ConvertedTLCSIdProd^^'+ConvertedTLCSIdProd);
            
            for (Case ca: Trigger.new) {
                
                if((Trigger.OldMap.get(ca.Id).OwnerId != ca.OwnerId )){
                    
                    if(!((userinfo.getUserId() == AutomatedUser)|| ( userinfo.getProfileId()==SysAdminIdSand) || (userinfo.getProfileId()==SysAdminIdProd) || (ConvertedTLCSandbox==TLCSandbox) || (ConvertedTLCSIdProd==TLCSIdProd) )){
                        if(ca.Case_Complaints__c==null){
                            ca.addError('Please enter Case Compliant before changing the owner.');
                        }
                    } 
                }
            }
        }
    }
    
    /* if(Trigger.isBefore && Trigger.isUpdate) {

Boolean isDuplicate = true;
Sub_Type1__c   subType1 = [SELECT Id, Sub_Type__c, Sub_Type__r.Case_Type__c,
Sub_Type__r.Case_Type__r.Case_Complaint__c, Sub_Type__r.Case_Type__r.Case_Category__c
FROM Sub_Type1__c
WHERE Name = 'Duplicate' AND
Sub_Type__r.Name = 'Status of Dispute' AND
Sub_Type__r.Case_Type__r.Name = 'Query' AND
Sub_Type__r.Case_Type__r.Case_Complaint__c = 'Report' AND
Sub_Type__r.Case_Type__r.Case_Category__c = 'Consumer' limit 1];

for(Case cs : Trigger.New) {
if(cs.Is_Duplicate_Case__c) {
if(cs.ParentId == null) {
cs.ParentId.addError('Parent Case is required to mark case as duplicate');
continue;
}

if(cs.ParentId != null) {
cs.Status = 'Resolved';
cs.Case_Category__c = subType1.Sub_Type__r.Case_Type__r.Case_Category__c;
cs.Case_Complaints__c = subType1.Sub_Type__r.Case_Type__r.Case_Complaint__c;
cs.Case_Type_Lookup__c = subType1.Sub_Type__r.Case_Type__c;
cs.Sub_Type_Lookup__c = subType1.Sub_Type__c;
cs.Sub_Type_1_Lookup__c = subType1.Id;
}
}
} 
}*/
}