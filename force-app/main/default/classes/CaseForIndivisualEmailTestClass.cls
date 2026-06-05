@isTest 
private class CaseForIndivisualEmailTestClass{
    static testMethod void validateIndivisualEmail() {
       Account acc = new Account();
       acc.Name = 'Kabib';
       acc.Instant_Reports__c  = true;
       // Add other info on account which is requred to create it.
       insert acc;
       System.debug('Account--->'+acc);
       Contact cn = new Contact();
       cn.AccountId = acc.id;
       cn.FirstName = 'Aj';
       cn.LastName = 'style';
       cn.Phone = '1234567890';
       cn.Fax = '1234567';
       cn.Contact_Role__c = 'Nodal Officer';
       cn.Email = 'tsetas@gmail.com';
       cn.Birthdate=system.today();
    insert cn;
       System.debug('Contact--->'+cn);
       Case cs = new Case();
       //cs.RecordTypeId='0126D000000hc2GQAQ';
       cs.Status = 'Open';
       cs.AccountId = acc.id;
       cs.Subject = 'Update Oracle Id';
       cs.Case_Category__c = 'Consumer';
       cs.Case_Complaints__c = 'Correct details on credit report';
       cs.Case_Type__c='Dispute';
       cs.Sub_Type__c='Account Status';
       cs.Sub_Type_1__c='Active';
       cs.Sub_Type_Status__c ='Notify to Bank';
       //cs.Contact.Birthdate=cn.Birthdate;
       //cs.Account.Instant_Reports__c = acc.Instant_Reports__c;
       cs.Origin = 'Web';
       // Add other info on case which is requred to create it.
       insert cs;
       System.debug('Case--->'+cs);
       Map<Id,Case> myCaseMap = new Map<Id,Case>();
       myCaseMap.put(cs.Id,cs);
       // calling your sendmail method 
       CaseForIndivisualEmail cse=new CaseForIndivisualEmail();
       CaseForIndivisualEmail.sendemail( myCaseMap );
    }
}