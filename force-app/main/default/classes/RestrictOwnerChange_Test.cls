@isTest

public class RestrictOwnerChange_Test {
    
    public static testMethod void beforeUpdate(){
        
        Test.startTest();
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
        
        Case_Type__c ct = new Case_Type__c();
        ct.Name = 'Query';
        ct.Case_Category__c = 'Consumer';
        ct.Case_Complaint__c = 'Report';
        Insert ct;
        
        Sub_Type__c st = new Sub_Type__c();
        st.Name = 'Status of Dispute';
        st.Case_Type__c = ct.id;
        st.isActive__c = true;
        Insert st;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Duplicate';
        st1.Sub_Type__c = st.id;
        st1.isActive__c = true;
        Insert st1;
        
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
        cs.Consumer_Dispute_Status__c= 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Experian';
        insert cs;
        
        Case cs1 = new Case();
        cs1.Displayed_Loan_Balance__c =Decimal.valueof(5000);
        cs1.Displayed_EMI_Amount__c =Decimal.valueof(9000);
        cs1.Status = 'Open';
        cs1.OwnerId=u_a.id;
        cs1.AccountId = acc.id;
        cs1.Subject = 'Update';
        cs1.Case_Category__c = 'Consumer';
        cs1.Case_Complaints__c = null;
        cs1.Origin = 'Email';
        cs1.Consumer_Dispute_Status__c= 'Resolved not in favour of the Consumer';
        cs1.Rejection_Reason__c = 'Rejected by Experian';
        cs1.ParentId = cs.id;
        cs1.Is_Duplicate_Case__c = true;
        insert cs1;
              
        System.debug('cs.OwnerId : insert '+cs.OwnerId);            
        
        User u1 = new User(Alias = 'standt2', Email='standarduser2@testorg.com', EmailEncodingKey='UTF-8',
                           LastName='Rajput2', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p2.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='Deepu@testorg.com');
        insert u1;
        System.debug('u1 '+u1);
        
        cs.OwnerId=u1.id;
        System.debug('cs.OwnerId : update '+cs.OwnerId);
        
        RecursiveTriggerHandler.isFirstTime = true;
        update cs;
        RecursiveTriggerHandler.isFirstTime = false;  
    }   
}