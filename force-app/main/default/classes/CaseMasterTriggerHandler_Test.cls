@isTest
public class CaseMasterTriggerHandler_Test {
    
    @isTest
    public static void validate(){
        
        Case_Type__c casetype = new Case_Type__c();
        casetype.Case_Category__c = 'Consumer';
        casetype.Name ='Complaint Dispute Consumer';
        casetype.Case_Complaint__c = 'Report';
        insert casetype;
        
        Sub_Type__c	 subtype =new Sub_Type__c();
        subtype.Name = 'Demographic Details';
        subtype.Case_Type__c = casetype.Id;
        insert subtype;
        
        Sub_Type1__c subtype1 = new Sub_Type1__c();
        subtype1.Name = 'Incorrect Name';
        subtype1.Sub_Type__c = subtype.Id;
        insert subtype1;
        
        Sub_Type1__c subtype2 = new Sub_Type1__c();
        subtype2.Name = 'Matching - Incorrect Name';
        subtype2.Sub_Type__c = subtype.Id;
        insert subtype2;
        
        Account acc = new Account();
        acc.Name = 'State Bank of India';
        acc.Email_1_Dispute__c = 'abc@gmail.com';
        acc.Member_Status__c = 'Active';
        insert acc;
        
        Contact cn = new Contact();
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Contact_Role__c = 'Consumer';
        cn.Email = 'tsetas@gmail.com';
        insert cn;
        
        test.startTest();
        
        Case cs = new Case();
        cs.AccountId = acc.id;
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Report';
        cs.Case_Type_Lookup__c = casetype.Id;
        cs.Sub_Type_Lookup__c = subtype.Id;
        cs.Sub_Type_1_Lookup__c= subtype1.Id;
        cs.Origin = 'Portal';
        cs.Status = 'Open';
        cs.Displayed_Account_number__c = '12';
        cs.Correct_Account_number__c = '12';
        cs.Displayed_Bank_Name__c = 'State Bank of India';
        cs.Displayed_Account_number__c = '1234';
        cs.Name_of_Consumer__c = cn.Id;
        cs.Displayed_Address__c = 'rajasthan';
        insert cs;
    }
}