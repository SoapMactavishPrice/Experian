global class MapContactBatchClass_Schedule implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        
        MapContactBatchClass gps=new MapContactBatchClass();
        Database.executeBatch(gps);
    }
}