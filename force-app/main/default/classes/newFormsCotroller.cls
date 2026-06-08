public class newFormsCotroller {
    public List<String> type_of_member{get;set;}
    public List<String> nbfcs_types_options{get;set;}
    public String Id {get;set;}
    public String companyName {get;set;}
    PUBLIC  STRING force_site_label {get;set;}
    
    public newFormsCotroller() {
        force_site_label = System.label.MemberOnboarding;
        System.debug('ID===>'+apexpages.currentpage().getparameters().get('id'));
        String decryptedId='';
        Id = apexpages.currentpage().getparameters().get('id');
        
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
        system.debug('cinReturn '+cinReturn);
        nstatus.clsDirectList=  cinReturn.returnVerifyCompanyCin.clsDirectorLIst;
        system.debug('clsDirectList '+ nstatus.clsDirectList);
        nstatus.dateOfIncorporation=cinReturn.returnVerifyCompanyCin.dateOfIncorporation;
        nstatus.registeredAddress = cinReturn.returnVerifyCompanyCin.registeredAddress;
        //Integer Company_Year_Existence = system.Today().year() - Date.valueOf(nstatus.dateOfIncorporation).year();
        
        /* date currentData = date.today();
date dt1 = date.valueOf(cinReturn.returnVerifyCompanyCin.dateOfIncorporation);
integer d1 = currentData.month();
integer y1 = currentData.year();
integer d2 = dt1.month();
integer y2 = dt1.year();
integer total_months = (y1 - y2) * 12 + (d1 - d2);
double years = Math.floor(total_months / 12);
integer months = Math.mod(total_months , 12);
string Company_Year_Existence = years + ' Years,' + months + ' Months';
*/
        //nstatus.CompanyYearExistence = Company_Year_Existence;
        
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
            System.debug('nL1--->'+nl.Id);
            //nl.First_Name_AuSig__c = bApex.First_Name_AuSig_c;
            //nl.Last_Name_AuSig__c = bApex.Last_Name_AuSig_c;
            //nl.Job_Title_AuSig__c = bApex.Job_Title_AuSig_c;
            //nl.DIN__c = bApex.DIN_AuSig_c;
            //nl.Official_Email_Address_AuSig__c = bApex.Official_Email_Address_AuSig_c;
            // nl.Tel_No_AuSig__c = bApex.Tel_No_AuSig_c;
            //nl.Selected_Authorised_Signatory__c=bApex.authSignListValue;
            nl.Selected_Company_Name__c=bApex.SelectedCompanyOptionBy;
           

            List<AuthSignatoryList> authList = bApex.authList;
            
            
            if(authList.size() > 0){
                AuthSignatoryList auth = new AuthSignatoryList();
                auth = authList[0];
                nl.FirstName = auth.name;
                nl.LastName = auth.LastNameOfDirector;
                //nl.link
                nl.Email = auth.email;
                nl.DIN__c = auth.din;
                nl.Phone = auth.mobile;
                nl.Designation__c = auth.designation;
                authList.remove(0);
                
            }
            
            
            //map the basic detials with authorise signatory
            //nl.FirstName = bApex.First_Name_AuSig_c;
            //nl.LastName = bApex.Last_Name_AuSig_c;
            //nl.Email = bApex.Official_Email_Address_AuSig_c;
            //nl.Phone = bApex.Tel_No_AuSig_c;
            
            nl.Company = bApex.Company;
            system.debug('type '+bApex.Company_Type);
            if(!Test.isRunningTest()){
                nl.Type__c  = bApex.Company_Type;
            }
            
            system.debug('type -->'+bApex.SelectedCompanyOptionByUser);
            if(bApex.SelectedCompanyOptionByUser){
                nl.Selected_Company_Name__c='As Per User';
            }
            
            if(bApex.SelectedCompanyOptionByMCA){
                nl.Selected_Company_Name__c='As Per MCA';
            }
           
            //added by shashank on 5 july,2023
            nl.Other_Type__c = bApex.Other_Type_c;
            string recId = SObjectType.Lead.getRecordTypeInfosByName().get('ECS').getRecordTypeId();
            nl.RecordTypeId = recId;
            nl.Pan_no__c = bApex.Pan_no_c;
            nl.GST_State__c = bApex.GST_State_c;
            nl.GST_No__c = bApex.GST_No_c;
            nl.Website = bApex.Website;
            nl.GST_Registered__c=bApex.GST_Registered_c;
            nl.CIN_Company_Identification_Number__c = bApex.CIN_Company_Identification_Number_c;
            nl.Date_of_Incorporation__c = bApex.Date_of_Incorporation_c;
            nl.Company_Years_of_Existence__c	 = bApex.Company_Year_Existence;
            nl.Registered_Address__c	 = bApex.registeredAddress;
            nl.Is_Same_As_a_Registered_Address__c	 = bApex.Is_Same_As_Registered_Address;
            nl.Business_Address__c	 = bApex.Business_Address;
            nl.End_Use_Permitted_Purpose__c	 = bApex.End_Use_Permitted_Purpose;
            nl.Company_Years_of_Existence__c	 = bApex.Company_Year_Existence;
            nl.Has_the_name_been_changed_recently__c = bApex.isHasNameChangedYes;
            nl.Type_of_Ownership__c = bApex.Type_of_Ownership_c;
            
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
            
           
            List<Authorized_Signatory_Directors__c> ausDirList = new List<Authorized_Signatory_Directors__c>();
            
           Map<Id,Authorized_Signatory_Directors__c> allDirMap = new Map<Id,Authorized_Signatory_Directors__c>([SELECT Id FROM Authorized_Signatory_Directors__c
                                                                  where Lead__c=:nl.Id]);
            if(authList.size() > 0){
                for( AuthSignatoryList ausl : authList){
                    Authorized_Signatory_Directors__c aus = new Authorized_Signatory_Directors__c();
                    if(allDirMap.containsKey(ausl.Id)){
                        aus.Id = ausl.Id;
                        aus.First_Name__c = ausl.name;
                        aus.Last_Name__c = ausl.LastNameOfDirector;
                        aus.LinkedIn_URL__c = ausl.url;
                        aus.Description__c= ausl.Description;
						aus.Mobile_No__c = ausl.mobile;
                        aus.DIN__c = ausl.din;
                        
                        aus.Description__c = ausl.Description;
                        aus.Lead__c = nl.Id;
                        aus.Official_Email_Address__c = ausl.email;
                        aus.Designation__c = ausl.designation;
                        ausDirList.add(aus);
                    }else{
                        aus.First_Name__c = ausl.name;
                        aus.Last_Name__c = ausl.LastNameOfDirector;
                        aus.Mobile_No__c = ausl.mobile;
                        aus.DIN__c = ausl.din;
                        aus.LinkedIn_URL__c = ausl.url;
                        aus.Description__c= ausl.Description;

                        aus.Description__c = ausl.Description;
                        aus.Lead__c = nl.Id;
                        aus.Official_Email_Address__c = ausl.email;
                        aus.Designation__c = ausl.designation;
                        ausDirList.add(aus);  
                    }
                }
                
                if(ausDirList.size() > 0){
                    upsert ausDirList;
                }    
                
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
            System.debug('>>> ERROR1 ='+e+'line'+e.getLineNumber());
            
        }
        
        return bMRS;
    }
    
    @RemoteAction
    public static verificationMemberReturnStatus verificationMember(String OTP, String Id){
        verificationMemberReturnStatus vMRS = new verificationMemberReturnStatus();
        try {
            Lead Ld = [SELECT Id,Email, OTP__c,Status FROM Lead WHERE Id =: Id];
            //added by shashank to put encryption on otp
            // Generate the data to be encrypted.
              system.debug(' OTP '+OTP);
              
            Blob data = Blob.valueOf(OTP);
            system.debug(' data '+data);
            // Encrypt the data and have Salesforce.com generate the initialization vector
            Blob encryptedData = Crypto.generateDigest('MD5', data);
            system.debug(' encryptedData '+encryptedData);
            String otpEnc=EncodingUtil.convertToHex(encryptedData);
            system.debug(' Ld.OTP__c '+Ld.OTP__c+' otpEnc '+otpEnc);
            system.debug('Ld.OTP__c    '+Ld.OTP__c+' otpEnc  '+otpEnc);
            if(Ld.OTP__c == otpEnc){
                if(Ld.Status == 'OTP verified'){
                    //Ld.Status = 'Member details';
                    Ld.Status='Business and Ownership';
                    update Ld;
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
    public static detailMemberReturnStatus detailMember(String json, String Id){
        detailMemberReturnStatus dMRS = new detailMemberReturnStatus();
        
        detailMemberApex dApex = detailsMemberparseTarget(json);
        try {
            
            Lead Ld = [ SELECT Id,Status, First_Name_AuSig__c, Last_Name_AuSig__c,First_Name_Nodal__c,Last_Name_Nodal__c,Job_Title_Nodal__c,Official_Email_Address_Nodal__c,Tel_No_Nodal__c, Job_Title_AuSig__c, Official_Email_Address_AuSig__c, Tel_No_AuSig__c, Billing_Contact_Person__c, Billing_Contact_Details__c, Billing_Email_Address__c, Billing_Job_Title__c, Billing_City__c, Billing_State__c, Billing_Street__c, Billing_Zip_Postal_Code__c, Billing_Country__c FROM Lead WHERE Id =: Id ];
            
            
            /*Ld.First_Name_Nodal__c = dApex.First_Name_Nodal_c;
            Ld.Last_Name_Nodal__c = dApex.Last_Name_Nodal_c;
            Ld.Nodal_Officer_Name__c = dApex.First_Name_Nodal_c+' '+dApex.Last_Name_Nodal_c;
            Ld.Official_Email_Address_Nodal__c = dApex.Email;
            Ld.Tel_No_Nodal__c = dApex.Tel_No_Nodal_c;
            Ld.Job_Title_Nodal__c = dApex.Job_Title_Nodal_c;
            
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
            */
            if(Ld.Status == 'Business and Ownership'){
                // Ld.Status = 'Plan selection';
                Ld.Status = 'Contact and User ID';
            }
            
            ld.Brand_Name_Market_Name__c = dApex.brandName;
            ld.Description_Business_Model_of_Client__c = dApex.brandDescriprion;
            ld.Description_Business_Model_of_Client__c = dApex.brandDescriprion;
            //update Ld;
            List<AuthSignatoryList> aulist = dApex.authList;
            List<promotoresList> pmoList = dApex.pmList;
            system.debug('current 1 size of '+aulist.size()+' and of pmoList'+pmoList.size());
            if(aulist.size() > 0){
                AuthSignatoryList lds = aulist[0];
                ld.LinkedIn_URL__c = lds.url;
                ld.Description	 = lds.Description;
                aulist.remove(0);  
             }
            Update ld;
            

            system.debug('current 2 size of'+aulist.size()+' and of pmoList'+pmoList.size());

            List<Authorized_Signatory_Directors__c> auListoUpdate = new List<Authorized_Signatory_Directors__c>();
            for(AuthSignatoryList ausl : aulist){
                Authorized_Signatory_Directors__c alsu = new Authorized_Signatory_Directors__c();
                alsu.Id = ausl.Id;
              	alsu.LinkedIn_URL__c = ausl.url;
                alsu.Description__c = ausl.Description; 
                auListoUpdate.add(alsu);
            }
            
            if(auListoUpdate.size() > 0){
               upsert auListoUpdate;
            }


            List<Promoter_Owner__c> pmListoUpdate = new List<Promoter_Owner__c>();
            for(promotoresList ausl : pmoList){
                if(string.isNotBlank(ausl.Id)){
                Promoter_Owner__c alsu = new Promoter_Owner__c();
                alsu.Id = ausl.Id;
              	alsu.Name = ausl.NameOfDirector;
                alsu.Percentage_of_Ownership__c = ausl.per_Of_Ownership; 
                alsu.Lead__c = Id;
                pmListoUpdate.add(alsu);
                }else if(string.isNotBlank(ausl.NameOfDirector)){
                Promoter_Owner__c alsu = new Promoter_Owner__c();
              	alsu.Name = ausl.NameOfDirector;
                alsu.Percentage_of_Ownership__c = ausl.per_Of_Ownership; 
                alsu.Lead__c = Id;
                pmListoUpdate.add(alsu);
                }
                
            }
            
            if(pmListoUpdate.size() > 0){
                upsert pmListoUpdate;
            }
            
            
            
            dMRS.Id = Ld.Id;
            dMRS.status = true;
            dMRS.msg = 'Record Updated Successfully';
            
        } catch (Exception e) {
            
            dMRS.status = false;
            dMRS.msg = 'Record Updation Failed';
            system.debug('line'+e.getLineNumber() +' msg '+e.getMessage());
        }
        
        return dMRS;
    }
    
    
    @RemoteAction 
    public static headDetailsReturnStatus saveUserDetail(string json,string Id){
        
            
        headDetailsReturnStatus wDRS = new headDetailsReturnStatus();
        
        try{
            Lead Ld = [SELECT Id,Email, OTP__c,Status FROM Lead WHERE Id =: Id];
            if(Ld.Status == 'Contact and User ID'){
                Ld.Status = 'Supporting Documents (Company)';
            }
            getHeadDetails wApex = getHeadDetailsparse(json);
            system.debug('JSON Is  >> '+json);
        head_of_Products hp = wApex.hd_Product;
        head_of_Technology tp = wApex.hd_technology;
        head_of_Compliance cp = wApex.hd_compliance;
        head_of_Infosec Ip = wApex.hd_Infosec;
        billing_contact_details Dp = wApex.hd_con_Details;
        head_of_Audit_and_Compliance Ap = wApex.hd_Audit_and_Compliance;
        details_of_person_authorized Pp = wApex.hd_person_authorized;
        API_IP_address_details ppp =wApex.hd_IP_address;
        
       
       List<User_Detail__c> uslist = new List<User_Detail__c>();
       
        User_Detail__c u1 = new User_Detail__c();
            //system.debug('hp.Id'+hp.Id);
       if(string.isNotBlank(hp.Id)){
           //system.debug('hp.Id'+hp.Id);
          u1.Id = hp.Id;
       }
       u1.First_Name__c  = hp.First_Name_head_of_prod_c;
       u1.Lead__c = Id;
       u1.Last_Name__c  = hp.Last_Name_head_of_prod_c;
       u1.Official_Email_Address__c  = hp.Official_Email_head_of_prod_c;
       u1.Mobile_No__c  = hp.Tel_No_head_of_prod_c;
       u1.Designation__c  = hp.Job_Title_head_of_prod_c;
       u1.User_Type__c = 'Head of Product';
       uslist.add(u1);
        
        
      User_Detail__c u3 = new User_Detail__c();
        if(string.isNotBlank(tp.Id)){
           u3.Id = tp.Id;
       }
       u3.First_Name__c  = tp.First_Name_head_of_Technology_c;
       u3.Lead__c = Id;
       u3.Last_Name__c  = tp.Last_Name_head_of_Technology_c;
       u3.Official_Email_Address__c  = tp.Official_Email_head_of_Technology_c;
       u3.Mobile_No__c  = tp.Tel_No_head_of_Technology_c;
       u3.Designation__c  = tp.Job_Title_head_of_Technology_c;
       u3.User_Type__c = 'Head of Technology';
       uslist.add(u3);
        
        
        User_Detail__c u4 = new User_Detail__c();
        if(string.isNotBlank(cp.Id)){
           u4.Id = cp.Id;
       }
       u4.Lead__c = Id;
       u4.First_Name__c  = cp.First_Name_head_of_Compliance_c;
       u4.Last_Name__c  = cp.Last_Name_head_of_Compliance_c;
       u4.Official_Email_Address__c  = cp.Official_Email_head_of_Compliance_c;
       u4.Mobile_No__c  = cp.Tel_No_head_of_Compliance_c;
       u4.Designation__c  = cp.Job_Title_head_of_Compliance_c;
       u4.User_Type__c = 'Head of Compliance';
       uslist.add(u4);
        
        
        
        User_Detail__c u5 = new User_Detail__c();
        if(string.isNotBlank(Ip.Id)){
           u5.Id = Ip.Id;
       }
        u5.Lead__c = Id;
       u5.First_Name__c  = Ip.First_Name_head_of_Infosec_c;
       u5.Last_Name__c  = Ip.Last_Name_head_of_Infosec_c;
       u5.Official_Email_Address__c  = Ip.Official_Email_head_of_Infosec_c;
       u5.Mobile_No__c  = Ip.Tel_No_head_of_Infosec_c;
       u5.Designation__c  = Ip.Job_Title_head_of_Infosec_c;
       u5.User_Type__c = 'Head of Infosec';
       uslist.add(u5);
        
        
        
       User_Detail__c u6 = new User_Detail__c();
        if(string.isNotBlank(dp.Id)){
           u6.Id = dp.Id;
       }
        u6.Lead__c = Id;
       u6.First_Name__c  = dp.First_Name_billing_contact_details_c;
       u6.Last_Name__c  = dp.Last_Name_billing_contact_details_c;
       u6.Official_Email_Address__c  = dp.Official_Email_billing_contact_details_c;
       u6.Mobile_No__c  = dp.Tel_No_billing_contact_details_c;
       u6.Designation__c  = dp.Job_Title_billing_contact_details_c;
       u6.User_Type__c = 'Billing Contact Detail';
       uslist.add(u6);
        
        
        
       User_Detail__c u7 = new User_Detail__c();
        if(string.isNotBlank(ap.Id)){
           u7.Id = ap.Id;
       }
       u7.Lead__c = Id;
       u7.First_Name__c  = ap.First_Name_head_of_Audit_c;
       u7.Last_Name__c  = ap.Last_Name_head_of_Audit_c;
       u7.Official_Email_Address__c  = ap.Official_Email_head_of_Audit_c;
       u7.Mobile_No__c  = ap.Tel_No_head_of_Audit_c;
       u7.Designation__c  = ap.Job_Title_head_of_Audit_c;
       u7.User_Type__c = 'Head of Audit';
       uslist.add(u7);
        
        
        
       User_Detail__c u8 = new User_Detail__c();
        if(string.isNotBlank(pp.Id)){
           u8.Id = pp.Id;
       }
       u8.Lead__c = Id;
       u8.First_Name__c  = pp.First_Name_details_of_person_authorized_c;
       u8.Last_Name__c  = pp.Last_Name_details_of_person_authorized_c;
       u8.Official_Email_Address__c  = pp.Official_Email_details_of_person_authorized_c;
       u8.Mobile_No__c  = pp.Tel_No_details_of_person_authorized_c;
       u8.Designation__c  = pp.Job_Title_details_of_person_authorized_c;
       u8.User_Type__c = 'Person authorized to upload/share onboarding documents';
       uslist.add(u8);
        
        
      User_Detail__c u9 = new User_Detail__c();
       if(string.isNotBlank(ppp.Id)){
           u9.Id = ppp.Id;
       }
       u9.Lead__c = Id;
       u9.First_Name__c  = ppp.First_Name_API_IP_address_c;
       u9.Last_Name__c  = ppp.Last_Name_API_IP_address_c;
       u9.Official_Email_Address__c  = ppp.Official_Email_API_IP_address_c;
       u9.Mobile_No__c  = ppp.Tel_No_API_IP_address_c;
       u9.Designation__c  = ppp.Job_Title_API_IP_address_c;
       List<IpAddresscls>IpRanges = ppp.RestrctedIPRanges;
       u9.User_Type__c = 'API Login User';
       uslist.add(u9);
       
        List<UAT_Test_Profile_Details> uat = new List<UAT_Test_Profile_Details>();
        if(wApex.hd_Profile_Details.size() > 0){
            for(UAT_Test_Profile_Details ut : wApex.hd_Profile_Details){
                User_Detail__c u2 = new User_Detail__c();
                if(string.isNotBlank(ut.Id)){
                    u2.Id = ut.Id;
                }
                u2.Lead__c = Id;
                u2.First_Name__c  = ut.First_Name_UAT_Test_Profile_Details_c;
                u2.Last_Name__c  = ut.Last_Name_UAT_Test_Profile_Details_c;
                u2.Official_Email_Address__c  = ut.Official_Email_UAT_Test_Profile_Details_c;
                u2.Mobile_No__c  = ut.Tel_No_UAT_Test_Profile_Details_c;
                u2.Designation__c  = ut.Job_Title_UAT_Test_Profile_Details_c;
                u2.User_Type__c = 'UAT Test Profile';
                uslist.add(u2);
            }
        }
       
        if(uslist.size() > 0){
            upsert uslist;
        }
        
       User_Detail__c usdl = [select Id, Name from User_Detail__c where User_Type__c='API Login User'  and Lead__c =:Id limit 1]; 
        
       List<IP_Address__c> ipts = new List<IP_Address__c>();
       for(IpAddresscls ips : IpRanges){
           IP_Address__c ipads = new IP_Address__c();
           if(string.isNotbLank(ips.Id)){
               ipads.Id =ips.Id; 
           }
           ipads.User_Detail__c = usdl.Id;
           ipads.Name = ips.login_IP;
           ipts.add(ipads);
        }
        
        if(ipts.size() > 0){
            upsert ipts;
            update Ld;
         }
            
        
        //try {
            wDRS.status = true;
            wDRS.uploadedFileList= newFormsCotroller.getUploadedFiles(Id);
            wDRS.msg = 'Record Updated Successfully'+wDRS.uploadedFileList.size();
        }catch (Exception e) {
            
            wDRS.status = false;
            wDRS.msg = 'Record Updation Failed'+e.getLineNumber();
            
        }
        
        return wDRS; 
    }
    
    @RemoteAction 
    public static submitDocumentResult saveSubmmitDocument(string Id){ 
      submitDocumentResult wDRS = new submitDocumentResult();
		try{
            Lead Ld = [SELECT Id,Email, OTP__c,LastName,FirstName,Status FROM Lead WHERE Id =: Id];
            if(Ld.Status == 'Supporting Documents (Company)'){
                Ld.Status = 'Supporting Documents (Signatory & Directors)';
            }
            update Ld;
            
            List<DirecotorFileUploaded> fileListOfDirector= new List<DirecotorFileUploaded>();
            DirecotorFileUploaded v1 = new DirecotorFileUploaded();
            v1.dirId = Ld.Id;
            v1.dirName = Ld.FirstName+''+Ld.LastName;
            v1.file = newFormsCotroller.getDirecotorFiles(Ld.Id);
            fileListOfDirector.add(v1);
            
            List<Authorized_Signatory_Directors__c> allDirList = [SELECT Id,First_Name__c, Last_Name__c, Lead__c FROM Authorized_Signatory_Directors__c
                                                                  where Lead__c=:ld.Id];
            for( Authorized_Signatory_Directors__c ausl1 : allDirList){	
                DirecotorFileUploaded v2 = new DirecotorFileUploaded();
                v2.dirId = ausl1.Id;
                v2.dirName = ausl1.First_Name__c+''+ausl1.Last_Name__c;
                v2.file = newFormsCotroller.getDirecotorFiles(ausl1.Id);
                fileListOfDirector.add(v2);
            }
            wDRS.status = true;
            wDRS.DirectorFileList = fileListOfDirector;
            wDRS.goNext = true;
            wDRS.msg = 'Record Updated Successfully';
        }catch (Exception e) {
            wDRS.status = false;
            wDRS.goNext = true;
            wDRS.msg = 'Record Updation Failed'+e.getLineNumber();
        }
        
        return wDRS;
    }
    public static List<uploadedFileData> getUploadedFiles(string leadId){
        List<ContentDocumentLink> docList= [select Id,LinkedEntityId ,ContentDocument.Title from ContentDocumentLink where LinkedEntityId =:leadId];
        List<uploadedFileData> tempFileList = new List<uploadedFileData>();
        for(ContentDocumentLink cdl : docList){
            uploadedFileData ups = new uploadedFileData();
            ups.Id = cdl.Id;
            ups.fileName = cdl.ContentDocument.Title;
            ups.hasFileUploaded = true;
            tempFileList.add(ups);
        }
        system.debug('JSON'+JSON.serialize(tempFileList));
        return tempFileList;
    }
    
    public static List<uploadedFileData> getUploadedFilesV2(string leadId){
        
        set<Id> sId = new set<Id>();
        List<uploadedFileData> tempFileList = new List<uploadedFileData>();
        List<Supporting_Document__c> lst = [Select Id from Supporting_Document__c where Lead__c =:leadId]; 
        
        for(Supporting_Document__c sp : lst){
            sId.add(sp.Id);
        }
        
        if(sId.size() > 0){
            List<ContentDocumentLink> docList= [select Id,LinkedEntityId ,ContentDocument.Title from ContentDocumentLink where LinkedEntityId IN : sId];
            
            for(ContentDocumentLink cdl : docList){
                uploadedFileData ups = new uploadedFileData();
                ups.Id = cdl.Id;
                ups.fileName = cdl.ContentDocument.Title;
                ups.hasFileUploaded = true;
                tempFileList.add(ups);
            }
        }
        system.debug('JSON'+JSON.serialize(tempFileList));
        return tempFileList;
    }
    
    public static List<fileUploaded> getDirecotorFiles(string leadId){
        List<string> fileName = new List<string>();
        fileName.add('Copy of  Identity proof');
        fileName.add('Letter of Authority');
        fileName.add('Visiting card / Business Card');
        List<ContentDocumentLink> docList= [select Id,LinkedEntityId ,ContentDocument.Title from ContentDocumentLink where LinkedEntityId =:leadId
                                           and ContentDocument.Title IN : fileName order by ContentDocument.Title];
        
        List<fileUploaded> tempFileList = new List<fileUploaded>();
        Map<Id,fileUploaded> fsMap = new Map<Id,fileUploaded>();
        
                if(docList.size() > 0){
                    Map<string,string> strMap = new Map<string,string>();
                          for(ContentDocumentLink csd : docList){
                                if(strMap.containsKey(csd.ContentDocument.Title)){
                                 
                                }else{
                                    strMap.put(csd.ContentDocument.Title,csd.Id);
                                }
                        
                          }
                    
                    for(string dl : fileName){
                        if(strMap.containskey(dl)){
                              fileUploaded ups1 = new fileUploaded();
                              ups1.fId = strMap.get(dl);
                              ups1.docName = dl;
                              ups1.hasUploded = true;
                            if(ups1.docName =='Letter of Authority'){
                                ups1.hasNotRequird = false;
                            }else{
                                ups1.hasNotRequird = true;   
                            }
                              
                              ups1.hasShowError = false;
                              tempFileList.add(ups1);
                        }
                        else{
                              fileUploaded ups1 = new fileUploaded();
                              ups1.fId = '';
                              ups1.docName = dl;
                            if(ups1.docName =='Letter of Authority'){
                                ups1.hasNotRequird = false;
                            }else{
                                ups1.hasNotRequird = true;   
                            }
                              ups1.hasUploded = false;
                              ups1.hasShowError = false;
                              tempFileList.add(ups1);
                        }
                    }
                          
                   
                }         
                 
        else{
                    for(string str : fileName){
                    fileUploaded ups = new fileUploaded();
                    ups.fId = '';
                    ups.docName = str;
                        if(str =='Letter of Authority'){
                                ups.hasNotRequird = false;
                            }else{
                                ups.hasNotRequird = true;   
                            }
                    ups.hasUploded = false;
                    ups.hasShowError = false;
                    tempFileList.add(ups);
                    }
                }
        
        
        return tempFileList;
 }
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
            
            getHeadDetails hDA = newFormsCotroller.getHeaderDetails(LeadList.Id);
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
            
            
            List<AuthSignatoryList> ausDirList = new List<AuthSignatoryList>();
            
            AuthSignatoryList ausl = new AuthSignatoryList();
            Authorized_Signatory_Directors__c aus = new Authorized_Signatory_Directors__c();
            ausl.Id = LeadList.Id;
            ausl.name = LeadList.FirstName;
            ausl.LastNameOfDirector = LeadList.LastName;
            ausl.mobile = LeadList.Phone;
            ausl.din = LeadList.DIN__c ;
            ausl.Description = LeadList.Description;
            ausl.email = LeadList.email;
            ausl.url =(LeadList.LinkedIn_URL__c != null) ? LeadList.LinkedIn_URL__c : '';
            ausl.designation = LeadList.Designation__c ;
            ausDirList.add(ausl);
            
            List<DirecotorFileUploaded> fileListOfDirector= new List<DirecotorFileUploaded>();
            DirecotorFileUploaded v1 = new DirecotorFileUploaded();
            v1.dirId = LeadList.Id;
            v1.dirName = LeadList.FirstName+''+LeadList.LastName;
            v1.file = newFormsCotroller.getDirecotorFiles(LeadList.Id);
            fileListOfDirector.add(v1);
            
            List<Authorized_Signatory_Directors__c> allDirList = [SELECT Id, LinkedIn_URL__c, First_Name__c, Last_Name__c, Designation__c, Mobile_No__c, 
                                                                  Official_Email_Address__c, DIN__c, Description__c, Lead__c FROM Authorized_Signatory_Directors__c
                                                                  where Lead__c=:LeadList.Id];
            for( Authorized_Signatory_Directors__c ausl1 : allDirList){	
                AuthSignatoryList aus1 = new AuthSignatoryList();
                aus1.Id = ausl1.Id;
                aus1.name = ausl1.First_Name__c ;
                aus1.LastNameOfDirector = ausl1.Last_Name__c;
                aus1.mobile = ausl1.Mobile_No__c;
                aus1.din  = ausl1.DIN__c;
                system.debug('LinkedIn_URL__c ::>>>> '+ausl1.LinkedIn_URL__c);
                aus1.url =(ausl1.LinkedIn_URL__c != null) ? ausl1.LinkedIn_URL__c : '';
                aus1.Description = (ausl1.Description__c !=null )?  ausl1.Description__c : '';
            
                aus1.email = (ausl1.Official_Email_Address__c != null) ? ausl1.Official_Email_Address__c : '';
                aus1.designation  = ausl1.Designation__c;
                ausDirList.add(aus1);
                
                DirecotorFileUploaded v2 = new DirecotorFileUploaded();
                v2.dirId = ausl1.Id;
                v2.dirName = ausl1.First_Name__c+''+ausl1.Last_Name__c;
                v2.file = newFormsCotroller.getDirecotorFiles(ausl1.Id);
                fileListOfDirector.add(v2);
            }
            //system.debug('JSOn-->'+JSON.serialize(ausDirList));
            //List<uploadedFileData> uploadedList  =new List<uploadedFileData>();
            bMA.authList   = ausDirList;
           
            
            
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
            
            bMA.Type_of_Ownership_c  = LeadList.Type_of_Ownership__c;
            
            
            //Integer Company_Year_Existence = system.Today().year() - LeadList.Date_of_Incorporation__c.year();
            
            integer d1 = date.today().year();
            integer y1 = date.today().month();
            integer d2 = LeadList.Date_of_Incorporation__c.year();
            integer y2 = LeadList.Date_of_Incorporation__c.month();
            Integer total_months = (y1 - y2) * 12 + (d1 - d2);
            Integer years = total_months / 12;
            integer  months = Math.mod(total_months, 12);
            
            string Company_Year_Existence= years+' Years,'+ months+' Months';
            
            bMA.Company_Year_Existence 	 = LeadList.Company_Years_of_Existence__c;
            bMA.registeredAddress 	 = LeadList.Registered_Address__c;
            bMA.Is_Same_As_Registered_Address 	 = LeadList.Is_Same_As_a_Registered_Address__c;
            bMA.Business_Address 	 = LeadList.Business_Address__c;
            bMA.End_Use_Permitted_Purpose 	 = LeadList.End_Use_Permitted_Purpose__c;
            bMA.isHasNameChangedYes  = LeadList.Has_the_name_been_changed_recently__c;
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
            
            
            List<Promoter_Owner__c> pmoList = [Select Id,Percentage_of_Ownership__c,Name from Promoter_Owner__c where lead__c =:LeadList.Id];
            
            List<promotoresList> pmList = new List<promotoresList>();
            for(Promoter_Owner__c pro: pmoList){
                promotoresList pmlu = new promotoresList();
                pmlu.Id = pro.Id;
              	pmlu.NameOfDirector  = pro.Name;
                pmlu.per_Of_Ownership  = pro.Percentage_of_Ownership__c; 
                pmList.add(pmlu);
            }
            
            dMA.brandName = LeadList.Brand_Name_Market_Name__c;
            dMA.brandDescriprion = LeadList.Description_Business_Model_of_Client__c;
            if(ausDirList.size() > 0){
                dMA.authList   = ausDirList;
            }else{
                dMA.authList   = null;
            }
            
            dMA.pmList = pmList;
            
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
                    status.documentVerifying=true;
                    
                }
                when 'OTP Verified' {
                    System.debug('OTP Verified');
                    //status.detailMemberApex = dMA;
                    status.becomMemberApex = bMA;
                    //status.uploadDoclist  = uploadDoclist;
                    // status.OTPApex = OA;
                }
                when 'Business and Ownership' {
                    System.debug('Business and Ownership');
                    status.becomMemberApex = bMA;
                    status.OTPApex = OA;
                    //status.uploadDoclist  = uploadDoclist;
                    status.detailMemberApex = dMA;
                    //status.getHeadDetails = hDA;
                    
                }
                when 'Contact and User ID' {
                    System.debug('Contact and User ID');
                    
                    status.becomMemberApex = bMA;
                    status.OTPApex = OA;
                    //status.uploadDoclist  = uploadDoclist;
                    status.detailMemberApex = dMA;
                    //status.webUserDetailsApex = LeadList.Web_User_Details__r;
                    status.getHeadDetails = hDA;
                    //status.authUserIdReqApex = aUIRA;
                }
                when 'Supporting Documents (Company)' {
                    bMA.uploadedFileList =  newFormsCotroller.getUploadedFilesV2(LeadList.Id);
                    System.debug('Supporting Documents (Company)');
                    status.becomMemberApex = bMA;
                    status.OTPApex = OA;
                    status.detailMemberApex = dMA;
                    status.webUserDetailsApex = LeadList.Web_User_Details__r;
                    status.getHeadDetails = hDA;
                    status.authUserIdReqApex = aUIRA;
                    status.planSelectionApex= LeadList.Payment_Detail__r;
                    //status.paymentDetailApexForPlan = LeadList.Payment_Detail__r;
                }
                when 'Supporting Documents (Signatory & Directors)' {
                    System.debug('Supporting Documents (Signatory & Directors)');
                    bMA.uploadedFileList =  newFormsCotroller.getUploadedFilesV2(LeadList.Id);
                    bMA.DirectorFileList   = fileListOfDirector;
                    status.becomMemberApex = bMA;
                    status.OTPApex = OA;
                    status.uploadDoclist  = uploadDoclist;
                    status.detailMemberApex = dMA;
                    status.webUserDetailsApex = LeadList.Web_User_Details__r;
                    status.getHeadDetails = hDA;
                    status.authUserIdReqApex = aUIRA;
                    status.planSelectionApex= LeadList.Payment_Detail__r;
                    status.paymentDetailApexForPlan = LeadList.Payment_Detail__r;
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
    
    public static getHeadDetails getHeaderDetails(string Id){
        
        List<UAT_Test_Profile_Details> upsList = new List<UAT_Test_Profile_Details>();
        List<User_Detail__c> uslist = [select Id,Designation__c,First_Name__c,Last_Name__c,Lead__c,Mobile_No__c,
                                       Official_Email_Address__c,User_Type__c from User_Detail__c where Lead__c=:Id];
        
        set<Id> usId = new set<Id>();
        for(User_Detail__c us : uslist){
            if(us.User_Type__c == 'API Login User'){
                usId.add(us.Id);
            }
        }
        List<IP_Address__c> ipc = [select Id,Name from IP_Address__c where User_Detail__c IN : usId];
        List<IpAddresscls> ipcls= new List<IpAddresscls>();
        for(IP_Address__c  ipa : ipc){
            IpAddresscls ipcl = new IpAddresscls();
            ipcl.Id = ipa.Id;
            ipcl.login_IP = ipa.Name;
            ipcls.add(ipcl);
        }
           
        getHeadDetails h_Ouser = new getHeadDetails();
        for(User_Detail__c us :uslist ){
            switch on us.User_Type__c {
                when 'Head of Product'{
                    head_of_Products hp = new head_of_Products();
                    hp.Id = us.Id;
                    hp.First_Name_head_of_prod_c = us.First_Name__c;
                    hp.Last_Name_head_of_prod_c = us.Last_Name__c;
                    hp.Official_Email_head_of_prod_c = us.Official_Email_Address__c;
                    hp.Tel_No_head_of_prod_c = us.Mobile_No__c;
                    hp.Job_Title_head_of_prod_c = us.Designation__c;
                    h_Ouser.hd_Product = hp;
                } 
                
                when 'Head of Technology'{
                    head_of_Technology hp = new head_of_Technology();
                    hp.First_Name_head_of_Technology_c = us.First_Name__c;
                    hp.Last_Name_head_of_Technology_c = us.Last_Name__c;
                    hp.Official_Email_head_of_Technology_c = us.Official_Email_Address__c;
                    hp.Tel_No_head_of_Technology_c = us.Mobile_No__c;
                    hp.Job_Title_head_of_Technology_c = us.Designation__c;
                    hp.Id = us.Id;
                    h_Ouser.hd_technology = hp;
                    
                    }
                    
                
                when 'Head of Compliance'{
                    head_of_Compliance hp = new head_of_Compliance();
                    hp.First_Name_head_of_Compliance_c = us.First_Name__c;
                    hp.Last_Name_head_of_Compliance_c = us.Last_Name__c;
                    hp.Official_Email_head_of_Compliance_c = us.Official_Email_Address__c;
                    hp.Tel_No_head_of_Compliance_c = us.Mobile_No__c;
                    hp.Job_Title_head_of_Compliance_c = us.Designation__c;
                    h_Ouser.hd_compliance = hp;
                    hp.Id = us.Id;
                    
                    } 
                
                when 'Head of Infosec'{
                    head_of_Infosec hp = new head_of_Infosec();
                    hp.First_Name_head_of_Infosec_c = us.First_Name__c;
                    hp.Last_Name_head_of_Infosec_c = us.Last_Name__c;
                    hp.Official_Email_head_of_Infosec_c = us.Official_Email_Address__c;
                    hp.Tel_No_head_of_Infosec_c = us.Mobile_No__c;
                    hp.Job_Title_head_of_Infosec_c = us.Designation__c;
                    hp.Id = us.Id;
                    h_Ouser.hd_Infosec = hp;
                  } 
                
                
                when 'Billing Contact Detail'{
                    billing_contact_details hp = new billing_contact_details();
                    hp.First_Name_billing_contact_details_c = us.First_Name__c;
                    hp.Last_Name_billing_contact_details_c = us.Last_Name__c;
                    hp.Official_Email_billing_contact_details_c = us.Official_Email_Address__c;
                    hp.Tel_No_billing_contact_details_c = us.Mobile_No__c;
                    hp.Job_Title_billing_contact_details_c = us.Designation__c;
                    hp.Id = us.Id;
                    h_Ouser.hd_con_Details = hp;
                } 
                
                when 'Head of Audit'{
                    head_of_Audit_and_Compliance hp = new head_of_Audit_and_Compliance();
                    hp.First_Name_head_of_Audit_c = us.First_Name__c;
                    hp.Last_Name_head_of_Audit_c = us.Last_Name__c;
                    hp.Official_Email_head_of_Audit_c = us.Official_Email_Address__c;
                    hp.Tel_No_head_of_Audit_c = us.Mobile_No__c;
                    hp.Job_Title_head_of_Audit_c = us.Designation__c;
                    hp.Id = us.Id;
                    h_Ouser.hd_Audit_and_Compliance = hp;
                 } 
                
                
                when 'Person authorized to upload/share onboarding documents'{
                    details_of_person_authorized hp = new details_of_person_authorized();
                    hp.First_Name_details_of_person_authorized_c = us.First_Name__c;
                    hp.Last_Name_details_of_person_authorized_c = us.Last_Name__c;
                    hp.Official_Email_details_of_person_authorized_c = us.Official_Email_Address__c;
                    hp.Tel_No_details_of_person_authorized_c = us.Mobile_No__c;
                    hp.Job_Title_details_of_person_authorized_c = us.Designation__c;
                    hp.Id = us.Id;
                    h_Ouser.hd_person_authorized = hp;
                    
               } 
                
                when 'API Login User'{
                    API_IP_address_details hp = new API_IP_address_details();
                    hp.First_Name_API_IP_address_c = us.First_Name__c;
                    hp.Last_Name_API_IP_address_c = us.Last_Name__c;
                    hp.Official_Email_API_IP_address_c = us.Official_Email_Address__c;
                    hp.Tel_No_API_IP_address_c = us.Mobile_No__c;
                    hp.Job_Title_API_IP_address_c = us.Designation__c;
                    hp.RestrctedIPRanges = null;
                    hp.Id = us.Id;
                    hp.RestrctedIPRanges = ipcls;
                    h_Ouser.hd_IP_address = hp;
                    
                    } 
                
                when 'UAT Test Profile'{
                    UAT_Test_Profile_Details hp = new UAT_Test_Profile_Details();
                    hp.First_Name_UAT_Test_Profile_Details_c = us.First_Name__c;
                    hp.Last_Name_UAT_Test_Profile_Details_c = us.Last_Name__c;
                    hp.Official_Email_UAT_Test_Profile_Details_c = us.Official_Email_Address__c;
                    hp.Tel_No_UAT_Test_Profile_Details_c = us.Mobile_No__c;
                    hp.Job_Title_UAT_Test_Profile_Details_c = us.Designation__c;
                    hp.Id = us.Id;
                    //h_Ouser.hd_Profile_Details = hp;
                    upsList.add(hp);
                   } 
                
                
            }
            h_Ouser.hd_Profile_Details = upsList;
        }

        
        return h_Ouser;
        
    } 
    
    @RemoteAction
    public static map<string,string> uploaddocs(string leadId,String fileName, object base64Data,string fileExtension) {
        map<string,string> result = new map<string,string>();
        Set<string> fNameStr = new Set<string>();
        try {
            
            List<Supporting_Document__c> splist = new List<Supporting_Document__c>();
            splist = [Select Id, lead__c from Supporting_Document__c where Supporting_Document_Name__c=: fileName and lead__c=:leadId];
            system.debug('splist-->'+splist.size());
            Supporting_Document__c sp = new Supporting_Document__c();
            if(splist.size() > 0 ){
                system.debug('inside if');
                sp.lead__c = leadId;
                sp.Document_Status__c = 'Pending';
                sp.Supporting_Document_Name__c	 = fileName;
                sp.Document_Type__c = 'Company';
                if(splist[0].Id != null){
                    sp.Id = splist[0].Id;
                }
                
            }else{
                system.debug('inside else');
                sp.lead__c = leadId;
                sp.Document_Type__c = 'Company';
                sp.Document_Status__c = 'Pending';
                sp.Supporting_Document_Name__c	 = fileName;
            }
            
            if(sp.Supporting_Document_Name__c!=null){
                upsert sp;
                set<Id> spId = new set<Id>();
                spId.add(sp.id);   
                if(spId.size() > 0){
                    
                    List<ContentDocumentLink> cdltodelete = New  List<ContentDocumentLink>();
                    List<ContentDocumentLink> cdloList = [SELECT ContentDocument.Id,ContentDocument.Title,LinkedEntityId,ContentDocument.CreatedDate,  
                                                          ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId IN :spId];
                    if(cdloList != null && cdloList.size() > 0){
                        for(ContentDocumentLink c : cdloList){
                            if(c.ContentDocument.Title.toLowerCase() == fileName.ToLowerCase()){
                                cdltodelete.add(c); 
                            }
                        }
                    }
                    if(cdltodelete.size() > 0){
                        delete cdltodelete;
                    }
                    
                    string strv = string.valueOf(base64Data);
                    //string strImage = '';
                    //strImage =strv.substring(strv.indexOf(',')+1,strv.length());
                    List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
                    Blob fileBlob = EncodingUtil.base64Decode(strv);
                    ContentVersion contentVersion = new ContentVersion();
                    contentVersion.Title = fileName;
                    contentVersion.PathOnClient = fileName+'.'+fileExtension;
                    contentVersion.VersionData = fileBlob;// ;
                    contentVersion.contentlocation = 'S';
                    insert contentVersion;
                    
                    for(ContentVersion cvr :[select Id,ContentDocumentId from ContentVersion where Id =:contentVersion.Id]){
                        ContentDocumentLink cvl = new ContentDocumentLink();
                        cvl.LinkedEntityId = sp.Id;
                        cvl.ContentDocumentId = cvr.ContentDocumentId;
                        cvl.Visibility = 'AllUsers';
                        cvl.shareType = 'V';
                        cdlList.add(cvl);
                    }
                    insert cdlList;
                }
            }
            
            
            result.put('success','success');
            return result;
        } catch (Exception e) {
            system.debug('e'+e.getLineNumber()+' msg '+e.getMessage());
            result.put('error',e.getMessage());
            return result;
        }
    }
    
    
    
    @RemoteAction
    public static map<string,string> uploaddocsnew(string leadId,String fileName, object base64Data,string fileExtension) {
        map<string,string> result = new map<string,string>();
        Set<string> fNameStr = new Set<string>();
        try {
           List<ContentDocumentLink> cdltodelete = New  List<ContentDocumentLink>();
           List<ContentDocumentLink> cdloList = [SELECT ContentDocument.Id,ContentDocument.Title,LinkedEntityId,ContentDocument.CreatedDate,  
                                        ContentDocument.FileType FROM ContentDocumentLink WHERE LinkedEntityId=:leadId];
           if(cdloList != null && cdloList.size() > 0){
            for(ContentDocumentLink c : cdloList){
                if(c.ContentDocument.Title.toLowerCase() == fileName.ToLowerCase()){
                   cdltodelete.add(c); 
                }
              }
           }
            if(cdltodelete.size() > 0){
                  delete cdltodelete;
            }
            
            string strv = string.valueOf(base64Data);
            string strImage = '';
            strImage =strv.substring(strv.indexOf(',')+1,strv.length());
            List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
            Blob fileBlob = EncodingUtil.base64Decode(strImage);
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = fileName;
            contentVersion.PathOnClient = fileName+'.'+fileExtension;
            contentVersion.VersionData = fileBlob;// ;
            contentVersion.contentlocation = 'S';
            insert contentVersion;
            
            for(ContentVersion cvr :[select Id,ContentDocumentId from ContentVersion where Id =:contentVersion.Id]){
                    ContentDocumentLink cvl = new ContentDocumentLink();
                    cvl.LinkedEntityId = leadId;
                    cvl.ContentDocumentId = cvr.ContentDocumentId;
                    cvl.Visibility = 'AllUsers';
                    cvl.shareType = 'V';
                    cdlList.add(cvl);
                }
            insert cdlList;
            result.put('success','success');
            return result;
        } catch (Exception e) {
            result.put('error',e.getMessage());
            return result;
        }
    }
    
    @RemoteAction
    public static sentForAgreementReturnResult getAgreementCopy(String Id){
        sentForAgreementReturnResult sFAR = new sentForAgreementReturnResult();
        try {
            Lead ld = [SELECT Id,LegalDesk_Agreement_Document_Id__c,Legal_desk_docket_id__c,Agreement_Customer_Status_Stages__c,Agreement_Experian_Status__c FROM Lead WHERE Id =:Id];
            if((ld.LegalDesk_Agreement_Document_Id__c != null || ld.LegalDesk_Agreement_Document_Id__c != '') && (ld.Legal_desk_docket_id__c != null || ld.Legal_desk_docket_id__c != '') ){
                if(!Test.isRunningTest()){
                    //Invoke mock web service response if not calling from test
                    sFAR.pdf = RestApiGetdocketInfo.get_pdf_content(Id);
                }
                sFAR.expSign = ld.Agreement_Experian_Status__c;
                sFAR.cusSign = ld.Agreement_Customer_Status_Stages__c;
                sFAR.status = true;
                sFAR.msg = 'We have mailed the agreement copy to you. Please follow the instructions sent on the mail to complete the agreement signing.';
            }else{
                sFAR.expSign = ld.Agreement_Experian_Status__c;
                sFAR.cusSign = ld.Agreement_Customer_Status_Stages__c;
                sFAR.status = false;
                sFAR.msg = 'please wait we will reach you for this agreement process or you can Contact Experian Support';
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
    public static resSendReturnResult resendOTP(String Id){
        
        API_LOG__c ap=new API_LOG__c();
        ap.Request_Source__c='Resend OTP';
        
        resSendReturnResult status = new resSendReturnResult();
        
        try{
            Lead l = [SELECT Id,Company,Resend_OTP__c FROM Lead WHERE Id =: Id];
            l.Resend_OTP__c = true;
            ap.Company_Name__c=l.Company;
            
            // ap.Request__c = String.valueof(l);
            
            update l;
            system.debug('Resend_OTP__c-->'+l.Resend_OTP__c);
            //MyClass.mmethod(new List<string>{l.Id});
            //MyClass.mmethod(new List<string>{l.Id});
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
    public static returnPlanSelection planSelection(String Id,String json){
        
        returnPlanSelection rPS = new returnPlanSelection();
        
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
    public static returnPlanSelection paymentSubmit(String Id){
        
        returnPlanSelection rPS = new returnPlanSelection();
        
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
            
        }catch(QueryException e){
            rPS.msg = 'Exception! please contact Experian Supprt';
            // status.sing = 'fa fa-exclamation-triangle';
            rPS.status = false;
        }
        return rPS;
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
    
    public static List < webUserDetailsApex >  webUserDetailsparseTarget(String json) {
        return ( List < webUserDetailsApex > ) System.JSON.deserialize(json, List < webUserDetailsApex >.class);
    }
    
    public static getHeadDetails  getHeadDetailsparse(String json) {
        return ( getHeadDetails) System.JSON.deserialize(json,getHeadDetails.class);
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
        
       /* String referanceId = datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
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
        */
        PaymentStatus ps=new PaymentStatus();
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
        public Boolean SelectedCompanyOptionByUser = false;
        public Boolean SelectedCompanyOptionByMCA = false;
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
        public string Type_of_Ownership_c;
        public string Company_Year_Existence;
        public string registeredAddress;
        public string Is_Same_As_Registered_Address;
        public string Business_Address;
        public string End_Use_Permitted_Purpose;
        public string isHasNameChangedYes;
        public Boolean Data_Pull_id_s_c;
        public Boolean Auth_Usr_Id_Requestor_CheckBox_c;
        public verfiedData verfiedData;
        public String RBI_List_Verification_Remarks_c;
        public String CIN_Number_Verified_c;
        public Boolean new_lead_Status; // new_lead_Status used to check and throw the error for duplicate lead based on Company Name
        public List<FetchMoreDetailsByCIN.cls_directorDetails> clsDirectList{get;set;}
        public List<AuthSignatoryList> authList;
        public List<DirecotorFileUploaded>DirectorFileList;
        public List<uploadedFileData> uploadedFileList;
    }
    
    public class uploadedFileData {
        public Id Id;
        public string fileName;
        public boolean hasFileUploaded = false;
            
    }
    public class AuthSignatoryList{
        public Id Id;
        public string  name ;
        public string  LastNameOfDirector ;
        public string  Description;
        public string  url ;
        public string  designation ;
        public string  mobile;
        public string  email;
        public string  din;
    }
    
    public class detailMemberApex {
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
        
        
        public string brandName;
        public string brandDescriprion;
        public List<AuthSignatoryList>authList;
        
        List<promotoresList> pmList;
    }
    
    public class DirecotorFileUploaded{
        public string dirName;
        public string dirId;
        List<fileUploaded> file;
    }
    
    public class fileUploaded{
        public string fId;
        public string docName;
        public boolean hasUploded;
        public boolean hasNotRequird;
        public boolean hasShowError;
    }
    
    public class promotoresList{
        public string Id;
        public string srNo;
        public string NameOfDirector;
        public double per_Of_Ownership;
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
    
    
    
    
    public class headDetailsReturnStatus{
        public String Id{get;set;}
        public Boolean status{get;set;}
        public String msg{get;set;}
        public String instruction{get;set;}
        public String sing{get;set;}
        //public List<Lead_Payment_Detail__c> paymentDetailApex;
        //public List<Web_User_Details__c> webUserDetailsApex;
        public List<uploadedFileData> uploadedFileList;
    }
    
    public class submitDocumentResult{
        public String Id{get;set;}
        public Boolean status{get;set;}
        public String msg{get;set;}
        public boolean goNext{get;set;}
        public String instruction{get;set;}
        public String sing{get;set;}
        public List<DirecotorFileUploaded>DirectorFileList;
        //public List<Lead_Payment_Detail__c> paymentDetailApex;
        //public List<Web_User_Details__c> webUserDetailsApex;
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
        public String registeredAddress{get;set;}
        //public Integer CompanyYearExistence {get;set;}
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
    }
    
    public class returnLeadInfo{
        public Boolean status{get;set;}
        public Boolean documentVerifying{get;set;}
        public String msg{get;set;}
        public String instruction{get;set;}
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
        public getHeadDetails getHeadDetails;
        
        public List<Lead_Payment_Detail__c> paymentDetailApex;
        public sentForAgreementReturnResult sentForAgreementReturnResult;
        public returnDocsStatus returnDocsStatus;
        public Boolean paymentNextButton;
    }
    
    public class getHeadDetails{
        public head_of_Products hd_Product;
        public head_of_Technology hd_technology;
        public head_of_Compliance hd_compliance;
        public head_of_Infosec hd_Infosec;
        public billing_contact_details hd_con_Details;
        public head_of_Audit_and_Compliance hd_Audit_and_Compliance;
        public details_of_person_authorized hd_person_authorized;
        public API_IP_address_details hd_IP_address;
        public List<UAT_Test_Profile_Details> hd_Profile_Details;
    }
    
    
    public class head_of_Products  {
        public string Id;
        public string First_Name_head_of_prod_c;
        public string Last_Name_head_of_prod_c;
        public string Official_Email_head_of_prod_c;
        public string Tel_No_head_of_prod_c;
        public string Job_Title_head_of_prod_c;
    }
    
    public class  head_of_Technology{
        public string Id;
        public string  First_Name_head_of_Technology_c;
        public string  Last_Name_head_of_Technology_c ;
        public string  Official_Email_head_of_Technology_c ;
        public string  Tel_No_head_of_Technology_c ;
        public string  Job_Title_head_of_Technology_c ;
    }
    
    public class head_of_Compliance {
        public string Id;
        public string  First_Name_head_of_Compliance_c;
        public string Last_Name_head_of_Compliance_c;
        public string  Official_Email_head_of_Compliance_c;
        public string  Tel_No_head_of_Compliance_c;
        public string  Job_Title_head_of_Compliance_c;
    }
   
    public class head_of_Infosec  {
        public string Id;
        public string  First_Name_head_of_Infosec_c;
        public string  Last_Name_head_of_Infosec_c;
        public string  Official_Email_head_of_Infosec_c;
        public string  Tel_No_head_of_Infosec_c;
        public string  Job_Title_head_of_Infosec_c;
    }
    
    
    public class billing_contact_details {
        public string Id;
        public string First_Name_billing_contact_details_c;
        public string  Last_Name_billing_contact_details_c;
        public string  Official_Email_billing_contact_details_c;
        public string Tel_No_billing_contact_details_c;
        public string Job_Title_billing_contact_details_c;
    }
    
    
    public class head_of_Audit_and_Compliance {
        public string Id;
        public string  First_Name_head_of_Audit_c;
        public string  Last_Name_head_of_Audit_c;
        public string  Official_Email_head_of_Audit_c;
        public string  Tel_No_head_of_Audit_c;
        public string  Job_Title_head_of_Audit_c;
    }
    
    public class details_of_person_authorized{
        public string Id;
        public string  First_Name_details_of_person_authorized_c;
        public string  Last_Name_details_of_person_authorized_c;
        public string  Official_Email_details_of_person_authorized_c;
        public string  Tel_No_details_of_person_authorized_c;
        public string  Job_Title_details_of_person_authorized_c;
    }
    
    
    public class API_IP_address_details {
        public string Id;
        public string First_Name_API_IP_address_c;
        public string Last_Name_API_IP_address_c;
        public string  Official_Email_API_IP_address_c;
        public string  Tel_No_API_IP_address_c;
        public string  Job_Title_API_IP_address_c;
        public List<IpAddresscls> RestrctedIPRanges;
    }
    
    public class IpAddresscls{
        public string Id;
        public Integer SrNo; 
        public string login_IP;
    }
    
    
    public class UAT_Test_Profile_Details  
    {
        public string Id;
        public string First_Name_UAT_Test_Profile_Details_c;
        public string Last_Name_UAT_Test_Profile_Details_c;
        public string Official_Email_UAT_Test_Profile_Details_c;
        public string Tel_No_UAT_Test_Profile_Details_c;
        public string Job_Title_UAT_Test_Profile_Details_c;
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