public with sharing class MembershipDocumentController {

    @AuraEnabled(cacheable=true)
    public static List<Membership_Document__c> getMembershipDocuments(Id leadId) {
        try {
            return [
                SELECT
                    Id,
                    Name,
                    Document_Name__c,
                    Executive_Document_Status__c,
                    Executive_Comments__c,
                    TL_Document_Status__c,
                    TL_Comments__c,
                    Admin_Document_Status__c,
                    Admin_Comments__c,
                    Is_Exception__c,
                    Exception_Valid_Till__c,
                    Exception_Notes__c
                FROM Membership_Document__c
                WHERE Lead__c = :leadId
                ORDER BY CreatedDate ASC
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching membership documents: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String, List<String>> getPicklistValues() {
        try {
            Map<String, List<String>> picklistMap = new Map<String, List<String>>();
            
            picklistMap.put('Executive', getValuesForField(Membership_Document__c.Executive_Document_Status__c.getDescribe()));
            picklistMap.put('TL', getValuesForField(Membership_Document__c.TL_Document_Status__c.getDescribe()));
            picklistMap.put('Admin', getValuesForField(Membership_Document__c.Admin_Document_Status__c.getDescribe()));
            
            return picklistMap;
        } catch (Exception e) {
            throw new AuraHandledException('Error fetching picklist values: ' + e.getMessage());
        }
    }

    private static List<String> getValuesForField(Schema.DescribeFieldResult fieldResult) {
        List<String> options = new List<String>();
        for(Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
            if(f.isActive()) {
                options.add(f.getValue());
            }
        }
        return options;
    }

    @AuraEnabled
    public static void saveMembershipDocuments(List<Membership_Document__c> docs) {
        try {
            if (docs != null && !docs.isEmpty()) {
                // Strip fields that are not updatable by the current user to satisfy security requirements
                SObjectAccessDecision decision = Security.stripInaccessible(AccessType.UPDATABLE, docs);
                update decision.getRecords();
            }
        } catch (Exception e) {
            throw new AuraHandledException('Error saving membership documents: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Membership_Document__c> initializeDocuments(Id leadId) {
        try {
            if (String.isNotBlank(leadId)) {
                List<Lead> leads = [SELECT Id FROM Lead WHERE Id = :leadId LIMIT 1];
                if (!leads.isEmpty()) {
                    // Check if they already exist
                    Integer existingCount = [SELECT COUNT() FROM Membership_Document__c WHERE Lead__c = :leadId];
                    if (existingCount == 0) {
                        LeadTriggerHandler.createMembershipDocuments(leads);
                    }
                    return getMembershipDocuments(leadId);
                }
            }
            return new List<Membership_Document__c>();
        } catch (Exception e) {
            throw new AuraHandledException('Error initializing documents: ' + e.getMessage());
        }
    }
}
