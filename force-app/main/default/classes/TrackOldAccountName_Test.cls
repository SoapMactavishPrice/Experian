@isTest (SeeAllData=true)
public class TrackOldAccountName_Test {
    
    public static testMethod void validate(){
        
        Account acc = new Account();
        acc.Name = 'Finesse';
        acc.Certificate_Email_Sent__c=false;
        insert acc;
        
        acc.Name = 'Finesse IT';
        update acc;
        
        AccountHistory ah =new AccountHistory();
        ah.AccountId=acc.Id;
        ah.Field='TextName';
        insert ah;
        
        acc.Old_Account_Name__c ='Finesse';
        update acc;
        
        
        test.startTest();
        TrackOldAccountName send =new TrackOldAccountName();
        Set<id> ids = new Set<id>();
        ids.add(acc.id);
        TrackOldAccountName.UpdateOldAccountName(ids);
        test.stopTest();
        
    }  
    
}