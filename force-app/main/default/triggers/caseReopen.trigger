trigger caseReopen on EmailMessage (after insert) { 
    
    Set<Id> set_caseId = new Set<Id>();    
    for(EmailMessage em: trigger.new){
        if(em.parentId!=Null && em.Incoming == true){
            set_caseId.add(em.parentId);
            system.debug('set_caseId'+set_caseId);
        }
    }
    
    Set<Id> BankCaseId = new Set<Id>(); 
    map<string, EmailMessage> emailMap  = new map<string,EmailMessage>();
    Id bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;
    Id ConSupId   = System.Label.Consumer_Support_Queue_Id;
    Id CustSupId  = System.Label.Customer_Support_Queue_Id;
    Id MembSupId  = System.Label.Membership_Support_Queue_Id;
    
    set<Id> parentCaseId = new set<Id>();
    
    for(EmailMessage em: trigger.new){
        if(em.parentId!=Null && em.Incoming == true){
            BankCaseId.add(em.parentId);
            emailMap.put(em.FromAddress, em);
            system.debug('BankCaseId----->'+BankCaseId);
            system.debug('emailMap----->'+emailMap);
        }
    }
    
    List<Case> listcse1 = new List<Case>();
    
    for(Case cse : [Select Id, OwnerId , AccountId, Account.Email_Dispute__c,Account.Email_1_Dispute__c, Account.Email_2_Dispute__c ,
                    Account.Email_3_Dispute__c, Account.Email_4_Dispute__c ,Account.Email_5_Dispute__c ,Account.Email_6_Dispute__c,
                    Account.Email_7_Dispute__c,Account.Email_8_Dispute__c,Account.Email_9_Dispute__c,Account.Email_10_Dispute__c
                    from Case where Id IN : BankCaseId]){//and OwnerId =:bankteamId 
                        
                        if(emailMap.containsKey(cse.Account.Email_Dispute__c) || emailMap.containsKey(cse.Account.Email_1_Dispute__c)|| emailMap.containsKey(cse.Account.Email_2_Dispute__c) || emailMap.containsKey(cse.Account.Email_3_Dispute__c) || emailMap.containsKey(cse.Account.Email_4_Dispute__c) || emailMap.containsKey(cse.Account.Email_5_Dispute__c)|| emailMap.containsKey(cse.Account.Email_6_Dispute__c)  || emailMap.containsKey(cse.Account.Email_7_Dispute__c) || emailMap.containsKey(cse.Account.Email_8_Dispute__c)  || emailMap.containsKey(cse.Account.Email_9_Dispute__c)|| emailMap.containsKey(cse.Account.Email_10_Dispute__c) ){
                            
                            cse.OwnerId =ConSupId;
                            listcse1.add(cse); 
                            system.debug('listcse1'+listcse1);
                        }
                    }
    
    List<Case> listcse = new List<Case>();
    for(Case cse : [Select Id, Status, Junk_Case__c, Case_Category__c  from Case where Id In : set_caseId And 
                    (Status ='Resolved' OR Status='ReClose') and Junk_Case__c=false]){
                        
                        cse.Status = 'ReOpen';
                        
                        if(cse.Case_Category__c =='Customer'){
                            cse.OwnerId=CustSupId;
                        }
                        if(cse.Case_Category__c =='Consumer'){
                            cse.OwnerId=ConSupId;
                        }
                        if(cse.Case_Category__c =='Membership'){
                            cse.OwnerId=MembSupId;
                        }
                        listcse.add(cse); 
                        system.debug('listcse'+listcse);
                    }
    
    if(listcse1.size()>0){
        update listcse1;
        system.debug('listcse1'+listcse1);
    }
    
      
    if(listcse.size()>0){
        update listcse;
        system.debug('listcse'+listcse);
    } 
    
    // Parent Case Update
    
    set<Id> prId = new set<Id>();
    for(case cs : [Select Id, Account_s_Parent_Case__c, OwnerId from Case where Id IN: listcse1 and Account_s_Parent_Case__c =: true]){
        prId.add(cs.Id);
    }
    
    List<Case> childCase = new List<Case>();
    Set <Id> caseIds = new Set <Id>();
    if(prId.size() > 0){
        for(Case cs : [select Id from Case where Reminder_Parent_Case__c IN : prId and Account_s_Parent_Case__c =: false and Owner.Name ='Bank Team']){
            //cs.OwnerId = ConSupId;
            //caseIds.add(cs.Id);
            //childCase.add(cs);
        }
    }
    
    if(childCase.size() > 0){
        //update childCase;
    } 
    
    if(caseIds.size()>0 || caseIds.size()!=0){ //Vijai Added after Discussing with Balram 28/05/2024 
        system.debug('Inside caseIds----');
        if(!system.isBatch()){
            system.debug('Inside CaseOwnerUpdate_Batch Caller----');
            CaseOwnerUpdate_Batch updateOwner = new CaseOwnerUpdate_Batch(caseIds);
            Integer batchSize = Integer.ValueOf(Label.CaseOwnerUpdate_BatchSize);
            if(Test.isRunningTest())
                batchSize = 200;
            Id batchId = Database.executeBatch(updateOwner, batchSize);
        }
    }
    
}