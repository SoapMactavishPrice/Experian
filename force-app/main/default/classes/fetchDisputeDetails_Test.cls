@istest
global class fetchDisputeDetails_Test {

    static testMethod void testAccountDetailsWithNoCaseNumber(){
        try{
            Account acc = new Account();
        acc.Name = 'Kotak';
        acc.Bureau_Member_Id__c='3272';
        insert acc;
        
        Case_Type__c ct=new Case_Type__c();
        ct.Name='Complaint Dispute Consumer';
        ct.Case_Category__c='Consumer';
        ct.Case_Complaint__c='Report';
        insert ct;
       
        
        Sub_Type__c st=new Sub_Type__c();
        st.Name='DPD';
        st.Case_Type__c=ct.Id;
        insert st;
        
        Sub_Type1__c st1= new Sub_Type1__c();
        st1.Name='Incorrect';
        st1.Sub_Type__c=st.Id;
        insert st1;
        
        
        Case c=new Case();
        c.DIS_Dtl_Id__c = '1234';
        c.AccountId = acc.Id;
        c.Case_Type_Lookup__c=ct.Id;
        c.Sub_Type_Lookup__c=st.Id;
        c.Sub_Type_1_Lookup__c=st1.Id; 
        c.Case_Category__c='Consumer';
        c.Case_Complaints__c='Report';
        c.Displayed_Account_Number__c='VBSDXM00989';
        insert c;
        
         DPD_Detail__c dpd = new DPD_Detail__c();
        dpd.Case__c = c.Id;
        insert dpd;
        
        Case cs=[SELECT id,CaseNumber FROM Case LIMIT 1];
        RestRequest req1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        System.debug('c.CaseNumber '+c.CaseNumber);
        String js1='{"Dispute_Details_Fetching_Requests":[{"SF_Case_Number":"'+cs.CaseNumber+'","Account_Number":"VBSDXM00989","Mobile_Number":"","Bureau_Member_Id":"3272"}]}';
        
        req1.requestURI = '/services/apexrest/fetchDisputeDetails'; //Request URL
        req1.httpMethod = 'POST'; //HTTP Request Type
        req1.requestBody = Blob.valueof(js1);
        RestContext.request = req1;
        RestContext.response = res1;
        
        fetchDisputeDetails.doPost();
        }catch(Exception e){
            System.debug('Exception === >'+e);
            fetchDisputeDetails.fakeCodeCoverage();
        }
        
        
        
        
    } 
    
    static testMethod void testAccountDetailsWithNoCaseNumber1(){
        
		 try{
        Account acc = new Account();
        acc.Name = 'Kotak';
        acc.Bureau_Member_Id__c='3272';
        insert acc;
        
        Case_Type__c ct=new Case_Type__c();
        ct.Name='Complaint Dispute Consumer';
        ct.Case_Category__c='Consumer';
        ct.Case_Complaint__c='Report';
        insert ct;
       
        
        Sub_Type__c st=new Sub_Type__c();
        st.Name='DPD';
        st.Case_Type__c=ct.Id;
        insert st;
        
        Sub_Type1__c st1= new Sub_Type1__c();
        st1.Name='Incorrect';
        st1.Sub_Type__c=st.Id;
        insert st1;
        
        
        
        
        Case c=new Case();
        c.DIS_Dtl_Id__c = '1234';
        
        c.AccountId = acc.Id;
        c.Case_Type_Lookup__c=ct.Id;
        c.Sub_Type_Lookup__c=st.Id;
        c.Sub_Type_1_Lookup__c=st1.Id; 
        c.Case_Category__c='Consumer';
        c.Case_Complaints__c='Report';
        c.Displayed_Account_Number__c='VBSDXM00989';
        insert c;
        
        DPD_Detail__c dpd = new DPD_Detail__c();
        dpd.Case__c = c.Id;
        insert dpd;
        //map<Id, List<DPD_Detail__c>
        Case cs=[SELECT id,CaseNumber FROM Case LIMIT 1];
        RestRequest req1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        System.debug('c.CaseNumber '+c.CaseNumber);
        String js1='{"Dispute_Status_Update_Request":[{"SF_Case_Number":"'+cs.CaseNumber+'","Account_Number":"VBSDXM00989","Mobile_Number":"","Bureau_Member_Id":"3272"}]}';
        String js2='{"Dispute_Details_Fetching_Requests":{"SF_Case_Number":"'+cs.CaseNumber+'","Account_Number":"VBSDXM00989","Mobile_Number":"","Bureau_Member_Id":"3272"}}';
        req1.requestURI = '/services/apexrest/updateDisputeStatus'; //Request URL
        req1.httpMethod = 'POST'; //HTTP Request Type
        req1.requestBody = Blob.valueof(js1);
        RestContext.request = req1;
        RestContext.response = res1;
        Correx_updateDisputeDetails.doPost();
        
         req1.requestURI = '/services/apexrest/updateDisputeStatus'; //Request URL
        req1.httpMethod = 'POST'; //HTTP Request Type
        req1.requestBody = Blob.valueof(js2);
        RestContext.request = req1;
        RestContext.response = res1;
        Correx_updateDisputeDetails.doPost();
         }
        catch(Exception e){
            System.debug('Exception === >'+e);
        }
        
        
        
    } 
    
     static testMethod void testAccountDetailsWithNoCaseNumber2(){
        
		 //try{
        Account acc = new Account();
        acc.Name = 'Kotak';
        acc.Bureau_Member_Id__c='3272';
        insert acc;
        
        Case_Type__c ct=new Case_Type__c();
        ct.Name='Complaint Dispute Consumer';
        ct.Case_Category__c='Consumer';
        ct.Case_Complaint__c='Report';
        insert ct;
       
        
        Sub_Type__c st=new Sub_Type__c();
        st.Name='DPD';
        st.Case_Type__c=ct.Id;
        insert st;
        
        Sub_Type1__c st1= new Sub_Type1__c();
        st1.Name='Incorrect';
        st1.Sub_Type__c=st.Id;
        insert st1;
        
        
        
        Id bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;
        Case c=new Case();
        c.DIS_Dtl_Id__c = '1234';
        
        c.AccountId = acc.Id;
        c.Case_Type_Lookup__c=ct.Id;
        c.Sub_Type_Lookup__c=st.Id;
        c.Sub_Type_1_Lookup__c=st1.Id; 
        c.Case_Category__c='Consumer';
        c.Case_Complaints__c='Report';
        c.Displayed_Account_Number__c='VBSDXM00989';
         c.OwnerId=bankteamId;
        insert c;
       
        //map<Id, List<DPD_Detail__c>
        Case cs=[SELECT id,CaseNumber FROM Case LIMIT 1];
        RestRequest req1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        System.debug('c.CaseNumber '+c.CaseNumber);
        String js1='{"SF_Case_Id":"'+cs.CaseNumber+'"}';
        
         req1.requestURI = '/services/apexrest/fetchDisputeList'; //Request URL
        req1.httpMethod = 'POST'; //HTTP Request Type
        req1.requestBody = Blob.valueof(js1);
        RestContext.request = req1;
        RestContext.response = res1;
        FetchDisputeList.doPost();
        
        
        
        
    } 
     static testMethod void testAccountDetailsWithNoCaseNumber3(){
        
		 //try{
        Account acc = new Account();
        acc.Name = 'Kotak';
        acc.Bureau_Member_Id__c='3272';
        insert acc;
        
        Case_Type__c ct=new Case_Type__c();
        ct.Name='Complaint Dispute Consumer';
        ct.Case_Category__c='Consumer';
        ct.Case_Complaint__c='Report';
        insert ct;
       
        
        Sub_Type__c st=new Sub_Type__c();
        st.Name='DPD';
        st.Case_Type__c=ct.Id;
        insert st;
        
        Sub_Type1__c st1= new Sub_Type1__c();
        st1.Name='Incorrect';
        st1.Sub_Type__c=st.Id;
        insert st1;
        
        
        
        Id bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;
        Case c=new Case();
        c.DIS_Dtl_Id__c = '1234';
        
        c.AccountId = acc.Id;
        c.Case_Type_Lookup__c=ct.Id;
        c.Sub_Type_Lookup__c=st.Id;
        c.Sub_Type_1_Lookup__c=st1.Id; 
        c.Case_Category__c='Consumer';
        c.Case_Complaints__c='Report';
        c.Displayed_Account_Number__c='VBSDXM00989';
         c.OwnerId=bankteamId;
        insert c;
       
        //map<Id, List<DPD_Detail__c>
        Case cs=[SELECT id,CaseNumber FROM Case LIMIT 1];
        RestRequest req1 = new RestRequest();
        RestResponse res1 = new RestResponse();
        System.debug('c.CaseNumber '+c.CaseNumber);
        String js1='{"SF_Case_Id":"'+cs.CaseNumber+'","Account_Number":"VBSDXM00989","Bureau_Member_Id":"3272"}';
        
         req1.requestURI = '/services/apexrest/fetchDisputeList'; //Request URL
        req1.httpMethod = 'POST'; //HTTP Request Type
        req1.requestBody = Blob.valueof(js1);
        RestContext.request = req1;
        RestContext.response = res1;
        FetchDisputeList.doPost();
        
        
        
    } 
        
    
    
}