public with sharing class SingleEmailMessageLimitController {

    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getEmailLimits() {
        System.OrgLimit lmt = OrgLimits.getMap().get('SingleEmail');
        Map<String, Integer> result = new Map<String, Integer>();
        result.put('used', lmt.getValue());
        result.put('max', lmt.getLimit());
        return result;
    }

}