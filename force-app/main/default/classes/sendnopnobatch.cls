global class sendnopnobatch implements Database.Batchable<sObject>,Schedulable{
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new sendnopnobatch(),1);
    }
    
    global List<Case> start(Database.BatchableContext BC){
        
        string query= 'Select Id,Account_Number__c,Loan_Account_Type__c,Dispute_Detail__c,OwnerId,CaseNumber,Forward_to_bank__c,AccountId,ContactId, Displayed_Details__c,Correct_Details__c,Contact.Name,'+
            'Name_of_Consumer__r.Name,Name_of_Consumer__r.email,Name_of_Consumer__r.Phone,Name_of_Consumer__r.BirthDate,'+
            'Sub_Type_Lookup__r.Name,Account.Name, Displayed_Account_Type__c, Displayed_Account_number__c,'+
            'Name_of_Consumer__r.Account_No__c,Address__c,Displayed_Address__c,Displayed_Address_1_v1__c, Name_of_Consumer__r.Account_Type__c, Name_of_Consumer__r.Pan_no__c,Account.Person_Name_Dispute__c,Account.Phone_Dispute__c'+
            ' From Case Where status = \'Open\'  and (Case_Origin_2__c= \'NO\' or Case_Origin_2__c= \'Escalated Case\'	 or  Case_Origin_2__c = \'PNO\')';
        if(test.isRunningTest()){
            
        }else{
            query+= ' and Owner.Name =\'Bank Team\' ';
        } 
        
        // query+= ' )';
        
        List<Case> csList = database.query(query);
        return csList;
    }
    
    global void execute(Database.BatchableContext BC, List<Case> scope){
        set<Id> accId  = new set<Id>();
        for(Case cs : scope){
            accId.add(cs.AccountId);
        }   
        
        map<Id,Account> mapAccounts = new map<Id,Account>([select Id,Name, Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,
                                                           CC_Address_1__c, CC_Address_10__c, CC_Address_2__c, CC_Address_3__c, CC_Address_4__c, CC_Address_5__c, CC_Address_6__c,
                                                           CC_Address_7__c, CC_Address_8__c, CC_Address_9__c,
                                                           Email_4_Dispute__c,Email_5_Dispute__c,Email_6_Dispute__c,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c 
                                                           from Account where Id IN : accId]);
        
        Map<Id,Case> parentCaseMap = new Map<Id,Case>();
        List<Case> Caselist = [Select Id, AccountId,Account_s_Parent_Case__c from Case where Account_s_Parent_Case__c =:true and AccountId IN:accId];
        for(Case cs : Caselist){
            parentCaseMap.put(cs.AccountId,cs);
        }
        
        List<EmailMessage> EmailMessageList = new List<EmailMessage>();
        List<Messaging.Email> allMails = new List<Messaging.Email>();  
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'nodal.officer.india@experian.com'];
        
        List<Case> reminderMapCase = new List<Case>();
        List<Messaging.EmailFileAttachment> emcclist = new List<Messaging.EmailFileAttachment>();
        list<StaticResource> objPDFList = [Select body,ContentType, name from StaticResource where name IN ('OLM_Suppression_Demographic_Correction','Data_Correction_Formats')];
        for(StaticResource objPDF:objPDFList){
            Messaging.EmailFileAttachment objPDFAttachment = new Messaging.EmailFileAttachment();
            if(objPDF.name =='OLM_Suppression_Demographic_Correction'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.pdf');
                emcclist.add(objPDFAttachment);
            }else if(objPDF.name =='Data_Correction_Formats'){
                objPDFAttachment.setBody(objPDF.Body);
                objPDFAttachment.setFileName(objPDF.name + '.xlsb');
                emcclist.add(objPDFAttachment);
            }
        }  
        for(Case cs : scope){
            if(mapAccounts.containsKey(cs.AccountId)){
                Account ac = mapAccounts.get(cs.AccountId);
                List<string> emailList = new List<string>(); 
                if(string.isNotBlank(ac.Email_1_Dispute__c)){
                    if(!emailList.contains(ac.Email_1_Dispute__c)){}
                    emailList.add(ac.Email_1_Dispute__c);
                }
                if(string.isNotBlank(ac.Email_2_Dispute__c)){
                    if(!emailList.contains(ac.Email_2_Dispute__c)){}
                    emailList.add(ac.Email_2_Dispute__c);
                }
                if(string.isNotBlank(ac.Email_3_Dispute__c)){
                    if(!emailList.contains(ac.Email_3_Dispute__c)){}
                    emailList.add(ac.Email_3_Dispute__c);
                }
                if(string.isNotBlank(ac.Email_4_Dispute__c)){
                    if(!emailList.contains(ac.Email_4_Dispute__c)){}
                    emailList.add(ac.Email_4_Dispute__c);
                }
                if(string.isNotBlank(ac.Email_5_Dispute__c)){
                    if(!emailList.contains(ac.Email_5_Dispute__c)){}
                    emailList.add(ac.Email_5_Dispute__c);
                }
                if(string.isNotBlank(ac.Email_6_Dispute__c)){
                    if(!emailList.contains(ac.Email_6_Dispute__c)){}   
                    emailList.add(ac.Email_6_Dispute__c);
                }
                
                if(string.isNotBlank(ac.Email_7_Dispute__c)){
                    if(!emailList.contains(ac.Email_7_Dispute__c)){}   
                    emailList.add(ac.Email_7_Dispute__c);
                }
                if(string.isNotBlank(ac.Email_8_Dispute__c)){
                    if(!emailList.contains(ac.Email_8_Dispute__c)){}   
                    emailList.add(ac.Email_8_Dispute__c);
                }
                if(string.isNotBlank(ac.Email_9_Dispute__c)){
                    if(!emailList.contains(ac.Email_9_Dispute__c)){}   
                    emailList.add(ac.Email_9_Dispute__c);
                }
                if(string.isNotBlank(ac.Email_10_Dispute__c)){
                    if(!emailList.contains(ac.Email_10_Dispute__c)){}   
                    emailList.add(ac.Email_10_Dispute__c);
                }
                
                
                List<String> toCCAddresses = new List<String>();
                String emailCCId='';
                if(ac.CC_Address_1__c != null){
                    toCCAddresses.add(ac.CC_Address_1__c);
                    emailCCId += '; ' + ac.CC_Address_1__c;
                }
                
                if(ac.CC_Address_2__c != null){
                    toCCAddresses.add(ac.CC_Address_2__c);
                    emailCCId += '; ' + ac.CC_Address_2__c;
                }
                
                if(ac.CC_Address_3__c != null){
                    toCCAddresses.add(ac.CC_Address_3__c);
                    emailCCId += '; ' + ac.CC_Address_3__c;
                }
                
                if(ac.CC_Address_4__c != null){
                    toCCAddresses.add(ac.CC_Address_4__c);
                    emailCCId += '; ' + ac.CC_Address_4__c;
                }
                
                if(ac.CC_Address_5__c != null){
                    toCCAddresses.add(ac.CC_Address_5__c);
                    emailCCId += '; ' + ac.CC_Address_5__c;
                }
                
                if(ac.CC_Address_6__c != null){
                    toCCAddresses.add(ac.CC_Address_6__c);
                    emailCCId += '; ' + ac.CC_Address_6__c;
                }
                
                if(ac.CC_Address_7__c != null){
                    toCCAddresses.add(ac.CC_Address_7__c);
                    emailCCId += '; ' + ac.CC_Address_7__c;
                }
                
                if(ac.CC_Address_8__c != null){
                    toCCAddresses.add(ac.CC_Address_8__c);
                    emailCCId += '; ' + ac.CC_Address_8__c;
                }
                
                if(ac.CC_Address_9__c != null){
                    toCCAddresses.add(ac.CC_Address_9__c);
                    emailCCId += '; ' + ac.CC_Address_9__c;
                }
                
                if(ac.CC_Address_10__c != null){
                    toCCAddresses.add(ac.CC_Address_10__c);
                    emailCCId += '; ' + ac.CC_Address_10__c;
                }
                
                if(parentCaseMap.containsKey(ac.Id)){
                    cs.Reminder_Parent_Case__c = parentCaseMap.get(ac.Id).Id;
                    reminderMapCase.add(cs);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    string emailbody = '<p>Dear Team,</p>'; 
                    emailbody += '<p>As per RBI we are mandated by a 21 days (for banks) and 30 days (for CIC) TAT which we will breach in case we do not receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed. </p>';
                    
                    String DOB='';
                    
                    if(test.isRunningTest()){
                        // DOB = dt.format('MM/dd/yyyy'); 
                        DOB = '02/01/2021'; 
                    }
                    else{
                        date dt1 =cs.Name_of_Consumer__r.BirthDate; 
                        DOB = String.valueof(dt1); 
                    } 
                    if(cs.Sub_Type_Lookup__r.Name =='Account ownership issue' || cs.Sub_Type_Lookup__r.Name =='Demographic Details'){
                        emailbody+='<table border="1px" style="border-collapse:collapse;width:98%;border:1px solid #ddd"><thead><tr>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff;width:3%">Case No</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff;width:3%">Consumer name</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff;width:3%">Date of Birth</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff;width:5%">Address</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff;width:3%">Contact no</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff;width:3%">Email ID</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff;width:3%">PAN Detail</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff;width:3%">Member Name</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff;width:3%">Account Type</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff;width:3%">Account No</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff;width:8%">Dispute Details</th></tr></thead>';
                        
                    }else{
                        //Strbdy += '<table border="1px"><tr><th style="">Case No</th><th>Consumer name</th><th>Member Name</th><th>Account Type</th><th>Account No</th><th>Dispute Details</th></tr>';
                        emailbody+='<table border="1px" style="border-collapse:collapse;width:98%;border:1px solid #ddd"><thead><tr>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Case No</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Consumer name</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Member Name</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Account Type</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Account No</th>';
                        emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Dispute Details</th></tr></thead>';
                        
                    }
                    
                    if(cs.Sub_Type_Lookup__r.Name =='Account ownership issue' || cs.Sub_Type_Lookup__r.Name =='Demographic Details'){
                        string Displayed_Address_1 = cs.Displayed_Address__c != null ? cs.Displayed_Address__c : cs.Displayed_Address_1_v1__c;
                        emailbody += '<tbody><tr><td>' + cs.CaseNumber + '</td><td>' +checkNull(cs.Name_of_Consumer__r.Name) + '</td><td>' + DOB + '</td><td>' + checkNull(Displayed_Address_1) + '</td><td>' + checkNull(cs.Name_of_Consumer__r.Phone) + '</td><td>' + checkNull(cs.Name_of_Consumer__r.Email) + '</td><td>' + checkNull(cs.Name_of_Consumer__r.Pan_no__c) + '</td><td>' +  checkNull(cs.Account.Name)  + '</td><td>' + checkNull(cs.Displayed_Account_Type__c) + '</td><td>' + checkNull(cs.Displayed_Account_number__c) + '</td><td>' + checkNull(cs.Dispute_Detail__c) + '</td></tr>';  
                    }else{
                        emailbody += '<tbody><tr><td>' + cs.CaseNumber + '</td><td>' +checkNull(cs.Name_of_Consumer__r.Name) + '</td><td>' +  checkNull(cs.Account.Name)  + '</td><td>' + checkNull(cs.Displayed_Account_Type__c) + '</td><td>' + checkNull(cs.Displayed_Account_number__c) + '</td><td>' + checkNull(cs.Dispute_Detail__c) + '</td></tr>';  
                    }
                    
                    emailbody += '</tbody></table>';
                    
                    emailbody +=    '<br/><p>We request you to share the correction on the SFTP folder and share the file name with us. We do not accept changes in excel or on the email body.</p>';
                    
                    emailbody +=    '<p>If we have not addressed this to the right team, please help us with the right contacts within your organisation for this.<br /><br />Please treat this with high priority</p><p>';
                    
                    emailbody +=    '<p>Note: 1) Please fill only the Demographic Details sheet for correction regards to demographic changes.<br/>2) For correction regarding Suppression of Credit Enquiry or Account, please fill only the Suppression Request sheet.<br/>3) Except Demographic and Suppression, all other correction will be in Normal Updation sheet.</p><p>';
                    
                    //Added by balram on 09/07/2023
                    emailbody +=    '<p>Further, we request you to read the explanation of OLM in the file named “OLM Suppression Demographic Correction“ and then accordingly fill the form for correction.<br/><br/>Please feel free to contact us for any further queries.<br/><br />Regards,<br/></p>';
                    emailbody +=  '<p>Consumer Support Team <br/>' + 'Experian Credit Information Company of India Private Limited  <br/>' + 'www.experian.in <br/><br/> Get your Experian Credit Report & Score today, <a href="https://consumer.experian.in/ECV-OLN/#/experianHome">click here</a></p></body></html>';
                    
                    
                    ID orgId = UserInfo.getOrganizationId();
                    String sOrgId = (string)orgId;
                    ID caseId = cs.Id;
                    String sCaseId = (string)caseId;
                    String threadIdPart1 = 'ref:_' + sOrgId.left(5) + sOrgId.right(10).replace('0','');
                    threadIdPart1 = threadIdPart1.substring(0,threadIdPart1.length()-3);
                    String threadIdPart2 = '._' + sCaseId.Left(5) + sCaseId.right(10).left(5).replace('0','') + sCaseId.right(5);
                    threadIdPart2 = threadIdPart2.substring(0,threadIdPart2.length()-3)+':ref';
                    String threadId = threadIdPart1 + threadIdPart2;  
                    System.debug('Thread Id^^'+threadId);
                    
                    mail.setUseSignature(false);
                    mail.setBccAddresses(emailList);
                    if(toCCAddresses.size() > 0)
                     mail.setCCAddresses(toCCAddresses);
                    
                    EmailMessage em=new EmailMessage();
                    em.subject = 'Open Disputes Reminder('+ac.Name+')'+ '[ '+ threadId +' ]';
                    em.RelatedToId=cs.Id;  
                    em.ToAddress = string.join(emailList,',');
                    em.MessageDate=system.now();
                    
                    if(string.isNotBlank(emailCCId))
                       em.CcAddress = emailCCId;
                    
                    em.Incoming=false;
                    em.Email_Body__c =emailbody;
                    em.Status='3';
                    em.FromAddress='nodal.officer.india@experian.com';
                    em.FromName='Nodal Officer';
                    EmailMessageList.add(em);
                    
                    if ( owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    }
                    mail.htmlbody = emailbody + '<br /> ';
                    mail.subject='Open Disputes Reminder('+ac.Name+')'+ '[ '+ threadId +' ]';
                    mail.setFileAttachments(emcclist);
                    allMails.add(mail);
                    
                }
            }
        }
        
        
        List<API_LOG__c> apliLogList = new List<API_LOG__c>();
        if(reminderMapCase.size() > 0){
            Database.SaveResult[] srList = Database.update(reminderMapCase,false);
            system.debug('updated get record '+srList.size());
            for(Integer i=0;i<srList.size();i++){
                system.debug('Error 67-->'+srList.get(i).isSuccess());
                
                if(srList.get(i).isSuccess()){
                    try{
                        List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
                        
                        for(Messaging.SendEmailResult result: results){
                            if(result.isSuccess()){
                                insert EmailMessageList;
                            }
                            
                        }
                        
                    }
                    catch(exception e){
                        API_LOG__c ap =new API_LOG__c();
                        ap.Request_Source__c='Queable NO/PNO/Escalated Send Email Failed of Case ';
                        ap.Exception_Description__c =e.getLineNumber()+' '+ e.getMessage();
                        apliLogList.add(ap);   
                    }
                }else 
                    if(!srList.get(i).isSuccess()){
                        //system.debug('Error 69 inside fail'+srList[i].getErrors());
                        for(Database.Error err : srList[i].getErrors()) {
                            
                            API_LOG__c ap =new API_LOG__c();
                            ap.Request_Source__c='Queable NO/PNO/Escalated Case Update  Failed';
                            ap.Case__c = srList[i].Id;
                            ap.Exception_Description__c = err.getMessage();
                            apliLogList.add(ap);
                            
                        }
                    }
                
            }
            
            
        }
        
        if(apliLogList.size() > 0){
            insert apliLogList;
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
    
    private static String checkNull(Object obj) {
        if(obj == null)
            return '';
        else
            return String.valueOf(obj).trim().escapeCsv()+'';
    }
    
}