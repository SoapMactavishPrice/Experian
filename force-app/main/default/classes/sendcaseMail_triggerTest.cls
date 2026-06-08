@isTest
public class sendcaseMail_triggerTest{
    
  public static testMethod void sendMail(){
  
       Account acc = new Account();
           acc.Name = 'Kabib';
           acc.Instant_Reports__c  = true; 
       insert acc; 
       
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
        
       Case cs = new Case();
       //cs.RecordTypeId='0126D000000hc2GQAQ';
       cs.Displayed_Loan_Balance__c =Decimal.valueof(5000);
       cs.Displayed_EMI_Amount__c =Decimal.valueof(9000);
       cs.Status = 'Open';
       cs.AccountId = acc.id;
       cs.Subject = 'Update';
       cs.Case_Category__c = 'Consumer';
       cs.Case_Complaints__c = 'Correct details on credit report';
       cs.Case_Type__c='Dispute';
       cs.Sub_Type__c='Account Status';
       cs.Sub_Type_1__c='Active';
       cs.Sub_Type_Status__c ='Notify to Bank';
       //cs.Forward_to_bank__c=true;
       //cs.Name_of_Consumer__r.BirthDate =  Date.newInstance(2020 , 10 ,20);
       //cs.Contact.Birthdate=cn.Birthdate;
       //cs.Account.Instant_Reports__c = acc.Instant_Reports__c;
       cs.Origin = 'Web';
       //cs.OwnerId='00G6D000001rpbg';
       // Add other info on case which is requred to create it.
       insert cs;

       cs.Forward_to_bank__c=true;
       update cs;
       
       cs.Displayed_Address__c ='andhi Nagar';
       update cs;
       
       }
     

}