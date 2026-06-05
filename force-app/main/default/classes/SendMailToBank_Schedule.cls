global class SendMailToBank_Schedule implements Schedulable{
    
    
    global void execute(SchedulableContext ctx) {
        
        SenMailToBank_Batch gps=new SenMailToBank_Batch();
        Database.executeBatch(gps, 20);
    }
    
}