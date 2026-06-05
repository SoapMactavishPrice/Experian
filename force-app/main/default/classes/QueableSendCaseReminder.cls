public with sharing class QueableSendCaseReminder implements Queueable{
    private Map<Integer, List<Sobject>>  records;
    private String action;      //insert or update or upsert or delete
    private Integer batchSize;
    private Integer currentBatch;
    private String finallyHandlerName;
    private Id parentId;
    private Integer successCount; 
    private List<Account> AccountList;
    
    
    public Integer offset = 1;
    public Integer lmit = 0;
    
    
    //Queueable Jobs kick-off
    //System.enqueueJob(new QueableSendCaseReminder(this.records, this.action, this.batchSize, nextBatch, this.finallyHandlerName, this.parentId, this.successCount, this.AccountList));

    public QueableSendCaseReminder(List<Sobject> recordsList, String action, Integer batchSize, Id parentId, String finallyHandlerName , List<Account> AccountList){
        this.records = batchOutDmls(recordsList, batchSize);
        this.action = action;
        this.batchSize = batchSize;
        this.currentBatch = 1;
        this.finallyHandlerName = finallyHandlerName;
        this.parentId = parentId;
        this.successCount = 0;
        this.AccountList = AccountList;
    }
    
    
    //Iterative Queueable job
    //System.enqueueJob(new QueableSendCaseReminder(this.records, this.action, this.batchSize, nextBatch, this.finallyHandlerName, this.parentId, this.successCount, this.AccountList));
    
    public QueableSendCaseReminder(Map<Integer, List<Sobject>>  records, String action, Integer batchSize, Integer currentBatch, String finallyHandlerName, Id parentId, Integer successCount, List<Account> AccountList){
        this.records = records;
        this.action = action;
        this.batchSize = batchSize;
        this.currentBatch = currentBatch;
        this.finallyHandlerName = finallyHandlerName;
        this.parentId = parentId;
        this.successCount = successCount; 
        this.AccountList = AccountList;
        
    }
    
    public void execute(QueueableContext context) {
        if(this.records.containsKey(this.currentBatch)){
            Boolean success = false;
            Integer processedRecords = 0;
            integer recordErrorProceed = 0;
            try {
                List<Sobject> thisBatchRecords = this.records.get(this.currentBatch);
                processedRecords = thisBatchRecords.size();
                switch on action {
                    when 'INSERT' {
                        insert thisBatchRecords;
                    }	
                    when 'UPDATE' {
                        system.debug('update size'+thisBatchRecords.size());
                        update thisBatchRecords;
                        system.debug('update size to all'+thisBatchRecords.size());
                        
                        List<API_LOG__c> apliLogList = new List<API_LOG__c>();
                        
                        if(thisBatchRecords.size() > 0){
                            
                            Database.SaveResult[] srList = Database.update(thisBatchRecords,false);
                            system.debug('updated get record '+srList.size());
                            for(Integer i=0;i<srList.size();i++){
                                system.debug('Error 67-->'+srList.get(i).isSuccess());
                                if(!srList.get(i).isSuccess()){
                                   system.debug('Error 69 inside fail'+srList[i].getErrors());
                                    for(Database.Error err : srList[i].getErrors()) {
                                        
                                        API_LOG__c ap =new API_LOG__c();
                                        ap.Request_Source__c='Case Reminder Case Update  Failed Before April 26, 2024';
                                        ap.Case__c = thisBatchRecords[i].Id;
                                        ap.Exception_Description__c = err.getMessage();
                                        apliLogList.add(ap);
                                        
                                    }
                                }
                                
                            }
            
                   }   
        
                        if(apliLogList.size() > 0){
                            insert apliLogList;
                            recordErrorProceed = apliLogList.size();
                        }
                    }
                    when 'UPSERT' {
                        upsert thisBatchRecords;
                    }
                    when 'DELETE' {
                        delete thisBatchRecords;
                    }
                }
                this.records.remove(this.currentBatch);
                system.debug('error records '+recordErrorProceed);
                if(recordErrorProceed != 0){
                    success = false;
                }
                if(recordErrorProceed == 0){
                    success = true;
                }
            } catch(Exception e){
                System.debug('Exception in queueable jobs chain ==> '+e.getMessage());
                //Handle your relevant custom exception handling and monitoring                
            }
            QueableSendCaseReminder handler;
            if(String.isNotBlank(this.finallyHandlerName)){
                Type classType = Type.forName(this.finallyHandlerName);
                handler = (QueableSendCaseReminder)classType.newInstance();
				system.debug(handler);                
            }            
            if(success) {
                if(this.successCount == null){
                    this.successCount = processedRecords;
                } else {
                    this.successCount += processedRecords;
                }
                //if(handler != null){
                    QueableSendCaseReminder.handleSingleBatchCompletion(this.parentId, this.successCount);
                //}
            

            Integer nextBatch = this.currentBatch + 1;
            if(this.records.containsKey(nextBatch) && Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()){
                //Chain jobs
                System.enqueueJob(new QueableSendCaseReminder(this.records, this.action, this.batchSize, nextBatch, this.finallyHandlerName, this.parentId, this.successCount, this.AccountList));
            } else/* if(handler != null)*/{
                 QueableSendCaseReminder.handleAllJobsCompletion(this.parentId, this.successCount ,this.AccountList);
                //Invoke the finally callback
               /* handler.handleAllJobsCompletion(this.parentId, this.successCount);
                {
                   // List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
                }*/
            }
            }
        } 
    }

    private Map<Integer, List<Sobject>> batchOutDmls(List<Sobject> recordsList, Integer batchSize){
        Map<Integer, List<Sobject>> batchMap = new Map<Integer, List<Sobject>>();
        if(batchSize <= 10000){
            Integer batchCurrSize = 0;
            Integer batchNumber = 1;
            List<Sobject> singleBatch = new List<Sobject>();    
            for (Integer i = 0; i < recordsList.size(); i++){
                if(batchCurrSize == batchSize){
                    batchMap.put(batchNumber, singleBatch);
                    singleBatch = new List<Sobject>();            
                    batchNumber++;
                    batchCurrSize = 0;
                }
                singleBatch.add(recordsList[i]);
                batchCurrSize++;
            }
            if(!singleBatch.isEmpty()){
                batchMap.put(batchNumber, singleBatch);
            } 
        } else {
            //throw new CustomException('BatchSize cannot be more than 10k');
        }
        return batchMap;
    }
   
    //Handler for each queueable job completion
    public static void handleSingleBatchCompletion(Id parentId, Integer successCount){
        
    }

    //Handler when the entire job completes/for the last queueable job
    public static void handleAllJobsCompletion(Id parentId, Integer successCount,List<Account> accList){
        if(!test.isRunningTest()){
         system.enqueueJob(new QueableForSendEmail(accList,'SEND',1));
        }
   }
}