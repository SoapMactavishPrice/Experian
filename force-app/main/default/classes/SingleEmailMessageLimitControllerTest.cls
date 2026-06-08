@isTest
public class SingleEmailMessageLimitControllerTest {

    @isTest
    public static void testGetEmailLimits() {
        Test.startTest();
        SingleEmailMessageLimitController.getEmailLimits();
        Test.stopTest();
    }

}