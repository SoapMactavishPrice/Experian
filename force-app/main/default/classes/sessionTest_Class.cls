@IsTest
public class sessionTest_Class {
static testMethod void testMethod1() 
    {
        Blob blobKey = crypto.generateAesKey(192);
        String key = EncodingUtil.base64encode(blobKey);
        System.debug('KEY====>'+key);
        
     Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
     User u = new User(Alias = 'standt', Email='standarduser@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
     LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com');
     
     Session__c sc = new Session__c();
     sc.Name = 'Test';
     sc.sessionId__c = key;
    sc.User_Id__c = u.id;
     sc.TIme__c = datetime.now();
     sc.Expire_Time__c = datetime.now().addminutes(2);
     insert sc;
        
     
        
        session s = new session();
        s.startSession(u.id);
        s.updateSession(u.id, key, SC);
        s.deleteSession(u.id);
        s.checkSession(u.id, key);
        
        
    }
}