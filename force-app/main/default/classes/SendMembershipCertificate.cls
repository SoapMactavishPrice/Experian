public class SendMembershipCertificate {
    
    public Account acc {get;set;}
    public string currentRecID {get;set;}
    
    public SendMembershipCertificate(){
        
        currentRecID = ApexPages.CurrentPage().getparameters().get('id');
        acc = [Select Id, Name, Lead_Email__c, Current_Date_Year__c, Next_Month_Year__c, Subscriber_ID__c 
               From Account Where Id =:currentRecID];  
        
        String UserName  = UserInfo.getName();
        String UserEmail = UserInfo.getUserEmail();
    }
    
    @future (callout=true)
    public  static void SendEmail(Set<Id> ids){
        
        String UserName = UserInfo.getName();
        String UserEmail = UserInfo.getUserEmail();
        
        system.debug('acclist'+ids); 
        List < Account > acclist = [Select Id,Name,Lead_Email__c,Authorized_Signatory_Email__c,Nodal_Officer_Email__c,Email_ID__c
                                    From Account Where Id IN:ids ];        
        system.debug('acclist'+acclist.size()); 
        
        for(Account inv: acclist){
            
            try{
                Attachment a;
                
                String[] ccAddresses = new string [1];
                String[] ToAddresses = new string [1];
                ToAddresses.clear();
                ccAddresses.clear();
                ToAddresses.add(inv.Lead_Email__c);  
                ToAddresses.add(inv.Authorized_Signatory_Email__c); 
                ToAddresses.add(inv.Nodal_Officer_Email__c); 
                ccAddresses.add(inv.Email_ID__c);
                System.debug('ccAddresses==========='+ccAddresses);
                
                PageReference pdf;
                pdf = Page.SendMembershipCertificate;
                pdf.getParameters().put('id',inv.id);
                Blob pdfBody;
                if(!test.isRunningTest()){
                    pdfBody = pdf.getContentAsPDF();
                }
                else
                {
                    pdfBody = blob.valueof('TEST');
                }
                list<Attachment> at=[select id,name,body from Attachment where ParentId=:inv.id];
                String name;
                if(at.size()!=0)
                    name='Certificate Of Membership'+at.size()+'.pdf';
                else
                {
                    name='Certificate Of Membership.pdf';
                }
                Attachment attach = new Attachment();
                attach.ParentId =inv.id;
                attach.name = name;
                attach.body = pdfBody ;
                INSERT attach;
                
                String Strbdy='';
                Strbdy += '<p>Dear Member,</p>';
                Strbdy += '<p>Thank you for your membership with Experian.</p>';
                Strbdy += '<p>Kindly find the attached the soft copy of Membership Certificate for your reference. The access to Experian platforms will also be provided basis the details submitted by your Organisation.</p>';
                Strbdy += '<p>We look forward to your usage of our products and services. For any requests regarding your usage, please feel free to write to Customer.Support@in.experian.com<br/></p><br/><br/>';
                Strbdy += '<p>'+UserName+ '<br/>Membership Team <br/>Experian Credit Information Company of India Private Limited <br/>India STS Link – https://data.experian.in <br/>Nextgen Link - https://nxg-india.experian.com/nextgen-ind-pds/ </p>';
                
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'customer.support@in.experian.com'];// To send from Org wide address
                System.debug('owea  '+owea); // balramp610@gmail.com   customer.support@in.experian.com	 
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                if ( owea.size() > 0 ) {
                    System.debug('inside');  
                    email.setOrgWideEmailAddressId(owea.get(0).Id);
                } 
                
                email.setSubject('Certificate Of Membership');
                email.setToAddresses(ToAddresses);
                email.setCcAddresses(ccAddresses);
                email.setUseSignature(false);
                email.setHtmlBody(Strbdy);
                
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(attach.Name);
                efa.setBody(attach.Body);
                email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
                
                Messaging.SendEmailResult [] r = Messaging.SendEmail(new Messaging.SingleEmailMessage[] {email});
                System.debug('r==========='+r);
                
                inv.Certificate_Email_Sent__c=true;
                
                EmailMessage em=new EmailMessage();
                em.Subject='Certificate Of Membership';
                em.RelatedToId=inv.id;  
                em.ToAddress=inv.Lead_Email__c + ',' +inv.Nodal_Officer_Email__c + ','+inv.Authorized_Signatory_Email__c;
                em.CcAddress=inv.Email_ID__c;
                em.MessageDate=system.now();
                em.Incoming=false;
                em.Email_Body__c =Strbdy;
                em.Status='3';
                em.FromAddress='customer.support@in.experian.com';
                em.FromName='Customer Support';
                insert em;
            }
            catch(exception e){
            }
        }
        
        update acclist;
    }
}