public class AgreementAPiRESTController {

    public String referanceId ;
    public String currentDate;
    public String made_valid_reference;

    public AgreementAPiRESTController(){
      
            
        referanceId = datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String[] separte_valid_refernce=referanceId.split('-');
        String[] seconds_valid_ref=separte_valid_refernce[2].split(':');
        made_valid_reference=separte_valid_refernce[0]+''+separte_valid_refernce[1]+''+seconds_valid_ref[0]+''+seconds_valid_ref[1]+''+seconds_valid_ref[2];
        
        System.debug('---------------------->made_valid_reference'+made_valid_reference);
        currentDate = datetime.now().formatGMT('yyyy-MM-dd');
    }

    @future (callout=true)
    public static void save_pdf_in_attachment(String Billing_Contact_Person_c,String Billing_Contact_Details_c,String Billing_Job_Title_c,String company_name,String Name,String designation,String phone_number,String email,String billing_email, String billing_address,String gst_registration_no,String parentId, String NodalOfficerName, String NodalEmail, String TelNoNodal, String BillingStreet, String BillingCity, String BillingZipPostalCode, String BillingState, String BillingCountry,String First_Name_Auth_Usr_Req_c,String Last_Name_Auth_Usr_Req_c,String Job_Title_Auth_Usr_Req_c,String Official_Email_Auth_Usr_Req_c,String Tel_No_Auth_Usr_Req_c,String First_Name_AuSig_c,String Last_Name_AuSig_c,String Job_Title_AuSig_c,String Tel_No_AuSig_c,String Official_Email_Address_AuSig_c){
        
        String consumer_credit_information_report = 'No';
        String delphi_for_new_business_score = 'No';
        String commercial_credit_information_report = 'No';
        String online_account_review = 'No';
        String online_account_review_Id = null;
        List<Product_Line_Item__c> Product_Line_Item_List = new List<Product_Line_Item__c>();

        List<String> st1 = new String[]{ ' ', 'one', 'two', 'three', 'four', 'five', 'six','seven', 'eight', 'nine' };

        List<Lead_Payment_Detail__c> Lead_Payment_Detail_List = [ SELECT Id,Name,Product__r.Name,Product__r.Id FROM Lead_Payment_Detail__c WHERE Lead__c =: parentId ];
        System.debug('Lead_Payment_Detail_List ->'+Lead_Payment_Detail_List.size());
        if(Lead_Payment_Detail_List.size() > 0){
            for (Lead_Payment_Detail__c LPDC : Lead_Payment_Detail_List) {
                System.debug('LPDC -->'+LPDC);
                if(LPDC.Product__r.Name == 'Credit Information Report - Commercial'){
                    commercial_credit_information_report = 'Yes';
                }
                if(LPDC.Product__r.Name == 'Credit Information Report - with Delphi Score'){
                     delphi_for_new_business_score = 'Yes';
                }
                if(LPDC.Product__r.Name == 'Online Account Review'){      
                    online_account_review = 'Yes';
                    online_account_review_Id = LPDC.Product__r.Id;
                }
                if(LPDC.Product__r.Name == 'Credit Information Report - Consumer'){
                    consumer_credit_information_report = 'Yes';
                }
            }
        }
        System.debug('online_account_review ->'+online_account_review);
        if(online_account_review == 'Yes'){
            if(online_account_review_Id != null){
                Product_Line_Item_List = [ SELECT Id,Name,Monthly_Volumes__c,Price_Per_Report__c,Product__c FROM Product_Line_Item__c  WHERE Product__c =: online_account_review_Id ORDER BY Name ];
            }
        }
        
            API_LOG__c ap=new API_LOG__c();
        	ap.Lead__c=parentId;
            ap.Request_Source__c='Sent For Agreement';
            ap.Company_Name__c=company_name;
            AgreementAPiRESTController arc = new AgreementAPiRESTController (); 
            String loginURL = system.label.LegalDesk_Agreement_Url;
            
            system.debug('****uuuu'+loginURL);
            //Final Map
            Map<String, Object> mapagrrementFinal = new Map<String, Object>();  

            //Doc info map  
            Map<String, Object> docinformap = new Map<String,Object>();
            docinformap.put('signature_sequence','sequential');
            docinformap.put('signature_type','electronic');
            mapagrrementFinal.put('document_info',docinformap); 

            //Signer info Map customer side
            Map<String,Object> signer_infoMap = new Map<String,Object>();
            signer_infoMap.put('signer_name',First_Name_AuSig_c+' '+Last_Name_AuSig_c);
            signer_infoMap.put('signer_email',Official_Email_Address_AuSig_c);
            signer_infoMap.put('signer_mobile',Tel_No_AuSig_c);
            signer_infoMap.put('esign_type','otp');
            signer_infoMap.put('sequence','1');
            signer_infoMap.put('signer_ref_id','1');
            signer_infoMap.put('signing_mode','electronic');

             //Signer info Map experian side
             Map<String,Object> signer_infoMap1 = new Map<String,Object>(); 
             signer_infoMap1.put('signer_name',system.label.Experian_signer_name); 
             signer_infoMap1.put('signer_email',system.label.Experian_signer_email);//live data
             //signer_infoMap1.put('signer_email','balram@finesseme.com'); //testing data
             
             signer_infoMap1.put('signer_mobile',system.label.Experian_signer_mobile);//live data
             //signer_infoMap1.put('signer_mobile','8169093584');//testing data
             
             signer_infoMap1.put('esign_type','otp');
             signer_infoMap1.put('sequence','2');
             signer_infoMap1.put('signer_ref_id','2');
             signer_infoMap1.put('signing_mode','electronic');
            

            //Signer info list
            List<Object> signerinfolist = new List<Object>();  
            signerinfolist.add(signer_infoMap);
            signerinfolist.add(signer_infoMap1);
            mapagrrementFinal.put('signer_info',signerinfolist);

            //first party address - experian
            Map<String,Object> firstprtyAddress = new Map<String,Object>();
            firstprtyAddress.put('street_address','Equinox Business Park');
            firstprtyAddress.put('locality','LBS Marg Kurla (West)');
            firstprtyAddress.put('city','Mumbai');
            firstprtyAddress.put('state','MH');
            firstprtyAddress.put('pincode','400070');
            firstprtyAddress.put('country','India');
            mapagrrementFinal.put('first_party_address',firstprtyAddress);

            //second party address -customer
            Map<String,Object> secndpartyAddress = new Map<String, Object>();
            secndpartyAddress.put('street_address',BillingStreet);
            secndpartyAddress.put('locality',BillingStreet);
            secndpartyAddress.put('city',BillingCity);
            secndpartyAddress.put('state',BillingState);
            secndpartyAddress.put('pincode',BillingZipPostalCode);
            secndpartyAddress.put('country',BillingCountry);
            mapagrrementFinal.put('second_party_address',secndpartyAddress);

            //Template Info
            Map<String,Object> tempinfoMap = new Map<String,Object>();
            // tempinfoMap.put('template_id','5def6d09109eee1becaae759'); //OLD
            //tempinfoMap.put('template_id','60c750133ad89441ee3a48b8'); //NEW Sandbox
       	 	tempinfoMap.put('template_id','644a06e0e1bef57b5653dd64'); // Production

            //Template Param
            Map<String,Object> tempparamMap = new Map<String,Object>();
            
            tempparamMap.put('address', billing_address);
            tempparamMap.put('signature_of_authoritysignatory', 'Signature');
            tempparamMap.put('name_in_company', First_Name_AuSig_c+' '+Last_Name_AuSig_c);
            tempparamMap.put('gm_credit_services', system.label.Experian_signer_position); // GM – Credit Services
            tempparamMap.put('position_in_company', Job_Title_AuSig_c);
            tempparamMap.put('date_one', arc.currentDate);
            tempparamMap.put('company_name',company_name); 
            tempparamMap.put('company',company_name); 
            tempparamMap.put('date',arc.currentDate); 
            tempparamMap.put('name',system.label.Experian_signer_name); //Uday Khona
            tempparamMap.put('designation',Billing_Job_Title_c);  
            tempparamMap.put('email_id', billing_email); 
            tempparamMap.put('phone_number',phone_number); 
            tempparamMap.put('ph_number',phone_number); 
            tempparamMap.put('email',billing_email); 
            tempparamMap.put('billing_entity_name',Name); 
            tempparamMap.put('billing_address',billing_address); 
            tempparamMap.put('gst_registration_no',gst_registration_no); 
            tempparamMap.put('billing_contact_name_and_designation',Name); 
            tempparamMap.put('billing_contact_phone_and_email',billing_email); 

            // -- Added by MMFurkan on 21-6-2021 for agreemtn api update for authorize signatory -- //
            // l.First_Name_Auth_Usr_Req_c,l.Last_Name_Auth_Usr_Req_c,Job_Title_Auth_Usr_Req_c,l.Official_Email_Auth_Usr_Req_c,l.Tel_No_Auth_Usr_Req_c
            tempparamMap.put('consumer_credit_information_report',consumer_credit_information_report); 
            tempparamMap.put('delphi_for_new_business_score',delphi_for_new_business_score); 
            tempparamMap.put('commercial_credit_information_report',commercial_credit_information_report);
            tempparamMap.put('online_account_review',online_account_review);            
            tempparamMap.put('online_account_review_one', 'No');
            tempparamMap.put('online_account_review_two', 'No');
            tempparamMap.put('online_account_review_three', 'No');
            tempparamMap.put('online_account_review_four','No');
            tempparamMap.put('online_account_review_five','No');
            tempparamMap.put('online_account_review_six', 'No');
            tempparamMap.put('online_account_review_seven', 'No');
            tempparamMap.put('online_account_review_eight', 'No'); 

            System.debug('Product_Line_Item_List ->'+Product_Line_Item_List.size());
            if(Product_Line_Item_List.size() > 0){
                for (Product_Line_Item__c PLIL : Product_Line_Item_List) {
                        System.debug('PLIL ->'+PLIL);
                        tempparamMap.put('online_account_review_'+(st1[integer.valueof(PLIL.Name)]), PLIL.Monthly_Volumes__c);
                }
            }

            tempparamMap.put('First_Name_Auth_Usr_Req__c',First_Name_Auth_Usr_Req_c); 
            tempparamMap.put('Last_Name_Auth_Usr_Req__c',Last_Name_Auth_Usr_Req_c); 
            tempparamMap.put('Job_Title_Auth_Usr_Req__c',Job_Title_Auth_Usr_Req_c); 
            tempparamMap.put('Official_Email_Auth_Usr_Req__c',Official_Email_Auth_Usr_Req_c); 
            tempparamMap.put('name_of_the_authorised_signatory',Billing_Contact_Person_c+' '+Billing_Contact_Details_c); 

            // -- End here for above code -- //
            //put temp param value into temp info map
            tempinfoMap.put('template_params',tempparamMap); 

            //put temp info value into final map
            mapagrrementFinal.put('template_info',tempinfoMap);
            mapagrrementFinal.put('initiator_email_id',system.label.initiator_email_id);
            mapagrrementFinal.put('self_signer','false');
            mapagrrementFinal.put('final_copy_recipients', NodalEmail);
            mapagrrementFinal.put('esign_link_validity',365);
            mapagrrementFinal.put('first_party_name','Experian CIC India Pvt Ltd');
            mapagrrementFinal.put('second_party_name',company_name);
            mapagrrementFinal.put('document_reference_no',arc.made_valid_reference);
            mapagrrementFinal.put('stamp_duty_paid_by','First Party');
            mapagrrementFinal.put('document_category','1');
            //mapagrrementFinal.put('stamp_amount','500'); // Sandbox Latest change
            mapagrrementFinal.put('stamp_amount','1000'); // For Production 
            mapagrrementFinal.put('stamp_state', 'MH');
                   
            mapagrrementFinal.put('reference_id',arc.made_valid_reference);
            mapagrrementFinal.put('consideration_amount',0);
            mapagrrementFinal.put('duty_payer_phone_number','9920098201');
            mapagrrementFinal.put('source_type','template');

            String js = JSON.serialize(mapagrrementFinal);
            System.debug('mapagrrementFinal ->'+js);
        
            HttpRequest req = new HttpRequest();
            HttpResponse res  = new HttpResponse();
            Http http = new Http();
            req.setMethod('POST');
            req.setHeader('x-parse-rest-api-key', system.label.Legal_Desk_Username_Auth);
            req.setHeader('X-parse-rest-api-id', system.label.Legal_Desk_Auth_ID); 
            req.setHeader('Content-Type', 'application/json');
            req.setBody(js);
            req.setEndpoint(loginUrl);
        	req.setTimeout(120000);
            System.debug('Input Request:' + js);
			ap.Request__c=js;
            if(!Test.isRunningTest()){
                try{
                res = http.send(req);
                system.debug('***Response'+ res.getBody());
                ap.Response__c=res.getBody();
                JSON2ApexAgreementFirstCall japx =  JSON2ApexAgreementFirstCall.parse(res.getBody());
                
                Lead ld = [SELECT Id, LegalDesk_Agreement_Document_Id__c ,Legal_desk_docket_id__c,Agreement_Experian_Status__c,Agreement_Customer_Status_Stages__c FROM Lead WHERE Id =: parentId];

                    //update document Id
                    ld.LegalDesk_Agreement_Document_Id__c = japx.document_id;
                    ld.Legal_desk_docket_id__c = japx.docket_id;
                    ld.Agreement_Customer_Status_Stages__c = 'unsigned';
                    ld.Agreement_Experian_Status__c = 'unsigned';
                	ld.Sent_for_Agreement__c=true;
                    update ld;
                  // System.debug('japx.document_id' + japx.signer_info[0].document_id);

            }
            Catch(Exception e){
                ap.Exception_Description__c=e.getMessage();
                System.debug('Callout error Of Login API: '+ e.getMessage());
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error'+e.getMessage()));
            }
        	insert ap;
            }
            
           
    }

    public class JSON2ApexAgreementFirstCall{

    public String status;
    public String reference_id;
    public String message;
    public String error_code;
    //public List<String> stamp_paper_number;
    public String docket_id;
    public String document_id;
    public String transaction_id;
    public List<Signer_info> signer_info;
    public String api_response_id;
    public String response_time_stamp;

    }
    public class Signer_info {
        public String signer_id;
        public String signer_ref_id;
       
    }

    
    public static JSON2ApexAgreementFirstCall parse(String json) {
        return (JSON2ApexAgreementFirstCall) System.JSON.deserialize(json, JSON2ApexAgreementFirstCall.class);
    } 
}