@IsTest
public class SendMembershipRenewalTrigger_Test {
    
    public static testMethod void validate(){
        
        Account acc = new Account();
        acc.Name = 'Finesse';
        acc.Certificate_Email_Sent__c=false;
        acc.Subscriber_ID__c='FP123';
        insert acc;
        
        Membership_Renewal__c mr =new Membership_Renewal__c();
        mr.Account__c=acc.id;
        mr.Renewal_Date__c=system.today();
        mr.Renewal_Payment_Received__c=true;
        mr.Certificate_Email_Sent__c=false;
        insert mr;
        
        mr.Certificate_Email_Sent__c=true;
        update mr;
        
    }  
}