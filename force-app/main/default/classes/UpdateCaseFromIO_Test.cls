@isTest
public class UpdateCaseFromIO_Test {
    
    @isTest    
    public static void testNoChange(){
        
        Account acc = new Account();
        acc.Name = 'Kabib';
        insert acc; 
        
        Contact cn = new Contact();
        cn.AccountId = acc.id;
        cn.FirstName = 'Aj';
        cn.LastName = 'style';
        cn.Phone = '1234567890';
        cn.Contact_Role__c = 'Consumer';
        cn.Email = 'tsetas@gmail.com';
        insert cn;
        
        Case_Type__c ct = new Case_Type__c();
        ct.Name = 'Query';
        ct.Case_Category__c = 'Consumer';
        ct.Case_Complaint__c = 'Report';
        Insert ct;
        
        Sub_Type__c st = new Sub_Type__c();
        st.Name = 'Status of Dispute';
        st.Case_Type__c = ct.id;
        st.isActive__c = true;
        Insert st;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Duplicate';
        st1.Sub_Type__c = st.id;
        st1.isActive__c = true;
        Insert st1;
        
        Case cs = new Case();
        cs.Displayed_Loan_Balance__c =Decimal.valueof(5000);
        cs.Displayed_EMI_Amount__c =Decimal.valueof(9000);
        cs.Status = 'Open';
        //cs.OwnerId=u_a.id;
        cs.Name_of_Consumer__c = cn.id;
        cs.AccountId = acc.id;
        cs.Subject = 'Update';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = null;
        cs.Origin = 'Email';
        cs.Consumer_Dispute_Status__c= 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Experian';
        insert cs;
        
        IO_Comments__c io = new IO_Comments__c();
        io.Case__c = cs.id;
        io.Status__c = 'Seeking Further Information - Member';
        io.IO_Comments__c = 'all good';
        insert io;
        
        IO_Comments__c io2 = new IO_Comments__c();
        io2.Case__c = cs.id;
        io2.Status__c = 'Seeking Further Information - Consumer';
        io2.IO_Comments__c = 'all good';
        insert io2;
        
    }
}