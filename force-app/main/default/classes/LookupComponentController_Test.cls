@isTest
public class LookupComponentController_Test {
     @isTest
    public static void test1() {
        List<Account> acclist = new List<Account>();
        Account acc = new Account();
        acc.Name = 'Finesse IT Labs Pvt Ltd';
        acc.Email_1_Dispute__c = 'abc@gmail.com';
        acc.Email_2_Dispute__c = 'abc@gmail.com';
        acc.Email_3_Dispute__c = 'abc@gmail.com';
        acc.Email_4_Dispute__c = 'abc@gmail.com';
        acc.Email_5_Dispute__c = 'abc@gmail.com';
        acc.Email_6_Dispute__c = 'abc@gmail.com';
        acc.Email_7_Dispute__c = 'abc@gmail.com';
        acc.Email_8_Dispute__c = 'abc@gmail.com';
        acc.Email_9_Dispute__c = 'abc@gmail.com';
        acc.Email_10_Dispute__c = 'abc@gmail.com';
        insert acc;
        acclist.add(acc);
        
        
        
        Contact con = new Contact();
        con.Email = 'abcsdfgh@gmail.com';
        con.FirstName = 'dfghj';
        con.LastName = 'dfghjk';
        con.AccountId= acc.Id;
        con.Contact_Role__c = 'Consumer';
        insert con;
        
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'Report';
        insert ct;
        
        Sub_Type__c	 stl1 =new Sub_Type__c	();
        stl1.Name = 'Account Details';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'EMI Amounts';
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
        //cs.Send_Mail_for_RBI_Complaint__c = true;
        cs.RBI_Complaint_Number__c = '1234567';
        cs.Displayed_Account_number__c = '1234567890';
        cs.Displayed_Bank_Name__c = 'HDFC';
        cs.Name_of_Consumer__c = con.Id;
        insert cs;
        
         //Insert emailmessage for case
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'abc@gmail.com';
            email.Incoming = True;
            email.ToAddress= 'test@xyz.org';
            email.Subject = 'Test email';
            email.HtmlBody = 'Test email body';
            email.ParentId = cs.Id; 
            insert email;
        List<string> strlist = new List<string>();
        strlist.add('status');
        
        LookupComponentController.findRecords('','Case',cs.Id,'status',strlist,'','','Id','','');
        LookupComponentController.fetchDefaultRecord(cs.Id,'Case','status');
        
        
    }
    

}