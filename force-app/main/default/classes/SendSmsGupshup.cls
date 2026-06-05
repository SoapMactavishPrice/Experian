public class SendSmsGupshup {
    
    @Future(callout=true)
    public static void sendSMS(Set<Id> csIds,String mtType){
        
        List<Case> cList=[SELECT id,CaseNumber,Displayed_Account_number__c,Name_of_Consumer__c,Name_of_Consumer__r.Phone,Name_of_Consumer__r.Phone_2__c
                          FROM Case
                          WHERE Id IN:csIds];
        
        Gupshup__mdt gsmdt=[Select Id,label,auth_scheme__c,DeveloperName,format__c,method__c,msg__c,msg_type__c,password__c,userid__c,v__c 
                            FROM Gupshup__mdt 
                            WHERE DeveloperName=:mtType] ;  
        
        String Message =gsmdt.msg__c;
        List<API_LOG__c> apList=new List<API_LOG__c>();
        
        for(Case cs:cList){
            
            Message=Message.replace('var1', cs.CaseNumber);
            Message=Message.replace('var2', cs.Displayed_Account_number__c);
            API_LOG__c apiLog=new API_LOG__c();
            apiLog.Request_Source__c='SendSmsGupshup for '+ mtType+' Event';
            String parameter = '';  
            parameter += 'method='+gsmdt.method__c;
            if(cs.Name_of_Consumer__c!=null){
                if(cs.Name_of_Consumer__r.Phone !=null){
                    parameter += '&send_to=' + '91'+cs.Name_of_Consumer__r.Phone;
                }else if(cs.Name_of_Consumer__r.Phone_2__c !=null){
                    parameter += '&send_to=' + '91'+cs.Name_of_Consumer__r.Phone_2__c;
                }
            }
            
            parameter += '&msg=' +Message; 
            parameter += '&msg_type=' + gsmdt.msg_type__c;
            parameter += '&userid=' + gsmdt.userid__c;
            parameter += '&auth_scheme=' + gsmdt.auth_scheme__c;
            parameter += '&password=' + gsmdt.password__c;
            parameter += '&v=' + gsmdt.v__c;   
            parameter += '&format=' + gsmdt.format__c;
            
            try {
                HttpRequest httpReq = new HttpRequest();
                httpReq.setMethod('GET');
                httpReq.setEndpoint(Label.GupshupSMSEndpoint);
                httpReq.setHeader('Content-Type','application/x-www-form-urlencoded');
                httpReq.setTimeout(120000);
                httpReq.setBody(parameter);
                
                System.debug('body '+parameter);
                apiLog.Request__c = parameter;
                
                Http h = new Http();
                HttpResponse httpRes = h.send(httpReq);
                System.debug('response '+httpRes.getBody());
                Map<String,Object> response = (Map<String,Object>) JSON.deserializeUntyped(httpRes.getBody());
                Object responseBody =(Object)response.get('response');
                
                Map<String,Object> response1 = (Map<String,Object>) responseBody;
                apiLog.Gupshup_response_Id__c=(String)response1.get('id');
                apiLog.Gupshup_Status__c=(String)response1.get('status');
                
                apiLog.Response__c = httpRes.getBody();
                apiLog.Case__c=cs.Id;
                
            }
            catch(Exception e){
                System.debug('== >'+e.getMessage());
                apiLog.Exception_Description__c = e.getMessage();
            }
            apList.add(apiLog);  
        }
        //UPDATE cList;
        Insert apList;  
    }
    
    public static void sendSMSBatch(Set<Id> csIds,String mtType){
        
        List<Case> cList=[SELECT id,CaseNumber,Displayed_Account_number__c,Name_of_Consumer__c,Name_of_Consumer__r.Phone,Name_of_Consumer__r.Phone_2__c
                          FROM Case
                          WHERE Id IN:csIds];
        
        Gupshup__mdt gsmdt=[Select Id,label,auth_scheme__c,DeveloperName,format__c,method__c,msg__c,msg_type__c,password__c,userid__c,v__c 
                            FROM Gupshup__mdt 
                            WHERE DeveloperName=:mtType] ;  
        
        String Message =gsmdt.msg__c;
        List<API_LOG__c> apList=new List<API_LOG__c>();
        
        for(Case cs:cList){
            
            Message=Message.replace('var1', cs.CaseNumber);
            Message=Message.replace('var2', cs.Displayed_Account_number__c);
            API_LOG__c apiLog=new API_LOG__c();
            apiLog.Request_Source__c='SendSmsGupshup for '+ mtType+' Event';
            String parameter = '';  
            parameter += 'method='+gsmdt.method__c;
            if(cs.Name_of_Consumer__c!=null){
                if(cs.Name_of_Consumer__r.Phone !=null){
                    parameter += '&send_to=' + '91'+cs.Name_of_Consumer__r.Phone;
                }else if(cs.Name_of_Consumer__r.Phone_2__c !=null){
                    parameter += '&send_to=' + '91'+cs.Name_of_Consumer__r.Phone_2__c;
                }
            }
            
            parameter += '&msg=' +Message; 
            parameter += '&msg_type=' + gsmdt.msg_type__c;
            parameter += '&userid=' + gsmdt.userid__c;
            parameter += '&auth_scheme=' + gsmdt.auth_scheme__c;
            parameter += '&password=' + gsmdt.password__c;
            parameter += '&v=' + gsmdt.v__c;   
            parameter += '&format=' + gsmdt.format__c;
            
            try {
                HttpRequest httpReq = new HttpRequest();
                httpReq.setMethod('GET');
                httpReq.setEndpoint(Label.GupshupSMSEndpoint);
                httpReq.setHeader('Content-Type','application/x-www-form-urlencoded');
                httpReq.setTimeout(120000);
                httpReq.setBody(parameter);
                
                System.debug('body '+parameter);
                apiLog.Request__c = parameter;
                
                Http h = new Http();
                HttpResponse httpRes = h.send(httpReq);
                System.debug('response '+httpRes.getBody());
                Map<String,Object> response = (Map<String,Object>) JSON.deserializeUntyped(httpRes.getBody());
                Object responseBody =(Object)response.get('response');
                
                Map<String,Object> response1 = (Map<String,Object>) responseBody;
                apiLog.Gupshup_response_Id__c=(String)response1.get('id');
                apiLog.Gupshup_Status__c=(String)response1.get('status');
                
                apiLog.Response__c = httpRes.getBody();
                apiLog.Case__c=cs.Id;
                
            }
            catch(Exception e){
                System.debug('== >'+e.getMessage());
                apiLog.Exception_Description__c = e.getMessage();
            }
            apList.add(apiLog);  
        }
        //UPDATE cList;
        Insert apList;  
    }
}