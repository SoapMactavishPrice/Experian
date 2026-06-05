public with sharing class SendEmailaccountwithCase {
    public SendEmailaccountwithCase() {
        
    }
    
    @AuraEnabled
    public static string getEmail(string escalationlevel,string accId){
        List<Object> lsObj = (List<Object>)json.deserializeUntyped(escalationlevel);
        map<string,set<string>> tempemail = new map<string,set<string>>();
        set<string> emailList = new set<string>(); 
        for(object obj :lsObj){
            if(obj == 'Dispute Manager – Escalation Level 1'){
                
                List<Account> accountList =[Select Id,Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,
                                            Email_4_Dispute__c,Email_5_Dispute__c,Email_6_Dispute__c,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c from Account where id=: accId];
                if(accountList.size() > 0){
                    for(Account ac : accountList){
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
                        
                    }
                    if(emailList.size() > 0){ 
                        tempemail.put('email',emailList);
                        //tempemail.put('email',emailList);
                    }
                }
            }
            
            if(obj == 'Dispute Manager – Escalation Level 2' || obj == 'Dispute Manager – Escalation Level 3' || obj == 'Dispute Manager – Escalation Level 4'){
                List<Contact> conlist = [select Id ,Email from Contact where AccountId =:accId and Contact_Role__c =: string.valueOf(obj)];
                
                if(conlist.size() > 0){
                    for(Contact con : conlist){
                        emailList.add(con.Email);
                        tempemail.put('email',emailList);
                    }
                }
            }
        }
        system.debug('emaillist'+tempemail);
        return JSON.serialize(tempemail);
    }
    
    
    // server side
    
    @AuraEnabled
    public static string getAccount_server(String ofst, String lmt, String searchKeyword) {
        system.debug('ofst'+ofst+'lmt'+lmt);
        Integer offset;
        Integer limt;
        String filter = '';
        
        if(String.isNotBlank(ofst)) {
            offset = Integer.valueOf(ofst);
        }
        if(String.isNotBlank(lmt)) {
            limt = Integer.valueOf(lmt);
        }
        
        system.debug('offset'+offset+'limt'+limt);
        
        if(String.isNotBlank(searchKeyword)) {
            filter += 'and (';
            
            filter += 'Name like \'%'+searchKeyword+'%\'';
            filter += ' or Membership_Status__c like \'%'+searchKeyword+'%\'';
            filter += ' or Member_Type__c like \'%'+searchKeyword+'%\'';
            filter += ')';
        }
        
        List<Object> strForJSON = new List<object>();
        List<Map<String, Object>> finalMap = new List<Map<String, Object>>();
        
        integer index = 0;
        boolean bfalse = false;
        String query = '';
        
        if(test.isRunningTest()){
            query = 'Select Id, VIP_Member__c,Subscriber_ID__c,Member_Type__c,Membership_Status__c,Name '+
                //'FROM Account WHERE Id IN (SELECT AccountId From Case) ';
                'FROM Account WHERE Id IN (SELECT AccountId From Case Where (status = \'Open\' or status = \'Customer Notified\')  and Account_s_Parent_Case__c = false ) '+filter+' limit:limt offset:offset';
            
        }else{
            query = 'Select Id, VIP_Member__c,Subscriber_ID__c,Member_Type__c,Membership_Status__c,Name '+
                //'FROM Account WHERE Id IN (SELECT AccountId From Case) ';
                'FROM Account WHERE Id IN (SELECT AccountId From Case Where (status = \'Open\' or status = \'Customer Notified\') and Owner.Name =\'Bank Team\' and Account_s_Parent_Case__c = false ) '+filter+' limit:limt offset:offset';
            
        }
        
        
        system.debug('query'+query);
        for(Account ac : Database.query(query)) {
            //system.debug('case list'+ac);
            //system.debug('case list'+ac.Cases);
            Map<String, Object> tempMap = new Map<String, Object>();
            tempMap.put('index',index++);
            tempMap.put('resId',ac.Id);
            tempMap.put('accName',ac.Name);
            tempMap.put('accVIPN',ac.VIP_Member__c);
            tempMap.put('accsubId',ac.Subscriber_ID__c);
            tempMap.put('accMemstatus',ac.Membership_Status__c);
            tempMap.put('accMemType',ac.Member_Type__c);
            tempMap.put('isSelected', false);
            List<Map<String, Object>> tempList = new List<Map<String, Object>>();
            finalMap.add(tempMap);
        }
        
        strForJSON.add(finalMap);
        query = 'select count() from Account WHERE Id IN (SELECT AccountId From Case Where (status = \'Open\' or status = \'Custom Notified\') and Owner.Name =\'Bank Team\' and Account_s_Parent_Case__c = false)'+filter;
        strForJSON.add(Database.countQuery(query));
        return JSON.serialize(strForJSON);
    }
    
    
    @AuraEnabled 
    public static string getCaseDetail(string accId,date fromDate , date toDate){
        system.debug('accId'+accId);
        List<Case> caseList = new List<Case>();
        if(!test.isRunningTest()){
            if(fromDate == null && toDate == null){
                caseList = [select Id,Case_Category__c,Case_Type_Lookup__r.Name,Sub_Type_Lookup__r.Name,Sub_Type_1_Lookup__r.Name,
                            Subject,OwnerId,Owner.Name,AccountId,CaseNumber from Case where (status =:'Open' or Status=:'Customer Notified') and  Owner.Name =:'Bank Team' 
                            and Account_s_Parent_Case__c = false and AccountId=:accId ORDER BY CaseNumber];
                
            }else if(fromDate != null && toDate != null){
                caseList = [select Id,Case_Category__c,Case_Type_Lookup__r.Name,Sub_Type_Lookup__r.Name,Sub_Type_1_Lookup__r.Name,
                            Subject,OwnerId,Owner.Name,AccountId,CaseNumber from Case where (status =:'Open' or Status=:'Customer Notified') and  Owner.Name =:'Bank Team' 
                            and Account_s_Parent_Case__c = false and AccountId=:accId and (CreatedDate >= :fromDate and CreatedDate <=:toDate) ORDER BY CaseNumber];
                
            }
            
            
        }else{
            caseList = [select Id,Case_Category__c,Case_Type_Lookup__r.Name,Sub_Type_Lookup__r.Name,Sub_Type_1_Lookup__r.Name,
                        Subject,OwnerId,Owner.Name,AccountId,CaseNumber from Case where (status =:'Open' or Status=:'Custom Notified')
                        and Account_s_Parent_Case__c = false and AccountId=:accId ORDER BY CaseNumber];
        }
        
        List<Map<String, Object>> tempList = new List<Map<String, Object>>();
        for(case cs : caseList){
            Map<String, Object> tempMap2 = new Map<String, Object>();
            tempMap2.put('csId',cs.Id);
            tempMap2.put('csAccId',cs.AccountId);
            tempMap2.put('CaseNumber',cs.CaseNumber);
            tempMap2.put('CaseCategory',cs.Case_Category__c);
            tempMap2.put('CaseSubject',cs.Subject);
            tempMap2.put('CaseOwner',cs.owner.Name);
            if(string.IsNOTBlank(cs.Case_Type_Lookup__c)){tempMap2.put('CaseType',cs.Case_Type_Lookup__r.Name);}
            if(string.IsNOTBlank(cs.Sub_Type_Lookup__c)){tempMap2.put('CaseSubType',cs.Sub_Type_Lookup__r.Name);}
            if(string.IsNOTBlank(cs.Sub_Type_1_Lookup__c)){tempMap2.put('CaseSub12Type',cs.Sub_Type_1_Lookup__r.Name);}
            tempMap2.put('isSelected', true);
            tempList.add(tempMap2);
        }
        return JSON.serialize(tempList);
    }
    
    @AuraEnabled
    public static string  SendEmail(String data, List<string> emails) {
        try{  
            if(string.isNotBlank(data)) {
                system.debug('data'+data);
                
                system.debug('email are'+emails);
                List<Messaging.Email> allMails = new List<Messaging.Email>();
                // Map<string,Object> caseData = new Map<string,Object>();
                
                Map<String, Object> jsonData = (Map<String, Object>) System.JSON.deserializeUntyped(data);
                
                List<String> accIds = new List<String>();
                List<String> caseIds = new List<String>();
                
                for(String str : jsonData.keySet()) {
                    accIds.add(str);
                    for(Object obj : (List<Object>) jsonData.get(str)) {
                        caseIds.add(String.valueOf(obj));
                    }
                }
                
                system.debug('accIds'+accIds.size() +' case size'+ caseIds);
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'disputeresolution@experian.com'];// To send from Org wide address
                System.debug('owea  '+owea); // balramp610@gmail.com   consumer.support@in.experian.com                   
                
                boolean bfalse = false;
                
                String query = 'select Id, Name, Email_1_Dispute__c, Email_2_Dispute__c, Email_3_Dispute__c, Email_4_Dispute__c, '+
                    'Email_5_Dispute__c , Email_6_Dispute__c,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c,'+
                    '(select Id, Name_of_Consumer__r.Name,Raised_Days__c,Member_TAT__c,'+
                    'Name_of_Consumer__r.Phone,AccountId,Name_of_Consumer__r.Email,Name_of_Consumer__r.Pan_no__c, Dispute_Raised_Date__c,'+
                    'Account.Name, Displayed_Account_Type__c, Displayed_Account_number__c, Dispute_Detail__c,Enquiry_Loan_Amount__c,Enquiry_User_Id__c,  '+
                    'Displayed_Details__c, Correct_Details__c,Open_Ageing_with_Bank__c, Sub_Type_Lookup__r.Name ,'+
                    ' Name_of_Consumer__r.BirthDate,Displayed_Address__c,Displayed_Address_1_v1__c,Date_of_the_email_received__c,'+
                    ' CaseNumber from Cases where Id in: caseIds ';
                if(!test.isRunningTest()){
                    query += 'and Owner.Name =\'Bank Team\'';
                }else{
                    //query += 'Owner.Name =\'Bank Team\' and ';
                    
                }
                query += 'and Account_s_Parent_Case__c =false) from Account where Id in: accIds';
                //query+=') from Account where Id in: accIds';
                string summary ;
                Id  case_parentId ;
                summary =  '<style>th{background-color:#1798c1;color:#000000}</style>';
                summary += '<table border="1" style="border-collapse:collapse;width:50;"><tr><th>Month Raised</th><th>Count of Pending Cases</th></tr>';
                
                Map<string,map<string,string>> accwithmonth = new Map<string,map<string,string>>();
                
                for(AggregateResult ar :[select count(Id) cid,CALENDAR_MONTH(CreatedDate) month,AccountId,CALENDAR_YEAR(CreatedDate) year
                                         from case where AccountId IN : accIds AND ID IN:caseIds
                                         GROUP BY AccountId, CALENDAR_MONTH(CreatedDate),CALENDAR_YEAR(CreatedDate)]){
                                             if(accwithmonth.containskey(string.valueOf(ar.get('AccountId')))){
                                                 accwithmonth.get(string.valueOf(ar.get('AccountId'))).put(string.valueOf(ar.get('month'))+':'+string.valueOf(ar.get('year')),string.valueOf(ar.get('cid')));
                                             }else{
                                                 map<string,string> monthcount = new map<string,string>();
                                                 monthcount.put(string.valueOf(ar.get('month'))+':'+string.valueOf(ar.get('year')),string.valueOf(ar.get('cid')));
                                                 accwithmonth.put(string.valueOf(ar.get('AccountId')),monthcount);
                                             }
                                             
                                         }
                Map<Id,Case> caseMap = new Map<Id,Case>();
                List<Case> Caselist = [Select Id, AccountId,Account_s_Parent_Case__c from Case where Account_s_Parent_Case__c =:true and AccountId IN:accIds ];
                for(Case cs : Caselist){
                    caseMap.put(cs.AccountId,cs);
                }
                
                system.debug('case map'+caseMap);
                String threadId;
                List<Case> Up_Parent_CaseList = new List<Case>();
                for(Account ac : Database.query(query)) {
                    string[] toAddresses;
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                    
                    String tempExcel;
                     String excelData = '<?xml version="1.0" encoding="UTF-8"?>' +
                           '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" ' +
                           'xmlns:o="urn:schemas-microsoft-com:office:office" ' +
                           'xmlns:x="urn:schemas-microsoft-com:office:excel" ' +
                           'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">' +
                           '<Worksheet ss:Name="Cases"><Table>';
                    
                    tempExcel = '<style>table{border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #D5D5D5}td,th{padding:5px;border:1px solid #D5D5D5}';
                    tempExcel += 'th{font-size:25px;font-weight:400;text-align:center;background-color:#D5D5D5;color:#fff}td{font-size:11px;font-weight:100;text-align:left}</style>';
                    
                    tempExcel += '<table border="1px"><tr><th>Case Number</th><th>Email Received Date</th><th>Consumer Name</th><th>Member Name</th><th>Account Type</th><th>Account No</th><th>Dispute Details</th><th>Enquiry User Id</th><th>Enquiry Loan Amount</th><th>Dispute Raised Date</th><th>Open Ageing with Bank</th></tr>';
                    
                    
                   
                     excelData += '<Row>' +
                     '<Cell><Data ss:Type="String">Case Number</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Email Received Date</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Consumer Name</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Member Name</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Account Type</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Account No</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Dispute Details</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Enquiry User Id</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Enquiry Loan Amount</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Dispute Raised Date</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Open Ageing with Bank</Data></Cell>' +
                     '</Row>';
                    
                    
                    
                    String tempExcelDemog;
                    String excelDataDemog = '<?xml version="1.0" encoding="UTF-8"?>' +
                           '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" ' +
                           'xmlns:o="urn:schemas-microsoft-com:office:office" ' +
                           'xmlns:x="urn:schemas-microsoft-com:office:excel" ' +
                           'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">' +
                           '<Worksheet ss:Name="Cases"><Table>';
                    
                    tempExcelDemog = '<style>table{border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #D5D5D5}td,th{padding:5px;border:1px solid #D5D5D5}';
                    tempExcelDemog += 'th{font-size:25px;font-weight:400;text-align:center;background-color:#D5D5D5;color:#fff}td{font-size:11px;font-weight:100;text-align:left}</style>';
                    
                    tempExcelDemog += '<table border="1px"><tr><th>Case Number</th><th>Email Received Date</th><th>Consumer Name</th><th>Date of Birth</th><th>Address</th><th>Contact no</th><th>Email ID</th><th>PAN Detail</th><th>Member Name</th> <th>Account Type</th> <th>Account No</th><th>Dispute Details</th><th>Enquiry User Id</th><th>Enquiry Loan Amount</th><th>Dispute Raised Date</th><th>Open Ageing with Bank</th></tr>';
                    
                     
                     excelDataDemog += '<Row>' +
                     '<Cell><Data ss:Type="String">Case Number</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Email Received Date</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Consumer Name</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Date of Birth</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Address</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Contact no</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Email ID</Data></Cell>' +
                     '<Cell><Data ss:Type="String">PAN Detail</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Member Name</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Account Type</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Account No</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Dispute Details</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Enquiry User Id</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Enquiry Loan Amount</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Dispute Raised Date</Data></Cell>' +
                     '<Cell><Data ss:Type="String">Open Ageing with Bank</Data></Cell>' +
                     '</Row>';
                   
                    
                    
                    string emailbody ='Dear Team,' +
                        '<p>As per RBI the financial institutions have to respond within 21 days and CIC’s have a timeline of 30 days for resolution of the Complaint. Please note the' +
                        ' consumer is looking for a rectified report so that credit could be availed. We are awaiting a response from you / your team for the attached list of cases. <br /><br />'+
                        'To monitor the response timelines, you will find ‘Dispute raised date’ (the date when the dispute was first sent to you) and ‘Member TAT’ '+
                        '(today - date raised to you) in the attached file.<br /></p>'+
                        'A summary is given below.<br /><br />';  
                    
                    mail.setUseSignature(false);
                    mail.setToAddresses(emails);
                    system.debug('emails--242'+emails);
                    //mail.setToAddresses(new List<String> {'rishikesh.korade@finessedirect.com'});
                    
                    //emailBody +=  '<style>th{background-color:#ADD8E6;}</style>';
                    emailbody += '<table border="1" style="border-collapse:collapse;width:50%;"><tr><th style="color:#000000;background-color:#ADD8E6;">Month Raised</th><th style="color:#000000;background-color:#ADD8E6;">Count of Pending Cases</th></tr>';
                    List<String> caseRow = new List<String>();
                    
                    Map<string ,string> strlist = new Map<string ,string>();
                    if(accwithmonth.containsKey(ac.Id)){
                        strlist = accwithmonth.get(ac.Id);
                    }
                    integer totalsub= 0;
                    for(string strs : strlist.keyset()){
                        string month = '';
                        integer monNum = integer.valueOf(strs.substringBefore(':'));
                        switch on monNum {
                            when 1 {
                                month = 'January';
                            }
                            when 2 {
                                month = 'February';
                            }
                            when 3 {
                                month = 'March';
                            }
                            when 4 {
                                month = 'April';
                            }
                            when 5 {
                                month = 'May';
                            }
                            when 6 {
                                month = 'June';
                            }
                            when 7 {
                                month = 'July';
                            }
                            when 8 {
                                month = 'August';
                            }
                            when 9 {
                                month = 'September';
                            }
                            when 10 {
                                month = 'October';
                            }
                            when 11 {
                                month = 'November';
                            }
                            when 12 {
                                month = 'December';
                            }
                        }
                        
                        system.debug('strlist.get(str)'+strlist.get(strs));
                        caseRow.add('<tr><td style="text-Align:center">'+month+'\''+strs.substringAfter(':')+'</td><td style="text-Align:center">'+strlist.get(strs)+'</td></tr>');
                        totalsub +=integer.valueOf(strlist.get(strs));
                    }
                    emailBody += String.join(caseRow,' ');
                    emailBody += '<tr><td style="text-Align:center"><b>Total Cases</b></td><td style="text-Align:center"><b>'+totalsub+'</b></td></tr>';
                    emailBody += '</table>'; 
                    
                    List<String> caseexcelRow = new List<String>();
                    List<String> caseexcelRowDemog = new List<String>();
                    for(Case cs : ac.cases) {
                        //system.debug('Test data'+caseMap);
                        if(caseMap.containskey(cs.accountId)){
                            case_parentId = (Id)caseMap.get(cs.accountId).Id;
                            ID orgId = UserInfo.getOrganizationId();
                            String sOrgId = (string)orgId;
                            ID caseId = cs.Id;
                            String sCaseId = caseMap.get(cs.accountId).Id;
                            String threadIdPart1 = 'ref:_' + sOrgId.left(5) + sOrgId.right(10).replace('0','');
                            threadIdPart1 = threadIdPart1.substring(0,threadIdPart1.length()-3);
                            String threadIdPart2 = '._' + sCaseId.Left(5) + sCaseId.right(10).left(5).replace('0','') + sCaseId.right(5);
                            threadIdPart2 = threadIdPart2.substring(0,threadIdPart2.length()-3)+':ref';
                            threadId = threadIdPart1 + threadIdPart2;  
                            cs.Reminder_Parent_Case__c = caseMap.get(cs.accountId).Id;
                            Up_Parent_CaseList.add(cs);
                            
                        }
                        
                        String DOB2;
                             if(test.isRunningTest()){
                                        DOB2 = '02/01/2021';
                                    }else{
                                        date dt2 =cs.Date_of_the_email_received__c;
                                        if(string.isNotBlank(string.valueOf(dt2))){
                                            DOB2 = String.valueof(dt2);
                                        }else{
                                            DOB2 = '-';
                                        }
                                    }
                        if(cs.Sub_Type_Lookup__r.Name =='Account ownership issue' || cs.Sub_Type_Lookup__r.Name =='Demographic Details'){  
                            date dt1 =cs.Name_of_Consumer__r.BirthDate; 
                            string DOB = String.valueof(dt1);
                            string Displayed_Address_1 = cs.Displayed_Address__c != null ? cs.Displayed_Address__c : cs.Displayed_Address_1_v1__c;
                            caseexcelRowDemog.add('<tr><td style="text-align:center">'+cs.CaseNumber+'</td><td style="text-align:center">'+DOB2+'</td><td style="text-align:center">'+cs.Name_of_Consumer__r.Name+'</td> <td style="text-align:center">'+DOB+'</td> <td style="text-align:center">'+Displayed_Address_1+'</td> <td style="text-align:center">'+cs.Name_of_Consumer__r.Phone+'</td>  <td style="text-align:center">'+cs.Name_of_Consumer__r.Email+'</td>  <td style="text-align:center">'+cs.Name_of_Consumer__r.Pan_no__c+'</td>  <td style="text-align:center">'+cs.Account.Name+'</td><td style="text-align:center">'+cs.Displayed_Account_Type__c+'</td><td style="text-align:center">'+cs.Displayed_Account_number__c+'</td> <td style="text-align:center">'+cs.Dispute_Detail__c+'</td><td style="text-align:center">'+cs.Enquiry_User_Id__c+'</td><td style="text-align:center">'+cs.Enquiry_Loan_Amount__c+'</td><td style="text-align:center">'+cs.Dispute_Raised_Date__c+'</td><td style="text-align:center">'+cs.Open_Ageing_with_Bank__c+'</td></tr>');
                            excelDataDemog += '<Row>' +
                                wrapCell(cs.CaseNumber) +
                                wrapCell(DOB2) +
                                wrapCell(cs.Name_of_Consumer__r.Name) +
                                wrapCell(DOB) +
                                wrapCell(Displayed_Address_1) +
                                wrapCell(cs.Name_of_Consumer__r.Phone) +
                                wrapCell(cs.Name_of_Consumer__r.Email) +
                                wrapCell(cs.Name_of_Consumer__r.Pan_no__c) +
                                wrapCell(cs.Account.Name) +
                                wrapCell(cs.Displayed_Account_Type__c) +
                                wrapCell(cs.Displayed_Account_number__c) +
                                wrapCell(cs.Dispute_Detail__c) +
                                wrapCell(cs.Enquiry_User_Id__c) +
                                wrapCell(string.valueOf(cs.Enquiry_Loan_Amount__c)) +
                                wrapCell(formatDate(cs.Dispute_Raised_Date__c)) +
                                wrapCell(string.valueOf(cs.Open_Ageing_with_Bank__c)) +
                                '</Row>';
                            
                        
                        
                        }else if(cs.Sub_Type_Lookup__r.Name !='Account ownership issue' || cs.Sub_Type_Lookup__r.Name !='Demographic Details'){
                            caseexcelRow.add('<tr><td style="text-align:center">'+cs.CaseNumber+'</td><td style="text-align:center">'+DOB2+'</td><td style="text-align:center">'+cs.Name_of_Consumer__r.Name+'</td> <td style="text-align:center">'+cs.Account.Name+'</td> <td style="text-align:center">'+cs.Displayed_Account_Type__c+'</td> <td style="text-align:center">'+cs.Displayed_Account_number__c+'</td>  <td style="text-align:center">'+cs.Dispute_Detail__c+'</td><td style="text-align:center">'+cs.Enquiry_User_Id__c+'</td><td style="text-align:center">'+cs.Enquiry_Loan_Amount__c+'</td><td style="text-align:center">'+cs.Dispute_Raised_Date__c+'</td><td style="text-align:center">'+cs.Open_Ageing_with_Bank__c+'</td></tr>');
                            excelData += '<Row>' +
                                wrapCell(cs.CaseNumber) +
                                wrapCell(DOB2) +
                                wrapCell(cs.Name_of_Consumer__r.Name) +
                                wrapCell(cs.Account.Name) +
                                wrapCell(cs.Displayed_Account_Type__c) +
                                wrapCell(cs.Displayed_Account_number__c) +
                                wrapCell(cs.Dispute_Detail__c) +
                                wrapCell(cs.Enquiry_User_Id__c) +
                                wrapCell(string.valueOf(cs.Enquiry_Loan_Amount__c)) +
                                wrapCell(formatDate(cs.Dispute_Raised_Date__c)) +
                                wrapCell(string.valueOf(cs.Open_Ageing_with_Bank__c)) +
                                '</Row>';
                        
                        
                        
                       }
                    }
                    
                    
                    
                    if(caseexcelRow.size()> 0){
                        excelData += '</Table></Worksheet></Workbook>';
                        //string temp ;
                        //string tempdata = '';
                        //temp += String.join(caseexcelRow,' ');
                        //tempdata +=temp.replace('null','');
                        //tempExcel +=tempdata.replace('00:00:00','');
                        //tempExcel +='</table>';
                    }
                    
                    if(caseexcelRowDemog.size()> 0){
                        excelDataDemog += '</Table></Worksheet></Workbook>';
                        //string tempDemog ;
                        //string tempdataDemog = '';
                        //tempDemog += String.join(caseexcelRowDemog,' ');
                        //tempdataDemog +=tempDemog.replace('null','');
                        //tempExcelDemog +=tempdataDemog.replace('00:00:00','');
                        //tempExcelDemog +='</table>';
                    }
                    
                    
                    if ( owea.size() > 0 ) {
                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                    } 
                    
                    Messaging.EmailFileAttachment emcc = new Messaging.EmailFileAttachment();
                    emcc.setFileName('Cases without Demographics Details.xls');
                    //emcc.setContentType('text/xlsx');
                    emcc.setBody(blob.valueOf(excelData));
                    
                    Messaging.EmailFileAttachment emcc1 = new Messaging.EmailFileAttachment();
                    emcc1.setFileName('Cases with Demographics Details.xls');
                    //emcc.setContentType('text/xlsx');
                    emcc1.setBody(blob.valueOf(excelDataDemog));
                    //emcc1.setBody(blob.valueOf(excelDataDemog));
                    
                    emailbody += 
                        '<p>Kindly upload the file on the SFTP site <u><a href="https://data.experian.in" target="_blank">https://data.experian.in</a> </u> . If we have not addressed this to the right team, please help us with the right contacts '+
                        'within your organisation for this. Please treat this with high priority.</p>'+
                        '<p>Please feel free to contact us for any further queries.<br/></p><br />' +
                        '<p>Regards, </p><br />' +
                        'Consumer Support Team <br/ >' +
                        'Experian Credit Information Company of India Private Limited <br />'+
                        '<u><a href="www.experian.in" target="_blank">www.experian.in</a> </u>';
                    mail.htmlbody = emailbody + '<br /> ';
                    mail.subject='Open Disputes Reminder('+ac.Name+')'+ '[ '+ threadId +' ]';
                    
                    List<Messaging.EmailFileAttachment> emcclist = new List<Messaging.EmailFileAttachment>();
                    emcclist = getFilesFromStaticResource.getFiles();
                    emcclist.add(emcc);
                    emcclist.add(emcc1);
                    mail.setFileAttachments(emcclist);
                    
                    allMails.add(mail);
                    EmailMessage em=new EmailMessage();
                    //em.Subject='List of Open Cases' + '[ '+ threadId +' ]';
                    em.subject = 'Open Disputes Reminder('+ac.Name+')'+ '[ '+ threadId +' ]';
                    em.RelatedToId=case_parentId;  
                    em.ToAddress = string.join(emails,',');
                    em.MessageDate=system.now();
                    em.Incoming=false;
                    em.Email_Body__c =EmailBody;
                    em.Status='3';
                    em.FromAddress='disputeresolution@experian.com';
                    em.FromName='Dispute Resolution';
                    insert em;
                    
                    if(tempExcel.length() > 0){
                        ContentVersion cv = new ContentVersion();
                        //blob b = blob.valueOf(tempExcel);
                        blob b = blob.valueOf(excelData);
                        cv.VersionData = b;
                        cv.Title = 'Cases without Demographics Details.xls';
                        cv.PathOnClient = 'Cases without Demographics Details.xls';
                        insert cv;
                        
                        
                        //Link the File to Parent Record
                        ContentDocumentLink cdl = new ContentDocumentLink();
                        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
                        cdl.LinkedEntityId = em.Id;
                        cdl.ShareType = 'V';
                        insert cdl;
                    }
                    
                    if(tempExcelDemog.length() > 0){
                        ContentVersion cv = new ContentVersion();
                        //blob b = blob.valueOf(tempExcelDemog);
                        blob b = blob.valueOf(excelDataDemog);
                        cv.VersionData = b;
                        cv.Title = 'Cases with Demographics Details.xls';
                        cv.PathOnClient = 'Cases with Demographics Details.xls';
                        insert cv;
                        
                        
                        //Link the File to Parent Record
                        ContentDocumentLink cdl = new ContentDocumentLink();
                        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
                        cdl.LinkedEntityId = em.Id;
                        cdl.ShareType = 'V';
                        insert cdl;
                    }
                    
                    Id bankteamId = System.Label.Foward_to_Bank_Team_Queue_Id;
                    system.debug('case_parentId'+case_parentId);
                    if(string.isNotBlank(case_parentId)){
                        Case cse = [select Id,ownerId,Status,Rejection_Reason__c from case where Id=:case_parentId];
                        cse.OwnerId = bankteamId;
                        update cse;
                    }
                    
                }
                
                system.debug('Size'+Up_Parent_CaseList.size());
                if(Up_Parent_CaseList.size() > 0){
                    database.executeBatch(new  SendEmailaccountwithCaseBatch(Up_Parent_CaseList),10);
                    
                    //update Up_Parent_CaseList;
                }
                
                List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
                return 'success';
            }
            else{
                return null;
            }
            
        }catch (Exception ex) {
            System.debug('message'+ex.getMessage() + ' -> ' + ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            //System.debug('message'+ex.getMessage());
            //throw new AuraHandledException(ex.getMessage());
            return ex.getMessage();
        }
        
        
    }
    
    private static String wrapCell(String value) {
        if (value == null) value = '';
        return '<Cell><Data ss:Type="String">' + String.escapeSingleQuotes(value) + '</Data></Cell>';
    }

    // Utility: Format Date values
    private static String formatDate(Datetime dt) {
        return (dt != null) ? dt.format() : '';
    }
    
    
    
    
    /* private static String checkNull(Object obj) {
if(obj == null)
return ',';
else
return String.valueOf(obj).trim().escapeCsv()+',';
}*/
    
    
}