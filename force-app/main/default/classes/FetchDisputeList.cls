@RestResource(urlMapping='/fetchDisputeList/*')
global without sharing class FetchDisputeList {
 @HttpPost 
    global static void doPost(){
        
        API_LOG__c ap=new API_LOG__c();
        ap.Request_Source__c='fetchDisputeList Correx';
        RestRequest request = RestContext.request;  
        RestResponse response = RestContext.response;  
        Map<String,Object> responseObj = new Map<String,Object>();
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        ap.Request__c=jSONRequestBody;
        fromRequest japex=fromRequest.parse(jSONRequestBody); 
        try{
            Id bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;
            Map<String, Schema.SObjectField> fieldMap = CASE.sObjectType.getDescribe().fields.getMap();
            List < string > conditions = new List < string > ();
            // Get all of the fields on the object
            Set<String> setFieldNames = fieldMap.keySet();
            list<String> lstFieldNames = new List<String>(setFieldNames);
            
            // Dynamic Query String.
            String strQuery = 'SELECT Name_of_Consumer__r.Name,Account.Name,Sub_Type_Lookup__r.Name,Account.Bureau_Member_Id__c,Sub_Type_1_Lookup__r.Name, ' + String.join(lstFieldNames, ',') + ' FROM Case';
            
            if (japex.Bureau_Member_Id != null && japex.Bureau_Member_Id != '') {
                conditions.add('Account.Bureau_Member_Id__c Like \'%' + japex.Bureau_Member_Id + '%\' ');
            }
             if (japex.Account_Number != null && japex.Account_Number != '') {
                conditions.add('Displayed_Account_number__c = \'' + japex.Account_Number + '\'');
            }
             if (japex.SF_Case_Id != null && japex.SF_Case_Id != '') {
                conditions.add('CaseNumber = \'' + japex.SF_Case_Id + '\'');
            }
            if(Boolean.valueOf(Label.FetchDisputeList)){
                
            
             if (japex.Dispute_Creation_Date_Start != null && japex.Dispute_Creation_Date_Start != '') { //20/09/1991 - dd/mm/yyyy
                 Date cust=Date.parse(japex.Dispute_Creation_Date_Start);
                conditions.add('Date_of_the_email_received__c  >=:cust');
            }
              if (japex.Dispute_Creation_Date_End != null && japex.Dispute_Creation_Date_End != '') {
                  Date cust=Date.parse(japex.Dispute_Creation_Date_End);
                conditions.add('Date_of_the_email_received__c  <=:cust ');
            }
             if (japex.SF_Case_Creation_Date_Start != null && japex.SF_Case_Creation_Date_Start != '') {
                 Date cust=Date.parse(japex.SF_Case_Creation_Date_Start);
                conditions.add('CreatedDate >=: cust');
            }
             if (japex.SF_Case_Creation_Date_End != null && japex.SF_Case_Creation_Date_End != '') {
                 Date cust=Date.parse(japex.SF_Case_Creation_Date_End);
                conditions.add('CreatedDate <=: cust');
            }
            }
            
            if (conditions.size() > 0) {
                strQuery += '  WHERE OwnerId =:bankteamId AND ' + conditions[0];
                for (Integer i = 1; i < conditions.size(); i++){
                     strQuery += '  AND ' + conditions[i];
                }
                   
            }
            
           
            // add sort and limits at the end  
            strQuery += '  ORDER By CreatedDate DESC LIMIT 50000'; 
            system.debug('strQuery ==> ' + strQuery);
            
            List < Case > getRecordList = Database.query(strQuery);
             List<Map<String,Object>> DisputeStatusTrackingResponsesList=new List<Map<String,Object>>();
            for(Case row:getRecordList){
                Map<String,Object> mp=new  Map<String,Object>();
                mp.put('sfCaseId',row.CaseNumber);
                mp.put('accountNumber',row.Displayed_Account_number__c);
                mp.put('mobileNumber',row.ContactMobileNo__c);
                mp.put('bureauMemberId',row.Account.Bureau_Member_Id__c);
                mp.put('bureauMemberName',row.Account.Name);
                mp.put('subType',row.Sub_Type_Lookup__r.Name);
                mp.put('subType1',row.Sub_Type_1_Lookup__r.Name);
                mp.put('disputeId',row.DIS_Id__c);
                mp.put('disputeDetailId',row.DIS_Dtl_Id__c);
                mp.put('caseStatus',row.Status);
                mp.put('disputeStatus',row.Consumer_Dispute_Status__c);
                mp.put('sfCaseCreationDate',row.CreatedDate);
                mp.put('disputeCreationDate',row.Dis_Date__c);
                mp.put('memberAssignmentdDate',row.Forward_to_Bank_Date__c);
                mp.put('Consumer_Name',row.Contact_Name__c);
                DisputeStatusTrackingResponsesList.add(mp);
            }
            responseObj.put('currentDate',Date.today());
            responseObj.put('disputeListRefreshTransactionId',null);
            responseObj.put('sfdisputeListResponses',DisputeStatusTrackingResponsesList);
            responseObj.put('Response_Status', 'Success');
            responseObj.put('Status', '200');
            response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
            response.statusCode = 200;
            response.addHeader('Content-Type', 'application/json');
            ap.Response__c=String.valueOf(responseObj);
        }catch(Exception e){
            System.debug('e.getMessage() '+e.getMessage());
            responseObj.put('Response_Status', e.getMessage());
            responseObj.put('Status', '400');
            response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
            response.statusCode = 400;
            response.addHeader('Content-Type', 'application/json');
            ap.Exception_Description__c=e.getMessage();
            ap.Response__c=String.valueOf(responseObj);
        }
        insert ap;
    }
    
    public class fromRequest{
        public String Bureau_Member_Id;	//
        public String Account_Number;	//
        public String SF_Case_Id;	//
        public String Dispute_Creation_Date_Start;	//
        public String Dispute_Creation_Date_End;	//
        public String SF_Case_Creation_Date_Start;	//
        public String SF_Case_Creation_Date_End;	//
    }
	public static fromRequest parse(String json){
		return (fromRequest) System.JSON.deserialize(json, fromRequest.class);
	}
}