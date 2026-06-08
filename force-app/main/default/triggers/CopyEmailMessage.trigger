trigger CopyEmailMessage on EmailMessage (before update) {
    
    if(Trigger.isBefore && Trigger.isUpdate){
        
        List<EmailMessage> emailMessagesToUpdate = new List<EmailMessage>();
        Set<Id> relatedCaseIds = new Set<Id>();
        Set<Id> emMsgIds = new Set<Id>();
        
        for (EmailMessage em : Trigger.new) {
            if (em.Subject =='Dispute Email to Consumer' || em.Subject =='Dispute resolved in your favour' ||
                em.Subject =='Correct Details - Follow with Financial Institution' || 
                em.Subject =='Forward to Bank'){
                    relatedCaseIds.add(em.RelatedToId);
                    emMsgIds.add(em.Id);
                }
        }
        
        system.debug('18'+relatedCaseIds+ '  '+ emMsgIds);
        List<Case> relatedCases = [ SELECT Id, Name_of_Consumer__r.FirstName, Name_of_Consumer__r.LastName,Name_of_Consumer__r.Birthdate,
                                   Name_of_Consumer__r.Phone,Name_of_Consumer__r.Pan_no__c,Name_of_Consumer__r.Email,
                                   Displayed_Bank_Name__c,
                                   Displayed_Account_number__c, Dispute_Detail__c, Dispute_Raised_Date__c, Date_of_the_email_received__c,
                                   Owner.LastName, Owner.FirstName, CaseNumber, Account.Name, Sub_Type_Name__c, Sub_Type_1_Name__c,
                                   Sub_Type_Lookup__r.Name, Name_of_Consumer__r.Full_Name__c,Displayed_Account_Type__c
                                   FROM Case
                                   WHERE Id IN :relatedCaseIds ];
        
        //User u  =[Select Id ,LastName,FirstName from User where Id =: UserInfo.getUserId()];
        system.debug('29'+relatedCases.size());
        Map<Id, Case> caseMap = new Map<Id, Case>();
        
        for (Case relatedCase : relatedCases) {
            caseMap.put(relatedCase.Id, relatedCase);
        }
        
        system.debug('29'+caseMap);
        for (EmailMessage msg : Trigger.new) {
            
            Case relcse = caseMap.get(msg.RelatedToId);
            system.debug('inside Email msg'); 
            
            if (msg.subject.contains('Dispute Email to Consumer')) {
                
                string emailbody = '';  
                if (relcse.Name_of_Consumer__r.FirstName == null){
                    emailbody+='Dear '+relcse.Name_of_Consumer__r.LastName+','+'<br/><br/>';
                }
                else{
                    emailbody+='Dear '+relcse.Name_of_Consumer__r.FirstName + ' ' + relcse.Name_of_Consumer__r.LastName+','+'<br/><br/>';
                }
                //emailbody+='Dear '+relcse.Name_of_Consumer__r.FirstName + ' ' + relcse.Name_of_Consumer__r.LastName+','+'<br/><br/>';
                emailbody+='Thank you for contacting Experian Credit Information Company of India Pvt Ltd.<br/><br/>';
                emailbody+='Your request is logged against: ' +relcse.CaseNumber +'. This request has been raised with the<br/><br/>';
                emailbody+='Name of the Financial Instituition : ' +relcse.Displayed_Bank_Name__c + '<br/>';
                emailbody+='Account Number : '+ relcse.Displayed_Account_number__c  + '<br/>';
                emailbody+='Date of the email received : '+ string.valueOf(relcse.Date_of_the_email_received__c)  + '<br/>';
                emailbody+='Date of dispute raised : '+ string.valueOf(relcse.Dispute_Raised_Date__c)  +'<br/>';
                emailbody+='Dispute Detail : '+ relcse.Dispute_Detail__c +'<br/>' + '<br/>';
                emailbody+='We had received your email with all the necessary information and raised it with the financial instituition. We are awaiting the response'+ 
                    ' from the bank for us to resolve the same at our end. The regulations governing the dispute resolution process gives us 30 days from'+
                    ' the date of the details received to resolve the same basis the information received from the financial instituition.<br/><br/>';
                emailbody+='Kindly use this reference number '+ relcse.CaseNumber + ' for any further communication.<br/> <br/>';
                emailbody+='Thank you for your support and please feel free to contact us for any further queries.<br/><br/>';
                emailbody+='Regards,<br/>';
                //emailbody+= u.FirstName + ' ' + u.LastName + '<br/>';
                emailbody+='Consumer Support Team <br/>';
                emailbody+='Experian Credit Information Company of India Private Limited <br/>';
                emailbody+='www.experian.in<br/><br/>';                
                emailbody+='Get your Experian Credit Report & Score today, click here';
                msg.email_body__c = emailbody;     
            }
            
            else if(msg.subject.contains('Dispute resolved in your favour')){
                string emailbody = '';
                if (relcse.Name_of_Consumer__r.FirstName == null){
                    emailbody+='Dear '+relcse.Name_of_Consumer__r.LastName+','+'<br/><br/>';
                }
                else{
                    emailbody+='Dear '+relcse.Name_of_Consumer__r.FirstName + ' ' + relcse.Name_of_Consumer__r.LastName+','+'<br/><br/>';
                }
                //emailbody+='Dear ' +relcse.Name_of_Consumer__r.FirstName + ' ' + relcse.Name_of_Consumer__r.LastName+ ',<br/><br/>';
                emailbody+='Thank you for your continued co-operation.<br/>'; 
                emailbody+='This is with reference to ticket logged under ' + relcse.CaseNumber  +'<br/><br/>';
                emailbody+='We are pleased to inform you that, the details of your Experian Credit Information Report regarding<br/>';  
                emailbody+='Member Institution : ' + relcse.Account.Name  +'<br/>'; 
                emailbody+='Account Number : ' + relcse.Displayed_Account_number__c   +'<br/> ';
                emailbody+='Sub Type : ' + relcse.Sub_Type_Name__c +'<br/>';
                emailbody+='Sub Type 1 : ' + relcse.Sub_Type_1_Name__c +'<br/>';  
                emailbody+='Dispute Details :' + relcse.Dispute_Detail__c +'<br/>';
                emailbody+='is now rectified. Please visit our website and check your report.<br/><br/>';
                emailbody+='The request ' + relcse.CaseNumber + ' has been completed and we are treating this as resolved and hence closed.<br/><br/>';  
                emailbody+='In case you want to respond to the same query ' +relcse.CaseNumber + ' please write on the same email. Please feel free to write a separate email for any other queries. We will be glad to assist.<br/><br/>';
                emailbody+='Regards,<br/>'; 
                //emailbody+=relcse.Owner.FirstName +' '+ relcse.Owner.LastName  +'<br/>'; 
                emailbody+='Consumer Support Team<br/>';
                emailbody+='Experian Credit Information Company of India Private Limited<br/>';
                emailbody+='www.experian.in <br/><br/>';
                emailbody+='Get your Experian Credit Report & Score today, click here';
                msg.email_body__c = emailbody;     
            }
            
            else 
                if(msg.subject.contains('Correct Details - Follow with Financial Institution')){
                    string emailbody = '';
                    if (relcse.Name_of_Consumer__r.FirstName == null){
                        emailbody+='Dear '+relcse.Name_of_Consumer__r.LastName+','+'<br/><br/>';
                    }
                    else{
                        emailbody+='Dear '+relcse.Name_of_Consumer__r.FirstName + ' ' + relcse.Name_of_Consumer__r.LastName+','+'<br/><br/>';
                    }
                    //emailbody+='Dear ' +relcse.Name_of_Consumer__r.FirstName + ' ' + relcse.Name_of_Consumer__r.LastName+ ',<br/><br/>';
                    emailbody+='Thank you for your continued co-operation.<br/>';
                    emailbody+='This is with reference to ticket logged under ' +  relcse.CaseNumber +'<br/> <br/>';
                    emailbody+='Member Institution : ' + relcse.Account.Name  +'<br/>';
                    emailbody+='Account Number : ' + relcse.Displayed_Account_number__c   +'<br/>';
                    emailbody+='Sub Type : ' + relcse.Sub_Type_Name__c +'<br/>'; 
                    emailbody+='Sub Type 1 : ' + relcse.Sub_Type_1_Name__c +'<br/>  <br/>';
                    emailbody+='Dispute Detail :' + relcse.Dispute_Detail__c +'<br/>';
                    emailbody+='We had raised and followed up with the financial instituition.<br/>  <br/>';
                    emailbody+='We have received confirmation from ' +  relcse.Account.Name  + ' with regards to the dispute raised stating that the account information is correct as reported in the Credit report. We request you to follow up with the respective bank.<br/>  <br/>';
                    emailbody+='We would like to inform you that the Experian Credit Information Report is based on the data regarding your credit card or loan accounts including re-payment behaviour for the past 36 months as submitted by the member banks / credit institutions with whom you have credit relationship.<br/>  <br/>';
                    emailbody+='As envisaged by the applicable law, Experian is only a collector and collator of credit information and not the originators of the credit information. Experian cannot make any changes or amendments to the credit information. Any required correction, deletion or addition can be made only after such correction, deletion or addition has been certified as correct by the concerned credit institution.<br/>  <br/>';
                    emailbody+='The request ' + relcse.CaseNumber  + ' has been completed and we are treating this as resolved and hence closed.<br/>  <br/>';
                    emailbody+='In case you want to respond to the same query ' + relcse.CaseNumber + ' please write on the same email. Please feel free to write a separate email for any other queries. We will be glad to assist.<br/>  <br/>';
                    emailbody+='Regards,<br/>';
                    //emailbody+=relcse.Owner.FirstName +' '+ relcse.Owner.LastName  +'<br/>'; 
                    emailbody+='Consumer Support Team <br/>'; 
                    emailbody+='Experian Credit Information Company of India Private Limited <br/>'; 
                    emailbody+='www.experian.in <br/><br/>'; 
                    emailbody+='Get your Experian Credit Report & Score today, click here';
                    msg.email_body__c = emailbody;     
                }
            
            else 
                if(msg.subject.contains('Forward to Bank')){
                    system.debug('sub type name'+relcse.Sub_Type_Name__c); 
                    if(string.isBlank(msg.email_body__c)){
                        
                        system.debug('sub type name'+relcse.Sub_Type_Name__c);  
                        
                        if(relcse.Sub_Type_Name__c !='Demographic Details'){
                            string emailbody = '';
                            emailbody+='Dear Team,<br/> <br/>';
                            
                            emailbody+='As per RBI we are mandated by a 21 days (for banks) and 30 days (for CIC) TAT which we will breach in case we do not receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed.<br/><br/>';
                            
                            emailbody+='Case No - '+relcse.CaseNumber +'<br/>';
                            
                            emailbody+='Consumer name -'+relcse.Name_of_Consumer__r.Full_Name__c +'<br/>';
                            
                            emailbody+='Member Name - '+relcse.Account.Name +'<br/>';
                            
                            emailbody+='Account Type - '+relcse.Displayed_Account_Type__c +'<br/>';
                            
                            emailbody+='Account No - '+relcse.Displayed_Account_number__c +'<br/>';
                            
                            emailbody+='Dispute Details - '+relcse.Dispute_Detail__c +'<br/><br/>';
                            
                            
                            
                            emailbody+='If we have not addressed this to the right team, please help us with the right contacts within your organisation for this.<br/><br/>';
                            
                            emailbody+='Please treat this with high priority.<br/><br/>';
                            
                            emailbody+='Please feel free to contact us for any further queries.<br/><br/><br/>';
                            
                            
                            emailbody+='Regards,<br/><br/>';
                            
                            emailbody+='Experian Global<br/>';
                            emailbody+='Consumer Support Team<br/>';
                            emailbody+='Experian Credit Information Company of India Private Limited<br/>';
                            emailbody+='www.experian.in<br/><br/>';
                            
                            emailbody+='Get your Experian Credit Report & Score today, click here';
                            msg.email_body__c = emailbody; 
                            
                        }
                        else if(relcse.Sub_Type_Name__c=='Demographic Details'){
                            string emailbody = '';
                            emailbody+='Dear Team,<br/><br/>';
                            emailbody+='As per RBI we are mandated by a 21 days (for banks) and 30 days (for CIC) TAT which we will breach in case we do not receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed.<br/><br/>';
                            
                            emailbody+='Case No - '+relcse.CaseNumber +'<br/>';                            
                            emailbody+='Consumer name -'+relcse.Name_of_Consumer__r.Full_Name__c +'<br/>';
                            
                            emailbody+='Date of Birth - '+string.valueOf(relcse.Name_of_Consumer__r.Birthdate) +'<br/>';
                            
                            emailbody+='Contact no - '+relcse.Name_of_Consumer__r.Phone +'<br/>';
                            
                            emailbody+='Email ID - '+relcse.Name_of_Consumer__r.Email +'<br/>';
                            
                            emailbody+='PAN Detail - '+relcse.Name_of_Consumer__r.Pan_no__c +'<br/>';
                            
                            emailbody+='Member Name - '+relcse.Account.Name +'<br/>';
                            
                            emailbody+='Account Type - '+relcse.Displayed_Account_Type__c +'<br/>';
                            
                            emailbody+='Account No - '+relcse.Displayed_Account_number__c +'<br/>';
                            
                            emailbody+= 'Dispute Details - '+relcse.Dispute_Detail__c +'<br/><br/>';
                            
                            
                            
                            emailbody+='If we have not addressed this to the right team, please help us with the right contacts within your organisation for this.<br/><br/>'; 
                            
                            emailbody+='Please treat this with high priority.<br/><br/>';
                            
                            emailbody+='Please feel free to contact us for any further queries.<br/><br/><br/>';
                            
                            
                            emailbody+='Regards, <br/><br/>';
                            
                            emailbody+='Experian Global <br/>';
                            emailbody+='Consumer Support Team <br/>';
                            emailbody+='Experian Credit Information Company of India Private Limited <br/>';
                            emailbody+='www.experian.in<br/><br/>';
                            
                            emailbody+='Get your Experian Credit Report & Score today, click here';
                            msg.email_body__c = emailbody; 
                        } 
                    }
                }
        }
    }
}