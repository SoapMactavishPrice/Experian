@isTest
public class DataClass_Test {
    
      public static testMethod void validate1(){
          
        List<OrgWideEmailAddress> owea1 = [select Id from OrgWideEmailAddress where Address = 'nodal.officer.india@experian.com' limit 1];
        //owea1.Address = 'nodal.officer.india@experian.com' ;
        //INSERT owea1;
          
         List<OrgWideEmailAddress> owea2 = [select Id from OrgWideEmailAddress where Address = 'consumer.support@in.experian.com' limit 1];
        //owea2.Address = 'consumer.support@in.experian.com' ;
        //INSERT owea2;
          
          
        Dataclass cl = new Dataclass();
        Dataclass.getNodalOfficer();
        Dataclass.getConsumerSupport();
          
      }

}