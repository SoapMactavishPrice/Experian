@IsTest
public class PanCardValidationRESTControllerTest_Clas {

private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('login')) {
                String sta = 'OK';
                String Js = '{"id": "34","userId":"1234"}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
             if (req.getEndpoint().endsWith('snoops')) {
                String sta = 'OK';
                String Js = '{"response":{"result":{"message":"success","verified":true}}}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
             if (req.getEndpoint().endsWith('identities')) {
                String sta = 'OK';
                String Js = '{"accessToken":"ASFDG","id":"34"}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
            
            return null;
        }
    }
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
    PanCardValidationRESTController.parse(json); 
    
    Account a = new Account();
    a.Name = 'Test';
    Insert a;
    
    PageReference pgRef = Page.PanCardValidationPage; //Create Page Reference - 'Appt_New' is the name of Page
    Test.setCurrentPage(pgRef); //Set the page for Test Method
    ApexPages.currentPage().getParameters().put('id',  l.id );
    
    try{
    Test.StartTest();
    Test.setMock(HttpCalloutMock.class, new Mock());
    PanCardValidationRESTController p = new PanCardValidationRESTController();
    p.Cancel();
    p.getTokenAPI();
   
    
   
    
    PanCardValidationRESTController.JSON2ApexAuthAPI pj = new PanCardValidationRESTController.JSON2ApexAuthAPI();
    pj.created = '';
    pj.id = l.Id;
    pj.ttl = 1;
    pj.userId = l.Username__c;
     Test.StopTest();

    } Catch(Exception e){}
}
static testMethod void testParse2() {
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
    PanCardValidationRESTController.parse(json); 
    
    Account a = new Account();
    a.Name = 'Test';
    Insert a;
    
    PageReference pgRef = Page.PanCardValidationPage; //Create Page Reference - 'Appt_New' is the name of Page
    Test.setCurrentPage(pgRef); //Set the page for Test Method
    ApexPages.currentPage().getParameters().put('id',  l.id );
    
    try{
    Test.StartTest();
    //Test.setMock(HttpCalloutMock.class, new Mock());
    PanCardValidationRESTController p = new PanCardValidationRESTController();
    p.Cancel();
    p.getTokenAPI();
   
    
   
    
    PanCardValidationRESTController.JSON2ApexAuthAPI pj = new PanCardValidationRESTController.JSON2ApexAuthAPI();
    pj.created = '';
    pj.id = l.Id;
    pj.ttl = 1;
    pj.userId = l.Username__c;
     Test.StopTest();

    } Catch(Exception e){}
}
}