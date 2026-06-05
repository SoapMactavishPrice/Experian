@isTest
public class SendConsumerDisputeEmail_Test {
    public static testMethod void beforeUpdate(){
        Case_Type__c ct12 = new Case_Type__c();
        ct12.Name = 'Query';
        ct12.Case_Category__c = 'Consumer';
        ct12.Case_Complaint__c = 'Report';
        Insert ct12;
        
        Sub_Type__c st12 = new Sub_Type__c();
        st12.Name = 'Status of Dispute';
        st12.Case_Type__c = ct12.id;
        st12.isActive__c = true;
        Insert st12;
        
        Sub_Type1__c st21 = new Sub_Type1__c();
        st21.Name = 'Duplicate';
        st21.Sub_Type__c = st12.id;
        st21.isActive__c = true;
        Insert st21;
        
        Sub_Type1__c st212 = new Sub_Type1__c();
        st212.Name = 'Re-raise';
        st212.Sub_Type__c = st12.id;
        st212.isActive__c = true;
        Insert st212;
        
        Account acc = new Account();
        acc.Name = 'Experian India Pvt Ltd';
        acc.Instant_Reports__c  = true;
        acc.Email_10_Dispute__c = 'abc@gmail.com';
        acc.Email_2_Dispute__c = 'abc@gmail.com';
        insert acc; 
        
        Contact authContact = new Contact(
            AccountId = acc.Id,
            LastName = 'Zagade',
            FirstName = 'Aditya',
            Salutation = 'Mr.',
            Email = 'aditya.zagade1234@finessedirect.com',
            Contact_Role__c ='Consumer');
        insert authContact;
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Balance Issue';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Current Balance';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        Case cs = new Case();
        cs.Status = 'Open';
        cs.Case_Complaints__c = 'Call Center';
        cs.AccountId = acc.id;
        cs.Subject = 'Update';
        cs.Case_Category__c = 'Consumer';
        cs.Origin = 'Portal';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st.Id;
        cs.Consumer_Dispute_Status__c= 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Experian';
        cs.Displayed_Bank_Name__c = '1234';
        cs.Displayed_Account_number__c = '1234567';
        cs.Name_of_Consumer__c = authContact.Id;
        cs.Date_of_the_email_received__c = date.today();
        cs.Dispute_Raised_Date__c = null;
        cs.Dispute_Detail__c = 'abc';
        cs.Send_Email_to_Consumer__c = false;
 insert cs;
        
        
         cs = new Case();
        cs.Status = 'Open';
        cs.Case_Complaints__c = 'Call Center';
        cs.AccountId = acc.id;
        cs.Subject = 'Update';
        cs.Case_Category__c = 'Consumer';
        cs.Origin = 'Portal';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st.Id;
        cs.Consumer_Dispute_Status__c= 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Experian';
        cs.Displayed_Bank_Name__c = '1234';
        cs.Displayed_Account_number__c = '1234567';
        cs.Name_of_Consumer__c = authContact.Id;
        cs.Date_of_the_email_received__c = date.today();
        cs.Dispute_Raised_Date__c = date.today();
        cs.Dispute_Detail__c = 'abc';
        cs.Send_Email_to_Consumer__c = false;
        insert cs;
        
        //cs.Send_Email_to_Consumer__c = true;
        //update cs;
        
        SendConsumerDisputeEmail batch = new SendConsumerDisputeEmail();
        Database.executeBatch(batch,10);
    }
    
}