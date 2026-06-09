public class FormsCotroller {

    public List<String> type_of_member{get;set;}
    public List<String> nbfcs_types_options{get;set;}
    public String Id {get;set;}
    public String companyName {get;set;}
    PUBLIC string force_site_label {get;set;}
    public static Id CustomerId {get;set;}

    public FormsCotroller() {
        force_site_label = System.label.onboarding;
        System.debug('ID===>'+apexpages.currentpage().getparameters().get('id'));
        String decryptedId='';
        Id = apexpages.currentpage().getparameters().get('id');
       CustomerId = [ SELECT Id FROM User WHERE Name=:'CustomerOnboarding Site Guest User' limit 1  ].Id;
        if(Id!=null){
            Blob privateKey2 = Blob.valueOf('046QdQEH24AgGa=='); 
            Blob t = EncodingUtil.convertFromHex(Id);
            Blob decrypted = Crypto.decryptWithManagedIV('AES128', privateKey2, t);
             decryptedId = decrypted.toString();
        }else{
            // decryptedId='00Q6D000003w8AwUAI';
            decryptedId=null;
        }
       

        List<Lead> ld = [ SELECT Id,Name,Company FROM Lead WHERE Id =: decryptedId ];
        if(ld.size() > 0 ){
            companyName = ld[0].Company;
        }else{
            companyName = 'null';
        }
        System.debug('companyName-->'+companyName);
        System.debug('decryptedId==>'+decryptedId); 

        // Blob privateKey = Blob.valueOf('046QdQEH24AgGa=='); 
        // System.debug('privateKey--->'+privateKey); 
        // System.debug('Id--->'+Id); 
        // String scs = EncodingUtil.convertToHex(Crypto.encryptWithManagedIV('AES128', privateKey, Blob.valueOf(Id)));
        // System.debug('scs-->'+scs);
        // String str = '?id='+EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES128', privateKey, Blob.valueOf(Id)));
        // System.debug('STR-->'+str);

        // Blob privateKey2 = Blob.valueOf('046QdQEH24AgGa=='); 
        // Blob t = EncodingUtil.convertFromHex(scs);
        // Blob decrypted = Crypto.decryptWithManagedIV('AES128', privateKey2, t);
        // String decryptedString = decrypted.toString();

        

        
        
        // HttpResponse.setHeader('Set-Cookie', 'BrowserId=1234; SameSite=Strict; Secure');
        //  Cookie BrowserId = Apexpages.currentPage().getCookies().get('BrowserId');
        // BrowserId.setAttribute('SameSite','Strict');
        // System.debug('BrowserId-->'+BrowserId);
        // String BrowserId_value = apexpages.currentPage().getCookies().get('BrowserId').getValue();
        // System.debug('BrowserId_value-->'+BrowserId_value);
        //     Cookie cook=new Cookie('USERNAME', 'BrowserId_value', null, 1440, true,'Strict');
        //    Apexpages.currentPage().setCookies(new Cookie[] {cook});

        

        // Pagereference pr = new Pagereference('/apex/yourpagename');
        // Cookie cookietest = new Cookie('value', Data, null, -1, false);
        // pr.setCookies(new Cookie[] {cookietest});

        type_of_member = new List<String>();
        String objectName = 'Lead';
        String fieldName ='Type_of_Member__c';
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            Map<String, Object> mapName = new Map<String, Object>();
            mapName.put('label',pickListVal.getValue());
            type_of_member.add(JSON.serialize(mapName));
        }


        nbfcs_types_options = new List<String>();
        String objectNamee = 'Lead';
        String fieldNamee ='NBFCs_Types__c';
        Schema.SObjectType se = Schema.getGlobalDescribe().get(objectNamee) ;
        Schema.DescribeSObjectResult re = se.getDescribe() ;
        Map<String,Schema.SObjectField> fieldse = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResulte = fieldse.get(fieldNamee).getDescribe();
        List<Schema.PicklistEntry> plee = fieldResulte.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : plee){
            Map<String, Object> mapName = new Map<String, Object>();
            mapName.put('label',pickListVal.getValue());
            nbfcs_types_options.add(JSON.serialize(mapName));
        }
        
    }



    @RemoteAction 
    public static State_City_Pin__c getStateCityPincode(String pincode){

        try {
            State_City_Pin__c spc = [SELECT Circlename__c,Districtname__c,Divisionname__c,Name,PinCode__c,Regionname__c,Statename__c,Taluk__c FROM State_City_Pin__c WHERE PinCode__c =: pincode ]; 
            return spc;
        } catch (Exception e) {
                
            return null;
        }

    }

    @RemoteAction
    public static memberVerifiedReturnResult getVarifedInfo(String Company,String Pan_no,String gst_state){

        memberVerifiedReturnResult Nstatus = new memberVerifiedReturnResult();

        PanCardValidationRESTController1 PCVRC = new PanCardValidationRESTController1();
        PanCardValidationRESTController1.returnResult panc_return = PCVRC.getTokenAPI(Company,Pan_no);
        GSTINValidationRESTController1 GSTVRC = new GSTINValidationRESTController1();

        GSTINValidationRESTController1.returnResult gstc_return = GSTVRC.getTokenAPI(Pan_no,gst_state);

        Nstatus.Pan_Verification_Remark_c = panc_return.returnVerifyPanCard.Pan_Verification_Remark_c;
        Nstatus.Pan_Verified_c = panc_return.returnVerifyPanCard.Pan_Verified_c;

        Nstatus.GST_Verified_c = gstc_return.returnGST.GST_Verified_c;
        Nstatus.GST_Verification_Remark_c = gstc_return.returnGST.GST_Verification_Remark_c;
        Nstatus.GST_number = gstc_return.returnGST.GST_number;

        return Nstatus;

    }

    @RemoteAction
    public static memberVerifiedReturnResult getPANVerifiedInfo(String panNo){

        memberVerifiedReturnResult nstatus = new memberVerifiedReturnResult();
        
        //Verify PAN and get Company Name
        PanToCompanyCinRESTController  ptcc=new PanToCompanyCinRESTController();
        PanToCompanyCinRESTController.returnResult ptccReturn = ptcc.getTokenAPI(panNo);
        system.debug('ptccReturn-->'+ptccReturn);
        nstatus.Pan_Verification_Remark_c = ptccReturn.returnCompany.Company_Verification_Remark_c;
        nstatus.Pan_Verified_c = ptccReturn.returnCompany.Company_Verified_c;
        nstatus.verifiedCompanyName=ptccReturn.returnCompany.name;

        String tempCompanyName=ptccReturn.returnCompany.name;
        tempCompanyName=tempCompanyName.toLowerCase();
        if(tempCompanyName.contains('bank')){
            
            List<FetchMoreDetailsByCIN.cls_directorDetails>  directorDetailsList=new List<FetchMoreDetailsByCIN.cls_directorDetails>();
            FetchMoreDetailsByCIN.cls_directorDetails clsDetials=new FetchMoreDetailsByCIN.cls_directorDetails();
            clsDetials.name='Other';
            clsDetials.designation='';
            
            //add by shashank on 18 Aug
            clsDetials.din='';
            directorDetailsList.add(clsDetials);

            nstatus.clsDirectList =directorDetailsList;
            nstatus.bankContains=true;
        }else{
            //Fetch CIN by Company Name
            NewCompanyToCinController  ctc=new NewCompanyToCinController();
            NewCompanyToCinController.returnResult ccReturn = ctc.getCtoCinAPI(ptccReturn.returnCompany.name);
            nstatus.cin=ccReturn.returnVerifyCompanyCin.companyID;
            nstatus.CIN_Verified_c=ccReturn.returnVerifyCompanyCin.CIN_Verified_c;
            nstatus.bankContains=false;
            //fetch MoreDetials by CIN
            // FetchMoreDetailsByCIN fmdbc=new FetchMoreDetailsByCIN();
            // FetchMoreDetailsByCIN.returnResult cinReturn=fmdbc.getCtoCinAPI(ccReturn.returnVerifyCompanyCin.companyID);
            // nstatus.clsDirectList=  cinReturn.returnVerifyCompanyCin.clsDirectorLIst;
        }

      
        return nstatus;

    }

    @RemoteAction
    public static memberVerifiedReturnResult getCINVerifiedInfo(String cin){

        memberVerifiedReturnResult nstatus = new memberVerifiedReturnResult();

        //fetch MoreDetials by CIN
        FetchMoreDetailsByCIN fmdbc=new FetchMoreDetailsByCIN();
        FetchMoreDetailsByCIN.returnResult cinReturn=fmdbc.getCtoCinAPI(cin);
        nstatus.clsDirectList=  cinReturn.returnVerifyCompanyCin.clsDirectorLIst;
        nstatus.dateOfIncorporation=cinReturn.returnVerifyCompanyCin.dateOfIncorporation;
        if(cinReturn.returnVerifyCompanyCin.CIN_Verified_c =='True'){
            nstatus.CIN_Verified_c=true;
        }else{
            nstatus.CIN_Verified_c=false;
        }
        return nstatus;

    }

    @RemoteAction
    public static resSendReturnResult getRBIVerifiedInfo(String Company,String baknType){
        resSendReturnResult result=new resSendReturnResult();
        try {
            // RBI_Member__c RM = [SELECT Name,Type__c
            //                         FROM RBI_Member__c 
            //                         WHERE Name =: Company AND Type__c=:baknType ]; 

            String searchStr1 = '*'+Company+'*';
            String searchQuery = 'FIND \'' + searchStr1 + '\' IN Name FIELDS RETURNING  RBI_Member__c (Id,Name,Type__c WHERE Type__c =:baknType),Terminated_Member__c(Id,Name)';
            // List<List<SObject>> searchList = [FIND ''+Company+''+'' IN Name FIELDS RETURNING RBI_Member__c (Id,Name,Type__c WHERE ),Terminated_Member__c(Id,Name)];
            List<List <sObject>> searchList = search.query(searchQuery);
            System.debug('searchList=========> '+searchList);
            List<RBI_Member__c> rbiMemberList = ((List<RBI_Member__c>)searchList[0]);
            List<Terminated_Member__c> terminatedList  = ((List<Terminated_Member__c>)searchList[1]);

            if(rbiMemberList.size() >0){
                if(terminatedList.size()>0 ){
                    result.status=false;
                    result.msg='Your name is not featuring in the Active members against the RBI Specified User list. Please call us at 022 - 6641 9010.';
                    return result;
                }else{
                    result.status=true;
                    result.msg='Verified';
                    return result;
                }
            }else{
                result.status=false;
                result.msg='We are unable to verify your name from the RBI list of specified users. Without RBI certificate, we will not be able to onboard you as a Bureau Member as per CICRA rules.Please upload your RBI Certificate for us to proceed further.';
                return result;
            }
        } catch (Exception e) {
            System.debug('error ==> '+e);
            result.status=false;
            result.msg='try Again';
            return result;
        }
    }

    @RemoteAction
    public static becomeMemberReturnStatus becomeMember(String json){

        becomeMemberReturnStatus bMRS = new becomeMemberReturnStatus();
        System.debug('Update Lead in Action ->'+json);

        try {
            becomMemberApex bApex = becomMemberparseTarget(json);
    
            Lead nl = new Lead();
            try {
                if(bApex.new_lead_Status == true){
                    nl = [SELECT Id FROM Lead WHERE Company =: bApex.Company AND Status <> 'Qualified' LIMIT 1 ];
                    if(nl.Id != null){
                        throw new CommonException('Test Common Exception');
                    }
                }else{
                    nl = [SELECT Id FROM Lead WHERE Company =: bApex.Company AND Status <> 'Qualified' LIMIT 1 ];
                }
            } catch (CommonException CE) {
                bMRS.msg = 'Account Already Exist!';
                bMRS.instruction = 'Your company ('+bApex.Company+') has already been registered. please use the same email address '+bApex.Company+' to continue with the process of onboarding of your company as an Experian Member.';
                bMRS.sing = 'fa fa-exclamation-triangle';
                bMRS.status = false;
                System.debug('>>> ERROR1 ='+CE);
                
                return bMRS;
            }
            catch (Exception e) {
                System.debug('Exception  '+e);
            }
            //System.debug('nL1--->'+nl.Id);
            // nl.First_Name_Nodal__c = bApex.First_Name_Nodal_c;
            // System.debug('nL2--->'+nl.Id);
            // nl.Last_Name_Nodal__c = bApex.Last_Name_Nodal_c;
            // System.debug('nL3--->'+nl.Id);
            // nl.Nodal_Officer_Name__c = bApex.First_Name_Nodal_c+' '+bApex.Last_Name_Nodal_c;
            // System.debug('nL4--->'+nl.Id);
            // nl.FirstName = bApex.First_Name_Nodal_c;
            // System.debug('nL5--->'+nl.Id);
            // nl.LastName = bApex.Last_Name_Nodal_c;
            // System.debug('nL6--->'+nl.Id);
            // nl.Phone = bApex.Tel_No_Nodal_c;
            // System.debug('nL7--->'+nl.Id);
            // nl.Email = bApex.Email;
            // System.debug('nL8--->'+nl.Id);
            // nl.Official_Email_Address_Nodal__c = bApex.Email;
            // System.debug('nL9--->'+nl.Id);
            // nl.Tel_No_Nodal__c = bApex.Tel_No_Nodal_c;
            // System.debug('nL12--->'+nl.Id);
            // nl.Job_Title_Nodal__c = bApex.Job_Title_Nodal_c;
            // System.debug('nL13--->'+nl.Id);

            nl.First_Name_AuSig__c = bApex.First_Name_AuSig_c;
            nl.Last_Name_AuSig__c = bApex.Last_Name_AuSig_c;
            nl.Job_Title_AuSig__c = bApex.Job_Title_AuSig_c;
            nl.DIN__c = bApex.DIN_AuSig_c;
            nl.Official_Email_Address_AuSig__c = bApex.Official_Email_Address_AuSig_c;
            nl.Tel_No_AuSig__c = bApex.Tel_No_AuSig_c;
            nl.Selected_Authorised_Signatory__c=bApex.authSignListValue;
            nl.Selected_Company_Name__c=bApex.SelectedCompanyOptionBy;
            string recId = SObjectType.Lead.getRecordTypeInfosByName().get('ECIC').getRecordTypeId();
            nl.RecordTypeId = recId;

            //map the basic detials with authorise signatory
            nl.FirstName = bApex.First_Name_AuSig_c;
            nl.LastName = bApex.Last_Name_AuSig_c;
            nl.Email = bApex.Official_Email_Address_AuSig_c;
            nl.Phone = bApex.Tel_No_AuSig_c;
            
            nl.Company = bApex.Company;
            nl.Type__c = bApex.Company_Type;
              //added by shashank on 5 july,2023
            nl.Other_Type__c = bApex.Other_Type_c;

            nl.Pan_no__c = bApex.Pan_no_c;
            nl.GST_State__c = bApex.GST_State_c;
            nl.GST_No__c = bApex.GST_No_c;
            nl.Website = bApex.Website;
            nl.GST_Registered__c=bApex.GST_Registered_c;
            nl.CIN_Company_Identification_Number__c = bApex.CIN_Company_Identification_Number_c;
            nl.Date_of_Incorporation__c = bApex.Date_of_Incorporation_c;
            
            System.debug('bApex.verfiedData '+bApex.verfiedData);
            nl.Pan_Verified__c = bApex.verfiedData.Pan_Verified_c;
            nl.RBI_List_Verification_Remarks__c=bApex.RBI_List_Verification_Remarks_c;
            if(bApex.RBI_List_Verification_Remarks_c =='Verified'){
                nl.RBI_Member_Verified__c='Yes';
            }else {
                nl.RBI_Member_Verified__c='No';
            }
            nl.CIN_Number_Verified__c=bApex.CIN_Number_Verified_c;
            nl.Pan_Verification_Remark__c = bApex.verfiedData.Pan_Verification_Remark_c;
            nl.GST_Verified__c = bApex.verfiedData.GST_Verified_c;
            nl.GST_Verification_Remark__c = bApex.verfiedData.GST_Verification_Remark_c;
            
            
            if(nl.Id == null){
                System.debug('nL-if-->'+nl.Id);
                nl.Status = 'OTP verified';
            }

            // insert nl;
            upsert nl;
            
            
            
            if(bApex.CurrentStageLocation != null){
                system.debug('inside CurrentStageLocation '+bApex.CurrentStageLocation);
                APILoginDetail api =  bApex.CurrentStageLocation;
                if(api.stage !=null){
                List<Onboarding_API_Logs__c> listOfLogsToInsert = new List<Onboarding_API_Logs__c>();
                List<Onboarding_API_Logs__c> nAPI_LogList =[Select Id,Name__c from Onboarding_API_Logs__c where Name__c = :api.stage 
                                                            and Lead__c =:nl.Id];
                
                system.debug(api.stage+'  '+nAPI_LogList.size());
                if(nAPI_LogList.size() > 0){
                    
                }else{
                    Onboarding_API_Logs__c log  = new Onboarding_API_Logs__c();
                    log.Name__c = api.stage;
                    log.Lead__c = nl.Id;
                    
                    string  dateTimeString = string.valueOf(api.startTime);
                    // Extract components
                    Integer year = Integer.valueOf(dateTimeString.substring(0, 4));
                    Integer month = Integer.valueOf(dateTimeString.substring(5, 7));
                    Integer day = Integer.valueOf(dateTimeString.substring(8, 10));
                    Integer hour = Integer.valueOf(dateTimeString.substring(11, 13));
                    Integer minute = Integer.valueOf(dateTimeString.substring(14, 16));
                    Integer second = Integer.valueOf(dateTimeString.substring(17, 19));
                    log.Start_Time__c = DateTime.newInstance(year, month, day, hour+5, minute+30, 00);
                    log.End_Time__c = system.now();
                    log.User__c = CustomerId;
                    system.debug(log);
                    insert log;
                    //listOfLogsToInsert.add(log);
                 }
                }
                //system.debug('listOfLogsToInsert'+listOfLogsToInsert.size());
                //if(listOfLogsToInsert.size() > 0){
                  //  insert listOfLogsToInsert;
                //}
                
                
            }

            if(bApex.GST_Registered_c =='No'){
            //     String noLetterBody='<html><body><p>To \n Membership Team \n ECICI';
            //     noLetterBody+='\n\n This is to confirm that we at "'+bApex.Company+'", do hereby state that as we have the turnover below the taxable limit as specified under the Goods and Services Tax Act we are not required to get ourselves registered under the Goods and Services Tax 2017';
            //     noLetterBody+='\n\n We hereby also confirm that if during any financial year we decide or required to register under the GST in that case we undertake to provide all the requisite information and documents. We request you to treat this communication as a declaration regarding non-requirement to be registered under the Goods and Service Tax Act, 2017.';
            //     noLetterBody+='\n\n "'+bApex.First_Name_AuSig_c+'" "'+bApex.First_Name_AuSig_c+'"';
            //     noLetterBody+='\n\n "'+bApex.Company+'"</html></body></p>';
            //     String base64BlobValue = EncodingUtil.Base64Encode( Blob.valueOf( noLetterBody ) );
            //     DateTime yourDate = Datetime.now();
            //    String dateOutput = yourDate.format('dd/MM/yyyy');
   
            //     noLetterBody+='\n\n '+ dateOutput;
            System.debug('== > '+nl.Id);
                Blob strPdfBody = null;
                // PageReference objPagePdf = new PageReference('/apex/noGstLetter?Id='+nl.Id);
                PageReference objPagePdf = page.noGstLetter;
                objPagePdf.getParameters().put('Company', bApex.company);
                objPagePdf.getParameters().put('First_Name_AuSig__c', bApex.First_Name_AuSig_c);
                objPagePdf.getParameters().put('Last_Name_AuSig__c', bApex.Last_Name_AuSig_c);
                strPdfBody =  objPagePdf.getContentAsPdf();
   
               ContentVersion contentVersion = new ContentVersion();
               contentVersion.ContentLocation = 'S'; // S = Stored in Salesforce
               contentVersion.PathOnClient = 'No GST Letter.pdf';
               //contentVersion.Title = fileName;
               contentVersion.Title = 'No GST Letter';
               contentVersion.isMajorVersion = false;
               contentVersion.VersionData = strPdfBody;
               
               upsert contentVersion;
   
               contentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id];
   
               ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
               contentDocumentLink.ContentDocumentId = contentVersion.ContentDocumentId;
               contentDocumentLink.LinkedEntityId = nl.Id;
               contentDocumentLink.ShareType = 'V';
   
               upsert contentDocumentLink;
   
               ContentDistribution cd = new ContentDistribution();
               cd.Name = 'No GST Letter';
               cd.ContentVersionId = contentVersion.Id;
               cd.PreferencesAllowViewInBrowser= true;
               cd.PreferencesLinkLatestVersion=true;
               cd.PreferencesNotifyOnVisit=false;
               cd.PreferencesPasswordRequired=false;
               cd.PreferencesAllowOriginalDownload= true;
   
               upsert cd;
            }

            
            bMRS.Id = nl.Id;
            bMRS.msg = 'Thank you for filling the form';
            bMRS.instruction = 'We will get back to you shortly';
            bMRS.sing = 'fa fa-thumbs-up';
            bMRS.status = true;

        } catch (QueryException e) {

            bMRS.msg = 'Somthing went wrong Exception!';
            bMRS.instruction = 'please refresh the page or Contact to Experian Support';
            bMRS.sing = 'fa fa-exclamation-triangle';
            bMRS.status = false;
            System.debug('>>> ERROR1 ='+e);

        }

        return bMRS;
    }
   
    @RemoteAction
    public static verificationMemberReturnStatus verificationMember(String OTP, String Id,string status){
        verificationMemberReturnStatus vMRS = new verificationMemberReturnStatus();
        APILoginDetail dApex = APILoginDetailparseTarget(status);
        system.debug(dApex);
        try {
            Lead Ld = [SELECT Id,Email, OTP__c,Status FROM Lead WHERE Id =: Id];
           //added by shashank to put encryption on otp
            // Generate the data to be encrypted.
             Blob data = Blob.valueOf(OTP);
            // Encrypt the data and have Salesforce.com generate the initialization vector
             Blob encryptedData = Crypto.generateDigest('MD5', data);
				String otpEnc=EncodingUtil.convertToHex(encryptedData);
            system.debug(' Ld.OTP__c '+Ld.OTP__c+' otpEnc '+otpEnc);
           // if(Ld.OTP__c == OTP){
            if(Ld.OTP__c == otpEnc){
                if(Ld.Status == 'OTP verified'){
                   //Ld.Status = 'Member details';
                   Ld.Status='Document Verifiying';
                    update Ld;
                    
                List<Onboarding_API_Logs__c> listOfLogsToInsert = new List<Onboarding_API_Logs__c>();
                List<Onboarding_API_Logs__c> nAPI_LogList =[Select Id,Name__c from Onboarding_API_Logs__c where Name__c = :dApex.stage 
                                                            and Lead__c =:Id];
                if(nAPI_LogList.size() > 0){
                    
                }
                    else{
                    Onboarding_API_Logs__c log  = new Onboarding_API_Logs__c();
                    log.Name__c = dApex.stage;
                    log.Lead__c = Id;
                    string  dateTimeString = string.valueOf(dApex.startTime);
                    // Extract components
                    Integer year = Integer.valueOf(dateTimeString.substring(0, 4));
                    Integer month = Integer.valueOf(dateTimeString.substring(5, 7));
                    Integer day = Integer.valueOf(dateTimeString.substring(8, 10));
                    Integer hour = Integer.valueOf(dateTimeString.substring(11, 13));
                    Integer minute = Integer.valueOf(dateTimeString.substring(14, 16));
                    Integer second = Integer.valueOf(dateTimeString.substring(17, 19));
                    log.Start_Time__c = DateTime.newInstance(year, month, day, hour+5, minute+30, 00);
                    log.End_Time__c = system.now();
                        log.User__c = CustomerId;
                    //system.debug(log);
                    insert log;
                }
                }
                vMRS.msg = 'Verified';
                vMRS.status = true;
                vMRS.color = 'green';
                vMRS.Email =Ld.Email;
                vMRS.LeadStatus =Ld.Status;
            }else{
                vMRS.msg = 'Not verified';
                vMRS.status = false;
                vMRS.color = 'red';
            }
        } catch (QueryException e) {
            vMRS.msg = 'Somthing went wrong Exception!';
            vMRS.status = false;
            vMRS.color = 'red';
        }
        return vMRS;
    }

    @RemoteAction
    public static detailMemberReturnStatus detailMember(String json, String Id,string status){
        detailMemberReturnStatus dMRS = new detailMemberReturnStatus();
        
        
        APILoginDetail apiLogs = APILoginDetailparseTarget(status);
        detailMemberApex dApex = detailsMemberparseTarget(json);
        try {
            
            Lead Ld = [ SELECT Id,Status, First_Name_AuSig__c, Last_Name_AuSig__c,First_Name_Nodal__c,Last_Name_Nodal__c,Job_Title_Nodal__c,Official_Email_Address_Nodal__c,Tel_No_Nodal__c, Job_Title_AuSig__c, Official_Email_Address_AuSig__c, Tel_No_AuSig__c, Billing_Contact_Person__c, Billing_Contact_Details__c, Billing_Email_Address__c, Billing_Job_Title__c, Billing_City__c, Billing_State__c, Billing_Street__c, Billing_Zip_Postal_Code__c, Billing_Country__c FROM Lead WHERE Id =: Id ];

            // if(dApex.Authorised_Signatory_Same_As_Nodal_Offic_c == true){
            //     Ld.First_Name_AuSig__c = Ld.First_Name_Nodal__c;
            //     Ld.Last_Name_AuSig__c = Ld.Last_Name_Nodal__c;
            //     Ld.Job_Title_AuSig__c = Ld.Job_Title_Nodal__c;
            //     Ld.Official_Email_Address_AuSig__c = Ld.Official_Email_Address_Nodal__c;
            //     Ld.Tel_No_AuSig__c = Ld.Tel_No_Nodal__c;
            // }else{
                // Ld.First_Name_AuSig__c = dApex.First_Name_AuSig_c;
                // Ld.Last_Name_AuSig__c = dApex.Last_Name_AuSig_c;
                // Ld.Job_Title_AuSig__c = dApex.Job_Title_AuSig_c;
                // Ld.Official_Email_Address_AuSig__c = dApex.Official_Email_Address_AuSig_c;
                // Ld.Tel_No_AuSig__c = dApex.Tel_No_AuSig_c;

            Ld.First_Name_Nodal__c = dApex.First_Name_Nodal_c;
            // System.debug('nL2--->'+nl.Id);
            Ld.Last_Name_Nodal__c = dApex.Last_Name_Nodal_c;
            // System.debug('nL3--->'+nl.Id);
            Ld.Nodal_Officer_Name__c = dApex.First_Name_Nodal_c+' '+dApex.Last_Name_Nodal_c;
            // System.debug('nL4--->'+nl.Id);
            Ld.Official_Email_Address_Nodal__c = dApex.Email;
            // System.debug('nL9--->'+nl.Id);
            Ld.Tel_No_Nodal__c = dApex.Tel_No_Nodal_c;
            // System.debug('nL12--->'+nl.Id);
            Ld.Job_Title_Nodal__c = dApex.Job_Title_Nodal_c;
            // System.debug('nL13--->'+nl.Id);
            // }

            Ld.Billing_Contact_Person__c = dApex.Billing_Contact_Person_c;
            Ld.Billing_Contact_Details__c = dApex.Billing_Contact_Details_c;
            Ld.Billing_Email_Address__c = dApex.Billing_Email_Address_c;
            Ld.Billing_Job_Title__c = dApex.Billing_Job_Title_c;
            Ld.Billing_City__c = dApex.Billing_City_c;
            Ld.Billing_State__c = dApex.Billing_State_c;
            Ld.Billing_Street__c = dApex.Billing_Street_c;
            Ld.Billing_Zip_Postal_Code__c = dApex.Billing_Zip_Postal_Code_c;
            Ld.Billing_Country__c = dApex.Billing_Country_c;
            Ld.Authorised_Signatory_Same_As_Nodal_Offic__c = dApex.Authorised_Signatory_Same_As_Nodal_Offic_c;

            if(Ld.Status == 'Member details'){
                // Ld.Status = 'Plan selection';
                Ld.Status = 'Additional details';
            }

            update Ld;
            
            List<Onboarding_API_Logs__c> listOfLogsToInsert = new List<Onboarding_API_Logs__c>();
            if(apiLogs.stage !=null){
                List<Onboarding_API_Logs__c> nAPI_LogList =[Select Id,Name__c from Onboarding_API_Logs__c where Name__c = :apiLogs.stage 
                                                            and Lead__c =:Id];
                if(nAPI_LogList.size() > 0){
                    
                }
                else{
                    Onboarding_API_Logs__c log  = new Onboarding_API_Logs__c();
                    log.Name__c = apiLogs.stage;
                    log.Lead__c = Id;
                    string  dateTimeString = string.valueOf(apiLogs.startTime);
                    // Extract components
                    Integer year = Integer.valueOf(dateTimeString.substring(0, 4));
                    Integer month = Integer.valueOf(dateTimeString.substring(5, 7));
                    Integer day = Integer.valueOf(dateTimeString.substring(8, 10));
                    Integer hour = Integer.valueOf(dateTimeString.substring(11, 13));
                    Integer minute = Integer.valueOf(dateTimeString.substring(14, 16));
                    Integer second = Integer.valueOf(dateTimeString.substring(17, 19));
                    log.Start_Time__c = DateTime.newInstance(year, month, day, hour+5, minute+30, 00);
                    log.End_Time__c = system.now();
                    log.User__c = CustomerId;
                    //system.debug(log);
                    insert log;
                }
            }

            dMRS.Id = Ld.Id;
            dMRS.status = true;
            dMRS.msg = 'Record Updated Successfully';
            
        } catch (Exception e) {

            dMRS.status = false;
            dMRS.msg = 'Record Updation Failed';
        }
        
        return dMRS;
    }
    

    @RemoteAction
    public static webUserDetailsReturnStatus webUserDetails(String json,String json2,Boolean data_pull_ids, String Id,string status){
        webUserDetailsReturnStatus wDRS = new webUserDetailsReturnStatus();
		APILoginDetail apiLogs = APILoginDetailparseTarget(status);
        List <webUserDetailsApex> wApex = webUserDetailsparseTarget(json);
        authUserIdRequestorApex authUserIdReqApex = authUserIdRequestorparseTarget(json2);

        List<Web_User_Details__c> wusdList = new List<Web_User_Details__c>();

        try {

        Lead Ld = [ SELECT Id,First_Name_Auth_Usr_Req__c,Last_Name_Auth_Usr_Req__c,Official_Email_Auth_Usr_Req__c,Tel_No_Auth_Usr_Req__c,Job_Title_Auth_Usr_Req__c,Status,Data_Pull_id_s__c,(SELECT GST_Amount__c,Lead__c,GST__c,Initial_Payment_Amount__c,Name,Product__c,Product__r.Name,Product__r.Fee_Plan_Type__c,Total_Payment_Amount__c FROM Payment_Detail__r) FROM Lead WHERE Id =: Id ];


        System.debug('---->'+Ld);
            integer disputeCount=1;
            for (webUserDetailsApex w : wApex) {
                Web_User_Details__c wsd = new Web_User_Details__c();
                if(w.Id != null || w.Id != ''){
                    wsd.Id = w.Id;
                }
                wsd.Web_User_First_Name__c = w.Web_User_First_Name_c;
                wsd.Web_User_Job_Title__c = w.Web_User_Job_Title_c;
                wsd.Web_User_Last_Name__c = w.Web_User_Last_Name_c;
                wsd.Web_User_Email__c = w.Web_User_Email_c;
                wsd.Web_User_Tel_No__c = w.Web_User_Tel_No_c;
                wsd.Name = w.Web_User_First_Name_c +' '+w.Web_User_Last_Name_c;
                wsd.Lead__c = Id;
                /*if (data_pull_ids) {
                    wsd.Web_User_Type__c = 'Data Submission Id';
                }else {
                    wsd.Web_User_Type__c = 'Data Pull Id';
                }*/
                wsd.Web_User_Type__c = w.Web_User_Type_c;
                if(w.Web_User_Type_c =='For Grievance on Disputes'){
                    wsd.Dispute_Member_Count__c=disputeCount;
                    disputeCount++;
                }
                
                wusdList.add(wsd);

            }

            Ld.First_Name_Auth_Usr_Req__c = authUserIdReqApex.First_Name_Auth_Usr_Req_c;
            Ld.Last_Name_Auth_Usr_Req__c = authUserIdReqApex.Last_Name_Auth_Usr_Req_c;
            Ld.Official_Email_Auth_Usr_Req__c = authUserIdReqApex.Official_Email_Auth_Usr_Req_c;
            Ld.Tel_No_Auth_Usr_Req__c = authUserIdReqApex.Tel_No_Auth_Usr_Req_c;
            Ld.Job_Title_Auth_Usr_Req__c = authUserIdReqApex.Job_Title_Auth_Usr_Req_c;

            if(Ld.Status == 'Additional details'){
                Ld.Status = 'Payment';
                Ld.Data_Pull_id_s__c = data_pull_ids;
                update Ld;
            }else{
                Ld.Data_Pull_id_s__c = data_pull_ids;
                update Ld;

            }
            
            List<Onboarding_API_Logs__c> listOfLogsToInsert = new List<Onboarding_API_Logs__c>();
            if(apiLogs.stage !=null){
                
                
                List<Onboarding_API_Logs__c> nAPI_LogList =[Select Id,Name__c from Onboarding_API_Logs__c where Name__c = :apiLogs.stage 
                                                            and Lead__c =:Id];
                if(nAPI_LogList.size() > 0){
                    
                }
                else{
                    Onboarding_API_Logs__c log  = new Onboarding_API_Logs__c();
                    log.Name__c = apiLogs.stage;
                    log.Lead__c = Id;
                    string  dateTimeString = string.valueOf(apiLogs.startTime);
                    // Extract components
                    Integer year = Integer.valueOf(dateTimeString.substring(0, 4));
                    Integer month = Integer.valueOf(dateTimeString.substring(5, 7));
                    Integer day = Integer.valueOf(dateTimeString.substring(8, 10));
                    Integer hour = Integer.valueOf(dateTimeString.substring(11, 13));
                    Integer minute = Integer.valueOf(dateTimeString.substring(14, 16));
                    Integer second = Integer.valueOf(dateTimeString.substring(17, 19));
                    log.Start_Time__c = DateTime.newInstance(year, month, day, hour+5, minute+30, 00);
                    log.End_Time__c = system.now();
                    log.User__c = CustomerId;
                    //system.debug(log);
                    insert log;
                }
            }
            
            System.debug(wusdList);

            upsert wusdList;

            wDRS.status = true;
            wDRS.msg = 'Record Updated Successfully';
            wDRS.paymentDetailApex = Ld.Payment_Detail__r;
            wDRS.webUserDetailsApex = wusdList;

        } catch (Exception e) {

            wDRS.status = false;
            wDRS.msg = 'Record Updation Failed';
            system.debug('error '+e.getLinenumber()+' msg '+e.getMessage());
            
        }
        
        return wDRS;
        
    }
    
    @RemoteAction
    public static returnPlanSelection planSelection(String Id,String json,string status){

        returnPlanSelection rPS = new returnPlanSelection();
		APILoginDetail apiLogs = APILoginDetailparseTarget(status);
        try{
            System.debug('json -> '+json);
            String s = json.replace( '__c' , '_c' );
            String ss = s.replace( '__r' , '_r' );
            System.debug('sinJson -> '+ ss);
            List<paymentDetailApexForPlan> pdApex = paymentDetailApexForPlanTarget(ss);
            System.debug('sinJson -> '+ pdApex);

            Lead Ld = [SELECT Id,Status,Email,(SELECT Id,Product__c,Name,Product__r.Id,Product__r.Name FROM Payment_Detail__r) FROM Lead WHERE Id =: Id];
            system.debug('944-->'+Ld);
            List<Lead_Payment_Detail__c> pdcListToUpsert = new List<Lead_Payment_Detail__c>();
            List<Lead_Payment_Detail__c> pdcListToDelete = new List<Lead_Payment_Detail__c>();
            for (paymentDetailApexForPlan pd : pdApex) {
                Lead_Payment_Detail__c pdc = new Lead_Payment_Detail__c();
                System.debug('pd ----> '+ pd);
                if(pd.Selected_c == true){
                    System.debug('pd ----> '+ pd);
                    System.debug('pd ----> '+ Ld.Payment_Detail__r.size());
                    pdc.Lead__c = Ld.Id;
                    System.debug('pd.Id ----> '+ pd.Id);
                    pdc.Product__c = pd.Id;
                    if(Ld.Payment_Detail__r.size() > 0){
                        for (Lead_Payment_Detail__c paymentDetail_c : Ld.Payment_Detail__r) {
                            if(pd.Id == paymentDetail_c.Product__r.Id){
                                pdc.Id = paymentDetail_c.Id;
                                pdc.Product__c = paymentDetail_c.Product__c;
                            }
                        }
                    }
                    System.debug('pdc ----> '+ pdc);
                    pdcListToUpsert.add(pdc);
                }else if(pd.Selected_c == false){
                    if(Ld.Payment_Detail__r.size() > 0){
                        for (Lead_Payment_Detail__c paymentDetail_c : Ld.Payment_Detail__r) {
                            if(pd.Id == paymentDetail_c.Product__r.Id){
                                pdc.Id = paymentDetail_c.Id;
                                pdcListToDelete.add(pdc);
                            }
                        }
                    }
                }
            }
            if(pdcListToUpsert.size() > 0){
                upsert pdcListToUpsert;
            }
            if(pdcListToDelete.size() > 0){
                delete pdcListToDelete;
            }
            
            
            List<Onboarding_API_Logs__c> listOfLogsToInsert = new List<Onboarding_API_Logs__c>();
            if(apiLogs.stage !=null){
                
                
                List<Onboarding_API_Logs__c> nAPI_LogList =[Select Id,Name__c from Onboarding_API_Logs__c where Name__c = :apiLogs.stage 
                                                            and Lead__c =:Id];
                if(nAPI_LogList.size() > 0){
                    
                }
                else{
                    Onboarding_API_Logs__c log  = new Onboarding_API_Logs__c();
                    log.Name__c = apiLogs.stage;
                    log.Lead__c = Id;
                    string  dateTimeString = string.valueOf(apiLogs.startTime);
                    // Extract components
                    Integer year = Integer.valueOf(dateTimeString.substring(0, 4));
                    Integer month = Integer.valueOf(dateTimeString.substring(5, 7));
                    Integer day = Integer.valueOf(dateTimeString.substring(8, 10));
                    Integer hour = Integer.valueOf(dateTimeString.substring(11, 13));
                    Integer minute = Integer.valueOf(dateTimeString.substring(14, 16));
                    Integer second = Integer.valueOf(dateTimeString.substring(17, 19));
                    log.Start_Time__c = DateTime.newInstance(year, month, day, hour+5, minute+30, 00);
                    log.End_Time__c = system.now();
                    log.User__c = CustomerId;
                    //system.debug(log);
                    insert log;
                }
            }
            
            if(Ld.Status == 'Plan selection'){
                Ld.Status = 'Payment';//added by shasashank
                UPDATE Ld;   //added by shashank.
                rPS.goNext = true; //added by shashank.

                rPS.status = true;
                //rPS.goNext = false;  //comment by shashank 07_04_2022
                rPS.msg = 'We are validating your information and documents. You will hear from us within 2 days on your email id '+Ld.Email+' , '+' You are just 3 steps away from completing the membership process--  '+' , '+' 1.Validation of the documents submitted '+' , '+' 2.Payment for your Membership'+' ,'+' 3.E-signing of the Agreement ';
            }else{
                if(Ld.Status == 'Payment' || Ld.Status == 'Sent for Agreement' || Ld.Status == 'Agreement Received' ){
                    rPS.status = true;
                    rPS.goNext = true;
                }
            }
            

        }catch(QueryException e){
            rPS.msg = 'Exception !We are validating the documents from our end regarding specified user mentioned in CICRA.” You will hear from us shortly';
            // status.sing = 'fa fa-exclamation-triangle';
            rPS.status = false;
        }
        return rPS;
    }
    
    
    @RemoteAction
    public static returnPlanSelection paymentSubmit(String Id,string status){

        returnPlanSelection rPS = new returnPlanSelection();
		APILoginDetail apiLogs = APILoginDetailparseTarget(status);
        try{
            Lead Ld = [SELECT Id,Status FROM Lead WHERE Id =: Id];
            
            if(Ld.Status == 'Payment'){
                // Ld.Status = 'Payment';
                // update Ld;
                rPS.status = true;
                rPS.goNext = false;
                rPS.msg = 'Once we receive the payment, we will send you a notification email for signing the Agreement.';
            }else{
                if(Ld.Status == 'Sent for Agreement' || Ld.Status == 'Agreement Received' ){
                    rPS.status = true;
                    rPS.goNext = true;
                }
            }
            List<Onboarding_API_Logs__c> listOfLogsToInsert = new List<Onboarding_API_Logs__c>();
            if(apiLogs.stage !=null){
                
                
                List<Onboarding_API_Logs__c> nAPI_LogList =[Select Id,Name__c from Onboarding_API_Logs__c where Name__c = :apiLogs.stage 
                                                            and Lead__c =:Id];
                if(nAPI_LogList.size() > 0){
                    
                }
                else{
                    Onboarding_API_Logs__c log  = new Onboarding_API_Logs__c();
                    log.Name__c = apiLogs.stage;
                    log.Lead__c = Id;
                    string  dateTimeString = string.valueOf(apiLogs.startTime);
                    // Extract components
                    Integer year = Integer.valueOf(dateTimeString.substring(0, 4));
                    Integer month = Integer.valueOf(dateTimeString.substring(5, 7));
                    Integer day = Integer.valueOf(dateTimeString.substring(8, 10));
                    Integer hour = Integer.valueOf(dateTimeString.substring(11, 13));
                    Integer minute = Integer.valueOf(dateTimeString.substring(14, 16));
                    Integer second = Integer.valueOf(dateTimeString.substring(17, 19));
                    log.Start_Time__c = DateTime.newInstance(year, month, day, hour+5, minute+30, 00);
                    log.End_Time__c = system.now();
                    log.User__c = CustomerId;
                    //system.debug(log);
                    insert log;
                }
            }

        }catch(QueryException e){
            rPS.msg = 'Exception! please contact Experian Supprt';
            // status.sing = 'fa fa-exclamation-triangle';
            rPS.status = false;
        }
        return rPS;
    }

    @RemoteAction
    public static sentForAgreementReturnResult getAgreementCopy(String Id,string status){
        APILoginDetail apiLogs = APILoginDetailparseTarget(status);
        sentForAgreementReturnResult sFAR = new sentForAgreementReturnResult();
        try {
            Lead ld = [SELECT Id,LegalDesk_Agreement_Document_Id__c,Legal_desk_docket_id__c,Agreement_Customer_Status_Stages__c,Agreement_Experian_Status__c FROM Lead WHERE Id =:Id];
            if((ld.LegalDesk_Agreement_Document_Id__c != null || ld.LegalDesk_Agreement_Document_Id__c != '') && (ld.Legal_desk_docket_id__c != null 
                || ld.Legal_desk_docket_id__c != '') ){
                if(!Test.isRunningTest()){
                   //Invoke mock web service response if not calling from test
                   sFAR.pdf = RestApiGetdocketInfo.get_pdf_content(Id);
                }
                    system.debug('-->inside if');                                                                                                  
                sFAR.expSign = ld.Agreement_Experian_Status__c;
                sFAR.cusSign = ld.Agreement_Customer_Status_Stages__c;
                sFAR.status = true;
                sFAR.msg = 'We have mailed the agreement copy to you. Please follow the instructions sent on the mail to complete the agreement signing.';
            }else{
                system.debug('-->inside else');
                sFAR.expSign = ld.Agreement_Experian_Status__c;
                sFAR.cusSign = ld.Agreement_Customer_Status_Stages__c;
                sFAR.status = false;
                sFAR.msg = 'please wait we will reach you for this agreement process or you can Contact Experian Support';
            }
            
            List<Onboarding_API_Logs__c> listOfLogsToInsert = new List<Onboarding_API_Logs__c>();
            if(apiLogs.stage !=null){
                
                
                List<Onboarding_API_Logs__c> nAPI_LogList =[Select Id,Name__c from Onboarding_API_Logs__c where Name__c = :apiLogs.stage 
                                                            and Lead__c =:Id];
                if(nAPI_LogList.size() > 0){
                    
                }
                else{
                    Onboarding_API_Logs__c log  = new Onboarding_API_Logs__c();
                    log.Name__c = apiLogs.stage;
                    log.Lead__c = Id;
                    string  dateTimeString = string.valueOf(apiLogs.startTime);
                    // Extract components
                    Integer year = Integer.valueOf(dateTimeString.substring(0, 4));
                    Integer month = Integer.valueOf(dateTimeString.substring(5, 7));
                    Integer day = Integer.valueOf(dateTimeString.substring(8, 10));
                    Integer hour = Integer.valueOf(dateTimeString.substring(11, 13));
                    Integer minute = Integer.valueOf(dateTimeString.substring(14, 16));
                    Integer second = Integer.valueOf(dateTimeString.substring(17, 19));
                    log.Start_Time__c = DateTime.newInstance(year, month, day, hour+5, minute+30, 00);
                    log.End_Time__c = system.now();
                    log.User__c = CustomerId;
                    //system.debug(log);
                    insert log;
                }
            }
        } catch (Exception e) {
            system.debug('Exception-------> Testing----------->'+e);
            sFAR.expSign = '';
            sFAR.cusSign = '';
            sFAR.status = false;
            sFAR.msg = 'please wait we will reach you for this agreement process or you can Contact Experian Support';
        }

        return sFAR;
    }
    
    @RemoteAction
    public static boolean getAgreementView(String Id,string status){
        APILoginDetail apiLogs = APILoginDetailparseTarget(status);
        sentForAgreementReturnResult sFAR = new sentForAgreementReturnResult();
            List<Onboarding_API_Logs__c> listOfLogsToInsert = new List<Onboarding_API_Logs__c>();
            if(apiLogs.stage !=null){
                
                
                List<Onboarding_API_Logs__c> nAPI_LogList =[Select Id,Name__c from Onboarding_API_Logs__c where Name__c = :apiLogs.stage 
                                                            and Lead__c =:Id];
                if(nAPI_LogList.size() > 0){
                    
                }
                else{
                    Onboarding_API_Logs__c log  = new Onboarding_API_Logs__c();
                    log.Name__c = apiLogs.stage;
                    log.Lead__c = Id;
                    string  dateTimeString = string.valueOf(apiLogs.startTime);
                    // Extract components
                    Integer year = Integer.valueOf(dateTimeString.substring(0, 4));
                    Integer month = Integer.valueOf(dateTimeString.substring(5, 7));
                    Integer day = Integer.valueOf(dateTimeString.substring(8, 10));
                    Integer hour = Integer.valueOf(dateTimeString.substring(11, 13));
                    Integer minute = Integer.valueOf(dateTimeString.substring(14, 16));
                    Integer second = Integer.valueOf(dateTimeString.substring(17, 19));
                    log.Start_Time__c = DateTime.newInstance(year, month, day, hour+5, minute+30, 00);
                    log.End_Time__c = system.now();
                    log.User__c = CustomerId;
                    //system.debug(log);
                    insert log;
                }
            }
        return true;
       
    }

    // -----------------------------------------------------------------------
    // LOGIN OTP METHODS - Used in "Already filled? Continue from where you left" flow
    // -----------------------------------------------------------------------

    private static String encryptOTP(String plainOtp) {
        Blob privateKey = Blob.valueOf('046QdQEH24AgGa==');
        Blob encryptedBlob = Crypto.encryptWithManagedIV('AES128', privateKey, Blob.valueOf(plainOtp));
        return EncodingUtil.convertToHex(encryptedBlob);
    }

    private static String decryptOTP(String encryptedHex) {
        Blob privateKey = Blob.valueOf('046QdQEH24AgGa==');
        Blob encryptedBlob = EncodingUtil.convertFromHex(encryptedHex);
        Blob decryptedBlob = Crypto.decryptWithManagedIV('AES128', privateKey, encryptedBlob);
        return decryptedBlob.toString();
    }

    @RemoteAction
    public static resSendReturnResult sendLoginOTP(String existingCompanyName) {
        resSendReturnResult status = new resSendReturnResult();
        // try {
            Lead l = [SELECT Id, Email, Login_OTP__c, Company 
                    FROM Lead 
                    WHERE (Company =: existingCompanyName OR Id =: existingCompanyName) 
                    AND Status <> 'Qualified' 
                    LIMIT 1];

            Integer rawOtpInt = Math.mod(Math.abs(Crypto.getRandomInteger()), 900000) + 100000;
            String plainOtp = String.valueOf(rawOtpInt);

            l.Login_OTP__c = encryptOTP(plainOtp);
            update l;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // mail.setToAddresses(new List<String>{ l.Email });
            mail.setSubject('Your OTP for Experian Portal Login');
            mail.setHtmlBody(
                '<p>Dear Member,</p>' +
                '<p>Your OTP to continue your Experian membership application is:</p>' +
                '<h2 style="color:#982881;">' + plainOtp + '</h2>' +
                '<p>This OTP is valid for this session only. Please do not share it with anyone.</p>' +
                '<p>Regards,<br/>Experian Team</p>'
            );
            mail.setTargetObjectId(l.Id);
            mail.setSaveAsActivity(true);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });

            status.status = true;
            status.msg = 'OTP sent to ' + l.Email;
            status.leadId = l.Id;
            status.leadEmail = l.Email;

            System.debug('Status ==> ' + status);

        // } catch (QueryException e) {
        //     status.status = false;
        //     status.msg = 'No record found. Please check the company name.';
        // } catch (Exception e) {
        //     status.status = false;
        //     status.msg = 'Something went wrong. Please try again.';
        //     System.debug('sendLoginOTP Exception: ' + e);
        // }
        return status;
    }


    @RemoteAction
    public static resSendReturnResult sendVerificationOTP(String leadId) {
        System.debug('leadId ==> ' + leadId);
        resSendReturnResult status = new resSendReturnResult();
        // try {
            Lead l = [SELECT Id, Email, Verification_OTP__c, Company 
                    FROM Lead 
                    WHERE Id = :leadId
                    AND Status <> 'Qualified' 
                    LIMIT 1];

            Integer rawOtpInt = Math.mod(Math.abs(Crypto.getRandomInteger()), 900000) + 100000;
            String plainOtp = String.valueOf(rawOtpInt);

            l.Verification_OTP__c = encryptOTP(plainOtp);
            update l;

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('Your OTP for Experian Portal Verification');
            mail.setHtmlBody(
                '<p>Dear Member,</p>' +
                '<p>Your OTP to continue your Experian Portal Verification is:</p>' +
                '<h2 style="color:#982881;">' + plainOtp + '</h2>' +
                '<p>This OTP is valid for this session only. Please do not share it with anyone.</p>' +
                '<p>Thanks & Regards,<br/>Experian Customer Support</p>'
            );
            mail.setTargetObjectId(l.Id);
            mail.setSaveAsActivity(true);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });

            status.status = true;
            status.msg = 'OTP sent to ' + l.Email;
            status.leadId = l.Id;
            status.leadEmail = l.Email;

        // } catch (QueryException e) {
        //     status.status = false;
        //     status.msg = 'Lead not found. Please try again.';
        //     System.debug('sendVerificationOTP QueryException: ' + e);
        // } catch (Exception e) {
        //     status.status = false;
        //     status.msg = 'Something went wrong: ' + e.getMessage();
        //     System.debug('sendVerificationOTP Exception: ' + e);
        // }
        return status;
    }

    @RemoteAction
    public static resSendReturnResult resendLoginOTP(String leadId) {
        resSendReturnResult status = new resSendReturnResult();
        // try {
            Lead l = [SELECT Id, Email, Login_OTP__c FROM Lead WHERE Id =: leadId LIMIT 1];

            // Decrypt stored OTP and resend
            String plainOtp = decryptOTP(l.Login_OTP__c);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // mail.setToAddresses(new List<String>{ l.Email });
            mail.setSubject('Your OTP for Experian Portal Login');
            mail.setHtmlBody(
                '<p>Dear Member,</p>' +
                '<p>Your OTP to continue your Experian membership application is:</p>' +
                '<h2 style="color:#982881;">' + plainOtp + '</h2>' +
                '<p>This OTP is valid for this session only. Please do not share it with anyone.</p>' +
                '<p>Regards,<br/>Experian Team</p>'
            );
            mail.setTargetObjectId(l.Id);
            mail.setSaveAsActivity(true);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });

            status.status = true;
            status.msg = 'OTP resent to ' + l.Email;

        // } catch (QueryException e) {
        //     status.status = false;
        //     status.msg = 'Unable to resend OTP. Please try again.';
        // } catch (Exception e) {
        //     status.status = false;
        //     status.msg = 'Something went wrong. Please try again.';
        //     System.debug('resendLoginOTP Exception: ' + e);
        // }
        return status;
    }

    @RemoteAction
    public static resSendReturnResult resendVerificationOTP(String leadId) {
        resSendReturnResult status = new resSendReturnResult();
        // try {
            Lead l = [SELECT Id, Email, Verification_OTP__c FROM Lead WHERE Id =: leadId LIMIT 1];

            // Decrypt stored OTP and resend
            String plainOtp = decryptOTP(l.Verification_OTP__c);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // mail.setToAddresses(new List<String>{ l.Email });
            mail.setSubject('Your OTP for Experian Portal Verification');
            mail.setHtmlBody(
                '<p>Dear Member,</p>' +
                '<p>Your OTP to continue your Experian Portal Verification is:</p>' +
                '<h2 style="color:#982881;">' + plainOtp + '</h2>' +
                '<p>This OTP is valid for this session only. Please do not share it with anyone.</p>' +
                '<p>Thanks & Regards,<br/>Experian Customer Support</p>'
            );
            mail.setTargetObjectId(l.Id);
            mail.setSaveAsActivity(true);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });

            status.status = true;
            status.msg = 'OTP resent to ' + l.Email;

        // } catch (QueryException e) {
        //     status.status = false;
        //     status.msg = 'Unable to resend OTP. Please try again.';
        // } catch (Exception e) {
        //     status.status = false;
        //     status.msg = 'Something went wrong. Please try again.';
        //     System.debug('resendLoginOTP Exception: ' + e);
        // }
        return status;
    }

    @RemoteAction
    public static resSendReturnResult verifyLoginOTP(String enteredOtp, String leadId) {
        resSendReturnResult status = new resSendReturnResult();
        try {
            Lead l = [SELECT Id, Email, Login_OTP__c FROM Lead WHERE Id =: leadId LIMIT 1];

            String plainOtp = decryptOTP(l.Login_OTP__c);

            if (plainOtp == enteredOtp) {
                status.status = true;
                status.msg = 'OTP Verified';
                status.leadId = l.Id;
                status.leadEmail = l.Email;
            } else {
                status.status = false;
                status.msg = 'Invalid OTP. Please try again.';
            }

        } catch (QueryException e) {
            status.status = false;
            status.msg = 'Something went wrong. Please try again.';
        } catch (Exception e) {
            status.status = false;
            status.msg = 'Something went wrong. Please try again.';
            System.debug('verifyLoginOTP Exception: ' + e);
        }
        return status;
    }

    @RemoteAction
    public static resSendReturnResult verifyVerificationOTP(String OTP, String Id) {
        resSendReturnResult status = new resSendReturnResult();
        try {
            Lead l = [SELECT Id, Email, Verification_OTP__c, Status FROM Lead WHERE Id =: Id LIMIT 1];
            
            String plainOtp = decryptOTP(l.Verification_OTP__c);

            if (plainOtp == OTP) {
                l.Status = 'Member details';
                update l;
                status.status = true;
                status.msg = 'OTP Verified';
                status.leadId = l.Id;
                status.leadEmail = l.Email;
            } else {
                status.status = false;
                status.msg = 'Invalid OTP. Please try again.';
            }

        } catch (QueryException e) {
            status.status = false;
            status.msg = 'Something went wrong. Please try again.';
        } catch (Exception e) {
            status.status = false;
            status.msg = 'Something went wrong. Please try again.';
            System.debug('verifyVerificationOTP Exception: ' + e);
        }
        return status;
    }

    // -----------------------------------------------------------------------

    @RemoteAction
    public static returnLeadInfo getLeadInfo(String existingCompanyName){

        returnLeadInfo status = new returnLeadInfo();

        Set<String> leadFieldList = Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().keySet();
        List<String> strList = new List<String>();
        String query = '';
        String SobjectApiName = 'Lead';
        String Qualified = 'Qualified';
        Lead LeadList = new Lead();
        strList.addAll(leadFieldList);
        String fields = string.join(strList,',');

        System.debug('existingCompanyName--->'+existingCompanyName);
        try{
            query = 'SELECT ' + fields + ', (SELECT Name,Web_User_First_Name__c,Web_User_Job_Title__c,Web_User_Last_Name__c,Web_User_Email__c,Web_User_Tel_No__c, Web_User_Type__c FROM Web_User_Details__r ), (SELECT GST_Amount__c,Lead__c,GST__c,Initial_Payment_Amount__c,Name,Product__c,Product__r.Name,Product__r.Fee_Plan_Type__c,Total_Payment_Amount__c FROM Payment_Detail__r) FROM ' + SobjectApiName + ' WHERE (Company =: existingCompanyName OR Id =: existingCompanyName ) AND Status <>: Qualified Limit 1';
            System.debug('--->Fininding Company query--->'+query);
            LeadList = Database.query(query);
            System.debug('--->Fininding Company'+LeadList);
            becomMemberApex bMA = new becomMemberApex();
            OTPApex OA = new OTPApex();
            List<uploadDoc> uploadDoclist = new List<uploadDoc>();
            detailMemberApex dMA = new detailMemberApex();
            verfiedData vD = new verfiedData();
            authUserIdRequestorApex aUIRA = new authUserIdRequestorApex();
            List<webUserDetailsApex> wUDA = new List<webUserDetailsApex>();
            List<paymentDetailApex> pDA = new List<paymentDetailApex>();
            sentForAgreementReturnResult sFAR = new sentForAgreementReturnResult();
            returnDocsStatus rdSS = new returnDocsStatus();
            Boolean EBS_Payment_Status_c;
            // if(LeadList.Status == '')

            System.debug('LeadList--->---------------->-------------------------->'+LeadList);

            status.leadId = LeadList.Id;
            bMA.new_lead_Status = false;
            // bMA.Tel_No_Nodal_c = LeadList.Tel_No_Nodal__c;
            // bMA.First_Name_Nodal_c = LeadList.First_Name_Nodal__c;
            // bMA.Last_Name_Nodal_c = LeadList.Last_Name_Nodal__c;
            // bMA.Official_Email_Address_Nodal_c = LeadList.Official_Email_Address_Nodal__c;
            // bMA.Job_Title_Nodal_c = LeadList.Job_Title_Nodal__c;

            bMA.First_Name_AuSig_c = LeadList.First_Name_AuSig__c;
            bMA.Last_Name_AuSig_c = LeadList.Last_Name_AuSig__c;
            bMA.Job_Title_AuSig_c = LeadList.Job_Title_AuSig__c;
            bMA.DIN_AuSig_c = LeadList.DIN__c;
            bMA.Official_Email_Address_AuSig_c = LeadList.Official_Email_Address_AuSig__c;
            bMA.Tel_No_AuSig_c = LeadList.Tel_No_AuSig__c;
            bMA.authSignListValue=LeadList.Selected_Authorised_Signatory__c;

            bMA.Company = LeadList.Company;
            bMA.Company_Type = LeadList.Type__c;
            //add by shashank 5 july,2023
            bMA.Other_Type_c = LeadList.Other_Type__c;
            if(LeadList.Selected_Company_Name__c=='As Per User'){
                bMA.SelectedCompanyOptionByUser = true;
                bMA.SelectedCompanyOptionBy=LeadList.Selected_Company_Name__c;
            }else if(LeadList.Selected_Company_Name__c=='As Per MCA'){
                bMA.SelectedCompanyOptionByMCA = true;
                bMA.SelectedCompanyOptionBy=LeadList.Selected_Company_Name__c;
            }
           // bMA.Email = LeadList.Email;
            bMA.RBI_Certificate_Verified_c = LeadList.RBI_Certificate_Verified__c;
            bMA.Pan_no_c = LeadList.Pan_no__c;
            bMA.GST_State_c = LeadList.GST_State__c;
            bMA.GST_No_c = LeadList.GST_No__c;
            bMA.Website = LeadList.Website;
            bMA.CIN_Company_Identification_Number_c = LeadList.CIN_Company_Identification_Number__c;
            bMA.Date_of_Incorporation_c = LeadList.Date_of_Incorporation__c;
            bMA.Data_Pull_id_s_c = LeadList.Data_Pull_id_s__c;

            //add by shashank on 15 sept ,2022  purpose to check gst registered or not
            if(LeadList.GST_Registered__c =='Yes' || LeadList.GST_No__c!=null){
                bMA.GST_Registered_c='Yes';
            }else if(LeadList.GST_Registered__c =='No' || LeadList.GST_No__c==null){
                bMA.GST_Registered_c='No';
            }

            FetchMoreDetailsByCIN fmdbc=new FetchMoreDetailsByCIN();
            FetchMoreDetailsByCIN.returnResult cinReturn=fmdbc.getCtoCinAPI(LeadList.CIN_Company_Identification_Number__c);
            bMA.clsDirectList= cinReturn.returnVerifyCompanyCin.clsDirectorLIst;

            vD.GST_Verification_Remark_c = LeadList.GST_Verification_Remark__c;
            vD.GST_Verified_c = LeadList.GST_Verified__c;
            vD.Pan_Verification_Remark_c = LeadList.Pan_Verification_Remark__c;
            vD.Pan_Verified_c = LeadList.Pan_Verified__c;
            vD.RBI_List_Verification_Remarks_c=LeadList.RBI_List_Verification_Remarks__c;
          

            vD.CIN_Number_Verified_c=LeadList.CIN_Number_Verified__c;

            bMA.verfiedData = vD;

            System.debug(bMA);

            // uploaded doc list
            
            List<ContentDocumentLink> aaa = new List<ContentDocumentLink>();
            aaa = [
                SELECT ContentDocumentId,Id,IsDeleted,LinkedEntityId,ShareType,SystemModstamp,Visibility 
                FROM ContentDocumentLink WHERE LinkedEntityId =: LeadList.Id
                ];

            Set<Id> documentIds = new Set<Id>();
            for (ContentDocumentLink cdl : aaa) {
                documentIds.add(cdl.ContentDocumentId);
                System.debug('cdl.ContentDocumentId : '+cdl.ContentDocumentId);
            }
            List<ContentDocument> documents = new List<ContentDocument>();
            documents = [SELECT Id,Title FROM ContentDocument WHERE Id IN :documentIds];

            for (ContentDocument x : documents) {
                uploadDoc doc = new uploadDoc();
                
                doc.Id = x.Id;
                doc.Title = x.Title;
                System.debug('doc.Title : '+x.Title);

                uploadDoclist.add(doc);
            }
           
            OA.OTP = LeadList.OTP__c;

            // dMA.First_Name_AuSig_c = LeadList.First_Name_AuSig__c;
            // dMA.Last_Name_AuSig_c = LeadList.Last_Name_AuSig__c;
            // dMA.Job_Title_AuSig_c = LeadList.Job_Title_AuSig__c;
            // dMA.Official_Email_Address_AuSig_c = LeadList.Official_Email_Address_AuSig__c;
            // dMA.Tel_No_AuSig_c = LeadList.Tel_No_AuSig__c;
           
            dMA.Tel_No_Nodal_c = LeadList.Tel_No_Nodal__c;
            dMA.First_Name_Nodal_c = LeadList.First_Name_Nodal__c;
            dMA.Last_Name_Nodal_c = LeadList.Last_Name_Nodal__c;
            dMA.Official_Email_Address_Nodal_c = LeadList.Official_Email_Address_Nodal__c;
            dMA.Job_Title_Nodal_c = LeadList.Job_Title_Nodal__c;
            dMA.Email = LeadList.Official_Email_Address_Nodal__c;

            dMA.Billing_Contact_Person_c = LeadList.Billing_Contact_Person__c;
            dMA.Billing_Contact_Details_c = LeadList.Billing_Contact_Details__c;
            dMA.Billing_Email_Address_c = LeadList.Billing_Email_Address__c;
            dMA.Billing_Job_Title_c = LeadList.Billing_Job_Title__c;
            dMA.Billing_City_c = LeadList.Billing_City__c;
            dMA.Billing_State_c = LeadList.Billing_State__c;
            dMA.Billing_Street_c = LeadList.Billing_Street__c;
            dMA.Billing_Zip_Postal_Code_c = LeadList.Billing_Zip_Postal_Code__c;
            dMA.Billing_Country_c = LeadList.Billing_Country__c;
            dMA.Authorised_Signatory_Same_As_Nodal_Offic_c = LeadList.Authorised_Signatory_Same_As_Nodal_Offic__c;
            System.debug('BEFORE INSIDE IF -> '+LeadList.Billing_Zip_Postal_Code__c);
            System.debug('BEFORE  INSIDE IF -> '+LeadList.Billing_Country__c);
            if((LeadList.LegalDesk_Agreement_Document_Id__c != null || LeadList.LegalDesk_Agreement_Document_Id__c != '') && (LeadList.Legal_desk_docket_id__c != null || LeadList.Legal_desk_docket_id__c != '') ){
               	System.debug('INSIDE IF -> '+LeadList.LegalDesk_Agreement_Document_Id__c);
                System.debug('INSIDE IF -> '+LeadList.Legal_desk_docket_id__c);
                if(!Test.isRunningTest()){
                   //Invoke mock web service response if not calling from test
                   sFAR.pdf = RestApiGetdocketInfo.get_pdf_content(LeadList.Id);
                }
                System.debug('BEFORE INSIDE IF -> '+sFAR.pdf);
                sFAR.expSign = LeadList.Agreement_Experian_Status__c;
                sFAR.cusSign = LeadList.Agreement_Customer_Status_Stages__c;
                sFAR.status = true;
                sFAR.msg = 'We have mailed the agreement copy to you. Please follow the instructions sent on the mail to complete the agreement signing.';
            }
            if(LeadList.First_Name_Auth_Usr_Req__c != null){
                aUIRA.First_Name_Auth_Usr_Req_c = LeadList.First_Name_Auth_Usr_Req__c;
                aUIRA.Last_Name_Auth_Usr_Req_c = LeadList.Last_Name_Auth_Usr_Req__c;
                aUIRA.Official_Email_Auth_Usr_Req_c = LeadList.Official_Email_Auth_Usr_Req__c;
                aUIRA.Tel_No_Auth_Usr_Req_c = LeadList.Tel_No_Auth_Usr_Req__c;
                aUIRA.Job_Title_Auth_Usr_Req_c = LeadList.Job_Title_Auth_Usr_Req__c;
                bMA.Auth_Usr_Id_Requestor_CheckBox_c = true;
            }
            if(LeadList.status == 'Agreement Received'){
                rdSS = getsignedCopy(LeadList.Id);
            }
            if(LeadList.EBS_Payment_Status__c == 'Approved'){
                EBS_Payment_Status_c = false;
            }else{
                EBS_Payment_Status_c = true;
            }

            // wUDA = 

            switch on LeadList.Status {
                when 'Document Verifiying'{
                    System.debug('Document Verifiying');
                    status.Email = LeadList.Email;
                    status.documentVerifying=true;
                }
                when 'OTP Verified' {
                    System.debug('OTP');
                    
                    status.becomMemberApex = bMA;
                    status.uploadDoclist  = uploadDoclist;

                    // status.OTPApex = OA;
                }
                when 'Member details' {
                    System.debug('MEMBER');
                    status.becomMemberApex = bMA;
                    status.OTPApex = OA;
                    status.uploadDoclist  = uploadDoclist;
                    status.detailMemberApex = dMA;
                    
                }
                when 'Additional details' {
                    System.debug('ADD MEMBER');
                    status.becomMemberApex = bMA;
                    status.OTPApex = OA;
                    status.uploadDoclist  = uploadDoclist;
                    status.detailMemberApex = dMA;
                    status.webUserDetailsApex = LeadList.Web_User_Details__r;
                    status.authUserIdReqApex = aUIRA;
                    
                }
                when 'Plan selection' {
                    System.debug('MEMBER');
                    status.becomMemberApex = bMA;
                    status.OTPApex = OA;
                    status.uploadDoclist  = uploadDoclist;
                    status.detailMemberApex = dMA;
                    status.webUserDetailsApex = LeadList.Web_User_Details__r;
                    status.authUserIdReqApex = aUIRA;
                    status.planSelectionApex= LeadList.Payment_Detail__r;
                    //status.paymentDetailApexForPlan = LeadList.Payment_Detail__r;
                }
                when 'Payment' {
                    System.debug('PAYMENT');
                    status.becomMemberApex = bMA;
                    status.OTPApex = OA;
                    status.uploadDoclist  = uploadDoclist;
                    status.detailMemberApex = dMA;
                    status.webUserDetailsApex = LeadList.Web_User_Details__r;
                    status.authUserIdReqApex = aUIRA;
                    status.planSelectionApex= LeadList.Payment_Detail__r;
                    status.paymentDetailApexForPlan = LeadList.Payment_Detail__r;
                    status.paymentNextButton = EBS_Payment_Status_c;
                }
                
                when 'Sent for Agreement' {
                    System.debug('SENT FOR AGREEMENT');
                    status.becomMemberApex = bMA;
                    status.OTPApex = OA;
                    status.uploadDoclist  = uploadDoclist;
                    status.detailMemberApex = dMA;
                    status.webUserDetailsApex = LeadList.Web_User_Details__r;
                    status.authUserIdReqApex = aUIRA;
                    status.planSelectionApex= LeadList.Payment_Detail__r;
                    status.paymentDetailApexForPlan = LeadList.Payment_Detail__r;
                    status.sentForAgreementReturnResult = sFAR;
                    status.paymentNextButton = EBS_Payment_Status_c;
                    
                }
                when 'Agreement Received' {
                    System.debug('Agreement Received');
                    status.becomMemberApex = bMA;
                    status.OTPApex = OA;
                    status.uploadDoclist  = uploadDoclist;
                    status.detailMemberApex = dMA;
                    status.webUserDetailsApex = LeadList.Web_User_Details__r;
                    status.authUserIdReqApex = aUIRA;
                    status.planSelectionApex= LeadList.Payment_Detail__r;
                    status.paymentDetailApexForPlan = LeadList.Payment_Detail__r;
                    status.sentForAgreementReturnResult = sFAR;
                    status.returnDocsStatus = rdSS;
                    status.paymentNextButton = EBS_Payment_Status_c;
                    
                }
                when else {System.debug('ELSE');}
            }

            status.status = true;

        }
        catch(QueryException e){
            system.debug('e'+e.getLineNumber()+' msg '+e);
            //status.msg = String.valueOf(e);  
            status.msg = 'No record found';  
            status.instruction = 'enter correct url or contact Experian Support';
            status.sing = 'fa fa-exclamation-triangle';
            status.status = false;
            System.debug('Catch---------->--------------->-------------->'+e);
        }
        catch(Exception e){
            //status.msg = String.valueOf(e);  
            status.msg = 'No record found'; 
            status.instruction = 'enter correct url or contact Experian Support';
            status.sing = 'fa fa-exclamation-triangle';
            status.status = false;
            System.debug('Catch---------->--------------->-------------->'+e);
        }
        return status;
    }

    

    @RemoteAction
    public static resSendReturnResult resendOTP(String Id){

        API_LOG__c ap=new API_LOG__c();
        ap.Request_Source__c='Resend OTP';
        
        resSendReturnResult status = new resSendReturnResult();

        try{
            Lead l = [SELECT Id,Company,Resend_OTP__c FROM Lead WHERE Id =: Id];
            // l.Resend_OTP__c = true;
            // ap.Company_Name__c=l.Company;

            // ap.Request__c = String.valueof(l);

            update l;
            
            status.status = true;
            status.msg = 'sent to your email';
            //ap.Response__c= String.valueof(status);

        }catch(QueryException e){
            ap.Exception_Description__c=e.getMessage();
            status.msg = 'fail to send email please contact Experian Support!';
            // status.sing = 'fa fa-exclamation-triangle';
            status.status = false;
        }
        // insert ap;
        return status;
    }

    
    

    @RemoteAction
    public static returnLeadInfo  attachBlob(String parentId, String fileName, String fileTitle, String base64BlobValue){
        returnLeadInfo status = new returnLeadInfo();
        try{
            System.debug('fileTitle--> '+fileTitle);

            ContentVersion contentVersion = new ContentVersion();
            contentVersion.ContentLocation = 'S'; // S = Stored in Salesforce
            contentVersion.PathOnClient = fileName;
            //contentVersion.Title = fileName;
            contentVersion.Title = fileTitle;
            contentVersion.isMajorVersion = false;
            contentVersion.VersionData = EncodingUtil.base64Decode(base64BlobValue);
            
            upsert contentVersion;

            contentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id];

            ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
            contentDocumentLink.ContentDocumentId = contentVersion.ContentDocumentId;
            contentDocumentLink.LinkedEntityId = parentId;
            contentDocumentLink.ShareType = 'V';

            upsert contentDocumentLink;

            ContentDistribution cd = new ContentDistribution();
            cd.Name = fileName;
            cd.ContentVersionId = contentVersion.Id;
            cd.PreferencesAllowViewInBrowser= true;
            cd.PreferencesLinkLatestVersion=true;
            cd.PreferencesNotifyOnVisit=false;
            cd.PreferencesPasswordRequired=false;
            cd.PreferencesAllowOriginalDownload= true;

            upsert cd;

            System.debug('Coontent Distribution URL--> '+cd);

            status.msg = 'Thank you for uploading the document';
            status.instruction = 'We will get back to you shortly';
            status.sing = 'fa fa-thumbs-up';
            status.status = true;
            
        }
        catch(QueryException e){
            status.msg = 'Wrong url or you may have entered wrong Id!';
            status.instruction = 'enter correct url or contact Experian Support';
            status.sing = 'fa fa-exclamation-triangle';
            status.status = false;
        }catch(Exception e){
            //status.msg = 'Wrong url or you may have entered wrong Id!';
            status.msg = String.valueOf(e);
            status.instruction = 'enter correct url or contact Experian Support';
            status.sing = 'fa fa-exclamation-triangle';
            status.status = false;
        }
        
        return status;
    }

    @RemoteAction
    public static returnDocsStatus getsignedCopy(String Id){

        returnDocsStatus rdStatus = new returnDocsStatus();

        try {

            List<Attachment> allAttachmentParentContains = [SELECT Id,Name,Body,BodyLength FROM attachment WHERE parentId =: Id order by CreatedDate desc];

            System.debug('rdStatus'+allAttachmentParentContains);
            // attachments msg
            if(allAttachmentParentContains.size() > 0){
                System.debug('rdStatus'+allAttachmentParentContains[0].Name);
                if(allAttachmentParentContains[0].Name == 'Agreement Copy_signedByBothParty.pdf' || allAttachmentParentContains[0].Name=='Agreement Copy_signedByCustomer.pdf'){
                    System.debug('rdStatus'+allAttachmentParentContains[0].Name);
                    Blob csvBlob = allAttachmentParentContains[0].Body;
                    String csvString = EncodingUtil.base64Encode(csvBlob);
                    rdStatus.csvAsString = csvString;
                    System.debug('rdStatus'+rdStatus);
                    rdStatus.status = true;
                }else{
                    rdStatus.status = false;
                    System.debug('rdStatus FIRST ELSE');
                }
            }else{
                System.debug('rdStatus 2 ELSE');
                rdStatus.status = false;
            }

        } catch (Exception e) {
            System.debug('e->'+e);
            rdStatus.status = false;
        }
        return rdStatus;

    }
    @RemoteAction
    public static PAYNow getTokenForPayNow(String CompanyName,Integer total_amount,String email,String mobile){

        PAYNow p=new PAYNow();
        //String total_amt=String.valueof(total_amount);
       // String total_amt='1';
         integer total_amt=total_amount;
        String merchant_id=system.label.pay_now_merchant_id;
        String salt_id=system.label.pay_now_salt_id;

        String referanceId = datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String[] separte_valid_refernce=referanceId.split('-');
        String[] seconds_valid_ref=separte_valid_refernce[2].split(':');
        String made_valid_reference=separte_valid_refernce[0]+''+separte_valid_refernce[1]+''+seconds_valid_ref[0]+''+seconds_valid_ref[1]+''+seconds_valid_ref[2];
       
        String make_string=merchant_id+'|'+made_valid_reference+'|'+total_amt+'|'+ '' +'|'+ '' +'|'+mobile+'|'+email+'|'+ '' +'|'+ '' +'|'+''+'|'+ '' +'|'+ '' +'|'+ '' +'|'+''+'|'+''+'|'+''+'|'+salt_id;
        p.has_Stri=make_string;
        Blob myBlob = Blob.valueOf(make_string);
        Blob md5hash = Crypto.generateDigest('MD5', myBlob);
        String token=EncodingUtil.convertToHex(md5hash);

       // String token=EncodingUtil.base64encode(md5hash);
        //String token=String.valueOf(md5hash);
        
        p.p_token=token;
        p.p_made_valid_reference=made_valid_reference;

        Payment_Detail__c pd=new Payment_Detail__c();
        pd.Transaction_NUmber__c=made_valid_reference;
        pd.Amount__c=String.valueOf(total_amt);
        pd.Payment_Source__c='Pay Now';
        pd.Company_Name__c=CompanyName;
        pd.Payment_Status__c='Initiated';
        pd.Email__c=email;
        insert pd;
        return p;

    }
    @RemoteAction
    public static PayNowUpdateStatus update_payment_status_pay_now(String transaciton_id,String lead_id,Double amount,String date_time){

        PayNowUpdateStatus p=new PayNowUpdateStatus();
        try{
            Payment_Detail__c pd=[SELECT Id,Payment_Status__c,Transaction_NUmber__c FROM Payment_Detail__c WHERE Transaction_NUmber__c =:transaciton_id];
            
            Payment_Detail__c pd_upd=new Payment_Detail__c();
            pd_upd.Id=pd.Id;
            pd_upd.Payment_Status__c='Success';
            upsert pd_upd;

            
            Lead l=[SELECT Id,EBS_Payment_Status__c,Transaction_Id__c FROM Lead WHERE Id=:lead_id];

            Lead l_upd=new Lead();
            l_upd.Id=l.Id;
            l_upd.EBS_Payment_Status__c='Approved';
            l_upd.Transaction_Id__c=transaciton_id;
            l_upd.Total_Payment_Received__c=amount;
            l_upd.Payment_Date_Time__c=System.now();
            upsert l_upd;
            
            p.status_value=true;
        }catch(Exception e){
            p.status_value=false;
        }
        
    
       
        return p;

    }

    @RemoteAction
    public static List <Map<String, Object>> getPlan(){
        List <Map<String, Object>> maplistObject = new List <Map<String, Object>>();
        
        try {
            List<Product__c> plist = [ SELECT Id,Name,Examples__c,Description__c,Fee_Plan_Type__c,Initial_Payment_Amount__c, ( SELECT Id,Name,Monthly_Volumes__c,Price_Per_Report__c FROM Product_Line_Items__r ORDER BY Name ) FROM Product__c WHERE Active__c != true AND Fee_Plan_Type__c = 'Products' ];
            for (Product__c p : plist) {
                Map<String, Object> mapObject = new Map<String, Object>();
                mapObject.put('Id',p.Id);
                mapObject.put('Name',p.Name);
                mapObject.put('Examples__c',p.Examples__c);
                mapObject.put('Description__c',p.Description__c);
                mapObject.put('Fee_Plan_Type__c',p.Fee_Plan_Type__c);
                mapObject.put('Initial_Payment_Amount__c',p.Initial_Payment_Amount__c);
                mapObject.put('Product_Line_Items__r',p.Product_Line_Items__r);
                mapObject.put('Selected__c',false);
                maplistObject.add(mapObject);
            }
            // return JSON.serialize(maplistObject);
            return maplistObject;
        } catch (Exception e) {
            return null;
        }
    }

    public static  becomMemberApex  becomMemberparseTarget(String json) {
        return (becomMemberApex ) System.JSON.deserialize(json, becomMemberApex.class);
    }

    public static detailMemberApex  detailsMemberparseTarget(String json) {
        return ( detailMemberApex ) System.JSON.deserialize(json, detailMemberApex.class);
    }
    
    public static APILoginDetail  APILoginDetailparseTarget(String json) {
        return ( APILoginDetail ) System.JSON.deserialize(json, APILoginDetail.class);
    }

    public static List < webUserDetailsApex >  webUserDetailsparseTarget(String json) {
        return ( List < webUserDetailsApex > ) System.JSON.deserialize(json, List < webUserDetailsApex >.class);
    }

    public static authUserIdRequestorApex  authUserIdRequestorparseTarget(String json) {
        return ( authUserIdRequestorApex ) System.JSON.deserialize(json, authUserIdRequestorApex.class);
    }

    public static List < paymentDetailApex >  paymentDetailApexTarget(String json) {
        return ( List < paymentDetailApex > ) System.JSON.deserialize(json, List < paymentDetailApex >.class);
    }
    public static List < paymentDetailApexForPlan >  paymentDetailApexForPlanTarget(String json) {
        return ( List < paymentDetailApexForPlan > ) System.JSON.deserialize(json, List < paymentDetailApexForPlan >.class);
    }


    @RemoteAction
    public static PaymentStatus send_pay_details(String companyName,double amount,String name,String email,String mobile,String lead_id){
        
        PaymentStatus ps=common_method_for_payment(companyName,amount,name,email,mobile,lead_id);
        return ps;
    }

    public static PaymentStatus common_method_for_payment(String companyName,double amount,String name,String email,String mobile,String lead_id){

        String referanceId = datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
        String[] separte_valid_refernce=referanceId.split('-');
        String[] seconds_valid_ref=separte_valid_refernce[2].split(':');
        String made_valid_reference=separte_valid_refernce[0]+''+separte_valid_refernce[1]+''+seconds_valid_ref[0]+''+seconds_valid_ref[1]+''+seconds_valid_ref[2];
        String pay_URL = system.label.uat_payment_gateway_url;

        Payment_Detail__c pd=new Payment_Detail__c();
        pd.Transaction_NUmber__c=made_valid_reference;
        pd.Amount__c=String.valueof(amount);
        pd.Company_Name__c=companyName;
        //pd.Amount__c = '1';
        pd.Payment_Source__c='Pay Using a Link';
        pd.Payment_Status__c='Initiated';
        pd.Email__c=email;
        
        PaymentStatus ps=new PaymentStatus();
        

        System.debug('=============----->'+pay_URL);

         //Final Map
         Map<String, Object> map_rpp_pay_Final = new Map<String, Object>();  

         //RPPRequired 
         Map<String, Object> map_rpp_required = new Map<String, Object>();  
         map_rpp_required.put('Token', made_valid_reference);
         map_rpp_required.put('UniqueID', 0);
         map_rpp_required.put('Hashcode','');
         map_rpp_required.put('RequestType','request');
         map_rpp_required.put('TxnType','');
         map_rpp_required.put('MerchantMID',system.label.merchant_mid);
         map_rpp_required.put('MerchantID',system.label.merchant_id);
         map_rpp_required.put('MerchantName',system.label.merchant_name);
        // map_rpp_required.put('MerchantEmailMobile',system.label.merchant_email);
         map_rpp_required.put('MerchantEmailMobile','');
         map_rpp_required.put('Aspid','');
         map_rpp_required.put('AspMasterID',0);
         map_rpp_required.put('ChannelName','');
         map_rpp_required.put('ChannelTypeName','');
         map_rpp_required.put('IPAddress','');

        //RPPRequired 
        Map<String, Object> map_rpp_response = new Map<String, Object>();  
        map_rpp_response.put('ErrorCode', '');
        map_rpp_response.put('ErrorDescription', '');

        Map<String, Object> map_rpp_data = new Map<String, Object>();  
        map_rpp_data.put('CustomerName', name);
        map_rpp_data.put('CustomerEmailMobile', email);
        map_rpp_data.put('CustomerAlternateEmailMobile', mobile);
        map_rpp_data.put('Amount', amount);
        //map_rpp_data.put('Amount', 1);
        map_rpp_data.put('NoteFromMerchant', 'This payment is for Experian Bureau Membership');
        map_rpp_data.put('InvoiceNo', '');
        map_rpp_data.put('DistributerIdentifier', '');
        map_rpp_data.put('AgentName', '');
        map_rpp_data.put('AgentMobileNo', '');
        map_rpp_data.put('CustomerIdentifier', '');
        map_rpp_data.put('ProductIdentifier', '');
        map_rpp_data.put('CartDetails', '');
        map_rpp_data.put('InvoiceAmount', '');
        map_rpp_data.put('InvoiceDiscountAmount', '');
        map_rpp_data.put('InvoiceSurchargeAmount', '');
        map_rpp_data.put('AutoDebit', false);
        map_rpp_data.put('AccountHolderName', '');
        map_rpp_data.put('StartDate', '');
        map_rpp_data.put('EndDate', '');
        map_rpp_data.put('MaxAmount', '');
        map_rpp_data.put('Frequency', '');
        map_rpp_data.put('AmountType', '');
        map_rpp_data.put('AccountType', '');
        map_rpp_data.put('BillDate', '');
        map_rpp_data.put('ConsumerCD', '');
        map_rpp_data.put('IFSCCode', '');
        map_rpp_data.put('BankCode', '');
        map_rpp_data.put('AccountNo', '');
        map_rpp_data.put('ResendNotificationFlag', '');
        map_rpp_data.put('RequestID', '');
        map_rpp_data.put('MerchantTXNID', '');
        map_rpp_data.put('ImageName', '');
        map_rpp_data.put('Image', '');
        map_rpp_data.put('NotificationTemplateName', '');
        map_rpp_data.put('additionalParameter1', '');
        map_rpp_data.put('additionalParameter2', '');
        map_rpp_data.put('additionalParameter3', '');
        map_rpp_data.put('additionalParameter4', '');
        map_rpp_data.put('additionalParameter5', '');

        List<Object> map_rpp_data_line_item=new List<Object>();
        map_rpp_data_line_item.add(map_rpp_data);

        map_rpp_pay_Final.put('RPPRequired', map_rpp_required);
        map_rpp_pay_Final.put('RPPResponse', map_rpp_response);
        map_rpp_pay_Final.put('RPPData', map_rpp_data_line_item);

        String js = JSON.serialize(map_rpp_pay_Final);

        HttpRequest req = new HttpRequest();
        HttpResponse res  = new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(js);
        req.setEndpoint(pay_URL);
        System.debug('Input Request:' + js);

        try{
            res=http.send(req);
            system.debug('***Response'+ res.getBody());
            JSON2ApexPaymentGateway JPG=JSON2ApexPaymentGateway.parse(res.getBody());

           

            if(JPG.RPPResponse.ErrorCode == 'PYNERR000')
            {
                ps.status=JPG.RPPResponse.ErrorDescription;
                String request_id=JPG.RPPData[0].RequestID;
                String cust_email_id=JPG.RPPData[0].CustomerEmailMobile;
               
                Lead l_up=[SELECT Id,Transaction_Id__c,Pay_Later_RequestId__c,Pay_Later__c,Payment_Link_sent_to_Email_address__c FROM Lead WHERE Id=:lead_id];
                
                Lead l=new Lead();
                l.Id=l_up.Id;
                l.Pay_Later_RequestId__c=request_id;
                l.Transaction_Id__c=made_valid_reference;
                l.Pay_Later__c=true;
                l.Payment_Link_sent_to_Email_address__c=cust_email_id;
                upsert l;

                pd.PayLater_Request_type_ID__c=request_id;
                upsert pd;
               
            }else{
                ps.status=JPG.RPPResponse.ErrorDescription;
            }

        }catch(Exception e){
            System.debug('exception=============>>'+e.getMessage()+'---->'+e.getStackTraceString());
            ps.status='Faileds';
            ps.msg=e.getMessage()+' '+e.getStackTraceString();
        }

        return ps;
    } 

    public class PayNowUpdateStatus{
        public Boolean status_value;
    }

    public class PAYNow{
        public String p_token;
        public String p_made_valid_reference;
        public String has_Stri;
    }

    public class becomMemberApex {
        // public String Tel_No_Nodal_c;
        // public String First_Name_Nodal_c;
        // public String Last_Name_Nodal_c;
        // public String Official_Email_Address_Nodal_c;
        //public String Job_Title_Nodal_c;

        public String First_Name_AuSig_c;
        public String Last_Name_AuSig_c;
        public String Job_Title_AuSig_c;
        public String DIN_AuSig_c;
        public String Official_Email_Address_AuSig_c;
        public String Tel_No_AuSig_c;
        // public String Email;
        public String authSignListValue;
        public String RBI_Certificate_Verified_c;
        public String Company;
        public String Company_Type;
        public String Other_Type_c;
        public Boolean SelectedCompanyOptionByUser;
        public Boolean SelectedCompanyOptionByMCA;
        public String SelectedCompanyOptionBy;
        public String Pan_no_c;
        public String GST_State_c;
        public String GST_No_c;
        public String GST_Registered_c;
        public Boolean GST_Registered_Yes;
        public Boolean GST_Registered_No;
        public String Website;
        public String CIN_Company_Identification_Number_c;
        public Date Date_of_Incorporation_c;
        public Boolean Data_Pull_id_s_c;
        public Boolean Auth_Usr_Id_Requestor_CheckBox_c;
        public verfiedData verfiedData;
        public String RBI_List_Verification_Remarks_c;
        public String CIN_Number_Verified_c;
        public Boolean new_lead_Status; // new_lead_Status used to check and throw the error for duplicate lead based on Company Name
        public List<FetchMoreDetailsByCIN.cls_directorDetails> clsDirectList{get;set;}
        public APILoginDetail CurrentStageLocation{get;set;}
    }
    
    public class APILoginDetail{
        public string stage;
        public string startTime;
        public string EndTime;
    }
    
    public class detailMemberApex {

        
        // public String First_Name_AuSig_c;
        // public String Last_Name_AuSig_c;
        // public String Job_Title_AuSig_c;
        // public String Official_Email_Address_AuSig_c;
        // public String Tel_No_AuSig_c;

         public String Tel_No_Nodal_c;
        public String First_Name_Nodal_c;
        public String Last_Name_Nodal_c;
        public String Official_Email_Address_Nodal_c;
        public String Job_Title_Nodal_c;
        public String Email;
        
        public String Billing_Contact_Person_c;
        public String Billing_Contact_Details_c;
        public String Billing_Email_Address_c;
        public String Billing_Job_Title_c;
        public String Billing_City_c;
        public String Billing_State_c;
        public String Billing_Street_c;
        public String Billing_Zip_Postal_Code_c;
        public String Billing_Country_c;
        public Boolean Authorised_Signatory_Same_As_Nodal_Offic_c;
    }
    
    public class paymentDetailApex {
        public String GST_c;
        public String GST_Amount_c;
        public String Initial_Payment_Amount_c;
        public String Lead_c;
        public String Name;
        public String Product_c;
        public String Product_Name;
        public String Total_Payment_Amount_c;
    }
    public class paymentDetailApexForPlan {
        public String GST_c;
        public String GST_Amount_c;
        public String Initial_Payment_Amount_c;
        public String Lead_c;
        public String Name;
        public String Id;
        public String Product_c;
        public String Product_type_c;
        public String Product_Name;
        public String Total_Payment_Amount_c;
        public Boolean Selected_c;
        public List<Product_Line_Items_r> Product_Line_Items_r;
    }
    public class planSelectionApex {
        public String GST_c;
        public String GST_Amount_c;
        public String Initial_Payment_Amount_c;
        public String Lead_c;
        public String Name;
        public String Id;
        public String Product_c;
        public String Product_type_c;
        public String Product_Name;
        public String Total_Payment_Amount_c;
        public Boolean Selected_c;
        public List<Product_Line_Items_r> Product_Line_Items_r;
    }

    public class Product_Line_Items_r{
        public String Id;
        public String Name;
        public String Product_c;
        public String Monthly_Volumes_c;
        public String Price_Per_Report_c;

    }

    public class webUserDetailsApex {
        public String Id;
        public String Web_User_First_Name_c;
        public String Web_User_Last_Name_c;
        public String Web_User_Job_Title_c;
        public String Web_User_Email_c;
        public String Web_User_Tel_No_c;
        public String Web_User_Type_c;
    }

    public class authUserIdRequestorApex {
        public String First_Name_Auth_Usr_Req_c;
        public String Last_Name_Auth_Usr_Req_c;
        public String Official_Email_Auth_Usr_Req_c;
        public String Tel_No_Auth_Usr_Req_c;
        public String Job_Title_Auth_Usr_Req_c;
    }

    public class verfiedData{
        public String GST_Verification_Remark_c;
        public String GST_Verified_c;
        public String Pan_Verification_Remark_c;
        public String Pan_Verified_c;
        public String RBI_List_Verification_Remarks_c;
        public String CIN_Number_Verified_c;
    }

    public class becomeMemberReturnStatus{
        public String Id{get;set;}
        public Boolean status{get;set;}
        public String msg{get;set;}
        public String instruction{get;set;}
        public String sing{get;set;}
    }

    public class verificationMemberReturnStatus{
        public String Id{get;set;}
        public Boolean status{get;set;}
        public String msg{get;set;}
        public String color{get;set;}
        public String Email{get;set;}
        public String LeadStatus{get;set;}
    }

    public class detailMemberReturnStatus{
        public String Id{get;set;}
        public Boolean status{get;set;}
        public String msg{get;set;}
        public String instruction{get;set;}
        public String sing{get;set;}
    }

    public class webUserDetailsReturnStatus{
        public String Id{get;set;}
        public Boolean status{get;set;}
        public String msg{get;set;}
        public String instruction{get;set;}
        public String sing{get;set;}
        public List<Lead_Payment_Detail__c> paymentDetailApex;
        public List<Web_User_Details__c> webUserDetailsApex;
    }

    public class memberVerifiedReturnResult{
        public String Pan_Verification_Remark_c{get;set;}
        public String Pan_Verified_c{get;set;}
        public String GST_Verified_c{get;set;}
        public String GST_Verification_Remark_c{get;set;}
        public String GST_number{get;set;}
        public String verifiedCompanyName{get;set;}
        public String cin{get;set;}
        public Boolean CIN_Verified_c{get;set;}
        public String dateOfIncorporation{get;set;}
        public Boolean bankContains{get;set;}
        public List<FetchMoreDetailsByCIN.cls_directorDetails> clsDirectList{get;set;}
    }

    public class sentForAgreementReturnResult{
        public Boolean status{get;set;}
        public String expIcon{get;set;}
        public String cusIcon{get;set;}
        public String expSign{get;set;}
        public String cusSign{get;set;}
        public String msg{get;set;}
        public String link{get;set;}
        public String pdf{get;set;}
    }

    public class resSendReturnResult{
        public Boolean status;
        public String msg;
        public String leadId;
        public String leadEmail;
    }

    public class returnLeadInfo{
        public Boolean status{get;set;}
        public Boolean documentVerifying{get;set;}
        public String msg{get;set;}
        public String instruction{get;set;}
        public String Email{get;set;}
        public String sing{get;set;}
        public Lead leadInfo {get;set;}
        public String leadId{get;set;}
        public becomMemberApex becomMemberApex;
        public OTPApex OTPApex;
        public List<uploadDoc> uploadDoclist;
        public List<Lead_Payment_Detail__c> planSelectionApex;
        public List<Lead_Payment_Detail__c> paymentDetailApexForPlan;
        public detailMemberApex detailMemberApex;
        public authUserIdRequestorApex authUserIdReqApex;
        public List<Web_User_Details__c> webUserDetailsApex;
        public List<Lead_Payment_Detail__c> paymentDetailApex;
        public sentForAgreementReturnResult sentForAgreementReturnResult;
        public returnDocsStatus returnDocsStatus;
        public Boolean paymentNextButton;
    }
    
    public class uploadDoc{
        public String Id{get;set;}
        public String Title{get;set;}
    }

    public class OTPApex{
        public String OTP{get;set;}
    }

    public class returnPlanSelection{
        public Boolean status;
        public Boolean goNext;
        public String msg;
    }

    public class returnDocsStatus{
        // public List<Attachment> attachments;
        public Boolean status;
        public String msg;
        public String csvAsString;
    }

    public class CommonException extends Exception {}


    public class PaymentStatus{
        public String status;
      
        public String msg;
    }

    // First_Name_Auth_Usr_Req__c
    // Last_Name_Auth_Usr_Req__c
    // Official_Email_Auth_Usr_Req__c
    // Tel_No_Auth_Usr_Req__c
    // Job_Title_Auth_Usr_Req__c


}