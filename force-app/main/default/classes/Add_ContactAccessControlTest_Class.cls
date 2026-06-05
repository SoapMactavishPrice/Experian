@IsTest
public class Add_ContactAccessControlTest_Class {
 public static testMethod void validate(){
     Account a = new Account();
     a.Name = 'Test';
     Insert a;
     
     Contact c = new Contact();
     c.AccountId = a.id;
     c.LastName = 'Test';
     Insert c;
     
     Contact_Access_Control__c ca = new Contact_Access_Control__c();
     ca.Contact_Name__c = c.id;
     Insert ca;
     
     PageReference pgRef = Page.Add_ContactAccessControlPage; //Create Page Reference - 'Appt_New' is the name of Page
     Test.setCurrentPage(pgRef); //Set the page for Test Method
     ApexPages.currentPage().getParameters().put('id',  ca.Contact_Name__c );
    try{
     Add_ContactAccessControl ac = new Add_ContactAccessControl();
     ac.currentRecID =  ca.Contact_Name__c ;
     ac.rowIndex = 1;
     ac.addRow();
     ac.Cancel(); 
     ac.saveAccount();
     ac.deleteRow();
    } Catch(Exception e){}
 }
}