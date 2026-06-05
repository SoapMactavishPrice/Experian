@isTest
public class UpdateContactSitePageTest {

    @isTest
    public static void test1() {
        
        Account acc = new Account(
            Name = 'Finesse IT Labs Pvt Ltd',
            Member_Status__c = 'Active');
        insert acc;
        
        Contact authContact = new Contact(
            AccountId = acc.Id,
            LastName = 'Zagade',
            FirstName = 'Aditya',
            Salutation = 'Mr.',
            Email = 'aditya.zagade@finessedirect.com',
            Contact_Role__c = 'Authorized User Id');
        insert authContact;
        
        Contact nodalContact1 = new Contact(
            AccountId = acc.Id,
            LastName = 'Prajapati',
            FirstName = 'Balram',
            Salutation = 'Mr.',
            Email = 'balram@finessedirect.com',
            Contact_Role__c = 'Nodal Officer');
        insert nodalContact1;
        
        Contact nodalContact2 = new Contact(
            AccountId = acc.Id,
            LastName = 'Prajapati',
            FirstName = 'Balram',
            Salutation = 'Mr.',
            Email = 'balram.prajapati@finessedirect.com',
            Contact_Role__c = 'Nodal Officer');
        insert nodalContact2;
        
        ApexPages.currentPage().getParameters().put('recordId', authContact.Id);
        
        Test.startTest();
        
        String json = '{"Salutation":"Mr.","FirstName":"Aditya","LastName":"Zagade","Company":"Finesse IT Labs","Email":"aditya.zagade@finessedire.com","Personal_Email":"","Alternate_Mobile":"","Mobile":"+911234567890"}';
        UpdateContactSitePage.updateAWPLead(json, authContact.Id);
        
        authContact.Update_Contact_Link_Sent_Date__c = System.today().addDays(-20);
        update authContact;
        UpdateContactSitePage ucsp = new UpdateContactSitePage();
        
        Test.stopTest();
    }
    
}