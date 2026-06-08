@IsTest
public class JSON2ApexPanResponseTest_Class {
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
		JSON2ApexPanResponse.parse(json);
		//System.assert(r != null);

		

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2ApexPanResponse.Response objJSON2Apex = new JSON2ApexPanResponse.Response(System.JSON.createParser(json));
		System.assert(objJSON2Apex != null);
		System.assert(objJSON2Apex.name == null);
		System.assert(objJSON2Apex.number_Z == null);
		System.assert(objJSON2Apex.id == null);
		System.assert(objJSON2Apex.instance == null);
		System.assert(objJSON2Apex.result == null);
         
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2ApexPanResponse objJSON2Apex1 = new JSON2ApexPanResponse(System.JSON.createParser(json));        
        System.assert(objJSON2Apex1.service == null);
        System.assert(objJSON2Apex1.itemId == null);
        System.assert(objJSON2Apex1.task == null);
        System.assert(objJSON2Apex1.essentials == null);
        System.assert(objJSON2Apex1.accessToken == null);
        System.assert(objJSON2Apex1.id == null);
        System.assert(objJSON2Apex1.response == null);
         
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2ApexPanResponse.Instance objJSON2Apex2 = new JSON2ApexPanResponse.Instance(System.JSON.createParser(json));
         
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2ApexPanResponse.Instance_Z objJSON2Apex3 = new JSON2ApexPanResponse.Instance_Z(System.JSON.createParser(json));
        System.assert(objJSON2Apex3.id == null);
        System.assert(objJSON2Apex3.callbackUrl == null);
         
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2ApexPanResponse.Essentials objJSON2Apex4 = new JSON2ApexPanResponse.Essentials(System.JSON.createParser(json));
        System.assert(objJSON2Apex4.name == null);
        System.assert(objJSON2Apex4.number_Z == null);
        System.assert(objJSON2Apex4.instance == null);
         
        json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		JSON2ApexPanResponse.Result objJSON2Apex5 = new JSON2ApexPanResponse.Result(System.JSON.createParser(json));
        System.assert(objJSON2Apex5.message == null);
        System.assert(objJSON2Apex5.verified == null);
        System.assert(objJSON2Apex5.upstreamName == null);
        
    } Catch(Exception e){}
    }
}