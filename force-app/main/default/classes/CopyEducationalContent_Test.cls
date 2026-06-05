@isTest
public class CopyEducationalContent_Test {
	@isTest
    public static void validate(){
        
        Educational_Content__c edu = new Educational_Content__c();
        edu.Content__c = 'Loans – Credit Awareness';
        insert edu;
        
        Case_Type__c ct1 = new Case_Type__c();
        ct1.Name = 'Query';
        ct1.Case_Category__c = 'Consumer';
        ct1.Case_Complaint__c = 'Report';
        Insert ct1;
        
        Sub_Type__c st12 = new Sub_Type__c();
        st12.Name = 'Status of Dispute';
        st12.Case_Type__c = ct1.id;
        st12.isActive__c = true;
        Insert st12;
        
        Sub_Type1__c st21 = new Sub_Type1__c();
        st21.Name = 'Duplicate';
        st21.Sub_Type__c = st12.id;
        st21.isActive__c = true;
        Insert st21;
        
        State__c stat = new State__c();
        stat.Name ='Delhi';
        insert stat;
        
        State__c stat1 = new State__c();
        stat1.Name ='Andhra Pradesh';
        insert stat1;
        
        State__c stat2 = new State__c();
        stat2.Name ='Chandigarh';
        insert stat2;
        
        State__c stat3 = new State__c();
        stat3.Name ='Karnataka';
        insert stat3;
        
        State__c stat4 = new State__c();
        stat4.Name ='Gujarat';
        insert stat4;
        
        Account acc = new Account();
        acc.Name = 'Karur Vysya Bank Ltd (T1)';
        acc.Instant_Reports__c  = true;
        // Add other info on account which is requred to create it.
        acc.Email_1_Dispute__c = 'adfg@dfdg.com';
        acc.Email_2_Dispute__c = 'adfg@dfdg.com';
        acc.Email_3_Dispute__c = 'adfg@dfdg.com';
        acc.Email_4_Dispute__c = 'adfg@dfdg.com';
        acc.Email_5_Dispute__c = 'adfg@dfdg.com';
        acc.Email_6_Dispute__c = 'adfg@dfdg.com';
        acc.Email_Dispute__c = 'adfg@dfdg.com';
        acc.Member_Status__c = 'Active';
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
        
        Sub_Type__c   stl =new Sub_Type__c  ();
        stl.Name = 'Matching';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Account does not belong to me';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Credit Enquiry does not belong to me';
        st1.Sub_Type__c = stl.Id;
        insert st1;
        
        test.startTest();
        
         
        List<Case> csList = new List<Case>();
        //for(integer i = 0 ; i< 4 ;i++){
        Case cs = new Case();
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'Update Oracle Id';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st.Id;
        cs.Case_Type__c='Complaint';
        cs.Sub_Type__c='Document';
        cs.Sub_Type_1__c='Agreement not received';
        cs.Forward_to_bank__c=false;
        cs.Origin = 'Web';
        cs.Displayed_Account_number__c = '12';
        cs.Correct_Account_number__c = '12';
      //  cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Karur Vysya Bank Ltd';
        cs.Displayed_Account_number__c = '1234';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        cs.Send_Acknowledgement_SMS__c = true;
        cs.Send_Resolved_in_Favour_SMS__c = true;
        cs.Send_Resolved_not_in_Favour_SMS__c = true;
        cs.Displayed_Address__c = 'rajasthan';
        insert cs;
        
        
       
        cs.Copy_Educational_Content__c = true;
        update cs;
        
     
        
        
    }
}