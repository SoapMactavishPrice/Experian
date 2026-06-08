@IsTest
public class SendMembershipCertificate_Test {
    
    public static testMethod void validate(){
        
        Account acc = new Account();
        acc.Name = 'Finesse';
        insert acc;
        
        acc.Certificate_Email_Sent__c=true;
        update acc;
        
        test.startTest();
        ApexPages.CurrentPage().getparameters().put('id',acc.id);
        SendMembershipCertificate send =new SendMembershipCertificate();
        Set<id> ids = new Set<id>();
        ids.add(acc.id);
        SendMembershipCertificate.SendEmail(ids);
        acc.Certificate_Email_Sent__c=true;
        test.stopTest();
    }
}