public class PanToCompanyCinRESTController {

    public PanToCompanyCinRESTController(){
        
    }
	    
    public returnResult getTokenAPI(String pan_no){
        
        returnResult status_re = new returnResult();
        
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

       		returnCompany companyResult= validateCompany(t,u,pan_no);
            System.debug('--------> > > > '+companyResult);
            status_re.status = true;
            status_re.returnCompany = companyResult;
        }catch(Exception e){
            
            System.debug('--------------------------FAILED------------------------------');
            status_re.status = false; 
        } 
        return status_re;
    }

		public returnCompany validateCompany(String token,String userId,String pan_no){

            returnCompany company_status = new returnCompany();
            
            String userName = Label.SinzyUserName;
            String password = Label.SinzyPassword;
            String loginURL = Label.SinzyLoginAPI;    
    
			
           		String jsonb = '{"task":"fetch","essentials":{"number":"'+pan_no+'"}}';
                System.debug('Input Request:' + jsonb);
            	String jsonBody = '{"username": "'+userName+'","password" :"'+password+'"}';   
                String url =system.label.gstin_validation+userId+'/panv2';            
                HttpRequest req = new HttpRequest();
                HttpResponse res = new HttpResponse();
                Http http = new Http();
                req.setMethod('POST');
                req.setHeader('content-type', 'application/json');
                req.setHeader('Authorization', token);
                req.setEndpoint(url);                
                req.setBody(jsonb);
                
                system.debug('================>    '+req.getBody());
                
            try {
                res = http.send(req);
                             
                If(res.getStatusCode()==200 ){
                    JSON2ApexCompany js = JSON2ApexCompany.parse(res.getBody());
                    System.debug('Response object->'+res.getBody());
                    System.debug('Name of the Company : ----> '+js.result.name); 

                    company_status.Company_Verified_c = 'True';
                    company_status.Company_Verification_Remark_c = 'Found';
                    company_status.name=js.result.name;

                 }else{
                    System.debug('I am in 404');

                    company_status.Company_Verified_c = 'False';
                    company_status.Company_Verification_Remark_c = 'Not Found';

                 }
            } catch (Exception e) {
                System.debug('Callout error: '+ e);
                System.debug(res.toString());
            	company_status.Company_Verified_c = 'False';
            	company_status.Company_Verification_Remark_c = 'Not Found';
        		}
             
                
        return company_status;
    }
    
    public class returnCompany{
        public String Id {get;set;}
        public String name {get;set;}
        public String Company_Verified_c {get;set;}
        public String Company_Verification_Remark_c {get;set;}
    }
    
    public class returnResult {
        public String Id {get;set;}
        public boolean status {get;set;}
        public returnCompany returnCompany {get;set;}
    }
    public class JSON2ApexCompany {
        public String id {get;set;}
        public Result result;
    }
    
    public class Result {
        public String name {get;set;}
        public String panStatus {get;set;}
    }
    
    
    public static JSON2ApexCompany parse(String json) {
        return (JSON2ApexCompany) System.JSON.deserialize(json, JSON2ApexCompany.class);
    }   
}