public class DisputeLifecycleService {
    
    public static void handleInsert(List<Case> newCases){
        createLifecycle(newCases, null);
    }
    
    public static void handleUpdate(List<Case> newCases, Map<Id, Case> oldMap){
        createLifecycle(newCases, oldMap);
    }
    
    private static void createLifecycle(List<Case> newCases, Map<Id, Case> oldMap){
        
        Set<String> requiredTypes = new Set<String>();
        
        List<Dispute_Lifecycle__c> lifecycleToInsert = new List<Dispute_Lifecycle__c>();
        
        Map<Id, Set<String>> existingLifecycle = fetchExistingLifecycle(newCases);
        
        for(Case cs : newCases){
            
              //FILTER ADDED HERE
            if(cs.Origin != 'Portal') continue;
            
            Case oldCs = oldMap != null ? oldMap.get(cs.Id) : null;
            
            // CASE CREATED
            if(oldMap == null){
                addLifecycle(cs, 'Case Created', lifecycleToInsert, existingLifecycle);
            }
            
            // DISPUTE RECEIVED
            if(cs.Date_of_the_email_received__c != null && (oldCs == null || oldCs.Date_of_the_email_received__c == null)){
                   addLifecycle(cs, 'Dispute Received', lifecycleToInsert, existingLifecycle);
               }
            
            // DISPUTE RAISED
            if(cs.Dispute_Raised_Date__c != null && (oldCs == null || oldCs.Dispute_Raised_Date__c == null)){
                   addLifecycle(cs, 'Dispute Raised', lifecycleToInsert, existingLifecycle);
               }
            
            // ACKNOWLEDGEMENT
            if(cs.Consumer_Dispute_Status__c == 'Acknowledgement sent to Consumer' &&
               (oldCs == null || oldCs.Consumer_Dispute_Status__c != cs.Consumer_Dispute_Status__c)){
                   addLifecycle(cs, 'Acknowledgement sent to Consumer', lifecycleToInsert, existingLifecycle);
               }
            
            // REFERRED TO IO
            if(cs.First_Time_Referred_To_IO__c == TRUE && (oldCs == null || oldCs.First_Time_Referred_To_IO__c != TRUE)){
                   addLifecycle(cs, 'Referred To IO', lifecycleToInsert, existingLifecycle);
               }
            
            // IO SEEKING MEMBER
            if(cs.IO_Status__c == 'Seeking Further Information - Member' && (oldCs == null || oldCs.IO_Status__c != cs.IO_Status__c)){
                   addLifecycle(cs, 'IO Seeking Further Information - Member', lifecycleToInsert, existingLifecycle);
               }
            
            // IO SEEKING CONSUMER
            if(cs.IO_Status__c == 'Seeking Further Information - Consumer' &&  (oldCs == null || oldCs.IO_Status__c != cs.IO_Status__c)){
                   addLifecycle(cs, 'IO Seeking Further Information - Consumer', lifecycleToInsert, existingLifecycle);
               }
            
            // RESOLVED FAVOUR
            if(cs.Consumer_Dispute_Status__c == 'Resolved in favour of the Consumer' &&
               (oldCs == null || oldCs.Consumer_Dispute_Status__c != cs.Consumer_Dispute_Status__c)){
                   addLifecycle(cs, 'Resolved in favour of the Consumer', lifecycleToInsert, existingLifecycle);
               }
            
            // RESOLVED NOT FAVOUR
            if(cs.Consumer_Dispute_Status__c == 'Resolved not in favour of the Consumer' &&
               (oldCs == null || oldCs.Consumer_Dispute_Status__c != cs.Consumer_Dispute_Status__c)){
                   addLifecycle(cs, 'Resolved not in favour of the Consumer', lifecycleToInsert, existingLifecycle);
               }
            
            // FINAL RESOLVED
            if(cs.Status == 'Resolved' &&
               (oldCs == null || oldCs.Status != cs.Status)){
                   addLifecycle(cs, 'Resolved', lifecycleToInsert, existingLifecycle);
               }
        }
        
        // if(!lifecycleToInsert.isEmpty()){
        //     insert lifecycleToInsert;
        // }

          try{
            
            if(!lifecycleToInsert.isEmpty()){
                insert lifecycleToInsert;
            }
            
        } catch(Exception err){
            
            List<Automation_Logs__c> apiLogList = new List<Automation_Logs__c>();
            
            for(Dispute_Lifecycle__c dl : lifecycleToInsert){
                
                apiLogList.add(new Automation_Logs__c(
                    Batch_Class_Name__c = 'OneXPCaseTrigger',
                    Automation_Log_Description__c = 'DisputeLifecycleService - Step: Dispute Lifecycle Insert',
                    Case__c = dl.Case__c,
                    Error_Message__c = err.getMessage()
                ));
            }
            
            if(!apiLogList.isEmpty()){
                insert apiLogList;
            }
        }
    }
    
    private static Map<Id, Set<String>> fetchExistingLifecycle(List<Case> cases){
        
        Map<Id, Set<String>> mapData = new Map<Id, Set<String>>();
        
        for(Dispute_Lifecycle__c dl :
            [SELECT Case__c, Type__c FROM Dispute_Lifecycle__c
             WHERE Case__c IN :cases]){
                 
                 if(!mapData.containsKey(dl.Case__c)){
                     mapData.put(dl.Case__c, new Set<String>());
                 }
                 mapData.get(dl.Case__c).add(dl.Type__c);
             }
        
        return mapData;
    }
    
    private static void addLifecycle(
        Case cs,
        String typeName,
        List<Dispute_Lifecycle__c> lifecycleToInsert,
        Map<Id, Set<String>> existingLifecycle){
            
            if(existingLifecycle.containsKey(cs.Id) &&
               existingLifecycle.get(cs.Id).contains(typeName)){
                   return;
               }
            
            lifecycleToInsert.add(new Dispute_Lifecycle__c(
                Case__c = cs.Id,
                Type__c = typeName,
                Actioned_By_Type__c = 'User',
                Actioned_By_User__c = UserInfo.getUserId(),
                Actioned_Date__c = Date.today()
            ));
        }
}