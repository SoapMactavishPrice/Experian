global class CompensationResolvedBatch implements Database.Batchable<sObject>, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext BC) {

        Set<Id> accIds = new Set<Id>();

        for (Compensation_Child_Cases__c c : [
            SELECT Liable_Party_Account_Id__c
            FROM Compensation_Child_Cases__c
            WHERE Compensation_Email_Sent_Date__c = null
            AND (Compensation_Opted__c = 'Yes' OR Compensation_Opted__c = 'No')
        ]) {
            if (String.isNotBlank(c.Liable_Party_Account_Id__c)) {
                try {
                    accIds.add((Id)c.Liable_Party_Account_Id__c);
                } catch (Exception e) {
                    // Skip invalid Ids
                }
            }
        }

        return Database.getQueryLocator([
            SELECT Id, Name,
                   Email_1_Dispute__c, Email_2_Dispute__c, Email_3_Dispute__c,
                   Email_4_Dispute__c, Email_5_Dispute__c, Email_6_Dispute__c,
                   Email_7_Dispute__c, Email_8_Dispute__c, Email_9_Dispute__c, Email_10_Dispute__c,
                   CC_Address_1__c, CC_Address_2__c, CC_Address_3__c, CC_Address_4__c,
                   CC_Address_5__c, CC_Address_6__c, CC_Address_7__c, CC_Address_8__c,
                   CC_Address_9__c, CC_Address_10__c
            FROM Account
            WHERE Id IN :accIds
        ]);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {

        for (Account ac : scope) {

            try {

                // -------- CHILD RECORDS --------
                List<Compensation_Child_Cases__c> childList = [
                    SELECT Id, Consumer_Name__c, Consumer_Email_ID__c, Case_Number__c,
                           Displayed_Account_number__c, Sub_Type_Name__c, Sub_Type_1_Name__c, Account_Name__c,
                           Dispute_Received_Date__c, Resolve_Date__c, Status__c,
                           Delayed_No_of_Days__c, Liable_Amount__c, Experian_Liability_Amt__c,
                           Compensation_Opted__c, Bank_Name__c, Account_Number__c,
                           IFSC_Code__c, Consumer_Name_As_per_Bank_Account__c, Compensation_Email_Sent_Date__c
                    FROM Compensation_Child_Cases__c
                    WHERE Liable_Party_Account_Id__c = :ac.Id
                    AND Compensation_Email_Sent_Date__c = null
                    AND (Compensation_Opted__c = 'Yes' OR Compensation_Opted__c = 'No')
                ];

                if (childList.isEmpty()) continue;

            // -------- EXCEL --------
            String excelData = '<?xml version="1.0" encoding="UTF-8"?>' +
                '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">' +
                '<Worksheet ss:Name="Compensation"><Table>';

            excelData += '<Row>' +
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

            for (Compensation_Child_Cases__c c : childList) {
                excelData += '<Row>' +
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

            excelData += '</Table></Worksheet></Workbook>';

            // -------- ATTACHMENTS --------
            List<Messaging.EmailFileAttachment> emcclist = new List<Messaging.EmailFileAttachment>();
            emcclist.addAll(getFilesFromStaticResource.getFiles());

            Messaging.EmailFileAttachment compAttachment = new Messaging.EmailFileAttachment();
            compAttachment.setFileName('Resolved Cases.xls');
            compAttachment.setBody(Blob.valueOf(excelData));
            compAttachment.setContentType('application/vnd.ms-excel');

            emcclist.add(compAttachment);

            // -------- THREAD ID --------
            String threadId = '';
            Case parentCase;
            try {
                parentCase = [SELECT Id FROM Case WHERE AccountId = :ac.Id AND Account_s_Parent_Case__c = true LIMIT 1];
                String orgId = UserInfo.getOrganizationId();
                threadId = '[ ref:_00D' + orgId.substring(0, 9) +
                           '._500' + String.valueOf(parentCase.Id).substring(0, 9) + ':ref ]';
            } catch (Exception e) {}

            // -------- EMAIL BODY --------
            String emailbody = 'Dear Team,' +
                '<p>As per RBI the financial institutions have to respond within 21 days and CIC’s have a timeline of 9 days for resolution of the Complaint. Please note the consumer is looking for a rectified report so that credit could be availed. We are awaiting a response from you / your team for the attached list of cases. <br /><br />' +
                'To monitor the response timelines, you will find ‘Dispute raised date’ (the date when the dispute was first sent to you) and ‘Member TAT’ (today - date raised to you) in the attached file.<br /></p>'+

                '<p>Kindly upload the file on the SFTP site <u><a href="https://data.experian.in" target="_blank">https://data.experian.in</a></u>. If we have not addressed this to the right team, please help us with the right contacts within your organisation for this. Please treat this with high priority.</p>' +
                '<p>Please feel free to contact us for any further queries.<br/></p>' +
                '<p>Regards,</p>' +
                'Consumer Support Team <br/ >' +
                'Experian Credit Information Company of India Private Limited <br />' +
                '<u><a href="www.experian.in" target="_blank">www.experian.in</a></u>';

            // -------- EMAIL --------
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setHtmlBody(emailbody + '<br />');
            mail.setSubject('Open/Resolved Disputes Reminder From April 26, 2024 (' + ac.Name + ') [ ' + threadId + ' ]');

            // TO
            List<String> toList = new List<String>{
                ac.Email_1_Dispute__c, ac.Email_2_Dispute__c, ac.Email_3_Dispute__c,
                ac.Email_4_Dispute__c, ac.Email_5_Dispute__c, ac.Email_6_Dispute__c,
                ac.Email_7_Dispute__c, ac.Email_8_Dispute__c, ac.Email_9_Dispute__c, ac.Email_10_Dispute__c
            };

            List<String> finalTo = new List<String>();
            for(String e : toList){
                if(String.isNotBlank(e)) finalTo.add(e.trim());
            }
            mail.setToAddresses(finalTo);
            //mail.setToAddresses(new List<String> {'shanmugarajan@finessedirect.com', 'balram@finessedirect.com'});

            // CC
            List<String> ccList = new List<String>{
                ac.CC_Address_1__c, ac.CC_Address_2__c, ac.CC_Address_3__c,
                ac.CC_Address_4__c, ac.CC_Address_5__c, ac.CC_Address_6__c,
                ac.CC_Address_7__c, ac.CC_Address_8__c, ac.CC_Address_9__c, ac.CC_Address_10__c
            };

            List<String> finalCC = new List<String>();
            for(String c : ccList){
                if(String.isNotBlank(c)) finalCC.add(c.trim());
            }

            if(!finalCC.isEmpty()){
                mail.setCcAddresses(finalCC);
            }

            mail.setFileAttachments(emcclist);
            
            // -------- ORG WIDE EMAIL --------
            OrgWideEmailAddress[] owea = [
                SELECT Id 
                FROM OrgWideEmailAddress 
                WHERE Address = 'disputeresolution@experian.com'
            ];
            
            if (!owea.isEmpty()) {
                mail.setOrgWideEmailAddressId(owea[0].Id);
            }
            

            Messaging.SendEmailResult[] results =
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});

            // -------- AFTER SUCCESS --------
            if(results != null && results.size() > 0 && results[0].isSuccess()){

                for(Compensation_Child_Cases__c rec : childList){
                    rec.Compensation_Email_Sent_Date__c = Date.today();
                }
                update childList;

                EmailMessage em = new EmailMessage();
                em.Subject = mail.getSubject();
                em.HtmlBody = mail.getHtmlBody();
                em.ToAddress = String.join(finalTo, ';');
                em.CcAddress = String.join(finalCC, ';');
                em.FromAddress = 'disputeresolution@experian.com';
                em.Status = '3';
                if(parentCase != null) em.RelatedToId = parentCase.Id;
                em.Member_Name__c = ac.Name;

                insert em;
                
                // -------- STORE ATTACHMENTS IN EMAILMESSAGE --------
                List<ContentVersion> cvList = new List<ContentVersion>();
                
                for (Messaging.EmailFileAttachment att : emcclist) {
                    ContentVersion cv = new ContentVersion();
                    cv.Title = att.getFileName();
                    cv.PathOnClient = att.getFileName();
                    cv.VersionData = att.getBody();
                    cvList.add(cv);
                }
                
                insert cvList;
                
                // RE-QUERY to get ContentDocumentId
                List<ContentVersion> insertedCVs = [
                    SELECT Id, ContentDocumentId
                    FROM ContentVersion
                    WHERE Id IN :cvList
                ];
                
                // LINK FILES
                List<ContentDocumentLink> links = new List<ContentDocumentLink>();
                
                for (ContentVersion cv : insertedCVs) {
                    ContentDocumentLink cdl = new ContentDocumentLink();
                    cdl.ContentDocumentId = cv.ContentDocumentId;
                    cdl.LinkedEntityId = em.Id;
                    cdl.ShareType = 'V';
                    links.add(cdl);
                }
                
                insert links;
            } else {
                    String errorMsg = 'Unknown error';
                    if (results != null && results.size() > 0 && results[0].getErrors() != null && results[0].getErrors().size() > 0) {
                        errorMsg = results[0].getErrors()[0].getMessage();
                    }

                    insert new Automation_Logs__c(
                        Batch_Class_Name__c = 'CompensationResolvedBatch',
                        Automation_Log_Description__c = 'Email failed for account: ' + ac.Name,
                        Error_Message__c = errorMsg,
                        Status__c = 'Failed'
                    );
                }
            } catch (Exception e) {

                insert new Automation_Logs__c(
                    Batch_Class_Name__c = 'CompensationResolvedBatch',
                    Automation_Log_Description__c = 'Exception for account: ' + ac.Name,
                    Error_Message__c = e.getMessage(),
                    Status__c = 'Failed'
                );
            }
        }
    }

    global void finish(Database.BatchableContext BC) {}

    public static String wrapCell(String val) {
        return '<Cell><Data ss:Type="String">' + (val == null ? '' : val) + '</Data></Cell>';
    }

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CompensationResolvedBatch(), 1);
    }
}