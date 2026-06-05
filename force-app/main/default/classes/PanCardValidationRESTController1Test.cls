@IsTest
public class PanCardValidationRESTController1Test {
static testMethod void testParse() {
    Lead l = new Lead (LastName = 'Amjad',Pan_no__c='1234567',GST_No__c='1234567890',RBI_Certificate_No__c='1234567890',GST_State__c='Maharastra');
    insert l;
    String json = '{'+
        '    \"expiresAt\": \"2020-01-08T05:46:37.000Z\",'+
        '    \"status\": \"SUCCESS\",'+
        '    \"sessionToken\": \"20111U2e-0DeojsLlAOxIQVgEUPy0zvb9Dj0WPXm_KlcCdVEAGPp86y\",'+
        '    \"_embedded\": {'+
        '        \"user\": {'+
        '            \"id\": \"00u3g3rbaqIZHeXst0i7\",'+
        '            \"passwordChanged\": \"2019-12-26T11:57:33.000Z\",'+
        '            \"profile\": {'+
        '                \"login\": \"exptestp@expnsso.com\",'+
        '                \"firstName\": \"Test\",'+
        '                \"lastName\": \"Test\",'+
        '                \"locale\": \"en\",'+
        '                \"timeZone\": \"America/Los_Angeles\"'+
        '            }'+
        '        }'+
        '    },'+
        '    \"_links\": {'+
        '        \"cancel\": {'+
        '            \"href\": \"https://experian-eub-test.okta-emea.com/api/v1/authn/cancel\",'+
        '            \"hints\": {'+
        '                \"allow\": ['+
        '                    \"POST\"'+
        '                ]'+
        '            }'+
        '        }'+
        '    }'+
        '}';
    PanCardValidationRESTController1.parse(json);
    
    Account a = new Account();
    a.Name = 'Test';
    Insert a;
    
    PageReference pgRef = Page.PanCardValidationPage; //Create Page Reference - 'Appt_New' is the name of Page
    Test.setCurrentPage(pgRef); //Set the page for Test Method
    ApexPages.currentPage().getParameters().put('id',  l.id );
    
    try{
    PanCardValidationRESTController1 p = new PanCardValidationRESTController1();
    p.Cancel();
    p.getTokenAPI(l.Company, l.Pan_no__c);
        
    PanCardValidationRESTController1.returnVerifyPanCard pr = new PanCardValidationRESTController1.returnVerifyPanCard();
    pr.Id = l.id;
    pr.Pan_Verification_Remark_c = l.Pan_Verification_Remark__c;
    pr.Pan_Verified_c = l.Pan_Verified__c;
        
    PanCardValidationRESTController1.returnResult prs = new PanCardValidationRESTController1.returnResult();
    prs.Id = l.id;
    prs.value = '';
        
    PanCardValidationRESTController1.Error_Trace_Wrapper pe = new PanCardValidationRESTController1.Error_Trace_Wrapper();
    pe.error_in_method = '';
    pe.error_msg = '';
    pe.status = l.Status;
        
    PanCardValidationRESTController1.JSON2ApexAuthAPI pj = new PanCardValidationRESTController1.JSON2ApexAuthAPI();
    pj.created = '';
    pj.id = l.Id;
    pj.ttl = 1;
    pj.userId = l.Username__c;

    } Catch(Exception e){}
}
    
}