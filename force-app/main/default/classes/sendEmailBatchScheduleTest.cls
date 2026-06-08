@isTest
public class sendEmailBatchScheduleTest {
    public static testMethod Void test(){
        Test.startTest();
        sendEmailBatchSchedule sh1 = new sendEmailBatchSchedule();
        String sch = '0 0 2 * * ?'; 
        system.schedule('test', sch, sh1);
        Test.stopTest();
        
    }
    
}