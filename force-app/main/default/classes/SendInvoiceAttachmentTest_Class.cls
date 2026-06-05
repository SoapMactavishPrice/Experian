@IsTest(SeeAllData=true)
public class SendInvoiceAttachmentTest_Class {
 static testMethod void testMethod1() 
    {
        test.startTest();
        Account a = new Account(name='xxyyyx');
        upsert a;
        Contact c = new Contact(AccountId=a.id,LastName='yyyyxxxzzz',Contact_Role__c='Nodal Officer',Email='testasdd@gmail.com');
        upsert c;
        Invoice__c i = new Invoice__c(Name='zzzzyyyzaaa',Account__c=a.Id);
        upsert i;
        PageReference pgRef = Page.SendInvoiceAttachment; //Create Page Reference - 'Appt_New' is the name of Page
     Test.setCurrentPage(pgRef); //Set the page for Test Method       
        ApexPages.currentPage().getParameters().put('id', i.id);

        SendInvoiceAttachment s = new SendInvoiceAttachment();
        s.currentRecordId = i.id;
        s.a=a;
        s.c=c;
        s.inv=i;
        s.Send();
        
        
        test.stopTest();
    } 
}