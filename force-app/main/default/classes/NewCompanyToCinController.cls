public class NewCompanyToCinController {

    public String id {
        get;
        set;
    }

    public NewCompanyToCinController() {}

    public returnResult getCtoCinAPI(String Company) {

        returnResult status_re = new returnResult();

        String userName = Label.SinzyUserName;
        String password = Label.SinzyPassword;
        String loginURL = Label.SinzyLoginAPI;
        String t = '';
        String u = '';
        String jsonBody = '{"username": "' + userName + '","password" :"' + password + '"}';

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint(loginURL);
        req.setBody(jsonBody);
        try {
            res = http.send(req);
            JSON2ApexAuthAPI js = JSON2ApexAuthAPI.parse(res.getBody());
            t = js.id;
            u = js.userId;
        } catch (Exception e) {
            System.debug('--------------------------FAILED------------------------------');
            status_re.status = false;
        }
        String at = '';
        string idt = '';
        try {
            List < String > s = getOrgObjectDetails('', t, u);
            at = s[0]; //For access Token
            idt = s[1]; // For ID

        } catch (Exception e) {
            System.debug('--------------------------FAILED------------------------------');
            status_re.status = false;
        }

        try {
            returnVerifyCompanyCin rvp_status = verifyCompanyCin(at, idt, Company);
            System.debug('--------------------------SUCCESSC CIN------------------------------');
            status_re.msg = 'Success Company to CIN response';
            status_re.status = true;
            status_re.returnVerifyCompanyCin = rvp_status;
        } catch (Exception e) {
            System.debug('--------------------------FAILED------------------------------');
            status_re.msg = 'exception CIN response';
            status_re.status = false;
        }

        return status_re;
    }

    //Code for Generating  AccessToken & identityId for CIN 
    public List < String > getOrgObjectDetails(String type, String token, String userId) {

        String t = '';
        String accessToken = '';
        String identityId = '';
        List < String > returnString = new List < String > ();

        String userName = Label.SinzyUserName;
        String password = Label.SinzyPassword;
        String loginURL = Label.SinzyLoginAPI;

        String json = '{ "identifier": "organizations", "service": "roc", "callbackUrl": "http://199.34.22.154:9088/mfp/api/adapters/MMFSL4/videoMatchReturnUrl" }';

        String url = system.label.gstin_validation+userId+'/organizations';
        //String url = 'https://preproduction.signzy.tech/api/v2/patrons/60e033e39808ede4237536b3/organizations';
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
            JSON2ApexIdentityJSON js = JSON2ApexIdentityJSON.parse(res.getBody());
            accessToken = js.accessToken;
            identityId = js.id;

            returnString.add(accessToken);
            returnString.add(identityId);

        } catch (Exception e) {
            System.debug('Callout error: ' + e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Exception in Identity Creating Organization Object:' + e.getMessage()));
            return null;
        }

        return returnString;
    }

    //Code for Getting CIN against Company Name
    public returnVerifyCompanyCin verifyCompanyCin(String token, String userId, String Company) {

        String t = '';
        // List < String > returnString = new List < String > ();

        returnVerifyCompanyCin rvp_status = new returnVerifyCompanyCin();

        String userName = Label.SinzyUserName;
        String password = Label.SinzyPassword;
        String loginURL = Label.SinzyLoginAPI;

        String inputJson = '{ "target": "Organization", "itemId": "' + userId + '", "accessToken": "' + token + '", "task": "searchCompaniesByName", "essentials": { "name": "' + Company + '" }}';
        String url = system.label.SignzyBaseUrl+'/hunts';
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setTimeout(120000);

        req.setEndpoint(url);
        req.setBody(inputJson);

        try {
            res = http.send(req);
            JSON2ApexCompanyToCin js = JSON2ApexCompanyToCin.parseCin(res.getBody());
            System.debug('============================Js--->' + js);

            If(res.getStatusCode() == 200) {

                rvp_status.CIN_Verification_Remark_c = res.getStatus();
               
                if(js.result.companiesList.size() >0){
                    rvp_status.CIN_Verified_c = true;
                    rvp_status.companyID = js.result.companiesList[0].companyID;
                   
                }
            } else {
                rvp_status.CIN_Verification_Remark_c = res.getStatus();
                rvp_status.CIN_Verified_c = false;
                System.debug('I----returnString--------> ' + rvp_status);
            }
        } catch (Exception e) {
            rvp_status.CIN_Verified_c = false;
            rvp_status.CIN_Verification_Remark_c = 'Not Found';
        }
        
        return rvp_status;

    }

    //
    // Generated by JSON2Apex http://json2apex.herokuapp.com/
    //

    public class returnVerifyCompanyCin {
        public String companyID {
            get;
            set;
        }
        public Boolean CIN_Verified_c {
            get;
            set;
        }
        public String CIN_Verification_Remark_c {
            get;
            set;
        }
      
    }

    public class returnResult {
        public String Id {
            get;
            set;
        }
        public boolean status {
            get;
            set;
        }
        public String value {
            get;
            set;
        }
        public String msg {
            get;
            set;
        }
        public returnVerifyCompanyCin returnVerifyCompanyCin {
            get;
            set;
        }
    }

    public class Error_Trace_Wrapper {
        public String status {
            get;
            set;
        }
        public String error_in_method {
            get;
            set;
        }
        public String error_msg {
            get;
            set;
        }
    }


    public class JSON2ApexAuthAPI {

        public String id {
            get;
            set;
        }
        public Integer ttl {
            get;
            set;
        }
        public String created {
            get;
            set;
        }
        public String userId {
            get;
            set;
        }
    }


    public static JSON2ApexAuthAPI parse(String json) {
        return (JSON2ApexAuthAPI) System.JSON.deserialize(json, JSON2ApexAuthAPI.class);
    }


    public class JSON2ApexCompanyToCin {

        public String target;
        public String itemId;
        public String accessToken;
        public String task;
        public String id;
        public Essentials essentials;
        public Result result;

    }

    public class Essentials {
        public String name;
    }

    public class CompaniesList {
        public String companyName;
        public String companyID;
    }

    public class Result {
        public String message;
        public List < CompaniesList > companiesList;
    }


    public static JSON2ApexCompanyToCin parseCin(String json) {
        return (JSON2ApexCompanyToCin) System.JSON.deserialize(json, JSON2ApexCompanyToCin.class);
    }



}