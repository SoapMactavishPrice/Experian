public class QueableForSendEmail_Dte implements Queueable{
    private Map<Integer, List<Account>>  records;
    private String action;      //insert or update or upsert or delete
    private Integer batchSize;
    private Integer currentBatch;
    private String finallyHandlerName;
    private Id parentId;
    private Integer successCount; 
    public Integer offset = 1;
    public Integer lmit = 0;
    List<Account> accList;
    
    // Quick Off
    public QueableForSendEmail_Dte(List<Account> recordsList,string action, Integer batchSize){
        this.records = batchOutDmls(recordsList, batchSize);
        this.action  = action;
        this.batchSize = batchSize;
        this.currentBatch = 1;
        this.successCount = 0;
    }
    
    //Iterative Queueable job
    
    public QueableForSendEmail_Dte(Map<Integer, List<Account>>  records, string action ,Integer batchSize, Integer currentBatch, Integer successCount){
        this.records = records;
        this.action = action;
        this.batchSize = batchSize;
        this.currentBatch = currentBatch;
        this.successCount = successCount; 
    }
    
    public void execute(QueueableContext context) {
        if(this.records.containsKey(this.currentBatch)){
            Boolean success = false;
            Integer processedRecords = 0;
            try {
                
                
                List<Account> thisBatchRecords = this.records.get(this.currentBatch);
                processedRecords = thisBatchRecords.size();
                system.debug('processedRecords'+processedRecords);
                switch on action {
                    when 'SEND' {
                        set<Id> caseIds = new set<Id>();
                        set<Id> accIds = new set<Id>();
                        
                        //for(integer  i  :  this.records.keyset()){
                        //List<Account> accList = (List<Account>)records.get(i);
                        for(Account ac :  thisBatchRecords){
                            accIds.add(ac.Id);
                        }
                        ///}
                        
                        system.debug('accIds'+accIds);
                        
                        string query ='Select Id, Name, Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,'+
                            'CC_Address_1__c, CC_Address_10__c, CC_Address_2__c, CC_Address_3__c, CC_Address_4__c, CC_Address_5__c, CC_Address_6__c,'+
                            'CC_Address_7__c, CC_Address_8__c, CC_Address_9__c,'+
                            'Email_4_Dispute__c,Email_5_Dispute__c,Email_6_Dispute__c,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c'+
                            //'(select Id ,Email from Contacts where Contact_Role__c =\'Dispute Manager – Escalation Level 2\'),(Select Id,AccountId from Cases where (status = \'Open\' or status = \'Customer Notified\') and Owner.Name =\'Bank Team\' and Account_s_Parent_Case__c = false ) From Account Where Id =:aId';//IN (SELECT AccountId From Case Where (status = \'Open\' or status = \'Customer Notified\') and Owner.Name =\'Bank Team\' and Account_s_Parent_Case__c = false )';
                            ' ,(select Id ,Email from Contacts where Contact_Role__c =\'Dispute Manager – Escalation Level 2\')'+
                            ' From Account where Id IN : accIds and Do_Not_Send_Auto_Reminder__c =false';//IN (SELECT AccountId From Case Where (status = \'Open\' or status = \'Customer Notified\') and Owner.Name =\'Bank Team\' and Account_s_Parent_Case__c = false )';
                        
                        accList=Database.query(query); 
                        system.debug('accList'+accList.size());
                        Date cutoffDate = Date.newInstance(2024, 4, 25);
                        string que = 'select Id, Name_of_Consumer__r.Name,Name_of_Consumer__r.BirthDate,Raised_Days__c,Member_TAT__c,'+
                            +' Name_of_Consumer__r.Phone,AccountId,Name_of_Consumer__r.Email,Name_of_Consumer__r.Pan_no__c, Dispute_Raised_Date__c, '+
                            +' Account.Name, Displayed_Account_Type__c, Displayed_Account_number__c, Dispute_Detail__c,  '+
                            +' Displayed_Details__c, Correct_Details__c,Open_Ageing_with_Bank__c,Enquiry_User_Id__c,Enquiry_Loan_Amount__c, '+
                            +'CaseNumber ,Sub_Type_Lookup__r.Name ,Displayed_Address__c,Displayed_Address_1_v1__c,Date_of_the_email_received__c, Open_Dispute_Days_TAT__c, Account_Date_Reported__c '+
                            ' from Case where AccountId IN : accIds and (status = \'Open\' or status = \'Customer Notified\')';
                        if(!test.isRunningTest()){
                            que+=  ' and Owner.Name =\'Bank Team\' and Account_s_Parent_Case__c = false ';
                            que+=' and Date_of_the_email_received__c >: cutoffDate '; 
                        }
                        
                        
                        List<Case> casesList = dataBase.query(que);
                        system.debug(casesList.size());
                        map<Id,List<Case>> CaseMapRow = new map<Id,List<Case>>();
                        
                        for(Case csp : casesList){
                            caseIds.add(csp.Id);
                            if(CaseMapRow.containskey(csp.AccountId)){
                                CaseMapRow.get(csp.AccountId).add(csp); 
                            }else{
                                CaseMapRow.put(csp.AccountId, new List<Case>{csp});   
                            }
                        }
                        
                        system.debug(CaseMapRow.size()+'---'+CaseMapRow);
                        system.debug(this.records.size());
                        
                        
                        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
                        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'disputeresolution@experian.com'];
                        //To send from Org wide address
                        System.debug('owea  '+owea); // balramp610@gmail.com   consumer.support@in.experian.com	                 
                        
                        boolean bfalse = false;
                        string summary ;
                        Id  case_parentId ;
                        summary =  '<style>th{background-color:#1798c1;color:#000000}</style>';
                        summary += '<table border="1" style="border-collapse:collapse;width:50;"><tr><th>Month Raised</th><th>Count of Pending Cases</th></tr>';
                        
                        Map<string,map<string,string>> accwithmonth = new Map<string,map<string,string>>();
                        List<AggregateResult> areList = [select count(Id) cid,CALENDAR_MONTH(CreatedDate) month,AccountId,CALENDAR_YEAR(CreatedDate) year
                                                         from case where AccountId IN : accIds AND ID IN:caseIds
                                                         GROUP BY AccountId, CALENDAR_MONTH(CreatedDate),CALENDAR_YEAR(CreatedDate) limit 50000];
                        system.debug('areList'+areList);
                        
                        for(AggregateResult ar :areList){
                            if(accwithmonth.containskey(string.valueOf(ar.get('AccountId')))){
                                accwithmonth.get(string.valueOf(ar.get('AccountId'))).put(string.valueOf(ar.get('month'))+':'+string.valueOf(ar.get('year')),string.valueOf(ar.get('cid')));
                            }else{
                                map<string,string> monthcount = new map<string,string>();
                                monthcount.put(string.valueOf(ar.get('month'))+':'+string.valueOf(ar.get('year')),string.valueOf(ar.get('cid')));
                                accwithmonth.put(string.valueOf(ar.get('AccountId')),monthcount);
                            }
                            
                        }
                        Map<Id,Case> caseMap = new Map<Id,Case>();
                        List<Case> Caselist = [Select Id, AccountId,Account_s_Parent_Case__c from Case where Account_s_Parent_Case__c =:true and AccountId IN:accIds];
                        system.debug('Caselist'+Caselist.size());
                        for(Case cs : Caselist){
                            caseMap.put(cs.AccountId,cs);
                        }
                        
                        String threadId;
                        
                        
                        List<EmailMessage> mail_Message = new List<EmailMessage>();
                        string accountName='';
                        EmailMessage em=new EmailMessage();
                        blob b;
                        blob b1;
                        
                         // Start of New Line of code
                         Map<Id, List<Compensation_Child_Cases__c>> compCaseMap = new Map<Id, List<Compensation_Child_Cases__c>>();

                        
                        List<Compensation_Child_Cases__c> compCases = [
                            SELECT Id, Consumer_Name__c, Consumer_Email_ID__c, Case_Number__c,
                                   Displayed_Account_number__c, Sub_Type_Name__c, Sub_Type_1_Name__c, Account_Name__c,
                                   Dispute_Received_Date__c, Resolve_Date__c, Status__c,
                                   Delayed_No_of_Days__c, Liable_Amount__c, Experian_Liability_Amt__c,
                                   Compensation_Opted__c, Bank_Name__c, Account_Number__c,
                                   IFSC_Code__c, Consumer_Name_As_per_Bank_Account__c,
                                   Parent_Case__r.AccountId, Liable_Party_Account_Id__c, Compensation_Email_Sent_Date__c
                            FROM Compensation_Child_Cases__c
                            WHERE Liable_Party_Account_Id__c IN :accIds
                            AND Compensation_Email_Sent_Date__c = null
                            AND (Compensation_Opted__c = 'Yes' OR Compensation_Opted__c = 'No')
                            ORDER BY Case_Number__c ASC
                        ];

                        for(Compensation_Child_Cases__c rec : compCases){
                            Id accId = rec.Liable_Party_Account_Id__c;
                            if(!compCaseMap.containsKey(accId)){
                                compCaseMap.put(accId, new List<Compensation_Child_Cases__c>());
                            }
                            compCaseMap.get(accId).add(rec);
                        }
                        // End of New Line of code

                        Blob compBlob;
                        String compFileName;
                        
                        Map<Id, List<Compensation_Child_Cases__c>> compUpdateMap = new Map<Id, List<Compensation_Child_Cases__c>>();  
                        List<Id> accountOrder = new List<Id>();

                        for(Account ac : accList) {
                            compBlob = null;        
                            compFileName = null;
                            accountOrder.add(ac.Id);
                            List<Messaging.EmailFileAttachment> emcclist = new List<Messaging.EmailFileAttachment>();
    						emcclist.addAll(getFilesFromStaticResource.getFiles());
                            
                            // Start of New Line of code
                            if(compCaseMap.containsKey(ac.Id)){
                            compUpdateMap.put(ac.Id, compCaseMap.get(ac.Id));
                            List<Compensation_Child_Cases__c> childList = compCaseMap.get(ac.Id);
                            String excelData2 = '<?xml version="1.0" encoding="UTF-8"?>' +
                                '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" ' +
                                'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">' +
                                '<Worksheet ss:Name="Compensation"><Table>';
                        
                            // Header Row
                            excelData2 += '<Row>' +
                                wrapCell('Consumer Name') +
                                wrapCell('Consumer Email ID') +
                                wrapCell('Case Number') +
                                wrapCell('Displayed Account number') +
                                wrapCell('Complaint Category') +
                                wrapCell('Complaint Sub-Category') +
                                wrapCell('Liable Party') +
                                wrapCell('Dispute Received Date') +
                                wrapCell('Dispute Resolution Date') +
                                wrapCell('Status') +
                                wrapCell('No. of Days Delayed') +
                                wrapCell('Credit Institution Liability Amt.') +
                                wrapCell('Experian Liability Amt.') +
                                wrapCell('Compensation Opted') +
                                wrapCell('Bank Name Payout') +
                                wrapCell('Account Number Payout') +
                                wrapCell('IFSC Code') +
                                wrapCell('Account Holder Name') +
                            '</Row>';
                        
                            // Data Rows
                            for(Compensation_Child_Cases__c c : childList){
                                excelData2 += '<Row>' +
                                    wrapCell(c.Consumer_Name__c) +
                                    wrapCell(c.Consumer_Email_ID__c) +
                                    wrapCell(c.Case_Number__c) +
                                    wrapCell(c.Displayed_Account_number__c) +
                                    wrapCell(c.Sub_Type_Name__c) +
                                    wrapCell(c.Sub_Type_1_Name__c) +
                                    wrapCell(c.Account_Name__c) +
                                    wrapCell(c.Dispute_Received_Date__c != null ? c.Dispute_Received_Date__c.format() : '') +
                                    wrapCell(c.Resolve_Date__c != null ? c.Resolve_Date__c.format() : '') +
                                    wrapCell(c.Status__c) +
                                    wrapCell(String.valueOf(c.Delayed_No_of_Days__c)) +
                                    wrapCell(String.valueOf(c.Liable_Amount__c)) +
                                    wrapCell(String.valueOf(c.Experian_Liability_Amt__c)) +
                                    wrapCell(c.Compensation_Opted__c) +
                                    wrapCell(c.Bank_Name__c) +
                                    wrapCell(c.Account_Number__c) +
                                    wrapCell(c.IFSC_Code__c) +
                                    wrapCell(c.Consumer_Name_As_per_Bank_Account__c) +
                                '</Row>';
                            }
                        
                            excelData2 += '</Table></Worksheet></Workbook>';
                        
                            Messaging.EmailFileAttachment compAttachment = new Messaging.EmailFileAttachment();
                            compAttachment.setFileName('Resolved Cases.xls');
                            compAttachment.setBody(Blob.valueOf(excelData2));
                            compAttachment.setContentType('application/vnd.ms-excel');
                        
                            emcclist.add(compAttachment);

                            compBlob = Blob.valueOf(excelData2);
                            compFileName = 'Resolved Cases.xls';
                        } 
                        // End of New Line of code  
                            
                            accountName = ac.Name;
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
                            
                            for(Contact con : ac.Contacts){
                                if(!emailList.contains(con.Email))  {}
                                emailList.add(con.Email);
                                
                            } 
                            
                            List<String> toCCAddresses = new List<String>();
                            if(ac.CC_Address_1__c != null){
                                if(!toCCAddresses.contains(ac.CC_Address_1__c))   
                                    toCCAddresses.add(ac.CC_Address_1__c);
                            }
                            
                            if(ac.CC_Address_2__c != null){
                                if(!toCCAddresses.contains(ac.CC_Address_2__c)) 
                                    toCCAddresses.add(ac.CC_Address_2__c);
                            }
                            
                            if(ac.CC_Address_3__c != null){
                                if(!toCCAddresses.contains(ac.CC_Address_3__c)) 
                                    toCCAddresses.add(ac.CC_Address_3__c);
                            }
                            
                            if(ac.CC_Address_4__c != null){
                                if(!toCCAddresses.contains(ac.CC_Address_4__c)) 
                                    toCCAddresses.add(ac.CC_Address_4__c);
                            }
                            
                            if(ac.CC_Address_5__c != null){
                                if(!toCCAddresses.contains(ac.CC_Address_5__c)) 
                                    toCCAddresses.add(ac.CC_Address_5__c);
                            }
                            
                            if(ac.CC_Address_6__c != null){
                                if(!toCCAddresses.contains(ac.CC_Address_6__c)) 
                                    toCCAddresses.add(ac.CC_Address_6__c);
                            }
                            
                            if(ac.CC_Address_7__c != null){
                                if(!toCCAddresses.contains(ac.CC_Address_7__c)) 
                                    toCCAddresses.add(ac.CC_Address_7__c);
                            }
                            
                            if(ac.CC_Address_8__c != null){
                                if(!toCCAddresses.contains(ac.CC_Address_8__c)) 
                                    toCCAddresses.add(ac.CC_Address_8__c);
                            }
                            
                            if(ac.CC_Address_9__c != null){
                                if(!toCCAddresses.contains(ac.CC_Address_9__c)) 
                                    toCCAddresses.add(ac.CC_Address_9__c);
                            }
                            
                            if(ac.CC_Address_10__c != null){
                                if(!toCCAddresses.contains(ac.CC_Address_10__c)) 
                                    toCCAddresses.add(ac.CC_Address_10__c);
                            }
                            string[] toAddresses;
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            
                            
                            //String tempExcel;
                            //tempExcel = '<style>table{border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #D5D5D5}td,th{padding:5px;border:1px solid #D5D5D5}';
                            //tempExcel += 'th{font-size:25px;font-weight:400;text-align:center;background-color:#D5D5D5;color:#fff}td{font-size:11px;font-weight:100;text-align:left}</style>';
                            
                            //tempExcel += '<table border="1px"><tr><th>Case Number</th><th>Consumer Name</th><th>Member Name</th><th>Account Type</th><th>Account No</th><th>Dispute Details</th><th>Displayed Details</th><th>Correct Details</th><th>Enquiry User Id</th><th>Enquiry Loan Amount</th><th>Dispute Raised Date</th><th>Open Ageing with Bank</th><th>Dispute Accepted / Rejected</th> <th>Dispute Rejected Reason</th><th>Name of OLM File</th><th>Date of upload of OLM File</th><th>CinpID where the OLM file is uploaded</th></tr>';
                            
                            String tempExcelDemog;
                            tempExcelDemog = '<style>table{border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #D5D5D5}td,th{padding:5px;border:1px solid #D5D5D5}';
                            tempExcelDemog += 'th{font-size:25px;font-weight:400;text-align:center;background-color:#D5D5D5;color:#fff}td{font-size:11px;font-weight:100;text-align:left}</style>';
                            String excelData = '<?xml version="1.0" encoding="UTF-8"?>' +
                                '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" ' +
                                'xmlns:o="urn:schemas-microsoft-com:office:office" ' +
                                'xmlns:x="urn:schemas-microsoft-com:office:excel" ' +
                                'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">' +
                                '<Worksheet ss:Name="Cases"><Table>';
                            
                            tempExcelDemog += '<table border="1px"><tr><th>Case Number</th><th>Email Received Date</th><th>Consumer Name</th><th>Date of Birth</th><th>Address</th><th>Contact no</th><th>Email ID</th><th>PAN Detail</th><th>Member Name</th> <th>Account Type</th> <th>Account No</th> <th>Dispute Details</th><th>Enquiry User Id</th><th>Enquiry Loan Amount</th><th>Dispute Raised Date</th><th>Dispute Received Date</th><th>Open Ageing with Bank</th><th>Dispute Accepted / Rejected</th> <th>Dispute Rejected Reason</th><th>Name of OLM File</th><th>Date of upload of OLM File</th><th>CinpID where the OLM file is uploaded</th></tr>';
                            excelData += '<Row>' +
                                wrapCell('Case Number') +
                                wrapCell('Email Received Date') +
                                wrapCell('Consumer Name') +
                                wrapCell('Date of Birth') +
                                wrapCell('Address') +
                                wrapCell('Contact no') +
                                wrapCell('Email ID') +
                                wrapCell('PAN Detail') +
                                wrapCell('Member Name') +
                                wrapCell('Account Type') +
                                wrapCell('Account No') +
                                wrapCell('Dispute Details') +
                                wrapCell('Enquiry User Id') +
                                wrapCell('Enquiry Loan Amount') +
                                wrapCell('Dispute Raised Date') +
                                wrapCell('Dispute Received Date') +
                                wrapCell('Date Reported') +
                                wrapCell('Open Ageing with Bank') +
                                wrapCell('Dispute Accepted / Rejected') +
                                wrapCell('Dispute Rejected Reason') +
                                wrapCell('Name of OLM File') +
                                wrapCell('Date of upload of OLM File') +
                                wrapCell('CinpID where the OLM file is uploaded') +
                                '</Row>';
                            
                            
                            
                            
                            string emailbody ='Dear Team,' +
                                '<p>As per RBI the financial institutions have to respond within 21 days and CIC’s have a timeline of 9 days for resolution of the Complaint. Please note the' +
                                ' consumer is looking for a rectified report so that credit could be availed. We are awaiting a response from you / your team for the attached list of cases. <br /><br />'+
                                'To monitor the response timelines, you will find ‘Dispute raised date’ (the date when the dispute was first sent to you) and ‘Member TAT’ '+
                                '(today - date raised to you) in the attached file.<br /></p>'; 
                            
                            mail.setUseSignature(false);
                            mail.setToAddresses(emailList);
                            // mail.setToAddresses(new List<String> {'shanmugarajan@finessedirect.com', 'balram@finessedirect.com', 'Rakesh.Jaiswar@experian.com', 'neha.mandaogade@experian.com'});
                            
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
                                
                                
                                caseRow.add('<tr><td style="text-Align:center">'+month+'\''+strs.substringAfter(':')+'</td><td style="text-Align:center">'+strlist.get(strs)+'</td></tr>');
                                totalsub +=integer.valueOf(strlist.get(strs));
                            }
                            
                            emailBody += String.join(caseRow,' ');
                            emailBody += '<tr><td style="text-Align:center"><b>Total Cases</b></td><td style="text-Align:center"><b>'+totalsub+'</b></td></tr>';
                            emailBody += '</table>'; 

                            /********** NEW TABLE ADDED **********/

                            // Create the bucket map
                            Map<String, Integer> bucketCount = new Map<String, Integer>{
                                '0-5 Days' => 0,
                                '6-10 Days' => 0,
                                '11-15 Days' => 0,
                                '16-20 Days' => 0,
                                '21-30 Days' => 0,
                                'More than 30 Days' => 0
                            };

                            // Populate counts based on Case field Open_Dispute_Days_TAT__c
                            if (CaseMapRow.containsKey(ac.Id)) {
                                for (Case cs : CaseMapRow.get(ac.Id)) {
                                    String bucket = cs.Open_Dispute_Days_TAT__c;
                                    if (String.isNotBlank(bucket) && bucketCount.containsKey(bucket)) {
                                        bucketCount.put(bucket, bucketCount.get(bucket) + 1);
                                    }
                                }
                            }

                            emailBody += '<br/><br/><table border="1" style="border-collapse:collapse;width:50%;">' +
                                '<tr>' +
                                    '<th style="color:#000000;background-color:#ADD8E6;">Bucket</th>' +
                                    '<th style="color:#000000;background-color:#ADD8E6;">No of Cases</th>' +
                                '</tr>' +
                                '<tr><td style="text-align:center">0-5 Days</td><td style="text-align:center">' + bucketCount.get('0-5 Days') + '</td></tr>' +
                                '<tr><td style="text-align:center">6-10 Days</td><td style="text-align:center">' + bucketCount.get('6-10 Days') + '</td></tr>' +
                                '<tr><td style="text-align:center">11-15 Days</td><td style="text-align:center">' + bucketCount.get('11-15 Days') + '</td></tr>' +
                                '<tr><td style="text-align:center">16-20 Days</td><td style="text-align:center">' + bucketCount.get('16-20 Days') + '</td></tr>' +
                                '<tr><td style="text-align:center">21-30 Days</td><td style="text-align:center">' + bucketCount.get('21-30 Days') + '</td></tr>' +
                                '<tr><td style="text-align:center">More than 30 Days</td><td style="text-align:center">' + bucketCount.get('More than 30 Days') + '</td></tr>' +
                            '</table>';

                            /********** NEW TABLE ADDED **********/

                            
                            List<String> caseexcelRow = new List<String>();
                            List<String> caseexcelRowDemog = new List<String>();
                            if(CaseMapRow.containsKey(ac.Id)){
                                for(Case cs : CaseMapRow.get(ac.Id)) {
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
                                        
                                    }
                                    date dt1 =cs.Name_of_Consumer__r.BirthDate; 
                                    string DOB = String.valueof(dt1);
                                    
                                    String DOB2;
                                    
                                    if(test.isRunningTest()){
                                        DOB = '02/01/2021'; 
                                        DOB2 = '02/01/2021';
                                    }else{
                                        date dt2 =cs.Date_of_the_email_received__c;
                                        if(string.isNotBlank(string.valueOf(dt2))){
                                            DOB2 = String.valueof(dt2);
                                        }else{
                                            DOB2 = '-';
                                        }
                                    }
                                    string Displayed_Address_1 = cs.Displayed_Address__c != null ? cs.Displayed_Address__c : cs.Displayed_Address_1_v1__c;
                                    caseexcelRowDemog.add('<tr><td style="text-align:center">'+cs.CaseNumber+'</td><td style="text-align:center">'+DOB2+'</td><td style="text-align:center">'+cs.Name_of_Consumer__r.Name+'</td> <td style="text-align:center">'+DOB+'</td> <td style="text-align:center">'+Displayed_Address_1+'</td> <td style="text-align:center">'+cs.Name_of_Consumer__r.Phone+'</td>  <td style="text-align:center">'+cs.Name_of_Consumer__r.Email+'</td>  <td style="text-align:center">'+cs.Name_of_Consumer__r.Pan_no__c+'</td>  <td style="text-align:center">'+cs.Account.Name+'</td><td style="text-align:center">'+cs.Displayed_Account_Type__c+'</td><td style="text-align:center">'+cs.Displayed_Account_number__c+'</td> <td style="text-align:center">'+cs.Dispute_Detail__c+'</td><td style="text-align:center">'+cs.Enquiry_User_Id__c+'</td><td style="text-align:center">'+cs.Enquiry_Loan_Amount__c+'</td><td style="text-align:center">'+cs.Dispute_Raised_Date__c+'</td><td style="text-align:center">'+cs.Dispute_Raised_Date__c+'</td><td style="text-align:center">'+cs.Open_Ageing_with_Bank__c+'</td><td></td><td></td><td></td><td></td><td></td></tr>');
                                    
                                    excelData += '<Row>' +
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
                                        wrapCell(formatDate(cs.Dispute_Raised_Date__c)) +  // Format Date if needed
                                        wrapCell(formatDate(cs.Dispute_Raised_Date__c)) +  // Format Date if needed
                                        wrapCell(formatDate(cs.Account_Date_Reported__c)) +
                                        wrapCell(string.valueOf(cs.Open_Ageing_with_Bank__c)) +
                                        wrapCell('') +  // Empty cell for additional columns
                                        wrapCell('') +  // Empty cell for additional columns
                                        wrapCell('') +  // Empty cell for additional columns
                                        wrapCell('') +  // Empty cell for additional columns
                                        wrapCell('') +  
                                        '</Row>';
                                    /*  if(cs.Sub_Type_Lookup__r.Name =='Account ownership issue' || cs.Sub_Type_Lookup__r.Name ==
'Demographic Details' || cs.Sub_Type_Lookup__r.Name =='Enquiry Ownership Issue'){  
date dt1 =cs.Name_of_Consumer__r.BirthDate; 
string DOB = String.valueof(dt1);
string Displayed_Address_1 = cs.Displayed_Address__c != null ? cs.Displayed_Address__c : cs.Displayed_Address_1_v1__c;
caseexcelRowDemog.add('<tr><td style="text-align:center">'+cs.CaseNumber+'</td><td style="text-align:center">'+cs.Name_of_Consumer__r.Name+'</td> <td style="text-align:center">'+DOB+'</td> <td style="text-align:center">'+Displayed_Address_1+'</td> <td style="text-align:center">'+cs.Name_of_Consumer__r.Phone+'</td>  <td style="text-align:center">'+cs.Name_of_Consumer__r.Email+'</td>  <td style="text-align:center">'+cs.Name_of_Consumer__r.Pan_no__c+'</td>  <td style="text-align:center">'+cs.Account.Name+'</td><td style="text-align:center">'+cs.Displayed_Account_Type__c+'</td><td style="text-align:center">'+cs.Displayed_Account_number__c+'</td> <td style="text-align:center">'+cs.Dispute_Detail__c+'</td><td style="text-align:center">'+cs.Enquiry_User_Id__c+'</td><td style="text-align:center">'+cs.Enquiry_Loan_Amount__c+'</td><td style="text-align:center">'+cs.Dispute_Raised_Date__c+'</td><td style="text-align:center">'+cs.Open_Ageing_with_Bank__c+'</td><td></td><td></td><td></td><td></td><td></td></tr>');
}else if(cs.Sub_Type_Lookup__r.Name !='Account ownership issue' || cs.Sub_Type_Lookup__r.Name !='Demographic Details'
|| cs.Sub_Type_Lookup__r.Name !='Enquiry Ownership Issue'){

//system.debug('Up_Parent_CaseList ===> 1'+Up_Parent_CaseList.size());
caseexcelRow.add('<tr><td style="text-align:center">'+cs.CaseNumber+'</td><td style="text-align:center">'+cs.Name_of_Consumer__r.Name+'</td> <td style="text-align:center">'+cs.Account.Name+'</td> <td style="text-align:center">'+cs.Displayed_Account_Type__c+'</td> <td style="text-align:center">'+cs.Displayed_Account_number__c+'</td>  <td style="text-align:center">'+cs.Dispute_Detail__c+'</td>  <td style="text-align:center">'+cs.Displayed_Details__c+'</td>  <td style="text-align:center">'+cs.Correct_Details__c+'</td><td style="text-align:center">'+cs.Enquiry_User_Id__c+'</td><td style="text-align:center">'+cs.Enquiry_Loan_Amount__c+'</td><td style="text-align:center">'+cs.Dispute_Raised_Date__c+'</td><td style="text-align:center">'+cs.Open_Ageing_with_Bank__c+'</td><td></td><td></td><td></td><td></td><td></td></tr>');
}*/        
                                }
                            }
                            
                            
                            /*if(caseexcelRow.size()> 0){
string temp ;
string tempdata = '';
temp += String.join(caseexcelRow,' ');
tempdata +=temp.replace('null','');
tempExcel +=tempdata.replace('00:00:00','');
tempExcel +='</table>';

Messaging.EmailFileAttachment emcc = new Messaging.EmailFileAttachment();
emcc.setFileName('Cases without Demographics Details.xls');
b = blob.valueOf(tempExcel);
emcc.setBody(b);
emcclist.add(emcc);
}*/
                            
                            if(caseexcelRowDemog.size()> 0){
                                //string tempDemog ;
                                //string tempdataDemog = '';
                                //tempDemog += String.join(caseexcelRowDemog,' ');
                                //tempdataDemog +=tempDemog.replace('null','');
                                //tempExcelDemog +=tempdataDemog.replace('00:00:00','');
                                //tempExcelDemog +='</table>';
                                excelData += '</Table></Worksheet></Workbook>';
                                
                                Messaging.EmailFileAttachment emcc1 = new Messaging.EmailFileAttachment();
                                emcc1.setFileName('Cases Details.xls');
                                //b1 = blob.valueOf(tempExcelDemog);
                                b1 = blob.valueOf(excelData);
                                //emcc1.setBody(blob.valueOf(tempExcelDemog));
                                emcc1.setBody(blob.valueOf(excelData));
                                emcclist.add(emcc1);
                            }
                            
                            
                            if ( owea.size() > 0 ) {
                                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                            } 
                            
                            
                            
                            
                            
                            emailbody += 
                                '<p>Kindly upload the file on the SFTP site <u><a href="https://data.experian.in" target="_blank">https://data.experian.in</a> </u> . If we have not addressed this to the right team, please help us with the right contacts '+
                                'within your organisation for this. Please treat this with high priority.</p>'+
                                '<p>Please feel free to contact us for any further queries.<br/></p>' +
                                '<p>Regards,</p>' +
                                'Consumer Support Team <br/ >' +
                                'Experian Credit Information Company of India Private Limited <br />'+
                                '<u><a href="www.experian.in" target="_blank">www.experian.in</a> </u>';
                            mail.htmlbody = emailbody + '<br /> ';
                            mail.subject='Open/Resolved Disputes Reminder From April 26, 2024 ('+ac.Name+')'+ '[ '+ threadId +' ]';
                            //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {emcc});
                            
                            mail.setFileAttachments(emcclist);
                            if(toCCAddresses.size() > 0)
                                mail.setCCAddresses(toCCAddresses);
                            
                            system.debug('mail'+mail);
                            allMails.add(mail);
                            system.debug('mail'+allMails.size());
                            
                            //EmailMessage em=new EmailMessage();
                            //em.Subject='List of Open Cases' + '[ '+ threadId +' ]';
                            em.subject = 'Open/Resolved Disputes Reminder From April 26, 2024 ('+ac.Name+')'+ '[ '+ threadId +' ]';
                            em.RelatedToId=case_parentId;  
                            em.ToAddress = string.join(emailList,',');
                            if(toCCAddresses.size() > 0)
                                em.CcAddress = string.join(toCCAddresses,',');
                            em.MessageDate=system.now();
                            em.Incoming=false;
                            em.Email_Body__c =EmailBody;
                            em.Status='3';
                            em.FromAddress='disputeresolution@experian.com';
                            em.FromName='Dispute Resolution';
                            //mail_Message.add(em);
                            
                            
                            
                        }
                        //system.debug('call handle All job completion'+allMails);
                        //List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
                        List<API_LOG__c> apliLogList = new List<API_LOG__c>();
                        try{
                            system.debug('Mail size'+allMails.size());
                            List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
                            
                            for(Messaging.SendEmailResult result: results){
                                if(result.isSuccess()){
                                    insert em;
                                    
                                    /* if(b !=null){
ContentVersion cv = new ContentVersion();
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
*/
                                    if(b1 !=null){
                                        ContentVersion cv = new ContentVersion();
                                        //blob b1 = blob.valueOf(tempExcelDemog);
                                        cv.VersionData = b1;
                                        //cv.Title = 'Cases with Demographics Details.xls';
                                        //cv.PathOnClient = 'Cases with Demographics Details.xls';
                                        cv.Title = 'Cases Details.xls';
                                        cv.PathOnClient = 'Cases Details.xls';
                                        
                                        insert cv;
                                        
                                        
                                        //Link the File to Parent Record
                                        ContentDocumentLink cdl = new ContentDocumentLink();
                                        cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
                                        cdl.LinkedEntityId = em.Id;
                                        cdl.ShareType = 'V';
                                        insert cdl;
                                    }

                                    if(compBlob != null){
                                            ContentVersion cv2 = new ContentVersion();
                                            cv2.VersionData = compBlob;
                                            cv2.Title = compFileName;
                                            cv2.PathOnClient = compFileName;
                                            insert cv2;

                                            ContentDocumentLink cdl2 = new ContentDocumentLink();
                                            cdl2.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv2.Id].ContentDocumentId;
                                            cdl2.LinkedEntityId = em.Id;
                                            cdl2.ShareType = 'V';
                                            insert cdl2;
                                        }

                                    Integer index = results.indexOf(result);
                                    Id accId = accountOrder[index];

                                    if(compUpdateMap.containsKey(accId)){
                                        List<Compensation_Child_Cases__c> updates = new List<Compensation_Child_Cases__c>();

                                        for(Compensation_Child_Cases__c rec : compUpdateMap.get(accId)){
                                            rec.Compensation_Email_Sent_Date__c = Date.today();
                                            updates.add(rec);
                                        }

                                        if(!updates.isEmpty()){
                                            update updates;
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        catch(exception e){
                            API_LOG__c ap =new API_LOG__c();
                            ap.Request_Source__c='Case Reminder Email Failed of Account From April 26, 2024 '+accountName;
                            ap.Exception_Description__c = e.getMessage();
                            apliLogList.add(ap);   
                        } 
                        
                        if(apliLogList.size() > 0){
                            insert apliLogList;
                        }
                        //system.debug('result'+results);
                    }
                    
                }
            }
            catch(Exception e){
                System.debug('Exception in queueable jobs chain ==> '+e.getLineNumber()+' --'+e.getMessage());
                //Handle your relevant custom exception handling and monitoring                
            }
            
            QueableForSendEmail_Dte handler;
            if(String.isNotBlank(this.finallyHandlerName)){
                Type classType = Type.forName(this.finallyHandlerName);
                handler = (QueableForSendEmail_Dte)classType.newInstance();                
            }            
            if(success) {
                if(this.successCount == null){
                    this.successCount = processedRecords;
                } else {
                    this.successCount += processedRecords;
                }
                if(handler != null){
                    QueableForSendEmail_Dte.handleSingleBatchCompletion(this.parentId, this.successCount);
                }
            }
            
            Integer nextBatch = this.currentBatch + 1;
            system.debug(this.records.keyset());
            system.debug(this.currentBatch);
            system.debug(nextBatch);
            if(this.records.containsKey(nextBatch) && Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()){
                //Chain jobs
                System.enqueueJob(new QueableForSendEmail_Dte(this.records, this.action, this.batchSize, nextBatch,this.successCount));
            } else/* if(handler != null)*/{
                QueableForSendEmail_Dte.handleAllJobsCompletion();
                //Invoke the finally callback
                /* handler.handleAllJobsCompletion(this.parentId, this.successCount);
{
// List<Messaging.sendEmailResult> results = Messaging.sendEmail(allMails);
}*/
            }
        }
    }
    
    private Map<Integer, List<Sobject>> batchOutDmls(List<Account> recordsList, Integer batchSize){
        Map<Integer, List<Account>> batchMap = new Map<Integer, List<Account>>();
        if(batchSize <= 10000){
            Integer batchCurrSize = 0;
            Integer batchNumber = 1;
            List<Sobject> singleBatch = new List<Sobject>();    
            for (Integer i = 0; i < recordsList.size(); i++){
                if(batchCurrSize == batchSize){
                    batchMap.put(batchNumber, singleBatch);
                    singleBatch = new List<Sobject>();            
                    batchNumber++;
                    batchCurrSize = 0;
                }
                singleBatch.add(recordsList[i]);
                batchCurrSize++;
            }
            if(!singleBatch.isEmpty()){
                batchMap.put(batchNumber, singleBatch);
            } 
        } else {
            //throw new CustomException('BatchSize cannot be more than 10k');
        }
        return batchMap;
    }
    
    public static void handleAllJobsCompletion(){
        system.debug('email Send Done. COngratulation !');
        
        
    }
    public static void handleSingleBatchCompletion(Id parentId, Integer successCount){
        
    }
    
    
    private String wrapCell(String value) {
        if (value == null) value = '';
        return '<Cell><Data ss:Type="String">' + String.escapeSingleQuotes(value) + '</Data></Cell>';
    }
    
    // Utility: Format Date values
    private String formatDate(Datetime dt) {
        return (dt != null) ? dt.format() : '';
    }
    
    
}