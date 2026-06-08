global class sendEmailBatchSchedule implements schedulable {
    global void execute(SchedulableContext ctx) {
        sendEmailBatch gps=new sendEmailBatch();
        Database.executeBatch(gps, 50);
    }

}