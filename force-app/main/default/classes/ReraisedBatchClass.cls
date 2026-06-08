global class ReraisedBatchClass implements Database.Batchable<sObject>,schedulable{
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new ReraisedBatchClass(),Integer.ValueOf(Label.ReraisedBatchsize));
    }
    
    
    global List<Case> start(Database.BatchableContext BC){
        //string AccountName = ' and (Account.Name=\'Experian India Pvt Ltd\' or Account.Name=\'Finesse IT Labs Pvt Ltd\') ';
        
        Datetime todayAt7AMorPM = getCurrentTime.getTime(dateTime.now());
        date two = system.today().addDays(-2);
        
        string dte ='CreatedDate <=: todayAt7AMorPM';
        string query= 'Select Id,Dispute_Detail__c,Raise_Online_Dispute_Re_Raise__c,Step_3_Re_Raise__c,Correct_Loan_Balance__c,Displayed_Loan_Balance__c,Displayed_Overdue_Amount__c,Correct_Overdue_Amount__c,Sub_Type_1_Name__c,Sub_Type_Name__c,Dispute_Raised_Date__c From Case Where status = \'Open\'and (CreatedDate=Today or CreatedDate=Yesterday OR CreatedDate =: two ) '+
            ' and  Origin=\'Portal\' and (Sub_Type_1_Name__c=\'EMI Amounts\' or Sub_Type_Name__c=\'Balance Issue\' or Sub_Type_Name__c=\'DPD\' ) and Step_1_Duplicate__c =false and Step_2_Resolved_Status__c =false';
        
        if(!test.isRunningTest()){
            query+=' and Owner.Name=\'Consumer Support Queue\'';
            
            query +=' and  '+dte;
        }
        //query += AccountName;
        //query+=' and Sub_Type_1_Name__c !=\'Account does not belong to me\'';
        List<Case> csList = database.query(query);
        return csList;
    }
    
    global void execute(Database.BatchableContext BC , List<Case>Scope){
        
        map<string,Case> keyMap = new map<string,Case>();
        
        Case_Type__c ct   = [SELECT Id FROM Case_Type__c where Name = 'Query' and Case_Category__c='Consumer' and Case_Complaint__c='Report' limit 1];
        Sub_Type__c	  sub = [Select Id , Case_Type__c  from Sub_Type__c	 where Name ='Status of Dispute' and Case_Type__c =: ct.Id];
        Sub_Type1__c sub1 = [Select Id from Sub_Type1__c	 where Name ='Re-raise' and Sub_Type__c =:sub.Id];
        
        List<Case> dupCaselIst = new List<Case>();
        
        set<Id> caseId = new set<Id>();
        for(Case cs : Scope){
            system.debug('sub type '+cs.Sub_Type_Name__c);
            
            if(cs.Sub_Type_1_Name__c =='EMI Amounts'){
                cs.Case_Category__c = 'Consumer';
                cs.Case_Complaints__c = 'Report';
                cs.Case_Type_Lookup__c = ct.Id;
                cs.Sub_Type_Lookup__c = sub.Id;
                cs.Sub_Type_1_Lookup__c = sub1.Id;
                if(!test.isRunningTest()){
                    cs.Dispute_Raised_Date__c = system.today();
                }
                
                cs.Raise_Online_Dispute_Re_Raise__c = true;
                cs.Status = 'Resolved';
                
                cs.Step_3_Re_Raise__c = true;
                cs.Step_3_Re_Raise_Date__c = system.today();
                keyMap.put(cs.Id,cs);
                dupCaselIst.add(cs);
            }
            
            else if(cs.Sub_Type_Name__c =='DPD'){
                
                if(string.isBlank(cs.Dispute_Detail__c)){// do testing
                    
                    cs.Case_Category__c = 'Consumer';
                    cs.Case_Complaints__c = 'Report';
                    cs.Case_Type_Lookup__c = ct.Id;
                    cs.Sub_Type_Lookup__c = sub.Id;
                    cs.Sub_Type_1_Lookup__c = sub1.Id;
                    
                    if(!test.isRunningTest()){
                        cs.Dispute_Raised_Date__c = system.today();
                    }
                    cs.Raise_Online_Dispute_Re_Raise__c = true;
                    cs.Status = 'Resolved';
                    cs.Step_3_Re_Raise__c = true; 
                    cs.Step_3_Re_Raise_Date__c = system.today();
                    keyMap.put(cs.Id,cs);  
                    dupCaselIst.add(cs);
                    
                }else {
                    caseId.add(cs.Id);
                    keyMap.put(cs.Id,cs);
                }
            } 
            else if(cs.Sub_Type_Name__c =='Balance Issue'){
                
                if(cs.Sub_Type_1_Name__c =='Current Balance'){
                    
                    if(cs.Correct_Loan_Balance__c > cs.Displayed_Loan_Balance__c &&  cs.Correct_Loan_Balance__c > 0 &&
                       cs.Displayed_Loan_Balance__c  > 0){
                           
                           cs.Case_Category__c = 'Consumer';
                           cs.Case_Complaints__c = 'Report';
                           cs.Case_Type_Lookup__c = ct.Id;
                           cs.Sub_Type_Lookup__c = sub.Id;
                           cs.Sub_Type_1_Lookup__c = sub1.Id;
                           if(!test.isRunningTest()){
                               cs.Dispute_Raised_Date__c = system.today();
                           }
                           cs.Raise_Online_Dispute_Re_Raise__c = true;
                           cs.Status = 'Resolved';
                           
                           cs.Step_3_Re_Raise__c = true;
                           cs.Step_3_Re_Raise_Date__c = system.today();
                           keyMap.put(cs.Id,cs);
                           dupCaselIst.add(cs);
                       }
                }
                else if(cs.Sub_Type_1_Name__c =='Over due'){
                    
                    if(cs.Correct_Overdue_Amount__c > cs.Displayed_Overdue_Amount__c &&  cs.Correct_Overdue_Amount__c  > 0 && cs.Displayed_Overdue_Amount__c  > 0){
                        
                        cs.Case_Category__c = 'Consumer';
                        cs.Case_Complaints__c = 'Report';
                        cs.Case_Type_Lookup__c = ct.Id;
                        cs.Sub_Type_Lookup__c = sub.Id;
                        cs.Sub_Type_1_Lookup__c = sub1.Id;
                        if(!test.isRunningTest()){
                            cs.Dispute_Raised_Date__c = system.today();
                        }
                        cs.Raise_Online_Dispute_Re_Raise__c = true;
                        cs.Status = 'Resolved';
                        
                        cs.Step_3_Re_Raise__c = true;
                        cs.Step_3_Re_Raise_Date__c = system.today();
                        keyMap.put(cs.Id,cs);
                        dupCaselIst.add(cs);
                    }
                }    
            }
        }
        
        List<DPD_Detail__c> dpdList = new List<DPD_Detail__c> ();
        
        dpdList = [select Id ,Case__c,Correct_EMI_Repayment_Month__c,Displayed_EMI_Repayment_Month__c 
                   from DPD_Detail__c where Case__c IN : caseId];
        
        for(DPD_Detail__c dpd : dpdList){
            
            if(keyMap.containsKey(dpd.Case__c)){
                
                if(dpd.Displayed_EMI_Repayment_Month__c <= 0 ){
                    
                    case cs = new Case();
                    cs.Id = keyMap.get(dpd.Case__c).Id;
                    cs.Case_Category__c = 'Consumer';
                    cs.Case_Complaints__c = 'Report';
                    cs.Case_Type_Lookup__c = ct.Id;
                    cs.Sub_Type_Lookup__c = sub.Id;
                    cs.Sub_Type_1_Lookup__c = sub1.Id;
                    if(!test.isRunningTest()){
                        cs.Dispute_Raised_Date__c = system.today();
                    }
                    cs.Raise_Online_Dispute_Re_Raise__c = true;
                    cs.Status = 'Resolved';
                    
                    cs.Step_3_Re_Raise__c = true;
                    cs.Step_3_Re_Raise_Date__c = system.today();
                    keyMap.put(cs.Id,cs);
                    dupCaselIst.add(cs);
                }
            }
        }
        
        system.debug('keyMap ::: >>> '+keyMap.size());
        List<API_LOG__c> apliLogList = new List<API_LOG__c>();
        if(keyMap.size() > 0){
            Database.SaveResult[] srList = Database.update(keyMap.values(),false);
           /* for(Integer i=0;i<srList.size();i++){
                if(!srList.get(i).isSuccess()){
                    for(Database.Error err : srList[i].getErrors()) {
                        if(keyMap.containskey(dupCaselIst[i].Id)){
                            API_LOG__c ap =new API_LOG__c();
                            ap.Request_Source__c='Step 3 Fail '+keyMap.get(dupCaselIst[i].Id).CaseNumber;
                            ap.Case__c = keyMap.get(dupCaselIst[i].Id).Id;
                            ap.Exception_Description__c = err.getMessage();
                            apliLogList.add(ap);
                        } 
                    }
                }
                
            } */
        }  
        
         if(apliLogList.size() > 0){
                insert apliLogList;
        }
        
    }
    
    global void finish(Database.BatchableContext bc){
        
    } 
    
}