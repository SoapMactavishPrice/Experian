@isTest
public class schedulePayLaterTestclass {

 public static testMethod void validate(){
  Test.startTest();
  schedulePayLater sh1 = new schedulePayLater();
  String sch = '0 0 2 * * ?'; 
  system.schedule('Test Territory Check', sch, sh1); 
  Test.stopTest();
 }
}