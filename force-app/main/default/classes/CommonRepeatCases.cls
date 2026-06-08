global class CommonRepeatCases implements Database.Batchable<sObject>,schedulable{
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new CommonRepeatCases(),Integer.ValueOf(Label.CommonRepeatCases));
    }
    
    global Database.QueryLocator start(database.BatchableContext bc){
        DateTime dt = System.Now().addHours(-2);
        
        String query = 'SELECT Id, Owner.Name, SuppliedEmail, Case_Category__c, NO_Case__c, PNO_Case__c, Repeat_Complaint__c, Case_Origin_2__c, Priority, Case_Type_Name__c, Origin, Status, Case_Type_Lookup__c, Displayed_Account_number__c, AccountId, Account.Name, Sub_Type_1_Name__c, Sub_Type_1_Lookup__c, Sub_Type_Lookup__c, Sub_Type_Name__c, CreatedDate' +
            ' FROM Case ' +
            ' WHERE CreatedDate > :dt';
        return database.getQueryLocator(query);  
    }
    
    global void execute(database.BatchableContext bc, List<Case> scope){
        
        system.debug(scope.size());
        map<string,string> requestMap = new map<string,string>();
        set<string> accId = new set<string> ();
        set<string> accNum = new set<string> ();
        set<string> subTypeId = new set<string> ();
        set<string> subTypeOne = new set<string> ();
        set<Id> caseId = new set<Id> ();
        
        String caseTypeId = 'a0K2u00000VsuRk';
        String casesubTypeId  = 'a0L2u000007rZ1U';
        String casesubType1Id = 'a0M2u000008M5XK';
                
        for(Case cs : scope){
            caseId.add(cs.Id);
            
            if(cs.AccountId != NULL){
                accId.add(cs.AccountId);
            }
            if(cs.Displayed_Account_number__c != NULL){
                accNum.add(cs.Displayed_Account_number__c);
            }
            if(cs.Sub_Type_Lookup__c != NULL){
                subTypeId.add(cs.Sub_Type_Lookup__c);
            }
            if(cs.Sub_Type_1_Lookup__c != NULL){
                subTypeOne.add(cs.Sub_Type_1_Lookup__c);
            }  
        }
        
        List<Case> csList = new List<Case>();
       
        if(!test.isRunningTest()){
            csList  = [Select Id,CaseNumber,Sub_Type_1_Lookup__c,Sub_Type_1_Name__c,AccountId,
                       Displayed_Bank_Name__c,Step_1_Duplicate__c,Displayed_Account_number__c,Sub_Type_Lookup__c 
                       from Case 
                       where Sub_Type_Lookup__c IN : subTypeId and Sub_Type_1_Lookup__c IN : subTypeOne and
                       AccountId IN : accId and Displayed_Account_number__c IN : accNum 
                       and Id NOT IN: caseId ];
        }else{
            csList  = [Select Id,CaseNumber,Sub_Type_1_Lookup__c,Sub_Type_1_Name__c,AccountId,
                       Displayed_Bank_Name__c,Step_1_Duplicate__c,Displayed_Account_number__c,Sub_Type_Lookup__c 
                       from Case where Sub_Type_Lookup__c IN : subTypeId and Sub_Type_1_Lookup__c IN : subTypeOne and
                       AccountId IN : accId and Displayed_Account_number__c IN : accNum ];
        }
        
        for(Case cse : csList){
            string str = cse.AccountId+'-'+cse.Displayed_Account_number__c+'-'+cse.Sub_Type_Lookup__c+'-'+cse.Sub_Type_1_Lookup__c;
            if(requestMap.containsKey(str)){
                
            }else{
                requestMap.put(str,cse.Id); 
            }
        }
        
        map<Id,Case> updaseCaseMap = new map<Id,Case>();  
        
        for(Case cs : scope){
            
            string str = cs.AccountId+'-'+cs.Displayed_Account_number__c+'-'+cs.Sub_Type_Lookup__c+'-'+cs.Sub_Type_1_Lookup__c;
            
            if(requestMap.containsKey(str)){
                cs.Repeat_Complaint__c = true;
                updaseCaseMap.put(cs.Id,cs);
            }
            if(cs.Case_Origin_2__c =='RBI' || cs.Case_Origin_2__c =='PNO' || cs.Repeat_Complaint__c ){
                cs.Priority = 'High';
                updaseCaseMap.put(cs.Id,cs);
            }else if(cs.Case_Origin_2__c == 'NO' || cs.Origin == 'Portal' || cs.Origin=='Email'){
                cs.Priority = 'Medium';   updaseCaseMap.put(cs.Id,cs);
            }else if(cs.Case_Type_Name__c == 'Query'){
                cs.Priority = 'Low';    updaseCaseMap.put(cs.Id,cs);
            }
            /*if(cs.SuppliedEmail != null && cs.PNO_Case__c == false && cs.NO_Case__c == false && cs.Case_Category__c == 'Consumer'){
                cs.Send_Acknowledgement_to_Email_Case__c = true;
                updaseCaseMap.put(cs.Id,cs);
            }*/
            
            if(cs.SuppliedEmail != NULL && cs.PNO_Case__c == false && cs.NO_Case__c == false && cs.Case_Category__c == 'Consumer' && cs.Owner.Name == 'Consumer Support Queue' && cs.Status == 'Open' && cs.Case_Type_Lookup__c == NULL){
                cs.Case_Complaints__c   = 'Report'; cs.Case_Type_Lookup__c  = caseTypeId;
                cs.Sub_Type_Lookup__c   = casesubTypeId; cs.Sub_Type_1_Lookup__c = casesubType1Id;
                cs.Comments = 'Auto Tagging done by batch.';
                updaseCaseMap.put(cs.Id,cs);
            }
        }
        
        if(updaseCaseMap.size() > 0){
            update updaseCaseMap.values();
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}