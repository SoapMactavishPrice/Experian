@isTest
public class CaseOwnerUpdate_Batch_Test {
    
    public static testMethod void Validate(){
        
        Set<Id> caseIds = new Set<Id>();
        
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
        
        contact con = new contact();
        con.accountId = acc.Id;
        con.LastName = 'dhamu';
        con.Contact_Role__c = 'Consumer';
        INSERT con;
        
        Case cs = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        //cs.AccountId = acc.id;
        cs.Subject = 'UpdateId';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Correct details on credit report';
        cs.Case_Type__c='Dispute';
        cs.Sub_Type__c='Account Status';
        cs.Sub_Type_1__c='Active';
        cs.Sub_Type_Status__c ='Notify to Bank';
        cs.Origin = 'Web';
        cs.OwnerId=System.Label.Foward_to_Bank_Team_Queue_Id;
        cs.Displayed_Bank_Name__c = 'Opto';
        cs.Displayed_Account_number__c = 'ABC';
        //cs.OwnerId='00G2u000000pcXaEAI';
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs;
        caseIds.add(cs.Id);
        
        Case cs2 = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs2.Status = 'Open';
        //cs.AccountId = acc.id;
        cs2.Subject = 'UpdateId';
        cs2.Case_Category__c = 'Consumer';
        cs2.Case_Complaints__c = 'Correct details on credit report';
        cs2.Case_Type__c='Dispute';
        cs2.Sub_Type__c='Account Status';
        cs2.Sub_Type_1__c='Active';
        cs2.Sub_Type_Status__c ='Notify to Bank';
        cs2.AccountId = acc.Id;
        cs2.Name_of_Consumer__c = con.Id;
        
        cs2.Origin = 'Web';
        cs2.OwnerId=System.Label.Foward_to_Bank_Team_Queue_Id;
        //cs.OwnerId='00G2u000000pcXaEAI';
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs2;
        caseIds.add(cs2.Id);

        
        Test.startTest(); 
        //cs2.Send_Email_to_Consumer__c  = true;
        //UPDATE cs2;
        Database.executeBatch(new CaseOwnerUpdate_Batch(caseIds));
        Test.stopTest();
    }
    
     public static testMethod void Validate2(){
        
        Set<Id> caseIds = new Set<Id>();
        
        Case cs = new Case();
        //cs.RecordTypeId='0126D000000hc2GQAQ';
        cs.Status = 'Open';
        //cs.AccountId = acc.id;
        cs.Subject = 'UpdateId';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = 'Correct details on credit report';
        cs.Case_Type__c='Dispute';
        cs.Sub_Type__c='Account Status';
        cs.Sub_Type_1__c='Active';
        cs.Sub_Type_Status__c ='Notify to Bank';
        
        cs.Origin = 'Web';
        cs.OwnerId=System.Label.Foward_to_Bank_Team_Queue_Id;
        //cs.OwnerId='00G2u000000pcXaEAI';
        //cs.Name_of_Consumer__c =cn.Id; 
        insert cs;
        caseIds.add(cs.Id);

        
        Test.startTest(); 
        Database.executeBatch(new CaseOwnerUpdate_Batch(caseIds));
        Test.stopTest();
    }
    
}