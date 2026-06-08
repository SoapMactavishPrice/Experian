@IsTest
public class SendSmsGupshup_Test {
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('GatewayAPI/rest?')) {
                String sta = 'OK';
                String Js = '{"response": {"status":"123","docket_id":"1234"}}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
            return null;
        }
    }
    static testMethod void  updateMethodTest(){   
       try{
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
            
            Contact con = new Contact();
            con.AccountId = acc.id;
            con.LastName = 'Test';
            con.Phone = '1234567890';
            con.Phone_2__c = '1234567890';
            con.Contact_Role__c = 'Consumer';
            Insert con;
            
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Subject = 'Om Test';  
            c.Status ='Resolved';
            c.Priority = 'Medium';
            c.Origin = 'Email';
            c.Displayed_Account_number__c = '123';
            c.Name_of_Consumer__c = con.id;
            insert c;
            
            set<id> sid = new set<id>();
            sid.add(c.id);
            
            //Insert emailmessage for case
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'abc@gmail.com';
            email.Incoming = True;
            email.ToAddress= 'test@xyz.org';
            email.Subject = 'Test email';
            email.HtmlBody = 'Test email body';
            email.ParentId = c.Id; 
            insert email;
            
            Gupshup__mdt g = new Gupshup__mdt();
            g.auth_scheme__c = '';
            g.format__c = '';
            g.method__c = '';
            g.msg__c = '';
            g.msg_type__c = '';
            g.password__c = '';
            g.userid__c = '';
            g.v__c = '';
            g.DeveloperName = 'received';
            
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, new Mock());
            SendSmsGupshup ssg = new SendSmsGupshup();
            SendSmsGupshup.sendSMS(sid ,'received');
            Test.stopTest();
        } Catch(Exception e){}
    }
    static testMethod void  updateMethodTest1(){   
        try{
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
            
            Contact con = new Contact();
            con.AccountId = acc.id;
            con.LastName = 'Test';
            con.Contact_Role__c = 'Consumer';
            con.Phone_2__c = '1234567890';
            Insert con;
            
            Case c = new Case();
            c.AccountId = acc.Id;
            c.Subject = 'Om Test';  
            c.Status ='Resolved';
            c.Priority = 'Medium';
            c.Origin = 'Email';
            c.Displayed_Account_number__c = '123';
            c.Name_of_Consumer__c = con.id;
            insert c;
            
            set<id> sid = new set<id>();
            sid.add(c.id);
            
            //Insert emailmessage for case
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'abc@gmail.com';
            email.Incoming = True;
            email.ToAddress= 'test@xyz.org';
            email.Subject = 'Test email';
            email.HtmlBody = 'Test email body';
            email.ParentId = c.Id; 
            insert email;
            
            Gupshup__mdt g = new Gupshup__mdt();
            g.auth_scheme__c = '';
            g.format__c = '';
            g.method__c = '';
            g.msg__c = '';
            g.msg_type__c = '';
            g.password__c = '';
            g.userid__c = '';
            g.v__c = '';
            g.DeveloperName = 'received';
            
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, new Mock());
            SendSmsGupshup ssg = new SendSmsGupshup();
            SendSmsGupshup.sendSMS(sid ,'received');
            Test.stopTest();
        } Catch(Exception e){}
    }
    
}