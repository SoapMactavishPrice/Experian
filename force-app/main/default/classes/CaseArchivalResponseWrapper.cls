public class CaseArchivalResponseWrapper {
    public class ArchivalJSON {
        @AuraEnabled public String Id;
        @AuraEnabled public String name;
        @AuraEnabled public String accountNumber;
        @AuraEnabled public String accountName;
        @AuraEnabled public String bmid;
        @AuraEnabled public String caseCategory;
        @AuraEnabled public String status;
    }

    // Parse only records section
    public static List<ArchivalJSON> fromJson(String jsonString) {
        Map<String, Object> rawMap = (Map<String, Object>) JSON.deserializeUntyped(jsonString);
        List<Object> recordList = (List<Object>) rawMap.get('records');
        List<ArchivalJSON> parsedRecords = new List<ArchivalJSON>();

        for (Object recObj : recordList) {
            Map<String, Object> recMap = (Map<String, Object>) recObj;
            ArchivalJSON rec = new ArchivalJSON();

            rec.Id = (String) recMap.get('Id');
            rec.name = (String) recMap.get('Name');
            rec.accountNumber = (String) recMap.get('Account__c');
            rec.bmid = (String) recMap.get('BMID__c');
            rec.caseCategory = (String) recMap.get('Case_Category__c');
            rec.status = (String) recMap.get('Status__c');

            if (recMap.containsKey('Account__r')) {
                Map<String, Object> accMap = (Map<String, Object>) recMap.get('Account__r');
                rec.accountName = (String) accMap.get('Name');
            }

            parsedRecords.add(rec);
        }

        return parsedRecords;
    }
}