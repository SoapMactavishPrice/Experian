@istest
public class GrievancesNodalOfficersPortal_Test {
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
        
        Contact cn = new Contact();
        cn.AccountId = acc.id;
        cn.Contact_Role__c = 'Data Submission Primary';
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Fax = '1234567';
        cn.Email = 'tsetas@gmail.com';
        cn.Birthdate=system.today();
        insert cn;
        
        string js = '[{"Id":"003Bi00000JvtzJIAR","index":"6384","Name":"Rohit","Email":"rohit@gmail.com","Phone":"8976283037","Title":"Data Submission","UserRole":"Data Submission Primary","IP_Address":[{"index":"2196","fromIp":"1.1.1.1","fromToIp":""}]}]';
        ApexPages.currentPage().getParameters().put('recordId',acc.Id);
        GrievancesNodalOfficersPortal griev = new GrievancesNodalOfficersPortal();
        GrievancesNodalOfficersPortal.getAccountName(acc.Id);
        GrievancesNodalOfficersPortal.getContactsGroupedByRole(acc.Id);
        GrievancesNodalOfficersPortal.insertContacts(acc.Id,js);
        
    }
    
}