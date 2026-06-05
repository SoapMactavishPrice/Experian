public class GSTINValidationRESTController1 {
    
    public String id{get;set;}

    public returnResult getTokenAPI(String pan_no, String gst_state){
        
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
            System.debug('Response object->'+res.getBody());
            JSON2ApexAuthAPI js = JSON2ApexAuthAPI.parse(res.getBody());
            t = js.id;
            u = js.userId;
        } catch(Exception e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
            System.debug('--------------------------FAILED------------------------------');
            status_re.status = false;
        }
        try{
            System.debug('--------------------------SUCCESS------------------------------');

            /*List<String> s = validateGSTIN(t,u,gst_number,Id);
            if(s[0] == 'Success'){
                t = s[1];
            }
            status_re.msg = 'Success Api gst number validation';
            status_re.status = true;
            status_re.value = s[0];*/


            returnGST rgstResult= validateGSTIN(t,u,pan_no,gst_state);
            System.debug('--------> > > > '+rgstResult);
            status_re.status = true;
            status_re.returnGST = rgstResult;
        }catch(Exception e){
            
            System.debug('--------------------------FAILED------------------------------');
            status_re.status = false; 
        }
        
        return status_re;
        
    }

    public returnGST validateGSTIN(String token,String userId,String pan_no,String gst_state){

        // returnResultgstn gstResult = new returnResultgstn();

        returnGST rgst_status = new returnGST();

        String t = '';
        String accessToken = '';
        String identityId = '';
        List<String> returnString = new List<String>();
        
        String userName = Label.SinzyUserName;
        String password = Label.SinzyPassword;
        String loginURL = Label.SinzyLoginAPI;

        try {
            // Lead ld = [SELECT ID, Name , Pan_no__c, GST_No__c, Pan_Verification_Remark__c, Pan_Verified__c, GST_Verified__c, GST_Verification_Remark__c FROM Lead WHERE Id=:Id];
            // // String pan = ld.Pan_no__c;
            // String gst_no = gst_number;
            // String name = ld.Name;
            String jsonb = '{"task" : "panSearch","essentials": {"panNumber": "'+pan_no+'","state":"'+gst_state+'","email":"test122@finesseme.com"}}';
            String jsonBody = '{"username": "'+userName+'","password" :"'+password+'"}';
           // String url = 'https://preproduction.signzy.tech/api/v2/patrons/'+userId+'/gstns';
            String url = system.label.gstin_validation+userId+'/gstns';
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setMethod('POST');
            req.setHeader('content-type', 'application/json');
            req.setHeader('Authorization', token);
            req.setEndpoint(url);
            //req.setTimeout(120000);
            req.setBody(jsonb);
            system.debug('****123--'+req.getBody());
            try {
                res = http.send(req);
                If(res.getStatusCode()==200){
                    //JSON2ApexGSTINFail js = JSON2ApexGSTINFail.parse(res.getBody());
                    JSON2ApexAcyualGSTIN js = JSON2ApexAcyualGSTIN.parse(res.getBody());
                    System.debug('######After parsing result-->'+js);
                    For(gstnRecords cr:js.Result.gstnRecords){
                        System.debug('cr-->'+cr.gstin);
                        System.debug('cr-->'+cr.registrationName);
                        If(cr.gstin!=''){
                            // if(cr.gstin == gst_no){
                                rgst_status.GST_Verified_c = 'True';
                                rgst_status.GST_Verification_Remark_c = cr.registrationName;
                                rgst_status.GST_number = cr.gstin;
                            // }else{
                            //     rgst_status.GST_Verified_c = 'False';
                            //     // rgst_status.GST_Verification_Remark_c = cr.registrationName;
                            //     rgst_status.GST_Verification_Remark_c = 'Not Found';
                            //     rgst_status.GST_status = false;
                            //     rgst_status.GST_value = 'Fail';
                            //     rgst_status.matchStatus = false;
                                
                            // }
                        }else{
                            rgst_status.GST_number = '';
                            rgst_status.GST_Verified_c = 'False';
                            rgst_status.GST_Verification_Remark_c = 'Not Found';
                        }
                    }
                    
                }else{
                    System.debug('I am in 404');
                    rgst_status.GST_Verified_c = 'False';
                    rgst_status.GST_Verification_Remark_c = 'Not Found';
                    // update ld;
                }
            } catch(Exception e) {
                System.debug('Callout error: '+ e);
                System.debug(res.toString());
                rgst_status.GST_Verified_c = 'False';
                rgst_status.GST_Verification_Remark_c = 'Not Found';
            }
            
        } catch (Exception e) {
            rgst_status.GST_Verified_c = 'False';
            rgst_status.GST_Verification_Remark_c = 'Not Found';
        }
        
        
        return rgst_status;
    }
    
    public PageReference Cancel() {
        
        PageReference pageRef = new PageReference('/' + id);
        pageRef.setRedirect(true);
        return pageRef;      
    }

    public class returnGST{
        public String Id {get;set;}
        public String GST_Verified_c {get;set;}
        public String GST_Verification_Remark_c {get;set;}
        public String GST_number {get;set;}
    }

    public class returnResult {
        public String Id {get;set;}
        public boolean status {get;set;}
        public returnGST returnGST {get;set;}
    }

    // public class returnResultgstn {
    //     public boolean status;
    //     public String value;
    //     public String msg;
    //     public boolean matchStatus;
    // }

    //
    // Generated by JSON2Apex http://json2apex.herokuapp.com/
    //

    //
    // Generated by JSON2Apex http://json2apex.herokuapp.com/
    //

    public class JSON2ApexAcyualGSTIN {

        public String task {get;set;}
        public Essentials essentials;
        public String id {get;set;}
        public String patronId {get;set;}
        public Result result;
    }

    public class GstnRecords {
        public String applicationStatus {get;set;}
        public String registrationName {get;set;}
        public String mobNum {get;set;}
        public String regType {get;set;}
        public String emailId {get;set;} 
        public String tinNumber {get;set;}
        public String gstinRefId {get;set;}
        public String gstin {get;set;}
    }

    public class GstnDetailed {
        public String constitutionOfBusiness;
        public String legalNameOfBusiness;
        public String tradeNameOfBusiness;
        public String centreJurisdiction;
        public String stateJurisdiction;
        public String registrationDate;
        public String taxPayerDate;
        public String taxPayerType;
        public String gstinStatus;
        public String cancellationDate;
        public List<String> natureOfBusinessActivities;
        public String principalPlaceAddress;
        public String principalPlaceLatitude;
        public String principalPlaceLongitude;
        public String principalPlaceBuildingNameFromGST;
        public String principalPlaceBuildingNoFromGST;
        public String principalPlaceFlatNo;
        public String principalPlaceStreet;
        public String principalPlaceLocality;
        public String principalPlaceCity;
        public String principalPlaceDistrict;
        public String principalPlaceState;
        public String principalPlacePincode;
        public String additionalPlaceAddress;
        public String additionalPlaceLatitude;
        public String additionalPlaceLongitude;
        public String additionalPlaceBuildingNameFromGST;
        public String additionalPlaceBuildingNoFromGST;
        public String additionalPlaceFlatNo;
        public String additionalPlaceStreet;
        public String additionalPlaceLocality;
        public String additionalPlaceCity;
        public String additionalPlaceDistrict;
        public String additionalPlaceState;
        public String additionalPlacePincode;
    }


    public class Essentials {
        public String panNumber {get;set;}
        public String state {get;set;}
        public String email {get;set;}
    }
    
    public class Result {
        public List<GstnRecords> gstnRecords ;
    }
    
    public static JSON2ApexAcyualGSTIN parse(String json) {
        return (JSON2ApexAcyualGSTIN) System.JSON.deserialize(json, JSON2ApexAcyualGSTIN.class);
    }
}