public class CaseMasterTriggerHandler {
    
    public static void updateDemogMatching(List<Case> caseList) {
        
        if (caseList == null || caseList.isEmpty()) {
            return;
        }
        
        Set<Id> caseIds = new Set<Id>();
        
        // 1️⃣ Filter relevant cases
        for (Case cs : caseList) {
            if (cs.Sub_Type_Name__c == 'Demographic Details' && cs.Sub_Type_1_Name__c == 'Incorrect Name') {
                caseIds.add(cs.Id);
            }
        }
        
        if (caseIds.isEmpty()) {
            return;
        }
        
        // 2️⃣ Fetch Sub Type once
        Sub_Type1__c incorrectSubType1 = [
            SELECT Id
            FROM Sub_Type1__c
            WHERE Name = 'Matching - Incorrect Name'
            AND Case_Type__c = 'Complaint Dispute Consumer' AND Sub_Type__r.Name = 'Demographic Details' LIMIT 1
        ];
        
        // 3️⃣ Fetch cases eligible for update
        List<Case> casesToUpdate = new List<Case>();
        
        for (Case cs : [
            SELECT Id
            FROM Case
            WHERE Id IN :caseIds AND Account.Member_Status__c != 'Credit Institution - License Cancelled Entity'
        ]) {
            cs.Sub_Type_1_Lookup__c = incorrectSubType1.Id;
            casesToUpdate.add(cs);
        }
        
        // 4️⃣ Single DML
        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
}