@IsTest
public class JSON2ApexPaymentGatewayTest_Class {
static testMethod void testParse() {
     
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
		JSON2ApexPaymentGateway.parse(json);
     }
}