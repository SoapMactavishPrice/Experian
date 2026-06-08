@isTest
public class GrievancesNodalOfficersBatch_Test {
    @isTest
    public static void validate(){
        Account acc= new Account();
        acc.name = 'Test';
        //acc.Send_Grievances_Email__c = true;
        acc.Email_1_Dispute__c = 'abc@gmail.com';
        acc.Email_2_Dispute__c = 'abc@gmail.com';
        acc.Email_3_Dispute__c = 'abc@gmail.com';
        acc.Email_4_Dispute__c = 'abc@gmail.com';
        acc.Email_5_Dispute__c = 'abc@gmail.com';
        acc.Email_6_Dispute__c = 'abc@gmail.com';
        
        acc.Email_7_Dispute__c = 'abc@gmail.com';
        acc.Email_8_Dispute__c = 'abc@gmail.com';
        acc.Email_9_Dispute__c = 'abc@gmail.com';
        acc.Person_Name_Dispute__c = 'avcs';
        insert acc;
        
        GrievancesNodalOfficersBatch sm = new GrievancesNodalOfficersBatch();
        Database.executeBatch(sm,10);
    }
}