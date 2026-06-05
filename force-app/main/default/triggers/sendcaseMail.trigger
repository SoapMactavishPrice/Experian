trigger sendcaseMail on Case (before insert, before update, after update, after insert) {
    
    if(trigger.isBefore && trigger.isUpdate) {
        Set<Id> accIds = new Set<Id>();
        for(Case cs : trigger.new) {
           
            if(String.isBlank(cs.Dispute_Email_1__c) || String.isBlank(cs.Dispute_Email_2__c)  || String.isBlank(cs.Dispute_Email_3__c)  || String.isBlank(cs.Dispute_Email_4__c) ||
               String.isBlank(cs.Dispute_Email_5__c) || String.isBlank(cs.Dispute_Email_6__c)  || String.isBlank(cs.Dispute_Email_7__c)  || String.isBlank(cs.Dispute_Email_8__c) ||
               String.isBlank(cs.Dispute_Email_9__c) || String.isBlank(cs.Dispute_Email_10__c) || String.isBlank(cs.CC_Address_1__c)     || String.isBlank(cs.CC_Address_2__c)    ||
               String.isBlank(cs.CC_Address_3__c)    || String.isBlank(cs.CC_Address_4__c)     || String.isBlank(cs.CC_Address_5__c)     || String.isBlank(cs.CC_Address_6__c)    ||
               String.isBlank(cs.CC_Address_7__c)    || String.isBlank(cs.CC_Address_8__c)     || String.isBlank(cs.CC_Address_9__c )    || String.isBlank(cs.CC_Address_10__c)                                                                                                              
              ) {
                   accIds.add(cs.AccountId);
               }
        }
        
        if(accIds.size() > 0) {
            Map<Id, Account> mapAccounts = new Map<Id, Account>([SELECT Id, Email_Dispute__c, Email_1_Dispute__c, Email_2_Dispute__c, Email_3_Dispute__c, Email_4_Dispute__c,
                                                                 Email_5_Dispute__c, Email_6_Dispute__c, Email_7_Dispute__c, Email_8_Dispute__c, Email_9_Dispute__c, Email_10_Dispute__c,
                                                                 CC_Address_1__c, CC_Address_2__c, CC_Address_3__c, CC_Address_4__c, CC_Address_5__c, CC_Address_6__c,
                                                                 CC_Address_7__c, CC_Address_8__c, CC_Address_9__c, CC_Address_10__c
                                                                 FROM Account WHERE Id IN: accIds]);
            
            for(Case cs : trigger.new) {
                if(cs.Temp_Forward_to_Bank__c == true && (String.isBlank(cs.Dispute_Email_1__c) || String.isBlank(cs.Dispute_Email_2__c) ||
                                                          String.isBlank(cs.Dispute_Email_3__c) || String.isBlank(cs.Dispute_Email_4__c) ||
                                                          String.isBlank(cs.Dispute_Email_5__c) || String.isBlank(cs.Dispute_Email_6__c) || 
                                                          String.isBlank(cs.Dispute_Email_7__c) || String.isBlank(cs.Dispute_Email_8__c) ||
                                                          String.isBlank(cs.Dispute_Email_9__c) || String.isBlank(cs.Dispute_Email_10__c))) {
                                                              
                                                              if(mapAccounts.containsKey(cs.AccountId)) {
                                                                  Account acc = mapAccounts.get(cs.AccountId);
                                                                  cs.Dispute_Email_1__c = acc.Email_1_Dispute__c;
                                                                  cs.Dispute_Email_2__c = acc.Email_2_Dispute__c;
                                                                  cs.Dispute_Email_3__c = acc.Email_3_Dispute__c;
                                                                  cs.Dispute_Email_4__c = acc.Email_4_Dispute__c;
                                                                  cs.Dispute_Email_5__c = acc.Email_5_Dispute__c;
                                                                  cs.Dispute_Email_6__c = acc.Email_6_Dispute__c;
                                                                  cs.Dispute_Email_7__c = acc.Email_7_Dispute__c;
                                                                  cs.Dispute_Email_8__c = acc.Email_8_Dispute__c;
                                                                  cs.Dispute_Email_9__c = acc.Email_9_Dispute__c;
                                                                  cs.Dispute_Email_10__c = acc.Email_10_Dispute__c;
                                                                  
                                                                  cs.CC_Address_1__c = acc.CC_Address_1__c;
                                                                  cs.CC_Address_2__c = acc.CC_Address_2__c;
                                                                  cs.CC_Address_3__c = acc.CC_Address_3__c;
                                                                  cs.CC_Address_4__c = acc.CC_Address_4__c;
                                                                  cs.CC_Address_5__c = acc.CC_Address_5__c;
                                                                  cs.CC_Address_6__c = acc.CC_Address_6__c;
                                                                  cs.CC_Address_7__c = acc.CC_Address_7__c;
                                                                  cs.CC_Address_8__c = acc.CC_Address_8__c;
                                                                  cs.CC_Address_9__c = acc.CC_Address_9__c;
                                                                  cs.CC_Address_10__c = acc.CC_Address_10__c;
                                                              }
                                                          }
            }
        }
        
    }
    
    if(Trigger.isBefore ){
        if(Trigger.isInsert || Trigger.isUpdate){
            for(Case cs : Trigger.New) {
                try {
                    if(String.isNotBlank(cs.Description)) {
                        if(cs.Description.length() > 255)
                            cs.Description__c = cs.Description.subString(0, 255);
                        else
                            cs.Description__c = cs.Description;
                    }
                } Catch(Exception e) {
                    System.debug(e);
                }
            }
        }
        
    }
    
    List<Case> cs_list=new List<Case>();
    
    System.debug(RecursiveTriggerHandler.isFirstTimeSendCaseMail);
    if(Trigger.isBefore && Trigger.isUpdate && RecursiveTriggerHandler.isFirstTimeSendCaseMail){
        RecursiveTriggerHandler.isFirstTimeSendCaseMail = false;
        System.debug('inside if');
        String display_details='';
        String correct_details='';
        for(Case cs : trigger.new){
            
            // Case  NewCase = trigger.new[0];
            // Case OldCase = trigger.old[0]; 
            
            Case NewCase = cs;
            Case OldCase = Trigger.oldMap.get(cs.Id);
            
            System.debug(oldCase);
            System.debug(newCase);
            Case CaseObject = new Case(); // This takes all available fields from the required object. Schema.SObjectType objType = LeadObject.getSObjectType(); 
            Map<String, Schema.SObjectField> M = Schema.SObjectType.Case.fields.getMap(); 
            
            for (String str : M.keyset()) { 
                try { 
                    // System.debug('Field name: '+str +'. New value: ' + NewCase.get(str) +'. Old value: '+OldCase.get(str)); 
                    if(NewCase.get(str) != OldCase.get(str))
                    { 
                        System.debug(str);
                        // system.debug('******The value has changed!!!! '); // here goes more code 
                        if(str.contains('displayed')){
                            if(NewCase.get(str) !=null){
                                String[] split_fieldName=str.split('_');
                                String concat_s='';
                                for(String s:split_fieldName){
                                    if(s != 'c'){
                                        s=s.capitalize();
                                        concat_s=concat_s+' '+s;
                                    }
                                }
                                System.debug('concat_s '+concat_s);
                                display_details=display_details+concat_s+'- '+NewCase.get(str)+', \n';
                            }
                        }
                        
                        if(str.contains('correct')){
                            
                            if(NewCase.get(str) !=null){
                                String[] split_fieldName=str.split('_');
                                String concat_s='';
                                for(String s:split_fieldName){
                                    if(s != 'c'){
                                        s=s.capitalize();
                                        concat_s=concat_s+' '+s;
                                    }
                                }
                                System.debug('concat_s '+concat_s);
                                correct_details=correct_details+concat_s+'- '+NewCase.get(str)+', \n';
                            }
                        } 
                    } 
                }
                catch (Exception e) 
                { 
                    System.debug('Error: ' + e); 
                } 
            }
            System.debug('display_details '+display_details);
            System.debug('correct_details '+correct_details);
            cs.Displayed_Details__c =display_details ; 
            cs.Correct_Details__c=correct_details;
        }
        // RecursiveTriggerHandler.isFirstTime=false;
        
    }
    else{
        //sendMailtoBank.sendInstantMail(trigger.newMap, trigger.oldMap);  
        // new Code added
        System.debug(RecursiveTriggerHandler.isFirstTimeDateUpdate);
        RecursiveTriggerHandler.isFirstTimeDateUpdate = false;
        if(Trigger.isUpdate && Trigger.isBefore){
            
            Map<Id, Case> oldMap = new Map<Id, Case>();
            Map<Id, Case> newMap = new Map<Id, Case>();
            for(Case cs : Trigger.new){
                if(cs.Forward_to_bank__c != Trigger.oldMap.get(cs.Id).Forward_to_bank__c && cs.Temp_Forward_to_Bank__c ==false){
                    oldMap.put(cs.Id, Trigger.oldMap.get(cs.Id));
                    newMap.put(cs.Id, Trigger.newMap.get(cs.Id));
                }
            }
            if(!test.isRunningTest()){
            sendMailtoBank.sendInstantMail(newMap, oldMap, Trigger.newMap); 
            }            
            // for(Case cs : Trigger.new){
            /*
if(cs.Forward_to_bank__c != Trigger.oldMap.get(cs.Id).Forward_to_bank__c ){

}
*/
            String jsonOldMap = JSON.serialize(Trigger.oldMap);
            
            Set<ID> InvIDs = new Set<ID>(); 
            for(Case pa:trigger.new){
                if(trigger.oldmap.get(pa.Id).OwnerId  != pa.OwnerId){
                    InvIDs.add(pa.Id); 
                }
            }
            
            If(InvIDs.size()>0){
                system.debug('inside if ----');
                if(!System.isFuture() && !System.isBatch()){
                    system.debug('inside future----');
                    DisputeTrackerClass.UpdateDates(InvIDs,jsonOldMap);
                }
            }
            // }
        } 
    }
    
    //added by shashank to call the gupshup SMS API
    if(Trigger.isAfter && Trigger.isUpdate){
        Set<Id> csResolveIds=new Set<Id>();
        Set<Id> csRejectedIds=new Set<Id>();
        Set<Id> csReceivedIds=new Set<Id>();
        Set<Id> csGenerationDateIds=new Set<Id>();
        Map<Id,String> mpCaseIds=new Map<Id,String>();
        
        for(Case cs : trigger.new){
            
            Case NewCase = Trigger.newMap.get(cs.Id);
            Case OldCase = Trigger.oldMap.get(cs.Id);
            
            if(NewCase.Consumer_Dispute_Status__c != OldCase.Consumer_Dispute_Status__c){
                
                if(NewCase.Consumer_Dispute_Status__c =='Resolved in favour of the Consumer'){
                    csResolveIds.add(cs.Id);
                    mpCaseIds.put(cs.Id,OldCase.Consumer_Dispute_Status__c);
                }
                if(NewCase.Consumer_Dispute_Status__c =='Resolved not in favour of the Consumer'){
                    csRejectedIds.add(cs.Id);
                }
                 if(NewCase.Consumer_Dispute_Status__c =='Acknowledgement sent to Consumer'){
                    csReceivedIds.add(cs.Id);
                }
            }
        }
        
        if(csReceivedIds.size()>0){
            if (!System.isFuture() && !System.isBatch()){
                 //SendSmsGupshup.sendSMS(csReceivedIds,'received');
            }
        }
        if(csResolveIds.size()>0){
            if (!System.isFuture() && !System.isBatch()){
            	//SendSmsGupshup.sendSMS(csResolveIds,'resolved');
            	//IntegrationHandler.getAccessToken(csResolveIds);
            	IntegrationHandler.getAccessToken1(csResolveIds,mpCaseIds); //comment for now on 10 march 
            }
        }
        if(csRejectedIds.size()>0){
            if (!System.isFuture() && !System.isBatch()){
            	//SendSmsGupshup.sendSMS(csRejectedIds,'rejected');
            }
        }
                
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){ //- yet to deploy in live
        /*  for(Case cs : Trigger.new){
system.debug(cs.Status);
system.debug(cs.ParentId);
system.debug(cs.Consumer_Dispute_Status__c);
if (cs.Case_Type_Name__c !='Query' && cs.Case_Type_Name__c !='Junk'){
if(cs.Status== 'Resolved' && (cs.Consumer_Dispute_Status__c =='Acknowledgement sent to Consumer' || cs.Consumer_Dispute_Status__c == null ||  cs.Consumer_Dispute_Status__c== '')){
cs.Consumer_Dispute_Status__c.addError('Consumer Dispute Status should not be blank or Acknowledgement sent to Consumer');  
} 
}
} */
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        for(Case cs : Trigger.new){
            system.debug(cs.Status);
            system.debug(cs.ParentId);
            system.debug(cs.Consumer_Dispute_Status__c);      
            
            // add this to validation part 17 07
            if(cs.Send_Email_to_Consumer__c || cs.Forward_to_bank__c){
                if(cs.Dispute_Raised_Date__c == null && cs.Consumer_Dispute_Status__c != trigger.oldMap.get(cs.Id).Consumer_Dispute_Status__c){
                    //cs.Dispute_Raised_Date__c.addError('Dispute Raised Date should not be blank');
                }else 
                    if(cs.Date_of_the_email_received__c == null && cs.Consumer_Dispute_Status__c != trigger.oldMap.get(cs.Id).Consumer_Dispute_Status__c){
                        //cs.Date_of_the_email_received__c.addError('Email Received Date should not be blank');
                    }else 
                        if(string.isBlank(string.valueOf(cs.Dispute_Detail__c)) && cs.Consumer_Dispute_Status__c != trigger.oldMap.get(cs.Id).Consumer_Dispute_Status__c){
                            cs.Dispute_Detail__c.addError('Dispute Detail should not be blank');
                        }
            }
        }
    }
    
    // RBI Complaint Mail 
    if(Trigger.isBefore && Trigger.isUpdate) {
        
        //OrgWideEmailAddress[] oweaNodal = new OrgWideEmailAddress[]{};
        Id oweaNodal;
            if(!test.isRunningTest()){
                //oweaNodal = [select Id from OrgWideEmailAddress where Address = 'nodal.officer.india@experian.com' limit 1];// To send from Org wide address
                oweaNodal = DataClass.getNodalOfficer();
                
            }
        
        Set<Id> accIds = new Set<Id>();
        set<Id> casesId = new set<Id>();
        for(Case cs : Trigger.New) {
            if(cs.Send_Mail_for_RBI_Complaint__c && cs.Send_Mail_for_RBI_Complaint__c != Trigger.oldMap.get(cs.Id).Send_Mail_for_RBI_Complaint__c) {
                if(String.isNotBlank(cs.AccountId)) {
                    accIds.add(cs.AccountId);
                    casesId.add(cs.Id);
                }
                else {
                    cs.AccountId.addError('Required field');
                }
            }
        }
        
        if(casesId.size() > 0){
            
        
        map<Id,Case> caseMap = new map<Id,Case>([select Id, AccountId,Displayed_Account_Type__c,Displayed_Account_number__c,Dispute_Detail__c,Displayed_Details__c, 
                                                 RBI_Complaint_Number__c,Consumer_Name1__c,CaseNumber,Displayed_Bank_Name__c,Sub_Type_Lookup__r.Name,  Name_of_Consumer__r.BirthDate,
                                                 Name_of_Consumer__r.Name,Name_of_Consumer__r.email,Name_of_Consumer__r.Phone,
                                                 Name_of_Consumer__r.Account_No__c,Address__c,Displayed_Address__c,Displayed_Address_1_v1__c, Name_of_Consumer__r.Account_Type__c, Name_of_Consumer__r.Pan_no__c,
                                                 Account.Person_Name_Dispute__c,Account.Phone_Dispute__c,Account.Name 
                                                 from Case where Id IN : casesId and AccountId IN : accIds]);
       
        List<string>  emailList = new List<string>();
        for(Account ac: [Select Id,Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,Email_4_Dispute__c,Email_5_Dispute__c,
                         Email_6_Dispute__c,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c,
                         CC_Address_1__c, CC_Address_2__c, CC_Address_3__c, CC_Address_4__c, CC_Address_5__c, CC_Address_6__c,
                         CC_Address_7__c, CC_Address_8__c, CC_Address_9__c, CC_Address_10__c
                         
                         from Account where id IN : accIds]){
                             
                             if(string.isNotBlank(ac.Email_1_Dispute__c))
                                 emailList.add(ac.Email_1_Dispute__c);
                             if(string.isNotBlank(ac.Email_2_Dispute__c))
                                 emailList.add(ac.Email_2_Dispute__c);
                             if(string.isNotBlank(ac.Email_3_Dispute__c))
                                 emailList.add(ac.Email_3_Dispute__c);
                             if(string.isNotBlank(ac.Email_4_Dispute__c))
                                 emailList.add(ac.Email_4_Dispute__c);
                             if(string.isNotBlank(ac.Email_5_Dispute__c))
                                 emailList.add(ac.Email_5_Dispute__c);
                             if(string.isNotBlank(ac.Email_6_Dispute__c))
                                 emailList.add(ac.Email_6_Dispute__c);
                             if(string.isNotBlank(ac.Email_7_Dispute__c))
                                 emailList.add(ac.Email_7_Dispute__c);
                             if(string.isNotBlank(ac.Email_8_Dispute__c))
                                 emailList.add(ac.Email_8_Dispute__c);
                             if(string.isNotBlank(ac.Email_9_Dispute__c))
                                 emailList.add(ac.Email_9_Dispute__c);
                             if(string.isNotBlank(ac.Email_10_Dispute__c))
                                 emailList.add(ac.Email_10_Dispute__c);
                             
                             if(string.isNotBlank(ac.CC_Address_1__c))
                                 emailList.add(ac.CC_Address_1__c);
                             if(string.isNotBlank(ac.CC_Address_2__c))
                                 emailList.add(ac.CC_Address_2__c);
                             if(string.isNotBlank(ac.CC_Address_3__c))
                                 emailList.add(ac.CC_Address_3__c);
                             if(string.isNotBlank(ac.CC_Address_4__c))
                                 emailList.add(ac.CC_Address_4__c);
                             if(string.isNotBlank(ac.CC_Address_5__c))
                                 emailList.add(ac.CC_Address_5__c);
                             if(string.isNotBlank(ac.CC_Address_6__c))
                                 emailList.add(ac.CC_Address_6__c);
                             if(string.isNotBlank(ac.CC_Address_7__c))
                                 emailList.add(ac.CC_Address_7__c);
                             if(string.isNotBlank(ac.CC_Address_8__c))
                                 emailList.add(ac.CC_Address_8__c);
                             if(string.isNotBlank(ac.CC_Address_9__c))
                                 emailList.add(ac.CC_Address_9__c);
                             if(string.isNotBlank(ac.CC_Address_10__c))
                                 emailList.add(ac.CC_Address_10__c);
                         }
        system.debug('accIds'+accIds.size());
        if(accIds.size() > 0){
            
            List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
            List<EmailMessage> emailMessageList = new List<EmailMessage>();
            
            for(Case cs : Trigger.New) {
                
                if(cs.Send_Mail_for_RBI_Complaint__c && cs.Send_Mail_for_RBI_Complaint__c != Trigger.oldMap.get(cs.Id).Send_Mail_for_RBI_Complaint__c) {
                    
                    if(String.isNotBlank(cs.AccountId) && caseMap.containsKey(cs.Id)) {
                        
                        cs.Displayed_Bank_Name__c = String.isBlank(cs.Displayed_Bank_Name__c) ? '' : cs.Displayed_Bank_Name__c;
                        cs.Displayed_Account_Type__c = String.isBlank(cs.Displayed_Account_Type__c) ? '' : cs.Displayed_Account_Type__c;
                        cs.Displayed_Account_number__c = String.isBlank(cs.Displayed_Account_number__c) ? '' : cs.Displayed_Account_number__c;
                        cs.Dispute_Detail__c = String.isBlank(cs.Dispute_Detail__c) ? '' : cs.Dispute_Detail__c;
                        cs.Displayed_Details__c = String.isBlank(cs.Displayed_Details__c) ? '' : cs.Displayed_Details__c;
                        
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(emailList);
                        //email.setToAddresses(new List<String> {'rishikesh.korade@finessedirect.com','muskanbee.shaikh@experian.com','balram@finessedirect.com'});
                        
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
                        
                        email.setSubject('RBI complaint - '+cs.RBI_Complaint_Number__c+' - '+cs.Consumer_Name1__c + ' - '+ '[ '+ threadId + ' ]');
                        
                        //if(oweaNodal.size() > 0) {
                            //email.setOrgWideEmailAddressId(oweaNodal[0].Id);
                        //}

                        if(String.IsNotBlank(oweaNodal)){
                            email.setOrgWideEmailAddressId(oweaNodal);
                            system.debug('^^Yes^^');
                        }
                        
                        String DOB='';
                        
                        if(test.isRunningTest()){
                            // DOB = dt.format('MM/dd/yyyy'); 
                            DOB = '02/01/2021'; 
                        }
                        else{
                            date dt1 =cs.Name_of_Consumer__r.BirthDate; 
                            DOB = String.valueof(dt1); 
                        } 
                        String emailbody = '';
                        emailbody += '<html><body <p>Hi All,<br/>'+
                            '<p>Requesting your urgent intervention on this.</p>'+
                            '<p>As this is a RBI complaint, this needs to be closed within a stipulated time from our end.</p>'+
                            '<p>As per RBI we are mandated by a 21 days (for banks) and 30 days (for CIC) TAT which we will breach in case we do not '+
                            'receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed.</p>';
                        //'<style>table{border-collapse: collapse;}table,tr,th,td {border:0.5px solid gray;padding:2px 5px}</style>'+
                        
                        if(cs.Sub_Type_Name__c =='Account ownership issue' || cs.Sub_Type_Name__c =='Demographic Details'){
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
                            emailbody+='<table border="1px" style="border-collapse:collapse;width:98%;border:1px solid #ddd"><thead><tr>';
                            emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Case No</th>';
                            emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Consumer name</th>';
                            emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Member Name</th>';
                            emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Account Type</th>';
                            emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Account No</th>';
                            emailbody+='<th style="font-size:13px;background-color:#1798c1;color:#000000;font-weight:100;text-align:center;color:#fff">Dispute Details</th></tr></thead>';
                            
                        }
                        
                        if(cs.Sub_Type_Name__c =='Account ownership issue' || cs.Sub_Type_Name__c =='Demographic Details'){
                            string Displayed_Address_1 = cs.Displayed_Address__c != null ? cs.Displayed_Address__c : cs.Displayed_Address_1_v1__c;
                            emailbody += '<tbody><tr><td>' + cs.CaseNumber + '</td><td>' +checkNull(caseMap.get(cs.Id).Name_of_Consumer__r.Name) + '</td><td>' + checkNull(DOB) + '</td><td>' + checkNull(cs.Displayed_Address__c) + '</td><td>' + checkNull(caseMap.get(cs.Id).Name_of_Consumer__r.Phone) + '</td><td>' + checkNull(caseMap.get(cs.Id).Name_of_Consumer__r.Email) + '</td><td>' + checkNull(caseMap.get(cs.Id).Name_of_Consumer__r.Pan_no__c) + '</td><td>' +  checkNull(caseMap.get(cs.Id).Account.Name)  + '</td><td>' + checkNull(cs.Displayed_Account_Type__c) + '</td><td>' + checkNull(cs.Displayed_Account_number__c) + '</td><td>' + checkNull(cs.Dispute_Detail__c) + '</td></tr>';  
                        }else{
                            emailbody += '<tbody><tr><td>' + cs.CaseNumber + '</td><td>' +checkNull(caseMap.get(cs.Id).Name_of_Consumer__r.Name )+ '</td><td>' +  checkNull(caseMap.get(cs.Id).Account.Name)  + '</td><td>' + checkNull(cs.Displayed_Account_Type__c) + '</td><td>' + checkNull(cs.Displayed_Account_number__c) + '</td><td>' + checkNull(cs.Dispute_Detail__c) + '</td></tr>';  
                        }
                        emailbody += '</tbody></table>';
                        
                        emailbody+='<p>We request you to share the correction on the SFTP folder and share the file name with us. '+
                            'We do not accept changes in excel or on the email body.</p>'+
                            '<p>If we have not addressed this to the right team, please help us with the right contacts within your organisation for this.</p>'+
                            '<p>Please treat this with high priority</p>'+
                            '<p>Please feel free to contact us for any further queries.</p>'+
                            
                            'Regards,<br /><br />'+
                            'Nodal Officer<br />'+
                            'Experian Credit Information Company of India Pvt. Ltd.<br />'+
                            'E:<a href="mailto:nodal.officer.india@experian.com">nodal.officer.india@experian.com</a><br />'+
                            '<a href="www.experian.in">www.experian.in</a><br />'+
                            '<strong>India STS Link - </strong><a href="https://data.experian.in">https://data.experian.in</a><br />'+
                            '<strong>Nextgen Link - </strong>'+
                            '<a href="https://nxg-india.experian.com/nextgen-ind-pds/">https://nxg-india.experian.com/nextgen-ind-pds/</a></body </html>';
                        
                        
                        email.setHtmlBody(emailbody);
                        email.setUseSignature(false);
                        allMails.add(email);

                        system.debug('allMails--> ' +allMails);
                        
                        cs.RBI_Complaint_mail_sent_date__c = System.today();
                        
                        EmailMessage em=new EmailMessage();
                        em.subject = 'RBI complaint - '+cs.RBI_Complaint_Number__c+' - '+cs.Consumer_Name1__c;
                        
                        em.RelatedToId= cs.Id;  
                        em.ToAddress = string.join(emailList,',');
                        em.MessageDate=system.now();
                        em.Incoming=false;
                        em.Email_Body__c =emailbody; 
                        em.Status='3';
                        em.FromAddress= 'nodal.officer.india@experian.com';
                        em.FromName='Nodal Officer';
                        emailMessageList.add(em);
                    }
                }
            }
            
            if(allMails.size() > 0) {
                Messaging.sendEmail(allMails);
            }
            if(emailMessageList.size() > 0) {
                insert emailMessageList;
            }
            
        }
        }
    }
    
    // 14/08/2023 Request data correction on SFTP
    /*List<OrgWideEmailAddress> oweaConsumer = new List<OrgWideEmailAddress>();
    if(!Test.isRunningTest()){
        List<OrgWideEmailAddress> oweaConsumer = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'consumer.support@in.experian.com' limit 1];
    } */
    
    if(Trigger.isBefore && Trigger.isUpdate){
        
        //List<OrgWideEmailAddress> oweaConsumer = new List<OrgWideEmailAddress>();
        Id oweaConsumer;
        if(!Test.isRunningTest()){
            //oweaConsumer = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'consumer.support@in.experian.com' limit 1];
            oweaConsumer = DataClass.getConsumerSupport();
        }
        
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        List<EmailMessage> emailMessageList = new List<EmailMessage>();
        
        set<Id> accId = new set<Id>();
        map<string,string> CaseMap = new map<string,string>();
        for(Case cs : Trigger.new){
            if(cs.Request_data_correction_on_SFTP__c && cs.Request_data_correction_on_SFTP__c !=Trigger.oldmap.get(cs.Id).Request_data_correction_on_SFTP__c){
                accId.add(cs.AccountId);
                CaseMap.put(cs.AccountId,cs.Id);
                
            }
        }
        
        List<string>  emailList = new List<string>();
        for(Account ac: [Select Id,Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,
                         Email_4_Dispute__c,Email_5_Dispute__c,Email_6_Dispute__c,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c,
                         CC_Address_1__c, CC_Address_2__c, CC_Address_3__c, CC_Address_4__c, CC_Address_5__c, CC_Address_6__c,
                         CC_Address_7__c, CC_Address_8__c, CC_Address_9__c, CC_Address_10__c from Account where id IN : CaseMap.keySet()]){
                             if(CaseMap.containsKey(ac.Id)){
                                 if(string.isNotBlank(ac.Email_1_Dispute__c))
                                     emailList.add(ac.Email_1_Dispute__c);
                                 if(string.isNotBlank(ac.Email_2_Dispute__c))
                                     emailList.add(ac.Email_2_Dispute__c);
                                 if(string.isNotBlank(ac.Email_3_Dispute__c))
                                     emailList.add(ac.Email_3_Dispute__c);
                                 if(string.isNotBlank(ac.Email_4_Dispute__c))
                                     emailList.add(ac.Email_4_Dispute__c);
                                 if(string.isNotBlank(ac.Email_5_Dispute__c))
                                     emailList.add(ac.Email_5_Dispute__c);
                                 if(string.isNotBlank(ac.Email_6_Dispute__c))
                                     emailList.add(ac.Email_6_Dispute__c);
                                 if(string.isNotBlank(ac.Email_7_Dispute__c))
                                     emailList.add(ac.Email_7_Dispute__c);
                                 if(string.isNotBlank(ac.Email_8_Dispute__c))
                                     emailList.add(ac.Email_8_Dispute__c);
                                 if(string.isNotBlank(ac.Email_9_Dispute__c))
                                     emailList.add(ac.Email_9_Dispute__c);
                                 if(string.isNotBlank(ac.Email_10_Dispute__c))
                                     emailList.add(ac.Email_10_Dispute__c);
                                 
                                 if(string.isNotBlank(ac.CC_Address_1__c))
                                     emailList.add(ac.CC_Address_1__c);
                                 if(string.isNotBlank(ac.CC_Address_2__c))
                                     emailList.add(ac.CC_Address_2__c);
                                 if(string.isNotBlank(ac.CC_Address_3__c))
                                     emailList.add(ac.CC_Address_3__c);
                                 if(string.isNotBlank(ac.CC_Address_4__c))
                                     emailList.add(ac.CC_Address_4__c);
                                 if(string.isNotBlank(ac.CC_Address_5__c))
                                     emailList.add(ac.CC_Address_5__c);
                                 if(string.isNotBlank(ac.CC_Address_6__c))
                                     emailList.add(ac.CC_Address_6__c);
                                 if(string.isNotBlank(ac.CC_Address_7__c))
                                     emailList.add(ac.CC_Address_7__c);
                                 if(string.isNotBlank(ac.CC_Address_8__c))
                                     emailList.add(ac.CC_Address_8__c);
                                 if(string.isNotBlank(ac.CC_Address_9__c))
                                     emailList.add(ac.CC_Address_9__c);
                                 if(string.isNotBlank(ac.CC_Address_10__c))
                                     emailList.add(ac.CC_Address_10__c);
                             }
                             
                         }
        
        for(Case cs : Trigger.new){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.toaddresses = emailList;
            //email.setToAddresses(new List<String> {'rishikesh.korade@finessedirect.com'});
            //email.setToAddresses(new List<String> {'muskanbee.shaikh@experian.com'});
            if(cs.Request_data_correction_on_SFTP__c && cs.Request_data_correction_on_SFTP__c !=Trigger.oldmap.get(cs.Id).Request_data_correction_on_SFTP__c){
                String body = '';
                body+='<p>Dear Team,</p>';
                body+='<p>Thank you for contacting Experian Credit Information of India Pvt Ltd.</p>';
                body+='<p>We are unable to update the correction details in the consumer’s report if you provide the correction details in the email body.</p>';
                body+='<p>Hence, we request you to share the data correction format on <b>SFTP</b> and share the <b>file name</b> with us to resolve the issue at the earliest.</p>';
                body+='Regards,<br/><br/>';
                
                body+='consumer Support Team<br />';
                body+='Experian Credit Information Company of India Pvt. Ltd.<br/>';
                body+='consumer.support@in.experian.com<br/>';
                body+='<a href="www.experian.in">www.experian.in</a><br/>';
                body+='Get your Experian Credit Report & Score today <a href="https://nxg-india.experian.com/nextgen-ind-pds/">click here</a>';
                
                email.setSubject('Correction in Details on SFTP');


                //if(oweaConsumer.size() > 0) {
                    //email.setOrgWideEmailAddressId(oweaConsumer[0].Id);
                //}

                if(String.IsNotBlank(oweaConsumer)) {
                    email.setOrgWideEmailAddressId(oweaConsumer);
                    
                }

                email.setHtmlBody(body);
                email.setUseSignature(false);
                allMails.add(email);
                
                EmailMessage em=new EmailMessage();
                em.subject = 'Correction in Details on SFTP';
                em.RelatedToId= cs.Id;  
                em.ToAddress = string.join(emailList,',');
                em.MessageDate=system.now();
                em.Incoming=false;
                em.Email_Body__c =body;
                em.Status='3';
                em.FromAddress='consumer.support@in.experian.com';
                em.FromName='Consumer Support';
                emailMessageList.add(em);
                
            }
        }
        if(allMails.size() > 0) {
            Messaging.sendEmail(allMails);
        }
        
        if(emailMessageList.size() > 0) {
            insert emailMessageList;
        }
    }
    
    private static String checkNull(Object obj) {
        if(obj == null)
            return '';
        else
            return String.valueOf(obj).trim().escapeCsv()+' ';
    }
}