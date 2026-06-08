global class AccountExportSchedule implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        // Query all accounts where Bureau_Member_Id__c is NOT NULL
        List<Account> accountList = [ 
            SELECT Bureau_Member_Id__c, Name, Sector__c,
            DQR_DQI_Email_1__c, DQR_DQI_Email_2__c, DQR_DQI_Email_3__c, 
            DQR_DQI_Email_4__c, DQR_DQI_Email_5__c, DQR_DQI_Email_6__c, 
            DQR_DQI_Email_7__c, DQR_DQI_Email_8__c, DQR_DQI_Email_9__c, 
            DQR_DQI_Email_10__c, DQR_DQI_Email_11__c, DQR_DQI_Email_12__c, 
            DQR_DQI_Email_13__c, DQR_DQI_Email_14__c, DQR_DQI_Email_15__c, 
            DQR_DQI_Email_16__c, DQR_DQI_Email_17__c, DQR_DQI_Email_18__c, 
            DQR_DQI_Email_19__c, DQR_DQI_Email_20__c, DQR_DQI_Email_21__c, 
            DQR_DQI_Email_22__c, DQR_DQI_Email_23__c, DQR_DQI_Email_24__c, 
            DQR_DQI_Email_25__c
            FROM Account
            WHERE Bureau_Member_Id__c != NULL 
            ORDER BY Name
        ];
        
        if (accountList.isEmpty()) {
            System.debug('No accounts found. Skipping email.');
            return;
        }
        
        // Create CSV Content
        List<String> csvRows = new List<String>();
        csvRows.add('BMID,BMNAME,SECTOR,BMEMAILS,CATEGORY'); // Updated CSV Header
        
        for (Account acc : accountList) {
            csvRows.add(
                wrapCSVField(acc.Bureau_Member_Id__c) + ',' +
                wrapCSVField(acc.Name) + ',' +
                wrapCSVField(acc.Sector__c) + ',' +  // Added Sector__c
                collectEmails(acc) + ',' +
                '"DQR/DQI"' // Hardcoded CATEGORY column
            );
        }
        
        // Convert to Blob & Send Email
        Blob csvBlob = Blob.valueOf(String.join(csvRows, '\n'));
        String formattedDate = System.today().year() + '-' + System.today().month() + '-' + System.today().day(); // Fixed Date Formatting
        sendEmail(csvBlob, 'DQR_DQI_Data_Export_' +  formattedDate + '.csv');
    }
    
    // Utility: Handle null values for CSV formatting
    private String wrapCSVField(String value) {
        if (value == null) return '""'; 
        value = value.replace('"', '""'); // Escape quotes
        return '"' + value + '"'; // Wrap field in quotes
    }
    
    // Utility: Collect Emails (DQR_DQI_Email_1__c to DQR_DQI_Email_25__c)
    private String collectEmails(Account acc) {
        List<String> emails = new List<String>();
        
        for (Integer i = 1; i <= 25; i++) {
            String emailField = (String) acc.get('DQR_DQI_Email_' + i + '__c');
            if (emailField != null) emails.add(emailField);
        }
        
        return '"' + String.join(emails, ';') + '"'; // Emails separated by semicolon
    }
    
    // Send email with the CSV attachment using Org-Wide Email Address
    private void sendEmail(Blob fileBlob, String fileName) {
        OrgWideEmailAddress[] owea = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'customer.support@in.experian.com' LIMIT 1];
        
        if (owea.isEmpty()) {
            System.debug('OrgWideEmailAddress not found. Email not sent.');
            return;
        }
        String formattedDate = System.today().year() + '-' + System.today().month() + '-' + System.today().day(); // Fixed Date Formatting
        
        // Use Custom Label for email addresses
        String[] toAddresses = Label.Account_Export_Email_To.split(',');
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject('DQR/DQI Data Export - ' + formattedDate);
        mail.setPlainTextBody('Attached is the daily DQR/DQI Data export file.');
        mail.setOrgWideEmailAddressId(owea[0].Id); // Set org-wide email address
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFilename(fileName);
        attachment.setBody(fileBlob);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
}