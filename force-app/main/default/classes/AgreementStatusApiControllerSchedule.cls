global class AgreementStatusApiControllerSchedule implements Schedulable{
    global void execute(SchedulableContext SC) {
        AgreementStatusApiController aspc = new AgreementStatusApiController(); 
         Database.executebatch(aspc,1);
  
     }

}