public without sharing class ChildCaseDataTableController {

    @AuraEnabled(cacheable=true)
    public static List<Compensation_Child_Cases__c> getChildCasesByParent(Id parentCaseId) {

        if (parentCaseId == null) {
            throw new AuraHandledException('Invalid Case Id');
        }

        return [
            SELECT Id,
                   Consumer_Name__c,
                   Consumer_Email_ID__c,
                   Case_Number__c,
                   Displayed_Account_number__c,
                   Sub_Type_Name__c,
                   Sub_Type_1_Name__c,
                   Account_Name__c,
                   Dispute_Received_Date__c,
                   Resolve_Date__c,
                   Status__c,
                   Delayed_No_of_Days__c,
                   Liable_Amount__c,
                   Experian_Liability_Amt__c
            FROM Compensation_Child_Cases__c
            WHERE Parent_Case__c = :parentCaseId
        ];
    }


    @AuraEnabled
    public static void saveCompensationDetails(
        Id recordId,
        Boolean isOptIn,
        String accountHolderName,
        String bankName,
        String accountNumber,
        String ifscCode
    ) {

       if (recordId == null) {
        throw new AuraHandledException('Invalid Case Id');
    }

    List<Automation_Logs__c> logList = new List<Automation_Logs__c>();

    // FETCH CHILD RECORDS
    List<Compensation_Child_Cases__c> childCases = [
        SELECT Id,
               Account_Number__c,
               Bank_Name__c,
               IFSC_Code__c,
               Consumer_Name_As_per_Bank_Account__c,
               Compensation_Opted__c,
               Compensation_Response_Submitted__c
        FROM Compensation_Child_Cases__c
        WHERE Parent_Case__c = :recordId
    ];

        if (childCases.isEmpty()) {
            throw new AuraHandledException('No child records found');
        }

        String optedValue = isOptIn ? 'Yes' : 'No';

        List<Compensation_Child_Cases__c> toUpdate = new List<Compensation_Child_Cases__c>();

        // UPDATE CHILD RECORDS
        for (Compensation_Child_Cases__c child : childCases) {

            if (child.Compensation_Response_Submitted__c) {
                continue; // skip already submitted
            }

            if (isOptIn) {
                child.Account_Number__c = accountNumber;
                child.Bank_Name__c = bankName;
                child.IFSC_Code__c = ifscCode;
                child.Consumer_Name_As_per_Bank_Account__c = accountHolderName;
            }

            child.Compensation_Opted__c = optedValue;
            child.Compensation_Response_Submitted__c = true;

            if (Test.isRunningTest() && accountNumber == 'FAIL_TEST') {
                child.addError('Forced failure for testing');
            }

            toUpdate.add(child);
        }

        if (toUpdate.isEmpty()) {
            throw new AuraHandledException('Response has already been submitted for this case');
        }

        Database.SaveResult[] results = Database.update(toUpdate, false);
        for (Integer i = 0; i < results.size(); i++) {
            if (!results[i].isSuccess()) {
                Compensation_Child_Cases__c childRec = toUpdate[i];
                for (Database.Error err : results[i].getErrors()) {
                    Automation_Logs__c log = new Automation_Logs__c();
                    log.Batch_Class_Name__c = 'CompensationForm';
                    log.Automation_Log_Description__c =
                        'Step: Child Update | CaseId: ' + recordId +
                        ' | ChildId: ' + childRec.Id;
                    log.Case__c = recordId;
                    log.Error_Message__c =
                        'Message: ' + err.getMessage() +
                        ' | StatusCode: ' + err.getStatusCode();
                    logList.add(log);
                }
            }
        }

        // Insert logs safely
        if (!logList.isEmpty()) {
            try {
                insert logList;
            } catch (Exception e) {
                System.debug('Automation Log Insert Failed: ' + e.getMessage());
            }
        }
    }

    @AuraEnabled(cacheable=true)
    public static Boolean isResponseAlreadySubmitted(Id recordId) {
        List<Compensation_Child_Cases__c> records = [
            SELECT Compensation_Response_Submitted__c
            FROM Compensation_Child_Cases__c
            WHERE Parent_Case__c = :recordId
            LIMIT 1
        ];

        return (!records.isEmpty() && records[0].Compensation_Response_Submitted__c);
    }


    @AuraEnabled(cacheable=true)
    public static String getCaseNumber(Id recordId) {
        return [SELECT CaseNumber FROM Case WHERE Id = :recordId LIMIT 1].CaseNumber;
    }
}