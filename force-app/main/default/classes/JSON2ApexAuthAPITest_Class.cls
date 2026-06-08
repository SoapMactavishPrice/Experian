@IsTest
public class JSON2ApexAuthAPITest_Class {
 static testMethod void  updateMethodTest(){ 
     String js ='{    \"task\": \"panSearch\",    \"essentials\": {\"panNumber\": \"AAAJT1724E\",\"state\": \"west bengal\",\"email\": \"ravindra@finessedirect.com\"    }}';

     JSON2ApexAuthAPI j = new JSON2ApexAuthAPI();
     
     JSON2ApexAuthAPI.parse(js);
 }
}