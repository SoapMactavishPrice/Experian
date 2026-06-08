public without sharing class  GrievancesNodalOfficersControllerV2 {
    
    public Id accId {get;set;}
    public GrievancesNodalOfficersControllerV2(){
        accId = ApexPages.currentPage().getParameters().get('recordId');
        system.debug('account Id'+accId);
        if(accId == null){
            accId='001Bi00000CgquXIAR';
        }
    }
    
    @AuraEnabled
    public static string sendOTPEmail(String accId) {
        try{
            final integer STRING_LENGTH = 4;
            String aleaNumberN = String.valueOf(Math.Round(Math.Random() * ((Math.pow(10,STRING_LENGTH) - 1)-Math.pow(10,STRING_LENGTH -1)) + Math.pow(10,STRING_LENGTH -1)));
            Blob cryptoKey = Crypto.generateAesKey(128);
            Blob data = Blob.valueOf(aleaNumberN);
            Blob encryptedData = Crypto.generateDigest('MD5', data);
            String otpEnc=EncodingUtil.convertToHex(encryptedData);
            system.debug('aleaNumberN==>'+aleaNumberN);
            system.debug('otpEnc==>'+otpEnc);
            
            
            Account acc = [Select Id ,Name,Nodal_Officer_Email__c,Authorized_Signatory_Email__c,OTP__c from  Account where Id =:accId limit 1]; 
            
            acc.Id = accId;
            acc.OTP__c =  otpEnc;
            //acc.OTP_Plain__c = aleaNumberN;
            update acc;
            List<Messaging.Email> allMails = new List<Messaging.Email>();
            OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'customer.support@in.experian.com'];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            
            List<String> emailList = new List<String>();
            
            if (String.isNotBlank(acc.Nodal_Officer_Email__c)) {
                emailList.add(acc.Nodal_Officer_Email__c);
            }
            if (String.isNotBlank(acc.Authorized_Signatory_Email__c)) {
                emailList.add(acc.Authorized_Signatory_Email__c);
            }
            
            if (!emailList.isEmpty()) {
                mail.setToAddresses(emailList);
            }
            
            //mail.setToAddresses(new String[] { acc.Nodal_Officer_Email__c,acc.Authorized_Signatory_Email__c });
            mail.setSubject('OTP');
            
            if (owea.size() > 0) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setPlainTextBody('Your OTP is: ' + aleaNumberN);
            allMails.add(mail);
            List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
            return 'Opt Send Sucessfully';
        }catch(exception e){
            return e.getMessage()+' - '+e.getLineNumber();
        }
    }
    
    @AuraEnabled
    public static map<string,object>  verifyOTPEmail(String accId, String otp) {
        map<string,object> result = new map<string,object>();
        Account awp = [Select Id , OTP__c from  Account where Id =:accId  limit 1]; 
        
        Blob data = Blob.valueOf(OTP);
        system.debug(' data '+data);
        Blob encryptedData = Crypto.generateDigest('MD5', data);
        system.debug(' encryptedData '+encryptedData);
        String otpEnc=EncodingUtil.convertToHex(encryptedData);
        if(awp.OTP__c == otpEnc){
            result.put('Message','Verified');
            result.put('Status',true);
        }else{
            result.put('Message','Please Enter Valid OTP');
            result.put('Status',false);
        }
        return result;
        
    }
    
    @AuraEnabled 
    public static string getAccountData(string accId, string otp){
        if(accId == null){
            accId='001Bi00000CgquXIAR';
        }
        Account awp = [Select Id ,Name,Grievances_Nodal_Officer_Name__c,Grievances_Nodal_Officer_Email__c,Grievances_Nodal_Officer_Phone__c,
                       Technology_Contact_Email__c,Technology_Contact_Phone__c,Technology_Contact_Name__c,
                       Person_Name_Dispute__c,Person_Name_2__c, Person_Name_3__c, Person_Name_4__c, Person_Name_5__c, Person_Name_6__c,
                       Person_Name_7__c, Person_Name_8__c, Person_Name_9__c, Person_Name_10__c,
                       Email_1_Dispute__c, Email_2_Dispute__c, Email_3_Dispute__c, Email_4_Dispute__c, Email_5_Dispute__c, Email_6_Dispute__c, 
                       Email_7_Dispute__c, Email_8_Dispute__c, Email_9_Dispute__c, Email_10_Dispute__c,
                       Phone_1__c, Phone_2__c, Phone_3__c, Phone_4__c, Phone_5__c, Phone_6__c ,
                       Phone_7__c, Phone_8__c, Phone_9__c, Phone_10__c,
                       Nodal_Officer_Name__c,Nodal_Officer_Phone__c,Nodal_Officer_Email__c,Authorized_Signatory_Email__c,Authorized_Signatory_Name__c,Authorized_Signatory_Phone__c,
                       Change_Dispute_Detail_1__c,Change_Dispute_Detail_2__c,Change_Dispute_Detail_3__c,Change_Dispute_Detail_4__c,Change_Dispute_Detail_5__c,
                       Change_Dispute_Detail_6__c,Change_Dispute_Detail_7__c,Change_Dispute_Detail_8__c,Change_Dispute_Detail_9__c,
                       Change_Dispute_Detail_10__c,
                       
                       
                       Temp_Nodal_Officer_Name__c,Temp_Authorized_Signatory_Email__c,Temp_Authorized_Signatory_Name__c,
                       Temp_Authorized_Signatory_Phone__c
                       ,Temp_Nodal_Officer_Email__c,Temp_Nodal_Officer_Phone__c
                       ,DQR_DQI_Email_1__c,DQR_DQI_Email_2__c,DQR_DQI_Email_3__c,DQR_DQI_Email_4__c,DQR_DQI_Email_5__c,DQR_DQI_Email_6__c,DQR_DQI_Email_7__c,DQR_DQI_Email_8__c,DQR_DQI_Email_9__c,DQR_DQI_Email_10__c,
                       DQR_DQI_Email_11__c,DQR_DQI_Email_12__c,DQR_DQI_Email_13__c,DQR_DQI_Email_14__c,DQR_DQI_Email_15__c,DQR_DQI_Email_16__c,DQR_DQI_Email_17__c,DQR_DQI_Email_18__c,DQR_DQI_Email_19__c,DQR_DQI_Email_20__c,
                       DQR_DQI_Email_21__c,DQR_DQI_Email_22__c,DQR_DQI_Email_23__c,DQR_DQI_Email_24__c,DQR_DQI_Email_25__c,
                       
                       Form_C_Level_1_Email_1__c,Form_C_Level_1_Email_2__c,Form_C_Level_1_Email_3__c,Form_C_Level_1_Email_4__c,Form_C_Level_1_Email_5__c,Form_C_Level_1_Email_6__c,Form_C_Level_1_Email_7__c,Form_C_Level_1_Email_8__c,Form_C_Level_1_Email_9__c,Form_C_Level_1_Email_10__c,
                       Form_C_Level_1_Email_11__c,Form_C_Level_1_Email_12__c,Form_C_Level_1_Email_13__c,Form_C_Level_1_Email_14__c,Form_C_Level_1_Email_15__c/*,Form_C_Level_1_Email_16_del__c*/,
                       
                       Form_C_Level_2_Email_1__c,Form_C_Level_2_Email_2__c,Form_C_Level_2_Email_3__c,Form_C_Level_2_Email_4__c,Form_C_Level_2_Email_5__c,
                       
                       Form_C_Level_3_Email_1__c,Form_C_Level_3_Email_2__c,Form_C_Level_3_Email_3__c,Form_C_Level_3_Email_4__c,Form_C_Level_3_Email_5__c,
                       Billing_Contact_Email__c,Billing_Contact_Name__c,Billing_Contact_Phone__c,
                       Dispute_Email_1__c,Dispute_Email_2__c,Dispute_Email_3__c,Dispute_Email_4__c,Dispute_Email_5__c,Dispute_Email_6__c,Dispute_Email_7__c,Dispute_Email_8__c,Dispute_Email_9__c,
                       Dispute_Email_10__c,Dispute_Email_11__c,Dispute_Email_12__c,Dispute_Email_13__c,Dispute_Email_14__c,Dispute_Email_15__c
                       , OLM_Email_1__c, OLM_Email_2__c, OLM_Email_3__c, OLM_Email_4__c, OLM_Email_5__c,
                       OLM_Email_6__c, OLM_Email_7__c, OLM_Email_8__c, OLM_Email_9__c, OLM_Email_10__c,
                       OLM_Email_11__c, OLM_Email_12__c, OLM_Email_13__c, OLM_Email_14__c, OLM_Email_15__c,
                       OLM_Email_16__c, OLM_Email_17__c, OLM_Email_18__c, OLM_Email_19__c, OLM_Email_20__c,
                       OLM_Email_21__c, OLM_Email_22__c, OLM_Email_23__c, OLM_Email_24__c, OLM_Email_25__c,
                       OLM_Email_26__c, OLM_Email_27__c, OLM_Email_28__c, OLM_Email_29__c, OLM_Email_30__c,
                       OLM_Email_31__c, OLM_Email_32__c, OLM_Email_33__c, OLM_Email_34__c, OLM_Email_35__c,
                       OLM_Email_36__c, OLM_Email_37__c, OLM_Email_38__c, OLM_Email_39__c, OLM_Email_40__c
                       
                       
                       from Account where ID =:accId];
        
        AWPJSON acc = new AWPJSON();
        acc.Id =awp.Id;
        acc.Grievances_Nodal_Officer_Name= awp.Grievances_Nodal_Officer_Name__c;
        acc.Grievances_Nodal_Officer_Phone= awp.Grievances_Nodal_Officer_Phone__c;
        acc.Grievances_Nodal_Officer_Email= awp.Grievances_Nodal_Officer_Email__c;
        acc.Technology_Contact_Email= awp.Technology_Contact_Email__c;
        acc.Technology_Contact_Name= awp.Technology_Contact_Name__c;
        acc.Technology_Contact_Phone= awp.Technology_Contact_Phone__c;
        
        
        /*acc.Nodal_Officer_Name= awp.Nodal_Officer_Name__c;
        acc.Nodal_Officer_Phone= awp.Nodal_Officer_Phone__c;
        acc.Nodal_Officer_Email= awp.Nodal_Officer_Email__c;
        acc.Auth_Contact_Email= awp.Authorized_Signatory_Email__c;
        acc.Auth_Contact_Name= awp.Authorized_Signatory_Name__c;
        acc.Auth_Contact_Phone= awp.Authorized_Signatory_Phone__c;
        */
        
        
        acc.Nodal_Officer_Name= awp.Temp_Nodal_Officer_Name__c;
        acc.Nodal_Officer_Phone= awp.Temp_Nodal_Officer_Phone__c;
        acc.Nodal_Officer_Email= awp.Temp_Nodal_Officer_Email__c;
        acc.Auth_Contact_Email= awp.Temp_Authorized_Signatory_Email__c;
        acc.Auth_Contact_Name= awp.Temp_Authorized_Signatory_Name__c;
        acc.Auth_Contact_Phone= awp.Temp_Authorized_Signatory_Phone__c;
        acc.Billing_Contact_Email = awp.Billing_Contact_Email__c;
        acc.Billing_Contact_Name = awp.Billing_Contact_Name__c;
        acc.Billing_Contact_Phone = awp.Billing_Contact_Phone__c;
        
        
        if(awp.Person_Name_Dispute__c !=null || awp.Email_1_Dispute__c !=null || awp.Phone_1__c !=null){
            acc.Person_Name_Dispute= awp.Person_Name_Dispute__c;
            acc.Email_1_Dispute= awp.Email_1_Dispute__c;
            acc.Phone_1= awp.Phone_1__c;
            acc.inp_disabled_1  = true;
            acc.perseon_pB1_disabled = false;
        }else{
            acc.Person_Name_Dispute= awp.Person_Name_Dispute__c;
            acc.Email_1_Dispute= awp.Email_1_Dispute__c;
            acc.Phone_1= awp.Phone_1__c;
            acc.inp_disabled_1  =false;
            acc.perseon_pB1_disabled = true;
        }
        
        
        
        if(awp.Person_Name_2__c !=null || awp.Email_2_Dispute__c !=null || awp.Phone_2__c !=null){
            acc.Person_Name_2= awp.Person_Name_2__c;
            acc.Email_2_Dispute= awp.Email_2_Dispute__c;
            acc.Phone_2= awp.Phone_2__c;
            acc.inp_disabled_2  = true;
            acc.perseon_pB2_disabled = false;
        }else{
            acc.Person_Name_2= awp.Person_Name_2__c;
            acc.Email_2_Dispute= awp.Email_2_Dispute__c;
            acc.Phone_2= awp.Phone_2__c;
            acc.inp_disabled_2  =false;
            acc.perseon_pB2_disabled = true;
        }
        
        
        if(awp.Person_Name_3__c !=null || awp.Email_3_Dispute__c !=null || awp.Phone_3__c !=null){
            acc.Person_Name_3= awp.Person_Name_3__c;
            acc.Email_3_Dispute= awp.Email_3_Dispute__c;
            acc.Phone_3= awp.Phone_3__c;
            acc.inp_disabled_3  = true;
            acc.perseon_pB3_disabled = false;
        }else{
            acc.Person_Name_3= awp.Person_Name_3__c;
            acc.Email_3_Dispute= awp.Email_3_Dispute__c;
            acc.Phone_3= awp.Phone_3__c;
            acc.inp_disabled_3  =false;
            acc.perseon_pB3_disabled = true;
        }
        
        if(awp.Person_Name_4__c !=null || awp.Email_4_Dispute__c !=null || awp.Phone_4__c !=null){
            acc.Person_Name_4= awp.Person_Name_4__c;
            acc.Email_4_Dispute= awp.Email_4_Dispute__c;
            acc.Phone_4= awp.Phone_4__c;
            acc.inp_disabled_4  = true;
            acc.perseon_pB4_disabled = false;
        }else{
            acc.Person_Name_4= awp.Person_Name_4__c;
            acc.Email_4_Dispute= awp.Email_4_Dispute__c;
            acc.Phone_4= awp.Phone_4__c;
            acc.inp_disabled_4  =false;
            acc.perseon_pB4_disabled = true;
        }
        
        
        if(awp.Person_Name_5__c !=null || awp.Email_5_Dispute__c !=null || awp.Phone_5__c !=null){
            acc.Person_Name_5= awp.Person_Name_5__c;
            acc.Email_5_Dispute= awp.Email_5_Dispute__c;
            acc.Phone_5= awp.Phone_5__c;
            acc.inp_disabled_5  = true;
            acc.perseon_pB4_disabled = false;
        }else{
            acc.Person_Name_5= awp.Person_Name_5__c;
            acc.Email_5_Dispute= awp.Email_5_Dispute__c;
            acc.Phone_5= awp.Phone_5__c;
            acc.inp_disabled_5  =false;
            acc.perseon_pB5_disabled = true;
        }
        
        if(awp.Person_Name_6__c !=null || awp.Email_6_Dispute__c !=null || awp.Phone_6__c !=null){
            acc.Person_Name_6= awp.Person_Name_6__c;
            acc.Email_6_Dispute= awp.Email_6_Dispute__c;
            acc.Phone_6= awp.Phone_6__c;
            acc.inp_disabled_6  = true;
            acc.perseon_pB6_disabled = false;
        }else{
            acc.Person_Name_6 = awp.Person_Name_6__c;
            acc.Email_6_Dispute= awp.Email_6_Dispute__c;
            acc.Phone_6= awp.Phone_6__c;
            acc.inp_disabled_6  =false;
            acc.perseon_pB6_disabled = true;
        }
        
        
        if(awp.Person_Name_7__c !=null || awp.Email_7_Dispute__c !=null || awp.Phone_7__c !=null){
            acc.Person_Name_7= awp.Person_Name_7__c;
            acc.Email_7_Dispute= awp.Email_7_Dispute__c;
            acc.Phone_7= awp.Phone_7__c;
            acc.inp_disabled_7  = true;
            acc.perseon_pB7_disabled = false;
        }else{
            acc.Person_Name_7 = awp.Person_Name_7__c;
            acc.Email_7_Dispute= awp.Email_7_Dispute__c;
            acc.Phone_7= awp.Phone_7__c;
            acc.inp_disabled_7  =false;
            acc.perseon_pB7_disabled = true;
        }
        
        
        if(awp.Person_Name_8__c !=null || awp.Email_8_Dispute__c !=null || awp.Phone_8__c !=null){
            acc.Person_Name_8= awp.Person_Name_8__c;
            acc.Email_8_Dispute= awp.Email_8_Dispute__c;
            acc.Phone_8= awp.Phone_8__c;
            acc.inp_disabled_8  = true;
            acc.perseon_pB8_disabled = false;
        }else{
            acc.Person_Name_8 = awp.Person_Name_8__c;
            acc.Email_8_Dispute= awp.Email_8_Dispute__c;
            acc.Phone_8= awp.Phone_8__c;
            acc.inp_disabled_8  =false;
            acc.perseon_pB8_disabled = true;
        }
        
        
        if(awp.Person_Name_9__c !=null || awp.Email_9_Dispute__c !=null || awp.Phone_9__c !=null){
            acc.Person_Name_9= awp.Person_Name_9__c;
            acc.Email_9_Dispute= awp.Email_9_Dispute__c;
            acc.Phone_9= awp.Phone_9__c;
            acc.inp_disabled_9  = true;
            acc.perseon_pB9_disabled = false;
        }else{
            acc.Person_Name_9 = awp.Person_Name_9__c;
            acc.Email_9_Dispute= awp.Email_9_Dispute__c;
            acc.Phone_9= awp.Phone_9__c;
            acc.inp_disabled_9  =false;
            acc.perseon_pB9_disabled = true;
        }
        
        
        if(awp.Person_Name_10__c !=null || awp.Email_10_Dispute__c !=null || awp.Phone_10__c !=null){
            acc.Person_Name_10= awp.Person_Name_10__c;
            acc.Email_10_Dispute= awp.Email_10_Dispute__c;
            acc.Phone_10 = awp.Phone_10__c;
            acc.inp_disabled_10  = true;
            acc.perseon_pB10_disabled = false;
        }else{
            acc.Person_Name_10 = awp.Person_Name_10__c;
            acc.Email_10_Dispute= awp.Email_10_Dispute__c;
            acc.Phone_10= awp.Phone_10__c;
            acc.inp_disabled_10  =false;
            acc.perseon_pB10_disabled = true;
        }
        
        
        
        acc.perseon_pB1 = false;
        acc.perseon_pB2 = false;
        acc.perseon_pB3 = false;
        acc.perseon_pB4 = false;
        acc.perseon_pB5 = false;
        acc.perseon_pB6 = false;
        acc.perseon_pB7 = false;
        acc.perseon_pB8 = false;
        acc.perseon_pB9 = false;
        acc.perseon_pB10 = false;
        
        DQR_DQI_Email dq = new DQR_DQI_Email();
        dq.DQR_DQI_Email_1 = String.isNotBlank(awp.DQR_DQI_Email_1__c) ? awp.DQR_DQI_Email_1__c : '';
        dq.DQR_DQI_Email_2 = String.isNotBlank(awp.DQR_DQI_Email_2__c) ? awp.DQR_DQI_Email_2__c : '';
        dq.DQR_DQI_Email_3 = String.isNotBlank(awp.DQR_DQI_Email_3__c) ? awp.DQR_DQI_Email_3__c : '';
        dq.DQR_DQI_Email_4 = String.isNotBlank(awp.DQR_DQI_Email_4__c) ? awp.DQR_DQI_Email_4__c : '';
        dq.DQR_DQI_Email_5 = String.isNotBlank(awp.DQR_DQI_Email_5__c) ? awp.DQR_DQI_Email_5__c : '';
        
        dq.DQR_DQI_Email_6 = String.isNotBlank(awp.DQR_DQI_Email_6__c) ? awp.DQR_DQI_Email_6__c : '';
        dq.DQR_DQI_Email_7 = String.isNotBlank(awp.DQR_DQI_Email_7__c) ? awp.DQR_DQI_Email_7__c : '';
        dq.DQR_DQI_Email_8 = String.isNotBlank(awp.DQR_DQI_Email_8__c) ? awp.DQR_DQI_Email_8__c : '';
        dq.DQR_DQI_Email_9 = String.isNotBlank(awp.DQR_DQI_Email_9__c) ? awp.DQR_DQI_Email_9__c : '';
        dq.DQR_DQI_Email_10 = String.isNotBlank(awp.DQR_DQI_Email_10__c) ? awp.DQR_DQI_Email_10__c : '';
        dq.DQR_DQI_Email_11 = String.isNotBlank(awp.DQR_DQI_Email_11__c) ? awp.DQR_DQI_Email_11__c : '';
        dq.DQR_DQI_Email_12 = String.isNotBlank(awp.DQR_DQI_Email_12__c) ? awp.DQR_DQI_Email_12__c : '';
        dq.DQR_DQI_Email_13 = String.isNotBlank(awp.DQR_DQI_Email_13__c) ? awp.DQR_DQI_Email_13__c : '';
        dq.DQR_DQI_Email_14 = String.isNotBlank(awp.DQR_DQI_Email_14__c) ? awp.DQR_DQI_Email_14__c : '';
        dq.DQR_DQI_Email_15 = String.isNotBlank(awp.DQR_DQI_Email_15__c) ? awp.DQR_DQI_Email_15__c : '';
        dq.DQR_DQI_Email_16 = String.isNotBlank(awp.DQR_DQI_Email_16__c) ? awp.DQR_DQI_Email_16__c : '';
        dq.DQR_DQI_Email_17 = String.isNotBlank(awp.DQR_DQI_Email_17__c) ? awp.DQR_DQI_Email_17__c : '';
        dq.DQR_DQI_Email_18 = String.isNotBlank(awp.DQR_DQI_Email_18__c) ? awp.DQR_DQI_Email_18__c : '';
        dq.DQR_DQI_Email_19 = String.isNotBlank(awp.DQR_DQI_Email_19__c) ? awp.DQR_DQI_Email_19__c : '';
        dq.DQR_DQI_Email_20 = String.isNotBlank(awp.DQR_DQI_Email_20__c) ? awp.DQR_DQI_Email_20__c : '';
        dq.DQR_DQI_Email_21 = String.isNotBlank(awp.DQR_DQI_Email_21__c) ? awp.DQR_DQI_Email_21__c : '';
        dq.DQR_DQI_Email_22 = String.isNotBlank(awp.DQR_DQI_Email_22__c) ? awp.DQR_DQI_Email_22__c : '';
        dq.DQR_DQI_Email_23 = String.isNotBlank(awp.DQR_DQI_Email_23__c) ? awp.DQR_DQI_Email_23__c : '';
        dq.DQR_DQI_Email_24 = String.isNotBlank(awp.DQR_DQI_Email_24__c) ? awp.DQR_DQI_Email_24__c : '';
        dq.DQR_DQI_Email_25 = String.isNotBlank(awp.DQR_DQI_Email_25__c) ? awp.DQR_DQI_Email_25__c : '';
        
        acc.dqr = dq;
        
        Dispute_Email dm = new Dispute_Email();
        dm.Dispute_Email_1 = String.isNotBlank(awp.Dispute_Email_1__c) ? awp.Dispute_Email_1__c : '';
        dm.Dispute_Email_2 = String.isNotBlank(awp.Dispute_Email_2__c) ? awp.Dispute_Email_2__c : '';
        dm.Dispute_Email_3 = String.isNotBlank(awp.Dispute_Email_3__c) ? awp.Dispute_Email_3__c : '';
        dm.Dispute_Email_4 = String.isNotBlank(awp.Dispute_Email_4__c) ? awp.Dispute_Email_4__c : '';
        dm.Dispute_Email_5 = String.isNotBlank(awp.Dispute_Email_5__c) ? awp.Dispute_Email_5__c : '';
        dm.Dispute_Email_6 = String.isNotBlank(awp.Dispute_Email_6__c) ? awp.Dispute_Email_6__c : '';
        dm.Dispute_Email_7 = String.isNotBlank(awp.Dispute_Email_7__c) ? awp.Dispute_Email_7__c : '';
        dm.Dispute_Email_8 = String.isNotBlank(awp.Dispute_Email_8__c) ? awp.Dispute_Email_8__c : '';
        dm.Dispute_Email_9 = String.isNotBlank(awp.Dispute_Email_9__c) ? awp.Dispute_Email_9__c : '';
        dm.Dispute_Email_10 = String.isNotBlank(awp.Dispute_Email_10__c) ? awp.Dispute_Email_10__c : '';
        dm.Dispute_Email_11 = String.isNotBlank(awp.Dispute_Email_11__c) ? awp.Dispute_Email_11__c : '';
        dm.Dispute_Email_12 = String.isNotBlank(awp.Dispute_Email_12__c) ? awp.Dispute_Email_12__c : '';
        dm.Dispute_Email_13 = String.isNotBlank(awp.Dispute_Email_13__c) ? awp.Dispute_Email_13__c : '';
        dm.Dispute_Email_14 = String.isNotBlank(awp.Dispute_Email_14__c) ? awp.Dispute_Email_14__c : '';
        dm.Dispute_Email_15 = String.isNotBlank(awp.Dispute_Email_15__c) ? awp.Dispute_Email_15__c : '';
        
        acc.dispute = dm;
        
        Form_C_Level_1_Email fc1 = new Form_C_Level_1_Email();
        fc1.Form_C_Level_Email_1 = String.isNotBlank(awp.Form_C_Level_1_Email_1__c) ? awp.Form_C_Level_1_Email_1__c : '';
        fc1.Form_C_Level_Email_2 = String.isNotBlank(awp.Form_C_Level_1_Email_2__c) ? awp.Form_C_Level_1_Email_2__c : '';
        fc1.Form_C_Level_Email_3 = String.isNotBlank(awp.Form_C_Level_1_Email_3__c) ? awp.Form_C_Level_1_Email_3__c : '';
        fc1.Form_C_Level_Email_4 = String.isNotBlank(awp.Form_C_Level_1_Email_4__c) ? awp.Form_C_Level_1_Email_4__c : '';
        fc1.Form_C_Level_Email_5 = String.isNotBlank(awp.Form_C_Level_1_Email_5__c) ? awp.Form_C_Level_1_Email_5__c : '';
        fc1.Form_C_Level_Email_6 = String.isNotBlank(awp.Form_C_Level_1_Email_6__c) ? awp.Form_C_Level_1_Email_6__c : '';
        fc1.Form_C_Level_Email_7 = String.isNotBlank(awp.Form_C_Level_1_Email_7__c) ? awp.Form_C_Level_1_Email_7__c : '';
        fc1.Form_C_Level_Email_8 = String.isNotBlank(awp.Form_C_Level_1_Email_8__c) ? awp.Form_C_Level_1_Email_8__c : '';
        fc1.Form_C_Level_Email_9 = String.isNotBlank(awp.Form_C_Level_1_Email_9__c) ? awp.Form_C_Level_1_Email_9__c : '';
        
        fc1.Form_C_Level_Email_10 = String.isNotBlank(awp.Form_C_Level_1_Email_10__c) ? awp.Form_C_Level_1_Email_10__c : '';
        fc1.Form_C_Level_Email_11 = String.isNotBlank(awp.Form_C_Level_1_Email_11__c) ? awp.Form_C_Level_1_Email_11__c : '';
        fc1.Form_C_Level_Email_12 = String.isNotBlank(awp.Form_C_Level_1_Email_12__c) ? awp.Form_C_Level_1_Email_12__c : '';
        fc1.Form_C_Level_Email_13 = String.isNotBlank(awp.Form_C_Level_1_Email_13__c) ? awp.Form_C_Level_1_Email_13__c : '';
        fc1.Form_C_Level_Email_14 = String.isNotBlank(awp.Form_C_Level_1_Email_14__c) ? awp.Form_C_Level_1_Email_14__c : '';
        fc1.Form_C_Level_Email_15 = String.isNotBlank(awp.Form_C_Level_1_Email_15__c) ? awp.Form_C_Level_1_Email_15__c : '';
        //fc1.Form_C_Level_Email_16 = String.isNotBlank(awp.Form_C_Level_1_Email_16_del__c) ? awp.Form_C_Level_1_Email_16_del__c : '';
        
        acc.formOne = fc1;
        
        Form_C_Level_2_Email fc2 = new Form_C_Level_2_Email();
        fc2.Form_C_Level_2_Email_1 = String.isNotBlank(awp.Form_C_Level_2_Email_1__c) ? awp.Form_C_Level_2_Email_1__c : '';
        fc2.Form_C_Level_2_Email_2 = String.isNotBlank(awp.Form_C_Level_2_Email_2__c) ? awp.Form_C_Level_2_Email_2__c : '';
        fc2.Form_C_Level_2_Email_3 = String.isNotBlank(awp.Form_C_Level_2_Email_3__c) ? awp.Form_C_Level_2_Email_3__c : '';
        fc2.Form_C_Level_2_Email_4 = String.isNotBlank(awp.Form_C_Level_2_Email_4__c) ? awp.Form_C_Level_2_Email_4__c : '';
        fc2.Form_C_Level_2_Email_5 = String.isNotBlank(awp.Form_C_Level_2_Email_5__c) ? awp.Form_C_Level_2_Email_5__c : '';
        
        acc.formTwo = fc2;
        
        Form_C_Level_3_Email fc3 = new Form_C_Level_3_Email();
        fc3.Form_C_Level_3_Email_1 = String.isNotBlank(awp.Form_C_Level_3_Email_1__c) ? awp.Form_C_Level_3_Email_1__c : '';
        fc3.Form_C_Level_3_Email_2 = String.isNotBlank(awp.Form_C_Level_3_Email_2__c) ? awp.Form_C_Level_3_Email_2__c : '';
        fc3.Form_C_Level_3_Email_3 = String.isNotBlank(awp.Form_C_Level_3_Email_3__c) ? awp.Form_C_Level_3_Email_3__c : '';
        fc3.Form_C_Level_3_Email_4 = String.isNotBlank(awp.Form_C_Level_3_Email_4__c) ? awp.Form_C_Level_3_Email_4__c : '';
        fc3.Form_C_Level_3_Email_5 = String.isNotBlank(awp.Form_C_Level_3_Email_5__c) ? awp.Form_C_Level_3_Email_5__c : '';
        
        acc.formThree = fc3;
        
        olmEmail olm = new olmEmail();
        olm.OLM_Email_1 = String.isNotBlank(awp.OLM_Email_1__c) ? awp.OLM_Email_1__c : '';
        olm.OLM_Email_2 = String.isNotBlank(awp.OLM_Email_2__c) ? awp.OLM_Email_2__c : '';
        olm.OLM_Email_3 = String.isNotBlank(awp.OLM_Email_3__c) ? awp.OLM_Email_3__c : '';
        olm.OLM_Email_4 = String.isNotBlank(awp.OLM_Email_4__c) ? awp.OLM_Email_4__c : '';
        olm.OLM_Email_5 = String.isNotBlank(awp.OLM_Email_5__c) ? awp.OLM_Email_5__c : '';
        olm.OLM_Email_6 = String.isNotBlank(awp.OLM_Email_6__c) ? awp.OLM_Email_6__c : '';
        olm.OLM_Email_7 = String.isNotBlank(awp.OLM_Email_7__c) ? awp.OLM_Email_7__c : '';
        olm.OLM_Email_8 = String.isNotBlank(awp.OLM_Email_8__c) ? awp.OLM_Email_8__c : '';
        olm.OLM_Email_9 = String.isNotBlank(awp.OLM_Email_9__c) ? awp.OLM_Email_9__c : '';
        olm.OLM_Email_10 = String.isNotBlank(awp.OLM_Email_10__c) ? awp.OLM_Email_10__c : '';
        olm.OLM_Email_11 = String.isNotBlank(awp.OLM_Email_11__c) ? awp.OLM_Email_11__c : '';
        olm.OLM_Email_12 = String.isNotBlank(awp.OLM_Email_12__c) ? awp.OLM_Email_12__c : '';
        olm.OLM_Email_13 = String.isNotBlank(awp.OLM_Email_13__c) ? awp.OLM_Email_13__c : '';
        olm.OLM_Email_14 = String.isNotBlank(awp.OLM_Email_14__c) ? awp.OLM_Email_14__c : '';
        olm.OLM_Email_15 = String.isNotBlank(awp.OLM_Email_15__c) ? awp.OLM_Email_15__c : '';
        olm.OLM_Email_16 = String.isNotBlank(awp.OLM_Email_16__c) ? awp.OLM_Email_16__c : '';
        olm.OLM_Email_17 = String.isNotBlank(awp.OLM_Email_17__c) ? awp.OLM_Email_17__c : '';
        olm.OLM_Email_18 = String.isNotBlank(awp.OLM_Email_18__c) ? awp.OLM_Email_18__c : '';
        olm.OLM_Email_19 = String.isNotBlank(awp.OLM_Email_19__c) ? awp.OLM_Email_19__c : '';
        olm.OLM_Email_20 = String.isNotBlank(awp.OLM_Email_20__c) ? awp.OLM_Email_20__c : '';
        olm.OLM_Email_21 = String.isNotBlank(awp.OLM_Email_21__c) ? awp.OLM_Email_21__c : '';
        olm.OLM_Email_22 = String.isNotBlank(awp.OLM_Email_22__c) ? awp.OLM_Email_22__c : '';
        olm.OLM_Email_23 = String.isNotBlank(awp.OLM_Email_23__c) ? awp.OLM_Email_23__c : '';
        olm.OLM_Email_24 = String.isNotBlank(awp.OLM_Email_24__c) ? awp.OLM_Email_24__c : '';
        olm.OLM_Email_25 = String.isNotBlank(awp.OLM_Email_25__c) ? awp.OLM_Email_25__c : '';
        olm.OLM_Email_26 = String.isNotBlank(awp.OLM_Email_26__c) ? awp.OLM_Email_26__c : '';
        olm.OLM_Email_27 = String.isNotBlank(awp.OLM_Email_27__c) ? awp.OLM_Email_27__c : '';
        olm.OLM_Email_28 = String.isNotBlank(awp.OLM_Email_28__c) ? awp.OLM_Email_28__c : '';
        olm.OLM_Email_29 = String.isNotBlank(awp.OLM_Email_29__c) ? awp.OLM_Email_29__c : '';
        olm.OLM_Email_30 = String.isNotBlank(awp.OLM_Email_30__c) ? awp.OLM_Email_30__c : '';
        olm.OLM_Email_31 = String.isNotBlank(awp.OLM_Email_31__c) ? awp.OLM_Email_31__c : '';
        olm.OLM_Email_32 = String.isNotBlank(awp.OLM_Email_32__c) ? awp.OLM_Email_32__c : '';
        olm.OLM_Email_33 = String.isNotBlank(awp.OLM_Email_33__c) ? awp.OLM_Email_33__c : '';
        
        olm.OLM_Email_34 = String.isNotBlank(awp.OLM_Email_34__c) ? awp.OLM_Email_34__c : '';
        olm.OLM_Email_35 = String.isNotBlank(awp.OLM_Email_35__c) ? awp.OLM_Email_35__c : '';
        olm.OLM_Email_36 = String.isNotBlank(awp.OLM_Email_36__c) ? awp.OLM_Email_36__c : '';
        olm.OLM_Email_37 = String.isNotBlank(awp.OLM_Email_37__c) ? awp.OLM_Email_37__c : '';
        olm.OLM_Email_38 = String.isNotBlank(awp.OLM_Email_38__c) ? awp.OLM_Email_38__c : '';
        olm.OLM_Email_39 = String.isNotBlank(awp.OLM_Email_39__c) ? awp.OLM_Email_39__c : '';
        olm.OLM_Email_40 = String.isNotBlank(awp.OLM_Email_40__c) ? awp.OLM_Email_40__c : '';
        
        acc.olmEmail = olm;
        
         //sendOTPEmail(awp.Nodal_Officer_Email__c,Otp);
        //sendOTPEmail('rishikesh.Korade@finessedirect.com',otp);
        return JSON.serialize(acc);
    }
    
    @AuraEnabled
    public static map<string,string>  upadteAccount(string json , string accountId){
        if(accountId == null){
            accountId='001Bi00000CgquXIAR';
        }
        map<string,string> resultMap = new map<string,string>();
        AWPJSON awp = parseAWP(json);
        Dispute_Email dm = new Dispute_Email();
        dm = awp.dispute;
        DQR_DQI_Email dqr = new DQR_DQI_Email();
        dqr = awp.dqr;
        Form_C_Level_1_Email fc1 = new Form_C_Level_1_Email();
        fc1 = awp.formOne;
        Form_C_Level_2_Email fc2 = new Form_C_Level_2_Email();
        fc2 = awp.formTwo;
        Form_C_Level_3_Email fc3 = new Form_C_Level_3_Email();
        fc3 = awp.formThree;
        
        olmEmail olm = new olmEmail();
        olm =  awp.olmEmail;
        
        try{
            Account acc = new Account();
            acc.Id =accountId;
            acc.Grievances_Nodal_Officer_Name__c = awp.Grievances_Nodal_Officer_Name;
            acc.Grievances_Nodal_Officer_Phone__c = awp.Grievances_Nodal_Officer_Phone;
            acc.Grievances_Nodal_Officer_Email__c = awp.Grievances_Nodal_Officer_EmaiL;
            acc.Technology_Contact_Email__c = awp.Technology_Contact_Email;
            acc.Technology_Contact_Name__c = awp.Technology_Contact_Name;
            acc.Technology_Contact_Phone__c = awp.Technology_Contact_Phone;
            acc.Person_Name_Dispute__c = awp.Person_Name_Dispute;
            
            acc.Temp_Nodal_Officer_Name__c = awp.Nodal_Officer_Name;
            acc.Temp_Nodal_Officer_Phone__c = awp.Nodal_Officer_Phone;
            acc.Temp_Nodal_Officer_Email__c = awp.Nodal_Officer_Email;
            acc.Temp_Authorized_Signatory_Email__c = awp.Auth_Contact_Email;
            acc.Temp_Authorized_Signatory_Name__c = awp.Auth_Contact_Name;
            acc.Temp_Authorized_Signatory_Phone__c = awp.Auth_Contact_Phone;
            
            
            acc.Billing_Contact_Email__c = awp.Billing_Contact_Email;
        acc.Billing_Contact_Name__c = awp.Billing_Contact_Name;
        acc.Billing_Contact_Phone__c = awp.Billing_Contact_Phone;
            
            
            
            
            acc.Person_Name_2__c = awp.Person_Name_2;
            acc.Person_Name_3__c = awp.Person_Name_3;
            acc.Person_Name_4__c = awp.Person_Name_4;
            acc.Person_Name_5__c = awp.Person_Name_5;
            acc.Person_Name_6__c = awp.Person_Name_6;
            acc.Person_Name_7__c = awp.Person_Name_7;
            acc.Person_Name_8__c = awp.Person_Name_8;
            acc.Person_Name_9__c = awp.Person_Name_9;
            acc.Person_Name_10__c = awp.Person_Name_10;
            acc.Email_1_Dispute__c = awp.Email_1_Dispute;
            acc.Email_2_Dispute__c = awp.Email_2_Dispute;
            acc.Email_3_Dispute__c = awp.Email_3_Dispute;
            acc.Email_4_Dispute__c = awp.Email_4_Dispute;
            acc.Email_5_Dispute__c = awp.Email_5_Dispute;
            acc.Email_6_Dispute__c = awp.Email_6_Dispute;
            acc.Email_7_Dispute__c = awp.Email_7_Dispute;
            acc.Email_8_Dispute__c = awp.Email_8_Dispute;
            acc.Email_9_Dispute__c = awp.Email_9_Dispute;
            acc.Email_10_Dispute__c = awp.Email_10_Dispute;
            acc.Phone_1__c = awp.Phone_1;
            acc.Phone_2__c = awp.Phone_2;
            acc.Phone_3__c = awp.Phone_3;
            acc.Phone_4__c = awp.Phone_4;
            acc.Phone_5__c= awp.Phone_5;
            acc.Phone_6__c = awp.Phone_6;
            acc.Phone_7__c= awp.Phone_7;
            acc.Phone_8__c = awp.Phone_8;
            acc.Phone_9__c = awp.Phone_9;
            acc.Phone_10__c = awp.Phone_10;
            acc.Change_Dispute_Detail_1__c = awp.perseon_pB1;
            acc.Change_Dispute_Detail_2__c = awp.perseon_pB2;
            acc.Change_Dispute_Detail_3__c = awp.perseon_pB3;
            acc.Change_Dispute_Detail_4__c = awp.perseon_pB4;
            acc.Change_Dispute_Detail_5__c = awp.perseon_pB5;
            acc.Change_Dispute_Detail_6__c = awp.perseon_pB6;
            acc.Change_Dispute_Detail_7__c = awp.perseon_pB7;
            acc.Change_Dispute_Detail_8__c = awp.perseon_pB8;
            acc.Change_Dispute_Detail_9__c = awp.perseon_pB9;
            acc.Change_Dispute_Detail_10__c = awp.perseon_pB10;
            
            
            
            // Check if the dqr fields are not blank, and assign them to the acc fields
            acc.DQR_DQI_Email_1__c = String.isNotBlank(dqr.DQR_DQI_Email_1) ? dqr.DQR_DQI_Email_1 : '';
            acc.DQR_DQI_Email_2__c = String.isNotBlank(dqr.DQR_DQI_Email_2) ? dqr.DQR_DQI_Email_2 : '';
            acc.DQR_DQI_Email_3__c = String.isNotBlank(dqr.DQR_DQI_Email_3) ? dqr.DQR_DQI_Email_3 : '';
            acc.DQR_DQI_Email_4__c = String.isNotBlank(dqr.DQR_DQI_Email_4) ? dqr.DQR_DQI_Email_4 : '';
            acc.DQR_DQI_Email_5__c = String.isNotBlank(dqr.DQR_DQI_Email_5) ? dqr.DQR_DQI_Email_5 : '';
            
            acc.DQR_DQI_Email_6__c = String.isNotBlank(dqr.DQR_DQI_Email_6) ? dqr.DQR_DQI_Email_6 : '';
            system.debug('DQR_DQI_Email_7-->'+dqr.DQR_DQI_Email_7);
            acc.DQR_DQI_Email_7__c = String.isNotBlank(dqr.DQR_DQI_Email_7) ? dqr.DQR_DQI_Email_7 : '';
            acc.DQR_DQI_Email_8__c = String.isNotBlank(dqr.DQR_DQI_Email_8) ? dqr.DQR_DQI_Email_8 : '';
            acc.DQR_DQI_Email_9__c = String.isNotBlank(dqr.DQR_DQI_Email_9) ? dqr.DQR_DQI_Email_9 : '';
            acc.DQR_DQI_Email_10__c = String.isNotBlank(dqr.DQR_DQI_Email_10) ? dqr.DQR_DQI_Email_10 : '';
            acc.DQR_DQI_Email_11__c = String.isNotBlank(dqr.DQR_DQI_Email_11) ? dqr.DQR_DQI_Email_11 : '';
            acc.DQR_DQI_Email_12__c = String.isNotBlank(dqr.DQR_DQI_Email_12) ? dqr.DQR_DQI_Email_12 : '';
            acc.DQR_DQI_Email_13__c = String.isNotBlank(dqr.DQR_DQI_Email_13) ? dqr.DQR_DQI_Email_13 : '';
            acc.DQR_DQI_Email_14__c = String.isNotBlank(dqr.DQR_DQI_Email_14) ? dqr.DQR_DQI_Email_14 : '';
            acc.DQR_DQI_Email_15__c = String.isNotBlank(dqr.DQR_DQI_Email_15) ? dqr.DQR_DQI_Email_15 : '';
            acc.DQR_DQI_Email_16__c = String.isNotBlank(dqr.DQR_DQI_Email_16) ? dqr.DQR_DQI_Email_16 : '';
            acc.DQR_DQI_Email_17__c = String.isNotBlank(dqr.DQR_DQI_Email_17) ? dqr.DQR_DQI_Email_17 : '';
            acc.DQR_DQI_Email_18__c = String.isNotBlank(dqr.DQR_DQI_Email_18) ? dqr.DQR_DQI_Email_18 : '';
            acc.DQR_DQI_Email_19__c = String.isNotBlank(dqr.DQR_DQI_Email_19) ? dqr.DQR_DQI_Email_19 : '';
            acc.DQR_DQI_Email_20__c = String.isNotBlank(dqr.DQR_DQI_Email_20) ? dqr.DQR_DQI_Email_20 : '';
            acc.DQR_DQI_Email_21__c = String.isNotBlank(dqr.DQR_DQI_Email_21) ? dqr.DQR_DQI_Email_21 : '';
            acc.DQR_DQI_Email_22__c = String.isNotBlank(dqr.DQR_DQI_Email_22) ? dqr.DQR_DQI_Email_22 : '';
            acc.DQR_DQI_Email_23__c = String.isNotBlank(dqr.DQR_DQI_Email_23) ? dqr.DQR_DQI_Email_23: '';
            acc.DQR_DQI_Email_24__c = String.isNotBlank(dqr.DQR_DQI_Email_24) ? dqr.DQR_DQI_Email_24 : '';
            acc.DQR_DQI_Email_25__c = String.isNotBlank(dqr.DQR_DQI_Email_25) ? dqr.DQR_DQI_Email_25 : '';
            
            
            acc.Dispute_Email_1__c = String.isNotBlank(dm.Dispute_Email_1) ? dm.Dispute_Email_1 : '';
            acc.Dispute_Email_2__c = String.isNotBlank(dm.Dispute_Email_2) ? dm.Dispute_Email_2 : '';
            acc.Dispute_Email_3__c = String.isNotBlank(dm.Dispute_Email_3) ? dm.Dispute_Email_3 : '';
            acc.Dispute_Email_4__c = String.isNotBlank(dm.Dispute_Email_4) ? dm.Dispute_Email_4 : '';
            acc.Dispute_Email_5__c = String.isNotBlank(dm.Dispute_Email_5) ? dm.Dispute_Email_5 : '';
            acc.Dispute_Email_6__c = String.isNotBlank(dm.Dispute_Email_6) ? dm.Dispute_Email_6 : '';
            system.debug('fc1.dm.Dispute_Email_7'+dm.Dispute_Email_7);
            
            acc.Dispute_Email_7__c = String.isNotBlank(dm.Dispute_Email_7) ? dm.Dispute_Email_7 : '';
            acc.Dispute_Email_8__c = String.isNotBlank(dm.Dispute_Email_8) ? dm.Dispute_Email_8 : '';
            acc.Dispute_Email_9__c = String.isNotBlank(dm.Dispute_Email_9) ? dm.Dispute_Email_9 : '';
            acc.Dispute_Email_10__c = String.isNotBlank(dm.Dispute_Email_10) ? dm.Dispute_Email_10 : '';
            acc.Dispute_Email_11__c = String.isNotBlank(dm.Dispute_Email_11) ? dm.Dispute_Email_11 : '';
            acc.Dispute_Email_12__c = String.isNotBlank(dm.Dispute_Email_12) ? dm.Dispute_Email_12 : '';
            acc.Dispute_Email_13__c = String.isNotBlank(dm.Dispute_Email_13) ? dm.Dispute_Email_13 : '';
            acc.Dispute_Email_14__c = String.isNotBlank(dm.Dispute_Email_14) ? dm.Dispute_Email_14 : '';
            acc.Dispute_Email_15__c = String.isNotBlank(dm.Dispute_Email_15) ? dm.Dispute_Email_15 : '';
            
            
            acc.Form_C_Level_1_Email_1__c = String.isNotBlank(fc1.Form_C_Level_Email_1) ? fc1.Form_C_Level_Email_1 : '';
            acc.Form_C_Level_1_Email_2__c = String.isNotBlank(fc1.Form_C_Level_Email_2) ? fc1.Form_C_Level_Email_2 : '';
            acc.Form_C_Level_1_Email_3__c = String.isNotBlank(fc1.Form_C_Level_Email_3) ? fc1.Form_C_Level_Email_3 : '';
            acc.Form_C_Level_1_Email_4__c = String.isNotBlank(fc1.Form_C_Level_Email_4) ? fc1.Form_C_Level_Email_4 : '';
            acc.Form_C_Level_1_Email_5__c = String.isNotBlank(fc1.Form_C_Level_Email_5) ? fc1.Form_C_Level_Email_5 : '';
            acc.Form_C_Level_1_Email_6__c = String.isNotBlank(fc1.Form_C_Level_Email_6) ? fc1.Form_C_Level_Email_6 : '';
            system.debug('fc1.Form_C_Level_Email_7'+fc1.Form_C_Level_Email_7);
            acc.Form_C_Level_1_Email_7__c = String.isNotBlank(fc1.Form_C_Level_Email_7) ? fc1.Form_C_Level_Email_7 : '';
            acc.Form_C_Level_1_Email_8__c = String.isNotBlank(fc1.Form_C_Level_Email_8) ? fc1.Form_C_Level_Email_8 : '';
            acc.Form_C_Level_1_Email_9__c = String.isNotBlank(fc1.Form_C_Level_Email_9) ? fc1.Form_C_Level_Email_9 : '';
            
            acc.Form_C_Level_1_Email_10__c = String.isNotBlank(fc1.Form_C_Level_Email_10) ? fc1.Form_C_Level_Email_10 : '';
            acc.Form_C_Level_1_Email_11__c = String.isNotBlank(fc1.Form_C_Level_Email_11) ? fc1.Form_C_Level_Email_11 : '';
            acc.Form_C_Level_1_Email_12__c = String.isNotBlank(fc1.Form_C_Level_Email_12) ? fc1.Form_C_Level_Email_12 : '';
            acc.Form_C_Level_1_Email_13__c = String.isNotBlank(fc1.Form_C_Level_Email_13) ? fc1.Form_C_Level_Email_13 : '';
            acc.Form_C_Level_1_Email_14__c = String.isNotBlank(fc1.Form_C_Level_Email_14) ? fc1.Form_C_Level_Email_14 : '';
            acc.Form_C_Level_1_Email_15__c = String.isNotBlank(fc1.Form_C_Level_Email_15) ? fc1.Form_C_Level_Email_15 : '';
            //acc.Form_C_Level_1_Email_16_del__c = String.isNotBlank(fc1.Form_C_Level_Email_16) ? fc1.Form_C_Level_Email_16 : '';
            
            
            acc.Form_C_Level_2_Email_1__c = String.isNotBlank(fc2.Form_C_Level_2_Email_1) ? fc2.Form_C_Level_2_Email_1 : '';
            acc.Form_C_Level_2_Email_2__c = String.isNotBlank(fc2.Form_C_Level_2_Email_2) ? fc2.Form_C_Level_2_Email_2 : '';
            acc.Form_C_Level_2_Email_3__c = String.isNotBlank(fc2.Form_C_Level_2_Email_3) ? fc2.Form_C_Level_2_Email_3 : '';
            acc.Form_C_Level_2_Email_4__c = String.isNotBlank(fc2.Form_C_Level_2_Email_4) ? fc2.Form_C_Level_2_Email_4 : '';
            acc.Form_C_Level_2_Email_5__c = String.isNotBlank(fc2.Form_C_Level_2_Email_5) ? fc2.Form_C_Level_2_Email_5 : '';
            
            system.debug('fc1.Form_C_Level_3_Email_1__c'+fc3.Form_C_Level_3_Email_1);
            
            acc.Form_C_Level_3_Email_1__c = String.isNotBlank(fc3.Form_C_Level_3_Email_1) ? fc3.Form_C_Level_3_Email_1 : '';
            acc.Form_C_Level_3_Email_2__c = String.isNotBlank(fc3.Form_C_Level_3_Email_2) ? fc3.Form_C_Level_3_Email_2 : '';
            acc.Form_C_Level_3_Email_3__c = String.isNotBlank(fc3.Form_C_Level_3_Email_3) ? fc3.Form_C_Level_3_Email_3 : '';
            acc.Form_C_Level_3_Email_4__c = String.isNotBlank(fc3.Form_C_Level_3_Email_4) ? fc3.Form_C_Level_3_Email_4 : '';
            acc.Form_C_Level_3_Email_5__c = String.isNotBlank(fc3.Form_C_Level_3_Email_5) ? fc3.Form_C_Level_3_Email_5 : '';
            
            acc.OLM_Email_1__c = String.isNotBlank(olm.OLM_Email_1) ? olm.OLM_Email_1 : '';
            acc.OLM_Email_2__c = String.isNotBlank(olm.OLM_Email_2) ? olm.OLM_Email_2 : '';
            acc.OLM_Email_3__c = String.isNotBlank(olm.OLM_Email_3) ? olm.OLM_Email_3 : '';
            acc.OLM_Email_4__c = String.isNotBlank(olm.OLM_Email_4) ? olm.OLM_Email_4 : '';
            acc.OLM_Email_5__c = String.isNotBlank(olm.OLM_Email_5) ? olm.OLM_Email_5 : '';
            acc.OLM_Email_6__c = String.isNotBlank(olm.OLM_Email_6) ? olm.OLM_Email_6 : '';
            acc.OLM_Email_7__c = String.isNotBlank(olm.OLM_Email_7) ? olm.OLM_Email_7 : '';
            acc.OLM_Email_8__c = String.isNotBlank(olm.OLM_Email_8) ? olm.OLM_Email_8 : '';
            acc.OLM_Email_9__c = String.isNotBlank(olm.OLM_Email_9) ? olm.OLM_Email_9 : '';
            acc.OLM_Email_10__c = String.isNotBlank(olm.OLM_Email_10) ? olm.OLM_Email_10 : '';
            acc.OLM_Email_11__c= String.isNotBlank(olm.OLM_Email_11) ? olm.OLM_Email_11 : '';
            acc.OLM_Email_12__c = String.isNotBlank(olm.OLM_Email_12) ? olm.OLM_Email_12 : '';
            acc.OLM_Email_13__c = String.isNotBlank(olm.OLM_Email_13) ? olm.OLM_Email_13 : '';
            acc.OLM_Email_14__c = String.isNotBlank(olm.OLM_Email_14) ? olm.OLM_Email_14 : '';
            acc.OLM_Email_15__c = String.isNotBlank(olm.OLM_Email_15) ? olm.OLM_Email_15 : '';
            acc.OLM_Email_16__c = String.isNotBlank(olm.OLM_Email_16) ? olm.OLM_Email_16 : '';
            acc.OLM_Email_17__c = String.isNotBlank(olm.OLM_Email_17) ? olm.OLM_Email_17 : '';
            acc.OLM_Email_18__c = String.isNotBlank(olm.OLM_Email_18) ? olm.OLM_Email_18 : '';
            acc.OLM_Email_19__c = String.isNotBlank(olm.OLM_Email_19) ? olm.OLM_Email_19 : '';
            acc.OLM_Email_20__c = String.isNotBlank(olm.OLM_Email_20) ? olm.OLM_Email_20 : '';
            acc.OLM_Email_21__c = String.isNotBlank(olm.OLM_Email_21) ? olm.OLM_Email_21 : '';
            acc.OLM_Email_22__c = String.isNotBlank(olm.OLM_Email_22) ? olm.OLM_Email_22 : '';
            acc.OLM_Email_23__c = String.isNotBlank(olm.OLM_Email_23) ? olm.OLM_Email_23 : '';
            acc.OLM_Email_24__c = String.isNotBlank(olm.OLM_Email_24) ? olm.OLM_Email_24 : '';
            acc.OLM_Email_25__c = String.isNotBlank(olm.OLM_Email_25) ? olm.OLM_Email_25 : '';
            acc.OLM_Email_26__c = String.isNotBlank(olm.OLM_Email_26) ? olm.OLM_Email_26 : '';
            acc.OLM_Email_27__c = String.isNotBlank(olm.OLM_Email_27) ? olm.OLM_Email_27 : '';
            acc.OLM_Email_28__c = String.isNotBlank(olm.OLM_Email_28) ? olm.OLM_Email_28 : '';
            acc.OLM_Email_29__c = String.isNotBlank(olm.OLM_Email_29) ? olm.OLM_Email_29 : '';
            acc.OLM_Email_30__c = String.isNotBlank(olm.OLM_Email_30) ? olm.OLM_Email_30 : '';
            acc.OLM_Email_31__c = String.isNotBlank(olm.OLM_Email_31) ? olm.OLM_Email_31 : '';
            acc.OLM_Email_32__c = String.isNotBlank(olm.OLM_Email_32) ? olm.OLM_Email_32 : '';
            acc.OLM_Email_33__c = String.isNotBlank(olm.OLM_Email_33) ? olm.OLM_Email_33 : '';
            
            acc.OLM_Email_34__c = String.isNotBlank(olm.OLM_Email_34) ? olm.OLM_Email_34 : '';
            acc.OLM_Email_35__c = String.isNotBlank(olm.OLM_Email_35) ? olm.OLM_Email_35 : '';
            acc.OLM_Email_36__c = String.isNotBlank(olm.OLM_Email_36) ? olm.OLM_Email_36 : '';
            acc.OLM_Email_37__c = String.isNotBlank(olm.OLM_Email_37) ? olm.OLM_Email_37 : '';
            acc.OLM_Email_38__c = String.isNotBlank(olm.OLM_Email_38) ? olm.OLM_Email_38 : '';
            acc.OLM_Email_39__c = String.isNotBlank(olm.OLM_Email_39) ? olm.OLM_Email_39 : '';
            acc.OLM_Email_40__c = String.isNotBlank(olm.OLM_Email_40) ? olm.OLM_Email_40 : '';
            
            
            update acc;
            resultMap.put('Success','Detail Updated Sucessfully');
            return resultMap;
            
        }catch(exception e){
            resultMap.put('Error',e.getMessage());
            system.debug(e.getLineNumber()+' -- s'+resultMap);
            return resultMap;
            
            
        }
    } 
    
    public class AWPJSON {
        public string Id;
        public string Grievances_Nodal_Officer_Name;
        public string Grievances_Nodal_Officer_Email  ;
        public string Grievances_Nodal_Officer_Phone ;
        public string Technology_Contact_Name  ;
        public string Technology_Contact_Email ;
        public string Technology_Contact_Phone ;
        
        
        public string Nodal_Officer_Name;
        public string Nodal_Officer_Email  ;
        public string Nodal_Officer_Phone ;
        public string Auth_Contact_Name  ;
        public string Auth_Contact_Email ;
        public string Auth_Contact_Phone ;
        
        public string Billing_Contact_Email  ;
        public string Billing_Contact_Name ;
        public string Billing_Contact_Phone ;
        
        
        
        public string  Person_Name_Dispute  ;
        public string  Person_Name_2 ;
        public string Person_Name_3  ;
        public string Person_Name_4;
        public string Person_Name_5 ;
        public string Person_Name_6  ;
        public string Person_Name_7 ;
        public string Person_Name_8  ;
        public string Person_Name_9 ;
        public string Person_Name_10  ;
        
        public string  Email_1_Dispute  ;
        public string  Email_2_Dispute ;
        public string  Email_3_Dispute ;
        public string  Email_4_Dispute ;
        public string  Email_5_Dispute;
        public string Email_6_Dispute;
        public string Email_7_Dispute  ;
        public string Email_8_Dispute  ;
        public string Email_9_Dispute  ;
        public string Email_10_Dispute  ;
        
        
        public string Phone_1 ;
        public string  Phone_2 ;
        public string  Phone_3 ;
        public string  Phone_4;
        public string  Phone_5 ;
        public string  Phone_6  ;
        public string  Phone_7 ;
        public string  Phone_8  ;
        public string Phone_9 ;
        public string Phone_10;
        
        public boolean perseon_pB1 ;
        public boolean  perseon_pB2 ;
        public boolean  perseon_pB3 ;
        public boolean  perseon_pB4;
        public boolean  perseon_pB5 ;
        public boolean  perseon_pB6  ;
        public boolean  perseon_pB7 ;
        public boolean  perseon_pB8  ;
        public boolean perseon_pB9;
        public boolean perseon_pB10;
        
        public boolean perseon_pB1_disabled ;
        public boolean perseon_pB2_disabled ;
        public boolean perseon_pB3_disabled ;
        public boolean perseon_pB4_disabled ;
        public boolean perseon_pB5_disabled ;
        public boolean perseon_pB6_disabled ;
        public boolean perseon_pB7_disabled ;
        public boolean perseon_pB8_disabled ;
        public boolean perseon_pB9_disabled ;
        public boolean perseon_pB10_disabled ;
        
        
        
        
        public boolean inp_disabled_1 ;
        public boolean inp_disabled_2 ;
        public boolean inp_disabled_3 ;
        public boolean inp_disabled_4;
        public boolean inp_disabled_5 ;
        public boolean inp_disabled_6  ;
        public boolean inp_disabled_7 ;
        public boolean inp_disabled_8  ;
        public boolean inp_disabled_9;
        public boolean inp_disabled_10;
        
        
        public DQR_DQI_Email dqr;
        public Dispute_Email dispute;
        public Form_C_Level_1_Email formOne;
        public Form_C_Level_2_Email formTwo;
        public Form_C_Level_3_Email formThree;
        public olmEmail olmEmail;
    }
    
    public class olmEmail {
        // Define the Account record field and email fields directly
        public Account account;  // The Account record
        public String OLM_Email_1;
        public String OLM_Email_2;
        public String OLM_Email_3;
        public String OLM_Email_4;
        public String OLM_Email_5;
        public String OLM_Email_6;
        public String OLM_Email_7;
        public String OLM_Email_8;
        public String OLM_Email_9;
        public String OLM_Email_10;
        public String OLM_Email_11;
        public String OLM_Email_12;
        public String OLM_Email_13;
        public String OLM_Email_14;
        public String OLM_Email_15;
        public String OLM_Email_16;
        public String OLM_Email_17;
        public String OLM_Email_18;
        public String OLM_Email_19;
        public String OLM_Email_20;
        public String OLM_Email_21;
        public String OLM_Email_22;
        public String OLM_Email_23;
        public String OLM_Email_24;
        public String OLM_Email_25;
        public String OLM_Email_26;
        public String OLM_Email_27;
        public String OLM_Email_28;
        public String OLM_Email_29;
        public String OLM_Email_30;
        public String OLM_Email_31;
        public String OLM_Email_32;
        public String OLM_Email_33;
        public String OLM_Email_34;
        public String OLM_Email_35;
        public String OLM_Email_36;
        public String OLM_Email_37;
        public String OLM_Email_38;
        public String OLM_Email_39;
        public String OLM_Email_40;
    }
    
    public class DQR_DQI_Email {
        public string DQR_DQI_Email_1;
        public string DQR_DQI_Email_2;
        public string DQR_DQI_Email_3;
        public string DQR_DQI_Email_4;
        public string DQR_DQI_Email_5;
        public string DQR_DQI_Email_6;
        public string DQR_DQI_Email_7;
        public string DQR_DQI_Email_8;
        public string DQR_DQI_Email_9;
        public string DQR_DQI_Email_10;
        
        
        public string DQR_DQI_Email_11;
        public string DQR_DQI_Email_12;
        public string DQR_DQI_Email_13;
        public string DQR_DQI_Email_14;
        public string DQR_DQI_Email_15;
        public string DQR_DQI_Email_16;
        public string DQR_DQI_Email_17;
        public string DQR_DQI_Email_18;
        public string DQR_DQI_Email_19;
        public string DQR_DQI_Email_20;
        
        public string DQR_DQI_Email_21;
        public string DQR_DQI_Email_22;
        public string DQR_DQI_Email_23;
        public string DQR_DQI_Email_24;
        public string DQR_DQI_Email_25;
    }
    
    public class Dispute_Email {
        public string Dispute_Email_1;
        public string Dispute_Email_2;
        public string Dispute_Email_3;
        public string Dispute_Email_4;
        public string Dispute_Email_5;
        public string Dispute_Email_6;
        public string Dispute_Email_7;
        public string Dispute_Email_8;
        public string Dispute_Email_9;
        public string Dispute_Email_10;
        
        
        public string Dispute_Email_11;
        public string Dispute_Email_12;
        public string Dispute_Email_13;
        public string Dispute_Email_14;
        public string Dispute_Email_15;
        
    }
    
    public class Form_C_Level_1_Email {
        public string Form_C_Level_Email_1;
        public string Form_C_Level_Email_2;
        public string Form_C_Level_Email_3;
        public string Form_C_Level_Email_4;
        public string Form_C_Level_Email_5;
        public string Form_C_Level_Email_6;
        public string Form_C_Level_Email_7;
        public string Form_C_Level_Email_8;
        public string Form_C_Level_Email_9;
        public string Form_C_Level_Email_10;
        
        
        public string Form_C_Level_Email_11;
        public string Form_C_Level_Email_12;
        public string Form_C_Level_Email_13;
        public string Form_C_Level_Email_14;
        public string Form_C_Level_Email_15;
        public string Form_C_Level_Email_16;
    }
    
    public class Form_C_Level_2_Email {
        public string Form_C_Level_2_Email_1;
        public string Form_C_Level_2_Email_2;
        public string Form_C_Level_2_Email_3;
        public string Form_C_Level_2_Email_4;
        public string Form_C_Level_2_Email_5;
    }
    
    public class Form_C_Level_3_Email {
        public string Form_C_Level_3_Email_1;
        public string Form_C_Level_3_Email_2;
        public string Form_C_Level_3_Email_3;
        public string Form_C_Level_3_Email_4;
        public string Form_C_Level_3_Email_5;
    }
    
    public static AWPJSON parseAWP(String json) {
        return (AWPJSON) System.JSON.deserialize(json, AWPJSON.class);
    }
}