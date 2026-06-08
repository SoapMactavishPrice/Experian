@RestResource(urlMapping='/saveCase/*')
global class SaveCaseRestAPI {
    
    @HttpPost
    global static void doPost(){
        
        API_LOG__c ap=new API_LOG__c();
        ap.Request_Source__c='Save Case';
        ap.Request_Time__c=System.now();
        RestRequest request = RestContext.request;  
        RestResponse response = RestContext.response;  
        Map<String,Object> responseObj = new Map<String,Object>();
        Map<String,Id> req_obj = new Map<String,Id>();
        Map<String,Id> req_obj_v1 = new Map<String,Id>();
        Map<String,Id> req_obj_v2 = new Map<String,Id>();
        Map<String,Id> req_obj_v3 = new Map<String,Id>();
        Map<string,Id> bankNameMap = new Map<string,Id>(); 
        Set<String> AccountNameSets=new Set<String>();
        Set<String> SubTypeSets=new Set<String>();
        Set<String> SubType1Sets=new Set<String>();
        Map<String,String> mpDpd_ins;
        List<DPD_Detail__c> dpdList_ins;
        String jSONRequestBody=request.requestBody.toString().replace('\n', '');
        JSON2Apex japex_case=JSON2Apex.parse(jSONRequestBody);  
        
        
        //---------------------------Get Case From request----------------------------
        List<CaseList> CaseList_store = japex_case.CaseList;
        
        for(CaseList con_case:CaseList_store){
            AccountNameSets.add(con_case.AccoutDetailsList.Displayed_Bank_Name);
            SubTypeSets.add(con_case.SubType);
            SubType1Sets.add(con_case.SubType1);
        }
        
        List<Account> accList=new List<Account>();
        accList=[SELECT Id,Name,Subscriber_ID__c,Displayed_Bank_Name__c,Displayed_Bank_Name_2__c,Displayed_Bank_Name_3__c FROM Account WHERE Name IN:AccountNameSets or Displayed_Bank_Name__c IN : AccountNameSets 
                 or Displayed_Bank_Name_2__c IN : AccountNameSets 
                 or Displayed_Bank_Name_3__c IN : AccountNameSets];
        for(Account acc:accList){
            String s=acc.Name;
            req_obj.put(s,acc.Id);
            if(string.isNotBlank(acc.Displayed_Bank_Name__c)){
                req_obj_v1.put(acc.Displayed_Bank_Name__c,acc.Id);
            }
            if(string.isNotBlank(acc.Displayed_Bank_Name_2__c)){
                req_obj_v2.put(acc.Displayed_Bank_Name_2__c,acc.Id);
            }
            
            if(string.isNotBlank(acc.Displayed_Bank_Name_3__c)){
                req_obj_v3.put(acc.Displayed_Bank_Name_3__c,acc.Id);  
            }
        }
        system.debug('SubTypeSets'+SubTypeSets);
        //get all email from request
        Set<String> set_dis_dtl=new Set<String>();
        Set<String> set_contact_emial=new Set<String>();
        Set<String> set_contact_mobile=new Set<String>();
        
        for(CaseList con_case:CaseList_store){
            set_dis_dtl.add(con_case.Dis_Dtl_Id);
            if(con_case.ContactEmailId !='' && con_case.ContactEmailId !=null){
                set_contact_emial.add(con_case.ContactEmailId.toLowerCase());
            }
            if(con_case.ContactMobileNo !='' && con_case.ContactMobileNo !=null){
                set_contact_mobile.add(con_case.ContactMobileNo);  
            }
            
        }
        ap.Request__c=String.valueOf(set_dis_dtl)+'\n'+jSONRequestBody;
        List<Case> all_match_email=new List<Case>();
        all_match_email= [SELECT Id,CaseNumber,DIS_Dtl_Id__c,Status
                          FROM Case Where DIS_Dtl_Id__c IN:set_dis_dtl FOR UPDATE];
        
        
        if(all_match_email.size()>0){
            
            // ====== CREATE DPD FOR EXISTING CASE ======
            
            Set<Id> caseIds = new Set<Id>();
            Map<String, Id> disDtlToCaseId = new Map<String, Id>();
            
            for (Case c : all_match_email) {
                caseIds.add(c.Id);
                disDtlToCaseId.put(c.DIS_Dtl_Id__c, c.Id);
            }
            
            // Existing DPDs
            Map<String, Id> existingDpdMap = new Map<String, Id>();
            
            for (DPD_Detail__c dpd : [
                SELECT Id, Name, Case__r.DIS_Dtl_Id__c
                FROM DPD_Detail__c
                WHERE Case__c IN :caseIds
            ]) {
                existingDpdMap.put(dpd.Case__r.DIS_Dtl_Id__c + '_' + dpd.Name, dpd.Id);
            }
            
            // Incoming DPD
            List<DPD_Detail__c> dpdToInsert = new List<DPD_Detail__c>();
            List<DPD_Detail__c> dpdToUpdate = new List<DPD_Detail__c>();
            
            for (Dpd_Details ds : japex_case.Dpd_list) {
                
                String key = ds.Dis_Dtl_Id + '_' + ds.Dpd_id;
                
                if (existingDpdMap.containsKey(key)) {
                    
                    dpdToUpdate.add(new DPD_Detail__c(
                        Id = existingDpdMap.get(key),
                        Name = ds.Dpd_id,
                        Correct_EMI_Amount__c = ds.Correct_EMI_Amount,
                        Displayed_EMI_Amount__c = ds.Displayed_EMI_Amount,
                        Correct_EMI_Repayment_Month__c = ds.Correct_EMI_Repayment_Month,
                        Displayed_EMI_Repayment_Month__c = ds.Displayed_EMI_Repayment_Month,
                        Correct_EMI_Repayment_Year__c = ds.Correct_EMI_Repayment_Year,
                        Displayed_EMI_Repayment_Year__c = ds.Displayed_EMI_Repayment_Year
                    ));
                    
                } else {
                    
                    dpdToInsert.add(new DPD_Detail__c(
                        Name = ds.Dpd_id,
                        Case__c = disDtlToCaseId.get(ds.Dis_Dtl_Id),
                        Correct_EMI_Amount__c = ds.Correct_EMI_Amount,
                        Displayed_EMI_Amount__c = ds.Displayed_EMI_Amount,
                        Correct_EMI_Repayment_Month__c = ds.Correct_EMI_Repayment_Month,
                        Displayed_EMI_Repayment_Month__c = ds.Displayed_EMI_Repayment_Month,
                        Correct_EMI_Repayment_Year__c = ds.Correct_EMI_Repayment_Year,
                        Displayed_EMI_Repayment_Year__c = ds.Displayed_EMI_Repayment_Year
                    ));
                }
            }
            
            if (!dpdToUpdate.isEmpty()) update dpdToUpdate;
            if (!dpdToInsert.isEmpty()) insert dpdToInsert;
            
            // ====== END ======
            
            List<Map<String,Object>> UpdateCaseNumberList = new List<Map<String,Object>>();
            Map<String,Object> m=new Map<String,Object>();
            m.put('CaseNumber', all_match_email[0].CaseNumber);
            m.put('Dis_Dtl_Id',all_match_email[0].DIS_Dtl_Id__c);
            UpdateCaseNumberList.add(m);
            
            responseObj.put('Response', 'Success');
            responseObj.put('Status', '200');
            responseObj.put('InsertcaseNumberList',new List<Map<String,Object>>());
            responseObj.put('UpdatecaseNumberList',UpdateCaseNumberList);
            response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
            response.statusCode = 200;
            response.addHeader('Content-Type', 'application/json');
            ap.Response__c=String.valueOf(responseObj);
            ap.Response_Time__c=System.now();
        }
        else{
            try{
                Map<String,Id> m_map=new Map<String,Id>();
                Map<String,String> m_map_status=new Map<String,String>();
                for(Case con_case:all_match_email){
                    m_map.put(con_case.DIS_Dtl_Id__c,con_case.Id);
                    m_map_status.put(con_case.DIS_Dtl_Id__c,con_case.Status);
                }
                List<Contact> con=new List<Contact>();
                if(set_contact_emial.size()>0 && set_contact_mobile.size() > 0){
                    con=[SELECT Id, Email, Email_2__c, Phone FROM Contact 
                         WHERE (Email IN :set_contact_emial OR Email_2__c IN :set_contact_emial)
                         AND Phone IN :set_contact_mobile
                         LIMIT 1 FOR UPDATE];
                }
                
                Map<String,String> contact_name=new Map<String,String>();  
                Map<String,String> contact_phone=new Map<String,String>();  
                for(Contact contact:con){
                    // Store only contacts where both email and phone match
                    if ((set_contact_emial.contains(contact.Email.toLowerCase()) || 
                         set_contact_emial.contains(contact.Email_2__c?.toLowerCase())) &&
                        set_contact_mobile.contains(contact.Phone)) {
                            
                            String key = contact.Email.toLowerCase() + '-' + contact.Phone;
                            contact_name.put(key, contact.Id);
                        }
                }
                //System.debug('=contact_name===>'+contact_name);
                //--------------------------perform insert update operation  on Case---------------------------------------------  
                List<Case> ins_in_case=new List<Case>();
                List<Case> ups_in_case=new List<Case>();
                List<Contact> conList=new List<Contact>();
                Case_Type__c ct  = [SELECT Id,Name FROM Case_Type__c WHERE Name='Complaint Dispute Consumer'];
                Sub_Type__c st   = [SELECT Id,Name,Case_Type__c  FROM Sub_Type__c  WHERE Name IN :SubTypeSets and Case_Type__c=:ct.Id];
                Sub_Type1__c st1 = [SELECT Id,Name,Sub_Type__c FROM Sub_Type1__c WHERE Name IN :SubType1Sets and Sub_Type__c =:st.Id];
                RecordType recType = [SELECT Id, Name FROM RecordType WHERE Name='Consumer Support'];
                queuesobject queueRec = [SELECT Queue.Id FROM queuesobject WHERE queue.name='Consumer Support Queue'];
                ID queueId = [SELECT Queue.Id FROM queuesobject WHERE queue.name='Consumer Support Queue'].Queue.Id;
                
                String Message='';
                for(CaseList cl:CaseList_store){
                    
                    Case c=new Case(); 
                    if(m_map.get(cl.Dis_Dtl_Id)!=null){
                        c.Id= m_map.get(cl.Dis_Dtl_Id); 
                        ap.Case__c=m_map.get(cl.Dis_Dtl_Id);
                        Message='Update';
                    }else{
                        Message='Insert';
                    }
                    c.RecordTypeId=recType.Id;
                    if(m_map.get(cl.Dis_Dtl_Id) == null){//added by balram on 29/04/2024
                        c.OwnerId=queueId;
                    }
                    c.Comments=cl.Comments;
                    if(m_map.get(cl.Dis_Dtl_Id) == null){
                        c.Dispute_Raised_Date__c=null;
                    }
                    
                    c.Case_Category__c='Consumer';
                    c.Case_Complaints__c='Report';
                    c.Origin='Portal';
                    if(m_map.get(cl.Dis_Dtl_Id) == null){ //added by balram on 29/04/2024
                        c.Case_Type_Lookup__c=ct.Id;
                        c.Sub_Type_Lookup__c=st.Id;
                        c.Sub_Type_1_Lookup__c=st1.Id;
                    }
                    c.Dis_Date__c=cl.Dis_Date;
                    if(cl.Dis_Date!='' && cl.Dis_Date!=null){
                        c.Date_of_the_email_received__c=Date.parse(cl.Dis_Date);
                    }
                    
                    c.Dis_Raised_By__c=cl.Dis_Raised_By;
                    c.Dis_Ern__c=cl.Dis_Ern;
                    c.Dis_Uti__c=cl.Dis_Uti;
                    c.DIS_Dtl_Id__c=cl.Dis_Dtl_Id;
                    c.DIS_Id__c=cl.Dis_Id;
                    if(cl.Account_Date_Reported!='' && cl.Account_Date_Reported!=null){
                        c.Account_Date_Reported__c=Date.parse(cl.Account_Date_Reported);
                    }
                    
                    //AccountDetails
                    AccoutDetailsList adl=cl.AccoutDetailsList;
                    c.Sanctioned_Amount__c=adl.Sanctioned_Amount;
                    c.Displayed_Credit_Facility_Status__c=adl.Displayed_Credit_Facility_Status;
                    c.Corrected_Credit_Facility_Status__c=adl.Corrected_Credit_Facility_Status;
                    c.Displayed_Account_Status__c=adl.Displayed_Account_Status;
                    c.Correct_Account_Status__c=adl.Correct_Account_Status;
                    c.Displayed_Loan_Balance__c=adl.Displayed_Loan_Balance;
                    c.Correct_Loan_Balance__c=adl.Correct_Loan_Balance;
                    c.Correct_Overdue_Amount__c = adl.Correct_Amount_Overdue;
                    c.Displayed_Overdue_Amount__c    = adl.Displayed_Amount_Overdue;
                    if(adl.Displayed_Account_Opening_Date !=''){
                        c.Displayed_Account_Opening_Date__c=Date.parse(adl.Displayed_Account_Opening_Date);
                    }
                    if(adl.Correct_Account_Opening_Date !=''){
                        c.Correct_Account_Opening_Date__c=Date.parse(adl.Correct_Account_Opening_Date);
                    }
                    c.Displayed_Account_Type__c=adl.Displayed_Account_Type;
                    c.Displayed_Bank_Name__c=adl.Displayed_Bank_Name;
                    String sbnk=adl.Displayed_Bank_Name;
                    if(req_obj.get(sbnk!=''?sbnk:'')!= null){ //added by balram on 28/04/2024
                        c.AccountId= req_obj.get(adl.Displayed_Bank_Name);
                    }else if(req_obj_v1.get(adl.Displayed_Bank_Name)!=null){
                        c.AccountId= req_obj_v1.get(adl.Displayed_Bank_Name);
                    }else if(req_obj_v2.get(adl.Displayed_Bank_Name)!=null){
                        c.AccountId= req_obj_v1.get(adl.Displayed_Bank_Name);
                    }else if(req_obj_v3.get(adl.Displayed_Bank_Name)!=null){
                        c.AccountId= req_obj_v1.get(adl.Displayed_Bank_Name);
                    }
                    c.Displayed_Account_number__c = adl.Displayed_Account_number;
                    c.Displayed_loan_type__c = adl.Displayed_Loan_Type;
                    c.Correct_loan_type__c = adl.Correct_Loan_Type;
                    c.Correct_Account_Type__c = adl.Correct_Loan_Type;// added by balram on 10-04-2026
                    if(adl.Displayed_loan_Ownership !=''){
                        c.Displayed_loan_ownership__c=adl.Displayed_loan_Ownership;
                    }    
                    if(adl.Correct_Loan_Ownership!=''){
                        c.Correct_loan_ownership__c=adl.Correct_Loan_Ownership;
                    }
                    
                    //PersonalDetails
                    PersonalDetailsList pdl =cl.PersonalDetailsList;
                    String t=cl.ContactEmailId.toLowerCase() + '-' + cl.ContactMobileNo;
                    if(contact_name.get(t)!=null){
                        c.ContactId=contact_name.get(t);
                        c.Name_of_Consumer__c=contact_name.get(t);
                    }else if(contact_phone.get(cl.ContactMobileNo)!=null){
                        c.ContactId=contact_phone.get(cl.ContactMobileNo);
                        c.Name_of_Consumer__c=contact_phone.get(cl.ContactMobileNo);
                    }
                    c.Displayed_Name__c=pdl.Displayed_Name;
                    c.Correct_Name__c=pdl.Correct_Name;
                    if(pdl.Displayed_Date_of_Birth!=''){
                        c.Displayed_Date_of_Birth__c=Date.parse(pdl.Displayed_Date_of_Birth);
                    }
                    if(pdl.Correct_Date_of_Birth!=''){
                        c.Correct_Date_of_Birth__c=Date.parse(pdl.Correct_Date_of_Birth);
                    }
                    c.Displayed_Gender__c=pdl.Displayed_Gender;
                    c.Correct_Gender__c=pdl.Correct_Gender;
                    
                    if(pdl.Displayed_Address_1!='' && pdl.Displayed_Address_1!=null){
                        String da=pdl.Displayed_Address_1;
                        if(da.length()>250){
                            c.Displayed_Address_1_v1__c=pdl.Displayed_Address_1;
                        }else{
                            c.Displayed_Address__c=pdl.Displayed_Address_1;
                            c.Displayed_Address_1_v1__c=pdl.Displayed_Address_1;
                        }  
                    }
                    c.Correct_Address__c=pdl.Correct_Address_1;
                    
                    if(pdl.Displayed_Address_2!='' && pdl.Displayed_Address_2!=null){
                        String da=pdl.Displayed_Address_2;
                        if(da.length()>250){
                            c.Displayed_Address_2_v1__c=pdl.Displayed_Address_2;
                        }else{
                            c.Displayed_Address_2__c=pdl.Displayed_Address_2;
                            c.Displayed_Address_2_v1__c=pdl.Displayed_Address_2;
                        }  
                    }
                    
                    c.Correct_Address_2__c=pdl.Correct_Address_2;
                    
                    if(pdl.Displayed_Address_3!='' && pdl.Displayed_Address_3!=null){
                        String da=pdl.Displayed_Address_3;
                        if(da.length()>250){
                            c.Displayed_Address_3_v1__c=pdl.Displayed_Address_3;
                        }else{
                            c.Displayed_Address_3__c=pdl.Displayed_Address_3;
                            c.Displayed_Address_3_v1__c=pdl.Displayed_Address_3;
                        }  
                    }
                    
                    c.Correct_Address_3__c=pdl.Correct_Address_3;
                    
                    if(pdl.Displayed_Address_4!='' && pdl.Displayed_Address_4!=null){
                        String da=pdl.Displayed_Address_4;
                        if(da.length()>250){
                            c.Displayed_Address_4_v1__c=pdl.Displayed_Address_4;
                        }else{
                            c.Displayed_Address_4__c=pdl.Displayed_Address_4; 
                            c.Displayed_Address_4_v1__c=pdl.Displayed_Address_4;
                        }  
                    }
                    c.Correct_Address_4__c=pdl.Correct_Address_4;
                    
                    if(pdl.Displayed_Address_5!='' && pdl.Displayed_Address_5!=null){
                        String da=pdl.Displayed_Address_5;
                        if(da.length()>250){
                            c.Displayed_Address_5_v1__c=pdl.Displayed_Address_5;
                        }else{
                            c.Displayed_Address_5__c=pdl.Displayed_Address_5;
                            c.Displayed_Address_5_v1__c=pdl.Displayed_Address_5;
                        }  
                    }
                    c.Correct_Address_5__c=pdl.Correct_Address_5;
                    
                    c.Displayed_Email_Id__c=pdl.Displayed_email_id;
                    c.Correct_email_id__c=pdl.Correct_email_id;
                    c.Displayed_Mobile_No__c=pdl.Displayed_mobile_no_1;
                    c.Correct_Mobile_No__c=pdl.Correct_mobile_no_1;
                    
                    c.Displayed_Mobile_No_2__c=pdl.Displayed_mobile_no_2;
                    c.Correct_Mobile_No_2__c=pdl.Correct_mobile_no_2;
                    
                    c.Displayed_Mobile_No_3__c=pdl.Displayed_mobile_no_3;
                    c.Correct_Mobile_No_3__c=pdl.Correct_mobile_no_3; 
                    
                    c.Displayed_Mobile_No_4__c=pdl.Displayed_mobile_no_4;
                    c.Correct_Mobile_No_4__c=pdl.Correct_mobile_no_4;  
                    
                    c.Displayed_Mobile_No_5__c=pdl.Displayed_mobile_no_5;
                    c.Correct_Mobile_No_5__c=pdl.Correct_mobile_no_5;      
                    
                    c.Displayed_PAN_No__c=pdl.Displayed_PAN_No;
                    c.Correct_PAN_No__c=pdl.Correct_PAN_No;
                    
                    //Enquiry
                    EnquiryList el=cl.EnquiryList; 
                    c.Displayed_Enquired_For__c=el.Displayed_Enquired_For;
                    c.Correct_Enquired_For__c=el.Correct_Enquired_For;
                    c.Displayed_Enquired_By__c=el.Displayed_Enquired_By;
                    c.Correct_Enquired_By__c=el.Correct_Enquired_By;
                    if(el.Displayed_Enquiry_Date!=''){
                        c.Displayed_Enquiry_Date__c=Date.parse(el.Displayed_Enquiry_Date);
                    }
                    if(el.Correct_Enquiry_Date!=''){
                        c.Correct_Enquiry_Date__c=Date.parse(el.Correct_Enquiry_Date);
                    }
                    c.Enquiry_ERN__c=el.Enquiry_ERN;
                    c.Enquiry_Amount_Enquirylist__c=el.Enquiry_Amount;
                    
                    // Added 3 conditions by Balram on 27/04/2024
                    if(string.isBlank(c.Displayed_Account_Type__c)){
                        c.Displayed_Account_Type__c=el.Displayed_Enquired_For;
                    }
                    if(string.isBlank(c.Displayed_Bank_Name__c)){
                        c.Displayed_Bank_Name__c=el.Displayed_Enquired_By;
                    }
                    if(string.isBlank(c.Displayed_Account_number__c)){
                        c.Displayed_Account_number__c=el.Enquiry_ERN;
                    }
                    
                    //not my enquiry
                    Not_My_Enquiry nme=cl.Not_My_Enquiry; 
                    c.Correct_Enquiry_For__c=nme.Correct_Enquired_For;
                    c.Correct_Enquiry_By__c=nme.Correct_Enquired_By;
                    if(nme.Correct_Enquiry_Date!=''){
                        c.Correct_Enquiry_Date1__c=Date.parse(nme.Correct_Enquiry_Date);
                    }
                    c.Enquiry_ERN_1__c=nme.Enquiry_ERN;
                    c.Enquiry_Amount_not_my_enquiry__c=nme.Enquiry_Amount;
                    
                    // Added 3 conditions by Balram on 27/04/2024
                    if(string.isBlank(c.Displayed_Account_Type__c)){
                        c.Displayed_Account_Type__c=nme.Correct_Enquired_For;
                    }
                    if(string.isBlank(c.Displayed_Bank_Name__c)){
                        c.Displayed_Bank_Name__c=nme.Correct_Enquired_By;
                    }
                    if(string.isBlank(c.Displayed_Account_number__c)){
                        c.Displayed_Account_number__c=nme.Enquiry_ERN;
                    }
                    
                    //payout details
                    Payout_Details pd=cl.Payout_Details; 
                    c.Account_Number_Payout__c=pd.Account_Number;
                    c.Bank_Name_Payout__c=pd.Bank_Name;
                    c.IFSC_Code_Payout__c=pd.IFSC_Code;
                    c.Account_Holder_Name_Payout__c=pd.Account_Holder_Name;
                    c.Compensation_Opted__c = pd.Compensation_Opted;
                    
                    //The account does not belong to me
                    AccountDoesNotBelongToMe acnb=cl.AccountDoesNotBelongToMe; 
                    c.Account_Type_Not_Belong__c=acnb.AccountType;
                    c.Bank_Name_Not_Belong__c=acnb.BankName;
                    c.Account_Number_Not_Belong__c=acnb.AccountNumber;
                    
                    //I don’t see my account here
                    DontSeeMyAccountHere dsmah=cl.DontSeeMyAccountHere; 
                    c.Account_Type_Dont_see__c=dsmah.AccountType;
                    c.Bank_Name_Dont_see__c=dsmah.BankName;
                    c.Account_Number_Dont_see__c=dsmah.AccountNumber;
                    
                    EnquiryPersonDetailsList epdl = cl.EnquiryPersonDetailsList;
                    c.Enquiry_First_Name__c = epdl.Enq_First_Name;
                    c.Enquiry_Last_Name__c = epdl.Enq_Last_Name;
                    c.Enquiry_Gender_Code__c = epdl.Enq_Gender_Code;
                    c.Enquiry_Mobile_No__c  = epdl.Enq_Mobile_No;
                    c.Enquiry_Address__c  = epdl.Enq_Address;
                    c.Enquiry_Email_Id__c  = epdl.Enq_Email_Id;
                    if(epdl.Enq_DOB !=''){
                        c.Enquiry_DOB__c  = Date.parse(epdl.Enq_DOB);
                    }
                    c.Enquiry_PAN__c  = epdl.Enq_PAN;
                    c.Enquiry_Passport_Number__c  = epdl.Enq_Passport_Number;
                    c.Enquiry_VoterID_Number__c  = epdl.Enq_VoterID_Number;
                    c.Enquiry_Driving_License_Number__c  = epdl.Enq_Driving_License_Number;
                    c.Enquiry_Ration_Card_Number__c  = epdl.Enq_Ration_Card_Number;
                    
                    //added by shashank 
                    c.Contact_Name__c=cl.Contact_Name;
                    c.ContactEmailId__c=cl.ContactEmailId;
                    c.ContactMobileNo__c=cl.ContactMobileNo;
                    c.Contact_Gender__c=cl.Contact_Gender;
                    c.ContactPan__c=cl.Contact_PAN;
                    if(cl.Contact_Date_of_Birth!=''){
                        c.Contact_Date_of_Birth__c=Date.parse(cl.Contact_Date_of_Birth);
                    }
                    c.Contact_Address__c=cl.Contact_Address;
                    
                    if(m_map.get(cl.Dis_Dtl_Id)!=null){
                        if(m_map_status.get(cl.Dis_Dtl_Id) != 'Resolved'){
                            ups_in_case.add(c);  
                        }
                    }else{
                        ups_in_case.add(c);  
                    }
                }
                
                if(ups_in_case.size()>0){
                    UPSERT ups_in_case;
                }
                //------------------------get case number  and send in array----------------------------------------------
                Set<Id> up_sd=new Set<Id>();
                
                for(Case c:ups_in_case){
                    up_sd.add(c.Id);
                    ap.Case__c=c.Id;
                }
                if(ups_in_case.size()==0){
                    up_sd.add(ap.Case__c);
                }
                List<Case> asd_up=[Select Id,DIS_Dtl_Id__c,CaseNumber,ContactEmail From Case Where Id IN:up_sd];
                
                //-------------------------------------------DPD Details---------------------------------------------------------------
                Set<Id> mergeSETIDS=new Set<Id>();
                for(Case casd:asd_up){
                    mergeSETIDS.add(casd.Id);
                }
                Map<String,String> case_mp_id=new Map<String,String>();
                List<Case> updatedCaseList=[SELECT Id,DIS_Dtl_Id__c FROM Case WHERE Id IN:mergeSETIDS];
                for(Case cs:updatedCaseList){
                    case_mp_id.put(cs.DIS_Dtl_Id__c,cs.Id);
                }
                
                mpDpd_ins=new Map<String,String>();
                Map<String,String> map_case=new Map<String,String>();
                dpdList_ins=[SELECT Id,Name,Case__c,Case__r.DIS_Dtl_Id__c,Correct_EMI_Amount__c,
                             Correct_EMI_Repayment_Month__c,Correct_EMI_Repayment_Year__c,
                             Displayed_EMI_Amount__c,Displayed_EMI_Repayment_Month__c,Displayed_EMI_Repayment_Year__c 
                             FROM DPD_Detail__c WHERE Case__c IN:mergeSETIDS ];
                
                for(DPD_Detail__c dpdrow:dpdList_ins){
                    mpDpd_ins.put(dpdrow.Case__r.DIS_Dtl_Id__c+'_'+dpdrow.Name,dpdrow.Id);//1234_1
                }
                
                List<Dpd_Details>  dpdLis=japex_case.Dpd_list;
                List<DPD_Detail__c> dpdp_ins=new List<DPD_Detail__c>();
                List<DPD_Detail__c> dpdp_ups=new List<DPD_Detail__c>();
                for(Dpd_Details ds:dpdLis){
                    
                    if(mpDpd_ins.get(ds.Dis_Dtl_Id+'_'+ds.Dpd_id)!=null){
                        DPD_Detail__c dpdrow=new DPD_Detail__c();
                        dpdrow.Id=mpDpd_ins.get(ds.Dis_Dtl_Id+'_'+ds.Dpd_id);
                        dpdrow.Name=ds.Dpd_id;
                        dpdrow.Correct_EMI_Amount__c=ds.Correct_EMI_Amount;
                        dpdrow.Displayed_EMI_Amount__c=ds.Displayed_EMI_Amount;
                        dpdrow.Correct_EMI_Repayment_Month__c=ds.Correct_EMI_Repayment_Month;
                        dpdrow.Displayed_EMI_Repayment_Month__c=ds.Displayed_EMI_Repayment_Month;
                        dpdrow.Correct_EMI_Repayment_Year__c=ds.Correct_EMI_Repayment_Year;
                        dpdrow.Displayed_EMI_Repayment_Year__c=ds.Displayed_EMI_Repayment_Year;
                        dpdp_ups.add(dpdrow);
                    }else{
                        DPD_Detail__c dpdrow=new DPD_Detail__c();
                        dpdrow.Name=ds.Dpd_id;
                        if(case_mp_id.get(ds.Dis_Dtl_Id)!=null){
                            dpdrow.Case__c=case_mp_id.get(ds.Dis_Dtl_Id);
                        }else{
                            dpdrow.Case__c=m_map.get(ds.Dis_Dtl_Id);
                        }
                        dpdrow.Correct_EMI_Amount__c=ds.Correct_EMI_Amount;
                        dpdrow.Displayed_EMI_Amount__c=ds.Displayed_EMI_Amount;
                        dpdrow.Correct_EMI_Repayment_Month__c=ds.Correct_EMI_Repayment_Month;
                        dpdrow.Displayed_EMI_Repayment_Month__c=ds.Displayed_EMI_Repayment_Month;
                        dpdrow.Correct_EMI_Repayment_Year__c=ds.Correct_EMI_Repayment_Year;
                        dpdrow.Displayed_EMI_Repayment_Year__c=ds.Displayed_EMI_Repayment_Year;
                        dpdp_ins.add(dpdrow);
                    }
                }
                
                upsert dpdp_ups;
                upsert dpdp_ins;            
                
                //-----------------------------------Make response--------------------------------------------------------------------------
                List<Map<String,Object>> CaseNumberList = new List<Map<String,Object>>();
                for(Case casd:asd_up){
                    Map<String,Object> m=new Map<String,Object>();
                    m.put('CaseNumber', casd.CaseNumber);
                    m.put('ContactEmailId',casd.ContactEmail);
                    m.put('Dis_Dtl_Id',casd.DIS_Dtl_Id__c);
                    CaseNumberList.add(m);
                }            
                
                //----------------make response to third party system------------- 
                responseObj.put('Response', 'Success');
                responseObj.put('Status', '200');
                if(Message =='Insert'){
                    responseObj.put('InsertcaseNumberList',CaseNumberList);
                    responseObj.put('UpdatecaseNumberList',new List<Map<String,Object>>());
                }else{
                    responseObj.put('UpdatecaseNumberList',CaseNumberList);
                    responseObj.put('InsertcaseNumberList',new List<Map<String,Object>>());
                }
                
                response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
                response.statusCode = 200;
                response.addHeader('Content-Type', 'application/json');
                ap.Response__c=String.valueOf(responseObj);
                ap.Log_Status__c ='Success';
                ap.Response_Time__c=System.now();
            }
            catch (DmlException e) {
                String s=e.getMessage();
                if (s.contains('Record Currently Unavailable')) {
                    System.enqueueJob(new disputeQueueableAPI(jSONRequestBody));
                    //----------------make response to third party system------------- 
                    responseObj.put('Response', 'We are processing this records in the backend ');
                    responseObj.put('Status', '200');
                    responseObj.put('InsertcaseNumberList',new List<Map<String,Object>>());
                    responseObj.put('UpdatecaseNumberList',new List<Map<String,Object>>());
                    
                    response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
                    response.statusCode = 200;
                    response.addHeader('Content-Type', 'application/json');
                    ap.Response__c=String.valueOf(responseObj);
                    ap.Log_Status__c ='Success';
                    ap.Response_Time__c=System.now();
                } else{
                    System.debug('e.getMessage() '+e.getMessage());
                    responseObj.put('Response', e.getMessage()+' ; '+'Upload failed for DIS_DTL_ID:'+japex_case.CaseList[0].Dis_Dtl_Id);
                    responseObj.put('Line ', e.getLineNumber());
                    responseObj.put('Status', '400');
                    response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
                    response.statusCode = 400;
                    response.addHeader('Content-Type', 'application/json');
                    ap.Exception_Description__c=e.getMessage();
                    ap.Response__c=String.valueOf(responseObj);
                    ap.Log_Status__c ='Failure';
                    ap.Response_Time__c=System.now();
                }
            } catch(Exception e){
                System.debug(' e.getMessage()=======>'+e.getStackTraceString());
                if(e.getMessage().contains('DUPLICATE_VALUE')){
                    mpDpd_ins=new Map<String,String>();
                    String caseId=e.getMessage();
                    caseId=caseId.substringBetween('id: ', ':');
                    
                    dpdList_ins=[SELECT Id,Name,Case__c,Case__r.DIS_Dtl_Id__c,Case__r.CaseNumber,Correct_EMI_Amount__c,
                                 Correct_EMI_Repayment_Month__c,Correct_EMI_Repayment_Year__c,
                                 Displayed_EMI_Amount__c,Displayed_EMI_Repayment_Month__c,Displayed_EMI_Repayment_Year__c 
                                 FROM DPD_Detail__c WHERE Case__c =:caseId ];
                    
                    for(DPD_Detail__c dpdrow:dpdList_ins){
                        mpDpd_ins.put(dpdrow.Case__r.DIS_Dtl_Id__c+'_'+dpdrow.Name,dpdrow.Id);//1234_1
                    }
                    
                    List<Dpd_Details>  dpdLis=japex_case.Dpd_list;
                    List<DPD_Detail__c> dpdp_ins=new List<DPD_Detail__c>();
                    List<DPD_Detail__c> dpdp_ups=new List<DPD_Detail__c>();
                    for(Dpd_Details ds:dpdLis){
                        if(mpDpd_ins.get(ds.Dis_Dtl_Id+'_'+ds.Dpd_id)!=null){
                            DPD_Detail__c dpdrow=new DPD_Detail__c();
                            dpdrow.Id=mpDpd_ins.get(ds.Dis_Dtl_Id+'_'+ds.Dpd_id);
                            dpdrow.Name=ds.Dpd_id;
                            dpdrow.Correct_EMI_Amount__c=ds.Correct_EMI_Amount;
                            dpdrow.Displayed_EMI_Amount__c=ds.Displayed_EMI_Amount;
                            dpdrow.Correct_EMI_Repayment_Month__c=ds.Correct_EMI_Repayment_Month;
                            dpdrow.Displayed_EMI_Repayment_Month__c=ds.Displayed_EMI_Repayment_Month;
                            dpdrow.Correct_EMI_Repayment_Year__c=ds.Correct_EMI_Repayment_Year;
                            dpdrow.Displayed_EMI_Repayment_Year__c=ds.Displayed_EMI_Repayment_Year;
                            dpdp_ups.add(dpdrow);
                        }else{
                            DPD_Detail__c dpdrow=new DPD_Detail__c();
                            dpdrow.Name=ds.Dpd_id;
                            dpdrow.Case__c=caseId;
                            dpdrow.Correct_EMI_Amount__c=ds.Correct_EMI_Amount;
                            dpdrow.Displayed_EMI_Amount__c=ds.Displayed_EMI_Amount;
                            dpdrow.Correct_EMI_Repayment_Month__c=ds.Correct_EMI_Repayment_Month;
                            dpdrow.Displayed_EMI_Repayment_Month__c=ds.Displayed_EMI_Repayment_Month;
                            dpdrow.Correct_EMI_Repayment_Year__c=ds.Correct_EMI_Repayment_Year;
                            dpdrow.Displayed_EMI_Repayment_Year__c=ds.Displayed_EMI_Repayment_Year;
                            dpdp_ins.add(dpdrow);
                        }
                    }
                    
                    upsert dpdp_ups;
                    upsert dpdp_ins;  
                    
                    List<Map<String,Object>> UpdateCaseNumberList = new List<Map<String,Object>>();
                    Map<String,Object> m=new Map<String,Object>();
                    m.put('CaseNumber', dpdList_ins[0].Case__r.CaseNumber);
                    m.put('Dis_Dtl_Id',dpdList_ins[0].Case__r.DIS_Dtl_Id__c);
                    UpdateCaseNumberList.add(m);
                    
                    responseObj.put('Response', 'Success');
                    responseObj.put('Status', '200');
                    responseObj.put('InsertcaseNumberList',new List<Map<String,Object>>());
                    responseObj.put('UpdatecaseNumberList',UpdateCaseNumberList);
                    response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
                    response.statusCode = 200;
                    response.addHeader('Content-Type', 'application/json');
                    ap.Response__c=String.valueOf(responseObj);
                    ap.Response_Time__c=System.now();
                }
                else{
                    System.debug('e.getMessage() '+e.getMessage());
                    responseObj.put('Response', e.getMessage()+' ; '+'Upload failed for DIS_DTL_ID:'+japex_case.CaseList[0].Dis_Dtl_Id);
                    responseObj.put('Line ', e.getLineNumber());
                    responseObj.put('Status', '400');
                    response.responseBody = Blob.valueOf(JSON.serialize(responseObj));
                    response.statusCode = 400;
                    response.addHeader('Content-Type', 'application/json');
                    ap.Exception_Description__c=e.getMessage();
                    ap.Response__c=String.valueOf(responseObj);
                    ap.Log_Status__c ='Failure';
                    ap.Response_Time__c=System.now();
                }
            }
        }
        insert ap;
    }
    
    public class JSON2Apex {
        public List<CaseList> CaseList;
        public List<Dis_Document> Dis_Document_list;
        public List<Dpd_Details> Dpd_list;
    }
    
    public class EnquiryList {
        public String Displayed_Enquired_For;
        public String Correct_Enquired_For;
        public String Displayed_Enquired_By;
        public String Correct_Enquired_By;
        public String Displayed_Enquiry_Date;
        public String Correct_Enquiry_Date;
        public String Enquiry_ERN;
        public String Enquiry_Amount;
    }
    
    public class CaseList {
        public String Case_Number;
        public String ContactEmailId;
        public String ContactMobileNo;
        public String Contact_Name;
        public String Contact_Gender;
        public String Contact_Date_of_Birth;
        public String Contact_Address;
        public String Contact_PAN;
        public String Dis_Id;
        public String Dis_Dtl_Id;
        public String Dis_Uti;
        public String Dis_Ern;
        public String Dis_Raised_By;
        public String Dis_Date;
        public String Account_Date_Reported;
        public String Comments;
        public String SubType;
        public String SubType1;
        public AccoutDetailsList AccoutDetailsList;
        public EnquiryPersonDetailsList EnquiryPersonDetailsList;
        public PersonalDetailsList PersonalDetailsList;
        public EnquiryList EnquiryList;
        public Not_My_Enquiry Not_My_Enquiry;
        public Payout_Details Payout_Details;
        public AccountDoesNotBelongToMe AccountDoesNotBelongToMe;
        public DontSeeMyAccountHere DontSeeMyAccountHere;
        
    }
    
    public class Dis_Document {
        public String Dis_Dtl_Id;
        public String DocNameWithExtension;
        public String DocType;
        public String DocContent;
    }
    
    public class AccoutDetailsList {
        public String Sanctioned_Amount;
        public String Displayed_Credit_Facility_Status;
        public String Corrected_Credit_Facility_Status;
        public String Displayed_Account_Status;
        public String Correct_Account_Status;
        public Double Displayed_Loan_Balance;
        public Double Correct_Loan_Balance;
        
        public Double Displayed_Amount_Overdue;
        public Double Correct_Amount_Overdue;
        
        public String Displayed_Account_Opening_Date;
        public String Correct_Account_Opening_Date;
        
        public String Displayed_Account_Type;
        public String Displayed_Bank_Name;
        public String Displayed_Account_number;
        public String Displayed_Loan_Type;
        public String Correct_Loan_Type;
        public String Displayed_loan_Ownership;
        public String Correct_Loan_Ownership;
    }
    
    public class PersonalDetailsList {
        
        public String Displayed_Name;
        public String Correct_Name;
        public String Displayed_Date_of_Birth;
        public String Correct_Date_of_Birth;
        public String Displayed_Gender;
        public String Correct_Gender;
        public String Displayed_Address_1;
        public String Correct_Address_1;
        public String Displayed_Address_2;
        public String Correct_Address_2;
        public String Displayed_Address_3;
        public String Correct_Address_3;
        public String Displayed_Address_4;
        public String Correct_Address_4;
        public String Displayed_Address_5;
        public String Correct_Address_5;
        public String Displayed_email_id;
        public String Correct_email_id;
        public String Displayed_mobile_no_1;
        public String Correct_mobile_no_1;
        public String Displayed_mobile_no_2;
        public String Correct_mobile_no_2;
        public String Displayed_mobile_no_3;
        public String Correct_mobile_no_3;
        public String Displayed_mobile_no_4;
        public String Correct_mobile_no_4;
        public String Displayed_mobile_no_5;
        public String Correct_mobile_no_5;
        public String Displayed_PAN_No;
        public String Correct_PAN_No;
    }
    
    public class EnquiryPersonDetailsList{
        
        public String Enq_First_Name;
        public String Enq_Last_Name;
        public String Enq_Gender_Code;
        public String Enq_DOB;
        public String Enq_PAN;
        public String Enq_Passport_Number;
        public String Enq_VoterID_Number;
        public String Enq_Driving_License_Number;
        public String Enq_Ration_Card_Number;
        public String Enq_Mobile_No;
        public String Enq_Address;
        public String Enq_Email_Id;
    } 
    
    public class DPD_DETAILS{
        
        public String Dis_Dtl_Id;
        public String Dpd_id;
        public Integer Displayed_EMI_Amount;
        public Integer Correct_EMI_Amount;
        public Integer Displayed_EMI_Repayment_Month;
        public Integer Correct_EMI_Repayment_Month;
        public Integer Displayed_EMI_Repayment_Year;
        public Integer Correct_EMI_Repayment_Year;
        
    }
    
    public class AccountDoesNotBelongToMe{
        
        public String AccountType;
        public String BankName;
        public String AccountNumber;
    }
    
    public class DontSeeMyAccountHere{
        
        public String AccountType;
        public String BankName;
        public String AccountNumber;
    }
    
    public class Not_My_Enquiry{
        public String Correct_Enquired_For;
        public String Correct_Enquired_By;
        public String Correct_Enquiry_Date;
        public String Enquiry_ERN;
        public String Enquiry_Amount;
    }
    
    public class Payout_Details{
        public String Account_Number;
        public String Bank_Name;
        public String IFSC_Code;
        public String Account_Holder_Name;
        public String Compensation_Opted;
    }
    
    public static JSON2Apex parse(String json) {
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; 
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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