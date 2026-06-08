@isTest
public class UpdateResolvedStatus_Batch_Test {
    @isTest
    public static void isValidate(){
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
        
        Account acc = new Account();
        acc.Name = 'Experian India Pvt Ltd';
        acc.Instant_Reports__c  = true;
        acc.Email_Dispute__c='abc@gmail.com';
        acc.Email_1_Dispute__c='efg@gmail.com';
        acc.Email_2_Dispute__c='e@gmail.com';
        acc.Email_3_Dispute__c='p@gmail.com';
        acc.Email_4_Dispute__c='a@gmail.com';
        acc.Email_5_Dispute__c='b@gmail.com';
        acc.Email_6_Dispute__c='c@gmail.com';
        // Add other info on account which is requred to create it.
        insert acc;
        
        Contact cn = new Contact();
        cn.AccountId = acc.id;
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Fax = '1234567';
        cn.Contact_Role__c = 'Consumer';
        cn.Email = 'tsetas@gmail.com';
        cn.Birthdate=system.today();
        
        insert cn;
        
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Balance Issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Current Balance';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
                Case cs1 = new Case();
        cs1.Name_of_Consumer__c =cn.Id; 
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs1.Status = 'Open';
        cs1.AccountId = acc.id;
        cs1.Subject = 'UpdateId';
        cs1.Case_Category__c = 'Consumer';
        cs1.Case_Complaints__c = 'Call Center';
        cs1.Case_Type__c='Dispute';
        cs1.Sub_Type__c='Account Status';
        cs1.Sub_Type_1__c='Active';
        cs1.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs1.Account_s_Parent_Case__c = false;
        cs1.Origin='Portal';
        
        cs1.Case_Type_Lookup__c = ct.Id;
        cs1.Sub_Type_Lookup__c = stl1.id;
        cs1.Sub_Type_1_Lookup__c= st1.Id;
        cs1.Displayed_Loan_Balance__c = 0;
        //cs.Name_of_Consumer__c =cn.Id; 
        cs1.Displayed_Bank_Name__c = 'abc';
        cs1.Displayed_Account_number__c = '1234';
        cs1.status ='Open';
        //cs1.Forward_to_bank__c = false;
        insert cs1;
        
        Case cs = new Case();
        cs.Name_of_Consumer__c =cn.Id; 
        cs.Parent_Case__c = cs1.Id;
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        //cs.Consumer_Dispute_Status__c='Resolved in favour of the Consumer';
        cs.AccountId = acc.id;
        cs.Subject = 'UpdateId';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type__c='Dispute';
        cs.Sub_Type__c='Account Status';
        cs.Sub_Type_1__c='Active';
        cs.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs.Account_s_Parent_Case__c = false;
        
        cs.Origin = 'Portal';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl1.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Displayed_Loan_Balance__c = 0;
        //cs.Name_of_Consumer__c =cn.Id; 
        cs.Displayed_Bank_Name__c = 'abc';
        cs.Displayed_Account_number__c = '1234';
        cs.status ='Open';
        cs.Forward_to_bank__c = false;
        insert cs;
        
        UpdateResolvedStatus_Batch csf = new UpdateResolvedStatus_Batch();
        Database.executeBatch(csf,10);
    }
    
    
    @isTest
    public static void isValidate2(){
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
        
        Account acc = new Account();
        acc.Name = 'Experian India Pvt Ltd';
        acc.Instant_Reports__c  = true;
        acc.Email_Dispute__c='abc@gmail.com';
        acc.Email_1_Dispute__c='efg@gmail.com';
        acc.Email_2_Dispute__c='e@gmail.com';
        acc.Email_3_Dispute__c='p@gmail.com';
        acc.Email_4_Dispute__c='a@gmail.com';
        acc.Email_5_Dispute__c='b@gmail.com';
        acc.Email_6_Dispute__c='c@gmail.com';
        // Add other info on account which is requred to create it.
        insert acc;
        
        Contact cn = new Contact();
        cn.AccountId = acc.id;
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Fax = '1234567';
        cn.Contact_Role__c = 'Consumer';
        cn.Email = 'tsetas@gmail.com';
        cn.Birthdate=system.today();
        
        insert cn;
        
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Balance Issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'over due';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
                Case cs1 = new Case();
        cs1.Name_of_Consumer__c =cn.Id; 
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs1.Status = 'Open';
        cs1.AccountId = acc.id;
        cs1.Subject = 'UpdateId';
        cs1.Case_Category__c = 'Consumer';
        cs1.Case_Complaints__c = 'Call Center';
        cs1.Case_Type__c='Dispute';
        cs1.Sub_Type__c='Account Status';
        cs1.Sub_Type_1__c='Active';
        cs1.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs1.Account_s_Parent_Case__c = false;
        
        cs1.Origin = 'Portal';
        cs1.Case_Type_Lookup__c = ct.Id;
        cs1.Sub_Type_Lookup__c = stl1.id;
        cs1.Sub_Type_1_Lookup__c= st1.Id;
        cs1.Displayed_Loan_Balance__c = 0;
        //cs.Name_of_Consumer__c =cn.Id; 
        cs1.Displayed_Bank_Name__c = 'abc';
        cs1.Displayed_Account_number__c = '1234';
        cs1.status ='Open';
        //cs1.Forward_to_bank__c = false;
        insert cs1;
        
        Case cs = new Case();
        cs.Name_of_Consumer__c =cn.Id; 
        cs.Parent_Case__c = cs1.Id;
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        //cs.Consumer_Dispute_Status__c='Resolved in favour of the Consumer';
        cs.AccountId = acc.id;
        cs.Subject = 'UpdateId';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type__c='Dispute';
        cs.Sub_Type__c='Account Status';
        cs.Sub_Type_1__c='Active';
        cs.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs.Account_s_Parent_Case__c = false;
        
        cs.Origin = 'Portal';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl1.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Displayed_Overdue_Amount__c = 0;
        //cs.Name_of_Consumer__c =cn.Id; 
        cs.Displayed_Bank_Name__c = 'abc';
        cs.Displayed_Account_number__c = '1234';
        cs.status ='Open';
        cs.Forward_to_bank__c = false;
        insert cs;
        
        
        
        cs = new Case();
        cs.Name_of_Consumer__c =cn.Id; 
        cs.Parent_Case__c = cs1.Id;
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        //cs.Consumer_Dispute_Status__c='Resolved in favour of the Consumer';
        cs.AccountId = acc.id;
        cs.Subject = 'UpdateId';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type__c='Dispute';
        cs.Sub_Type__c='Account Status';
        cs.Sub_Type_1__c='Active';
        cs.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs.Account_s_Parent_Case__c = false;
        
        cs.Origin = 'Portal';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl1.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Displayed_Overdue_Amount__c = 0;
        //cs.Name_of_Consumer__c =cn.Id; 
        cs.Displayed_Bank_Name__c = 'abc';
        cs.Displayed_Account_number__c = '1234';
        cs.status ='Open';
        cs.Forward_to_bank__c = false;
        try{
        insert cs;
        }catch(exception e){}
        
        
        UpdateResolvedStatus_Batch csf = new UpdateResolvedStatus_Batch();
        Database.executeBatch(csf,10);
    }
    
    
     @isTest
    public static void isValidate3(){
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
        
        Account acc = new Account();
        acc.Name = 'Finesse IT Labs Pvt Ltd';
        acc.Instant_Reports__c  = true;
        acc.Email_Dispute__c='abc@gmail.com';
        acc.Email_1_Dispute__c='efg@gmail.com';
        acc.Email_2_Dispute__c='e@gmail.com';
        acc.Email_3_Dispute__c='p@gmail.com';
        acc.Email_4_Dispute__c='a@gmail.com';
        acc.Email_5_Dispute__c='b@gmail.com';
        acc.Email_6_Dispute__c='c@gmail.com';
        // Add other info on account which is requred to create it.
        insert acc;
        
        Contact cn = new Contact();
        cn.AccountId = acc.id;
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Fax = '1234567';
        cn.Contact_Role__c = 'Consumer';
        cn.Email = 'tsetas@gmail.com';
        cn.Birthdate=system.today();
        
        insert cn;
        
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'Report';
        insert ct;
        
        
        
        
        Sub_Type__c stl1=new Sub_Type__c();
        stl1.Name='Account Status';
        stl1.Case_Type__c=ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Active';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        
        Sub_Type1__c st2 = new Sub_Type1__c();
        st2.Name = 'Closed';
        st2.Sub_Type__c = stl1.Id;
        insert st2;
        
                Case cs1 = new Case();
        cs1.Name_of_Consumer__c =cn.Id; 
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs1.Status = 'Open';
        cs1.AccountId = acc.id;
        cs1.Subject = 'UpdateId';
        cs1.Case_Category__c = 'Consumer';
        cs1.Case_Complaints__c = 'Report';
        cs1.Case_Type__c='Dispute';
        cs1.Sub_Type__c='Account Status';
        cs1.Sub_Type_1__c='Active';
        cs1.Sub_Type_Status__c ='Notify to Bank';
        //cs.Owner.Name = 'Bank Team';
        cs1.Account_s_Parent_Case__c = false;
        
        cs1.Origin = 'Portal';
        cs1.Case_Type_Lookup__c = ct.Id;
        cs1.Sub_Type_Lookup__c = stl1.id;
        cs1.Sub_Type_1_Lookup__c= st1.Id;
        cs1.Displayed_Loan_Balance__c = 0;
        //cs.Name_of_Consumer__c =cn.Id; 
        cs1.Displayed_Bank_Name__c = 'abc';
        cs1.Displayed_Account_number__c = '1234';
        cs1.status ='Open';
        cs1.Displayed_Account_Status__c = 'Closed';
        //cs1.Forward_to_bank__c = false;
        insert cs1;
        
        
        
        UpdateResolvedStatus_Batch csf = new UpdateResolvedStatus_Batch();
        Database.executeBatch(csf,10);
    }

}