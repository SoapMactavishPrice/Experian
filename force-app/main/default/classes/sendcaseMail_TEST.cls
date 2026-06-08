@isTest
public class sendcaseMail_TEST {
    
    /*@isTest
    static void validate_data2(){
        Account acc = new Account();
        acc.Name = 'Kabib';
        acc.Instant_Reports__c  = true;
        // Add other info on account which is requred to create it.
        acc.Email_1_Dispute__c = 'adfg@dfdg.com';
        acc.Email_2_Dispute__c = 'adfg@dfdg.com';
        acc.Email_3_Dispute__c = 'adfg@dfdg.com';
        acc.Email_4_Dispute__c = 'adfg@dfdg.com';
        acc.Email_5_Dispute__c = 'adfg@dfdg.com';
        acc.Email_6_Dispute__c = 'adfg@dfdg.com';
        acc.Email_Dispute__c = 'adfg@dfdg.com';
        acc.Email_7_Dispute__c = 'abc@gmail.com';
        acc.Email_8_Dispute__c = 'abc@gmail.com';
        acc.Email_9_Dispute__c = 'abc@gmail.com';
        acc.Email_10_Dispute__c = 'abc@gmail.com';
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
        stl.Name = 'Balance Issue';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Current Balance';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        test.startTest();
        List<Case> csList = new List<Case>();
        for(integer i = 0 ; i< 4 ;i++){
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
            cs.Displayed_Bank_Name__c = '1213';
            cs.Last_Reply_from_Bank_Team__c = date.today();
            cs.Name_of_Consumer__c = cn.Id;
            cs.Temp_Forward_to_Bank__c = true;
            csList.add(cs);
        }
        insert csList;
        
        csList[0].Displayed_Account_number__c = '123';
        csList[0].Displayed_Name__c = 'test';
        csList[0].Correct_Account_number__c = '123';
        csList[0].Description = '123';
        csList[0].Request_data_correction_on_SFTP__c = true;
        csList[0].Displayed_Bank_Name__c = '13';
        update csList[0];
        
        csList[0].Consumer_Dispute_Status__c =null;
        csList[0].Send_Mail_for_RBI_Complaint__c = true;
        csList[0].Dispute_Raised_Date__c = system.today().addDays(-2);
        
        update csList[0];
        
        csList[0].Dispute_Raised_Date__c = system.today();
        
        // update csList[0];
        
        csList[1].Status = 'Resolved';
        csList[1].ParentId = null;
        csList[1].Consumer_Dispute_Status__c = 'Acknowledgement sent to Consumer';
        
        try{
            update csList[1];
        }catch(exception e){}
        
        csList[1].Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer';
        test.stopTest();   
    }
    */
    @isTest
    public static void isValidate3(){
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
        Account acc = new Account();
        acc.Name = 'Kabib';
        acc.Instant_Reports__c  = true;
        // Add other info on account which is requred to create it.
        acc.Email_1_Dispute__c = 'adfg@dfdg.com';
        acc.Email_2_Dispute__c = 'adfg@dfdg.com';
        acc.Email_3_Dispute__c = 'adfg@dfdg.com';
        acc.Email_4_Dispute__c = 'adfg@dfdg.com';
        acc.Email_5_Dispute__c = 'adfg@dfdg.com';
        acc.Email_6_Dispute__c = 'adfg@dfdg.com';
        acc.Email_Dispute__c = 'adfg@dfdg.com';
        acc.Email_7_Dispute__c='c@gmail.com';
        acc.Email_8_Dispute__c='c@gmail.com';
        acc.Email_9_Dispute__c='c@gmail.com';
        acc.Email_10_Dispute__c='c@gmail.com';
        acc.CC_Address_10__c = 'abc@gmail.com';
        acc.CC_Address_1__c = 'abc1@gmail.com';
        acc.CC_Address_2__c = 'abc2@gmail.com';
        acc.CC_Address_3__c = 'abc3@gmail.com';
        acc.CC_Address_4__c = 'abc4@gmail.com';
        acc.CC_Address_5__c = 'abc5@gmail.com';
        acc.CC_Address_6__c = 'abc6@gmail.com';
        acc.CC_Address_7__c = 'abc7@gmail.com';
        acc.CC_Address_8__c = 'abc8@gmail.com';
        acc.CC_Address_9__c = 'abc9@gmail.com';
        acc.CC_Address_10__c = 'abc12@gmail.com';
        acc.Bureau_Member_Id__c = '1';
        insert acc;
        
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
        
        test.startTest();
        
        Contact cn1 = new Contact();
        cn1.AccountId = acc.id;
        cn1.FirstName = 'Aj';
        cn1.LastName = 'style';
        cn1.Phone = '1234567890';
        cn1.Fax = '1234567';
        cn1.Contact_Role__c = 'Consumer';
        cn1.Email = 'tsetas@gmail.com';
        cn1.Birthdate=system.today();
        insert cn1;
        
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
        cs.Description = '345678oiugfcvbnm,mnbvcdknbvcvbnmhgftyuknbv m,jhgfddfghjhkgfdgfghlkjkhgjcxcgjhkjlkhgfdfxbgncmkutyrtergafgj,hkyitruetyrgfxghkytretsgzxvczarwyilykgfgdFSDZxcvhkuytrieutdhfghkjghfgdteyihkgjmcnfnmgdytuyilhk.,vmcnxdytuyi;h.k,gjmhgshttuyilhkvcsulhb cfghxg kydtshxeuijhgfxcvbnmmnfdrtyuikjvcvbnmhgfddcviuytrewqasm,mnbfde5678ojhgfdsfghjkjhgdsdfgh                          gfdsdfghuytdsdfgbjknbfde5678ijhgfdhjkyewsdfghjklmnbvdse567ikjn';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn1.Id;
        cs.Request_data_correction_on_SFTP__c = false;
        cs.Forward_to_Data_Merger__c = false;
        cs.SuppliedEmail = 'abc@gmail.com';
        insert cs;
        cs.Temp_Forward_to_Bank__c = true;
        update cs;
        
        cs.Displayed_Account_number__c = '123';
        cs.Request_data_correction_on_SFTP__c = true;
        cs.Forward_to_Data_Merger__c = true;
        cs.Description = 'q345678opohgfx';
        cs.Send_Mail_for_RBI_Complaint__c =true;
        update cs;
        test.stopTest();
    }
    
    @isTest
    public static void isValidate4(){
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
        Account acc = new Account();
        acc.Name = 'Kabib';
        acc.Instant_Reports__c  = true;
        // Add other info on account which is requred to create it.
        acc.Email_1_Dispute__c = 'adfg@dfdg.com';
        acc.Email_2_Dispute__c = 'adfg@dfdg.com';
        acc.Email_3_Dispute__c = 'adfg@dfdg.com';
        acc.Email_4_Dispute__c = 'adfg@dfdg.com';
        acc.Email_5_Dispute__c = 'adfg@dfdg.com';
        acc.Email_6_Dispute__c = 'adfg@dfdg.com';
        acc.CC_Address_10__c = 'abc@gmail.com';
         acc.CC_Address_1__c = 'abc1@gmail.com';
         acc.CC_Address_2__c = 'abc2@gmail.com';
         acc.CC_Address_3__c = 'abc3@gmail.com';
         acc.CC_Address_4__c = 'abc4@gmail.com';
         acc.CC_Address_5__c = 'abc5@gmail.com';
         acc.CC_Address_6__c = 'abc6@gmail.com';
         acc.CC_Address_7__c = 'abc7@gmail.com';
         acc.CC_Address_8__c = 'abc8@gmail.com';
         acc.CC_Address_9__c = 'abc9@gmail.com';
         acc.CC_Address_10__c = 'abc12@gmail.com';
        acc.Bureau_Member_Id__c = '1';
        acc.Email_Dispute__c = 'adfg@dfdg.com';
        insert acc;
        
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
        
        test.startTest();
        
        Contact cn1 = new Contact();
        cn1.AccountId = acc.id;
        cn1.FirstName = 'Aj';
        cn1.LastName = 'style';
        cn1.Phone = '1234567890';
        cn1.Fax = '1234567';
        cn1.Contact_Role__c = 'Consumer';
        cn1.Email = 'tsetas@gmail.com';
        cn1.Birthdate=system.today();
        insert cn1;
        
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
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = cn1.Id;
        cs.Request_data_correction_on_SFTP__c = false;
        cs.Forward_to_bank__c = false;
        insert cs;
        //cs.Forward_to_bank__c = true;
        //update cs;
        test.stopTest();
    }
    
}