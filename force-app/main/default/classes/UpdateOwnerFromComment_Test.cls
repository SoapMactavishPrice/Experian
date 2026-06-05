@IsTest(SeeAllData=true)
public class UpdateOwnerFromComment_Test {
    
    public static testMethod void validate(){
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        Profile p2 = [SELECT Id FROM Profile WHERE Name='Consumer Support'];
        
        User u_a = new User(Alias = 'standt1', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8',
                            LastName='Rajput', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, 
                            TimeZoneSidKey='America/Los_Angeles', UserName='Deepshikha@testorg.com');
        insert u_a;
        System.debug('u '+u_a); 
        
        Account acc = new Account();
        acc.Name = 'Kabib';
        acc.Instant_Reports__c  = true; 
        insert acc; 
        
        Case cs = new Case();
        cs.Displayed_Loan_Balance__c =Decimal.valueof(5000);
        cs.Displayed_EMI_Amount__c =Decimal.valueof(9000);
        cs.Status = 'Open';
        cs.OwnerId=u_a.id;
        cs.AccountId = acc.id;
        cs.Subject = 'Update';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = null;
        cs.Origin = 'Email';
        insert cs;
        
        FeedItem fi = new FeedItem();
        fi.ParentId = cs.Id;
        fi.Body = 'textarea';
        fi.IsRichText = false;
        insert fi;
        
        FeedComment fc=new FeedComment();
        //fc.ParentId=cs.id;
        fc.CommentType='TextComment';
        fc.CommentBody='test';
        fc.FeedItemId=fi.id;
        insert fc;
        
    }
}