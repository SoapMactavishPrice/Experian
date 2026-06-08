@isTest
public class MapContactBatchClass_Schedule_Test {
    
    public static testMethod void validate(){
        Test.startTest();
        MapContactBatchClass_Schedule sh1 = new MapContactBatchClass_Schedule();
        String sch = '0 0 2 * * ?'; 
        System.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest();
    }
    
}