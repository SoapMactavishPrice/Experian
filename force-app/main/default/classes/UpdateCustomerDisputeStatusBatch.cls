global class UpdateCustomerDisputeStatusBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(DataBase.BatchableContext bc){
        
        string CaseType = 'Complaint Dispute Consumer';
        string status = 'Open';
        Id bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;
        Boolean btrue = true;
        integer disputeDays = 30;
        string consStatus = 'Acknowledgement sent to Consumer';
        string query  = 'Select Id,Consumer_Dispute_Status__c from Case where OwnerId =:bankteamId AND Case_Type_Name__c =:CaseType AND Dispute_Days__c =: disputeDays AND Status =:status AND Consumer_Dispute_Status__c =:consStatus AND Forward_to_bank__c =:btrue'; 
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Case> scope){
        
        List<Case> upList = new List<Case>(); 
        
        for(Case cs : scope){
            cs.Consumer_Dispute_Status__c = 'No response from the bank';
            upList.add(cs);
        }
        if(upList.size() > 0)
            update upList;
    }
    
    global void finish(Database.BatchableContext BC){
    }
}