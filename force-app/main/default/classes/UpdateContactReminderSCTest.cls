@isTest
public class UpdateContactReminderSCTest {
    
    @isTest
    public static void test1() {
        
        Account acc = new Account(
            Name = 'Finesse IT Labs Pvt Ltd',
            Member_Status__c = 'Active');
        insert acc;
        
        Contact authContact1 = new Contact(
            AccountId = acc.Id,
            LastName = 'Zagade',
            FirstName = 'Aditya',
            Salutation = 'Mr.',
            Email = 'aditya.zagade@finessedirect.com',
            Contact_Role__c = 'Authorized User Id');
        insert authContact1;
        
        Contact authContact2 = new Contact(
            AccountId = acc.Id,
            LastName = 'Zagade',
            FirstName = 'Aditya',
            Salutation = 'Mr.',
            Email = 'aditya.zagade@finessedirect.com',
            Contact_Role__c = 'Authorized User Id');
        insert authContact2;
        
        Contact authContact3 = new Contact(
            AccountId = acc.Id,
            LastName = 'Zagade',
            FirstName = 'Aditya',
            Salutation = 'Mr.',
            Update_Contact_Link_Sent__c = true,
            Email = 'aditya.zagade@finesseme.com',
            Contact_Role__c = 'Authorized User Id');
        insert authContact3;
        
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
            Email_2__c = 'balram.prajapati@finessedirect.com',
            Contact_Role__c = 'Nodal Officer');
        insert nodalContact2;
        
        Test.startTest();
         System.schedule('Reminder', '0 0 12 * * ? *', new UpdateContactReminderSC());
        Test.stopTest();
        
    }
    
}