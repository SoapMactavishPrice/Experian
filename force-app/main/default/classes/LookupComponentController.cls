public with sharing class LookupComponentController {
    @AuraEnabled(cacheable=true)  
    public static List<sobject> findRecords(String searchKey, String objectName, String recdataid, string returnFields, List<String> queryFields, 
                                            String displayFields, String filter, String sortColumn, String maxResults ,string masterId) {
        String a = '';
        if (returnFields != null && returnFields.trim() != '') {
            a = returnFields;
        }
        if (displayFields != null && displayFields.trim() != '') {
            a = (a == ''? displayFields : a + ','+ displayFields) ;
        }
        Set<String> b = new Set<String>();
        String col = '';
        if(a.trim() != ''){
            for(String t: a.split(',')){
                b.add(t.trim());
            }
            for(String t: b){
                col = col + ',' + t;
            }
        }

        /* if (returnFields != null && returnFields != '') {
            returnFields = ',' + returnFields;
        } else {
            returnFields = '';
        } */

        string searchText = '\'' + String.escapeSingleQuotes(searchKey) + '%\'';

        String vQuery =  'SELECT Id, CaseNumber '+ col + ' FROM ' +objectName+ ' WHERE ';

        if (queryFields == null || queryFields.isEmpty()) {
            vQuery += ' CaseNumber LIKE ' + searchText;
        } else {
            string likeField = '';
            for(string field : queryFields) {
                likeField += ' OR ' + field + ' LIKE ' + searchText;
            }
            vQuery += ' (' + likeField.removeStart(' OR ') + ') ';
        }

        if (filter != null && filter != '') {
            vQuery += ' AND (' + filter + ')';
        }

        if (sortColumn != null && sortColumn != '') {
            vQuery += ' ORDER BY ' + sortColumn;
        }

        if (maxResults == null || maxResults == '') {
            maxResults = '10';
        }

        vQuery += ' LIMIT ' + maxResults;

        System.debug(vQuery);

        return Database.query(vQuery);
    }

    @AuraEnabled
    public static sObject fetchDefaultRecord(string recordId , string sObjectApiName, string returnFields) {
        string sRecId = recordId;

        if (returnFields != null && returnFields != '') {
            returnFields = ',' + returnFields;
        } else {
            returnFields = '';
        }

        string sQuery = 'Select Id,CaseNumber '+ returnFields + ' From ' + sObjectApiName + ' Where Id = : sRecId LIMIT 1';
        for (sObject obj: database.query(sQuery)) {
            return obj;
        }
        return null;
    }
}