@isTest
public class SendMailToBank_ScheduleTest {
    
  public static testMethod void validate(){
  Test.startTest();
  SendMailToBank_Schedule sh1 = new SendMailToBank_Schedule();
  String sch = '0 0 2 * * ?'; 
  System.schedule('Test Territory Check', sch, sh1); 
  Test.stopTest();
 }

}