@isTest
public class SendEmailaccountwithCaseBatch_Test {

    @isTest
    public static void isValidate(){
        List<Case> cslist = new List<Case>();
		
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
            Contact cn = new Contact();
            cn.AccountId = acc.id;
            cn.FirstName = 'Aj';
            cn.LastName = 'style';
            cn.Phone = '1234567890';
            cn.Fax = '1234567';
            cn.Contact_Role__c = 'Consumer';
            cn.Email = 'tsetas@gmail.com';
            cn.Birthdate=system.today();
            
            Contact con=new  Contact();
            con.AccountId =acc.Id;
            con.LastName='Test';
            con.Email = 'abc@gmail.com';
            con.Contact_Role__c = 'Dispute Manager – Escalation Level 3';
            
            insert con;
            
            insert cn;
            system.debug('Account Id  5001s000007ZBK0AAO ++ >>. '+acc.Id);
            Case cs = new Case();
            //cs.RecordTypeId='0126D000000hc2GQAQ';
            cs.Status = 'Open';
            cs.AccountId = acc.id;
            cs.Subject = 'UpdateId';
            cs.Case_Category__c = 'Consumer';
            cs.Case_Complaints__c = 'Correct details on credit report';
            cs.Case_Type__c='Dispute';
            cs.Sub_Type__c='Account Status';
            cs.Sub_Type_1__c='Active';
            cs.Sub_Type_Status__c ='Notify to Bank';
            //cs.Owner.Name = 'Bank Team';
            cs.Account_s_Parent_Case__c = false;
            
            cs.Origin = 'Web';
            
            //cs.Name_of_Consumer__c =cn.Id; 
            insert cs;
            system.debug('Case owne r Id'+cs.Owner.Name);
            //cs.OwnerId='00G6D000001rpbg';
            cs.Forward_to_bank__c=true;
            update cs;
            
            
            Case cs1 = new Case();
            //cs.RecordTypeId='0126D000000hc2GQAQ';
            cs1.Status = 'Open';
            cs1.AccountId = acc.id;
            cs1.Subject = 'UpdateId';
            cs1.Case_Category__c = 'Consumer';
            cs1.Case_Complaints__c = 'Correct details on credit report';
            cs1.Case_Type__c='Dispute';
            cs1.Sub_Type__c='Account Status';
            cs1.Sub_Type_1__c='Active';
            cs1.Sub_Type_Status__c ='Notify to Bank';
            //cs.Owner.Name = 'Bank Team';
            cs1.Account_s_Parent_Case__c = true;
            
            cs1.Origin = 'Web';
            
            //cs.Name_of_Consumer__c =cn.Id; 
            insert cs1;
            system.debug('Case owne r Id'+cs.Owner.Name);
            //cs.OwnerId='00G6D000001rpbg';
            cs1.Forward_to_bank__c=true;
            update cs1;
            
            cs.Account_s_Parent_Case__c = true;
            update cs;
        
            cslist.add(cs);
            
          SendEmailaccountwithCaseBatch dt = new SendEmailaccountwithCaseBatch(cslist);
          database.executeBatch(dt,1);
    }
}