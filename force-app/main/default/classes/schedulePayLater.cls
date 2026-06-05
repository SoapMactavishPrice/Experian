global class schedulePayLater implements Schedulable{
    global void execute(SchedulableContext ctx) {
        getPaymentStatus gps=new getPaymentStatus();
        Database.executeBatch(gps, 200);
    }

}