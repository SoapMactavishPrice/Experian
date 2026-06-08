@IsTest
public class JSON2ApexAcyualGSTINTest_Class {
 static testMethod void  updateMethodTest(){ 
     String js ='{    \"task\": \"panSearch\",    \"essentials\": {\"panNumber\": \"AAAJT1724E\",\"state\": \"west bengal\",\"email\": \"ravindra@finessedirect.com\"    }}';

     JSON2ApexAcyualGSTIN j = new JSON2ApexAcyualGSTIN();
     
     JSON2ApexAcyualGSTIN.parse(js);
 }
}