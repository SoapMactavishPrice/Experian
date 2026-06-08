@IsTest
public class SendMembershipRenewalCertificate_Test {
    
    public static testMethod void validate(){
        
        Account acc = new Account();
        acc.Name = 'Finesse';
        insert acc;
        
        Membership_Renewal__c mr =new Membership_Renewal__c();
        mr.Account__c=acc.id;
        mr.Renewal_Date__c=system.today();
        mr.Renewal_Payment_Received__c=true;
        mr.Certificate_Email_Sent__c=false;
        insert mr;
        
        mr.Certificate_Email_Sent__c=true;
        update mr;
        
        test.startTest();
        ApexPages.CurrentPage().getparameters().put('id',mr.id);
        SendMembershipRenewalCertificate send =new SendMembershipRenewalCertificate();
        Set<id> ids = new Set<id>();
        ids.add(mr.id);
        SendMembershipRenewalCertificate.SendEmail(ids);
        acc.Certificate_Email_Sent__c=true;
        test.stopTest();
    }
    
}