public class  profileController{
    public Id contactId {get;set;}
    public List<String> child{get;set;}
    public List<String> parent{get;set;}
    
    // Case_Category__c
    // Case_Type__c
    // Sub_Type__c
    // Sub_Type_1__c

    public String forgotpasswordURL{get;set;}
    public String CaseCategory_C {get; set;}
    public List<String> CaseType_C {get; set;}
    public List<String> CaseSubType_C {get; set;}
    public List<String> CaseSubTypeOne_C {get; set;}

    public String base64Value{get;set;}
    public String contentType{get;set;}

    public List<ContentDocumentLink> myContentDocument {get;set;}
    public List<ContentVersion> cvList {get;set;}
    public ContentVersion cv{get;set;}
    public String cvtoSend {get;set;}

    public String force_site_label {get;set;}


    // public List<String> contactList {get;set;}

    // public String userInformation {get; set;}
    
    public profileController(){
        // getCaseCategoryPiclistValue();
        force_site_label = System.label.Site_Label;
        forgotpasswordURL  = System.label.okta_forgot_password_url;
        Map<String, List<String>> DpndList = new Map<String, List<String>>();
        DpndList = getFieldDependencies('Case','Case_Type__c','Sub_Type__c','Sub_Type_1__c');
        // System.debug('dpndList-------> '+DpndList);
    }

    @RemoteAction
    public static returnDocsStatus getExistingDocs(String Id,String Token){

        Boolean chkSession =  new session().checkSession(Id,Token);
        // Boolean chkSession =  true;
        if(chkSession){
            returnDocsStatus rdStatus = new returnDocsStatus();
            ContentDistribution dpu = new ContentDistribution();
            List<ContentDistribution> NcdList = new List<ContentDistribution>();
            List<ContentDocumentLink> myContentDocument = new List<ContentDocumentLink>();
            List<ContentVersion> NcvList = new List<ContentVersion>();
    
            try {
                myContentDocument = [SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.title,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId in ( SELECT Id FROM Contact WHERE Id =: Id ) and LinkedEntity.Type='Contact'];
                for (ContentDocumentLink temp : myContentDocument) {
                        ContentVersion cv = new ContentVersion();
                        cv = [SELECT ContentUrl,PathOnCLient,VersionNumber FROM ContentVersion WHERE ContentDocumentId = :temp.ContentDocumentId AND IsLatest = true];
                        dpu = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId =: cv.Id];
                        NcvList.add(cv);
                        NcdList.add(dpu);
                }
                rdStatus.cdList = NcdList;
                rdStatus.cvList = NcvList;
                rdStatus.status = true;
            } catch (Exception e) {
                rdStatus.status = false;
            }
            return rdStatus;

        }else{
            new session().deleteSession(Id);
            return null;
        }

    }

    @RemoteAction
    public static returnDocsStatus getInvoice(String Id,String Token){
        Boolean chkSession =  new session().checkSession(Id,Token);
        // Boolean chkSession =  true;
        if(chkSession){
            returnDocsStatus rdStatus = new returnDocsStatus();
            ContentDistribution dpu = new ContentDistribution();
            List<ContentDistribution> NcdList = new List<ContentDistribution>();
            List<ContentDocumentLink> myContentDocument = new List<ContentDocumentLink>();
            List<ContentVersion> NcvList = new List<ContentVersion>();
    
            try {
                Contact con = [SELECT Id,AccountId FROM Contact WHERE Id =: Id];
                // myContentDocument = [SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.title,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId in ( (SELECT Id FROM Contact WHERE Id =: Id ) and LinkedEntity.Type='Contact'];
                //myContentDocument = [SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.title,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId in (SELECT Id FROM Invoice__c WHERE Account__c =: con.AccountId) and LinkedEntity.Type='Invoice__c'];
                
                myContentDocument = [SELECT ContentDocument.LatestPublishedVersionId, ContentDocument.title,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId in (SELECT Id FROM Invoice__c WHERE Contact__c =: con.Id) and LinkedEntity.Type='Invoice__c'];
                System.debug('myContentDocument--->'+myContentDocument);
                for (ContentDocumentLink temp : myContentDocument) {
                        ContentVersion cv = new ContentVersion();
                        cv = [SELECT ContentUrl,PathOnCLient,VersionNumber,CreatedDate FROM ContentVersion WHERE ContentDocumentId = :temp.ContentDocumentId AND IsLatest = true];
                        dpu = [SELECT DistributionPublicUrl FROM ContentDistribution WHERE ContentVersionId =: cv.Id];
                        NcvList.add(cv);
                        NcdList.add(dpu);
                }
                rdStatus.cdList = NcdList;
                rdStatus.cvList = NcvList;
                rdStatus.status = true;
            } catch (Exception e) {
                rdStatus.status = false;
            }
            return rdStatus;

        }else{
            new session().deleteSession(Id);
            return null;
        }
    }

    public List<SelectOption> getCaseCategoryPiclistValue(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Case.Case_Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        System.debug('Pick List value'+options);
        // CaseCategory_C = JSON.serialize(options);
        // System.debug('Pick List value'+CaseCategory_C);
        return options;
    }

    public List<SelectOption> getCaseTypePiclistValue(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Case.Case_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        // System.debug('Pick List value'+options);
        return options;
    }

    public List<SelectOption> getCaseSubTypePiclistValue(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Case.Sub_Type__c.getDescribe();    
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        // System.debug('Pick List value'+options);
        return options;
    }

    public class MyPickListInfo{
        public String validFor;
    }

    public Map<String, List<String>> getFieldDependencies(String objectName, String controllingField, String dependentField1,String dependentField2){
        child = new List<String>();
        parent = new List<String>();
        Map<String, List<String>> controllingInfo = new Map<String, List<String>>();
        Map<String, List<String>> SubcontrollingInfo = new Map<String, List<String>>();

        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);

        Schema.DescribeSObjectResult describeResult = objType.getDescribe();
        Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
        Schema.DescribeFieldResult dependentFieldInfo1 = describeResult.fields.getMap().get(dependentField1).getDescribe();
        Schema.DescribeFieldResult dependentFieldInfo2 = describeResult.fields.getMap().get(dependentField2).getDescribe();

        List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues1 = dependentFieldInfo1.getPicklistValues();
        List<Schema.PicklistEntry> dependentValues2 = dependentFieldInfo2.getPicklistValues();

        for(Schema.PicklistEntry currControllingValue : controllingValues){
            // System.debug('ControllingField: Label:-> ' + currControllingValue.getLabel());
            controllingInfo.put(currControllingValue.getLabel(), new List<String>());
        }

        for(Schema.PicklistEntry SubcurrControllingValue : dependentValues1){
            // System.debug('ControllingField: Label:-> ' + SubcurrControllingValue.getLabel());
            SubcontrollingInfo.put(SubcurrControllingValue.getLabel(), new List<String>());
        }

        for(Schema.PicklistEntry currDependentValue2 : dependentValues2){
            // System.debug('-----------NEW ---currDependentValue2------ '+currDependentValue2);
            String jsonString = JSON.serialize(currDependentValue2);

            MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);

            String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();

            // System.debug('DependentField: Label:' + currDependentValue2.getLabel() + ' ValidForInHex:' + hexString + ' JsonString:' + jsonString);

            Integer baseCount = 0;

            for(Integer curr : hexString.getChars())
            {
                // System.debug('CURR---------> '+curr);
                Integer val = 0;

                if(curr >= 65){
                    val = curr - 65 + 10;
                }else{
                    val = curr - 48;
                }

                if((val & 8) == 8){
                    // System.debug('Dependent Field: ' + currDependentValue2.getLabel() + ' Partof ControllingField:' + dependentValues1[baseCount + 0].getLabel());
                    SubcontrollingInfo.get(dependentValues1[baseCount + 0].getLabel()).add(currDependentValue2.getLabel());
                }
                if((val & 4) == 4){
                    // System.debug('baseCount--> '+baseCount+1);
                    // System.debug('Dependent Field: ' + currDependentValue2.getLabel() + ' Partof ControllingField:' + dependentValues1[baseCount + 1].getLabel());
                    SubcontrollingInfo.get(dependentValues1[baseCount + 1].getLabel()).add(currDependentValue2.getLabel());                    
                }
                if((val & 2) == 2){
                    // System.debug('Dependent Field: ' + currDependentValue2.getLabel() + ' Partof ControllingField:' + dependentValues1[baseCount + 2].getLabel());
                    SubcontrollingInfo.get(dependentValues1[baseCount + 2].getLabel()).add(currDependentValue2.getLabel());                    
                }
                if((val & 1) == 1){
                    // System.debug('Dependent Field: ' + currDependentValue2.getLabel() + ' Partof ControllingField:' + dependentValues1[baseCount + 3].getLabel());
                    SubcontrollingInfo.get(dependentValues1[baseCount + 3].getLabel()).add(currDependentValue2.getLabel());                    
                }

                baseCount += 4;
            }            
        } 
        child.add(JSON.serialize(SubcontrollingInfo));
        System.debug('--->>SubControllingInfo-> '+child);
        for(Schema.PicklistEntry currDependentValue1 : dependentValues1){
            // System.debug('-----------NEW ---currDependentValue------ '+currDependentValue1);
            String jsonString = JSON.serialize(currDependentValue1);

            MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);

            String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();

            // System.debug('DependentField: Label:' + currDependentValue1.getLabel() + ' ValidForInHex:' + hexString + ' JsonString:' + jsonString);

            Integer baseCount = 0;

            for(Integer curr : hexString.getChars())
            {
                // System.debug('CURR---------> '+curr);
                Integer val = 0;

                if(curr >= 65){
                    val = curr - 65 + 10;
                }else{
                    val = curr - 48;
                }

                if((val & 8) == 8){
                    // System.debug('Dependent Field: ' + currDependentValue1.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 0].getLabel());
                    controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue1.getLabel());
                }
                if((val & 4) == 4){
                    controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue1.getLabel());                    
                }
                if((val & 2) == 2){
                    // System.debug('Dependent Field: ' + currDependentValue1.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 2].getLabel());
                    controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue1.getLabel());                    
                }
                if((val & 1) == 1){
                    // System.debug('Dependent Field: ' + currDependentValue1.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 3].getLabel());
                    controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue1.getLabel());                    
                }

                baseCount += 4;
            }
        } 
        parent.add(JSON.serialize(controllingInfo));
        System.debug('--->>controllingInfo-> '+parent);            

        // System.debug('SubcontrollingInfo: ' + SubcontrollingInfo);
        // System.debug('ControllingInfo: ' + controllingInfo);

        return controllingInfo;
    }

    @RemoteAction
    public static OctaStaus login(String email, String password){
        
        String ex_userName=email;
        String ex_password=password;
        String loginURL = System.label.okta_authentication_url;
        String ex_status='';
        Integer count=0;
        Contact contactList,dummyContactList;      
        //String Option='{"multiOptionalFactorEnroll": false,"warnBeforePasswordExpired": false}';
        //String jsonBody = '{"username": "'+userName+'","password" :"'+password+'","options":"'+Option+'"}';
        
        String jsonBody='{\"username\": \"'+ex_userName+'\",\"password\": \"'+ex_password+'\",\"options\": {\"multiOptionalFactorEnroll\": false,\"warnBeforePasswordExpired\": false}}';
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint(loginURL);
        req.setBody(jsonBody);
        System.debug('Input Request:' + jsonBody);
        OctaStaus oct = new OctaStaus();

        try{
            count = [SELECT count() FROM Contact WHERE Okta_ex_Username__c =: email limit 1];
            System.debug('count-----> '+count);
            if(count == 0){
                System.debug('If count-----> '+count);
                oct.msg = 'Invalid  Credentialssss';
                oct.status = false;
            }else{
                try{
                    System.debug('If req-----> '+req);
                    res = http.send(req);
                    JSON2Apex js = JSON2Apex.parse(res.getBody());
                    ex_status=js.status;
                    System.debug('If res.getBody() -----> '+res.getBody());
                    System.debug('If JS -----> '+js);
                    System.debug('If js.status-----> '+js.status);
                    System.debug('If ex_status-----> '+ex_status);
                    if(ex_status.equals('SUCCESS')){ // Actual Working Code
                    //if(ex_status==null){ // Change for testing purpose cause okta api not working as expected...
                        System.debug('If SUCCESS-----> ');
                        try{
                            dummyContactList = [SELECT Id,Guest_User_Toke__c FROM Contact WHERE Okta_ex_Username__c =: email limit 1];
                            contactList = [SELECT Id,AccountId,Title,Name,Email,Phone,Birthdate,Pan_no__c,Voter_id__c,MailingAddress,Aadhar_no__c,Passport_id__c,Contact_Role__c,
                            (SELECT Id,Delete_Access__c,Name,None_Access__c,Read_Access__c,ReadWrite_Access__c,Tabs_Name__c,Contact_Name__c, Tabs_Name__r.Name,Tabs_Name__r.Tab_Url__c FROM Contact_Access_Control__r WHERE Contact_Name__c =: dummyContactList.Id) 
                            FROM Contact WHERE Id =:dummyContactList.Id limit 1];
                            
                            String userSessionId = new session().startSession(dummyContactList.Id);
                            
                            System.debug('dummyContactList-->'+dummyContactList);

                            oct.contactList = contactList;
                            oct.Token = userSessionId;
                            oct.msg = 'Login Success';
                            oct.status = true;
                        }catch(QueryException e){
                            oct.msg = 'Invalid Credential 2343';
                            oct.status = false;
                        }

                    }else{
                        oct.msg = 'Invalids  Credential 4345';
                        oct.status = false;
                    }
                } catch(System.CalloutException e){
                    oct.msg = 'Invalid  Credential iuo';
                    oct.status = false;
                } catch(System.NullPointerException e){
                    oct.msg = 'Invalid  Credential poiuy';
                    oct.status = false;
                }
            }
        
        }catch(QueryException e) {
            oct.msg = 'Invalid  Credential';
            oct.status = false;
        }

        return oct;
    }

    @RemoteAction
    public static OctaStaus login1(String email, String password){
        System.debug('login Click');
        //List<Contact> contactList  = new List<Contact>();
        String userInformation;
        System.debug('loginCredentials'+email+'->'+password);
        Contact contactList,dummyContactList;
        OctaStaus oct = new OctaStaus();
        try {
            dummyContactList = [SELECT Id FROM Contact WHERE Password__c =: password AND User_Id__c =: email limit 1];

            contactList = [SELECT Id,AccountId,Title,Name,Email,Phone,Birthdate,Pan_no__c,Voter_id__c,MailingAddress,Aadhar_no__c,Passport_id__c,Contact_Role__c,
            (SELECT Id,Delete_Access__c,Name,None_Access__c,Read_Access__c,ReadWrite_Access__c,Tabs_Name__c,Contact_Name__c, Tabs_Name__r.Name,Tabs_Name__r.Tab_Url__c FROM Contact_Access_Control__r WHERE Contact_Name__c =: dummyContactList.Id) 
            FROM Contact WHERE Id =:dummyContactList.Id limit 1];
            
            oct.contactList = contactList;
            oct.msg = 'Login Success';
            oct.status = true;

            return oct;
        } catch (Exception e) {

            oct.status = false;
            return oct;

        }
    }

    @RemoteAction
    public static List <Map<String, Object>> getPlan(String Id){
        List <Map<String, Object>> maplistObject = new List <Map<String, Object>>();
        
        try {
            List<Product__c> plist = [ SELECT Id,Name,Examples__c,Description__c,Fee_Plan_Type__c,Initial_Payment_Amount__c, ( SELECT Id,Name,Monthly_Volumes__c,Price_Per_Report__c FROM Product_Line_Items__r ORDER BY Name ) FROM Product__c WHERE Active__c != true AND Fee_Plan_Type__c = 'Products' ];
            Contact cnt = [ SELECT Id,Name,(SELECT Id,Name,Product__c FROM Contact_Payment_Details__r) FROM Contact WHERE Id =: Id ];
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
                for (Lead_Payment_Detail__c lpdc : cnt.Contact_Payment_Details__r) {
                    System.debug(cnt.Contact_Payment_Details__r+' -- '+cnt.Contact_Payment_Details__r);
                    if(lpdc.Product__c == p.Id){
                        mapObject.put('Selected__c',true);
                    }
                }
                maplistObject.add(mapObject);
            }
            // return JSON.serialize(maplistObject);
            return maplistObject;
        } catch (Exception e) {
            return null;
        }
    }

    @RemoteAction
    public static Contact existingUserIdRequestorContact(String Id){       
        try {
            List<Contact> contactList = [ SELECT Id,Name,Contact_Role__c,Title,FirstName,LastName,Phone,Job_Title__c,Email FROM Contact WHERE Contact_Role__c='Authorized User Id' AND AccountId=: Id LIMIT 1 ];
            // List<Contact> contactList = [ SELECT Id,Name,Contact_Role__c,Title,FirstName,LastName,Phone,Job_Title__c,Email FROM Contact LIMIT 1 ];
            if(contactList.size() > 0){
                return contactList[0];
            }else{
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    @RemoteAction
    public static returnPlanSelection planSelection(String Id,String json,String Token){

        returnPlanSelection rPS = new returnPlanSelection();

        try{
            System.debug('json -> '+json);
            String s = json.replace( '__c' , '_c' );
            String ss = s.replace( '__r' , '_r' );
            System.debug('sinJson -> '+ ss);
            List<paymentDetailApexForPlan> pdApex = paymentDetailApexForPlanTarget(ss);
            System.debug('sinJson -> '+ pdApex);

            Contact cont = [SELECT Id,Email,(SELECT Id,Product__c,Name,Product__r.Id,Product__r.Name FROM Contact_Payment_Details__r) FROM Contact WHERE Id =: Id];
            List<Lead_Payment_Detail__c> pdcListToUpsert = new List<Lead_Payment_Detail__c>();
            List<Lead_Payment_Detail__c> pdcListToDelete = new List<Lead_Payment_Detail__c>();
            for (paymentDetailApexForPlan pd : pdApex) {
                Lead_Payment_Detail__c pdc = new Lead_Payment_Detail__c();
                System.debug('pd ----> '+ pd);
                if(pd.Selected_c == true){
                    System.debug('pd ----> '+ pd);
                    pdc.Contact__c = cont.Id;
                    System.debug('pd.Id ----> '+ pd.Id);
                    pdc.Product__c = pd.Id;
                    if(cont.Contact_Payment_Details__r.size() > 0){
                        for (Lead_Payment_Detail__c paymentDetail_c : cont.Contact_Payment_Details__r) {
                            if(pd.Id == paymentDetail_c.Product__r.Id){
                                pdc.Id = paymentDetail_c.Id;
                                pdc.Product__c = paymentDetail_c.Product__c;
                            }
                        }
                    }
                    System.debug('pdc ----> '+ pdc);
                    pdcListToUpsert.add(pdc);
                }else if(pd.Selected_c == false){
                    if(cont.Contact_Payment_Details__r.size() > 0){
                        for (Lead_Payment_Detail__c paymentDetail_c : cont.Contact_Payment_Details__r) {
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
            rPS.msg = 'We are validating your information and documents. You will hear from us soon on your email id '+cont.Email+' , '+' You are just 3 steps away from completing the membership process--  '+' , '+' 1.Validation of the documents submitted '+' , '+' 2.Payment for your Membership'+' ,'+' 3.E-signing of the Agreement ';
            rPS.status = true;
            

        }catch(QueryException e){
            rPS.msg = 'Exception !We are validating the documents from our end regarding specified user mentioned in CICRA.” You will hear from us shortly';
            // status.sing = 'fa fa-exclamation-triangle';
            rPS.status = false;
        }
        return rPS;
    }

    @RemoteAction
    public static resultStatus editProfile(String json,String userId, String Token){
        resultStatus rS = new resultStatus();
        Boolean chkSession =  new session().checkSession(userId,Token);
        // Boolean chkSession =  true;
        if(chkSession){
            try {
                String s = json.replace( '__c' , '_c' );
                System.debug('s-------> '+s);
                String Name;
                List<Contact> NContact = new List < Contact > ();
                List < EditeProfileApex > ContactList = parseProfileEditTarget(s);
                System.debug('Contact Lisit-------> '+ContactList);
                for(EditeProfileApex cL : ContactList){
                    Contact cn = new Contact();
                    
                    System.debug('cL cL-------> '+cL);
                    cn.Id = cL.Id;
                    cn.Phone = cL.Phone;
                    cn.Title = cL.Title;
                    cn.Email = cL.Email;
                    cn.Phone = cL.Phone;
                    cn.MailingCity = cL.MailingAddress.city;
                    cn.MailingCountry = cL.MailingAddress.country;
                    cn.MailingPostalCode = cL.MailingAddress.postalCode;
                    cn.MailingState = cL.MailingAddress.state;
                    cn.MailingStreet = cL.MailingAddress.street;
                    System.debug('cL cL-------> '+cL);
                    
                    update cn; 
        
                    Name = cL.Name;
                    rS.status = true;
                }
                
            } catch (Exception e) {
                rS.status = false;
            }
            return rS;

        }else{
            new session().deleteSession(userId);
            return null;
        }
    }
    @RemoteAction
    public static resultStatus saveUserIdRequestorIdForm(String json,String userId,String accountId, String Token){
        resultStatus rS = new resultStatus();
        Boolean chkSession =  new session().checkSession(userId,Token);
        // Boolean chkSession =  true;
        if(chkSession){
            try {
                String s = json.replace( '__c' , '_c' );
                System.debug('s-------> '+s);
                String Name;
                useerIdRequestorFormApex Con = parseUserIdRequestorFormTarget(s);
                System.debug('Contact Lisit-------> '+Con);
                Contact cn = new Contact();
                
                if(Con.Id != null){
                    cn.Id = Con.Id;
                }
                cn.Title = Con.Title;
                cn.AccountId = accountId;
                cn.FirstName = Con.FirstName;
                cn.LastName = Con.LastName;
                cn.Phone = Con.Phone;
                cn.Contact_Role__c='Authorized User Id';
                cn.Job_Title__c = Con.Job_Title_c;
                cn.Email = Con.Email;
                System.debug('cn-------> '+cn);
                
                upsert cn; 
    
                rS.status = true;
            } catch (Exception e) {
                rS.status = false;
            }
            return rS;

        }else{
            new session().deleteSession(userId);
            return null;
        }
    }
    
    @RemoteAction
    public static Contact getInforamtion(String userId, String Token){
        System.debug('getInforamtion Click');
        System.debug('getInforamtion Token=> '+Token);
        System.debug('getInforamtion userId=> '+userId);
        Boolean chkSession =  new session().checkSession(userId,Token);
        // Boolean chkSession =  true;
        if(chkSession){
            System.debug('chkSession--->'+chkSession);
            //List<Contact> contactList  = new List<Contact>();
            Contact contactList;
            try {
                contactList = [SELECT Id,AccountId,Title,Name,Email,Phone,Birthdate,Pan_no__c,Voter_id__c,MailingAddress,Aadhar_no__c,
                Passport_id__c,Contact_Role__c from Contact where Id =: userId limit 1];
                return contactList;
            } catch (Exception e) {
                return contactList;
            }
        }else{
            new session().deleteSession(userId);
            return null;
        }
    }

    @RemoteAction
    public static Boolean expire_session(String userId){
        try {
            new session().deleteSession(userId);
            return true;
        } catch (Exception e) {
            System.debug('---------------------->expire_session method'+e);
            return false;
        }
    }

    @RemoteAction
    public static Account getCompanyInforamtion(String accId,String userId, String Token){
        System.debug('getCompanyInforamtion Click');
        //List<Contact> contactList  = new List<Contact>();
        Boolean chkSession =  new session().checkSession(userId,Token);
        // Boolean chkSession =  true;
        if(chkSession){
            Account accountList;
            try {
                accountList = [SELECT Name,Account_Type__c,Industry,Phone,AccountNumber,Member_Status__c,Membership_Status__c,RecordTypeId,
                CIN_Company_Identification_Number__c,BillingAddress,ShippingAddress,Website,
                Nodal_Officer_Name__c,Authorized_Signatory_Name__c,Sharing_data_with_any_Credit_bureau__c,Total_Active_Credit_Accounts_in_Branches__c,Total_number_of_Branches__c,
                Total_number_of_States_Present_in__c,Software_used_for_Loan_origination__c,Approx_no_of_Commercial_loan_monthly__c,Approx_no_of_Consumer_loan_monthly__c
                from Account where Id =: accId limit 1 ];
                return accountList;
            } catch (Exception e) {
                return accountList;
            }

        }else{
            new session().deleteSession(userId);
            return null;
        }
    }

    @RemoteAction
    public static List <Case> getCases(String contactId, String Token){
        
        Boolean chkSession =  new session().checkSession(contactId,Token);
        // Boolean chkSession =  true;
        if(chkSession){
            List<Case> relatedCases = new List<Case>();
            try {
                Contact cnt = [SELECT Id,Guest_User_Toke__c FROM Contact WHERE Id =: contactId ];
                //List<Contact> contactList  = new List<Contact>();
                System.debug('cnt-->'+cnt);
                System.debug(System.Label.Guest_User_Id);
                try {
                    relatedCases = [SELECT Id,CaseNumber, Origin, OwnerId, Reason,CreatedDate,Sub_Type_1__c,Sub_Type__c,Subject,Description,Case_Category__c,Case_Type__c,Status,Case_Complaints__c FROM Case WHERE ContactId =: contactId AND Case_Created_By_Portal__c = true];
                    System.debug(relatedCases);
                    return relatedCases;
                } catch (Exception e) {
                    return relatedCases;
                }
            } catch (Exception e) {
                System.debug('Exception-->');
                return relatedCases;
            }
        }else{
            new session().deleteSession(contactId);
            return null;
        }
        
    }
    
    public PageReference loginRedirect(){
        System.debug('Login Redirect-->');
        
        // PageReference redirecturl = new PageReference('https://exppartial-experian.cs73.force.com/PortalLogin');
        PageReference pageRef = new PageReference('<a target="_blank" href="https://www.google.com"></a>');
        pageRef.setRedirect(true);
        System.debug('Login Redirect-->');
        return pageRef;
    }

    @RemoteAction
    public static resultStatus registerCases(String json, String userId, String Token){

        Boolean chkSession =  new session().checkSession(userId,Token);
        // Boolean chkSession =  true;
        if(chkSession){
            System.debug('json'+json);
    
            List < Case > CList = new List < Case > ();
            List < CaseApex > caseList = parseTarget(json);
            String returnId = '';
            String returnSubject = '';
            String returnCaseNumber = '';
            String sNe = '';
    
            for (CaseApex C: caseList) {
                Case cts = new Case();
                if(C.Id == '' || C.Id == null){
                    sNe = 'Submitted';
                }else{
                    sNe = 'Edited';
                } 
                
                AssignmentRule AR = new AssignmentRule();
                AR = [select id from AssignmentRule where SobjectType = 'Case' and Active = true];
                
                //Creating the DMLOptions for "Assign using active assignment rules" checkbox
                Database.DMLOptions dmlOpts = new Database.DMLOptions();
                dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;
                dmlOpts.EmailHeader.TriggerUserEmail = true;
                //Setting the DMLOption on Case instance 
                
                // Case newCase = [SELECT CaseNumber, Origin, OwnerId, Reason,CreatedDate,Sub_Type_1__c,Sub_Type__c,Subject,Description,Case_Category__c,Case_Type__c,Status From Case WHERE CaseNumber =: C.CaseNumber ];
                // newCase.CaseNumber = C.CaseNumber;
                cts.Id = C.Id;
                cts.ContactId = C.contactId;
                if( C.caseCategory == 'Customer'){
                    cts.RecordTypeId = System.Label.Customer_Case_Record_type_Id;
                }else{
                    cts.RecordTypeId = System.Label.Consumer_Case_Record_type_Id;
                }
                cts.Case_Category__c = C.caseCategory;
                cts.Case_Complaints__c = C.caseComplain;
                // cts.Case_Type__c = C.caseType;
                // cts.Sub_Type__c = C.caseSubType;
                // cts.Sub_Type_1__c = C.caseSubtypeOne;
                cts.Subject = C.Subject;
                cts.Description = C.Description;
                cts.Case_Created_By_Portal__c = true;
                cts.Origin = 'Web';
                // if (cts.CaseNumber != '') {
                //     cts.CaseNumber = C.CaseNumber;
                // }
                
                cts.setOptions(dmlOpts); 
    
                upsert cts;
    
                System.debug('cts-->'+cts);
    
                returnId = cts.Id;
                returnSubject = cts.Subject;
                Case cs = [SELECT CaseNumber FROM Case WHERE Id =: cts.Id];
                returnCaseNumber = cs.CaseNumber;
            }
            resultStatus status = new resultStatus();
            status.caseId = returnId;
            status.subject = returnSubject;
            status.caseNumber = returnCaseNumber;
            status.status = true;
            status.sNe = sNe;
            return status;        
        }else{
            new session().deleteSession(userId);
            return null;
        }

    }

    @RemoteAction
    public static Boolean deleteCase(String caseno, String userId, String Token){

        Boolean chkSession =  new session().checkSession(userId,Token);
        // Boolean chkSession =  true;
        if(chkSession){
            System.debug('Delete Click->      '+caseno);
            Case c = new Case();
            try {
                c = [SELECT Id,Reason FROM Case WHERE CaseNumber =: caseno];
                System.debug('Reason-------------> '+c);
                delete c;
                return true;
            } catch (Exception e) {
                return false;
            }
        }else{
            new session().deleteSession(userId);
            return null;
        }

    }

    @RemoteAction
    public static String attachBlob(String parentId, String attachmentId, String fileName, String contentType, String base64BlobValue){
        /*
        parentId: The sfdc object Id this file will be attached to
        attachmentId: The record of the current Attachment file being processed
        fileName: Name of the attachment
        contentTye: Content Type of the file being attached
        base64BlobValue: Base64 encoded string of the file piece currently processing
        */
        Integer idxDot = fileName.lastIndexOf('.') + 1;
        String extFile = fileName.substring(idxDot, fileName.length()).toLowerCase();
        if (extFile == 'pdf' || extFile == 'jpg' || extFile == 'jpeg' || extFile == 'gif' || extFile == 'png' || extFile == 'doc' || extFile == 'docx' || extFile == 'xls' || extFile == 'xlsx' || extFile == 'ppt' ||extFile == 'txt') {
            System.debug('extFile----->'+extFile);
            //If recordId is blank this is the first part of a multi piece upload
            if(attachmentId == '' || attachmentId == null){
                Attachment att = new Attachment(
                    ParentId = parentId,
                    Body = EncodingUtil.Base64Decode(base64BlobValue),
                    Name = fileName,
                    ContentType = contentType
                );
                insert att;

                //Return the new attachment Id
                return att.Id;

            }else{
                for(Attachment atm : [select Id, Body from Attachment where Id = :attachmentId]){
                    //Take the body of the current attachment, convert to base64 string, append base64 value sent from page, then convert back to binary for the body
                    update new Attachment(Id = attachmentId, Body = EncodingUtil.Base64Decode(EncodingUtil.Base64Encode(atm.Body) + base64BlobValue));
                }

                //Return the Id of the attachment we are currently processing
                return attachmentId;
            }
        }else{
            return '';
        }
        
    }


    public class CaseApex {
        public String Id{get;set;}
        public String CaseNumber{get;set;}
        public String caseComplain{get;set;}
        public String caseCategory{get;set;}
        public String caseType{get;set;}
        public String caseSubType{get;set;}
        public String caseSubtypeOne{get;set;}
        public String Subject{get;set;}
        public String Description{get;set;}
        public String CaseOrigin{get;set;}
        public String contactId{get;set;}
    }

    public class EditeProfileApex {
        public String Id{get;set;}
        public String AccountId{get;set;}
        public String Contact_Role_c{get;set;}
        public String Name{get;set;}
        public String Email{get;set;}
        public String Pan_no_c{get;set;}
        public String Phone{get;set;}
        public String Title{get;set;}
        public MailingAddress MailingAddress{get;set;}
    }

    public class MailingAddress {
        public String city{get;set;}
        public String country{get;set;}
        public String postalCode{get;set;}
        public String state{get;set;}
        public String street{get;set;}
    }

    public class resultStatus{
        public Boolean status{get;set;}
        public String caseId{get;set;}
        public String caseNumber{get;set;}
        public String subject{get;set;}
        public String sNe{get;set;}
    }

    public class OctaStaus{
        public Contact contactList{get;set;}
        public String msg {get;set;}
        public String instruction{get;set;}
        public Boolean Status{get;set;}
        public String Token{get;set;}
    }

    public class returnDocsStatus{
        public List<ContentDistribution> cdList{get;set;}
        public List<ContentVersion> cvList{get;set;}
        public Boolean status{get;set;}
    }

    public class returnPlanSelection{
        public Boolean status;
        public Boolean goNext;
        public String msg;
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

    public class Product_Line_Items_r{
        public String Id;
        public String Name;
        public String Product_c;
        public String Monthly_Volumes_c;
        public String Price_Per_Report_c;
    }

    public class useerIdRequestorFormApex{
        public String Id;
        public String Name;
        public String Contact_Role_c;
        public String Title;
        public String FirstName;
        public String LastName;
        public String Phone;
        public String Job_Title_c;
        public String Email;
    }
    
    public static List < CaseApex > parseTarget(String json) {
        return (List < CaseApex > ) System.JSON.deserialize(json, List < CaseApex > .class);
    }

    public static List < EditeProfileApex > parseProfileEditTarget(String json) {
        return (List < EditeProfileApex > ) System.JSON.deserialize(json, List < EditeProfileApex > .class);
    }

    public static useerIdRequestorFormApex parseUserIdRequestorFormTarget(String json) {
        return (useerIdRequestorFormApex) System.JSON.deserialize(json,useerIdRequestorFormApex.class);
    }

    public static List < paymentDetailApexForPlan >  paymentDetailApexForPlanTarget(String json) {
        return ( List < paymentDetailApexForPlan > ) System.JSON.deserialize(json, List < paymentDetailApexForPlan >.class);
    }
}