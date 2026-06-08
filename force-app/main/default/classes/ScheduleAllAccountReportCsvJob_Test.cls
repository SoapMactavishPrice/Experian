@isTest
private class ScheduleAllAccountReportCsvJob_Test {

    @isTest
    static void testExecuteMethod() {

        Test.startTest();

        // Create instance of schedulable class
        ScheduleAllAccountReportCsvJob job = new ScheduleAllAccountReportCsvJob();
        
        // Execute the job manually
        job.execute(null);

        // Schedule the job (to cover system.schedule)
        String CRON_EXP = '0 0 12 * * ?'; // every day at noon
        String jobId = System.schedule('Test Schedule Job', CRON_EXP, job);

        Test.stopTest();

        // Assertions to verify that job scheduled successfully
        System.assertNotEquals(null, jobId, 'Job should be scheduled successfully');
    }
    
}