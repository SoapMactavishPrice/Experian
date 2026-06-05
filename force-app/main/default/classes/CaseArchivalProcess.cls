public with sharing class CaseArchivalProcess {
    
    @AuraEnabled
    public static List<CaseArchivalResponseWrapper.ArchivalJSON>  getCaseArchivalRecords() {
        List<CaseArchivalWrapper> caseArchivalRecords = new List<CaseArchivalWrapper>();

        try{
            // Define the endpoint URL (e.g., to access a custom object data)
            String endpointUrl = 'callout:Internal_Org_Credential/services/data/v52.0/sobjects/Case_Archival__c';
           

            // Create the HTTP request
            HttpRequest req = new HttpRequest();
            // req.setEndpoint(endpointUrl); // API endpoint URL
            req.setEndpoint('callout:Internal_Org_Credential/services/data/v61.0/query?q=' + 
            EncodingUtil.urlEncode('SELECT Id,Name,Account__r.Name,Account__c,BMID__c,Case_Category__c,Status__c FROM Case_Archival__c ORDER BY CreatedDate DESC', 'UTF-8'));
            req.setMethod('GET'); // HTTP method (GET, POST, etc.)

            // Set the Authorization header automatically handled by Named Credential
            // req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId()); // Use session ID for internal calls

            // Send the HTTP request
            Http http = new Http();
            HttpResponse res = http.send(req);

            // Handle the response
            if (res.getStatusCode() == 200) {
                System.debug(res.getBody());

                List<CaseArchivalResponseWrapper.ArchivalJSON> caseList = CaseArchivalResponseWrapper.fromJson(res.getBody());

                return caseList;               

            } else {
                System.debug('Error: ' + res.getStatusCode() + ' ' + res.getBody());
            }
        }catch(Exception ex){
            System.debug('Exception-->'+ex);
        }
        


        // List<Case_Archival__c> caseArchivalList = [SELECT Id,Name,Account__r.Name,Account__c,BMID__c,Case_Category__c,Status__c FROM Case_Archival__c  ORDER BY CreatedDate DESC];
        
        // for (Case_Archival__c caseArchival : caseArchivalList) {
        //     CaseArchivalWrapper caseArchivalWrapper = new CaseArchivalWrapper();
        //     caseArchivalWrapper.bmid = caseArchival.BMID__c;
        //     caseArchivalWrapper.accountNumber = caseArchival.Account__c;
        //     caseArchivalWrapper.accountName = caseArchival.Account__r.Name;
        //     caseArchivalWrapper.caseCategory = caseArchival.Case_Category__c;
        //     caseArchivalWrapper.name = caseArchival.Name;
        //     caseArchivalWrapper.status = caseArchival.Status__c;
        //     caseArchivalRecords.add(caseArchivalWrapper);
        // }

        // if(caseArchivalRecords.size() > 0) {
        //     return caseArchivalRecords;
        // }
        return null;
    }

    @AuraEnabled
	public static AccountInfo getAccountDetailsByBMID(String bmid) {
		if (String.isBlank(bmid)) {
			return null;
		}

		try{
			String safeBmid = String.escapeSingleQuotes(bmid);
			String queryData = 'SELECT Id,Name FROM Account WHERE Bureau_Member_Id__c = ' + '\'' + safeBmid + '\'' + ' ORDER BY CreatedDate DESC LIMIT 1';

			HttpRequest req = new HttpRequest();
			req.setEndpoint('callout:Internal_Org_Credential/services/data/v61.0/query?q=' + EncodingUtil.urlEncode(queryData, 'UTF-8'));
			req.setMethod('GET');

			Http http = new Http();
			HttpResponse res = http.send(req);

			if (res.getStatusCode() == 200) {
				Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
				List<Object> records = (List<Object>) responseMap.get('records');
				if (records != null && !records.isEmpty()) {
					Map<String, Object> first = (Map<String, Object>) records[0];
					AccountInfo info = new AccountInfo();
					info.accountId = (String) first.get('Id');
					info.accountName = (String) first.get('Name');
					return info;
				}
			} else {
				System.debug('Error: ' + res.getStatusCode() + ' ' + res.getBody());
			}
		}catch(Exception ex){
			System.debug('Exception-->' + ex);
		}

		return null;
	}

    public class AccountInfo {
        @AuraEnabled public String accountId { get; set; }
        @AuraEnabled public String accountName { get; set; }
    }

    @AuraEnabled
    public static List<CaseArchivalResponseWrapper.ArchivalJSON>  getCaseArchivalRecordsFiltered(String bmid, String caseNumber) {
        List<CaseArchivalWrapper> caseArchivalRecords = new List<CaseArchivalWrapper>();

        try{
            // Define the endpoint URL (e.g., to access a custom object data)
            System.debug('bmid-->'+bmid);
            System.debug('caseNumber-->'+caseNumber);
            String endpointUrl = 'callout:Internal_Org_Credential/services/data/v52.0/sobjects/Case_Archival__c';
            String queryData = 'SELECT Id,Name,Account__r.Name,Account__c,BMID__c,Case_Category__c,Status__c FROM Case_Archival__c ';
            if((bmid != null && bmid != '') || (caseNumber != null && caseNumber != '')){
                queryData += ' WHERE ';
            }
            if(bmid != null && bmid != ''){
                queryData += 'BMID__c = \'' + bmid + '\'';
            }
            if(bmid != null && bmid != '' && caseNumber != null && caseNumber != ''){
                queryData += ' AND Name = \'' + caseNumber + '\'';
            }else if(caseNumber != null && caseNumber != ''){
                queryData += ' Name = \'' + caseNumber + '\'';
            }

            queryData += ' ORDER BY CreatedDate DESC';

            System.debug('queryData-->'+queryData);

            // Create the HTTP request
            HttpRequest req = new HttpRequest();
            // req.setEndpoint(endpointUrl); // API endpoint URL
            req.setEndpoint('callout:Internal_Org_Credential/services/data/v61.0/query?q=' + 
            
            EncodingUtil.urlEncode(queryData, 'UTF-8'));
            req.setMethod('GET'); // HTTP method (GET, POST, etc.)

            // Set the Authorization header automatically handled by Named Credential
            // req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId()); // Use session ID for internal calls

            // Send the HTTP request
            Http http = new Http();
            HttpResponse res = http.send(req);

            // Handle the response
            if (res.getStatusCode() == 200) {
                System.debug(res.getBody());

                List<CaseArchivalResponseWrapper.ArchivalJSON> caseList = CaseArchivalResponseWrapper.fromJson(res.getBody());

                return caseList;               

            } else {
                System.debug('Error: ' + res.getStatusCode() + ' ' + res.getBody());
            }
        }catch(Exception ex){
            System.debug('Exception-->'+ex);
        }
        


        // List<Case_Archival__c> caseArchivalList = [SELECT Id,Name,Account__r.Name,Account__c,BMID__c,Case_Category__c,Status__c FROM Case_Archival__c  ORDER BY CreatedDate DESC];
        
        // for (Case_Archival__c caseArchival : caseArchivalList) {
        //     CaseArchivalWrapper caseArchivalWrapper = new CaseArchivalWrapper();
        //     caseArchivalWrapper.bmid = caseArchival.BMID__c;
        //     caseArchivalWrapper.accountNumber = caseArchival.Account__c;
        //     caseArchivalWrapper.accountName = caseArchival.Account__r.Name;
        //     caseArchivalWrapper.caseCategory = caseArchival.Case_Category__c;
        //     caseArchivalWrapper.name = caseArchival.Name;
        //     caseArchivalWrapper.status = caseArchival.Status__c;
        //     caseArchivalRecords.add(caseArchivalWrapper);
        // }

        // if(caseArchivalRecords.size() > 0) {
        //     return caseArchivalRecords;
        // }
        return null;
    }

   

    public class CaseArchivalWrapper {
        @AuraEnabled
        public String bmid {get; set;}
        @AuraEnabled
        public String accountNumber {get; set;}
        @AuraEnabled
        public String caseNumber {get; set;}
        @AuraEnabled
        public String accountName {get; set;}
        @AuraEnabled
        public String caseDetails {get; set;}
        @AuraEnabled
        public String status {get; set;}
        @AuraEnabled
        public String caseCategory {get; set;}
        @AuraEnabled
        public String name {get; set;}
    }
}