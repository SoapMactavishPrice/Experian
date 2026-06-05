@IsTest
public class JSON2ApexGSTINSuccessTest_Class {
 static testMethod void  updateMethodTest(){ 
     String js ='{    \"task\": \"panSearch\",    \"essentials\": {\"panNumber\": \"AAAJT1724E\",\"state\": \"west bengal\",\"email\": \"ravindra@finessedirect.com\"    }}';

     JSON2ApexGSTINSuccess j = new JSON2ApexGSTINSuccess();
     
     JSON2ApexGSTINSuccess.parse(js);
 }
}