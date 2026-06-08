@IsTest
public class ScheduleBankBulkEmailTest_Class {
 public static testMethod void validate(){
Test.startTest();
ScheduleBankBulkEmail sh1 = new ScheduleBankBulkEmail();
String sch = '0 0 2 * * ?'; 
system.schedule('Test Territory Check', sch, sh1); 
Test.stopTest();
// add system asserts to check your expected behaviour
 }
}