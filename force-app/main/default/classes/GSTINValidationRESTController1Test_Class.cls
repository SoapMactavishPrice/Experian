@IsTest
public class GSTINValidationRESTController1Test_Class {
 static testMethod void  updateMethodTest(){ 
     Lead l = new Lead (LastName = 'Amjad',Pan_no__c='1234567',GST_No__c='1234567890',RBI_Certificate_No__c='1234567890',GST_State__c='Maharastra');
     insert l;
         String js ='{    \"task\": \"panSearch\",    \"essentials\": {\"panNumber\": \"AAAJT1724E\",\"state\": \"west bengal\",\"email\": \"ravindra@finessedirect.com\"    }}';
     GSTINValidationRESTController1 g = new GSTINValidationRESTController1();
     g.getTokenAPI(l.Pan_no__c, l.GST_State__c);
     GSTINValidationRESTController1.parse(js);
     g.Cancel();
     GSTINValidationRESTController1.Essentials ge = new GSTINValidationRESTController1.Essentials();
     ge.panNumber = 'AAAJT1724E';
     ge.email = 'sayyad@finesseme.com';
     ge.state = 'west bengal';
     GSTINValidationRESTController1.GstnRecords gg = new GSTINValidationRESTController1.GstnRecords();
     gg.applicationStatus = 'Test';
     gg.emailId = 'sayyad@finesseme.com';
     gg.gstin = '1234567890';
     gg.gstinRefId = 'Test';
     gg.mobNum = 'Test';
     gg.registrationName = 'Test';
     gg.regType = 'Test';
     gg.tinNumber = 'Test';
     GSTINValidationRESTController1.JSON2ApexAcyualGSTIN gj = new GSTINValidationRESTController1.JSON2ApexAcyualGSTIN();
     gj.id = '';
     gj.patronId = '';
     gj.task = '';
     GSTINValidationRESTController1.returnResult gr = new GSTINValidationRESTController1.returnResult();
     gr.Id = '';
     gr.status = true;
     //gr.returnGST = '';
     GSTINValidationRESTController1.returnGST grs = new GSTINValidationRESTController1.returnGST();
     grs.Id = l.id;
     grs.GST_Verified_c = 'True';
     grs.GST_Verification_Remark_c = 'Found';
     grs.GST_number = l.GST_No__c;
 }
}