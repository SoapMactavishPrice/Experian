@IsTest
public class AgreementStatusApiControllerScheduleTest {
 public static testMethod void validate(){
  Test.startTest();
  AgreementStatusApiControllerSchedule sh1 = new AgreementStatusApiControllerSchedule();
  String sch = '0 0 2 * * ?'; 
  system.schedule('Test Territory Check', sch, sh1); 
  Test.stopTest();
 }
}