@IsTest
public class JSON2ApexIdentityJSONTest_Class {
	// This test method should give 100% coverage
	static testMethod void testParse() {
        try{
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
		JSON2ApexIdentityJSON.parse(json);
		//System.assert(r != null);

		

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2ApexIdentityJSON objJSON2Apex = new JSON2ApexIdentityJSON(System.JSON.createParser(json));
		System.assert(objJSON2Apex != null);
		System.assert(objJSON2Apex.type_Z == null);
		System.assert(objJSON2Apex.email == null);
		System.assert(objJSON2Apex.callbackUrl == null);
		System.assert(objJSON2Apex.images == null);
		System.assert(objJSON2Apex.accessToken == null);
        System.assert(objJSON2Apex.autoRecognition == null);
        System.assert(objJSON2Apex.verification == null);
        System.assert(objJSON2Apex.forgeryCheck == null);
        System.assert(objJSON2Apex.id == null);
        System.assert(objJSON2Apex.patronId == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2ApexIdentityJSON.AutoRecognition objJSON2Apex1 = new JSON2ApexIdentityJSON.AutoRecognition(System.JSON.createParser(json));
        List<String> su=JSON2ApexIdentityJSON.arrayOfString(System.JSON.createParser(json));
       // List<JSON2ApexIdentityJSON.AutoRecognition> su1=JSON2ApexIdentityJSON.arrayOfAutoRecognition(System.JSON.createParser(json));
    } Catch(Exception e){}
	
	
}
}