@IsTest
public class AgreementAPICheckTest_Class {
 public static testMethod void validate(){
     List<Lead> accList = new List<Lead>();
for (Integer i=0;i<200;i++) {
Lead m = new Lead (LastName = 'Amjad',Pan_no__c='1234567',GST_No__c='1234567890',RBI_Certificate_No__c='1234567890',
                   GST_State__c='Maharastra' + i);

accList.add(m);
}
insert accList;
Test.startTest();
AgreementAPICheck c = new AgreementAPICheck();
c.Cancel();
Test.stopTest();

 }
}