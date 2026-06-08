@isTest
public class UpdateCaseOwner_Test {
    
    @isTest
    public static void validate(){
        Account acc = new Account();
        acc.Name = 'Kabib'; 
        acc.Instant_Reports__c  = true;
        // Add other info on account which is requred to create it.
        insert acc;
        System.debug('Account--->'+acc);
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
        
        Contact cn1 = new Contact();
        cn1.AccountId = acc.id;
        cn1.FirstName = 'Aj';
        cn1.LastName = 'styles';
        cn1.Phone = '12345678901';
        cn1.Fax = '12345678';
        cn1.Contact_Role__c = 'Consumer';
        cn1.Email = 'tsetas1@gmail.com';
        cn1.Birthdate=system.today();
        insert cn1;
        
        test.startTest();
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
        
        List<Case> csList = new List<Case>();
        for(integer i = 0 ; i< 7 ;i++){
        Case cs = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
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
        cs.Displayed_Account_number__c = '12';
        cs.Correct_Account_number__c = '12';
        cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Referred_To_IO__c = 'No';
        cs.Consumer_Email__c = 'abc@gmail.com';
        //cs.Email_Id__c = 'avc@gmail.com';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c = [Select Id from Contact where Contact_Role__c =: 'Consumer' limit 1].Id;
        csList.add(cs);
        }
        insert csList;
        
        
        /*csList[2].Forward_to_bank__c=true;
        update csList[2];
        csList[3].Forward_to_bank__c=true;
        update csList[3];
        csList[4].Forward_to_bank__c=true;
        update csList[4];
        csList[5].Forward_to_bank__c=true;
        update csList[5];
        csList[6].Forward_to_bank__c=true;
        update csList[6];
          */ 
       /* csList[0].Forward_to_Data_Submission__c=true;
        update csList[0];
        */
        csList[1].Forward_to_OLM__c=true;
        update csList[1];
        csList[2].Forward_to_CST_Team__c=true;
        update csList[2];
        
        csList[3].Forward_to_ECV_Team__c=true;
        update csList[3];
        //csList[4].Forward_to_EWACS_Team__c=true;
        //update csList[4];
        /*csList[5].Forward_to_GPD_Team__c=true;
        update csList[5];
        csList[6].Forward_to_NG_Team__c=true;
        update csList[6];
        */
        /*
        cs.Forward_to_STS_Team__c=true;
        update cs;
        
        cs.Forward_to_Score_Team__c=true;
        update cs;
        
        */
        test.stopTest();
    
    }
    
    @isTest
    public static void validate2(){
        Account acc = new Account();
        acc.Name = 'Kabib'; 
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
        System.debug('Account--->'+acc);
        
        
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
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'Report';
        
        insert ct;
        Sub_Type__c	 stl =new Sub_Type__c	();
        stl.Name = 'Matching';
        stl.Case_Type__c = ct.Id;
        insert stl;
        
        Sub_Type1__c st = new Sub_Type1__c();
        st.Name = 'Current Balance';
        st.Sub_Type__c = stl.Id;
        insert st;
        
        
        Case cs = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'Update Oracle Id';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Report';
        
        cs.Case_Type_Lookup__c = ct.Id;
        cs.Sub_Type_Lookup__c = stl.id;
        cs.Sub_Type_1_Lookup__c= st.Id;
        
        cs.Forward_to_bank__c=false;
        cs.Origin = 'Web';
        cs.Displayed_Account_number__c = '12';
        cs.Correct_Account_number__c = '12';
        cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';
        cs.Rejection_Reason__c = 'Rejected by Lender';
        cs.Referred_To_IO__c = 'No';
        cs.Consumer_Email__c = 'abc@gmail.com';
        //cs.Email_Id__c = 'avc@gmail.com';
        cs.Last_Reply_from_Bank_Team__c = date.today();
        cs.Name_of_Consumer__c =cn1.Id;
        insert cs;
        /*try{
            cs.Forward_to_bank__c=true;
        	update cs;
        }catch(exception e){
            
        }*/
        
        /*//update cs;
        cs.Forward_to_Data_Submission__c=true;
        update cs;
        cs.Forward_to_OLM__c=true;
        update cs;
        cs.Name_of_Consumer__c = cn1.Id;
        cs.Forward_to_CST_Team__c=true;
        update cs;
        cs.Forward_to_ECV_Team__c=true;
        update cs;
        cs.Forward_to_EWACS_Team__c=true;
        update cs;
        cs.Forward_to_GPD_Team__c=true;
        update cs;
        cs.Forward_to_NG_Team__c=true;
        update cs;
        cs.Forward_to_STS_Team__c=true;
        update cs;
        
        cs.Forward_to_Score_Team__c=true;
        update cs;
        
        cs.Forward_to_Score_Team__c=true;
        update cs;
    */
        
        cs.Forward_to_Data_Merger__c = true;
        cs.Forward_to_Data_Submission__c=true;
        cs.Forward_to_ECV_Team__c=true;
        cs.Forward_to_GPD_Team__c=true;
        cs.Forward_to_EWACS_Team__c=true;
        cs.Forward_to_NG_Team__c=true;
        cs.Forward_to_STS_Team__c=true;
        cs.Forward_to_Score_Team__c=true;
        update cs;
    }
    
   

}