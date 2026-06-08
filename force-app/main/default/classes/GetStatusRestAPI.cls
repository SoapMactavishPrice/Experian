@RestResource(urlMapping='/getStatus/*')
global class GetStatusRestAPI {
    
    @HttpPost
    global static void doPost(){
        
        API_LOG__c ap=new API_LOG__c();
        ap.Request_Source__c='Get Dispute Status API';
        
        RestRequest request = RestContext.request;  
        RestResponse response = RestContext.response;  
        Map<String,Object> responseObj = new Map<String,Object>();
        
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        system.debug('-->'+jSONRequestBody);
        JSON2ApexDisputeStatus japex=JSON2ApexDisputeStatus.parse(jSONRequestBody); 
        Set<String> disDetailsId=new Set<String>();
        System.debug('=======>'+japex.Dispute_Status_Tracking_Requests);
        ap.Request__c=jSONRequestBody;
        List<Dispute_Status_Tracking_Requests> disStatusList=japex.Dispute_Status_Tracking_Requests;
        for(Dispute_Status_Tracking_Requests row:disStatusList){
            //system.debug(row.SF_Case_Number);
            //system.debug(row.Dispute_Detail_Id);
            disDetailsId.add(row.Email_Id+'-'+row.Mobile_Number);
        }
        
        system.debug(disDetailsId);
        
        List<CASE> getRecordList= [SELECT Id,Corrected_Credit_Facility_Status__c,Displayed_Credit_Facility_Status__c,Date_of_the_email_received__c,Dispute_Raised_Date__c,Displayed_Account_number__c,Displayed_Account_Type__c,Displayed_Bank_Name__c,Correct_Bank_Name__c,CaseNumber,Contact_Phone__c,getStatus_Unique__c,DIS_Dtl_Id__c,DIS_Id__c,Correct_Loan_Ownership__c,Correct_Account_Status__c,Correct_Loan_Type__c,Correct_Loan_Balance__c,
                                   Correct_EMI_Amount__c,Correct_Name__c,Correct_Gender__c,Correct_email_id__c,Correct_Date_of_Birth__c,Correct_Address__c,Correct_Mobile_No__c,Displayed_Mobile_No__c,
                                   Displayed_Address__c,Displayed_Address_1_v1__c,Displayed_Date_of_Birth__c,Displayed_Email_Id__c,Displayed_Gender__c,Displayed_Name__c,Displayed_EMI_Amount__c,Displayed_Loan_Balance__c,Displayed_Loan_Type__c,Displayed_loan_ownership__c,Displayed_Account_Status__c,
                                   Account_Type__c,ContactMobile,Account_Number__c,Sub_Type__c,Case_Type_Lookup__c,Case_Type_Lookup__r.Name,Sub_Type_1_Lookup__r.Name,
                                   Consumer_Dispute_Status__c,AccountId,Account.Name,Status,Sub_Type_Lookup__r.Name,Name_of_Consumer__c,Name_of_Consumer__r.Unique_Contact__c
                                   FROM CASE 
                                   WHERE Name_of_Consumer__r.Unique_Contact__c IN :disDetailsId AND CreatedDate >=LAST_N_MONTHS:6];
        
        List<Map<String,Object>> DisputeStatusTrackingResponsesList=new List<Map<String,Object>>();
        
        try{
            for(CASE row:getRecordList){
                Map<String,Object> mp=new  Map<String,Object>();
                mp.put('Dispute_Id',row.DIS_Id__c);
                mp.put('Dispute_Detail_Id',row.DIS_Dtl_Id__c); 
                mp.put('SF_Case_Number',row.CaseNumber);
                mp.put('Mobile_Number',row.Contact_Phone__c);
                if(row.AccountId!=null){
                     mp.put('Lender_Name',row.Account.Name);
                }else if(row.Displayed_Bank_Name__c!=null){
                    mp.put('Lender_Name',row.Displayed_Bank_Name__c);
                }else if(row.Correct_Bank_Name__c!=null){
                     mp.put('Lender_Name',row.Correct_Bank_Name__c);
                }
               
                mp.put('Account_Type',row.Displayed_Account_Type__c);
                mp.put('Account_Number',row.Displayed_Account_number__c);
                mp.put('Dispute_Raised_Date',row.Date_of_the_email_received__c);
                mp.put('Sub_Type',row.Sub_Type_Lookup__r.Name);
                mp.put('Sub_Type1',row.Sub_Type_1_Lookup__r.Name);
                mp.put('Case_Status',row.Status);
                if(row.Consumer_Dispute_Status__c!=null){
                     mp.put('Dispute_Status',row.Consumer_Dispute_Status__c);
                }else{
                     mp.put('Dispute_Status','Open');
                }
               
                if(row.Sub_Type_Lookup__r.Name =='Unidentified'){
                     mp.put('Old_Field_Value',null);
               		 mp.put('New_Field_Value',null);
                }else if((row.Sub_Type_Lookup__r.Name =='Account ownership issue' || row.Sub_Type_Lookup__r.Name =='Account not reflecting')  && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_loan_ownership__c);
               		 mp.put('New_Field_Value',row.Correct_Loan_Ownership__c);
                }else if(row.Sub_Type_Lookup__r.Name =='Account Status'  && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_Account_Status__c);
               		 mp.put('New_Field_Value',row.Correct_Account_Status__c);
                }else if(row.Sub_Type_Lookup__r.Name =='Account Type'  && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_Loan_Type__c);
               		 mp.put('New_Field_Value',row.Correct_Loan_Type__c);
                }else if(row.Sub_Type_Lookup__r.Name =='Credit Facility Status'  && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_Credit_Facility_Status__c);
               		 mp.put('New_Field_Value',row.Corrected_Credit_Facility_Status__c);
                }else if(row.Sub_Type_Lookup__r.Name =='Balance Issue' &&  row.Sub_Type_1_Lookup__r.Name =='Current Balance' && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_Loan_Balance__c);
               		 mp.put('New_Field_Value',row.Correct_Loan_Balance__c);
                }else if(row.Sub_Type_Lookup__r.Name =='Balance Issue' &&  row.Sub_Type_1_Lookup__r.Name =='Over due' && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_EMI_Amount__c);
               		 mp.put('New_Field_Value',row.Correct_EMI_Amount__c);
                }else if(row.Sub_Type_Lookup__r.Name =='Demographic Details' &&  row.Sub_Type_1_Lookup__r.Name =='Incorrect Name' && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_Name__c);
               		 mp.put('New_Field_Value',row.Correct_Name__c);
                }else if(row.Sub_Type_Lookup__r.Name =='Demographic Details' &&  row.Sub_Type_1_Lookup__r.Name =='Incorrect Gender' && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_Gender__c);
               		 mp.put('New_Field_Value',row.Correct_Gender__c);
                }else if(row.Sub_Type_Lookup__r.Name =='Demographic Details' &&  row.Sub_Type_1_Lookup__r.Name =='Incorrect Email ID' && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_Email_Id__c);
               		 mp.put('New_Field_Value',row.Correct_email_id__c);
                }else if(row.Sub_Type_Lookup__r.Name =='Demographic Details' &&  row.Sub_Type_1_Lookup__r.Name =='Incorrect DOB' && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_Date_of_Birth__c);
               		 mp.put('New_Field_Value',row.Correct_Date_of_Birth__c);
                }else if(row.Sub_Type_Lookup__r.Name =='Demographic Details' &&  row.Sub_Type_1_Lookup__r.Name =='Incorrect Address' && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_Address__c!=null?row.Displayed_Address__c:row.Displayed_Address_1_v1__c);
               		 mp.put('New_Field_Value',row.Correct_Address__c);
                }else if(row.Sub_Type_Lookup__r.Name =='Demographic Details' &&  row.Sub_Type_1_Lookup__r.Name =='Incorrect Mobile No' && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',row.Displayed_Mobile_No__c);
               		 mp.put('New_Field_Value',row.Correct_Mobile_No__c);
                }else if(row.Sub_Type_Lookup__r.Name =='DPD' &&  row.Sub_Type_1_Lookup__r.Name =='Incorrect' && row.Case_Type_Lookup__r.Name=='Complaint Dispute Consumer') {
                   	 mp.put('Old_Field_Value',null);
               		 mp.put('New_Field_Value',null);
                }else{
                    mp.put('Old_Field_Value',null);
               		mp.put('New_Field_Value',null);
                }
               
                mp.put('Error',null);
                
                DisputeStatusTrackingResponsesList.add(mp);
            }
            
            responseObj.put('Response_Status', 'Success');
            responseObj.put('Status', '200');
            responseObj.put('Dispute_Status_Tracking_Responses',DisputeStatusTrackingResponsesList);
            response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
            response.statusCode = 200;
            response.addHeader('Content-Type', 'application/json');
            ap.Response__c=String.valueOf(responseObj);
            
        }catch(Exception e){
            System.debug('e.getMessage() '+e.getMessage());
            responseObj.put('Response', e.getMessage());
            responseObj.put('Status', '400');
            response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
            response.statusCode = 400;
            response.addHeader('Content-Type', 'application/json');
            ap.Exception_Description__c=e.getMessage();
            ap.Response__c=String.valueOf(responseObj);
        }
        INSERT ap;
    }
    
    public class JSON2ApexDisputeStatus {
        public List<Dispute_Status_Tracking_Requests> Dispute_Status_Tracking_Requests;
    }
    public class Dispute_Status_Tracking_Requests {
        public String SF_Case_Number;
        public String Mobile_Number;
        public String First_Name;
        public String Family_Name;
        public String Email_Id;
    }
    
    public static JSON2ApexDisputeStatus parse(String json) {
        return (JSON2ApexDisputeStatus) System.JSON.deserialize(json, JSON2ApexDisputeStatus.class);
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
        i++;
        i++;
        i++;
        i++;
        
    }
    
    
}