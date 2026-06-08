global class GrievancesNodalOfficersBatch implements Database.Batchable<sObject>,schedulable{
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new GrievancesNodalOfficersBatch(),Integer.ValueOf(Label.GrievancesNodalOfficerssize));
    }
    
    global List<Account> start(Database.BatchableContext BC){
        string query= 'Select Id, Name, Nodal_Officer_Email__c, Grievances_Data_Check__c, RecordType.Name, Send_Grievances_Email__c, Grievances_Email_Sent__c,Authorized_Signatory_Email__c, Email_1_Dispute__c, Email_2_Dispute__c,Email_3_Dispute__c,'+
            'Email_4_Dispute__c,Email_5_Dispute__c,Email_6_Dispute__c,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c from Account'+ 
            ' where RecordType.Name =\'Customer\' and Grievances_Email_Sent__c = false and Grievances_Data_Check__c = true order by Name limit 2000';
        // and Id='';
        List<Account> accList = database.query(query);
        return accList;
    }
    
    global void execute(Database.BatchableContext BC , List<Account>Scope){
        system.debug(Scope.size());
        List<EmailMessage>emcList = new List<EmailMessage>();
        List<Messaging.Email> allMails = new List<Messaging.Email>();
        OrgWideEmailAddress[] owea = new OrgWideEmailAddress[]{};
            
            if(!test.isRunningTest()){
                owea = [select Id from OrgWideEmailAddress where Address ='disputeresolution@experian.com' limit 1];// To send from Org wide address
            }
        
        List<Account> accList = new List<Account>();
        for(Account acc: Scope){
            acc.Grievances_Email_Sent__c = true;
            //set<string> emailList = new set<string>();
            List<string> emailList = new List<string>();
            
            if(string.isNotBlank(acc.Email_1_Dispute__c))
                emailList.add(acc.Email_1_Dispute__c);
            if(string.isNotBlank(acc.Email_2_Dispute__c))
                emailList.add(acc.Email_2_Dispute__c);
            if(string.isNotBlank(acc.Email_3_Dispute__c))
                emailList.add(acc.Email_3_Dispute__c);
            if(string.isNotBlank(acc.Email_4_Dispute__c))
                emailList.add(acc.Email_4_Dispute__c);
            if(string.isNotBlank(acc.Email_5_Dispute__c))
                emailList.add(acc.Email_5_Dispute__c);
            if(string.isNotBlank(acc.Email_6_Dispute__c))
                emailList.add(acc.Email_6_Dispute__c);
            if(string.isNotBlank(acc.Email_7_Dispute__c))
                emailList.add(acc.Email_7_Dispute__c);
            if(string.isNotBlank(acc.Email_8_Dispute__c))
                emailList.add(acc.Email_8_Dispute__c);
            if(string.isNotBlank(acc.Email_9_Dispute__c))
                emailList.add(acc.Email_9_Dispute__c);
            if(string.isNotBlank(acc.Email_10_Dispute__c))
                emailList.add(acc.Email_10_Dispute__c);
            
            if(string.isNotBlank(acc.Nodal_Officer_Email__c))
                emailList.add(acc.Nodal_Officer_Email__c);
            if(string.isNotBlank(acc.Authorized_Signatory_Email__c))
                emailList.add(acc.Authorized_Signatory_Email__c);
            
            //string urlid= 'https://d2v000001ddyeeay--devorg.sandbox.my.salesforce-sites.com/NodalDetail?recordId='+acc.Id;//sandbox url 
            string urlid= 'https://d2v000001ddyeeay.my.salesforce-sites.com/GrievancesOfficersDetail?recordId='+acc.Id;//production url
            //
            string msg = 'Dear Member,<br/><br/>';    
            msg+='Greetings from Experian Credit Information Company of India Ltd.<br/><br/>';
            msg+='Apropos the circulars RBI/2023-24/72 DoR.FIN.REC.48/20.16.003/2023-24 - Framework for compensation to customers for delayed updation/ rectification of credit information and  RBI/2023-24/73 DoR.FIN.REC.49/20.16.003/2023-24 - Strengthening of customer service rendered by Credit Information Companies and Credit Institutions,<br/><br/>';
            msg+='Frictionless implementation of these circulars will be instrumental in providing the best consumer experience, speedy dispute resolution and faster credit decisioning.<br/><br/>';
            msg+='Therefore,  we exhort that you submit the details in the  <a href="'+urlid+'">form</a> viz. Name, Mobile Numbers, email ids of ';
            msg+='<ul><li>Grievances Nodal Officer</li><li>Dispute Managers (who will be resolving disputes raised by Experian to you)</li><li>Technology Contact (for any technology support for system integration)</li></ul>';
            
            msg+='Any Change in the Grievances Nodal Officer (to be informed within 5 days of the change as per RBI/2023-24/73 DoR.FIN.REC.49/20.16.003/2023-24 - Strengthening of customer service rendered by Credit Information Companies and Credit Institutions) may be sent to the email id – <a href="customer.support@in.experian.com" target="_self">customer.support@in.experian.com</a>  by the Nodal Officer (different from the Grievances Nodal Officer) or Authorized Signatory.<br/><br/>';
            msg+='This is to ensure compliance to:<br/><br/>';
            msg+='<b>RBI/2023-24/73 DoR.FIN.REC.49/20.16.003/2023-24 - Strengthening of customer service rendered by Credit Information Companies and Credit Institutions</b><br/>';
            msg+='2.2. Setting up of Nodal points/ officials by CIs (a) CIs shall have a dedicated nodal point/ official of contact for CICs for redress of customer grievances. Details of the nodal point/ official along with email ID and telephone/ mobile number shall be furnished by CIs to CICs. (b) CIs shall inform CICs of any changes in the nodal points/ official within five (5) calendar days of such a change.<br/><br/>';
            msg+='Thanking you for your patronage and looking forward to your continued cooperation.<br/><br/>';
            msg+='Further it is reiterated that you may write to <a href="DisputeResolution@experian.com" target="_self">DisputeResolution@experian.com</a> for any query relating to the dispute management process.<br/><br/>';
            //msg+='<img src="https://d2v000001ddyeeay--devorg.sandbox.my.salesforce.com/c/resource/GrievancesNodalOfficers" width="95%" height="100"/><br/><br/>';
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            //mail.setToAddresses(new List<string>{'rishikesh.korade@finessedirect.com','muskanbee.shaikh@experian.com','balram@finessedirect.com'});//'asif.husain@experian.com'
            mail.setToAddresses(emailList);
            mail.htmlbody = msg + '<br /> ';
            mail.subject = 'Link for Grievances Nodal Officers';
            
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            EmailMessage em=new EmailMessage();
            em.subject = 'Link for Grievances Nodal Officers - '+acc.Name;
            em.RelatedToId=acc.id;  
            em.ToAddress = string.join(emailList,',');
            em.MessageDate=system.now();
            em.Incoming=false;
            em.Email_Body__c =msg;
            em.Status='3';
            em.FromAddress='disputeresolution@experian.com';
            em.FromName='Dispute Resolution';
            emcList.add(em);
            
            allMails.add(mail);
            accList.add(acc);
        }
        
        List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
        if(emcList.size() > 0){
            insert emcList;
            update accList;
        }
        
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}