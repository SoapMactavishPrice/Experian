@IsTest
public class PanToCompanyCinRESTController_Test {
    
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
    PanToCompanyCinRESTController.parse(json);
    
        
    
    Account a = new Account();
    a.Name = 'Test';
    Insert a;
    
  
    
    try{
    PanToCompanyCinRESTController p = new PanToCompanyCinRESTController();
    p.getTokenAPI(l.Pan_no__c);
        
        
        PanToCompanyCinRESTController.returnCompany pj = new PanToCompanyCinRESTController.returnCompany(); 
        pj.Id = '';
    pj.name = l.Id;
    pj.Company_Verified_c = '';
    pj.Company_Verification_Remark_c = 'l.Username__c';

    } Catch(Exception e){}
}

}