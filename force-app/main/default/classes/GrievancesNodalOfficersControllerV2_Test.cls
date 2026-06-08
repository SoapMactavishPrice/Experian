@isTest
public class GrievancesNodalOfficersControllerV2_Test {
    @isTest
    public static void validate(){
        Account acc= new Account();
        acc.name = 'Test';
        
        acc.Person_Name_Dispute__c = 'avcs';
        acc.DQR_DQI_Email_1__c = 'abc@gmail.com';
        acc.DQR_DQI_Email_2__c = '';
        acc.DQR_DQI_Email_3__c = 'abc@gmail.com';
        acc.DQR_DQI_Email_4__c = '';
        acc.DQR_DQI_Email_5__c = 'abc@gmail.com';
        acc.Nodal_Officer_Email__c  ='abc@gmail.com';
        acc.Authorized_Signatory_Email__c  ='abc@gmail.com';
        insert acc;
        
        acc.OTP__c = '1234';
        update acc;
        
        ApexPages.currentPage().getParameters().put('recordId',acc.Id);
        GrievancesNodalOfficersControllerV2 griev = new GrievancesNodalOfficersControllerV2();
        GrievancesNodalOfficersControllerV2.getAccountData(acc.Id, acc.OTP__c);
        GrievancesNodalOfficersControllerV2.verifyOTPEmail(acc.Id, acc.OTP__c);
        GrievancesNodalOfficersControllerV2.sendOTPEmail(acc.Id);
        string json = '{"Grievances_Nodal_Officer_Name":"name","Person_Name_Dispute__c":"","DQR_DQI_Email_1":"abc@gmail.com","DQR_DQI_Email_2":"abc@gmail.com","DQR_DQI_Email_3":"abc@gmail.com","DQR_DQI_Email_3":"abc@gmail.com"}';
        GrievancesNodalOfficersControllerV2.upadteAccount(json,acc.Id);
    }
    
    @isTest
    public static void validate2(){
        Account acc= new Account();
        acc.name = 'Test';
        acc.Person_Name_2__c = 'avcs';
        acc.Person_Name_3__c = 'avcs';
        acc.Person_Name_4__c = 'avcs';
        acc.Person_Name_5__c = 'avcs';
        acc.Person_Name_6__c = 'avcs';
        acc.Person_Name_7__c = 'avcs';
        acc.Person_Name_8__c = 'avcs';
        acc.Person_Name_9__c = 'avcs';
        acc.Person_Name_10__c = 'avcs';
        
        acc.Person_Name_Dispute__c = 'avcs';
        acc.DQR_DQI_Email_1__c = 'abc@gmail.com';
        acc.DQR_DQI_Email_2__c = '';
        acc.DQR_DQI_Email_3__c = 'abc@gmail.com';
        acc.DQR_DQI_Email_4__c = '';
        acc.DQR_DQI_Email_5__c = 'abc@gmail.com';
        insert acc;
        
        acc.OTP__c = '1234';
        update acc;
        
        ApexPages.currentPage().getParameters().put('recordId',acc.Id);
        GrievancesNodalOfficersControllerV2 griev = new GrievancesNodalOfficersControllerV2();
        GrievancesNodalOfficersControllerV2.getAccountData(acc.Id, acc.OTP__c);
        GrievancesNodalOfficersControllerV2.verifyOTPEmail(acc.Id, acc.OTP__c);
        GrievancesNodalOfficersControllerV2.sendOTPEmail(acc.Id);
        string json = '{"Grievances_Nodal_Officer_Name":"name","Person_Name_Dispute__c":"","DQR_DQI_Email_1":"abc@gmail.com","DQR_DQI_Email_2":"abc@gmail.com","DQR_DQI_Email_3":"abc@gmail.com","DQR_DQI_Email_3":"abc@gmail.com"}';
        GrievancesNodalOfficersControllerV2.upadteAccount(json,acc.Id);
    }
}