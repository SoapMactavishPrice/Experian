trigger UpdateCaseFromIO on IO_Comments__c (after insert) {
    
    // Prepare a set to store parent Case IDs for bulk query
    Set<Id> caseIds = new Set<Id>();
    
    // Fetching System Labels for Owner Assignment
    Id BankTeamBlankIncorrectRejectReasonId   = System.Label.BankTeamBlankIncorrectRejectReasonId;
    Id BankTeamIOSeekingFurtherInformationId  = System.Label.BankTeamIOSeekingFurtherInformationId;
    Id ConsSupportIOSeekingFurtherInformation = System.Label.ConsSupportIOSeekingFurtherInformation;
    Id ConsumerSupportReferredbacktoDRU       = System.Label.ConsumerSupportReferredbacktoDRU; 
    
    // Gather Case IDs 
    for (IO_Comments__c io : Trigger.new) {
        if (io.Status__c != null && 
            (io.Status__c == 'Accept' || io.Status__c == 'Reject'   || io.Status__c == 'Seeking further information' ||
             io.Status__c == 'Seeking Further Information - Member' || io.Status__c == 'Seeking Further Information - Consumer' || 
             io.Status__c == 'Blank / Incorrect Rejection Reason'   || io.Status__c == 'Seeking Further Information - DRU to check' )
           ) {
               caseIds.add(io.Case__c);
           }
    }
    
    // Query all cases in bulk
    Map<Id, Case> caseMap = new Map<Id, Case>([
        SELECT Id, Sub_Type_1_Name__c, Re_Referred_To_IO_Count__c, IO_Comments__c, Dispute_Rejected_Reason__c, IO_Status__c, 
        Sub_Status__c, OwnerId, Re_Referred_To_IO__c, Referred_To_IO_Case__c   
        FROM Case 
        WHERE Id IN :caseIds
    ]);
    
    List<Case> casesToUpdate = new List<Case>();
    
    // Iterate over IO_Comments__c and update cases
    for (IO_Comments__c io : Trigger.new) {
         if (!caseMap.containsKey(io.Case__c)) continue;
            Case parentCase = caseMap.get(io.Case__c);
            String subType1 = parentCase.Sub_Type_1_Name__c; 

            parentCase.IO_Comments__c = io.IO_Comments__c;
            //parentCase.Dispute_Rejected_Reason__c = io.Dispute_Rejected_Reason__c;// commented by Balram on 12th April
            parentCase.IO_Status__c = io.Status__c;
            parentCase.Sub_Status__c = io.Sub_Status__c;
            
            // Only set Referred_To_IO__c to false when it's true
            if (parentCase.Referred_To_IO_Case__c == true) {
                parentCase.Referred_To_IO_Case__c = false;
            }
            
            //Update OwnerId based on Status__c
            if (io.Status__c == 'Seeking Further Information - Member') { 
                parentCase.OwnerId = BankTeamIOSeekingFurtherInformationId;  
                parentCase.Seeking_Further_Information_Member__c = true;
                parentCase.SFI_Member_Date__c = system.today();
            } else if (io.Status__c == 'Seeking Further Information - Consumer' &&
                      (subType1 == 'Account does not belong to me' ||
                      subType1  == 'Matching/CI - Account does not belong to me' ||
                      subType1  == 'Account not reflecting' || subType1  == 'Active')) {
                parentCase.OwnerId = ConsSupportIOSeekingFurtherInformation; parentCase.Seeking_Further_Information_Consumer__c  = true;
                parentCase.SFI_Consumer_Date__c = system.today();
            }else if (io.Status__c == 'Seeking Further Information - Consumer' &&
                      (subType1 != 'Account does not belong to me' && subType1  != 'Matching/CI - Account does not belong to me' &&
                      subType1  != 'Account not reflecting' && subType1  != 'Active')) {
                parentCase.OwnerId = ConsSupportIOSeekingFurtherInformation; 
                parentCase.Send_Provide_Proof__c = true;
                parentCase.Seeking_Further_Information_Consumer__c  = true; parentCase.SFI_Consumer_Date__c = system.today();
            } else if (io.Status__c == 'Blank / Incorrect Rejection Reason') {
                parentCase.OwnerId = BankTeamBlankIncorrectRejectReasonId;
                parentCase.Blank_Incorrect_Rejection_Reason__c = true;
                parentCase.Blank_Incorrect_Rejection_Reason_Date__c = system.today();
            } else if (io.Status__c == 'Seeking Further Information - DRU to check') {
                parentCase.OwnerId = ConsumerSupportReferredbacktoDRU; 
                parentCase.Seeking_Further_Information_DRU_to_check__c = true; parentCase.SFI_DRU_to_check_Date__c = system.today();
            }    
            casesToUpdate.add(parentCase);
    }
    
    map<id,Case> accmap = new map<id,Case>();
    
    accmap.putall(casesToUpdate);
    if(accmap.size()>0){
        update accmap.values();
    }
}