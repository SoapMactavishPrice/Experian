@IsTest
public class Lead_PaymentDetailTest_Class {
    public static Id leadId;
    static testMethod void convertLead(){
        test.startTest();
        try{
            Product__c p = new Product__c();
            p.Name = 'Test';
            p.Fee_Plan_Type__c = 'Fixed';
            Insert p; 
            
            list<String> idList = new List<String>();
            Lead newLead = new Lead() ;
            newLead.FirstName = 'Test';
            newLead.LastName = 'Mahi';
            newLead.Company = 'Apple';
            newLead.Status = 'OTP Verified';
            insert newLead;
            
            
            newLead.Status = 'Sent for Agreement';
            newLead.Sent_for_Agreement__c=false;
            newLead.Send_Proposal__c=true;
            newLead.Proposal_Email_Sent__c=false;
            update newLead;
            
            Lead newLead1 = new Lead() ;
            newLead1.FirstName = 'Test';
            newLead1.LastName = 'Mahi';
            newLead1.Company = 'Apple';
            newLead1.Status = 'Sent for Agreement';
            insert newLead1;
            
            newLead1.Sent_for_Agreement__c=false;
            newLead1.Send_Proposal__c=true;
            newLead1.Proposal_Email_Sent__c=false;
            update newLead1;
            
            EmailMessage em=new EmailMessage();
            em.Subject=' Proposal Email Sent';
            em.Lead__c=newLead.Id;  
            em.ToAddress=newLead.Email;
            em.CcAddress=newLead.Owner.Email;
            em.MessageDate=system.now();
            
            
            em.Incoming=false;
            em.Status='3';
            insert em;
            
            List<Product__c> pList= [SELECT id, Name FROM Product__c];
            
            List<Lead_Payment_Detail__c> listtest = [Select id from Lead_Payment_Detail__c where Lead__c =:newlead.id];
            
            system.debug('---'+listtest.size());
            
            Lead_Payment_Detail__c lp = new Lead_Payment_Detail__c();
            
        } Catch(Exception e){}
        test.stopTest();
    }  
    static testMethod void convertLead4(){
        test.startTest();
        try{
            Product__c p = new Product__c();
            p.Name = 'Test';
            p.Fee_Plan_Type__c = 'Fixed';
            Insert p; 
            
            list<String> idList = new List<String>();
            Lead newLead = new Lead() ;
            newLead.FirstName = 'Test';
            newLead.LastName = 'Mahi';
            newLead.Company = 'Apple';
            newLead.Status = 'Sent for Agreement';
            insert newLead;
            
            
            newLead.Status = 'Sent for Agreement';
            newLead.Sent_for_Agreement__c=false;
            newLead.Send_Proposal__c=true;
            newLead.Proposal_Email_Sent__c=false;
            update newLead;
            
            
            EmailMessage em=new EmailMessage();
            em.Subject=' Proposal Email Sent';
            em.Lead__c=newLead.Id;  
            em.ToAddress=newLead.Email;
            em.CcAddress=newLead.Owner.Email;
            em.MessageDate=system.now();
            
            
            em.Incoming=false;
            em.Status='3';
            insert em;
            
            List<Product__c> pList= [SELECT id, Name FROM Product__c];
            
            List<Lead_Payment_Detail__c> listtest = [Select id from Lead_Payment_Detail__c where Lead__c =:newlead.id];
            
            system.debug('---'+listtest.size());
            
            Lead_Payment_Detail__c lp = new Lead_Payment_Detail__c();
            //lp.Lead__c = newLead.id;
            //lp.Product__c = p.id;
            //Insert lp;
            
        } Catch(Exception e){}
        test.stopTest();
    }  
    public static testMethod void convertLead3(){
            
            Lead l = new Lead();
            l.First_Name_Nodal__c = 'Test First';
            l.Company = 'Test comp1';
            l.Last_Name_Nodal__c = 'Test Last';
            l.Last_Name_AuSig__c = 'Test Last';
            l.Last_Name_Web_User__c = 'Test Last';
            l.LastName='Tesatas';
            l.Company = 'Test Co PVT Ltd';
            l.Status='new';
            l.Tel_No_Nodal__c='1234567890';
            l.Official_Email_Address_Nodal__c='testamj@gmail.com';
            l.Job_Title_Nodal__c='Test';
            l.Fax_No_Nodal__c='1234567890';
            l.CIN_Company_Identification_Number__c='FIRT1234TY';
            l.Pan_no__c='AAAJT1724E';
            l.GST_No__c='19AAAJT1724E1Z8';
            l.RBI_Certificate_No__c='19AAAJT1724E1Z8';
            l.Send_Payment_Link__c=true;
            l.Authorised_Signatory_Same_As_Nodal_Offic__c = true;
            l.Email = 'testameeej@gmail.com';
            l.Authorized_Signatory_Name__c = 'Test';
            l.Date_of_Incorporation__c = system.today();
            l.Nodal_Officer_Name__c = 'Test';
            insert l;
            leadId = l.Id;
            
            l.Status='Rejected';
            l.Rejected_Reason__c ='Testing Company';
            
            update l;
           
            
        }
    }