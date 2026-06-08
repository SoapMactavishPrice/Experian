trigger UpdateCaseOwner on Case (before Update) {
    
    
    // Validation on Sub Type - Matching, Merging
    Boolean doQuery = false;
    for(Case cs : Trigger.New) {
        if(cs.Forward_to_bank__c) {
            doQuery = true;
            break;
        }
    }
    
    if(doQuery) {
        String[] subTypeNames = new String[] {'Matching', 'Merging'};
        Map<Id, Sub_Type__c> subTypesMap = new Map<Id, Sub_Type__c> ([SELECT Id, Name FROM Sub_Type__c WHERE Name IN: subTypeNames AND isActive__c = true]);
        
        for(Case cs : Trigger.New) {
            if(cs.Forward_to_bank__c) {
                if(subTypesMap.containsKey(cs.Sub_Type_Lookup__c)) {
                    cs.Forward_to_bank__c.addError('Forwarding to bank is not allowed when case is classified as ' + cs.Sub_Type_Name__c);
                }
            }
        }
    }
    
  
    List<string> GroupName = new List<string>();
    GroupName.add('Data Merger Team');
    GroupName.add('Data Submission Team');
    GroupName.add('OLM Team');
    GroupName.add('Bank Team');
    GroupName.add('ECV Team');
    GroupName.add('Consumer Support Queue');
    GroupName.add('EWACS Team');
    GroupName.add('Matching Team');
    GroupName.add('NG Team');
    GroupName.add('STS Team');
    GroupName.add('Score Team');
    
    //List<Group> groupmaster =[select Id,Name from Group where  Type = 'Queue'/* and Name IN : GroupName*/]; No where Used 30-05-2024
    
    //system.debug('All Quesue'+groupmaster.size()); No where Used 30-05-2024
    //if(Trigger.IsBefore && (Trigger.IsUpdate || Trigger.isInsert)) {
    if(Trigger.IsBefore && Trigger.IsUpdate) {
        map <string ,Id> queuesmap = new map<string,Id>();
        for(Group grp : [select Id,Name from Group where  Type = 'Queue' and Name IN : GroupName limit 11]){
            queuesmap.put(grp.Name,grp.Id);
        }
        //RecursiveTriggerHandler.isFirstTimeDateUpdate = false;
        for(Case cs : Trigger.new) {
            // WF - Owner change to Data Merger  --- 30 January 23 - Rishi
            if(cs.Forward_to_Data_Merger__c && (cs.Forward_to_Data_Merger_Sent_Date_1__c == null || cs.Forward_to_Data_MergerDate__c == null)  
               && cs.Forward_to_Data_Merger__c != Trigger.oldMap.get(cs.Id).Forward_to_Data_Merger__c) {
                   cs.OwnerId = queuesmap.get('Data Merger Team');
               }
            
            //WF - Owner change to Data Submission  --- 30 January 23 - Rishi
            if(cs.Forward_to_Data_Submission__c && cs.Forward_to_Data_Submission_Sent_Date_1__c == null
               && cs.Forward_to_Data_Submission__c != Trigger.oldMap.get(cs.Id).Forward_to_Data_Submission__c) {
                   cs.OwnerId = queuesmap.get('Data Submission Team');
               }
            
            //WF - Owner change to OLM  --- 30 January 23 - Rishi
            if(cs.Forward_to_OLM__c && cs.Forward_to_OLM__c != Trigger.oldMap.get(cs.Id).Forward_to_OLM__c && (cs.Forward_to_OLM_Sent_Date_1__c == null || cs.Forward_to_OLMDate__c == null)) {
                cs.OwnerId = queuesmap.get('OLM Team');
                // cs.Forward_to_OLMDate__c = system.today();
            }
            
            //WF - Email to Bank Team  --- 30 January 23 - Rishi
            
            if(cs.Forward_to_bank__c && (cs.Forward_to_Bank_Sent_Date_1__c == null || cs.Forward_to_Bank_Date__c == null) &&
               cs.Forward_to_bank__c != Trigger.oldMap.get(cs.Id).Forward_to_bank__c) {
                   If(string.isBlank(cs.AccountId) && cs.Forward_to_bank__c){
                       cs.AccountId.addError('Please select account first');
                   }else{
                       cs.OwnerId = queuesmap.get('Bank Team');
                   }
               }
            
            //WF - Email to ECV   --- 30 January 23 - Rishi
            if(cs.Forward_to_ECV_Team__c && (cs.Forward_to_ECV_Team_Sent_Date_1__c == null || cs.Forward_to_ECV_TeamDate__c == null) &&
               cs.Forward_to_ECV_Team__c != Trigger.oldMap.get(cs.Id).Forward_to_ECV_Team__c) {
                   cs.OwnerId = queuesmap.get('ECV Team');
                   cs.Forward_to_ECV_TeamDate__c = system.today();                             
               }
            
            //WF - Email to CST - Consumer   --- 30 January 23 - Rishi email alert present
            if(cs.Forward_to_CST_Team__c && cs.Case_Category__c == 'Consumer' && cs.Forward_to_CST_Team__c != Trigger.oldMap.get(cs.Id).Forward_to_CST_Team__c && (cs.Forward_to_CST_Team_Sent_Date_1__c == null || cs.Forward_to_CST_TeamDate__c == null)){
               
                 If(cs.Forward_to_CST_Team__c && string.isBlank(cs.Name_of_Consumer__c)){
                       cs.Name_of_Consumer__c.addError('Please select Consumer Name first');
                   } else{
                       cs.OwnerId = queuesmap.get('Consumer Support Queue');
                       cs.Forward_to_CST_TeamDate__c = date.today();
                   }
            }
            
            //WF - Email to EWACS Team   --- 30 January 23 - Rishi - 
            if(cs.Forward_to_EWACS_Team__c && cs.Forward_to_EWACS_Team__c != trigger.oldmap.get(cs.Id).Forward_to_EWACS_Team__c) {
                cs.OwnerId = queuesmap.get('EWACS Team');
                cs.Forward_to_EWACS_Team_Date__c =date.today();
            }
            
            // WF -Email to Matching Team   --- 30 January 23 - Rishi --
            if(cs.Forward_to_GPD_Team__c && ( cs.Forward_to_GPD_Team_Sent_Date_1__c == null || cs.Forward_to_GPD_TeamDate__c == null) &&
               cs.Forward_to_GPD_Team__c != Trigger.oldMap.get(cs.Id).Forward_to_GPD_Team__c) {
                   cs.OwnerId = queuesmap.get('Matching Team');
                   cs.Forward_to_GPD_TeamDate__c = Date.today();
               }
            
            // WF -Email to NG Team   --- 30 January 23 - Rishi
            if(cs.Forward_to_NG_Team__c && (cs.Forward_to_NG_Team_Sent_Date_1__c == null || cs.Forward_to_NG_Team_Date__c == null)  && cs.Forward_to_NG_Team__c != Trigger.oldMap.get(cs.Id).Forward_to_NG_Team__c) {
                cs.OwnerId = queuesmap.get('NG Team');
                //cs.Forward_to_NG_Team_Date__c = date.today();
            }
            
            // WF Email to STS   --- 30 January 23 - Rishi --  no changes
            if(cs.Forward_to_STS_Team__c && cs.Forward_to_STS_Team__c != Trigger.oldMap.get(cs.Id).Forward_to_STS_Team__c) {
                cs.OwnerId = queuesmap.get('STS Team');
                cs.Forward_to_STS_TeamDate__c = date.today();
            }           
            
            // WF Email to Score Team    --- 30 January 23 - Rishi
            if(cs.Forward_to_Score_Team__c && ( cs.Forward_to_Score_Team_Sent_Date_1__c == null || cs.Forward_to_Score_Team_Date__c == null) &&
               cs.Forward_to_Score_Team__c != Trigger.oldMap.get(cs.Id).Forward_to_Score_Team__c) {
                   cs.OwnerId = queuesmap.get('Score Team');
                   cs.Forward_to_Score_Team_Date__c = date.today();
               }
            
            // WF Forward to bank & DataOps Teams(Backend) Date/TIme    --- 30 January 23 - Rishi
            if(cs.Forward_to_bank__c && cs.Forward_to_bank__c!= Trigger.oldMap.get(cs.Id).Forward_to_bank__c  && cs.Forward_to_DataOps_Teams__c && cs.Forward_to_bank_DataOps_Teams_Backend__c == null) {
                cs.Forward_to_bank_DataOps_Teams_Backend__c = system.now();
            }
            
            // WF Forward to Forward to bank(Backend) Date/TIme    --- 30 January 23 - Rishi
            if(cs.Forward_to_bank__c && cs.Forward_to_bank__c!= Trigger.oldMap.get(cs.Id).Forward_to_bank__c && cs.Forward_to_DataOps_Teams__c == false && cs.Forward_to_bank_Backend__c == null) {
                cs.Forward_to_bank_Backend__c = system.now();
            }
            
        }
    }
        
}