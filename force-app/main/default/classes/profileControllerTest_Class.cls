@IsTest
public class profileControllerTest_Class {
static testMethod void testMethod1() 
    {   
       
        Account a = new Account(name='Test Account');
        //a.RecordTypeId= '0122u000000TSExAAO';
        insert a;
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        user u = new user(LastName='Xavi',Alias='aa',Email='A786@gmail.com',Username='A786@gmail.com',CommunityNickname='Ammu',ProfileId=profileId.id,TimeZoneSidKey = 'GMT',LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8',LocaleSidKey = 'en_US');               
        insert u;
        
        Contact c = new Contact ();
        c.AccountId =a.Id;
        c.Contact_Role__c = 'Authorized User Id';
        c.LastName = 'Amjad';
        c.Pan_no__c='1234567';
        c.GST_No__c='1234567890';
        c.User_Id__c=u.Id;
        c.Okta_ex_Username__c='Hala';
        c.Password__c='1234567a';
        c.User_Id__c='hala1@gmail.com';
        insert c;

        Product__c p = new Product__c();
        p.Name = 'Product 1';
        p.Active__c = false;
        p.Fee_Plan_Type__c = 'Products';
        Insert p;
        
        Lead_Payment_Detail__c lpd = new Lead_Payment_Detail__c();
        //c.AccountId=a.id;
        lpd.Product__c = p.Id;
        lpd.Contact__c = c.Id;
        insert lpd;

        Product_Line_Item__c pli = new Product_Line_Item__c ();
        pli.Product__c = p.Id;
        pli.Monthly_Volumes__c = 'Up to 30,000';
        pli.Price_Per_Report__c = 	9.35;
        Insert pli;

        Product_Line_Item__c pli1 = new Product_Line_Item__c ();
        pli1.Product__c = p.Id;
        pli1.Monthly_Volumes__c = 'Above 1000';
        pli1.Price_Per_Report__c = 	2;
        Insert pli1;

        Case cas = new Case();
        cas.AccountId=a.Id;
        cas.ContactId=c.Id;
        cas.Status='Open';
        cas.Origin='Email';
        insert cas;
        
        Attachment attachment = new Attachment();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        Attachment.body=bodyBlob;
        attachment.Name = String.valueOf('test.txt');
        attachment.ParentId = a.Id; 
        insert attachment;
        system.debug('Lead---->'+c);
        
        Session__c sc=new Session__c();
        sc.User_Id__c=a.Id;
        sc.sessionId__c='12345';
        insert sc;
        
        test.startTest();
        profileController la = new profileController();
        //FindNearby profileController = new FindNearby();
        la.getCaseCategoryPiclistValue();
        la.getCaseTypePiclistValue();
        la.getCaseSubTypePiclistValue();
        profileController.login('hala1@gmail.com','1234567a');
        profileController.login1('hala1@gmail.com','1234567a');
        profileController.getInforamtion(a.Id,'12345');
        profileController.getInvoice(a.Id,'12345');
        profileController.getExistingDocs(a.Id,'12345');
        profileController.getCompanyInforamtion(a.Id,a.Id,'12345');
     
        profileController.getCases(a.Id,'12345');
      
        profileController.expire_session(u.Id);
        profileController.deleteCase(cas.CaseNumber,a.Id,'12345');
        profileController.attachBlob(attachment.ParentId,attachment.Id,attachment.Name,'Type','hhh');
        profileController.attachBlob(attachment.ParentId,'',attachment.Name,'Type','hhh');
        //profileController.registerCases('[{"caseCategory":"Customer","contactId":"'+c.Id+'","caseType":"Complaint","caseSubType":"Website Related","caseSubtypeOne":"Website not working","Subject":"Not Working Bro","Description":"Please chehk","CaseNumber":""}]',a.Id,'12345');
       
        profileController.editProfile('[{"Id":"'+c.Id+'","AccountId":"'+a.Id+'","Title":"Asest Manager","Name":"Shajit Madhavan","Email":"rahshriv@rediffmail.com","Phone":"9998899823","Birthdate":1573603200000,"Pan_no__c":"BMHT7789","Voter_id__c":"VT0987601","MailingAddress":{"street":"Tulsi Pipe Road","city":"Mumbai","state":"MH","postalCode":"400013","country":"India"},"Aadhar_no__c":"432523456987","Passport_id__c":"9807MTPASS657","Contact_Role__c":"Dispute Manager"}]',a.Id,'12345');
    
        profileController.getPlan(c.Id);
        profileController.existingUserIdRequestorContact(a.Id);
        profileController.existingUserIdRequestorContact('a');

        string v_Json = '[{"Selected_c":true,"Id":"'+p.Id+'"}, {"Selected_c":false,"Id":"'+p.Id+'"}]';
        profileController.planSelection(c.Id, v_Json, '12345');

        v_Json = '{"Id":"'+c.Id+'","Title":"Title 1","FirstName":"FirstName 1","LastName":"LastName 1","Phone":"9876543210","Job_Title_c":"Job_Title_c 1","Email":"Email@gmail.com"}';
        profileController.saveUserIdRequestorIdForm(v_Json,a.Id, a.Id, '12345' );

        test.stopTest();
        
     profileController ca = new profileController();
     ca.contactId=c.id;
     ca.CaseCategory_C='hello';
     ca.cvtoSend='hello';
     ca.myContentDocument= new List<ContentDocumentLink>();
     ca.cv = new ContentVersion();
     ca.cvList = new List<ContentVersion>();
     ca.cvtoSend ='true';
     ca.CaseType_C= New List<String>();
     ca.CaseType_C.add('praveen');
     ca.CaseSubType_C= New List<String>();
     ca.CaseSubType_C.add('praveen');
     ca.CaseSubTypeOne_C= New List<String>();
     ca.CaseSubTypeOne_C.add('praveen');
     ca.base64Value='hello';
     ca.contentType='hello';  
        
     profileController.CaseApex rs = new  profileController.CaseApex();
     rs.Id=cas.id;
     rs.CaseNumber='hello';
     rs.caseCategory='hello';
     rs.caseType='hello';
     rs.caseSubType='hello';
     rs.caseSubtypeOne='hello';
     rs.Subject='hello';
     rs.Description='hello';
     rs.CaseOrigin='hello';
     rs.contactId='hello';
     rs.caseComplain ='Login Issues';
        
     profileController.EditeProfileApex rsp = new  profileController.EditeProfileApex();
     rsp.Id=u.id;
     rsp.AccountId=a.Id;
     rsp.Contact_Role_c='hello';
     rsp.Name='hello';
     rsp.Email='hello@gmail.com';
     rsp.Pan_no_c='1234hello';
     rsp.Phone='1234567890';
     rsp.Title='hello';
        
     profileController.OctaStaus ocS = new  profileController.OctaStaus();
     ocS.instruction='hello';
     ocS.contactList=c;
     ocs.Token = '12345';
     
     profileController.returnDocsStatus rd = new profileController.returnDocsStatus();
     rd.cdList = new List<ContentDistribution>();
     rd.cvList = new List<ContentVersion>();
     rd.status = false;
     
     profileController.resultStatus pr = new profileController.resultStatus();
     pr.status = true;
     pr.caseId =cas.id;
     pr.caseNumber = cas.CaseNumber;
     pr.subject =cas.Subject;
     pr.sNe = '1234';
     
    profileController.MailingAddress pm = new profileController.MailingAddress();
    pm.city = 'Goa';
    pm.country = 'India';
    pm.postalCode = '431001';
    pm.state = 'Goa';
    pm.street = 'Panji';
    
    profileController.MyPickListInfo pmp = new profileController.MyPickListInfo();
    pmp.validFor ='90';
        String res_b='{"status":"Success"}';
        JSON2Apex js = JSON2Apex.parse(res_b);
        
        if(js.status.equals('SUCCESS')){
            
        }
    
    }
    static testMethod void testMethod2() 
    {   
       
        Account a = new Account(name='Test Account2');
        //a.RecordTypeId = '0122u000000TSExAAO';
        insert a;
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        user u = new user(LastName='Xavi',Alias='aa',Email='A786@gmail.com',Username='A786@gmail.com',CommunityNickname='Ammu',ProfileId=profileId.id,TimeZoneSidKey = 'GMT',LanguageLocaleKey = 'en_US', EmailEncodingKey = 'UTF-8',LocaleSidKey = 'en_US');               
        insert u;
        Contact c = new Contact ();
        //c.AccountId=a.id;
        c.LastName = 'Amjad';
        c.Pan_no__c='1234567';
        c.GST_No__c='1234567890';
        c.User_Id__c=u.Id;
        c.Okta_ex_Username__c='Hala';
        insert c;
        Case cas = new Case();
        cas.AccountId=a.Id;
        cas.ContactId=c.Id;
        cas.Status='Open';
        cas.Origin='Email';
        insert cas;
        Attachment attachment = new Attachment();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        Attachment.body=bodyBlob;
        attachment.Name = String.valueOf('test.txt');
        attachment.ParentId = a.Id; 
        insert attachment;
        system.debug('Lead---->'+c);
     
        test.startTest();
        profileController la = new profileController();
        //FindNearby profileController = new FindNearby();
        la.getCaseCategoryPiclistValue();
        la.getCaseTypePiclistValue();
        la.getCaseSubTypePiclistValue();
        profileController.login('hala@gmail.com','1234567a');
        profileController.login1('hala1@gmail.com','1234567a');
        profileController.getInforamtion(u.Id,'12345');
        profileController.getInvoice(a.Id,'12345');
        profileController.getExistingDocs(c.Id,'12345');
        profileController.getCompanyInforamtion(a.Id,u.Id,'12345');
        profileController.getCompanyInforamtion('','','');
        profileController.getCases(c.Id,'12345');
        profileController.getCases('','');
        profileController.expire_session(u.Id);
        profileController.deleteCase(cas.CaseNumber,u.Id,'12345');
        profileController.attachBlob(attachment.ParentId,attachment.Id,attachment.Name,'Type','hhh');
        profileController.attachBlob(attachment.ParentId,'',attachment.Name,'Type','hhh');
        profileController.registerCases('[{"caseCategory":"Customer","contactId":"'+c.Id+'","caseType":"Complaint","caseSubType":"Website Related","caseSubtypeOne":"Website not working","Subject":"Not Working Bro","Description":"Please chehk","CaseNumber":""}]',a.Id,'12345');
       
        profileController.editProfile('[{"Id":"'+c.Id+'","AccountId":"'+a.Id+'","Title":"Asest Manager","Name":"Shajit Madhavan","Email":"rahshriv@rediffmail.com","Phone":"9998899823","Birthdate":1573603200000,"Pan_no__c":"BMHT7789","Voter_id__c":"VT0987601","MailingAddress":{"street":"Tulsi Pipe Road","city":"Mumbai","state":"MH","postalCode":"400013","country":"India"},"Aadhar_no__c":"432523456987","Passport_id__c":"9807MTPASS657","Contact_Role__c":"Dispute Manager"}]',a.Id,'12345');
        la.loginRedirect();
        test.stopTest();
        
     profileController ca = new profileController();
     ca.contactId=c.id;
     ca.CaseCategory_C='hello';
     ca.cvtoSend='hello';
     ca.myContentDocument= new List<ContentDocumentLink>();
     ca.cv = new ContentVersion();
     ca.cvList = new List<ContentVersion>();
     ca.cvtoSend ='true';
     ca.CaseType_C= New List<String>();
     ca.CaseType_C.add('praveen');
     ca.CaseSubType_C= New List<String>();
     ca.CaseSubType_C.add('praveen');
     ca.CaseSubTypeOne_C= New List<String>();
     ca.CaseSubTypeOne_C.add('praveen');
     ca.base64Value='hello';
     ca.contentType='hello';  
        
     profileController.CaseApex rs = new  profileController.CaseApex();
     rs.Id=cas.id;
     rs.CaseNumber='hello';
     rs.caseCategory='hello';
     rs.caseType='hello';
     rs.caseSubType='hello';
     rs.caseSubtypeOne='hello';
     rs.Subject='hello';
     rs.Description='hello';
     rs.CaseOrigin='hello';
     rs.contactId='hello';
     rs.caseComplain ='Login Issues';
        
     profileController.EditeProfileApex rsp = new  profileController.EditeProfileApex();
     rsp.Id=u.id;
     rsp.AccountId=a.Id;
     rsp.Contact_Role_c='hello';
     rsp.Name='hello';
     rsp.Email='hello@gmail.com';
     rsp.Pan_no_c='1234hello';
     rsp.Phone='1234567890';
     rsp.Title='hello';
        
     profileController.OctaStaus ocS = new  profileController.OctaStaus();
     ocS.instruction='hello';
     ocS.contactList=c;
     ocs.Token = '12345';
     
     profileController.returnDocsStatus rd = new profileController.returnDocsStatus();
     rd.cdList = new List<ContentDistribution>();
     rd.cvList = new List<ContentVersion>();
     rd.status = false;
     
     profileController.resultStatus pr = new profileController.resultStatus();
     pr.status = true;
     pr.caseId =cas.id;
     pr.caseNumber = cas.CaseNumber;
     pr.subject =cas.Subject;
     pr.sNe = '1234';
     
    profileController.MailingAddress pm = new profileController.MailingAddress();
    pm.city = 'Goa';
    pm.country = 'India';
    pm.postalCode = '431001';
    pm.state = 'Goa';
    pm.street = 'Panji';
    
    profileController.MyPickListInfo pmp = new profileController.MyPickListInfo();
    pmp.validFor ='90';
        String res_b='{"status":"Success"}';
        JSON2Apex js = JSON2Apex.parse(res_b);
        
        if(js.status.equals('SUCCESS')){
            
        }
    
    }
    
    
}