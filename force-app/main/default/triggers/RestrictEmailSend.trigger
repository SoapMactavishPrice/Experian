trigger RestrictEmailSend on EmailMessage (before insert, after insert) {
    
    if(Trigger.isBefore && Trigger.isInsert){
        Set<Id> set_caseId = new Set<Id>();    
        for(EmailMessage em: trigger.new){
            if(em.parentId!=Null && em.Incoming == false){
                set_caseId.add(em.parentId);
                system.debug('set_caseId'+set_caseId);
            }
        }
        
        String SysAdminIdSand ='00e2v0000034xKFAAY'; //Sandbox
        String SysAdminIdProd ='00e2v0000034xKF';   //Production
        
        Map<Id, Case> parentMap = new Map<Id, Case>();
        parentMap.putAll([SELECT Id, Case_Complaints__c FROM Case WHERE Case_Complaints__c=null and Id In : set_caseId]);
        
        for (EmailMessage nt : trigger.new){
            
            if(!(( userinfo.getProfileId()==SysAdminIdSand) || (userinfo.getProfileId()==SysAdminIdProd) )){
                
                if (null!=parentMap.get(nt.parentId)){ 
                    nt.addError('Please enter Case Complaint before sending an email.!!!');
                }
            }
        }
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        
        Map<Id, Case> casesToUpdate = new Map<Id, Case>();
        Set<Id> caseIds = new Set<Id>();
        
        for (EmailMessage email : Trigger.new) {
            if (email.ParentId != null && email.TextBody != null && email.TextBody.toLowerCase().contains('no change')) {
                caseIds.add(email.ParentId);
            }
        }
        
        Map<Id, Case> relatedCases = new Map<Id, Case>([
            SELECT Id, AccountId, Account.Email_Dispute__c, Account.Email_1_Dispute__c, Account.Email_2_Dispute__c,
            Account.Email_3_Dispute__c, Account.Email_4_Dispute__c, Account.Email_5_Dispute__c,
            Account.Email_6_Dispute__c, Account.Email_7_Dispute__c, Account.Email_8_Dispute__c,
            Account.Email_9_Dispute__c, Account.Email_10_Dispute__c
            FROM Case 
            WHERE Id IN :caseIds
        ]);
        
        for (EmailMessage email : Trigger.new) {
            if (email.ParentId != null && email.TextBody != null && email.TextBody.toLowerCase().contains('no change')) {
                Case relatedCase = relatedCases.get(email.ParentId);
                
                if (relatedCase != null && relatedCase.AccountId != null) {
                    Account acc = relatedCase.Account;
                    
                    if ((acc.Email_Dispute__c    != null && email.FromAddress.equalsIgnoreCase(acc.Email_Dispute__c))   || (acc.Email_1_Dispute__c  != null && email.FromAddress.equalsIgnoreCase(acc.Email_1_Dispute__c)) ||
                        (acc.Email_2_Dispute__c  != null && email.FromAddress.equalsIgnoreCase(acc.Email_2_Dispute__c)) || (acc.Email_3_Dispute__c  != null && email.FromAddress.equalsIgnoreCase(acc.Email_3_Dispute__c)) ||
                        (acc.Email_4_Dispute__c  != null && email.FromAddress.equalsIgnoreCase(acc.Email_4_Dispute__c)) || (acc.Email_5_Dispute__c  != null && email.FromAddress.equalsIgnoreCase(acc.Email_5_Dispute__c)) ||
                        (acc.Email_6_Dispute__c  != null && email.FromAddress.equalsIgnoreCase(acc.Email_6_Dispute__c)) || (acc.Email_7_Dispute__c  != null && email.FromAddress.equalsIgnoreCase(acc.Email_7_Dispute__c)) ||
                        (acc.Email_8_Dispute__c  != null && email.FromAddress.equalsIgnoreCase(acc.Email_8_Dispute__c)) || (acc.Email_9_Dispute__c  != null && email.FromAddress.equalsIgnoreCase(acc.Email_9_Dispute__c)) ||
                        (acc.Email_10_Dispute__c != null && email.FromAddress.equalsIgnoreCase(acc.Email_10_Dispute__c))) {
                            
                            relatedCase.System_Identified_No_Change__c = true;
                            casesToUpdate.put(relatedCase.Id, relatedCase);
                        }
                }
            }
        }
        
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate.values();
        }
    }
}