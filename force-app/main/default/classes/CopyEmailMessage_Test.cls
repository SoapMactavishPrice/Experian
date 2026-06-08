@isTest
public class CopyEmailMessage_Test {
    
    @isTest
    public static void test1() {
        
        test.startTest();
        Account acc = new Account(
            Name = 'Finesse IT Labs Pvt Ltd2',
            Member_Status__c = 'Active',
            Email_1_Dispute__c = 'aditya.zagade@finessedirect.com');
        insert acc;
        
        Contact con = new Contact(
            AccountId = acc.Id,
            LastName = 'Zagade',
            FirstName = 'Aditya',
            Salutation = 'Mr.',
            Email = 'aditya.zagade@finessedirect.com',
            Contact_Role__c = 'Consumer');
        insert con;
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Balance';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Current Balance';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        Case cs = new Case();
        cs.AccountId = acc.Id;
        cs.status = 'Open';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl1.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Case_Origin_2__c = 'RBI';
        cs.RBI_Complaint_Number__c = '1234567';
        cs.Send_Mail_for_RBI_Complaint__c = true;
        cs.RBI_Complaint_Number__c = '1234567';
        cs.Displayed_Account_number__c = '1234567890';
        cs.Displayed_Bank_Name__c = 'HDFC';
        cs.Name_of_Consumer__c = con.Id;
        cs.Displayed_Account_number__c ='SBI122';
        cs.Displayed_Bank_Name__c = 'SBI';
        cs.Dispute_Detail__c ='test';
        cs.Dispute_Raised_Date__c=system.today();
        cs.Date_of_the_email_received__c =system.today();
        insert cs;
        
        cs.Send_Email_to_Consumer__c =true;
        update cs;
        
        cs.Forward_to_bank__c = true;
        update cs;
        
        EmailMessage em=new EmailMessage();
        em.RelatedToId = cs.Id;
        em.Subject='Dispute Email to Consumer';
        em.ToAddress='balram@finessedirect.com';
        em.MessageDate=system.now();
        em.Incoming=false;
        em.Status='3';
        em.TextBody ='text body';
        em.Email_Body__c ='';
        insert em;   
        update em;  
        
        system.debug('78--->'+[select id,Sub_Type_Name__c, Sub_Type_Lookup__r.Name from Case where Id=:cs.Id]);        
        
        EmailMessage em1=new EmailMessage();
        em1.RelatedToId = cs.Id;
        em1.Subject='Correct Details - Follow with Financial Institution';
        em1.ToAddress='balram@finessedirect.com';
        em1.MessageDate=system.now();
        em1.Incoming=false;
        em1.Status='3';
        insert em1;   
        update em1;   
        
        EmailMessage em2=new EmailMessage();
        em2.RelatedToId = cs.Id;
        em2.Subject='Dispute resolved in your favour';
        em2.ToAddress='balram@finessedirect.com';
        em2.MessageDate=system.now();
        em2.Incoming=false;
        em2.Status='3';
        insert em2;   
        update em2;  
        
        EmailMessage em3=new EmailMessage();
        em3.RelatedToId = cs.Id;
        em3.Subject='Forward to Bank';
        em3.ToAddress='balram@finessedirect.com';
        em3.MessageDate=system.now();
        em3.Incoming=false;
        em3.Status='3';
        em3.TextBody ='text body';
        em3.Email_Body__c ='';
        insert em3;   
        update em3; 
        
        test.stopTest();        
    }
    
    @isTest
    public static void testv2() {
        test.startTest();
       
        Account acc = new Account(
            Name = 'Finesse IT Labs Pvt Ltd1',
            Member_Status__c = 'Active',
            Email_1_Dispute__c = 'aditya.zagade@finessedirect.com');
        insert acc;
        
        Contact con = new Contact(
            AccountId = acc.Id,
            LastName = 'Zagade',
            FirstName = 'Aditya',
            Salutation = 'Mr.',
            Email = 'aditya.zagade@finessedirect.com',
            Contact_Role__c = 'Consumer',
            Dispute_Member_Count__c = 1,
            Birthdate = system.today().addDays(-543)
        );
        insert con;
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'Report';
        insert ct;
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Demographic Details';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Incorrect DOB';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        Case cs = new Case();
        cs.AccountId = acc.Id;
        cs.status = 'Open';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Report';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl1.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Case_Origin_2__c = 'RBI';
        cs.RBI_Complaint_Number__c = '1234567';
        cs.Send_Mail_for_RBI_Complaint__c = true;
        cs.RBI_Complaint_Number__c = '1234567';
        cs.Displayed_Account_number__c = '1234567890';
        cs.Displayed_Bank_Name__c = 'HDFC';
        cs.Name_of_Consumer__c = con.Id;
        cs.Displayed_Account_number__c ='SBI122';
        cs.Displayed_Bank_Name__c = 'SBI';
        cs.Dispute_Detail__c ='test';
        cs.Dispute_Raised_Date__c=system.today();
        cs.Date_of_the_email_received__c =system.today();
        insert cs;
        
        cs.Send_Email_to_Consumer__c =true;
        update cs;
        
        cs.Forward_to_bank__c = true;
        update cs;
        
        system.debug('--->'+[select id,Sub_Type_Name__c, Sub_Type_Lookup__r.Name from Case where Id=:cs.Id]);
        
        EmailMessage em=new EmailMessage();
        em.RelatedToId = cs.Id;
        em.Subject='Forward to Bank';
        em.ToAddress='balram@finessedirect.com';
        em.MessageDate=system.now();
        em.Incoming=false;
        em.Status='3';
        em.TextBody ='text body';
        em.Email_Body__c ='';
        insert em;   
        update em; 
        
        test.stopTest();
        
    }
}