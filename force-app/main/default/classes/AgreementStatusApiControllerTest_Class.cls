@IsTest(seeAllData=true)
public class AgreementStatusApiControllerTest_Class {
 public static testMethod void validate(){
     List<Lead> lstLead = new List<Lead>();

        List<Lead> lstAccount= new List<Lead>();
        for(Integer i=0 ;i <200;i++)
        {
            Lead acc = new Lead();
            acc.LastName ='LastName'+i;
            acc.Pan_no__c='1234567'+i;
            acc.GST_No__c='1234567890'+i;
            acc.RBI_Certificate_No__c='1234567890'+i;
            acc.GST_State__c='Maharastra'+i;
            acc.Company = 'T'+i;
            acc.Status = 'New';
            acc.LegalDesk_Agreement_Document_Id__c = '123' + i;
            lstLead.add(acc);
        }
        insert lstAccount;

Test.startTest();
   if (test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new AgreementStatusApiMOCK());
Database.executeBatch(new AgreementStatusApiController());
Test.stopTest();

 }
 public static testMethod void validate1(){
     List<Lead> lstLead = new List<Lead>();

        List<Lead> lstAccount= new List<Lead>();
        for(Integer i=0 ;i <200;i++)
        {
            Lead acc = new Lead();
            acc.LastName ='LastName'+i;
            acc.Pan_no__c='1234567'+i;
            acc.GST_No__c='1234567890'+i;
            acc.RBI_Certificate_No__c='1234567890'+i;
            acc.GST_State__c='Maharastra'+i;
            acc.Company = 'T'+i;
            acc.Status = 'New';
            acc.LegalDesk_Agreement_Document_Id__c = '123' + i;
            lstLead.add(acc);
        }
        insert lstAccount;

Test.startTest();
   if (test.isRunningTest()) Test.setMock(HttpCalloutMock.class, new AgreementStatusApiMOCK1());
Database.executeBatch(new AgreementStatusApiController());
Test.stopTest();

 }
}