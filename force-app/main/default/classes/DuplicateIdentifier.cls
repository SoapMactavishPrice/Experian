global class DuplicateIdentifier implements Database.Batchable<sObject>,schedulable{
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new DuplicateIdentifier(),Integer.ValueOf(Label.DuplicateIdentifiersize));
    }
    
    global List<Case> start(Database.BatchableContext BC){
        //string AccountName = ' and (Account.Name=\'Experian India Pvt Ltd\' or Account.Name=\'Finesse IT Labs Pvt Ltd\') ';
        Datetime todayAt7AMorPM = getCurrentTime.getTime(dateTime.now());
        date two = system.today().addDays(-2);
       string dte ='CreatedDate <=: todayAt7AMorPM';
        
        string query= 'Select Id,status,Sub_Type_1_Lookup__c,Sub_Type_1_Name__c,Dispute_Raised_Date__c,Name_of_Consumer__r.Full_Name__c,Displayed_Bank_Name__c,Displayed_Account_number__c From Case Where status = \'Open\' and (CreatedDate=Today or CreatedDate=Yesterday or CreatedDate =: two ) and '+
            ' Consumer_Dispute_Status__c =null and Sub_Type_1_Name__c !=null and Name_of_Consumer__c !=null and Displayed_Bank_Name__c !=null and Displayed_Account_number__c !=null and Origin=\'Portal\' and Step_1_Duplicate__c =false';
         if(!test.isRunningTest()){
            query+=' and Owner.Name=\'Consumer Support Queue\'';
             //query +=' and  '+dte;
        }
        //query += AccountName;
        // query+=' and Sub_Type_1_Name__c !=\'Account does not belong to me\'';
        
        List<Case> csList = database.query(query);
        return csList;
    }
    
    global void execute(Database.BatchableContext BC , List<Case>Scope){
        
        map<string,string> key = new map<string,string>();
        set<string> subTypeId = new set<string> ();
        set<Id> consumerId = new set<Id> ();
        set<string> banName = new set<string> ();
        set<string> accNumber = new set<string> ();
        set<Id> csId = new set<Id>();
        
        Case_Type__c  ct   = [SELECT Id FROM Case_Type__c where Name = 'Query' and Case_Category__c='Consumer' and Case_Complaint__c='Report' limit 1];
        Sub_Type__c	  sub  = [Select Id, Case_Type__c  from Sub_Type__c	 where Name ='Status of Dispute' and Case_Type__c =: ct.Id];
        Sub_Type1__c  sub1 = [Select Id from Sub_Type1__c	 where Name ='Duplicate' and Sub_Type__c =:sub.Id];

        for(Case cs : Scope){
            csId.add(cs.Id);
            string str  = cs.Sub_Type_1_Name__c + '_' + cs.Name_of_Consumer__r.Full_Name__c +'_'+
            cs.Displayed_Bank_Name__c + '_' + cs.Displayed_Account_number__c;
            key.put(str,cs.Id);
            subTypeId.add(cs.Sub_Type_1_Lookup__c);
            consumerId.add(cs.Name_of_Consumer__c);
            banName.add(cs.Displayed_Bank_Name__c);
            accNumber.add(cs.Displayed_Account_number__c);
        }   
        
        Date today_s_Date = date.today();
        Date yest_s_Date = date.today().addDays(-1);
        
        List<Case> csList = [Select Id,CaseNumber,Sub_Type_1_Lookup__c,Sub_Type_1_Name__c,Name_of_Consumer__r.Full_Name__c,status,Dispute_Raised_Date__c,
                             Displayed_Bank_Name__c,Step_1_Duplicate__c,Displayed_Account_number__c from Case where Sub_Type_1_Lookup__c IN : subTypeId and Name_of_Consumer__c IN : consumerId and
                             Displayed_Bank_Name__c IN : banName and Displayed_Account_number__c IN : accNumber and status=:'Open'
                             and
                            (Created_Date__c=:today_s_Date or Created_Date__c=:yest_s_Date) and Consumer_Dispute_Status__c =:null
                             and Sub_Type_1_Name__c !=null and Name_of_Consumer__c !=null and Displayed_Bank_Name__c !=null and 
                             Displayed_Account_number__c !=null
                             order by CreatedDate asc 
                            ]; 
        
        map<string, list<Case>> caseMapData = new map<string, list<Case>>();
        for(Case cs : csList){
            system.debug('case number '+cs.CaseNumber);
            string keyValue  = cs.Sub_Type_1_Name__c + '_' + cs.Name_of_Consumer__r.Full_Name__c +'_'+cs.Displayed_Bank_Name__c + '_' + cs.Displayed_Account_number__c;
            if(caseMapData.containsKey(keyValue)){
                caseMapData.get(keyValue).add(cs);
            }else{
                caseMapData.put(keyValue,new List<Case>{cs});
            }
        }
        
        system.debug('csList'+caseMapData);
        List<Case> dupCaselIst = new List<Case>();
        map<Id,string> csMapId = new map<Id,string>();
        
        system.debug(' caseMapData   '+caseMapData.size());
        if(caseMapData.size() > 0){
            for(string str : caseMapData.keyset()){
                List<Case> casesList = new List<Case>();
                casesList = caseMapData.get(str);
                system.debug('str '+str + ' size '+ casesList.size());
                if(casesList.size() > 1){
                    casesList.remove(0);
                    system.debug('str 1 '+str + ' size 1 '+ casesList.size());
                    for(Case cs : casesList){
                       cs.Case_Category__c = 'Consumer';
                        cs.Case_Complaints__c = 'Report';
                        cs.Case_Type_Lookup__c = ct.Id;
                        cs.Sub_Type_Lookup__c = sub.Id;
                        cs.Sub_Type_1_Lookup__c = sub1.Id;
                        cs.Dispute_Raised_Date__c = system.today();
                        cs.Status = 'Resolved';
                        cs.Step_1_Duplicate__c = true;
                        cs.Step_1_Duplicate_Date__c = system.today();
                        csMapId.put(cs.Id,cs.CaseNumber);
                        dupCaselIst.add(cs);
                    }
                }
            }
        }
        
        system.debug('dupCaselIst'+dupCaselIst.size());
        List<API_LOG__c> apliLogList = new List<API_LOG__c>();
        if(dupCaselIst.size() > 0){
            Database.SaveResult[] srList = Database.update(dupCaselIst,false);
            for(Integer i=0;i<srList.size();i++){
                if(!srList.get(i).isSuccess()){
                    for(Database.Error err : srList[i].getErrors()) {
                        if(csMapId.containskey(dupCaselIst[i].Id)){
                            API_LOG__c ap =new API_LOG__c();
                            ap.Request_Source__c='Step 1 Fail '+csMapId.get(dupCaselIst[i].Id);
                            ap.Case__c = dupCaselIst[i].Id;
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
    
    global void finish(Database.BatchableContext bc){
        
    }   
}