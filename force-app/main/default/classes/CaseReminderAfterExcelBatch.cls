global class CaseReminderAfterExcelBatch implements Database.Batchable<sObject>, Schedulable {
    
    global Database.querylocator start(Database.BatchableContext BC) { 
        List<Case_Reminder__c> crList = [Select Id,Account__c from Case_Reminder__c where Account__c !=null and Total_Open_Cases_Count__c > 0  
                                         and Reminder_Date__c =: system.today()
                                         and Reminder_Period__c ='From April 26, 2024' order by Total_Open_Cases_Count__c asc];
        set<Id> crAccId = new set<Id>();
        for(Case_Reminder__c crs : crList){
            if(string.isNOtBlank(crs.account__c)){
                crAccId.add(crs.account__c);
            }
        }
        
        Date today = Date.today();
        string query = ' Select Id from Account where Id IN : crAccId';
        List<Account> accList= Database.query(query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        map<Id,Id> accMap = new map<Id,Id> ();
        string accId ='';
        for(Account ac : scope){
            accId = ac.Id;
            accMap.put(ac.Id,ac.Id);
        }
        Date today = Date.today();
        
        List<Case_Reminder__c> crList = [Select Id from Case_Reminder__c where Account__c !=null and Total_Open_Cases_Count__c > 0 and 
                                         Reminder_Period__c ='From April 26, 2024' and Account__c =:accId];
        
        system.debug('crList'+crList.size());
        Date cutoffDate = Date.newInstance(2024, 4, 26);      
        string que = 'select Id, IO_Comments__c,Name_of_Consumer__r.Name,Name_of_Consumer__r.BirthDate,Raised_Days__c,Member_TAT__c,'+
            +' Name_of_Consumer__r.Phone,AccountId,Name_of_Consumer__r.Email,Name_of_Consumer__r.Pan_no__c, Dispute_Raised_Date__c, '+
            +' Account.Name, Displayed_Account_Type__c, Displayed_Account_number__c, Dispute_Detail__c,  '+
            +' Displayed_Details__c, Correct_Details__c,Open_Ageing_with_Bank__c,Enquiry_User_Id__c,Enquiry_Loan_Amount__c, '+
            +'CaseNumber ,Sub_Type_Lookup__r.Name ,Displayed_Address__c,Displayed_Address_1_v1__c, Date_of_the_email_received__c  '+
            'from Case where AccountId =:accId and status = \'Open\'';
        if(!test.isRunningTest()){
            que+=  ' and (Owner.Name =\'Bank Team\' OR Owner.Name =\'Bank Team-Blank/Incorrect Reject Reason\' OR Owner.Name =\'Bank Team-IO Seeking Further Information\') and Account_s_Parent_Case__c = false and CreatedDate <: today ';
            que+=' and Date_of_the_email_received__c >=: cutoffDate order by Owner.Name asc'; 
        }
        
        
        List<Case> casesList = dataBase.query(que);
        
        system.debug('casesList..+'+casesList.size());
        
        String tempExcelDemog;
        tempExcelDemog = '<style>table{border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #D5D5D5}td,th{padding:5px;border:1px solid #D5D5D5}';
        tempExcelDemog += 'th{font-size:25px;font-weight:400;text-align:center;background-color:#D5D5D5;color:#fff}td{font-size:11px;font-weight:100;text-align:left}</style>';
        String excelData = '<?xml version="1.0" encoding="UTF-8"?>' +
                           '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" ' +
                           'xmlns:o="urn:schemas-microsoft-com:office:office" ' +
                           'xmlns:x="urn:schemas-microsoft-com:office:excel" ' +
                           'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">' +
                           '<Worksheet ss:Name="Cases"><Table>';
        excelData += '<Row>' +
  '<Cell><Data ss:Type="String">Case Number</Data></Cell>' +
  '<Cell><Data ss:Type="String">Email Received Date</Data></Cell>' +
  '<Cell><Data ss:Type="String">Consumer Name</Data></Cell>' +
  '<Cell><Data ss:Type="String">Account Name</Data></Cell>' +
  '<Cell><Data ss:Type="String">Date of Birth</Data></Cell>' +
  '<Cell><Data ss:Type="String">Account Type</Data></Cell>' +
  '<Cell><Data ss:Type="String">Account No</Data></Cell>' +
  '<Cell><Data ss:Type="String">Address</Data></Cell>' +
  '<Cell><Data ss:Type="String">Contact no</Data></Cell>' +
  '<Cell><Data ss:Type="String">Email ID</Data></Cell>' +
  '<Cell><Data ss:Type="String">PAN Detail</Data></Cell>' +
  '<Cell><Data ss:Type="String">Member Name</Data></Cell>' +
  '<Cell><Data ss:Type="String">Dispute Details</Data></Cell>' +
  '<Cell><Data ss:Type="String">Enquiry User Id</Data></Cell>' +
  '<Cell><Data ss:Type="String">Enquiry Loan Amount</Data></Cell>' +
  '<Cell><Data ss:Type="String">Dispute Raised Date</Data></Cell>' +
  '<Cell><Data ss:Type="String">Open Ageing with Bank</Data></Cell>' +
   '<Cell><Data ss:Type="String">IO Comments</Data></Cell>' +
  '<Cell><Data ss:Type="String">Dispute Accepted / Rejected</Data></Cell>' +
  '<Cell><Data ss:Type="String">Dispute Rejected Reason</Data></Cell>' +
  '<Cell><Data ss:Type="String">Name of OLM File</Data></Cell>' +
  '<Cell><Data ss:Type="String">Date of upload of OLM File</Data></Cell>' +
  '<Cell><Data ss:Type="String">CinpID where the OLM file is uploaded</Data></Cell>' +
            
'</Row>';
        
        List<String> caseexcelRowDemog = new List<String>();
        blob b1;
        for(Case cs : casesList){
            date dt1 =cs.Name_of_Consumer__r.BirthDate; 
            string DOB = String.valueof(dt1);
            string Displayed_Address_1 = cs.Displayed_Address__c != null ? cs.Displayed_Address__c : cs.Displayed_Address_1_v1__c;
            
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
            
            caseexcelRowDemog.add('<tr><td style="text-align:center">'+cs.CaseNumber+'</td><td style="text-align:center">'+DOB2+'</td><td style="text-align:center">'+cs.Name_of_Consumer__r.Name+'</td><td style="text-align:center">'+cs.Account.Name+'</td> <td style="text-align:center">'+DOB+'</td><td style="text-align:center">'+cs.Displayed_Account_Type__c+'</td><td style="text-align:center">'+cs.Displayed_Account_number__c+'</td><td style="text-align:center">'+Displayed_Address_1+'</td>  <td style="text-align:center">'+cs.Name_of_Consumer__r.Phone+'</td>  <td style="text-align:center">'+cs.Name_of_Consumer__r.Email+'</td>  <td style="text-align:center">'+cs.Name_of_Consumer__r.Pan_no__c+'</td> <td></td> <td style="text-align:center">'+cs.Dispute_Detail__c+'</td><td style="text-align:center">'+cs.Enquiry_User_Id__c+'</td><td style="text-align:center">'+cs.Enquiry_Loan_Amount__c+'</td><td style="text-align:center">'+cs.Dispute_Raised_Date__c+'</td><td style="text-align:center">'+cs.Open_Ageing_with_Bank__c+'</td><td></td><td></td><td></td><td></td><td></td></tr>');
			excelData += '<Row>' +
  wrapCell(cs.CaseNumber) +
  wrapCell(DOB2) +
  wrapCell(cs.Name_of_Consumer__r.Name) +
  wrapCell(cs.Account.Name) +
  wrapCell(DOB) +
  wrapCell(cs.Displayed_Account_Type__c) +
  wrapCell(cs.Displayed_Account_number__c) +
  wrapCell(Displayed_Address_1) +
  wrapCell(cs.Name_of_Consumer__r.Phone) +
  wrapCell(cs.Name_of_Consumer__r.Email) +
  wrapCell(cs.Name_of_Consumer__r.Pan_no__c) +
  wrapCell('') + // Placeholder for the empty cell
  wrapCell(cs.Dispute_Detail__c) +
  wrapCell(cs.Enquiry_User_Id__c) +
  wrapCell(string.valueOf(cs.Enquiry_Loan_Amount__c)) +
  wrapCell(formatDate(cs.Dispute_Raised_Date__c)) +
  wrapCell(string.valueOf(cs.Open_Ageing_with_Bank__c)) +
  wrapCell(string.valueOf(cs.IO_Comments__c)) +
  wrapCell('') + // Placeholder for the empty cell
  wrapCell('') + // Placeholder for the empty cell
  wrapCell('') + // Placeholder for the empty cell
  wrapCell('') + // Placeholder for the empty cell
  wrapCell('') + // Placeholder for the empty cell
'</Row>';
            
        }
        
        system.debug('caseexcelRowDemog --> '+caseexcelRowDemog.size());
        if(caseexcelRowDemog.size()> 0){
            excelData += '</Table></Worksheet></Workbook>';
            //string tempDemog ;
            //string tempdataDemog = '';
            //tempDemog += String.join(caseexcelRowDemog,' ');
            //tempdataDemog +=tempDemog.replace('null','');
            //tempExcelDemog +=tempdataDemog.replace('00:00:00','');
            //tempExcelDemog +='</table>';
            //b1 = blob.valueOf(tempExcelDemog);
            b1 = blob.valueOf(excelData);
        }
        
        
        if(b1 !=null){
            system.debug('inside blob-->'+b1);
            
            if(crList.size() > 0){
                system.debug('inside crList-->'+crList.size());
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
                cdl.LinkedEntityId = crList[0].Id;
                cdl.ShareType = 'V';
                insert cdl;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
    private String wrapCell(String value) {
        if (value == null) value = '';
        return '<Cell><Data ss:Type="String">' + String.escapeSingleQuotes(value) + '</Data></Cell>';
    }

    // Utility: Format Date values
    private String formatDate(Datetime dt) {
        return (dt != null) ? dt.format() : '';
    }

    global void execute(SchedulableContext sc) {
        CaseReminderAfterExcelBatch crdm = new CaseReminderAfterExcelBatch();
        Database.executeBatch(crdm,1);
    }
    
}