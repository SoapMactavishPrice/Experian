//On click forward to Bank on account, Send email to Bank with case details.
public class sendMailtoBank{
    
    public static void sendInstantMail(Map<Id, Case> mapIdcse , Map<Id, Case> oldMapCse, Map<Id, Case> newMap) {
        System.debug('mapIdcse '+mapIdcse );
        System.debug('oldMapCse '+oldMapCse );
        String emailId='';
        Id bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;
        
        
        String Name = UserInfo.getName();
        String UserEmail = UserInfo.getUserEmail();
        
        //Collected Account and its all related case.
        Map<Id, List<Case>> mapAccId_listcase = new Map<Id, List<Case>>();
        List<Case> listcase = new List<Case>();
        List<Case> casesToUpdate = new List<Case>();
        Id owea = DataClass.getConsumerSupport();
        //OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'consumer.support@in.experian.com' limit 1];// To send from Org wide address
        
        
        for(Case cse : [Select Id, Account_Number__c, Loan_Account_Type__c, Dispute_Detail__c, OwnerId,CaseNumber, Forward_to_bank__c, AccountId, ContactId, Displayed_Details__c,Correct_Details__c,Contact.Name,
                        Name_of_Consumer__r.Name,Name_of_Consumer__r.email, Name_of_Consumer__r.Phone,Name_of_Consumer__r.BirthDate,
                        Sub_Type_Lookup__r.Name, Name_of_Consumer__r.Account_No__c,Address__c,Displayed_Address__c,Displayed_Address_1_v1__c, Name_of_Consumer__r.Account_Type__c, Name_of_Consumer__r.Pan_no__c,Account.Person_Name_Dispute__c,Account.Phone_Dispute__c,
                        Account.Name, Account.Email_Dispute__c, Account.Email_1_Dispute__c, Account.Email_2_Dispute__c, Account.Email_3_Dispute__c,
                        Account.Email_4_Dispute__c,Account.Email_5_Dispute__c,Account.Email_6_Dispute__c, Account.Email_7_Dispute__c,
                        Account.Email_8_Dispute__c, Account.Email_9_Dispute__c, Account.Email_10_Dispute__c,
                         Account.CC_Address_1__c,  Account.CC_Address_2__c,  Account.CC_Address_3__c, Account.CC_Address_4__c,
                         Account.CC_Address_5__c,  Account.CC_Address_6__c,  Account.CC_Address_7__c,  Account.CC_Address_8__c,
                         Account.CC_Address_9__c,  Account.CC_Address_10__c,                        
                        Forward_to_Bank_Date__c,DIS_Id__c,Displayed_Values__c,Correct_Values__c,Enquiry_Date__c,
                        Mail_Sent__c, Displayed_Account_Type__c, Displayed_Account_number__c,Date_of_the_email_received__c
                       from Case 
                        where OwnerId =:bankteamId 
                        AND Forward_to_bank__c = true 
                        AND Id =: mapIdcse.keyset()
                        And Mail_Sent__c = false]){
                            listcase.add(cse);
                        }
        System.debug('listcase '+listcase.size() );
        List<Case> caseupdate = new List<Case>();
        for(Case cse :listcase){
            //System.debug('oldMapCse.get(cse.Id).Forward_to_bank__c '+listcase );
            
            if(oldMapCse.get(cse.Id).Forward_to_bank__c != mapIdcse.get(cse.Id).Forward_to_bank__c){
                
                if(cse.AccountId!= NULL && cse.Forward_to_bank__c == true && cse.OwnerId == bankteamId && cse.Mail_Sent__c==false){
                    
                    if(mapAccId_listcase.containskey(cse.AccountId)){
                        
                        List<Case> lst_cse = mapAccId_listcase.get(cse.AccountId);
                        lst_cse.add(cse);
                        mapAccId_listcase.put(cse.AccountId,lst_cse);  
                        newMap.get(cse.Id).Mail_Sent__c=true;
                    }
                    else {
                        mapAccId_listcase.put(cse.AccountId, new List<Case> {cse});
                        newMap.get(cse.Id).Mail_Sent__c=true;
                    }
                }
            }
        }
        System.debug('mapAccId_listcase.size() '+mapAccId_listcase.size() );
        string subject = '';
        if(mapAccId_listcase.size()>0){
            
            String Strbdy='';
            String EmailBody='';
            
            List<Messaging.SingleEmailMessage> mailList = new List <Messaging.SingleEmailMessage> ();
            
            for(Account acc : [Select Id, Name, Email_Dispute__c,Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,Email_4_Dispute__c,Email_5_Dispute__c,
                               Email_6_Dispute__c,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c, 
                               CC_Address_1__c, CC_Address_2__c, CC_Address_3__c, CC_Address_4__c, CC_Address_5__c, CC_Address_6__c,
                               CC_Address_7__c, CC_Address_8__c, CC_Address_9__c, CC_Address_10__c
                               from Account where Id In :mapAccId_listcase.keyset()])
            { 
                
                System.debug('owea  '+owea); // balramp610@gmail.com   consumer.support@in.experian.com	
                
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage(); 
                
                //if ( owea.size() > 0 ) {
                //System.debug('inside');  
                //message.setOrgWideEmailAddressId(owea.get(0).Id);
                //}  
                
                if(String.IsNotBlank(owea)) {
                    System.debug('inside');  
                    message.setOrgWideEmailAddressId(owea);
                }
                
                
                //message.setSenderDisplayName('Experian Consumer Support');
                //message.setReplyTo('No-reply@Experian.com');
                message.setUseSignature(false); 
                message.setBccSender(false);
                message.setSaveAsActivity(false); 
                
                for (Case cs: mapAccId_listcase.get(acc.Id)) {
                    
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
                    //Case No - 04033182, Dispute ID - 222222, Muskanbee Shaikh [ ref:_00D2v1ddYE._500Ny9dUkD:ref ]
                    
                    subject = 'Case No - ' +cs.CaseNumber +', Dispute ID - '+cs.DIS_Id__c+', '+cs.Name_of_Consumer__r.Name +' '+ '[ '+ threadId + ' ]';
                    
                    message.setSubject(subject);
                }
                
                Strbdy = '<style>table{border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #ddd}td,th{padding:10px;border:1px solid #ddd}';
                Strbdy += 'th{font-size:11px;font-weight:100;text-align:center;background-color:#1798c1;color:#fff}td{font-size:11px;font-weight:100;text-align:center}</style>';
                
                Strbdy += '<p>Dear Team,</p>';
                EmailBody += '<p>Dear Team,</p>';                             
                
                //Strbdy += '<p>As per RBI we are mandated by a 21 days (for banks) and 30 days (for CIC) TAT which we will breach in case we do not receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed. </p>';
                //EmailBody += '<p>As per RBI we are mandated by a 21 days (for banks) and 30 days (for CIC) TAT which we will breach in case we do not receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed. </p>';
                
                
                
                
                for (Case cs: mapAccId_listcase.get(acc.Id)) { 
                    
                    Date forToBank = cs.Name_of_Consumer__r.BirthDate; //BirthDate is a date field, it will be converted to datetime automatically.
                    String forToBankDate;
                    
                    if(test.isRunningTest()){
                        // DOB = dt.format('MM/dd/yyyy'); 
                        forToBankDate = '02/01/2021'; 
                    }
                    else{
                        system.debug('Forward_to_Bank_Date__c	'+cs.Forward_to_Bank_Date__c);
                        DateTime myDate = Datetime.NOW();
                        forToBankDate = myDate.format('dd/MM/YYYY'); 
                    } 
                    
                    Strbdy += '<p>We have raised a dispute on '+forToBankDate +' with you as per following details.</p>';
                    EmailBody += '<p>We have raised a dispute on ' + forToBankDate +' with you as per following details.</p>';
                    
                    if(cs.Sub_Type_Lookup__r.Name =='Account ownership issue' || cs.Sub_Type_Lookup__r.Name =='Demographic Details' || cs.Sub_Type_Lookup__r.Name=='Enquiry ownership issue'){
                        
                        //removed last column by balram on 09/07/023  
                        Strbdy += '<table border="1px" ><tr><th>Case No</th><th>Email Received Date</th><th>Consumer name</th><th>Date of Birth</th><th>Contact No</th><th>Email ID</th><th>PAN Detail</th><th>Member Name</th><th>Account Type</th><th>Account No / Enquiry Request No</th><th>Dispute Details</th><th>Displayed Value</th><th>Correct Value</th><th>Enquiry Date</th></tr>';
                        //EmailBody += '<table border="1px" style="border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #ddd"><tr><th style="background-color:#1798c1;color:#fff">Case No</th><th style="background-color:#1798c1;color:#fff">Consumer name</th><th style="background-color:#1798c1;color:#fff">Date of Birth</th><th style="background-color:#1798c1;color:#fff">Address</th><th style="background-color:#1798c1;color:#fff">Contact no</th><th style="background-color:#1798c1;color:#fff">Email ID</th><th style="background-color:#1798c1;color:#fff">PAN Detail</th><th style="background-color:#1798c1;color:#fff">Member Name</th><th style="background-color:#1798c1;color:#fff">Account Type</th><th style="background-color:#1798c1;color:#fff">Account No</th><th style="background-color:#1798c1;color:#fff">Dispute Details</th></tr>';
                        EmailBody += '<table border="1px" style="border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #ddd"><tr><th style="background-color:#1798c1;color:#fff">Case No</th><th style="background-color:#1798c1;color:#fff">Email Received Date</th><th style="background-color:#1798c1;color:#fff">Consumer name</th><th style="background-color:#1798c1;color:#fff">Date of Birth</th><th style="background-color:#1798c1;color:#fff">Contact No</th><th style="background-color:#1798c1;color:#fff">Email ID</th><th style="background-color:#1798c1;color:#fff">PAN Detail</th><th style="background-color:#1798c1;color:#fff">Member Name</th><th style="background-color:#1798c1;color:#fff">Account Type</th><th style="background-color:#1798c1;color:#fff">Account No / Enquiry Request No</th><th style="background-color:#1798c1;color:#fff">Dispute Details</th><th style="background-color:#1798c1;color:#fff">Displayed Value</th><th style="background-color:#1798c1;color:#fff">Correct Value</th><th style="background-color:#1798c1;color:#fff">Enquiry Date</th></tr>';
                        
                    }else{
                        Strbdy += '<table border="1px"><tr><th>Case No</th><th>Email Received Date</th><th>Consumer name</th><th>Member Name</th><th>Account Type</th><th>Account No / Enquiry Request No</th><th>Dispute Details</th><th>Displayed Value</th><th>Correct Value</th><th>Enquiry Date</th></tr>';
                        EmailBody += '<table border="1px" style="border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #ddd"><tr><th style="background-color:#1798c1;color:#fff">Case No</th><th style="background-color:#1798c1;color:#fff">Email Received Date</th><th style="background-color:#1798c1;color:#fff">Consumer name</th><th style="background-color:#1798c1;color:#fff">Member Name</th><th style="background-color:#1798c1;color:#fff">Account Type</th><th style="background-color:#1798c1;color:#fff">Account No / Enquiry Request No</th><th style="background-color:#1798c1;color:#fff">Dispute Details</th><th style="background-color:#1798c1;color:#fff">Displayed Value</th><th style="background-color:#1798c1;color:#fff">Correct Value</th><th style="background-color:#1798c1;color:#fff">Enquiry Date</th></tr>';
                        
                    }
                    
                }     
                for (Case cs: mapAccId_listcase.get(acc.Id)) { 
                    
                    Date dt = cs.Name_of_Consumer__r.BirthDate; //BirthDate is a date field, it will be converted to datetime automatically.
                    String DOB;
                    
                    Date EnquiryDate = cs.Enquiry_Date__c;
                    String EOB;
                    
                    String DOB2;
                    
                    if(test.isRunningTest()){
                        DOB = '02/01/2021'; 
                        EOB = '02/01/2021';
                        DOB2 = '02/01/2021';
                    }
                    else{
                        date dt1 =cs.Name_of_Consumer__r.BirthDate; 
                        DOB = String.valueof(dt1); 
                        
                        date dt2 =cs.Enquiry_Date__c; 
                        EOB = String.valueof(dt2); 
                        
                        date dt3 =cs.Date_of_the_email_received__c;
                        if(string.isNotBlank(string.valueOf(dt3))){
                            DOB2 = String.valueof(dt3);
                        }else{
                            DOB2 = '-';
                        }
                    } 
                    
                    if(cs.Sub_Type_Lookup__r.Name =='Account ownership issue' || cs.Sub_Type_Lookup__r.Name =='Demographic Details' || cs.Sub_Type_Lookup__r.Name=='Enquiry ownership issue'){
                        //Strbdy += '<tr><td>' + cs.CaseNumber + '</td><td>' + cs.Name_of_Consumer__r.Name + '</td><td>' + DOB + '</td><td>' + cs.Name_of_Consumer__r.Phone + '</td><td>' + cs.Name_of_Consumer__r.Email + '</td><td>' + cs.Name_of_Consumer__r.Pan_no__c + '</td><td>' +  cs.Account.Name  + '</td><td>' + cs.Displayed_Account_Type__c + '</td><td>' + cs.Displayed_Account_number__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Displayed_Details__c + '</td><td>' + cs.Correct_Details__c + '</td></tr>';  
                        //EmailBody += '<tr><td>' + cs.CaseNumber + '</td><td>' + cs.Name_of_Consumer__r.Name + '</td><td>' + DOB + '</td><td>' + cs.Name_of_Consumer__r.Phone + '</td><td>' + cs.Name_of_Consumer__r.Email + '</td><td>' + cs.Name_of_Consumer__r.Pan_no__c + '</td><td>' +  cs.Account.Name  + '</td><td>' + cs.Displayed_Account_Type__c + '</td><td>' + cs.Displayed_Account_number__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Displayed_Details__c + '</td><td>' + cs.Correct_Details__c + '</td></tr>';
                        Strbdy += '<tr><td>' + cs.CaseNumber + '</td><td>' + DOB2 + '</td><td>' + cs.Name_of_Consumer__r.Name + '</td><td>' + DOB + '</td><td>' + cs.Name_of_Consumer__r.Phone + '</td><td>' + cs.Name_of_Consumer__r.Email + '</td><td>' + cs.Name_of_Consumer__r.Pan_no__c + '</td><td>' +  cs.Account.Name  + '</td><td>' + cs.Displayed_Account_Type__c + '</td><td>' + cs.Displayed_Account_number__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Displayed_Values__c + '</td><td>' + cs.Correct_Values__c + '</td><td>' + EOB + '</td></tr>';  
                        EmailBody += '<tr><td>' + cs.CaseNumber + '</td><td>' + DOB2 + '</td><td>' + cs.Name_of_Consumer__r.Name + '</td><td>' + DOB + '</td><td>' + cs.Name_of_Consumer__r.Phone + '</td><td>' + cs.Name_of_Consumer__r.Email + '</td><td>' + cs.Name_of_Consumer__r.Pan_no__c + '</td><td>' +  cs.Account.Name  + '</td><td>' + cs.Displayed_Account_Type__c + '</td><td>' + cs.Displayed_Account_number__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Displayed_Values__c + '</td><td>' + cs.Correct_Values__c + '</td><td>' + EOB + '</td></tr>';
                    }else{
                        //Strbdy += '<tr><td>' + cs.CaseNumber + '</td><td>' + cs.Name_of_Consumer__r.Name + '</td><td>' +  cs.Account.Name  + '</td><td>' + cs.Displayed_Account_Type__c + '</td><td>' + cs.Displayed_Account_number__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Displayed_Details__c + '</td><td>' + cs.Correct_Details__c + '</td></tr>';  
                        //EmailBody += '<tr><td>' + cs.CaseNumber + '</td><td>' + cs.Name_of_Consumer__r.Name + '</td><td>' +  cs.Account.Name  + '</td><td>' + cs.Displayed_Account_Type__c + '</td><td>' + cs.Displayed_Account_number__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Displayed_Details__c + '</td><td>' + cs.Correct_Details__c + '</td></tr>';
                        Strbdy += '<tr><td>' + cs.CaseNumber + '</td><td>' + DOB2 + '</td><td>' + cs.Name_of_Consumer__r.Name + '</td><td>' +  cs.Account.Name  + '</td><td>' + cs.Displayed_Account_Type__c + '</td><td>' + cs.Displayed_Account_number__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Displayed_Values__c + '</td><td>' + cs.Correct_Values__c + '</td><td>' + EOB + '</td></tr>';  
                        EmailBody += '<tr><td>' + cs.CaseNumber + '</td><td>' + DOB2 + '</td><td>' + cs.Name_of_Consumer__r.Name + '</td><td>' +  cs.Account.Name  + '</td><td>' + cs.Displayed_Account_Type__c + '</td><td>' + cs.Displayed_Account_number__c + '</td><td>' + cs.Dispute_Detail__c + '</td><td>' + cs.Displayed_Values__c + '</td><td>' + cs.Correct_Values__c + '</td><td>' + EOB + '</td></tr>';
                    }
                }                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
                
                Strbdy += '</table><br/>';
                EmailBody += '</table><br/';
                
                //Strbdy +=    '<br/><p>We request you to share the correction on the SFTP folder and share the file name with us. We do not accept changes in excel or on the email body.</p>';
                /// EmailBody += '<br/><p>We request you to share the correction on the SFTP folder and share the file name with us. We do not accept changes in excel or on the email body.</p>';
                
                //adde by rishikesh 07/06/2024
                strbdy += '<p>We request you to examine the same at your end and share the response:<p/>';
                EmailBody += '<p>We request you to examine the same at your end and share the response:<p/>';
                
                
                strbdy += '    1.Correction, if any, on the SFTP folder and share the file name with us (Mention OLM in file Name). We do not accept changes in excel or on the email body.<br/>';
                EmailBody += '    1.Correction, if any, on the SFTP folder and share the file name with us (Mention OLM in file Name). We do not accept changes in excel or on the email body.<br/>';
                
                
                strbdy += '    2.If no change, either through excel or on the email body. Kindly do not share on SFTP.<br/><br/>';
                EmailBody += '    2.If no change, either through excel or on the email body. Kindly do not share on SFTP.<br/><br/>';
                
                strbdy +='As per RBI guidelines the disputes need to be resolved within 30 days (21 days for CIs) from the date of raising the same.<br/><br/>';
                EmailBody +='As per RBI guidelines the disputes need to be resolved within 30 days (21 days for CIs) from the date of raising the same.<br/><br/>';
                
                
                strbdy+='The consumer is looking for a rectified report.<br/>';
                EmailBody+='The consumer is looking for a rectified report.<br/>';
                
                
                //Added by balram on 09/07/2023
                Strbdy +=    '<p>If we have not addressed this to the right team, please help us with the right contacts within your organisation for this.<br /><br />Please treat this as a high priority.</p><p>';
                EmailBody += '<p>If we have not addressed this to the right team, please help us with the right contacts within your organisation for this.<br /><br />Please treat this as a high priority.</p><p>';
                
                //Added by balram on 09/07/2023
                Strbdy +=    '<p>Note: 1) Please fill only the Demographic Details sheet for correction regards to demographic changes.<br/>2) For correction regarding Suppression of Credit Enquiry or Account, please fill only the Suppression Request sheet.<br/>3) Except Demographic and Suppression, all other correction will be in Normal Updation sheet.</p><p>';
                EmailBody += '<p>Note: 1) Please fill only the Demographic Details sheet for correction regards to demographic changes.<br/>2) For correction regarding Suppression of Credit Enquiry or Account, please fill only the Suppression Request sheet.<br/>3) Except Demographic and Suppression, all other correction will be in Normal Updation sheet.</p><p>';
                
                //Added by balram on 09/07/2023
                Strbdy +=    '<p>Further, we request you to read the explanation of OLM in the file named “OLM Suppression Demographic Correction“ and then accordingly fill the form for correction.<br/><br/>Please feel free to contact us for any further queries.<br/><br />Regards,<br /></p><p>';
                EmailBody += '<p>Further, we request you to read the explanation of OLM in the file named “OLM Suppression Demographic Correction“ and then accordingly fill the form for correction.<br/><br/>Please feel free to contact us for any further queries.<br/><br />Regards,<br /></p><p>';
                
                Strbdy +=    '<p>Consumer Support Team <br/>' + 'Experian Credit Information Company of India Private Limited  <br/>' + 'www.experian.in <br/><br/> Get your Experian Credit Report & Score today, <a href="https://consumer.experian.in/ECV-OLN/#/experianHome">click here</a></p>';
                EmailBody += '<p>Consumer Support Team <br/>' + 'Experian Credit Information Company of India Private Limited  <br/>' + 'www.experian.in <br/><br/> Get your Experian Credit Report & Score today, <a href="https://consumer.experian.in/ECV-OLN/#/experianHome">click here</a></p>';
                
                List<String> toAddresses = new List<String>();  
                
                if(acc.Email_Dispute__c != null){ 
                    
                    String str = acc.Email_Dispute__c;
                    emailid=acc.Email_Dispute__c;            
                    String[] arrTest = str.split('\\;');
                    
                    for(String emailstr :arrTest){
                        toAddresses.add(emailstr);
                    }  
                    
                    toAddresses.add(acc.Email_Dispute__c);
                    
                    system.debug('****Email test &&& -- '+toAddresses);
                }
                
                if(acc.Email_1_Dispute__c != null){
                    toAddresses.add(acc.Email_1_Dispute__c);
                    emailId += '; '+acc.Email_1_Dispute__c;
                }
                
                if(acc.Email_2_Dispute__c != null){
                    toAddresses.add(acc.Email_2_Dispute__c);
                    emailId += '; '+acc.Email_2_Dispute__c;
                }
                
                if(acc.Email_3_Dispute__c != null){
                    toAddresses.add(acc.Email_3_Dispute__c);
                    emailId += '; '+acc.Email_3_Dispute__c;
                }
                
                if(acc.Email_4_Dispute__c != null){
                    toAddresses.add(acc.Email_4_Dispute__c);
                    emailId += '; '+acc.Email_4_Dispute__c;
                }
                
                if(acc.Email_5_Dispute__c != null){
                    toAddresses.add(acc.Email_5_Dispute__c); 
                    emailId += '; '+acc.Email_5_Dispute__c;
                }
                
                if(acc.Email_6_Dispute__c != null){
                    toAddresses.add(acc.Email_6_Dispute__c);
                    emailId += '; '+acc.Email_6_Dispute__c;
                } 
                
                if(acc.Email_7_Dispute__c != null){
                    toAddresses.add(acc.Email_7_Dispute__c);
                    emailId += '; '+acc.Email_7_Dispute__c;
                } 
                
                if(acc.Email_8_Dispute__c != null){
                    toAddresses.add(acc.Email_8_Dispute__c);
                    emailId += '; '+acc.Email_8_Dispute__c;
                } 
                
                if(acc.Email_9_Dispute__c != null){
                    toAddresses.add(acc.Email_9_Dispute__c);
                    emailId += '; '+acc.Email_9_Dispute__c;
                } 
                
                if(acc.Email_10_Dispute__c != null){
                    toAddresses.add(acc.Email_10_Dispute__c);
                    emailId += '; '+acc.Email_10_Dispute__c;
                } 
                
                // CC Address
                if(acc.CC_Address_1__c != null){
                    toAddresses.add(acc.CC_Address_1__c);
                    emailId += '; '+acc.CC_Address_1__c;
                }
                
                if(acc.CC_Address_2__c != null){
                    toAddresses.add(acc.CC_Address_2__c);
                    emailId += '; '+acc.CC_Address_2__c;
                }
                
                if(acc.CC_Address_3__c != null){
                    toAddresses.add(acc.CC_Address_3__c);
                    emailId += '; '+acc.CC_Address_3__c;
                }
                
                if(acc.CC_Address_4__c != null){
                    toAddresses.add(acc.CC_Address_4__c);
                    emailId += '; '+acc.CC_Address_4__c;
                }
                
                if(acc.CC_Address_5__c != null){
                    toAddresses.add(acc.CC_Address_5__c); 
                    emailId += '; '+acc.CC_Address_5__c;
                }
                
                if(acc.CC_Address_6__c != null){
                    toAddresses.add(acc.CC_Address_6__c);
                    emailId += '; '+acc.CC_Address_6__c;
                } 
                
                if(acc.CC_Address_7__c != null){
                    toAddresses.add(acc.CC_Address_7__c);
                    emailId += '; '+acc.CC_Address_7__c;
                } 
                
                if(acc.CC_Address_8__c != null){
                    toAddresses.add(acc.CC_Address_8__c);
                    emailId += '; '+acc.CC_Address_8__c;
                } 
                
                if(acc.CC_Address_9__c != null){
                    toAddresses.add(acc.CC_Address_9__c);
                    emailId += '; '+acc.CC_Address_9__c;
                } 
                
                if(acc.CC_Address_10__c != null){
                    toAddresses.add(acc.CC_Address_10__c);
                    emailId += '; '+acc.CC_Address_10__c;
                } 
                
                message.setToAddresses(toAddresses); 
                message.setHtmlBody(Strbdy);
                
                
                Set<String> LatestPublishedVersionIds = new Set<String>();
                for(OLM_Format__c olmFormat : [Select Id from OLM_Format__c]) {
                    for(ContentDocumentLink cv : [select Id, ContentDocumentId, ContentDocument.LatestPublishedVersionId
                                                  from ContentDocumentLink where LinkedEntityId =: olmFormat.Id])
                    {
                        LatestPublishedVersionIds.add(cv.ContentDocument.LatestPublishedVersionId);
                        
                    }
                }
                
                if(LatestPublishedVersionIds.size() > 0) {
                    List<String> LatestPublishedVersionIdList = new List<String>();
                    LatestPublishedVersionIdList.addAll(LatestPublishedVersionIds);
                    message.setEntityAttachments(LatestPublishedVersionIdList);
                }
                
                mailList.add(message);
            }
            
            Messaging.sendEmail(mailList); 
            
            EmailMessage em=new EmailMessage();
            em.Subject = 'Forward to Bank';
            em.RelatedToId = listcase[0].id;  
            em.ToAddress = emailId;
            em.MessageDate = system.now();
            em.Incoming = false;
            em.Email_Body__c = EmailBody;
            em.Status='3';
            em.FromAddress='consumer.support@in.experian.com';
            em.FromName='Experian Consumer Support';
            insert em;
        }
    }
}