@isTest
public class VerifySupportingDocumnets_Test {

    @isTest
    public static void isValidate(){
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
        
        List<VerifySupportingDocumnets.dataWrapper>  swpList = new List<VerifySupportingDocumnets.dataWrapper>();
        VerifySupportingDocumnets.dataWrapper dwp = new VerifySupportingDocumnets.dataWrapper();
        dwp.isVerified  = false;
        dwp.index = 1;
        dwp.Id = sp.Id;
        dwp.Name = sp.Name;
        dwp.status = 'Rejected';
        swpList.add(dwp);
        
        
        VerifySupportingDocumnets.getDoumnetData(l.Id);
        
       
        
        VerifySupportingDocumnets.getDocumentUrl(sp.Id);
        
        VerifySupportingDocumnets.saveStatus(JSON.serialize(swpList));
    }
}