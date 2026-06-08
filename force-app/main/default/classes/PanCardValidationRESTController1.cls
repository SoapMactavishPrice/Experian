public class PanCardValidationRESTController1 {

    public String id{get;set;}
    
    public PanCardValidationRESTController1(){} 

    public returnResult getTokenAPI(String Company, String Pan_no){

        returnResult status_re = new returnResult();

        // id = Id;
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
        } catch(Exception e) {
            System.debug('--------------------------FAILED------------------------------');
            status_re.msg = 'System callout exception pan card validation';
            status_re.status = false;
        }
        String at = '';
        string idt = '';
        try{
            List<String> s = getIdentityFlow('',t,u);
            at = s[0];
            idt = s[1];  
        }catch(Exception e){
            System.debug('--------------------------FAILED------------------------------');
            status_re.msg = 'exception pan card validation';
            status_re.status = false;  
        }
        
        try{
            // List<String> p = verifyPanCard(at,idt,id,Pan_no,Id);
            returnVerifyPanCard rvp_status = verifyPanCard(at,idt,Pan_no,Company);
            System.debug('TRY ---->   -->  '+rvp_status);
            // System.debug('TRY ----> p[0]  -->  '+p[0]);
            // System.debug('TRY ----> p[1]  -->  '+p[1]);
            // If(p[0] == 'Success'){
            //     t = p[1];
            // }  
            System.debug('--------------------------SUCCESS------------------------------');
            status_re.msg = 'Success Api pancard validation';
            status_re.status = true;
            status_re.returnVerifyPanCard = rvp_status;
        }catch(Exception e){
            System.debug('--------------------------FAILED------------------------------');
            status_re.msg = 'exception pan card validation';
            status_re.status = false;   
        }

        return status_re;
    }
    
    public List<String> getIdentityFlow(String type, String token, String userId){

        String t = '';
        String accessToken = '';
        String identityId = '';
        List<String> returnString = new List<String>();
        
        String userName = Label.SinzyUserName;
        String password = Label.SinzyPassword;
        String loginURL = Label.SinzyLoginAPI;
        
        String json = '{"type":"businessPan","email":"ankur.rand@signzy.com","callbackUrl":"http://199.34.22.154:9088/mfp/api/adapters/MMFSL4/videoMatchReturnUrl","images":["https://persist.signzy.tech/api/files/11763369/download/12LcX3GAM3eEgIL64ugtd45Y0v6m9X2U2zVYM01Ff3srIecKiJ.jpg"]}';
        
        String url = system.label.gstin_validation+userId+'/identities';
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
        } catch(Exception e) {
            System.debug('Callout error: '+ e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Exception in Identity API:'+e.getMessage()));
            return null;
            //System.debug(res.toString());
        }
        
        return returnString;
    }
    
    public returnVerifyPanCard verifyPanCard(String token, String userId,String Pan_no,String Company){

        String t = '';
        List<String> returnString = new List<String>();

        returnVerifyPanCard rvp_status = new returnVerifyPanCard();
        
        String userName = Label.SinzyUserName;
        String password = Label.SinzyPassword;
        String loginURL = Label.SinzyLoginAPI;
        
       
        String inputJson = '{"service":"Identity","itemId":"'+userId+'","accessToken":"'+token+'","task":"verification","essentials":{"name":"'+Company+'","number":"'+Pan_no+'"}}';
        
        
        String url = system.label.verify_pan;
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
            
            System.debug('I am printing the PAN response-->'+res.getStatusCode());
            System.debug('I am printing the PAN response-->'+res.getStatus());
            System.debug('I am printing the PAN response body-->'+res.getBody());
            JSON2ApexPanResponse js = JSON2ApexPanResponse.parse(res.getBody());
            System.debug('----js--->'+js);
            If(res.getStatusCode()==200){
                // ld.Pan_Verification_Remark__c = js.response.result.message;
                rvp_status.Pan_Verification_Remark_c = js.response.result.message;
                // returnString.add(js.response.result.message);
                If(js.response.result.verified){

                    System.debug('I am in success for update--');
                    rvp_status.Pan_Verified_c = 'True';
                    
                    rvp_status.Pan_Verification_Remark_c = res.getStatus();
                        
                }else{
                    rvp_status.Pan_Verification_Remark_c = res.getStatus();
                    rvp_status.Pan_Verified_c = 'Fail';
                    returnString.add(js.response.result.message);
                    returnString.add(js.response.result.upstreamName);
                }
            }else{
                returnString.add(res.getStatus());
                rvp_status.Pan_Verification_Remark_c = res.getStatus();
                rvp_status.Pan_Verified_c = 'Fail';
                System.debug('I----returnString--------> '+rvp_status);
            }
            
            // update ld;
            System.debug('   --    --  == >> '+rvp_status);
            
            
        } catch(Exception e) {
            rvp_status.Pan_Verified_c = 'False';
            rvp_status.Pan_Verification_Remark_c = 'Not Found';
        }
        //here i need to update the Lead fields
        
        return rvp_status;
        
    }
    
    //
    // Generated by JSON2Apex http://json2apex.herokuapp.com/
    //

    public class returnVerifyPanCard{
        public String Id {get;set;}
        public String Pan_Verified_c {get;set;}
        public String Pan_Verification_Remark_c {get;set;}
    }

    public class returnResult {
        public String Id {get;set;}
        public boolean status {get;set;}
        public String value {get;set;}
        public String msg {get;set;}
        public returnVerifyPanCard returnVerifyPanCard {get;set;}
    }

    public class Error_Trace_Wrapper {
        public String status {get;set;}
        public String error_in_method {get;set;}
        public String error_msg {get;set;}
    }
    
    
    public class JSON2ApexAuthAPI {
        
        public String id {get;set;}
        public Integer ttl {get;set;}
        public String created {get;set;}
        public String userId {get;set;}
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