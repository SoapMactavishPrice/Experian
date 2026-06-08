global class AllOpenCaseConsolidatedBatch implements Database.batchable<sObject>, schedulable{
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new AllOpenCaseConsolidatedBatch(),1);
    }
    
    global List<Account> start(Database.BatchableContext BC) {
        // > 26 April 2024
        // 
        Date myDate = Date.newInstance(2024, 4, 26);
        List<Account> accList = [select Id,Name, Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,Email_4_Dispute__c,Email_5_Dispute__c,
                                 Email_6_Dispute__c, Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c
                                 from Account where ID IN 
                                 (select AccountId from Case where (Forward_to_bank__c =: true OR Temp_Forward_to_Bank__c =: true)
                                  AND (Forward_to_Bank_Date__c >=: system.today() -7 ) AND Status = 'Open' AND AccountId !=null AND 
                                  Case_Type_Name__c='Complaint Dispute Consumer' and Sub_Type_Name__c = 'Enquiry Ownership Issue' 
                                  and Sub_Type_1_Name__c = 'Credit Enquiry does not belong to me')
                                ];
        
        /*List<Account> accList = [select Id,Name, Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,Email_4_Dispute__c,Email_5_Dispute__c,
                                 Email_6_Dispute__c, Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c
                                 from Account where ID IN 
                                 (select AccountId from Case where (Forward_to_bank__c =: true OR Temp_Forward_to_Bank__c =: true)
                                  AND (Date_of_the_email_received__c >=: myDate) AND Status = 'Open' AND AccountId !=null AND 
                                  (Case_Type_Name__c = 'Complaint Dispute Consumer' OR Case_Type_Name__c = 'Complaint Dispute Commercial'))
                                ];*/
        return accList;
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        if (scope.size()  > 1){
          throw new CommonException('Scope Size should be 1');
        }
        string accountName = '';
         for(Account acc : scope){
            accountName = acc.Name;
         }
        try{
        system.debug('totol cases '+scope.size());
        List<Messaging.SingleEmailMessage> lstEmail = new List<Messaging.SingleEmailMessage>();
        List<Messaging.EmailFileAttachment> emcclist = new List<Messaging.EmailFileAttachment>();
        emcclist = getFilesFromStaticResource.getFiles();
        
        //EmailMessage em=new EmailMessage();
        blob b1;
        string accId = '';
        //map<Id,blob> mapblob = new map<Id,blob>();
        
        Date myDate1 = Date.newInstance(2024, 4, 26);
        
        String Name = UserInfo.getName();
        DateTime myDate = Datetime.NOW().addDays(-1);
        String ansDate = myDate.format('dd-MMM-YYYY');
        
        OrgWideEmailAddress[] owea = new OrgWideEmailAddress[]{};
            if(!test.isRunningTest()){
                owea = [select Id from OrgWideEmailAddress where Address = 'disputeresolution@experian.com' limit 1];// To send from Org wide address
            }
        
        map<Id,string>excelMap = new map<Id,string>();
        List<EmailMessage> emcList = new List<EmailMessage>();
        EmailMessage em=new EmailMessage();
        integer i = 0;
        
        Map<Id,Case> caseMap = new Map<Id,Case>();
        
       set<Id> accIds = new set<Id>();
        for(Account acc : scope){
            accIds.add(acc.Id);
        }
       
        List<Case> csList = [SELECT Id,Open_Ageing_with_Bank__c,AccountId, Dispute_Raised_Date__c, CaseNumber , Name_of_Consumer__r.Name, Account.Name ,
                                  Displayed_Account_Type__c , Displayed_Account_number__c,Dispute_Detail__c,Sub_Type_Lookup__r.Name,DIS_Id__c,Origin,Date_of_the_email_received__c,
                                  Name_of_Consumer__r.BirthDate,Displayed_Address__c,Displayed_Address_1_v1__c,Name_of_Consumer__r.Phone,Name_of_Consumer__r.Email,Name_of_Consumer__r.Pan_no__c,
                                  Displayed_Values__c,Enquiry_Loan_Amount__c,Enquiry_User_Id__c,Correct_Values__c,Enquiry_Date__c,  Sub_Type_Name__c,Sub_Type_1_Name__c,Internal_Comment__c, Status, Case_Type_Name__c
                                  FROM Case WHERE (Forward_to_bank__c =: true OR Temp_Forward_to_Bank__c =: true)
                                  AND (Forward_to_Bank_Date__c >=: system.today() -7 ) AND Status = 'Open' AND AccountId !=null AND 
                                  Case_Type_Name__c='Complaint Dispute Consumer' and Sub_Type_Name__c = 'Enquiry Ownership Issue' 
                                  and Sub_Type_1_Name__c = 'Credit Enquiry does not belong to me'
                                  and AccountId IN : accIds];
                                
        for(Account acc : scope){
            accId = acc.Id;
            accountName = acc.Name;
            Integer TotalCases = 0;
            for(case cs: csList){
                TotalCases = TotalCases+1;
            }
            //Integer TotalCases = acc.Cases.size();
            i++;
            List<String> toAddresses = new List<String>();
            String emailId='';
            
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
            
            String EmailBody='<html><body style="font-family: Verdana;">';
            EmailBody += 'Dear Team,<br/><br/>'; 
            EmailBody += 'Please find the enclosed consolidated Open complaints from last 7 days.<br/><br/>';
            
            EmailBody += 'As per RBI circular 72 and 73, we are mandated by a 21 days (for banks) TAT which we will breach in case we do not receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed.<br/><br/>';
            
            EmailBody += ' 1. <b>For changes to be done in credit report </b> - We request you to share the correction on the SFTP folder and share the snapshot with us. We do not accept changes in excel attachment or on the email body. In the attached excel file (Dispute Cases.xlsx),kindly mention ‘Accepted’ in the column ‘Dispute Accepted / Rejected’.'+
                ' Also, provide the OLM file Name in the column ‘Name of OLM File’; date of the file when uploaded against ‘Date of upload of OLM File’ column and SFTP user ID to be mentioned in the column ‘CinpID where the OLM file is uploaded’. Sample case provided in row number 3 in the attached file (Dispute Cases.xlsx). <b><u>Uploading the OLM file on SFTP and sharing the snapshot is mandatory for changes to be done in credit report. Kindly mark cc to <a href="olmteam@experian.com">olmteam@experian.com</a>  mandatorily.</u></b><br/><br/>';
            EmailBody += '2. <b>For no changes to be done in credit report  </b> - If there are no changes to be done in the credit report then please mention ‘Rejected’ in the column ‘Member Comments’ in the Dispute Cases.xlsx and resend the file. Sample case provided in row number 2 in the attached file (Dispute Cases.xlsx).<br/><br/>';
            
            EmailBody +='If we have not addressed this to the right team, please help us with the right contacts with your organisation, so that we can update the contacts at our end too.<br/><br/>';
            
            EmailBody+='If you have already replied on given cases with correct format then please ignore that complaints, we will work upon those cases.<br/><br/>';
            EmailBody +='Please feel free to contact us for any further queries.<br/><br/>';
            
            EmailBody +='<p>Note:<br /> 1) Please fill only the Demographic Details sheet for correction regards to demographic changes.<br/>';
            EmailBody +='2) For correction regarding Suppression of Credit Enquiry or Account, please fill only the Suppression Request sheet.<br/>';
            EmailBody +='3) Except Demographic and Suppression, all other correction will be in Normal Updation sheet.</p>';
            //EmailBody +='Further, we request you to read the explanation of OLM in the file named “OLM Suppression Demographic Correction“ and then accordingly fill the form for correction.<br/><br/>';
            
            EmailBody+='<b>For detailed explanation, kindly refer the attached SOP (File Name – ECICI SOP Circular 72 & 73.pdf).</b><br/><br/>';
            EmailBody +='Please treat this with high priority.<br/><br/>';
            
            EmailBody +='Regards,<br/><br/>';
            EmailBody +='Consumer Support Team<br/>';
            EmailBody +='Experian Credit Information Company of India Private Limited<br/>';
            EmailBody +='<a href="www.experian.in">www.experian.in</a><br/><br/>';
            //EmailBody +='Get your Experian Credit Report & Score today, <a href="https://consumer.experian.in/ECV-OLN/view/angular/#/">click here</a></body></html>';
            
            
            List<String> caseexcelRow = new List<String>();
            String tempExcel = '';
            tempExcel = '<style>table{border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #D5D5D5}td,th{padding:5px;border:1px solid #D5D5D5}';
            tempExcel += 'th{font-size:25px;font-weight:400;text-align:center;background-color:#D5D5D5;color:#fff}td{font-size:11px;font-weight:100;text-align:left}</style>';
            String excelData = '<?xml version="1.0" encoding="UTF-8"?>' +
                           '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" ' +
                           'xmlns:o="urn:schemas-microsoft-com:office:office" ' +
                           'xmlns:x="urn:schemas-microsoft-com:office:excel" ' +
                           'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">' +
                           '<Worksheet ss:Name="Cases"><Table>';
            
            
            tempExcel += '<table border="1px"><tr><th>Dispute ID</th><th>Case No.</th><th>Case Id</th><th>Email Received Date</th> <th>Dispute Raised Date</th> <th>Source of Dispute</th> <th>Sub Type</th> <th>Sub Type 1</th><th>Consumer name</th><th>Member Name</th><th>Date of Birth</th><th>Address</th><th>Contact no</th><th>Email ID</th><th>PAN Detail</th><th>Account Type</th><th>Account No</th><th>Dispute Details</th><th>Displayed Values</th><th>Correct Values</th><th>Enquiry User Id</th><th>Enquiry Loan Amount</th><th>Enquiry Date</th><th>Dispute Accepted / Rejected</th> <th>Dispute Rejected Reason</th><th>Name of OLM File</th><th>Date of upload of OLM File</th><th>CinpID where the OLM file is uploaded</th>';
            excelData += '<Row>' +
                '<Cell><Data ss:Type="String">Dispute ID</Data></Cell>' +
                '<Cell><Data ss:Type="String">Case No.</Data></Cell>' +
                '<Cell><Data ss:Type="String">Case Id</Data></Cell>' +
                '<Cell><Data ss:Type="String">Email Received Date</Data></Cell>' +
                '<Cell><Data ss:Type="String">Dispute Raised Date</Data></Cell>' +
                '<Cell><Data ss:Type="String">Source of Dispute</Data></Cell>' +
                '<Cell><Data ss:Type="String">Sub Type</Data></Cell>' +
                '<Cell><Data ss:Type="String">Sub Type 1</Data></Cell>' +
                '<Cell><Data ss:Type="String">Consumer name</Data></Cell>' +
                '<Cell><Data ss:Type="String">Member Name</Data></Cell>' +
                '<Cell><Data ss:Type="String">Date of Birth</Data></Cell>' +
                '<Cell><Data ss:Type="String">Address</Data></Cell>' +
                '<Cell><Data ss:Type="String">Contact no</Data></Cell>' +
                '<Cell><Data ss:Type="String">Email ID</Data></Cell>' +
                '<Cell><Data ss:Type="String">PAN Detail</Data></Cell>' +
                '<Cell><Data ss:Type="String">Account Type</Data></Cell>' +
                '<Cell><Data ss:Type="String">Account No</Data></Cell>' +
                '<Cell><Data ss:Type="String">Dispute Details</Data></Cell>' +
                '<Cell><Data ss:Type="String">Displayed Values</Data></Cell>' +
                '<Cell><Data ss:Type="String">Correct Values</Data></Cell>' +
                '<Cell><Data ss:Type="String">Enquiry User Id</Data></Cell>' +
                '<Cell><Data ss:Type="String">Enquiry Loan Amount</Data></Cell>' +
                '<Cell><Data ss:Type="String">Enquiry Date</Data></Cell>' +
                '<Cell><Data ss:Type="String">Dispute Accepted / Rejected</Data></Cell>' +
                '<Cell><Data ss:Type="String">Dispute Rejected Reason</Data></Cell>' +
                '<Cell><Data ss:Type="String">Name of OLM File</Data></Cell>' +
                '<Cell><Data ss:Type="String">Date of upload of OLM File</Data></Cell>' +
                '<Cell><Data ss:Type="String">CinpID where the OLM file is uploaded</Data></Cell>' +
                '</Row>';
            
            for(Case cs : csList){
                caseMap.put(cs.Id, cs);
                //if(string.isNotBlank(cs.Sub_Type_Lookup__c) && string.isNotBlank(cs.Sub_Type_1_Name__c) ){ 
                String DOB;
                String DOB2;
                String DOB3;
                String DOB4;
                if(test.isRunningTest()){
                    DOB = '02/01/2021'; 
                    DOB2 = '02/01/2021'; 
                    DOB3= '02/01/2021'; 
                }
                else{
                    date dt1 =cs.Name_of_Consumer__r.BirthDate;
                    if(string.isNotBlank(string.valueOf(dt1))){
                        DOB = String.valueof(dt1);
                    }else{
                        DOB = '-';
                    }
                    
                    date dt2 =cs.Date_of_the_email_received__c;
                    if(string.isNotBlank(string.valueOf(dt2))){
                        DOB2 = String.valueof(dt2);
                    }else{
                        DOB2 = '-';
                    }
                    
                    date dt3 =cs.Dispute_Raised_Date__c;
                    if(string.isNotBlank(string.valueOf(dt3))){
                        DOB3 = String.valueof(dt3);
                    }else{
                        DOB3 = '-';
                    }
                    
                    date dt4 =cs.Enquiry_Date__c;
                    if(string.isNotBlank(string.valueOf(dt4))){
                        DOB4 = String.valueof(dt4);
                    }else{
                        DOB4 = '-';
                    }
                } 
                
                if(cs.Sub_Type_Lookup__r.Name =='Enquiry Ownership Issue'){ 
                     string Displayed_Address_1 = cs.Displayed_Address__c != null ? cs.Displayed_Address__c : cs.Displayed_Address_1_v1__c;
                    caseexcelRow.add('<tr><td style="text-align:center">'+cs.DIS_Id__c+'</td><td style="text-align:center">'+cs.CaseNumber+'</td><td style="text-align:center">'+cs.Id+'</td><td style="text-align:center">'+DOB2+'</td> <td style="text-align:center">'+DOB3+'</td><td style="text-align:center">'+cs.Origin+'</td><td style="text-align:center">'+cs.Sub_Type_Name__c+'</td><td style="text-align:center">'+cs.Sub_Type_1_Name__c+'</td><td style="text-align:center">'+cs.Name_of_Consumer__r.Name+'</td> <td style="text-align:center">'+cs.Account.Name+'</td> <td>' + DOB + '</td><td>' + Displayed_Address_1 + '</td><td>' + cs.Name_of_Consumer__r.Phone + '</td><td>' + cs.Name_of_Consumer__r.Email + '</td><td>' + cs.Name_of_Consumer__r.Pan_no__c + '</td><td style="text-align:center">'+cs.Displayed_Account_Type__c+'</td> <td style="text-align:center">'+cs.Displayed_Account_number__c+'</td>  <td style="text-align:center">'+cs.Dispute_Detail__c+'</td><td style="text-align:center">'+cs.Displayed_Values__c+'</td><td style="text-align:center">'+cs.Correct_Values__c+'</td><td style="text-align:center">'+cs.Enquiry_User_Id__c+'</td><td style="text-align:center">'+cs.Enquiry_Loan_Amount__c+'</td><td style="text-align:center">'+DOB4+'</td><td></td><td></td><td></td><td></td><td></td></tr>');
                    //caseexcelRow.add('<tr><td style="text-align:center">'+cs.DIS_Id__c+'</td><td style="text-align:center">'+cs.CaseNumber+'</td><td style="text-align:center">'+DOB2+'</td> <td style="text-align:center">'+DOB3+'</td><td style="text-align:center">'+cs.Origin+'</td><td style="text-align:center">'+cs.Sub_Type_Name__c+'</td><td style="text-align:center">'+cs.Sub_Type_1_Name__c+'</td><td style="text-align:center">'+cs.Name_of_Consumer__r.Name+'</td> <td style="text-align:center">'+cs.Account.Name+'</td> <td>' + DOB + '</td><td>' + cs.Displayed_Address__c + '</td><td>' + cs.Name_of_Consumer__r.Phone + '</td><td>' + cs.Name_of_Consumer__r.Email + '</td><td>' + cs.Name_of_Consumer__r.Pan_no__c + '</td><td style="text-align:center">'+cs.Displayed_Account_Type__c+'</td> <td style="text-align:center">'+cs.Displayed_Account_number__c+'</td>  <td style="text-align:center">'+cs.Dispute_Detail__c+'</td><td>'+option+'</td><td style="text-align:center"></td></tr>');
                    excelData += '<Row>' +
                        wrapCell(cs.DIS_Id__c) +
                        wrapCell(cs.CaseNumber) +
                        wrapCell(cs.Id) +
                        wrapCell(DOB2) +   // Assuming DOB2 is a date value
                        wrapCell(DOB3) +   // Assuming DOB3 is a date value
                        wrapCell(cs.Origin) +
                        wrapCell(cs.Sub_Type_Name__c) +
                        wrapCell(cs.Sub_Type_1_Name__c) +
                        wrapCell(cs.Name_of_Consumer__r.Name) +
                        wrapCell(cs.Account.Name) +
                        wrapCell(DOB) +    // Assuming DOB is a date value
                        wrapCell(Displayed_Address_1) +
                        wrapCell(cs.Name_of_Consumer__r.Phone) +
                        wrapCell(cs.Name_of_Consumer__r.Email) +
                        wrapCell(cs.Name_of_Consumer__r.Pan_no__c) +
                        wrapCell(cs.Displayed_Account_Type__c) +
                        wrapCell(cs.Displayed_Account_number__c) +
                        wrapCell(cs.Dispute_Detail__c) +
                        wrapCell(cs.Displayed_Values__c) +
                        wrapCell(cs.Correct_Values__c) +
                        wrapCell(cs.Enquiry_User_Id__c) +
                        wrapCell(string.valueOf(cs.Enquiry_Loan_Amount__c)) +
                        wrapCell(DOB4) +   // Assuming DOB4 is a date value
                        wrapCell('') +  // Empty cell
                        wrapCell('') +  // Empty cell
                        wrapCell('') +  // Empty cell
                        wrapCell('') +  // Empty cell
                        wrapCell('') +  // Empty cell
                        '</Row>';

                }
                /*else{
                    caseexcelRow.add('<tr><td style="text-align:center">'+cs.DIS_Id__c+'</td><td style="text-align:center">'+cs.CaseNumber+'</td><td style="text-align:center">'+cs.Id+'</td><td style="text-align:center">'+DOB2+'</td> <td style="text-align:center">'+DOB3+'</td><td style="text-align:center">'+cs.Origin+'</td><td style="text-align:center">'+cs.Sub_Type_Name__c+'</td><td style="text-align:center">'+cs.Sub_Type_1_Name__c+'</td><td style="text-align:center">'+cs.Name_of_Consumer__r.Name+'</td> <td style="text-align:center">'+cs.Account.Name+'</td> <td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td style="text-align:center">'+cs.Displayed_Account_Type__c+'</td> <td style="text-align:center">'+cs.Displayed_Account_number__c+'</td>  <td style="text-align:center">'+cs.Dispute_Detail__c+'<td style="text-align:center">'+cs.Displayed_Values__c+'</td><td style="text-align:center">'+cs.Correct_Values__c+'</td><td style="text-align:center">'+cs.Enquiry_User_Id__c+'</td><td style="text-align:center">'+cs.Enquiry_Loan_Amount__c+'</td><td style="text-align:center">'+DOB4+'</td></td> <td></td><td></td><td></td><td></td><td></td></tr>');
                    
                    
                    //                   caseexcelRow.add('<tr><td style="text-align:center">'+cs.DIS_Id__c+'</td><td style="text-align:center">'+cs.CaseNumber+'</td><td style="text-align:center">'+DOB2+'</td> <td style="text-align:center">'+DOB3+'</td><td style="text-align:center">'+cs.Origin+'</td><td style="text-align:center">'+cs.Sub_Type_Name__c+'</td><td style="text-align:center">'+cs.Sub_Type_1_Name__c+'</td><td style="text-align:center">'+cs.Name_of_Consumer__r.Name+'</td> <td style="text-align:center">'+cs.Account.Name+'</td> <td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td style="text-align:center">'+cs.Displayed_Account_Type__c+'</td> <td style="text-align:center">'+cs.Displayed_Account_number__c+'</td>  <td style="text-align:center">'+cs.Dispute_Detail__c+'</td> <td>'+option+'</td><td style="text-align:center"></td></tr>');
                	excelData += '<Row>' +
  wrapCell(cs.DIS_Id__c) +
  wrapCell(cs.CaseNumber) +
  wrapCell(cs.Id) +
  wrapCell(DOB2) +   // Assuming DOB2 is a date value
  wrapCell(DOB3) +   // Assuming DOB3 is a date value
  wrapCell(cs.Origin) +
  wrapCell(cs.Sub_Type_Name__c) +
  wrapCell(cs.Sub_Type_1_Name__c) +
  wrapCell(cs.Name_of_Consumer__r.Name) +
  wrapCell(cs.Account.Name) +
  wrapCell('-') +  // For the column with "-". If you want to use dynamic data, replace with relevant field.
  wrapCell('-') +  // For the column with "-".
  wrapCell('-') +  // For the column with "-".
  wrapCell('-') +  // For the column with "-".
  wrapCell('-') +  // For the column with "-".
  wrapCell(cs.Displayed_Account_Type__c) +
  wrapCell(cs.Displayed_Account_number__c) +
  wrapCell(cs.Dispute_Detail__c) +
  wrapCell(cs.Displayed_Values__c) +
  wrapCell(cs.Correct_Values__c) +
  wrapCell(cs.Enquiry_User_Id__c) +
  wrapCell(string.valueOf(cs.Enquiry_Loan_Amount__c)) +
  wrapCell(DOB4) +  // Assuming DOB4 is a date value
  wrapCell('') +  // Empty cell
  wrapCell('') +  // Empty cell
  wrapCell('') +  // Empty cell
  wrapCell('') +  // Empty cell
  wrapCell('') +  // Empty cell
'</Row>';

                
                }*/
                //}
            }
            
            if(caseexcelRow.size()> 0){
                //string temp ;
                //string tempdata = '';
                //temp += String.join(caseexcelRow,' ');
                //tempdata +=temp.replace('null','');
                //tempExcel += tempdata.replace('00:00:00','');
                //tempExcel +='</table>';
                 excelData += '</Table></Worksheet></Workbook>';
            }
            
            Messaging.EmailFileAttachment emcc1 = new Messaging.EmailFileAttachment();
            emcc1.setFileName('Dispute Cases.xls');
            //emcc1.setBody(blob.valueOf(tempExcel));
            emcc1.setBody(blob.valueOf(excelData));
            emcclist.add(emcc1);
            //b1 = blob.valueOf(tempExcel);
            b1 = blob.valueOf(excelData);
            //excelMap.put(acc.Id,tempExcel);
            Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
            
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            //mail.setToAddresses(new List<string>{'balram@finessedirect.com'});
            //mail.setToAddresses(new List<string>{'rishikesh.korade@finessedirect.com','balram@finessedirect.com','muskanbee.shaikh@experian.com','asif.husain@experian.com'});
            mail.setToAddresses(toAddresses);
            
            mail.setHtmlBody(EmailBody);
            mail.setFileAttachments(emcclist);
            
            //mail.setFileAttachments(objPDFAttachmentList);
            
            mail.setSubject('Enquiry Consolidated Open complaints of last 7 days | '+acc.Name);
            mail.setUseSignature(false); 
            mail.setBccSender(false);
            mail.setSaveAsActivity(false); 
            lstEmail.add(mail);
            
            //EmailMessage em=new EmailMessage();
            em.Subject='Enquiry Consolidated Open complaints of last 7 days | '+acc.Name;
            em.RelatedToId=acc.id;  
            em.ToAddress=emailId;
            em.MessageDate=system.now();
            em.Incoming=false;
            em.Email_Body__c =EmailBody;
            em.Status='3';
            em.FromAddress='disputeresolution@experian.com';
            em.FromName='Dispute Resolution';
            emcList.add(em);
            
        }
        
        system.debug('total Email'+lstEmail.size());
        List<API_LOG__c> apliLogList = new List<API_LOG__c>();
        if(lstEmail.size() > 0){
            system.debug('lstEmail'+lstEmail.size());
            //List<Messaging.sendEmailResult> results = Messaging.sendEmail(lstEmail);
            try{
                Messaging.SendEmailResult[] sendResults = Messaging.sendEmail(lstEmail);  
                
                for(Messaging.SendEmailResult result: sendResults){
                    if(result.isSuccess()){
                        insert em;
                        
                        if(b1 !=null){
                            
                        
                        ContentVersion cv = new ContentVersion();
                        cv.VersionData = b1;
                        cv.Title = 'Dispute Cases.xls';
                        cv.PathOnClient = 'Dispute Cases.xls';
                        insert cv;
                        
                        ContentDocumentLink cdl = new ContentDocumentLink();
                        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
                        cdl.LinkedEntityId = em.Id;
                        cdl.ShareType = 'V';
                        insert cdl;
                        }
                        
                    }
                }
            }catch(exception e){
                API_LOG__c ap =new API_LOG__c();
                ap.Request_Source__c='Enquiry Consolidated Batch Failed of Account Name '+accountName;
                ap.Exception_Description__c = 'e line '+e.getLineNumber() +'   '+e.getMessage();
                apliLogList.add(ap);   
            }   
        }
        
        system.debug('failed list '+apliLogList.size());
        if(apliLogList.size() > 0){
            insert apliLogList;
        } 
      }catch(exception e){
                API_LOG__c ap =new API_LOG__c();
                ap.Request_Source__c='Consolidated Batch Failed of Account Name '+accountName;
                ap.Exception_Description__c = 'e line '+e.getLineNumber() +'   '+e.getMessage();
                insert ap;   
            }   
    }
    
    private String wrapCell(String value) {
        if (value == null) value = '';
        return '<Cell><Data ss:Type="String">' + String.escapeSingleQuotes(value) + '</Data></Cell>';
    }

    // Utility: Format Date values
    private String formatDate(Datetime dt) {
        return (dt != null) ? dt.format() : '';
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
    
    public class CommonException extends Exception {}

}