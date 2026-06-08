public class SendSmsOnextel {
    @Future(callout=true)
    
    public static void sendSMS(Set<Id> csIds, String mtType) {
        
        // Fetch Cases
        List<Case> cList = [
            SELECT Id, CaseNumber, Displayed_Account_number__c,
            Name_of_Consumer__c,
            Name_of_Consumer__r.Phone,
            Name_of_Consumer__r.Phone_2__c
            FROM Case
            WHERE Id IN :csIds
        ];
        
        // Fetch metadata template
        Onex__mdt smsTemplate;
        try {
            smsTemplate = [
                SELECT Label, body__c, entityid__c, from__c, Method__c,
                key__c, templateid__c
                FROM Onex__mdt
                WHERE DeveloperName = :mtType
                LIMIT 1
            ];
        } catch (Exception e) {
            System.debug('Metadata not found for: ' + mtType);
            return;
        }
        
        List<API_LOG__c> apList = new List<API_LOG__c>();
        
        for (Case cs : cList) {
            try {
                // Prepare message body
                String message = smsTemplate.body__c;
                message = message.replace('var1', cs.CaseNumber != null ? cs.CaseNumber : '');
                message = message.replace('var2', cs.Displayed_Account_number__c != null ? cs.Displayed_Account_number__c : '');
                
                // Prepare recipient phone number
                String phone = null;
                if (cs.Name_of_Consumer__r != null) {
                    if (cs.Name_of_Consumer__r.Phone != null) {
                        phone = '91' + cs.Name_of_Consumer__r.Phone;
                    } else if (cs.Name_of_Consumer__r.Phone_2__c != null) {
                        phone = '91' + cs.Name_of_Consumer__r.Phone_2__c;
                    }
                }
                
                if (phone == null) {
                    System.debug('No phone number found for Case: ' + cs.Id);
                    continue; // Skip this case
                }
                
                // Construct URL parameters
                String encodedBody = EncodingUtil.urlEncode(message, 'UTF-8');
                String endpointUrl = 'https://api.onex-aura.com/api/sms'
                    + '?from=' + smsTemplate.from__c
                    + '&body=' + encodedBody
                    + '&templateid=' + smsTemplate.templateid__c
                    + '&key=' + smsTemplate.key__c
                    + '&to=' + phone
                    + '&entityid=' + smsTemplate.entityid__c;
                
                // Prepare HTTP request
                HttpRequest httpReq = new HttpRequest();
                httpReq.setEndpoint(endpointUrl);
                httpReq.setMethod('GET');
                httpReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                httpReq.setTimeout(120000);
                
                // Send request
                Http http = new Http();
                HttpResponse httpRes = http.send(httpReq);
                
                // Parse response
                Map<String, Object> resMap = (Map<String, Object>) JSON.deserializeUntyped(httpRes.getBody());
                system.debug('resMap-->'+resMap);
                Map<String, Object> responseData = (Map<String, Object>) resMap.get('response');
                
                // Log API call
                API_LOG__c apiLog = new API_LOG__c();
                apiLog.Request_Source__c = 'SendSmsOnextel for ' + mtType + ' Event';
                apiLog.Request__c = endpointUrl;
                apiLog.Log_Status__c ='Success';
                apiLog.Response__c = httpRes.getBody();
                //apiLog.Gupshup_response_Id__c = (String) responseData.get('id');
                //apiLog.Gupshup_Status__c = (String) responseData.get('status');
                apiLog.Case__c = cs.Id;
                
                apList.add(apiLog);
            } catch (Exception e) {
                API_LOG__c errorLog = new API_LOG__c();
                errorLog.Request_Source__c = 'SendSmsOnextel for ' + mtType + ' Event';
                errorLog.Exception_Description__c = e.getMessage();
                errorLog.Case__c = cs.Id;
                apList.add(errorLog);
                //System.debug('Error processing case : ' + e.getMessage());
            }
        }
        
        // Insert logs
        if (!apList.isEmpty()) {
            insert apList;
        }
    }
    
    public static void sendSMSBatch(Set<Id> csIds,String mtType){
        system.debug('csIds-->'+csIds);
        List<Case> cList = [
            SELECT Id, CaseNumber, Displayed_Account_number__c,
            Name_of_Consumer__c,
            Name_of_Consumer__r.Phone,
            Name_of_Consumer__r.Phone_2__c
            FROM Case
            WHERE Id IN :csIds
        ];
        
        // Fetch metadata template
        Onex__mdt smsTemplate;
        try {
            smsTemplate = [
                SELECT Label, body__c, entityid__c, from__c, Method__c,
                key__c, templateid__c
                FROM Onex__mdt
                WHERE DeveloperName = :mtType
                LIMIT 1
            ];
        } catch (Exception e) {
            System.debug('Metadata not found for: ' + mtType);
            return;
        }
        
        List<API_LOG__c> apList = new List<API_LOG__c>();
        
        for (Case cs : cList) {
            try {
                // Prepare message body
                String message = smsTemplate.body__c;
                message = message.replace('var1', cs.CaseNumber != null ? cs.CaseNumber : '');
                message = message.replace('var2', cs.Displayed_Account_number__c != null ? cs.Displayed_Account_number__c : '');
                
                // Prepare recipient phone number
                String phone = null;
                if (cs.Name_of_Consumer__r != null) {
                    if (cs.Name_of_Consumer__r.Phone != null) {
                        phone = '91' + cs.Name_of_Consumer__r.Phone;
                    } else if (cs.Name_of_Consumer__r.Phone_2__c != null) {
                        phone = '91' + cs.Name_of_Consumer__r.Phone_2__c;
                    }
                }
                
                if (phone == null) {
                    System.debug('No phone number found for Case: ' + cs.Id);
                    continue; // Skip this case
                }
                
                // Construct URL parameters
                String encodedBody = EncodingUtil.urlEncode(message, 'UTF-8');
                String endpointUrl = system.label.Onextel
                    + '?from=' + smsTemplate.from__c
                    + '&body=' + encodedBody
                    + '&templateid=' + smsTemplate.templateid__c
                    + '&key=' + smsTemplate.key__c
                    + '&to=' + phone
                    + '&entityid=' + smsTemplate.entityid__c;
                
                // Prepare HTTP request
                HttpRequest httpReq = new HttpRequest();
                httpReq.setEndpoint(endpointUrl);
                httpReq.setMethod('GET');
                httpReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                httpReq.setTimeout(120000);
                
                // Send request
                Http http = new Http();
                HttpResponse httpRes = http.send(httpReq);
                
                // Parse response
                Map<String, Object> resMap = (Map<String, Object>) JSON.deserializeUntyped(httpRes.getBody());
                system.debug('resMap-->'+resMap);
                Map<String, Object> responseData = (Map<String, Object>) resMap.get('response');
                
                // Log API call
                API_LOG__c apiLog = new API_LOG__c();
                apiLog.Request_Source__c = 'SendSmsOnextel for ' + mtType + ' Event';
                apiLog.Request__c = endpointUrl;
                apiLog.Log_Status__c ='Success';
                apiLog.Response__c = httpRes.getBody();
                apiLog.Case__c = cs.Id;
                
                apList.add(apiLog);
            } catch (Exception e) {
                API_LOG__c errorLog = new API_LOG__c();
                errorLog.Request_Source__c = 'SendSmsOnextel for ' + mtType + ' Event';
                errorLog.Exception_Description__c = e.getMessage();
                errorLog.Case__c = cs.Id;
                apList.add(errorLog);
            }
        }
        
        // Insert logs
        if (apList.size() > 0) {
            insert apList;
        } 
    }
}