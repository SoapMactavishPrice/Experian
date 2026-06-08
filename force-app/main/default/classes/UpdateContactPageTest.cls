@isTest
public class UpdateContactPageTest {

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
        
        ApexPages.StandardController sc = new ApexPages.StandardController(authContact);
        UpdateContactPage updateContactPage = new UpdateContactPage(sc);
    
        updateContactPage.send(); 
        
        
    }
    
}