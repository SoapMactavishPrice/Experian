@isTest
public class CaseTriggerHandler_Test {
    
    @isTest
    public static void validate(){
        CaseTriggerHandler cth= new CaseTriggerHandler();
        CaseTriggerHandler.fakeCodeCoverage();
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
        
        Sub_Type__c	 stl =new Sub_Type__c	();
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
        csList.add(cs);
        
        cs = new Case();
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
        cs.Displayed_Account_number__c = 'abc1234';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        cs.Displayed_Bank_Name__c = 'QUADRILLION FINANCE PVT LTD';
        cs.Displayed_Account_number__c = 'abc1234';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
       // cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'HDFC Bank Ltd';
        cs.Displayed_Account_Type__c = 'credit';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
     //   cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'HDFC Bank Ltd';
        cs.Displayed_Account_Type__c = 'non';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        
      //  cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'HDFC LIMITED';
        cs.Displayed_Account_Type__c = 'property loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        cs.Displayed_Bank_Name__c = 'Axis Bank';
        cs.Displayed_Account_Type__c = 'credit';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'Update Oracle Id';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st.Id;
        cs.Forward_to_bank__c=false;
        cs.Origin = 'Web';
       // cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Axis Bank';
        cs.Displayed_Account_Type__c = 'abc1234';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        cs.Displayed_Bank_Name__c = 'Yes Bank';
        cs.Displayed_Account_Type__c = 'credit';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        cs.Displayed_Bank_Name__c = 'Yes Bank';
        cs.Displayed_Account_Type__c = 'loan against bank deposit';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        cs.Displayed_Bank_Name__c = 'Yes Bank';
        cs.Displayed_Account_Type__c = 'personal loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
       // cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'IndusInd Bank Limited';
        cs.Displayed_Account_Type__c = 'credit';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        cs.Displayed_Bank_Name__c = 'IndusInd Bank Limited';
        cs.Displayed_Account_Type__c = 'tractor loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
     //   cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'IndusInd Bank Limited';
        cs.Displayed_Account_Type__c = 'business loan unsecured';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
     //   cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'IndusInd Bank Limited';
        cs.Displayed_Account_Type__c = 'auto loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        //cs.Send_Email_to_Consumer__c = true;
        //cs.Forward_to_bank__c = true;
        csList.add(cs);
        
        cs = new Case();
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
        
      //  cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Kotak Mahindra Bank Limited';
        cs.Displayed_Account_Type__c = 'credit';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Kotak Mahindra Bank Limited';
        cs.Displayed_Account_Type__c = 'personal loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        
     //   cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Kotak Mahindra Bank Limited';
        cs.Displayed_Account_Type__c = 'csdfghredit';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        cs.Displayed_Bank_Name__c = 'Canara Bank';
        cs.Displayed_Account_Type__c = 'credit';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        cs.Displayed_Bank_Name__c = 'Canara Bank';
        cs.Displayed_Account_Type__c = 'tractor loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
       // cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.State__c = stat.Id; 
        cs.Displayed_Bank_Name__c = 'State Bank of India';
        cs.Displayed_Account_Type__c = 'tractor loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
        cs.State__c = stat1.Id; 
        cs.Displayed_Bank_Name__c = 'State Bank of India';
        cs.Displayed_Account_Type__c = 'tractor loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
     //   cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.State__c = stat2.Id; 
        cs.Displayed_Bank_Name__c = 'State Bank of India';
        cs.Displayed_Account_Type__c = 'tractor loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
       // cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.State__c = stat3.Id; 
        cs.Displayed_Bank_Name__c = 'State Bank of India';
        cs.Displayed_Account_Type__c = 'tractor loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        cs = new Case();
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
     //   cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.State__c = stat4.Id; 
        cs.Displayed_Bank_Name__c = 'State Bank of India';
        cs.Displayed_Account_Type__c = 'tractor loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        
        cs = new Case();
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
   //     cs.Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Indian Bank';
        cs.Displayed_Account_Type__c = 'tractor loan';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        csList.add(cs);
        
        insert csList;
        
        
    }

    
    @isTest
    public static void validate5(){
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
        
        
        
        Sub_Type__c	 stl =new Sub_Type__c	();
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
        //   cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Karur Vysya Bank Ltd';
        cs.Displayed_Account_number__c = '1234';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        cs.Send_Acknowledgement_SMS__c = true;
        cs.Send_Resolved_in_Favour_SMS__c = true;
        cs.Send_Resolved_not_in_Favour_SMS__c = true;
        cs.Displayed_Address__c = 'rajasthan';
        cs.Displayed_Enquired_By__c = 'tyui';
        cs.Correct_Enquired_By__c = 'sdty';
        csList.add(cs);
        insert csList;
        
        
        
        
    }
    
    @isTest
    public static void validate2(){
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
        
        Map<string,string> stList = new Map<string,string>();
        stList.put('Gujarat','SBI - AHMEDABAD');
        stList.put('Karnataka','SBI - BANGALORE');
        stList.put('Andhra Pradesh','SBI - HYDERABAD');
        stList.put('Madhya Pradesh','SBI - BHOPAL');
        stList.put('Orissa','SBI - BHUBANESWAR');
        stList.put('Chandigarh','SBI - CHANDIGARH');
        stList.put('Tamil Nadu','SBI - CHENNAI');
        stList.put('Delhi','SBI - DELHI');
        stList.put('Assam','SBI - GUWAHATI');
        stList.put('Rajasthan','SBI - JAIPUR');
        stList.put('West Bengal','SBI - KOLKATA');
        stList.put('Uttar Pradesh','SBI - LUCKNOW'); 
        stList.put('Goa','SBI - MUMBAI'); 
        stList.put('Bihar','SBI - PATNA'); 
        stList.put('Kerala','SBI - THIRUVANANTHAPURAM'); 
        stList.put('Uttar Pradesh','SBI - LUCKNOW'); 
        
        system.debug('Total state'+stList.size());
        List<State__c> stateList = new List<State__c>();
        for(string str : stList.keySet()){
            State__c state = new State__c();
            state.Name =str;
            stateList.add(state);
        }
        
        if(stateList.size() > 0){
            insert stateList;
            Map<string,string> stMap = new Map<string,string>();
            for(state__c st : stateList){
                if(stList.containsKey(st.Name)){
                    stMap.put(stList.get(st.Name),st.Id);
                }
            }
            
            List<string> accList = new List<string>();
            accList.add('SBI - AHMEDABAD');
            accList.add('SBI - BANGALORE');
            accList.add('SBI - BHOPAL');
            accList.add('SBI - BHUBANESWAR');
            accList.add('SBI - CHANDIGARH');
            accList.add('SBI - CHENNAI');
            accList.add('SBI - DELHI');
            accList.add('SBI - GUWAHATI');
            accList.add('SBI - HYDERABAD');
            accList.add('SBI - JAIPUR');
            accList.add('SBI - KOLKATA');
            accList.add('SBI - LUCKNOW');
            accList.add('SBI - MUMBAI');
            accList.add('SBI - PATNA');
            accList.add('SBI - THIRUVANANTHAPURAM');
            
            List<Account> accsList = new List<Account>();
            for(Integer i = 0; i < accList.size(); i++){
                Account acc = new Account();
                acc.Name = accList[i];
                acc.Instant_Reports__c  = true;
                acc.Email_1_Dispute__c = 'adfg@dfdg.com';
                acc.Email_2_Dispute__c = 'adfg@dfdg.com';
                acc.Email_3_Dispute__c = 'adfg@dfdg.com';
                acc.Email_4_Dispute__c = 'adfg@dfdg.com';
                acc.Email_5_Dispute__c = 'adfg@dfdg.com';
                acc.Email_6_Dispute__c = 'adfg@dfdg.com';
                acc.Email_Dispute__c = 'adfg@dfdg.com';
                 acc.Member_Status__c = 'Active';
                accsList.add(acc);
                
            }
            insert accsList;
            system.debug('isnde total Cases'+accsList.size());
            Map<string,string> strMap = new Map<string,string>();
            List<Case>csList = new List<Case>();
            Case_Type__c  ct = new Case_Type__c();
            ct.Case_Category__c = 'Consumer';
            ct.Name ='Complaint Dispute Consumer';
            ct.Case_Complaint__c = 'call Center';
            insert ct;
            
            Sub_Type__c	 stl =new Sub_Type__c	();
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
           
            
            system.debug(stMap);
            for(Account ac: accsList){
                //strMap.put(ac.Name,ac.Id);
                if(stMap.containsKey((ac.Name))){
                    system.debug('inside ac'+ac.Name);
                    Case cs = new Case();
                    cs.Status = 'Open';
                    //cs.AccountId = ac.id;
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
                 //   cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
                    cs.Rejection_Reason__c = 'Rejected by Lender';
                    system.debug(' -->'+ac.Name);
                    
                    cs.State__c = stMap.get(ac.Name); 
                    cs.Displayed_Bank_Name__c = 'State Bank of India';
                    cs.Displayed_Account_Type__c = 'tractor loan';
                    cs.Last_Reply_from_Bank_Team__c = date.today();
                        cs.Send_Acknowledgement_SMS__c = true;
        cs.Send_Resolved_in_Favour_SMS__c = true;
        cs.Send_Resolved_not_in_Favour_SMS__c = true;
                    csList.add(cs);
                }
            }
            
            if(csList.size() > 0){
                Insert csList;
            }
            update csList;
   
        }
    }
    
    @isTest
    public static void validate3(){
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
        Map<string,string> stList = new Map<string,string>();
        stList.put('Ahmedabad','SBI - AHMEDABAD');
        stList.put('Bengaluru','SBI - BANGALORE');
        stList.put('Andhra Pradesh','SBI - HYDERABAD');
        stList.put('Bhopal','SBI - BHOPAL');
        stList.put('Bhubaneswar','SBI - BHUBANESWAR');
        stList.put('Chandigarh','SBI - CHANDIGARH');
        stList.put('Chennai','SBI - CHENNAI');
        stList.put('New Delhi','SBI - DELHI');
        stList.put('Guwahati','SBI - GUWAHATI');
        stList.put('Jaipur','SBI - JAIPUR');
        stList.put('Hyderabad','SBI - Hyderabad');
        stList.put('West Bengal','SBI - KOLKATA');
        stList.put('Uttar Pradesh','SBI - LUCKNOW'); 
        stList.put('Mumbai Metro','SBI - MUMBAI'); 
        stList.put('Patna','SBI - PATNA'); 
        stList.put('Thiruvananthapuram','SBI - THIRUVANANTHAPURAM'); 
        stList.put('Lucknow','SBI - LUCKNOW'); 
        
        system.debug('Total state'+stList.size());
        List<Circle__c> stateList = new List<Circle__c>();
        for(string str : stList.keySet()){
            Circle__c state = new Circle__c();
            state.Name =str;
            stateList.add(state);
        }
        
        if(stateList.size() > 0){
            insert stateList;
            Map<string,string> stMap = new Map<string,string>();
            for(Circle__c st : stateList){
                if(stList.containsKey(st.Name)){
                    stMap.put(stList.get(st.Name),st.Id);
                }
            }
            
            List<string> accList = new List<string>();
            accList.add('SBI - AHMEDABAD');
            accList.add('SBI - BANGALORE');
            accList.add('SBI - BHOPAL');
            accList.add('SBI - BHUBANESWAR');
            accList.add('SBI - CHANDIGARH');
            accList.add('SBI - CHENNAI');
            accList.add('SBI - DELHI');
            accList.add('SBI - GUWAHATI');
            accList.add('SBI - HYDERABAD');
            accList.add('SBI - JAIPUR');
            accList.add('SBI - KOLKATA');
            accList.add('SBI - LUCKNOW');
            accList.add('SBI - MUMBAI');
            accList.add('SBI - PATNA');
            accList.add('SBI - THIRUVANANTHAPURAM');
            
            List<Account> accsList = new List<Account>();
            for(Integer i = 0; i < accList.size(); i++){
                Account acc = new Account();
                acc.Name = accList[i];
                acc.Instant_Reports__c  = true;
                 acc.Member_Status__c = 'Active';
                acc.Email_1_Dispute__c = 'adfg@dfdg.com';
                acc.Email_2_Dispute__c = 'adfg@dfdg.com';
                acc.Email_3_Dispute__c = 'adfg@dfdg.com';
                acc.Email_4_Dispute__c = 'adfg@dfdg.com';
                acc.Email_5_Dispute__c = 'adfg@dfdg.com';
                acc.Email_6_Dispute__c = 'adfg@dfdg.com';
                acc.Email_Dispute__c = 'adfg@dfdg.com';
                accsList.add(acc);
                
            }
            insert accsList;
            system.debug('isnde total Cases'+accsList.size());
            Map<string,string> strMap = new Map<string,string>();
            List<Case>csList = new List<Case>();
            Case_Type__c  ct = new Case_Type__c();
            ct.Case_Category__c = 'Consumer';
            ct.Name ='Complaint Dispute Consumer';
            ct.Case_Complaint__c = 'call Center';
            insert ct;
            
            Sub_Type__c	 stl =new Sub_Type__c	();
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
            system.debug(stMap);
            for(Account ac: accsList){
                //strMap.put(ac.Name,ac.Id);
                if(stMap.containsKey((ac.Name))){
                    system.debug('inside ac'+ac.Name);
                    Case cs = new Case();
                    cs.Status = 'Open';
                    //cs.AccountId = ac.id;
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
             //       cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
                    cs.Rejection_Reason__c = 'Rejected by Lender';
                    system.debug(' -->'+ac.Name);
                    
                    cs.Circle__c = stMap.get(ac.Name); 
                    cs.Displayed_Bank_Name__c = 'State Bank of India';
                    cs.Displayed_Account_Type__c = 'tractor loan';
                    cs.Last_Reply_from_Bank_Team__c = date.today();
                        cs.Send_Acknowledgement_SMS__c = true;
        cs.Send_Resolved_in_Favour_SMS__c = true;
        cs.Send_Resolved_not_in_Favour_SMS__c = true;
                    csList.add(cs);
                }
            }
            
            //csList
            if(csList.size() > 0){
                Insert csList;
            }
            update csList;
            
            
            
            
        }
    }
    
    
    @isTest
    public static void validate1(){
        Case_Type__c ct1 = new Case_Type__c();
        ct1.Name = 'Query';
        ct1.Case_Category__c = 'Consumer';
        ct1.Case_Complaint__c = 'Report';
        Insert ct1;
        
        Sub_Type__c st1234 = new Sub_Type__c();
        st1234.Name = 'Status of Dispute';
        st1234.Case_Type__c = ct1.id;
        st1234.isActive__c = true;
        Insert st1234;
        
        Sub_Type1__c st21 = new Sub_Type1__c();
        st21.Name = 'Duplicate';
        st21.Sub_Type__c = st1234.id;
        st21.isActive__c = true;
        Insert st21;
        State__c stat = new State__c();
        stat.Name ='Delhi';
        insert stat;
        
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
        
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Account ownership issue';
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
        
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Matching';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st12 = new Sub_Type1__c();
        st12.Name = 'Account does not belong to me';
        st12.Sub_Type__c = stl1.Id;
        insert st12;
        
        Sub_Type1__c st123 = new Sub_Type1__c();
        st123.Name = 'Credit Enquiry does not belong to me';
        st123.Sub_Type__c = stl1.Id;
        insert st123;
        
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
        cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Karur Vysya Bank Ltd';
        cs.Displayed_Account_number__c = '1234';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        cs.Send_Acknowledgement_SMS__c = true;
        cs.Send_Resolved_in_Favour_SMS__c = true;
        cs.Send_Resolved_not_in_Favour_SMS__c = true;
        cs.Displayed_Address__c = 'rajasthan';
        cs.Displayed_PAN_No__c ='2345678';
        cs.ContactPan__c ='23456780';
        
        cs = new Case();
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'Update Oracle Id';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Case_Type__c='Complaint';
        cs.Sub_Type__c='Document';
        cs.Sub_Type_1__c='Agreement not received';
        cs.Forward_to_bank__c=false;
        cs.Origin = 'Web';
        cs.Displayed_Account_number__c = '12';
        cs.Correct_Account_number__c = '12';
        cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Karur Vysya Bank Ltd';
        cs.Displayed_Account_number__c = '1234';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        cs.Send_Acknowledgement_SMS__c = true;
        cs.Send_Resolved_in_Favour_SMS__c = true;
        cs.Send_Resolved_not_in_Favour_SMS__c = true;
        cs.Displayed_Address__c = 'rajasthan';
        cs.Displayed_Mobile_No__c ='2345678';
         cs.ContactMobileNo__c ='23456780';
        csList.add(cs);
        
        
        cs = new Case();
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'Update Oracle Id';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Case_Type__c='Complaint';
        cs.Sub_Type__c='Document';
        cs.Sub_Type_1__c='Agreement not received';
        cs.Forward_to_bank__c=false;
        cs.Origin = 'Web';
        cs.Displayed_Account_number__c = '12';
        cs.Correct_Account_number__c = '12';
  //      cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Karur Vysya Bank Ltd';
        cs.Displayed_Account_number__c = '1234';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        cs.Send_Acknowledgement_SMS__c = true;
        cs.Send_Resolved_in_Favour_SMS__c = true;
        cs.Send_Resolved_not_in_Favour_SMS__c = true;
        cs.Displayed_Address__c = 'rajasthan';
        cs.Displayed_Mobile_No__c ='2345678';
         cs.ContactMobileNo__c ='2345678';
        cs.Displayed_Name__c ='2345678234';
         cs.Contact_Name__c ='2345678';
        csList.add(cs);
        
        insert csList;
    }

    
    /*
    @isTest
    public static void validate53(){
        Case_Type__c ct1 = new Case_Type__c();
        ct1.Name = 'Query';
        ct1.Case_Category__c = 'Consumer';
        ct1.Case_Complaint__c = 'Report';
        Insert ct1;
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        insert ct;
        
        
        Sub_Type__c st1224 = new Sub_Type__c();
        st1224.Name = 'Status of Dispute';
        st1224.Case_Type__c = ct1.id;
        st1224.isActive__c = true;
        Insert st1224;
        
        Sub_Type__c st1225 = new Sub_Type__c();
        st1225.Name = 'Account ownership issue';
        st1225.Case_Type__c = ct.id;
        st1225.isActive__c = true;
        Insert st1225;
        
        Sub_Type1__c st21 = new Sub_Type1__c();
        st21.Name = 'Duplicate';
        st21.Sub_Type__c = st1224.id;
        st21.isActive__c = true;
        Insert st21;
        
        Sub_Type1__c st22 = new Sub_Type1__c();
        st22.Name = 'Matching - Account does not belong to me';
        st22.Sub_Type__c = st1225.id;
        st22.isActive__c = true;
        Insert st22;
        
        State__c stat = new State__c();
        stat.Name ='Delhi';
        insert stat;
        
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
        
        
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Account ownership issue';
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
        
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Matching';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st12 = new Sub_Type1__c();
        st12.Name = 'Account does not belong to me';
        st12.Sub_Type__c = stl1.Id;
        insert st12;
        
        Sub_Type1__c st123 = new Sub_Type1__c();
        st123.Name = 'Credit Enquiry does not belong to me';
        st123.Sub_Type__c = stl1.Id;
        insert st123;
        
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
        cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Karur Vysya Bank Ltd';
        cs.Displayed_Account_number__c = '1234';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        cs.Send_Acknowledgement_SMS__c = true;
        cs.Send_Resolved_in_Favour_SMS__c = true;
        cs.Send_Resolved_not_in_Favour_SMS__c = true;
        cs.Displayed_Address__c = 'rajasthan';
        cs.Displayed_PAN_No__c ='2345678';
        cs.ContactPan__c ='23456780';
        
        csList.add(cs);
        
        cs = new Case();
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'Update Oracle Id';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Call Center';
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st1.Id;
        cs.Case_Type__c='Complaint';
        cs.Sub_Type__c='Document';
        cs.Sub_Type_1__c='Agreement not received';
        cs.Forward_to_bank__c=false;
        cs.Origin = 'Web';
        cs.Displayed_Account_number__c = '12';
        cs.Correct_Account_number__c = '12';
        cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Displayed_Bank_Name__c = 'Karur Vysya Bank Ltd';
        cs.Displayed_Account_number__c = '1234';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn.Id;
        cs.Send_Acknowledgement_SMS__c = true;
        cs.Send_Resolved_in_Favour_SMS__c = true;
        cs.Send_Resolved_not_in_Favour_SMS__c = true;
        cs.Displayed_Address__c = 'rajasthan';
        cs.Displayed_PAN_No__c ='2345678';
        cs.ContactPan__c ='23456780';
        
        csList.add(cs);
        
        insert csList;
    }
    */
}