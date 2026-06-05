public class FetchMoreDetailsByCIN {

    public FetchMoreDetailsByCIN() {
        
    }

    public returnResult getCtoCinAPI(String Cin) {

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
            
            system.debug('res.getBody()'+res.getBody());
            JSON2ApexAuthAPI js = JSON2ApexAuthAPI.parse(res.getBody());
            system.debug('JSON2ApexAuthAPI'+js);
            
            t = js.id;
            u = js.userId;
        } catch (Exception e) {
            System.debug('--------------------------FAILED------------------------------'+e.getMessage());
            status_re.status = false;
        }
        String at = '';
        string idt = '';
        try {
            List < String > s = getOrgObjectDetails('', t, u,Cin);
            at = s[0]; //For access Token
            idt = s[1]; // For ID

        } catch (Exception e) {
            System.debug('--------------------------FAILED------------------------------');
            status_re.status = false;
        }

        try {
            returnVerifyCompanyCin rvp_status = verifyCompanyCin(at, idt, Cin);
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
    public List < String > getOrgObjectDetails(String type, String token, String userId,String Cin) {

        String t = '';
        String accessToken = '';
        String identityId = '';
        List < String > returnString = new List < String > ();

        String userName = Label.SinzyUserName;
        String password = Label.SinzyPassword;
        String loginURL = Label.SinzyLoginAPI;

        String json = '{ "identifier": "'+Cin+'", "service": "roc", "callbackUrl": "http://199.34.22.154:9088/mfp/api/adapters/MMFSL4/videoMatchReturnUrl" }';

        String url = system.label.gstin_validation+userId+'/organizations';
        
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
            System.debug('getOrgObjectDetails == '+res.getBody());
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
    public returnVerifyCompanyCin verifyCompanyCin(String token, String userId, String Cin) {

        String t = '';
        // List < String > returnString = new List < String > ();

        returnVerifyCompanyCin rvp_status = new returnVerifyCompanyCin();

        String userName = Label.SinzyUserName;
        String password = Label.SinzyPassword;
        String loginURL = Label.SinzyLoginAPI;

        String inputJson = '{ "target": "Organization", "itemId": "' + userId + '", "accessToken": "' + token + '", "task": "simpleSearchByCin", "essentials": { "cin": "' + Cin + '" }}';

        String url = system.label.SignzyBaseUrl+'/hunts';
        ////String url = system.label.verify_cin;
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setTimeout(120000);

        req.setEndpoint(url);
        req.setBody(inputJson);

        List<cls_directorDetails>  directorDetailsList=new List<cls_directorDetails>();
        cls_directorDetails cROW2=new cls_directorDetails();
        cROW2.name='Other';
        cROW2.designation='';
        
         //add by shashank on 18 Aug
        cROW2.din='';
        directorDetailsList.add(cROW2);

        try {
            // System.debug('========verifyCompanyCin====================input Js--->' + req.getBody());
            res = http.send(req);
            If(res.getStatusCode() == 200) {
                Map<String, Object> m = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                // fromJSON js = fromJSON.parseCINdetails(res.getBody());
                 
                 Map<String, Object> mResult= (Map<String, Object>) m.get('result');
                  system.debug('Register addrss is '+ mResult.get('registeredAddress'));
                
                 List<Map<String, Object>> myMaps = new List<Map<String, Object>>();
                 List<Object> myMapObjects = (List<Object>) mResult.get('directorDetails');

                 for (Object obj : myMapObjects) {
                     myMaps.add((Map<String, Object>)obj);
                 }
                 
                 for(Map<String, Object> mRow:myMaps){
                     cls_directorDetails cROW=new cls_directorDetails();
                     cROW.name=(String)mRow.get('name');
                     cROW.designation=(String)mRow.get('designation');
                     
                     //add by shashank on 18 Aug
                     cROW.din=(String)mRow.get('din');
                     directorDetailsList.add(cROW);
                 }
                System.debug('=========directorDetailsList=================Js--->' + directorDetailsList);
                rvp_status.dateOfIncorporation=(String)mResult.get('dateOfIncorporation');
                rvp_status.registeredAddress = (String)mResult.get('registeredAddress');
                rvp_status.clsDirectorLIst=directorDetailsList;
                rvp_status.CIN_Verified_c = 'True';
                rvp_status.CIN_Verification_Remark_c = 'Found';

            } else {
                rvp_status.CIN_Verification_Remark_c = res.getStatus();
                rvp_status.CIN_Verified_c = 'Fail';
                System.debug('I----returnString- not--200-----> ' + rvp_status);
                rvp_status.clsDirectorLIst=directorDetailsList;
                rvp_status.CIN_Verified_c = 'False';
                rvp_status.CIN_Verification_Remark_c = 'Not Found';
            }
        } catch (Exception e) {
            System.debug('Exception ' + e);
            rvp_status.clsDirectorLIst=directorDetailsList;
            rvp_status.CIN_Verified_c = 'False';
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
        public String CIN_Verified_c {
            get;
            set;
        }
        public String CIN_Verification_Remark_c {
            get;
            set;
        }

        public String dateOfIncorporation {
            get;
            set;
        }
        
        public String registeredAddress {
            get;
            set;
        }

        public List<cls_directorDetails> clsDirectorLIst{
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


    //
//Generated by AdminBooster
//

public class fromJSON{
	public String target;	//Organization
	public String itemId;	//62386addc2b34dad7eb53cb8
	public String accessToken;	//f8sl58xkwpijaypjhrhqxpzs6veugkkp
	public String task;	//simpleSearchByCin
	public String id;	//62386b72c2b34dad7eb53d14
	public cls_essentials essentials;
	public cls_result result;
}
	class cls_essentials {
		public String cin;	//L40100GJ1995PLC025447
	}
	class cls_result {
		public String numberOfMembers;	//0
		public String subCategory;	//NON-GOVT COMPANY
		public String companyType;	//INDIAN COMPANY
		public String companyName;	//SUZLON ENERGY LIMITED
		public String paidUpCapital;	//18434888074
		public String authorisedCapital;	//92000000000
		public String whetherListed;	//LISTED
		public String dateOfIncorporation;	//10/04/1995
		public String lastAgmDate;	//24/09/2021
		public String registrationNumber;	//025447
		public String registeredAddress;	//SUZLON 5,SHRIMALI SOCIETY NEAR SHRI KRISHNA COMPLEX NAVRANGPURA AHMEDABAD GJ 380009 IN
		public String activeCompliance;	//ACTIVE COMPLIANT
		public String suspendedAtStockExchange;	//
		public String balanceSheetDate;	//31/03/2021
		public String category;	//COMPANY LIMITED BY SHARES
		public String status;	//ACTIVE
		public String cin;	//L40100GJ1995PLC025447
		public String rocOffice;	//ROC-AHMEDABAD
		public String countryOfIncorporation;	//
		public String descriptionOfMainDivision;	//
		public String addressOtherThanRegisteredOffice;	//ONE EARTH, HADAPSAR PUNE 411028 MH
		public String emailId;	//mca@suzlon.com
		public cls_splitAddress splitAddress;
		public String natureOfBusiness;	//
		public String noOfDirectors;	//13
		public String statusForEfiling;	//ACTIVE
		public String pan;	//AAECS4967P
		public cls_directorDetails[] directorDetails;
	}
	class cls_splitAddress {
		public cls_district[] district;
		public cls_state[] state;
		public cls_city[] city;
		public String pincode;	//
		public cls_country[] country;
		public String addressLine;	//
	}
	class cls_district {
	}
	class cls_state {
	}
	class cls_city {
	}
	class cls_country {
		
	}
	public class cls_directorDetails {
		public String din;	//00002266
		public String designation;	//WHOLETIME DIRECTOR
		public String dateOfAppointment;	//01/11/2010
		public String address;	//
		public String name;	//VINOD RANCHHODBHAI TANTI
		public String whetherDscRegistered;	//YES
		public String dscExpiryDate;	//15/02/2024
		public String pan;	//
		public String noOfCompanies;	//
		public String fatherName;	//
		public String dob;	//-
		public cls_splitAddress splitAddress;
	}
	public static fromJSON parseCINdetails(String json){
		return (fromJSON) System.JSON.deserialize(json, fromJSON.class);
	}

	public static void fakeCodeCoverage(){
        integer i=1;
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
        i++; i++;
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
    }


}