@IsTest
public class SendMembershipCertificateTrigger_Test {
    
    public static testMethod void validate(){
        
        Account acc = new Account();
        acc.Name = 'Finesse';
        acc.Certificate_Email_Sent__c=false;
        insert acc;
        
        acc.Subscriber_ID__c='FP123';
        update acc;
        
        Account ac = new Account();
        ac.Name = 'Finesse';
        ac.Certificate_Email_Sent__c=false;
        insert ac;
        
        update ac;
        
        
    }  
}