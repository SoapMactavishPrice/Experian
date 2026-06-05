@RestResource(urlMapping='/updateDisputeStatus/*')
global class Correx_updateDisputeDetails {
    @HttpPost
    global static void doPost(){
        
        API_LOG__c ap=new API_LOG__c();
        ap.Request_Source__c='updateDisputeStatus Correx';
        RestRequest request = RestContext.request;  
        RestResponse response = RestContext.response;  
        Map<String,Object> responseObj = new Map<String,Object>();
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        ap.Request__c=jSONRequestBody;
        JSON2Apex japex=JSON2Apex.parse(jSONRequestBody); 
        try{
            //---------------------------request----------------------------
            List<Dispute_Status_Update_Request> reqList = japex.Dispute_Status_Update_Request;
            
            Set<String> correxUniqueIdentifier=new Set<String>();
            Map<String,String> caseIdsMap = new Map<String,String>();
            Set<String> correxUniqueIdentifierAccountNUmber=new Set<String>();
            for(Dispute_Status_Update_Request row:reqList){
                //correxUniqueIdentifier.add(row.SF_Case_Number+'-'+row.Account_Number+'-'+row.Mobile_Number+'-'+row.Bureau_Member_id);
                correxUniqueIdentifier.add(row.SF_Case_Number+'-'+row.Mobile_Number+'-'+row.Bureau_Member_id);
                correxUniqueIdentifierAccountNUmber.add(row.Account_Number);
                caseIdsMap.put(row.SF_Case_Number+'-'+row.Account_Number+'-'+row.Mobile_Number+'-'+row.Bureau_Member_id,row.Dispute_Status);
            }
            System.debug('caseIdsMap '+caseIdsMap);
            Map<String, Schema.SObjectField> fieldMap = CASE.sObjectType.getDescribe().fields.getMap();
            
            // Get all of the fields on the object
            Set<String> setFieldNames = fieldMap.keySet();
            list<String> lstFieldNames = new List<String>(setFieldNames);
            
            // Dynamic Query String.
            List<Case> getRecordList = Database.query('SELECT Account.Bureau_Member_Id__c, ' + String.join(lstFieldNames, ',') + ' FROM Case WHERE Correx_fetch_details_unique_identifier__c IN: correxUniqueIdentifier AND Displayed_Account_number__c IN:correxUniqueIdentifierAccountNumber');
            List<Case> caseListToUpdate=new List<Case>();
            for(Case row:getRecordList){
                System.debug('getRecordList '+row.CaseNumber+'-'+row.Displayed_Account_number__c);
                if(caseIdsMap.get(row.CaseNumber+'-'+row.Displayed_Account_number__c+'-'+row.Contact_Phone__c+'-'+row.Account.Bureau_Member_Id__c)!=null){  
                    if(caseIdsMap.get(row.CaseNumber+'-'+row.Displayed_Account_number__c+'-'+row.Contact_Phone__c+'-'+row.Account.Bureau_Member_Id__c) == 'Accept'){
                        row.Consumer_Dispute_Status__c='Resolved in favour of the Consumer';
                    } 
                    else if(caseIdsMap.get(row.CaseNumber+'-'+row.Displayed_Account_number__c+'-'+row.Contact_Phone__c+'-'+row.Account.Bureau_Member_Id__c) == 'Reject'){
                        row.Consumer_Dispute_Status__c='Resolved not in favour of the Consumer';
                        row.Rejection_Reason__c='Rejected by Lender';
                    }
                    caseListToUpdate.add(row);
                }
            }
            if(caseListToUpdate.size()>0){
                UPSERT caseListToUpdate;
            }
             System.debug('caseListToUpdate '+caseListToUpdate);
            Map<String,String> mpRec=new Map<String,String>();
            Database.UpsertResult[] results = Database.upsert(caseListToUpdate, false);
            for(Integer i = 0, size = results.size(); i < size; i++) {
                if (results.get(i).isSuccess()){
                    //results.get(i).getId();
            	mpRec.put(caseListToUpdate[i].CaseNumber+'-'+caseListToUpdate[i].Displayed_Account_number__c+'-'+caseListToUpdate[i].Contact_Phone__c+'-'+caseListToUpdate[i].Account.Bureau_Member_Id__c,'Success');
                }else if (!results.get(i).isSuccess()){
                    // DML operation failed
                    Database.Error error = results.get(i).getErrors().get(0);
                    String failedDML = error.getMessage();
                    mpRec.put(caseListToUpdate[i].CaseNumber+'-'+caseListToUpdate[i].Displayed_Account_number__c+'-'+caseListToUpdate[i].Contact_Phone__c+'-'+caseListToUpdate[i].Account.Bureau_Member_Id__c,failedDML);
                 }
            }
            
            List<Map<String,Object>> DisputeStatusList=new List<Map<String,Object>>(); 
            
            for(Dispute_Status_Update_Request row:reqList){
                Map<String,Object> mp=new  Map<String,Object>();
                mp.put('SF_Case_Number',row.SF_Case_Number);
                mp.put('Account_Number',row.Account_Number);
                mp.put('Mobile_Number',row.Mobile_Number);
                mp.put('Bureau_Member_id',row.Bureau_Member_id);
               
                if(caseIdsMap.get(row.SF_Case_Number+'-'+row.Account_Number+'-'+row.Mobile_Number+'-'+row.Bureau_Member_id)!=null){
                    mp.put('Updated_Dispute_Status',mpRec.get(row.SF_Case_Number+'-'+row.Account_Number+'-'+row.Mobile_Number+'-'+row.Bureau_Member_id));
                    
                }else{
                     mp.put('Updated_Dispute_Status','Status cannot be null');
                }
                DisputeStatusList.add(mp);
            }
            
            responseObj.put('Response_Status', 'Success');
            responseObj.put('Status', '200');
            responseObj.put('Dispute_Status_Update_Response',DisputeStatusList);
            response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
            response.statusCode = 200;
            response.addHeader('Content-Type', 'application/json');
            ap.Response__c=String.valueOf(responseObj);
        }catch(Exception e){
            System.debug('e.getMessage() '+e.getMessage());
            responseObj.put('Response_Status', e.getMessage());
            responseObj.put('Status', '400');
            responseObj.put('Dispute_Status_Update_Response',new List<Map<String,Object>>());
            response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
            response.statusCode = 400;
            response.addHeader('Content-Type', 'application/json');
            ap.Exception_Description__c=e.getMessage();
            ap.Response__c=String.valueOf(responseObj);
        }
        insert ap;
        
    }
    public class JSON2Apex {
        public List<Dispute_Status_Update_Request> Dispute_Status_Update_Request;
    }
    
    public class Dispute_Status_Update_Request {
        public String SF_Case_Number;
        public String Account_Number;
        public String Mobile_Number;
        public String Bureau_Member_id;
        public String Dispute_Status;
        
    }
    public static JSON2Apex parse(String json) {
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    }
}