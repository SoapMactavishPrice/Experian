@isTest
public class UpdateCustomerDipputeStatusSch_Test {
   public static testMethod Void test(){
        Test.startTest();
        UpdateCustomerDisputeStatusSchedule sh1 = new UpdateCustomerDisputeStatusSchedule();
        String sch = '0 0 2 * * ?'; 
        system.schedule('test', sch, sh1);
        Test.stopTest();
        
    }
}