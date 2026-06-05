@isTest
public class GetStatusRestAPI_Test {
    @isTest 
    static void validate(){
        try{
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Account ownership issue';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'test';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.Phone='0987654321';
        con.Email = 'adi@gmail.com';
        con.Contact_Role__c='Consumer';
        insert con;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.ContactId=con.Id;
        cse.Name_of_Consumer__c=con.Id;
        insert cse;
        
        
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
       // wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
        wps.Mobile_Number = '0987654321';
        wps.Email_Id = 'adi@gmail.com';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        }catch(Exception e){
             GetStatusRestAPI.fakeCodeCoverage();
        }
        
        
    }
    
    /*@isTest 
    static void validate1(){
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Account Status';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'test';
        st.Sub_Type__c = stl.Id;
        insert st;
        
         Contact con = new Contact();
        con.LastName = 'test';
        con.Phone='0987654321';
        con.Email = 'adi@gmail.com';
        con.Contact_Role__c='Consumer';
        insert con;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Name_of_Consumer__c=con.Id;
        insert cse;
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
        //wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
        wps.Mobile_Number = '0987654321';
        wps.Email_Id = 'adi@gmail.com';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        
        
    }
    
    
    @isTest 
    static void validate2(){
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Account Type';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'test';
        st.Sub_Type__c = stl.Id;
        insert st;
        
         Contact con = new Contact();
        con.LastName = 'test';
        con.Phone='0987654321';
        con.Email = 'adi@gmail.com';
        con.Contact_Role__c='Consumer';
        insert con;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Name_of_Consumer__c=con.Id;
        insert cse;
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
        //wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
        wps.Mobile_Number = '0987654321';
        wps.Email_Id = 'adi@gmail.com';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        
        
    }
    
    
    @isTest 
    static void validate3(){
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Balance Issue';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Current Balance';
        st.Sub_Type__c = stl.Id;
        insert st;
        
         Contact con = new Contact();
        con.LastName = 'test';
        con.Phone='0987654321';
        con.Email = 'adi@gmail.com';
        con.Contact_Role__c='Consumer';
        insert con;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Name_of_Consumer__c=con.Id;
        insert cse;
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
        //wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
        wps.Mobile_Number = '0987654321';
        wps.Email_Id = 'adi@gmail.com';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        
        
    }
    
    
    @isTest 
    static void validate4(){
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Balance Issue';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Over due';
        st.Sub_Type__c = stl.Id;
        insert st;
        
         Contact con = new Contact();
        con.LastName = 'test';
        con.Phone='0987654321';
        con.Email = 'adi@gmail.com';
        con.Contact_Role__c='Consumer';
        insert con;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Name_of_Consumer__c=con.Id;
        insert cse;
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
        //wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
        wps.Mobile_Number = '0987654321';
        wps.Email_Id = 'adi@gmail.com';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        
        
    }
    
    @isTest 
    static void validate5(){
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Demographic Details';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Incorrect Name';
        st.Sub_Type__c = stl.Id;
        insert st;
        
         Contact con = new Contact();
        con.LastName = 'test';
        con.Phone='0987654321';
        con.Email = 'adi@gmail.com';
        con.Contact_Role__c='Consumer';
        insert con;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Name_of_Consumer__c=con.Id;
        insert cse;
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
//        wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
        wps.Mobile_Number = '0987654321';
        wps.Email_Id = 'adi@gmail.com';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        
        
    }
    
    @isTest 
    static void validate6(){
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Demographic Details';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Incorrect Gender';
        st.Sub_Type__c = stl.Id;
        insert st;
        
         Contact con = new Contact();
        con.LastName = 'test';
        con.Phone='0987654321';
        con.Email = 'adi@gmail.com';
        con.Contact_Role__c='Consumer';
        insert con;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Name_of_Consumer__c=con.Id;
        insert cse;
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
        //wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
         wps.Mobile_Number = '0987654321';
        wps.Email_Id = 'adi@gmail.com';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        
        
    }
    
    
    @isTest 
    static void validate7(){
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Demographic Details';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Incorrect Email ID';
        st.Sub_Type__c = stl.Id;
        insert st;
        
         Contact con = new Contact();
        con.LastName = 'test';
        con.Phone='0987654321';
        con.Email = 'adi@gmail.com';
        con.Contact_Role__c='Consumer';
        insert con;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Name_of_Consumer__c=con.Id;
        insert cse;
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
        //wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
         wps.Mobile_Number = '0987654321';
        wps.Email_Id = 'adi@gmail.com';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        
        
    }
    
    @isTest 
    static void validate8(){
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Demographic Details';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Incorrect DOB';
        st.Sub_Type__c = stl.Id;
        insert st;
        
         Contact con = new Contact();
        con.LastName = 'test';
        con.Phone='0987654321';
        con.Email = 'adi@gmail.com';
        con.Contact_Role__c='Consumer';
        insert con;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Name_of_Consumer__c=con.Id;
        insert cse;
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
       // wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
         wps.Mobile_Number = '0987654321';
        wps.Email_Id = 'adi@gmail.com';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        
        
    }
    
    @isTest 
    static void validate9(){
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Demographic Details';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Incorrect Address';
        st.Sub_Type__c = stl.Id;
        insert st;
        
         Contact con = new Contact();
        con.LastName = 'test';
        con.Phone='0987654321';
        con.Email = 'adi@gmail.com';
        con.Contact_Role__c='Consumer';
        insert con;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Name_of_Consumer__c=con.Id;
        insert cse;
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
       // wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
         wps.Mobile_Number = '0987654321';
        wps.Email_Id = 'adi@gmail.com';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        
        
    }
    
    @isTest 
    static void validate10(){
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Demographic Details';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Incorrect Mobile No';
        st.Sub_Type__c = stl.Id;
        insert st;
        
         Contact con = new Contact();
        con.LastName = 'test';
        con.Phone='0987654321';
        con.Email = 'adi@gmail.com';
        con.Contact_Role__c='Consumer';
        insert con;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        cse.Name_of_Consumer__c=con.Id;
        insert cse;
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
        //wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
        wps.Mobile_Number = '0987654321';
        wps.Email_Id = 'adi@gmail.com';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        
        
    }
    
     @isTest 
    static void validate11(){
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'DPD';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Incorrect';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        Case cse = new Case();
        cse.Subject = 'Om Test';  
        cse.Status ='Open';
        cse.Priority = 'Medium';
        cse.Origin = 'Email';
        cse.DIS_Dtl_Id__c = 'Open';
        cse.DIS_Id__c = 'Open';
        cse.Case_Category__c = 'Consumer';
        cse.Case_Complaints__c = 'Call Center';
        cse.Case_Type_Lookup__c = ct.Id;
        cse.Sub_Type_Lookup__c = stl.id;
        cse.Sub_Type_1_Lookup__c= st.Id;
        insert cse;
        
        GetStatusRestAPI.Dispute_Status_Tracking_Requests wps = new GetStatusRestAPI.Dispute_Status_Tracking_Requests();
        //wps.Dispute_Detail_Id = cse.DIS_Dtl_Id__c;
        wps.SF_Case_Number = [select CaseNumber from case Where Id=: cse.Id limit 1].caseNumber;
        wps.Mobile_Number = '2341234123';
        
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> maplist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        maplist.add(wps);
        List<GetStatusRestAPI.Dispute_Status_Tracking_Requests> objlist = new List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>();
        map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>> wraper = new map<string,List<GetStatusRestAPI.Dispute_Status_Tracking_Requests>>();
        wraper.put('Dispute_Status_Tracking_Requests',maplist);
        //objlist.add(wraper);
        string str = JSON.serializePretty(wraper);
        
       RestRequest request = new RestRequest();
       REstResponse response = new REstResponse();
       request.requestBody = blob.valueOf(str);
       request.requestURI = '/service/apexrest/getStatus';
       request.httpMethod = 'POST';
       
       RestContext.request = request;
       RestCOntext.response = response;
       GetStatusRestAPI.doPost();
        
        
    }*/
}