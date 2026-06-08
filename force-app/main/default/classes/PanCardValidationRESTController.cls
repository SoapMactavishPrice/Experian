public class PanCardValidationRESTController {
    public String id{get;set;}
    public PanCardValidationRESTController(){
        
        
    } 
    public PageReference getTokenAPI(){
        id = ApexPages.currentPage().getParameters().get('id');
        String userName = Label.SinzyUserName;
        String password = Label.SinzyPassword;
        String loginURL = Label.SinzyLoginAPI;
        String t = '';
        String u = '';
        String jsonBody = '{"username": "'+userName+'","password" :"'+password+'"}';
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint(loginURL);
        req.setBody(jsonBody);
        System.debug('Input Request:' + jsonBody);
        try {
            res = http.send(req);
            System.debug('Response object Of Login API->'+res.getBody());
            JSON2ApexAuthAPI js = JSON2ApexAuthAPI.parse(res.getBody());
            t = js.id;
            u = js.userId; 
        } catch(System.CalloutException e) {
            System.debug('Callout error Of Login API: '+ e.getMessage());
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Exception in Login API:'+e.getMessage()));
            return null;
        }
        String at = '';
        string idt = '';
        try{
            List<String> s = getIdentityFlow('',t,u);
            at = s[0];
            idt = s[1];  
        }catch(Exception e){
            PageReference pageRef = new PageReference('/' + id);
            pageRef.setRedirect(true);
            return pageRef;  
        }
        
        try{
            List<String> p = verifyPanCard(at,idt,id);
            If(p[0] == 'Success'){
                t = p[1];
            }  
        }catch(Exception e){
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            //return null;
            PageReference pageRef = new PageReference('/' + id);
            pageRef.setRedirect(true);
            return pageRef;  
        }
        
        PageReference orderPage = new PageReference('/' + id);
        orderPage.setRedirect(true);
        return orderPage;
    }
    
    public List<String> getIdentityFlow(String type, String token, String userId){
        String t = '';
        String accessToken = '';
        String identityId = '';
        List<String> returnString = new List<String>();
        
        String userName = Label.SinzyUserName;
        String password = Label.SinzyPassword;
        String loginURL = Label.SinzyLoginAPI;
        
        String json = '{"type":"individualPan","email":"ankur.rand@signzy.com","callbackUrl":"http://199.34.22.154:9088/mfp/api/adapters/MMFSL4/videoMatchReturnUrl","images":["https://persist.signzy.tech/api/files/11763369/download/12LcX3GAM3eEgIL64ugtd45Y0v6m9X2U2zVYM01Ff3srIecKiJ.jpg"]}';
        
        
        String url = 'https://preproduction.signzy.tech/api/v2/patrons/'+userId+'/identities';
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setHeader('Authorization', token);
        req.setEndpoint(url);
        req.setBody(json);
        
        try {
            res = http.send(req);
            System.debug('Input Request Of Identites API-->'+req);
            System.debug('Input Body of Identites API-->'+req.getBody());
            System.debug('Response object of Identites API-->'+res.getBody());
            JSON2ApexIdentityJSON js = JSON2ApexIdentityJSON.parse(res.getBody());
            System.debug('After parsing-->'+js);
            accessToken = js.accessToken;
            identityId = js.id;
            System.debug('accessToken of IdentityAPI ->'+accessToken);
            System.debug('id of IdentityAPI ->'+identityId);
            
            returnString.add(accessToken);
            returnString.add(identityId);
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Exception in Identity API:'+e.getMessage()));
            return null;
            //System.debug(res.toString());
        }
        
        return returnString;
    }
    
    public List<String> verifyPanCard(String token, String userId,String recId){
        String t = '';
        List<String> returnString = new List<String>();
        
        
        String userName = Label.SinzyUserName;
        String password = Label.SinzyPassword;
        String loginURL = Label.SinzyLoginAPI;
        
        Lead ld = [SELECT ID, Name ,Company, Pan_no__c, GST_No__c, Pan_Verification_Remark__c, Pan_Verified__c, GST_Verified__c, GST_Verification_Remark__c FROM Lead WHERE Id=:id];
        String pan = ld.Pan_no__c;
        String name = ld.Company;
        
        //String inputJson = '{"service":"Identity","itemId":"'+userId+'","accessToken":"'+token+'","task":"verification","essentials":{"name":"'+name+'","number":"'+pan+'"}}';
        
        String inputJson = '{"service":"Identity","itemId":"'+userId+'","accessToken":"'+token+'","task":"verification","essentials":{"name":"'+name+'","number":"'+pan+'"}}';
        System.debug('InputJSON--->'+inputJson);
        String url = 'https://preproduction.signzy.tech/api/v2/snoops';
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        
        req.setEndpoint(url);
        req.setBody(inputJson);
        
        try {
            res = http.send(req);
            System.debug('Input Request Of Pan API:'+req);
            System.debug('Input body Of Pan API:'+req.getBody());
            System.debug('Response object Of Pan API:'+res.getBody());
            
            System.debug('I am printing the PAN response-->'+res.getStatusCode());
            System.debug('I am printing the PAN response-->'+res.getStatus());
            If(res.getStatusCode()==404){
                ld.Pan_Verification_Remark__c = res.getStatus();
                ld.Pan_Verified__c = 'False';
            }else{
                JSON2ApexPanResponse js = JSON2ApexPanResponse.parse(res.getBody());
                
                System.debug('Response Of PAN API-result-->'+js.response.result);
                System.debug('Response Of PAN API--->'+js.response.result.verified);
                ld.Pan_Verification_Remark__c = js.response.result.message;
                If(js.response.result.verified){
                    System.debug('I am in success for update--');
                    ld.Pan_Verified__c = 'True';
                    
                    If(js.response.result.verified){
                        returnString.add('Success');
                        returnString.add(js.response.result.message);
                        returnString.add(js.response.result.upstreamName);
                        
                        
                        
                    }else{
                        returnString.add('Fail');
                        returnString.add(js.response.result.message);
                        returnString.add(js.response.result.upstreamName);
                    }
                }
            }
            
            update ld;
            
            
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e.getMessage());
            String finalMsg = 'Exception in PAN API:'+e.getMessage();
            System.debug('FinalMsg:'+finalMsg);    
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,finalMsg));
            return null;
            
        }
        //here i need to update the Lead fields
        
        return returnString;
        
    }
    
    //
    // Generated by JSON2Apex http://json2apex.herokuapp.com/
    //
    
    public class JSON2ApexAuthAPI {
        
        public String id;
        public Integer ttl;
        public String created;
        public String userId;
    }
    
    
    public static JSON2ApexAuthAPI parse(String json) {
        return (JSON2ApexAuthAPI) System.JSON.deserialize(json, JSON2ApexAuthAPI.class);
    }
    
    public PageReference Cancel() {
        
        PageReference pageRef = new PageReference('/' + id);
        pageRef.setRedirect(true);
        return pageRef;      
    }
    
}