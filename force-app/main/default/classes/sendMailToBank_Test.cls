@isTest
public class sendMailToBank_Test {
    public static testMethod void test1() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        system.assert(true);
        User u = new User(
            Alias = 'testu',
            Email = 'test34567890@gmail.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = p.Id,
            UserName='test3456789056789@gmail.com'
        );
        
        INSERT u;     
        
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
        acc.Email_7_Dispute__c='p@gmail.com';
        acc.Email_8_Dispute__c='a@gmail.com';
        acc.Email_9_Dispute__c='b@gmail.com';
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
         Case_Type__c ct1 = new Case_Type__c();
        ct1.Name = 'Query';
        ct1.Case_Category__c = 'Consumer';
        ct1.Case_Complaint__c = 'Report';
        Insert ct1;
        
        Sub_Type__c st = new Sub_Type__c();
        st.Name = 'Status of Dispute';
        st.Case_Type__c = ct1.id;
        st.isActive__c = true;
        Insert st;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Duplicate';
        st1.Sub_Type__c = st.id;
        st1.isActive__c = true;
        Insert st1;
        
        Case_Type__c  ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'call Center';
        
        insert ct;
        
         Sub_Type__c	 stl1234 =new Sub_Type__c	();
        stl1234.Name = 'Matching';
        stl1234.Case_Type__c = ct.Id;
        
        insert stl1234;
        
        Sub_Type1__c st1234 = new Sub_Type1__c();
        st1234.Name = 'Account does not belong to me';
        st1234.Sub_Type__c = stl1234.Id;
        insert st1234;
        
        Sub_Type1__c st12345 = new Sub_Type1__c();
        st12345.Name = 'Credit Enquiry does not belong to me';
        st12345.Sub_Type__c = stl1234.Id;
        insert st12345;
       
        
        Case cs = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'Update';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = null;
        cs.Case_Type__c=null;
        cs.Sub_Type__c=null;
        cs.Sub_Type_1__c=null;
        cs.Sub_Type_Status__c =null;
        
        //cs.Name_of_Consumer__r.BirthDate =  Date.newInstance(2020 , 10 ,20);
        //cs.Contact.Birthdate=cn.Birthdate;
        //cs.Account.Instant_Reports__c = acc.Instant_Reports__c;
        cs.Origin = 'Web';
        cs.OwnerId= u.id;
        // Add other info on case which is requred to create it.
        insert cs;
        
        cs.Forward_to_bank__c=true;
        update cs;
        System.debug('Case--->'+cs);
        Map<Id,Case> myCaseMap = new Map<Id,Case>();
        myCaseMap.put(cs.Id,cs);
        
        Case cs1 = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs1.Status = 'Open';
        cs1.AccountId = acc.id;
        cs1.Subject = 'Update Oracle Id';
        cs1.Case_Category__c = 'Consumer';
        cs1.Case_Complaints__c = null;
        cs1.Case_Type__c=null;
        cs1.Sub_Type__c=null;
        cs1.Sub_Type_1__c=null;
        cs1.Sub_Type_Status__c =null;
        //cs.Contact.Birthdate=cn.Birthdate;
        //cs.Account.Instant_Reports__c = acc.Instant_Reports__c;
        cs1.Origin = 'Web';
        cs1.Forward_to_bank__c = false;
        
        // cs1.Name_of_Consumer__r.BirthDate = Date.newInstance(2021,10,20);﻿ 
        
        //cs1.OwnerId=System.Label.Foward_to_Bank_Team_Queue_Id;
        
        // Add other info on case which is requred to create it.
        insert cs1;
        System.debug('Case--->'+cs1);
        Map<Id,Case> myCaseMap1 = new Map<Id,Case>();
        myCaseMap1.put(cs.Id,cs1);
        
        test.startTest();
        sendMailtoBank.sendInstantMail(myCaseMap , myCaseMap1, myCaseMap1);
        test.stopTest();
        
    }
    
    
}