@isTest
public class BatchCycleUtil_Test {

    @isTest
    static void test2AMCycle() {

        Test.startTest();
        Datetime cutoff = BatchCycleUtil.getCycleCutoff();
        Datetime start  = BatchCycleUtil.getStartTime(cutoff);
        Test.stopTest();

        // Cutoff should be one of cycle hours
        List<Integer> validHours = new List<Integer>{2,6,10,14,18,22};

        System.assert(validHours.contains(cutoff.hour()),
            'Cutoff hour should be valid cycle hour');

        // Start should always be midnight of previous day
        System.assertEquals(0, start.hour(), 'Start hour must be 0');
    }


    @isTest
    static void testAllCycleHoursValidation() {

        Test.startTest();
        Datetime cutoff = BatchCycleUtil.getCycleCutoff();
        Test.stopTest();

        Integer hour = cutoff.hour();

        // Validate it always returns valid cycle hour
        System.assert(
            hour == 2 || hour == 6 || hour == 10 ||
            hour == 14 || hour == 18 || hour == 22,
            'Invalid cycle hour returned: ' + hour
        );
    }


    @isTest
    static void testStartTimeLogic() {

        Datetime sampleCutoff = Datetime.newInstance(
            Date.today(),
            Time.newInstance(6,0,0,0)
        );

        Datetime start = BatchCycleUtil.getStartTime(sampleCutoff);

        Datetime expectedStart = Datetime.newInstance(
            Date.today().addDays(-1),
            Time.newInstance(0,0,0,0)
        );

        System.assertEquals(expectedStart, start, 'Start time calculation is wrong');
    }
}