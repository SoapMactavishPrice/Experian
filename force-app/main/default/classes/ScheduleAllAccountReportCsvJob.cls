public class ScheduleAllAccountReportCsvJob implements Schedulable {
    public void execute(SchedulableContext sc) {
 
        List<String> recipients = new List<String>{'SajidaKhatoon.InamulHaque@experian.com','Shakuntala.Nikharge@experian.com',
                                                    'Aditya.VSingh@experian.com', 'Soumitra.Maharana@experian.com',
                                                    'Harish.Harish@experian.com', 'Somesh.Merani@experian.com', 
                                                    'dataoperationsin@experian.com', 'Dataacquisition.india@experian.com'};

        Database.executeBatch(new SendAllAccountReport(recipients), 200);
    }
}