global class UpdateCustomerDisputeStatusSchedule implements Schedulable{
    
    global void execute(SchedulableContext ctx){
        UpdateCustomerDisputeStatusBatch ups=new UpdateCustomerDisputeStatusBatch();
        Database.executeBatch(ups,3);
    }
}