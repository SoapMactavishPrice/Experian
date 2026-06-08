// 15 16 points
// step 2

global class UpdateResolvedStatus_Batch implements Database.batchable<sObject>,schedulable{
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new UpdateResolvedStatus_Batch(),Integer.ValueOf(Label.UpdateResolvedStatus_BatchSize));
    }
    global List<Case> start(Database.BatchableContext BC) {
        //string AccountName = ' and (Account.Name=\'Experian India Pvt Ltd\' or Account.Name=\'Finesse IT Labs Pvt Ltd\') ';
        Datetime todayAt7AMorPM = getCurrentTime.getTime(dateTime.now());
        date two = system.today().addDays(-2);
        string dte ='CreatedDate <=: todayAt7AMorPM';
        string query =  'Select Id  ,Sub_Type_1_Lookup__c,Sub_Type_Name__c,Sub_Type_1_Name__c,Sub_Type_Lookup__c,'+
            ' Displayed_Account_Opening_Date__c,CaseNumber,Origin,Step_2_Resolved_Status__c,'+
            ' Displayed_Bank_Name__c,Displayed_Account_number__c ,Status,Dispute_Raised_Date__c,'+
            ' Displayed_Loan_Balance__c,Consumer_Dispute_Status__c,Displayed_Overdue_Amount__c,Displayed_Account_Status__c'+
            ' from Case '+
            ' where (CreatedDate = Today OR CreatedDate = Yesterday OR CreatedDate =: two ) AND Sub_Type_1_Name__c !=\'Junk\' and Sub_Type_1_Name__c !=null AND '+
            ' (Case_Type_Name__c = \'Complaint Dispute Consumer\' OR Case_Type_Name__c = \'Complaint Dispute Commercial\') and'+
            ' Status=\'Open\' and Origin=\'Portal\' and Consumer_Dispute_Status__c = null and Step_1_Duplicate__c =false';
        if(!test.isRunningTest()){
            query+=' and Owner.Name=\'Consumer Support Queue\'';
			
            query +=' and  '+dte;
        }
        //query += AccountName;
        query+=' order by CaseNumber asc';
        //query+=' and Sub_Type_1_Name__c !=\'Account does not belong to me\'';
        
        List<Case> caseList = database.query(query);
        return caseList;
        
    }
    
    global void execute(Database.BatchableContext BC, List<Case> scope) {
        system.debug('-->'+scope.size());
        
        Map<Id,Case> csValues = new Map<Id,Case>();
        List<Case> csLists = new List<Case>();
        List<Sub_Type1__c> subTypeList= [select Id , Name,Sub_Type__c from Sub_Type1__c where Name='closed'];
        Map<Id,Id > subTypeMap =  new Map<Id,Id>();
        
        for(Sub_Type1__c stp  :subTypeList ){
            subTypeMap.put(stp.Sub_Type__c,stp.Id);  
        }
        
        for(Case cs : scope){
            csLists.add(cs);
            system.debug('-> inside for');
            ///11.	In the case of the sub type "account status" and the displayed account status is "closed," or “Entity ceased while account was closed” we should change the sub type to "closed" and send a resolution in favor of the consumer. (Status needs to be resolved and Dispute Raised Date = today)
            
            if(cs.Origin == 'Portal' && cs.Sub_Type_Name__c =='Account Status' && 
               (cs.Displayed_Account_Status__c == 'Closed'|| cs.Displayed_Account_Status__c =='Entity ceased while account was closed' )){
                   if(subTypeMap.containskey(cs.Sub_Type_Lookup__c)){
                       cs.Sub_Type_1_Lookup__c = subTypeMap.get(cs.Sub_Type_Lookup__c);
                       cs.Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer' ;
                       cs.Status='Resolved';
                       cs.Dispute_Raised_Date__c = date.today();
                       cs.Step_2_Resolved_Status__c = true;
                       cs.Step_2_Resolved_Status_Date__c = system.today();
                       csValues.put(cs.Id,cs);
                   }
               }
            
            
            //15
            if((cs.Sub_Type_1_Name__c).toLowerCase().contains('current balance') &&  cs.Displayed_Loan_Balance__c == 0){
                system.debug('-> inside current balnace');
                cs.Dispute_Raised_Date__c = date.today();
                cs.Status='Resolved';
                cs.Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer' ;
                cs.Step_2_Resolved_Status__c = true;
                cs.Step_2_Resolved_Status_Date__c = system.today();
                csValues.put(cs.Id,cs);
            }
            
            //16.	Similarly, if the sub type 1 is "overdue" and the displayed overdue amount is 0, we need to send a resolution in favor of the consumer. (Status needs to be resolved and Dispute Raised Date = today)
            if((cs.Sub_Type_1_Name__c).toLowerCase().contains('over due') &&  cs.Displayed_Overdue_Amount__c == 0){
               system.debug('-> inside Overdue');
               cs.Dispute_Raised_Date__c = date.today();
               cs.Status='Resolved';
               cs.Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer';
                cs.Step_2_Resolved_Status__c = true;
                cs.Step_2_Resolved_Status_Date__c = system.today();
                csValues.put(cs.Id,cs);
            }
        }
        
        List<API_LOG__c> apliLogList = new List<API_LOG__c>();
        system.debug('csValues'+csValues.size() );
        if(csValues.size() > 0){
            
            Database.SaveResult[] srList = Database.update(csValues.values(),false);
            
            for(Integer i=0;i<srList.size();i++){
                if(!srList.get(i).isSuccess()){
                    for(Database.Error err : srList[i].getErrors()) {
                        if(csValues.containskey(csLists[i].Id)){
                            API_LOG__c ap =new API_LOG__c();
                            ap.Request_Source__c='Step 2 Fail '+csValues.get(csLists[i].Id).CaseNumber;
                            ap.Case__c = csValues.get(csLists[i].Id).Id;
                            ap.Exception_Description__c = err.getMessage();
                            apliLogList.add(ap);
                        } 
                    }
                }
                
            }
            
         }
        
        if(apliLogList.size() > 0){
                insert apliLogList;
        }
        
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}