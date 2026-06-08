global class CaseGroupingBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    
    // =========================
    // START
    // =========================
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id, AccountId, Name_of_Consumer__c, Status, Consumer_Dispute_Status__c, Forward_to_bank__c, 
            Displayed_Account_number__c, Displayed_Bank_Name__c, Forward_to_Bank_Date__c, Origin, 
            Displayed_Account_Type__c, Dis_Ern__c, OwnerId, Date_of_the_email_received__c, 
            Account_Date_Reported__c, Contact_Name__c
            FROM Case
            WHERE (CreatedDate = today)
            AND Dis_Ern__c != NULL
            AND Status = 'Open'
            AND SuppliedEmail = NULL
            AND Case_Identifier_Type__c = NULL
        ]);
    }
    
    // =========================
    // EXECUTE
    // =========================
    global void execute(Database.BatchableContext bc, List<Case> scope) {
        
        if (scope.isEmpty()) return;
        
        List<Automation_Logs__c> apiLogList = new List<Automation_Logs__c>();
        
        // =========================
        // STEP 1: GROUP BY Dis_Ern
        // =========================
        Map<String, List<Case>> disErnMap = new Map<String, List<Case>>();
        
        for (Case c : scope) {
            if (!disErnMap.containsKey(c.Dis_Ern__c)) {
                disErnMap.put(c.Dis_Ern__c, new List<Case>());
            }
            disErnMap.get(c.Dis_Ern__c).add(c);
        }
        
        // Filter invalid groups
        for (String key : new List<String>(disErnMap.keySet())) {
            Boolean valid = true;
            for (Case c : disErnMap.get(key)) {
                if (c.AccountId == null || c.Name_of_Consumer__c == null) {
                    valid = false;
                    break;
                }
            }
            if (!valid) {
                disErnMap.remove(key);
            }
        }
        
        if (disErnMap.isEmpty()) return;
        
        // =========================
        // STEP 2: GROUP BY ACCOUNT NUMBER
        // =========================
        Map<String, List<Case>> acctMap = new Map<String, List<Case>>();
        
        for (List<Case> cases : disErnMap.values()) {
            for (Case c : cases) {
                if (String.isNotBlank(c.Displayed_Account_number__c)) {
                    if (!acctMap.containsKey(c.Displayed_Account_number__c)) {
                        acctMap.put(c.Displayed_Account_number__c, new List<Case>());
                    }
                    acctMap.get(c.Displayed_Account_number__c).add(c);
                }
            }
        }
        
        if (acctMap.isEmpty()) return;
        
        // =========================
        // STEP 3: FETCH EXISTING PARENTS
        // =========================
        Map<String, Id> acctToParent = new Map<String, Id>();
        
        for (Case c : [
            SELECT Id, Displayed_Account_number__c
            FROM Case
            WHERE Case_Identifier_Type__c = 'Account Number'
            AND CreatedDate = TODAY
            AND Displayed_Account_number__c IN :acctMap.keySet()]) {
                acctToParent.put(c.Displayed_Account_number__c, c.Id);
            }
        
        // =========================
        // STEP 4: CREATE MISSING PARENTS
        // =========================
        List<Case> parentToInsert = new List<Case>();
        
        for (String acct : acctMap.keySet()) {
            if (!acctToParent.containsKey(acct)) {
                Case sample = acctMap.get(acct)[0];
                
                Case parent = new Case(
                    Status = 'Open',
                    Origin = sample.Origin,
                    Case_Identifier_Type__c = 'Account Number',
                    AccountId = sample.AccountId,
                    Name_of_Consumer__c = sample.Name_of_Consumer__c,
                    Displayed_Account_number__c = sample.Displayed_Account_number__c,
                    Displayed_Bank_Name__c = sample.Displayed_Bank_Name__c,
                    Displayed_Account_Type__c = sample.Displayed_Account_Type__c,
                    Dis_Ern__c = sample.Dis_Ern__c,
                    Account_Level_Status__c = 'Unassigned',
                    OwnerId = '00G2u000000pcYJ', //Consumer Support Queue
                    Date_of_the_email_received__c = sample.Date_of_the_email_received__c,
                    Account_Date_Reported__c = sample.Account_Date_Reported__c,
                    Forward_to_Bank_Date__c = sample.Forward_to_Bank_Date__c,
                    Contact_Name__c = sample.Contact_Name__c
                );
                
                parentToInsert.add(parent);
            }
        }
        
        // =========================
        // STEP 4.1: INSERT PARENTS WITH LOGGING
        // =========================
        if (!parentToInsert.isEmpty()) {
            
            Database.SaveResult[] parentResults = Database.insert(parentToInsert, false);
            
            for (Integer i = 0; i < parentResults.size(); i++) {
                
                Case parentRec = parentToInsert[i];
                
                if (parentResults[i].isSuccess()) {
                    
                    acctToParent.put(parentRec.Displayed_Account_number__c, parentResults[i].getId());
                    
                } else {
                    
                    for (Database.Error err : parentResults[i].getErrors()) {
                        
                        Automation_Logs__c log = new Automation_Logs__c();
                        log.Batch_Class_Name__c = 'CaseGroupingBatch';
                        log.Automation_Log_Description__c = 'Step: Parent Insert' + ' | Account Name: ' + parentRec.Displayed_Bank_Name__c
                            + ' | Account Numer: ' + parentRec.Displayed_Account_number__c + ' | ERN: ' + parentRec.Dis_Ern__c;
                        
                        if (parentRec.Id != null) { log.Case__c = parentRec.Id;
                                                  }
                        log.Error_Message__c =  'Message: ' + err.getMessage() + ' | StatusCode: ' + err.getStatusCode();
                        apiLogList.add(log);
                    }
                }
            }
        }
        
        // =========================
        // STEP 5: UPDATE CHILD CASES
        // =========================
        List<Case> childUpdates = new List<Case>();
        
        for (String acct : acctMap.keySet()) {
            
            Id parentId = acctToParent.get(acct);
            
            // skip if parent failed
            if (parentId == null) continue;
            
            for (Case c : acctMap.get(acct)) {
                c.Parent_Account_Number_Case__c = parentId;
                c.Case_Identifier_Type__c = 'Attribute';
                childUpdates.add(c);
            }
        }
        
        // =========================
        // STEP 5.1: UPDATE CHILDREN WITH LOGGING
        // =========================
        if (!childUpdates.isEmpty()) {
            
            Database.SaveResult[] childResults = Database.update(childUpdates, false);
            
            for (Integer i = 0; i < childResults.size(); i++) {
                
                if (!childResults[i].isSuccess()) {
                    
                    for (Database.Error err : childResults[i].getErrors()) {
                        
                        Automation_Logs__c log = new Automation_Logs__c();
                        log.Batch_Class_Name__c = 'CaseGroupingBatch';
                        log.Automation_Log_Description__c = 'Step: Child Update' + ' | Account Name: ' + childUpdates[i].Displayed_Bank_Name__c
                            + ' | Account Number: ' + childUpdates[i].Displayed_Account_number__c + ' | ERN: ' + childUpdates[i].Dis_Ern__c;
                        
                        log.Case__c = childUpdates[i].Id;
                        log.Error_Message__c = 'Message: ' + err.getMessage() +  ' | StatusCode: ' + err.getStatusCode();
                        apiLogList.add(log);
                    }
                }
            }
        }
        
        // =========================
        // FINAL: INSERT API LOGS
        // =========================
        if (!apiLogList.isEmpty()) {
            try { insert apiLogList;
                } catch (Exception e) {
                    System.debug('Automation Log Insert Failed: ' + e.getMessage());
                }
        }
    }
    
    global void finish(Database.BatchableContext bc) {}
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CaseGroupingBatch(), 2);
    }
}