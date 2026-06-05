@IsTest
public class JSON2ApexGSTINFailTest_Class {
 static testMethod void  updateMethodTest(){ 
     String js ='{    \"task\": \"panSearch\",    \"essentials\": {\"panNumber\": \"AAAJT1724E\",\"state\": \"west bengal\",\"email\": \"ravindra@finessedirect.com\"    }}';

     JSON2ApexGSTINFail j = new JSON2ApexGSTINFail();
     
     JSON2ApexGSTINFail.parse(js);
 }
}