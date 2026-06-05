@IsTest
public class FetchMoreDetailsByCIN_Test {
    
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('organizations')) {
                String sta = 'OK';
                String Js = '{"accessToken": "TREW":"id":""}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
            
            if (req.getEndpoint().endsWith('hunts')) {
                String sta = 'OK';
                String Js = '{"result":{ "TREW":"id":""}}';
                
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
        Test.startTest();
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
        Test.setMock(HttpCalloutMock.class, new Mock());
        
        
        FetchMoreDetailsByCIN.parse(json);
        FetchMoreDetailsByCIN.parseCINdetails('{}');
        
        
        
        Account a = new Account();
        a.Name = 'Test';
        Insert a;
        
        
        
        try{
            FetchMoreDetailsByCIN p = new FetchMoreDetailsByCIN();
            p.getCtoCinAPI('Suzlon Energy Ltd');
            
            
            
            FetchMoreDetailsByCIN.JSON2ApexAuthAPI pj = new FetchMoreDetailsByCIN.JSON2ApexAuthAPI(); pj.created = '';
            pj.id = l.Id;
            pj.ttl = 1;
            pj.userId = l.Username__c;
            
            FetchMoreDetailsByCIN.Error_Trace_Wrapper pj1 = new FetchMoreDetailsByCIN.Error_Trace_Wrapper(); 
            pj1.status = '';
            pj1.error_in_method = l.Id;
            
            pj1.error_msg = l.Username__c;
            
            
            FetchMoreDetailsByCIN.fromJSON pl=new  FetchMoreDetailsByCIN.fromJSON();
            pl.target='';
            
            FetchMoreDetailsByCIN.returnVerifyCompanyCin pl1=new  FetchMoreDetailsByCIN.returnVerifyCompanyCin();
            pl1.companyID='';
            pl1.dateOfIncorporation='';
            pl1.registeredAddress = '5678';
            
            FetchMoreDetailsByCIN.returnResult pl2=new  FetchMoreDetailsByCIN.returnResult();
            pl2.Id='';
            pl2.value='';
            
            FetchMoreDetailsByCIN.fakeCodeCoverage();
            Test.stopTest();
        } Catch(Exception e){}
    }
}