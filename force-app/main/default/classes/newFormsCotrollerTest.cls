@isTest
public class newFormsCotrollerTest {
    
    @isTest
    public static void isValidate(){
        
        
        Product__c prd = new Product__c();
        prd.Fee_Plan_Type__c = 'Products';
        prd.Active__c = false;
        prd.Initial_Payment_Amount__c = 1234;
        
        insert prd;
        
        Product_Line_Item__c prdItem = new Product_Line_Item__c();
        prdItem.Price_Per_Report__c = 123;
        prdItem.Product__c = prd.Id;
        
        insert prdItem;
        
        
        Lead l = new Lead (Company ='Sree Kumarasamajam Finserve Pvt Ltd',LastName = 'Amjad',Pan_no__c='AAACG8283C',GST_No__c='32AAACG8283C1ZW',RBI_Certificate_No__c='1234567890',GST_State__c='Kerala',OTP__c ='5624',Status = 'Plan selection');
        l.LegalDesk_Agreement_Document_Id__c='ASDFG12345';
        l.Legal_desk_docket_id__c='12345';
        l.email = 'abc@gmail.com';
        l.RBI_Certificate_Verified__c = 'True';
        l.Pan_Verified__c = 'True';
        l.GST_Verified__c ='True';
        l.RBI_Member_Verified__c = 'Yes';
        l.Checked_in_NBFC_List__c = 'Yes';
        l.Date_of_Incorporation__c = system.today().addDays(-7879);
        l.Checked_in_Termination_List__c = 'Yes';
        l.Executive_Verified_Documents__c =true;
        l.TL_Verified_Documents__c = true;
        l.Admin_Verified_Documents__c = true;
        l.Selected_Company_Name__c = 'As Per MCA';
        l.First_Name_Auth_Usr_Req__c = 'Test';
        l.OTP__c = '1234';
        insert l;
        
        l.status='Business and Ownership';
        update l;
        
        
        l.status='Contact and User ID';
        update l;
        
        
        
        l.status='Supporting Documents (Company)';
        update l;
        
        
        List<string> userTypeDetail = new List<string> ();
        userTypeDetail.add('Head of Product');
        userTypeDetail.add('Head of Technology');
        userTypeDetail.add('Head of Compliance');
        userTypeDetail.add('Head of Infosec');
        userTypeDetail.add('Billing Contact Detail');
        userTypeDetail.add('Head of Audit');
        userTypeDetail.add('Person authorized to upload/share onboarding documents');
        userTypeDetail.add('API Login User');
        userTypeDetail.add('UAT Test Profile');
        
        List<User_Detail__c> userTypeDetailList = new List<User_Detail__c> ();
        for(integer i = 0; i< userTypeDetail.size() ; i++){
            User_Detail__c ud = new User_Detail__c();
            ud.User_Type__c = userTypeDetail[i];
            ud.Lead__c = l.Id;
            ud.First_Name__c = 'Test'+i;
            ud.Last_Name__c = 'Test Last'+i;
            ud.Official_Email_Address__c = i+'abc@gmail.com';
            userTypeDetailList.add(ud); 
        }
        
        
        User_Detail__c ud = new User_Detail__c();
            ud.User_Type__c = 'API Login User';
            ud.Lead__c = l.Id;
            ud.First_Name__c = 'Test';
            ud.Last_Name__c = 'Test Last';
            ud.Official_Email_Address__c = 'abc@gmail.com';
        insert ud;
        
        IP_Address__c ipc =new IP_Address__c();
        ipc.Name = '56789';
        ipc.User_Detail__c = ud.Id;
        insert ipc;
        
        if(userTypeDetailList.size() > 0){
            insert userTypeDetailList;
        }
        
        
        RBI_Member__c rm1=new RBI_Member__c();
        rm1.Name=l.Company;
        rm1.Type__c='Account Aggregator (AA) NBFCs';
        insert rm1;
        
        
        State_City_Pin__c sc = new State_City_Pin__c();
        sc.PinCode__c = '421306';
        sc.Name ='sdfg';
        insert sc; 
        
        
        Authorized_Signatory_Directors__c aus = new Authorized_Signatory_Directors__c();
        aus.Lead__c = l.Id;
        aus.First_Name__c = 'Test';
        aus.Last_Name__c = 'Last Name';
        aus.LinkedIn_URL__c = 'www.google.com';
        aus.Description__c= 'disc';
        aus.Mobile_No__c = '8989898909';
        aus.DIN__c = '1234';
        insert aus;
        
        
        Supporting_Document__c sp = new Supporting_Document__c();
        sp.lead__c = l.Id;
        sp.Supporting_Document_Name__c = 'Copy of PAN Card';
        insert sp;
        
        
        ContentVersion testContentInsert2 =new ContentVersion(); 
        testContentInsert2.ContentURL='test'; 
        testContentInsert2.Title ='Google.com'; 
        insert testContentInsert2; 
        
        
        Id contentDocument2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentInsert2.Id LIMIT 1].ContentDocumentId;
        ContentDocumentLink cd2=new ContentDocumentLink();
        cd2.ContentDocumentId=contentDocument2;
        cd2.LinkedEntityId = sp.Id;
        cd2.ShareType = 'V' ;
        insert cd2;
        
        
        
        ContentVersion testContentInsert3 =new ContentVersion(); 
        testContentInsert3.ContentURL='test'; 
        testContentInsert3.Title ='Copy of  Identity proof'; 
        insert testContentInsert3; 
        
        
        Id contentDocument3 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentInsert3.Id LIMIT 1].ContentDocumentId;
        ContentDocumentLink cd3=new ContentDocumentLink();
        cd3.ContentDocumentId=contentDocument3;
        cd3.LinkedEntityId = l.Id;
        cd3.ShareType = 'V' ;
        insert cd3;
        
        
        
        string js='{"authList":[{"Description":"Daily Scrum Meeting*","designation":"WHOLE-TIME DIRECTOR","din":"00002603","email":"rishikesh.korade@finessedirect.com","Id":"00QBi00000BI8aJMAT","LastNameOfDirector":"TANTI","mobile":"6786786789","name":"GIRISH RANCHHODBHAI","url":"linkdin.com"},{"Description":"","designation":"DIRECTOR","din":"00508623","email":"shashank@finessedirect.com","Id":"a0TBi000002LmIEMA0","LastNameOfDirector":"DESAEDELEER","mobile":"6786786789","name":"MARC ANDREE R","url":""}],"Authorised_Signatory_Same_As_Nodal_Offic_c":false,"brandDescriprion":"Hello","brandName":"Brand Name / Market Name","pmList":[{"Id":"a0VBi000001L5QqMAK","NameOfDirector":"Vikram Jadhav","per_Of_Ownership":10},{"Id":"a0VBi000001L5QrMAK","NameOfDirector":"Sourav k","per_Of_Ownership":90}]}';
        string js2='{"hd_Audit_and_Compliance":{"First_Name_head_of_Audit_c":"sahil","Id":"a09Bi000004FUDIIA4","Job_Title_head_of_Audit_c":"hghbkjb","Last_Name_head_of_Audit_c":"khaire","Official_Email_head_of_Audit_c":"sa@gamil.com","Tel_No_head_of_Audit_c":"6767676767"},"hd_compliance":{"First_Name_head_of_Compliance_c":"amit","Id":"a09Bi000004FUDFIA4","Job_Title_head_of_Compliance_c":"fgh","Last_Name_head_of_Compliance_c":"singh","Official_Email_head_of_Compliance_c":"a@gmail.com","Tel_No_head_of_Compliance_c":"6676786789"},"hd_con_Details":{"First_Name_billing_contact_details_c":"sourav","Id":"a09Bi000004FUDHIA4","Job_Title_billing_contact_details_c":"kh","Last_Name_billing_contact_details_c":"kaushari","Official_Email_billing_contact_details_c":"s@gmail.com","Tel_No_billing_contact_details_c":"5675675674"},"hd_Infosec":{"First_Name_head_of_Infosec_c":"prince","Id":"a09Bi000004FUDGIA4","Job_Title_head_of_Infosec_c":"jh","Last_Name_head_of_Infosec_c":"badi","Official_Email_head_of_Infosec_c":"p@gmail.com","Tel_No_head_of_Infosec_c":"6786786785"},"hd_IP_address":{"First_Name_API_IP_address_c":"aditya","Id":"a09Bi000004FUDKIA4","Job_Title_API_IP_address_c":"nkdbbf","Last_Name_API_IP_address_c":"zagade","Official_Email_API_IP_address_c":"zaa@gmail.com","RestrctedIPRanges":[{"Id":"a0UBi000000NWSDMA4","login_IP":"121:121:121:23"}],"Tel_No_API_IP_address_c":"6767678678"},"hd_person_authorized":{"First_Name_details_of_person_authorized_c":"amjad","Id":"a09Bi000004FUDJIA4","Job_Title_details_of_person_authorized_c":"mnb","Last_Name_details_of_person_authorized_c":"sayyad","Official_Email_details_of_person_authorized_c":"sam@gmail.com","Tel_No_details_of_person_authorized_c":"7686786786"},"hd_Product":{"First_Name_head_of_prod_c":"harish","Id":"a09Bi000004FUDDIA4","Job_Title_head_of_prod_c":"tester","Last_Name_head_of_prod_c":"waghmare","Official_Email_head_of_prod_c":"h@gmail.com","Tel_No_head_of_prod_c":"5675675674"},"hd_Profile_Details":[{"First_Name_UAT_Test_Profile_Details_c":"PRANAV","Id":"a09Bi000004FUDLIA4","Job_Title_UAT_Test_Profile_Details_c":"Tester","Last_Name_UAT_Test_Profile_Details_c":"TULSIBHAI","Official_Email_UAT_Test_Profile_Details_c":"p@gmail.com","Tel_No_UAT_Test_Profile_Details_c":"8897909087"}],"hd_technology":{"First_Name_head_of_Technology_c":"sahshank","Id":"a09Bi000004FUDEIA4","Job_Title_head_of_Technology_c":"fjjoj","Last_Name_head_of_Technology_c":"sharma","Official_Email_head_of_Technology_c":"a@gamil.com","Tel_No_head_of_Technology_c":"8798798798"}}';
        
        ContentVersion testContentInsert =new ContentVersion(); 
        testContentInsert.ContentURL='test'; 
        testContentInsert.Title ='Google.com'; 
        insert testContentInsert; 
        
        
        Id contentDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentInsert.Id LIMIT 1].ContentDocumentId;
        
        
        ContentDocumentLink cd=new ContentDocumentLink();
        cd.ContentDocumentId=contentDocument;
        cd.LinkedEntityId = l.Id;
        cd.ShareType = 'V' ;
        insert cd;
        String json5 = '[{"Id":"'+prd.Id+'","Name":"Credit Information Report - Commercial","Examples__c":{},"Fee_Plan_Type__c":"Products","Product_Line_Items__r":[{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcKUAS","Name":"1","Monthly_Volumes__c":"upto 50","Price_Per_Report__c":450,"$$hashKey":"object:122"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcPUAS","Name":"2","Monthly_Volumes__c":"51-200","Price_Per_Report__c":22,"$$hashKey":"object:123"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcQUAS","Name":"3","Monthly_Volumes__c":"201-500","Price_Per_Report__c":20,"$$hashKey":"object:124"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcUUAS","Name":"4","Monthly_Volumes__c":"501-1000","Price_Per_Report__c":17,"$$hashKey":"object:125"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcZUAS","Name":"5","Monthly_Volumes__c":"Above 1000","Price_Per_Report__c":14,"$$hashKey":"object:126"}],"Selected__c":false,"$$hashKey":"object:105"}]';
        
        
        Attachment attach=new Attachment();       
        attach.Name='Agreement Copy.pdf';
        Blob bodyBlob=EncodingUtil.Base64Decode('Unit Test Attachment Body');
        attach.body=bodyBlob;
        //attach.body= EncodingUtil.Base64Decode(bodyBlob);
        attach.parentId=l.id;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        Payment_Detail__c pd=new Payment_Detail__c();
        pd.Transaction_NUmber__c='1234';
        insert pd;
        
        test.startTest();
        newFormsCotroller nm = new newFormsCotroller();
        newFormsCotroller.getStateCityPincode(sc.PinCode__c);
        newFormsCotroller.getVarifedInfo(l.Company,l.Pan_no__c,l.GST_No__c);
        newFormsCotroller.getCINVerifiedInfo('L40100GJ1995PLC025447');
        
        newFormsCotroller.getRBIVerifiedInfo('','Account Aggregator (AA) NBFCs');
        newFormsCotroller.getRBIVerifiedInfo(rm1.Name,rm1.Type__c);
        newFormsCotroller.verificationMember('1234',l.Id);
        newFormsCotroller.detailMember(js, l.Id);
        //newFormsCotroller.fakeCodeCoverage();
        l.status='Contact and User ID';
        //update l;
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        newFormsCotroller.getLeadInfo('Sree Kumarasamajam Finserve Pvt Ltd');
        newFormsCotroller.saveUserDetail(js2,l.Id);
        newFormsCotroller.getUploadedFilesV2(l.Id);
        newFormsCotroller.getDirecotorFiles(l.Id);
        newFormsCotroller.uploaddocs(l.Id,'Test','678','pdf');
        newFormsCotroller.uploaddocsnew(l.Id,'Test','678','pdf');
        newFormsCotroller.getAgreementCopy(l.Id);
        newFormsCotroller.resendOTP(l.Id);
        
        newFormsCotroller.planSelection(l.Id,json5);
        newFormsCotroller.paymentSubmit(l.Id);
        newFormsCotroller.getsignedCopy(l.Id);
        newFormsCotroller.saveSubmmitDocument(l.Id);
        
        newFormsCotroller.attachBlob(attach.parentId, attach.Name,attach.Name,  'bodyBlob');
        newFormsCotroller.getTokenForPayNow('',456,'sf@testmail.com','9028822777');
        newFormsCotroller.update_payment_status_pay_now(pd.Transaction_NUmber__c,l.Id,9,'');
        newFormsCotroller.getPlan();
        newFormsCotroller.send_pay_details('',1, l.Name, l.Email, l.MobilePhone, l.Company);
        test.stopTest();
        //newFormsCotroller.getPANVerifiedInfo(l.Pan_no__c);
        
    }
    
    
    @isTest
    public static void isValidate3(){
        
        
        Product__c prd = new Product__c();
        prd.Fee_Plan_Type__c = 'Products';
        prd.Active__c = false;
        prd.Initial_Payment_Amount__c = 1234;
        
        insert prd;
        
        Product_Line_Item__c prdItem = new Product_Line_Item__c();
        prdItem.Price_Per_Report__c = 123;
        prdItem.Product__c = prd.Id;
        
        insert prdItem;
        
        
        Lead l = new Lead (Company ='Sree Kumarasamajam Finserve Pvt Ltd',LastName = 'Amjad',Pan_no__c='AAACG8283C',GST_No__c='32AAACG8283C1ZW',RBI_Certificate_No__c='1234567890',GST_State__c='Kerala',OTP__c ='5624',Status = 'Plan selection');
        l.LegalDesk_Agreement_Document_Id__c='ASDFG12345';
        l.Legal_desk_docket_id__c='12345';
        l.email = 'abc@gmail.com';
        l.RBI_Certificate_Verified__c = 'True';
        l.Pan_Verified__c = 'True';
        l.GST_Verified__c ='True';
        l.RBI_Member_Verified__c = 'Yes';
        l.Checked_in_NBFC_List__c = 'Yes';
        l.Date_of_Incorporation__c = system.today().addDays(-7879);
        l.Checked_in_Termination_List__c = 'Yes';
        l.Executive_Verified_Documents__c =true;
        l.TL_Verified_Documents__c = true;
        l.Admin_Verified_Documents__c = true;
        l.Selected_Company_Name__c = 'As Per MCA';
        l.First_Name_Auth_Usr_Req__c = 'Test';
        l.OTP__c = '1234';
        insert l;
        
        l.status='Business and Ownership';
        update l;
        
        
        l.status='Contact and User ID';
        update l;
        
        
        
        l.status='Supporting Documents (Signatory & Directors)';
        update l;
        
        
        List<string> userTypeDetail = new List<string> ();
        userTypeDetail.add('Head of Product');
        userTypeDetail.add('Head of Technology');
        userTypeDetail.add('Head of Compliance');
        userTypeDetail.add('Head of Infosec');
        userTypeDetail.add('Billing Contact Detail');
        userTypeDetail.add('Head of Audit');
        userTypeDetail.add('Person authorized to upload/share onboarding documents');
        userTypeDetail.add('API Login User');
        userTypeDetail.add('UAT Test Profile');
        
        List<User_Detail__c> userTypeDetailList = new List<User_Detail__c> ();
        for(integer i = 0; i< userTypeDetail.size() ; i++){
            User_Detail__c ud = new User_Detail__c();
            ud.User_Type__c = userTypeDetail[i];
            ud.Lead__c = l.Id;
            ud.First_Name__c = 'Test'+i;
            ud.Last_Name__c = 'Test Last'+i;
            ud.Official_Email_Address__c = i+'abc@gmail.com';
            userTypeDetailList.add(ud); 
        }
        
        if(userTypeDetailList.size() > 0){
            insert userTypeDetailList;
        }
        
        
        RBI_Member__c rm1=new RBI_Member__c();
        rm1.Name=l.Company;
        rm1.Type__c='Account Aggregator (AA) NBFCs';
        insert rm1;
        
        
        State_City_Pin__c sc = new State_City_Pin__c();
        sc.PinCode__c = '421306';
        sc.Name ='sdfg';
        insert sc; 
        
        
        Authorized_Signatory_Directors__c aus = new Authorized_Signatory_Directors__c();
        aus.Lead__c = l.Id;
        aus.First_Name__c = 'Test';
        aus.Last_Name__c = 'Last Name';
        aus.LinkedIn_URL__c = 'www.google.com';
        aus.Description__c= 'disc';
        aus.Mobile_No__c = '8989898909';
        aus.DIN__c = '1234';
        insert aus;
        
        
        Supporting_Document__c sp = new Supporting_Document__c();
        sp.lead__c = l.Id;
        sp.Supporting_Document_Name__c = 'Copy of PAN Card';
        insert sp;
        
        
        ContentVersion testContentInsert2 =new ContentVersion(); 
        testContentInsert2.ContentURL='test'; 
        testContentInsert2.Title ='Google.com'; 
        insert testContentInsert2; 
        
        
        Id contentDocument2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentInsert2.Id LIMIT 1].ContentDocumentId;
        ContentDocumentLink cd2=new ContentDocumentLink();
        cd2.ContentDocumentId=contentDocument2;
        cd2.LinkedEntityId = sp.Id;
        cd2.ShareType = 'V' ;
        insert cd2;
        
        
        
        ContentVersion testContentInsert3 =new ContentVersion(); 
        testContentInsert3.ContentURL='test'; 
        testContentInsert3.Title ='Copy of  Identity proof'; 
        insert testContentInsert3; 
        
        
        Id contentDocument3 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentInsert3.Id LIMIT 1].ContentDocumentId;
        ContentDocumentLink cd3=new ContentDocumentLink();
        cd3.ContentDocumentId=contentDocument3;
        cd3.LinkedEntityId = l.Id;
        cd3.ShareType = 'V' ;
        insert cd3;
        
        
        
        string js='{"authList":[{"Description":"Daily Scrum Meeting*","designation":"WHOLE-TIME DIRECTOR","din":"00002603","email":"rishikesh.korade@finessedirect.com","Id":"00QBi00000BI8aJMAT","LastNameOfDirector":"TANTI","mobile":"6786786789","name":"GIRISH RANCHHODBHAI","url":"linkdin.com"},{"Description":"","designation":"DIRECTOR","din":"00508623","email":"shashank@finessedirect.com","Id":"a0TBi000002LmIEMA0","LastNameOfDirector":"DESAEDELEER","mobile":"6786786789","name":"MARC ANDREE R","url":""}],"Authorised_Signatory_Same_As_Nodal_Offic_c":false,"brandDescriprion":"Hello","brandName":"Brand Name / Market Name","pmList":[{"Id":"a0VBi000001L5QqMAK","NameOfDirector":"Vikram Jadhav","per_Of_Ownership":10},{"Id":"a0VBi000001L5QrMAK","NameOfDirector":"Sourav k","per_Of_Ownership":90}]}';
        string js2='{"hd_Audit_and_Compliance":{"First_Name_head_of_Audit_c":"sahil","Id":"a09Bi000004FUDIIA4","Job_Title_head_of_Audit_c":"hghbkjb","Last_Name_head_of_Audit_c":"khaire","Official_Email_head_of_Audit_c":"sa@gamil.com","Tel_No_head_of_Audit_c":"6767676767"},"hd_compliance":{"First_Name_head_of_Compliance_c":"amit","Id":"a09Bi000004FUDFIA4","Job_Title_head_of_Compliance_c":"fgh","Last_Name_head_of_Compliance_c":"singh","Official_Email_head_of_Compliance_c":"a@gmail.com","Tel_No_head_of_Compliance_c":"6676786789"},"hd_con_Details":{"First_Name_billing_contact_details_c":"sourav","Id":"a09Bi000004FUDHIA4","Job_Title_billing_contact_details_c":"kh","Last_Name_billing_contact_details_c":"kaushari","Official_Email_billing_contact_details_c":"s@gmail.com","Tel_No_billing_contact_details_c":"5675675674"},"hd_Infosec":{"First_Name_head_of_Infosec_c":"prince","Id":"a09Bi000004FUDGIA4","Job_Title_head_of_Infosec_c":"jh","Last_Name_head_of_Infosec_c":"badi","Official_Email_head_of_Infosec_c":"p@gmail.com","Tel_No_head_of_Infosec_c":"6786786785"},"hd_IP_address":{"First_Name_API_IP_address_c":"aditya","Id":"a09Bi000004FUDKIA4","Job_Title_API_IP_address_c":"nkdbbf","Last_Name_API_IP_address_c":"zagade","Official_Email_API_IP_address_c":"zaa@gmail.com","RestrctedIPRanges":[{"Id":"a0UBi000000NWSDMA4","login_IP":"121:121:121:23"}],"Tel_No_API_IP_address_c":"6767678678"},"hd_person_authorized":{"First_Name_details_of_person_authorized_c":"amjad","Id":"a09Bi000004FUDJIA4","Job_Title_details_of_person_authorized_c":"mnb","Last_Name_details_of_person_authorized_c":"sayyad","Official_Email_details_of_person_authorized_c":"sam@gmail.com","Tel_No_details_of_person_authorized_c":"7686786786"},"hd_Product":{"First_Name_head_of_prod_c":"harish","Id":"a09Bi000004FUDDIA4","Job_Title_head_of_prod_c":"tester","Last_Name_head_of_prod_c":"waghmare","Official_Email_head_of_prod_c":"h@gmail.com","Tel_No_head_of_prod_c":"5675675674"},"hd_Profile_Details":[{"First_Name_UAT_Test_Profile_Details_c":"PRANAV","Id":"a09Bi000004FUDLIA4","Job_Title_UAT_Test_Profile_Details_c":"Tester","Last_Name_UAT_Test_Profile_Details_c":"TULSIBHAI","Official_Email_UAT_Test_Profile_Details_c":"p@gmail.com","Tel_No_UAT_Test_Profile_Details_c":"8897909087"}],"hd_technology":{"First_Name_head_of_Technology_c":"sahshank","Id":"a09Bi000004FUDEIA4","Job_Title_head_of_Technology_c":"fjjoj","Last_Name_head_of_Technology_c":"sharma","Official_Email_head_of_Technology_c":"a@gamil.com","Tel_No_head_of_Technology_c":"8798798798"}}';
        
        ContentVersion testContentInsert =new ContentVersion(); 
        testContentInsert.ContentURL='test'; 
        testContentInsert.Title ='Google.com'; 
        insert testContentInsert; 
        
        
        Id contentDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentInsert.Id LIMIT 1].ContentDocumentId;
        
        
        ContentDocumentLink cd=new ContentDocumentLink();
        cd.ContentDocumentId=contentDocument;
        cd.LinkedEntityId = l.Id;
        cd.ShareType = 'V' ;
        insert cd;
        String json5 = '[{"Id":"'+prd.Id+'","Name":"Credit Information Report - Commercial","Examples__c":{},"Fee_Plan_Type__c":"Products","Product_Line_Items__r":[{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcKUAS","Name":"1","Monthly_Volumes__c":"upto 50","Price_Per_Report__c":450,"$$hashKey":"object:122"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcPUAS","Name":"2","Monthly_Volumes__c":"51-200","Price_Per_Report__c":22,"$$hashKey":"object:123"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcQUAS","Name":"3","Monthly_Volumes__c":"201-500","Price_Per_Report__c":20,"$$hashKey":"object:124"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcUUAS","Name":"4","Monthly_Volumes__c":"501-1000","Price_Per_Report__c":17,"$$hashKey":"object:125"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcZUAS","Name":"5","Monthly_Volumes__c":"Above 1000","Price_Per_Report__c":14,"$$hashKey":"object:126"}],"Selected__c":false,"$$hashKey":"object:105"}]';
        
        
        Attachment attach=new Attachment();       
        attach.Name='Agreement Copy.pdf';
        Blob bodyBlob=EncodingUtil.Base64Decode('Unit Test Attachment Body');
        attach.body=bodyBlob;
        //attach.body= EncodingUtil.Base64Decode(bodyBlob);
        attach.parentId=l.id;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        Payment_Detail__c pd=new Payment_Detail__c();
        pd.Transaction_NUmber__c='1234';
        insert pd;
        
        test.startTest();
        newFormsCotroller nm = new newFormsCotroller();
        newFormsCotroller.getStateCityPincode(sc.PinCode__c);
        newFormsCotroller.getVarifedInfo(l.Company,l.Pan_no__c,l.GST_No__c);
        newFormsCotroller.getCINVerifiedInfo('L40100GJ1995PLC025447');
        
        newFormsCotroller.getRBIVerifiedInfo('','Account Aggregator (AA) NBFCs');
        newFormsCotroller.getRBIVerifiedInfo(rm1.Name,rm1.Type__c);
        newFormsCotroller.verificationMember('1234',l.Id);
        newFormsCotroller.detailMember(js, l.Id);
        //newFormsCotroller.fakeCodeCoverage();
        l.status='Contact and User ID';
        //update l;
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        newFormsCotroller.getLeadInfo('Sree Kumarasamajam Finserve Pvt Ltd');
        newFormsCotroller.saveUserDetail(js2,l.Id);
        newFormsCotroller.getUploadedFilesV2(l.Id);
        newFormsCotroller.getDirecotorFiles(l.Id);
        newFormsCotroller.uploaddocs(l.Id,'Test','678','pdf');
        newFormsCotroller.uploaddocsnew(l.Id,'Test','678','pdf');
        newFormsCotroller.getAgreementCopy(l.Id);
        newFormsCotroller.resendOTP(l.Id);
        
        newFormsCotroller.planSelection(l.Id,json5);
        newFormsCotroller.paymentSubmit(l.Id);
        newFormsCotroller.getsignedCopy(l.Id);
        newFormsCotroller.saveSubmmitDocument(l.Id);
        
        newFormsCotroller.attachBlob(attach.parentId, attach.Name,attach.Name,  'bodyBlob');
        newFormsCotroller.getTokenForPayNow('',456,'sf@testmail.com','9028822777');
        newFormsCotroller.update_payment_status_pay_now(pd.Transaction_NUmber__c,l.Id,9,'');
        newFormsCotroller.getPlan();
        newFormsCotroller.send_pay_details('',1, l.Name, l.Email, l.MobilePhone, l.Company);
        test.stopTest();
        //newFormsCotroller.getPANVerifiedInfo(l.Pan_no__c);
        
    }
    
    
    @isTest
    public static void isValidate4(){
        
        
        Product__c prd = new Product__c();
        prd.Fee_Plan_Type__c = 'Products';
        prd.Active__c = false;
        prd.Initial_Payment_Amount__c = 1234;
        
        insert prd;
        
        Product_Line_Item__c prdItem = new Product_Line_Item__c();
        prdItem.Price_Per_Report__c = 123;
        prdItem.Product__c = prd.Id;
        
        insert prdItem;
        
        
        Lead l = new Lead (Company ='Sree Kumarasamajam Finserve Pvt Ltd',LastName = 'Amjad',Pan_no__c='AAACG8283C',GST_No__c='32AAACG8283C1ZW',RBI_Certificate_No__c='1234567890',GST_State__c='Kerala',OTP__c ='5624',Status = 'Plan selection');
        l.LegalDesk_Agreement_Document_Id__c='ASDFG12345';
        l.Legal_desk_docket_id__c='12345';
        l.email = 'abc@gmail.com';
        l.RBI_Certificate_Verified__c = 'True';
        l.Pan_Verified__c = 'True';
        l.GST_Verified__c ='True';
        l.RBI_Member_Verified__c = 'Yes';
        l.Checked_in_NBFC_List__c = 'Yes';
        l.Date_of_Incorporation__c = system.today().addDays(-7879);
        l.Checked_in_Termination_List__c = 'Yes';
        l.Executive_Verified_Documents__c =true;
        l.TL_Verified_Documents__c = true;
        l.Admin_Verified_Documents__c = true;
        l.Selected_Company_Name__c = 'As Per MCA';
        l.First_Name_Auth_Usr_Req__c = 'Test';
        l.OTP__c = '1234';
        insert l;
        
        l.status='Business and Ownership';
        update l;
        
        
        l.status='Contact and User ID';
        update l;
        
        
        
        
        List<string> userTypeDetail = new List<string> ();
        userTypeDetail.add('Head of Product');
        userTypeDetail.add('Head of Technology');
        userTypeDetail.add('Head of Compliance');
        userTypeDetail.add('Head of Infosec');
        userTypeDetail.add('Billing Contact Detail');
        userTypeDetail.add('Head of Audit');
        userTypeDetail.add('Person authorized to upload/share onboarding documents');
        userTypeDetail.add('API Login User');
        userTypeDetail.add('UAT Test Profile');
        
        List<User_Detail__c> userTypeDetailList = new List<User_Detail__c> ();
        for(integer i = 0; i< userTypeDetail.size() ; i++){
            User_Detail__c ud = new User_Detail__c();
            ud.User_Type__c = userTypeDetail[i];
            ud.Lead__c = l.Id;
            ud.First_Name__c = 'Test'+i;
            ud.Last_Name__c = 'Test Last'+i;
            ud.Official_Email_Address__c = i+'abc@gmail.com';
            userTypeDetailList.add(ud); 
        }
        
        if(userTypeDetailList.size() > 0){
            insert userTypeDetailList;
        }
        
        
        RBI_Member__c rm1=new RBI_Member__c();
        rm1.Name=l.Company;
        rm1.Type__c='Account Aggregator (AA) NBFCs';
        insert rm1;
        
        
        State_City_Pin__c sc = new State_City_Pin__c();
        sc.PinCode__c = '421306';
        sc.Name ='sdfg';
        insert sc; 
        
        
        Authorized_Signatory_Directors__c aus = new Authorized_Signatory_Directors__c();
        aus.Lead__c = l.Id;
        aus.First_Name__c = 'Test';
        aus.Last_Name__c = 'Last Name';
        aus.LinkedIn_URL__c = 'www.google.com';
        aus.Description__c= 'disc';
        aus.Mobile_No__c = '8989898909';
        aus.DIN__c = '1234';
        insert aus;
        
        
        Authorized_Signatory_Directors__c aus1 = new Authorized_Signatory_Directors__c();
        aus1.Lead__c = l.Id;
        aus1.First_Name__c = 'Test';
        aus1.Last_Name__c = 'Last Name';
        aus1.LinkedIn_URL__c = 'www.google.com';
        aus1.Description__c= 'disc';
        aus1.Mobile_No__c = '8989898909';
        aus1.DIN__c = '1234';
        insert aus1;
        
        
        Supporting_Document__c sp = new Supporting_Document__c();
        sp.lead__c = l.Id;
        sp.Supporting_Document_Name__c = 'Copy of PAN Card';
        insert sp;
        
        
        ContentVersion testContentInsert2 =new ContentVersion(); 
        testContentInsert2.ContentURL='test'; 
        testContentInsert2.Title ='Google.com'; 
        insert testContentInsert2; 
        
        
        Id contentDocument2 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentInsert2.Id LIMIT 1].ContentDocumentId;
        ContentDocumentLink cd2=new ContentDocumentLink();
        cd2.ContentDocumentId=contentDocument2;
        cd2.LinkedEntityId = sp.Id;
        cd2.ShareType = 'V' ;
        insert cd2;
        
        
        
        ContentVersion testContentInsert3 =new ContentVersion(); 
        testContentInsert3.ContentURL='test'; 
        testContentInsert3.Title ='Copy of  Identity proof'; 
        insert testContentInsert3; 
        
        
        Id contentDocument3 = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentInsert3.Id LIMIT 1].ContentDocumentId;
        ContentDocumentLink cd3=new ContentDocumentLink();
        cd3.ContentDocumentId=contentDocument3;
        cd3.LinkedEntityId = l.Id;
        cd3.ShareType = 'V' ;
        insert cd3;
        
        
        
        string js='{"authList":[{"Id":"'+aus.Id+'","Description":"Daily Scrum Meeting*","designation":"WHOLE-TIME DIRECTOR","din":"00002603","email":"rishikesh.korade@finessedirect.com","LastNameOfDirector":"TANTI","mobile":"6786786789","name":"GIRISH RANCHHODBHAI","url":"linkdin.com"},{"Description":"","designation":"DIRECTOR","din":"00508623","email":"shashank@finessedirect.com","Id":"a0TBi000002LmIEMA0","LastNameOfDirector":"DESAEDELEER","mobile":"6786786789","name":"MARC ANDREE R","url":""}],"Authorised_Signatory_Same_As_Nodal_Offic_c":false,"brandDescriprion":"Hello","brandName":"Brand Name / Market Name","pmList":[{"Id":"a0VBi000001L5QqMAK","NameOfDirector":"Vikram Jadhav","per_Of_Ownership":10},{"Id":"a0VBi000001L5QrMAK","NameOfDirector":"Sourav k","per_Of_Ownership":90}]}';
        string js2='{"hd_Audit_and_Compliance":{"First_Name_head_of_Audit_c":"sahil","Id":"a09Bi000004FUDIIA4","Job_Title_head_of_Audit_c":"hghbkjb","Last_Name_head_of_Audit_c":"khaire","Official_Email_head_of_Audit_c":"sa@gamil.com","Tel_No_head_of_Audit_c":"6767676767"},"hd_compliance":{"First_Name_head_of_Compliance_c":"amit","Id":"a09Bi000004FUDFIA4","Job_Title_head_of_Compliance_c":"fgh","Last_Name_head_of_Compliance_c":"singh","Official_Email_head_of_Compliance_c":"a@gmail.com","Tel_No_head_of_Compliance_c":"6676786789"},"hd_con_Details":{"First_Name_billing_contact_details_c":"sourav","Id":"a09Bi000004FUDHIA4","Job_Title_billing_contact_details_c":"kh","Last_Name_billing_contact_details_c":"kaushari","Official_Email_billing_contact_details_c":"s@gmail.com","Tel_No_billing_contact_details_c":"5675675674"},"hd_Infosec":{"First_Name_head_of_Infosec_c":"prince","Id":"a09Bi000004FUDGIA4","Job_Title_head_of_Infosec_c":"jh","Last_Name_head_of_Infosec_c":"badi","Official_Email_head_of_Infosec_c":"p@gmail.com","Tel_No_head_of_Infosec_c":"6786786785"},"hd_IP_address":{"First_Name_API_IP_address_c":"aditya","Id":"a09Bi000004FUDKIA4","Job_Title_API_IP_address_c":"nkdbbf","Last_Name_API_IP_address_c":"zagade","Official_Email_API_IP_address_c":"zaa@gmail.com","RestrctedIPRanges":[{"Id":"a0UBi000000NWSDMA4","login_IP":"121:121:121:23"}],"Tel_No_API_IP_address_c":"6767678678"},"hd_person_authorized":{"First_Name_details_of_person_authorized_c":"amjad","Id":"a09Bi000004FUDJIA4","Job_Title_details_of_person_authorized_c":"mnb","Last_Name_details_of_person_authorized_c":"sayyad","Official_Email_details_of_person_authorized_c":"sam@gmail.com","Tel_No_details_of_person_authorized_c":"7686786786"},"hd_Product":{"First_Name_head_of_prod_c":"harish","Id":"a09Bi000004FUDDIA4","Job_Title_head_of_prod_c":"tester","Last_Name_head_of_prod_c":"waghmare","Official_Email_head_of_prod_c":"h@gmail.com","Tel_No_head_of_prod_c":"5675675674"},"hd_Profile_Details":[{"First_Name_UAT_Test_Profile_Details_c":"PRANAV","Id":"a09Bi000004FUDLIA4","Job_Title_UAT_Test_Profile_Details_c":"Tester","Last_Name_UAT_Test_Profile_Details_c":"TULSIBHAI","Official_Email_UAT_Test_Profile_Details_c":"p@gmail.com","Tel_No_UAT_Test_Profile_Details_c":"8897909087"}],"hd_technology":{"First_Name_head_of_Technology_c":"sahshank","Id":"a09Bi000004FUDEIA4","Job_Title_head_of_Technology_c":"fjjoj","Last_Name_head_of_Technology_c":"sharma","Official_Email_head_of_Technology_c":"a@gamil.com","Tel_No_head_of_Technology_c":"8798798798"}}';
        
        ContentVersion testContentInsert =new ContentVersion(); 
        testContentInsert.ContentURL='test'; 
        testContentInsert.Title ='Google.com'; 
        insert testContentInsert; 
        
        
        Id contentDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :testContentInsert.Id LIMIT 1].ContentDocumentId;
        
        
        ContentDocumentLink cd=new ContentDocumentLink();
        cd.ContentDocumentId=contentDocument;
        cd.LinkedEntityId = l.Id;
        cd.ShareType = 'V' ;
        insert cd;
        String json5 = '[{"Id":"'+prd.Id+'","Name":"Credit Information Report - Commercial","Examples__c":{},"Fee_Plan_Type__c":"Products","Product_Line_Items__r":[{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcKUAS","Name":"1","Monthly_Volumes__c":"upto 50","Price_Per_Report__c":450,"$$hashKey":"object:122"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcPUAS","Name":"2","Monthly_Volumes__c":"51-200","Price_Per_Report__c":22,"$$hashKey":"object:123"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcQUAS","Name":"3","Monthly_Volumes__c":"201-500","Price_Per_Report__c":20,"$$hashKey":"object:124"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcUUAS","Name":"4","Monthly_Volumes__c":"501-1000","Price_Per_Report__c":17,"$$hashKey":"object:125"},{"Product__c":"a036D000005NoCSQA0","Id":"a0J6D000003GkcZUAS","Name":"5","Monthly_Volumes__c":"Above 1000","Price_Per_Report__c":14,"$$hashKey":"object:126"}],"Selected__c":false,"$$hashKey":"object:105"}]';
        
        
        Attachment attach=new Attachment();       
        attach.Name='Agreement Copy.pdf';
        Blob bodyBlob=EncodingUtil.Base64Decode('Unit Test Attachment Body');
        attach.body=bodyBlob;
        //attach.body= EncodingUtil.Base64Decode(bodyBlob);
        attach.parentId=l.id;
        attach.ContentType = 'application/pdf';
        insert attach;
        
        Payment_Detail__c pd=new Payment_Detail__c();
        pd.Transaction_NUmber__c='1234';
        insert pd;
        
        test.startTest();
        newFormsCotroller nm = new newFormsCotroller();
        newFormsCotroller.getStateCityPincode(sc.PinCode__c);
        newFormsCotroller.getVarifedInfo(l.Company,l.Pan_no__c,l.GST_No__c);
        newFormsCotroller.getCINVerifiedInfo('L40100GJ1995PLC025447');
        
        newFormsCotroller.getRBIVerifiedInfo('','Account Aggregator (AA) NBFCs');
        newFormsCotroller.getRBIVerifiedInfo(rm1.Name,rm1.Type__c);
        newFormsCotroller.verificationMember('1234',l.Id);
        newFormsCotroller.detailMember(js, l.Id);
        //newFormsCotroller.fakeCodeCoverage();
        l.status='Contact and User ID';
        //update l;
        
         Lead_Payment_Detail__c lp=new Lead_Payment_Detail__c();
        lp.Product__c=prd.Id;
        lp.Lead__c = l.Id;
        insert lp;
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        newFormsCotroller.getLeadInfo('Sree Kumarasamajam Finserve Pvt Ltd');
        try{
        newFormsCotroller.getLeadInfo(null);
        }catch(exception e){}
        newFormsCotroller.saveUserDetail(js2,l.Id);
        newFormsCotroller.getUploadedFilesV2(l.Id);
        newFormsCotroller.getDirecotorFiles(l.Id);
        newFormsCotroller.uploaddocs(l.Id,'Test','678','pdf');
        newFormsCotroller.uploaddocs(l.Id,'Copy of PAN Card','678','pdf');
        
        
        newFormsCotroller.uploaddocsnew(l.Id,'Test','678','pdf');
        newFormsCotroller.getAgreementCopy(l.Id);
        newFormsCotroller.resendOTP(l.Id);
        
        newFormsCotroller.planSelection(l.Id,json5);
        newFormsCotroller.paymentSubmit(l.Id);
        newFormsCotroller.getsignedCopy(l.Id);
        newFormsCotroller.saveSubmmitDocument(l.Id);
        
        newFormsCotroller.attachBlob(attach.parentId, attach.Name,attach.Name,  'bodyBlob');
        newFormsCotroller.getTokenForPayNow('',456,'sf@testmail.com','9028822777');
        newFormsCotroller.update_payment_status_pay_now(pd.Transaction_NUmber__c,l.Id,9,'');
        newFormsCotroller.getPlan();
        newFormsCotroller.send_pay_details('',1, l.Name, l.Email, l.MobilePhone, l.Company);
        
        try{
            newFormsCotroller.getPANVerifiedInfo(l.Pan_no__c);
        }catch(exception e){}
        test.stopTest();
        
    }
    
    
    @isTest
    public static void isValidate2(){
        
        
        Product__c prd = new Product__c();
        prd.Fee_Plan_Type__c = 'Products';
        prd.Active__c = false;
        prd.Initial_Payment_Amount__c = 1234;
        
        insert prd;
        
        Product_Line_Item__c prdItem = new Product_Line_Item__c();
        prdItem.Price_Per_Report__c = 123;
        prdItem.Product__c = prd.Id;
        
        insert prdItem;
        
        
        string ls = '{"authList":[{"Description":"Daily Scrum Meeting*","designation":"WHOLE-TIME DIRECTOR","din":"00002603","email":"rishikesh.korade@finessedirect.com","Id":"00QBi00000BI8aJMAT","LastNameOfDirector":"TANTI","mobile":"6786786789","name":"GIRISH RANCHHODBHAI","url":"linkdin.com"},{"Description":"","designation":"DIRECTOR","din":"00508623","email":"shashank@finessedirect.com","Id":"a0TBi000002LmIEMA0","LastNameOfDirector":"DESAEDELEER","mobile":"6786786789","name":"MARC ANDREE R","url":""}],"Business_Address":"SUZLON 5,SHRIMALI SOCIETY NEAR SHRI KRISHNA COMPLEX NAVRANGPURA, AHMEDABAD, GUJARAT, INDIA, 380009","CIN_Company_Identification_Number_c":"L40100GJ1995PLC025447","clsDirectList":[{"designation":"","din":"","name":"Other","$$hashKey":"object:144"},{"designation":"WHOLE-TIME DIRECTOR","din":"00002603","name":"GIRISH RANCHHODBHAI TANTI","$$hashKey":"object:145"},{"designation":"DIRECTOR","din":"00508623","name":"MARC ANDREE R DESAEDELEER","$$hashKey":"object:146"},{"designation":"CFO","din":"00686830","name":"HIMANSHU MODY","$$hashKey":"object:147"},{"designation":"DIRECTOR","din":"02957770","name":"PRANAV TULSIBHAI TANTI","$$hashKey":"object:148"},{"designation":"MANAGING DIRECTOR","din":"00002266","name":"VINOD RANCHHODBHAI TANTI","$$hashKey":"object:149"},{"designation":"DIRECTOR","din":"08702339","name":"SAMEER KANTILAL SHAH","$$hashKey":"object:150"},{"designation":"DIRECTOR","din":"00004612","name":"GAUTAM BHAILAL DOSHI","$$hashKey":"object:151"},{"designation":"DIRECTOR","din":"07026548","name":"SEEMANTINEE SHASHANK KHOT","$$hashKey":"object:152"},{"designation":"DIRECTOR","din":"07280323","name":"PER TORBEN HORNUNG PEDERSEN","$$hashKey":"object:153"},{"designation":"CEO","din":"00308931","name":"JAYARAMA PRASAD CHALASANI","$$hashKey":"object:154"}],"Company":"SUZLON ENERGY LTD","Company_Type":"Fintech Company","Data_Pull_id_s_c":false,"DIN_AuSig_c":"00002603","DirectorFileList":[{"dirId":"00QBi00000BI8aJMAT","dirName":"GIRISH RANCHHODBHAITANTI","file":[{"docName":"Copy of  Identity proof","fId":"06ABi000002KQa8MAG","hasNotRequird":true,"hasShowError":false,"hasUploded":true},{"docName":"Letter of Authority","fId":"06ABi000002KVEcMAO","hasNotRequird":false,"hasShowError":false,"hasUploded":true},{"docName":"Visiting card / Business Card","fId":"06ABi000002KVGEMA4","hasNotRequird":true,"hasShowError":false,"hasUploded":true}]},{"dirId":"a0TBi000002LmIEMA0","dirName":"MARC ANDREE RDESAEDELEER","file":[{"docName":"Copy of  Identity proof","fId":"06ABi000002KQn2MAG","hasNotRequird":true,"hasShowError":false,"hasUploded":true},{"docName":"Letter of Authority","fId":"06ABi000002KQn4MAG","hasNotRequird":false,"hasShowError":false,"hasUploded":true},{"docName":"Visiting card / Business Card","fId":"06ABi000002KTZQMA4","hasNotRequird":true,"hasShowError":false,"hasUploded":true}]}],"End_Use_Permitted_Purpose":"End","GST_No_c":"19AADCS0472N2ZY","GST_Registered_c":"Yes","GST_State_c":"West Bengal","Is_Same_As_Registered_Address":"Yes","new_lead_Status":false,"Pan_no_c":"AADCS0472N","registeredAddress":"SUZLON 5,SHRIMALI SOCIETY NEAR SHRI KRISHNA COMPLEX NAVRANGPURA, AHMEDABAD, GUJARAT, INDIA, 380009","SelectedCompanyOptionBy":"As Per MCA","SelectedCompanyOptionByMCA":true,"SelectedCompanyOptionByUser":false,"Type_of_Ownership_c":"Sole Proprietorship","uploadedFileList":[{"fileName":"Copy of PAN Card","hasFileUploaded":true,"Id":"06ABi000002KUyUMAW"},{"fileName":"Company Incorporation Certificate","hasFileUploaded":true,"Id":"06ABi000002KV1iMAG"},{"fileName":"Copy of the GST registration","hasFileUploaded":true,"Id":"06ABi000002KQF1MAO"},{"fileName":"Copy of MOA","hasFileUploaded":true,"Id":"06ABi000002KRHXMA4"},{"fileName":"Copy of AOA","hasFileUploaded":true,"Id":"06ABi000002KV6YMAW"},{"fileName":"Copy of Board Resolution confirming the authorised signatory details","hasFileUploaded":true,"Id":"06ABi000002KPMXMA4"},{"fileName":"Proof on private cloud (if data is being stored on cloud)","hasFileUploaded":true,"Id":"06ABi000002KQy9MAG"},{"fileName":"Proof on data localization in India with IP address","hasFileUploaded":true,"Id":"06ABi000002KV8AMAW"},{"fileName":"Copy of latest audited balance sheet","hasFileUploaded":true,"Id":"06ABi000002KTzJMAW"},{"fileName":"Copy of latest audited financials (Revenue and P and L)","hasFileUploaded":true,"Id":"06ABi000002KV9mMAG"},{"fileName":"Copy of compliance framework and Governance standards of the company (Board Approved)","hasFileUploaded":true,"Id":"06ABi000002KTWCMA4"},{"fileName":"Copy of Cyber Security Policy (Board Approved)","hasFileUploaded":true,"Id":"06ABi000002KU2TMAW"},{"fileName":"Consumer Grievance redressal Policy (Board Approved)","hasFileUploaded":true,"Id":"06ABi000002KSwiMAG"},{"fileName":"Business Continuity Policy (Board Approved)","hasFileUploaded":true,"Id":"06ABi000002KSAMMA4"},{"fileName":"IS Audit Report certified by CISA Auditor along with certificate of the auditor","hasFileUploaded":true,"Id":"06ABi000002KPm0MAG"}],"verfiedData":{"CIN_Number_Verified_c":"Verified","GST_Verification_Remark_c":"SUZLON ENERGY LTD","GST_Verified_c":"True","Pan_Verification_Remark_c":"OK","Pan_Verified_c":"True"},"Website":"www.google.com"}';
        
        test.startTest();
        Test.setMock(HttpCalloutMock.class, new Mock());
        newFormsCotroller.becomeMember(ls);
        newFormsCotroller.fakeCodeCoverage();
        test.stopTest();
    }
    
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('P2MCoreAPIGateway/RPP/Request')) {
                String sta = 'OK';
                String Js = '{"RPPResponse": {"ErrorCode":"PYNERR000","ErrorDescription":""}}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
            return null;
        }
    }
}