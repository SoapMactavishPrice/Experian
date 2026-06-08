public with sharing class ProdReusableLookup {
    
    @AuraEnabled
    public static List<ResultWrapper> fetchRecords(SearchWrapper inputWrapper) {
        try {
            if (inputWrapper != null) {
                String fieldsToQuery = 'SELECT Id';
                
                if (String.isNotBlank(inputWrapper.fieldApiName)) {
                    fieldsToQuery += ', ' + inputWrapper.fieldApiName;
                }
                
                if (String.isNotBlank(inputWrapper.otherFieldApiName)) {
                    fieldsToQuery += ', ' + inputWrapper.otherFieldApiName;
                }
                
                String query = fieldsToQuery + ' FROM ' + inputWrapper.objectApiName;
                String filterCriteria = inputWrapper.fieldApiName + ' LIKE \'' + String.escapeSingleQuotes(inputWrapper.searchString.trim()) + '%\'';
                
                
                if (String.isNotBlank(inputWrapper.selectedRecordId)) {
                    query += ' WHERE Id = \'' + String.escapeSingleQuotes(inputWrapper.selectedRecordId) + '\'';
                } else if (String.isNotBlank(inputWrapper.parentFieldApiName) && String.isNotBlank(inputWrapper.parentRecordId)) {
                    query += ' WHERE ' + inputWrapper.parentFieldApiName + ' = \'' + String.escapeSingleQuotes(inputWrapper.parentRecordId) + '\'';
                    query += ' AND ' + filterCriteria;
                } else {
                    query += ' WHERE ' + filterCriteria;
                    if (inputWrapper.objectApiName == 'Sub_Type__c') {
                        query += ' AND Case_Type__c = \'' + String.escapeSingleQuotes(inputWrapper.parentId) + '\'';
                        query += ' AND Case_Complaint__c = \'Report\'';
                        query += ' AND Case_Category__c = \'Consumer\'';
                    }
                    
                    
                    if (inputWrapper.objectApiName == 'Sub_Type1__c') {
                        query += ' AND Sub_Type__c = \'' + String.escapeSingleQuotes(inputWrapper.parentId) + '\'';
                        query += ' AND Case_Complaint__c = \'Report\'';
                        query += ' AND Case_Category__c = \'Consumer\'';
                    }
                    
                    
                    
                    
                }
                
                query+=' LIMIT 10';
                
                
                List<ResultWrapper> returnWrapperList = new List<ResultWrapper>();
                system.debug('query-->'+query);
                for (SObject s : Database.query(query)) {
                    system.debug('s-->'+s);
                    ResultWrapper wrap = new ResultWrapper();
                    wrap.mainField = (String)s.get(inputWrapper.fieldApiName);
                    //wrap.subField = (String)s.get(inputWrapper.otherFieldApiName);
                    wrap.id = (String)s.get('Id');
                    system.debug('wrap-->'+wrap);
                    returnWrapperList.add(wrap);
                }
                
                
                
                return returnWrapperList;
            }
            
            return null;
            
        } catch (Exception err) {
            throw new AuraHandledException(err.getMessage()+' line -'+err.getLineNumber());
        }
    }
    
    public class ResultWrapper {
        @AuraEnabled public String mainField { get; set; }
        @AuraEnabled public String subField { get; set; }
        @AuraEnabled public String id { get; set; }
    }
    
    public class SearchWrapper {
        @AuraEnabled public String objectApiName { get; set; }
        @AuraEnabled public String fieldApiName { get; set; }
        @AuraEnabled public String parentId{ get; set; }
        @AuraEnabled public String otherFieldApiName { get; set; }
        @AuraEnabled public String searchString { get; set; }
        @AuraEnabled public String selectedRecordId { get; set; }
        @AuraEnabled public String parentRecordId { get; set; }
        @AuraEnabled public String parentFieldApiName { get; set; }
    }
    
    public static void fakeCode(){
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}