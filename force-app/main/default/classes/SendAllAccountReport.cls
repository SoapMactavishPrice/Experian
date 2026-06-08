public with sharing class SendAllAccountReport implements Database.Batchable<sObject>, Database.Stateful{

    // 1. HEADERS 
    public static final List<String> CSV_HEADERS = new List<String>{
        'Account Name','Account ID','Bureau Member Id','Sub Code',
        'Billing Contact Name 1','Billing Contact Phone 1','Billing Contact Email 1',
        'Billing Street','Billing City','Billing Zip/Postal Code','Billing State/Province','Billing Country',
        'Shipping Street','Shipping City','Shipping Zip/Postal Code','Shipping State/Province','Shipping Country',
        'Registered Street','Registered City','Registered State/Province','Registered Pincode','Registered Country',

        // Person/Email/Phone 1–10
        'Person Name 1','Email 1','Phone 1',
        'Person Name 2','Email 2','Phone 2',
        'Person Name 3','Email 3','Phone 3',
        'Person Name 4','Email 4','Phone 4',
        'Person Name 5','Email 5','Phone 5',
        'Person Name 6','Email 6','Phone 6',
        'Person Name 7','Email 7','Phone 7',
        'Person Name 8','Email 8','Phone 8',
        'Person Name 9','Email 9','Phone 9',
        'Person Name 10','Email 10','Phone 10',

        // Complaint Nodal Officers
        'Complaint Nodal Officer Name','Complaint Nodal Officer Designation',
        'Complaint Nodal Officer Email','Complaint Nodal Officer Phone',

        // CC Address 1–10
        'CC Address 1','CC Address 2','CC Address 3','CC Address 4','CC Address 5',
        'CC Address 6','CC Address 7','CC Address 8','CC Address 9','CC Address 10',

        // Grievances Nodal Officer
        'Grievances Nodal Officer Name','Grievances Nodal Officer Email','Grievances Nodal Officer Phone',

        // Tech Contact
        'Technology Contact Name','Technology Contact Email','Technology Contact Phone',

        // Authorized Signatory
        'Authorized Signatory Name','Authorized Signatory Email','Authorized Signatory Phone',

        // Authorized User Id
        'Authorized User Id Name','Authorized User Id Email','Authorized User Id Phone',

        // Nodal Officer
        'Nodal Officer Name','Nodal Officer Email','Nodal Officer Phone',

        // DQR/DQI Email 1–25
        'DQR/DQI Email 1','DQR/DQI Email 2','DQR/DQI Email 3','DQR/DQI Email 4','DQR/DQI Email 5',
        'DQR/DQI Email 6','DQR/DQI Email 7','DQR/DQI Email 8','DQR/DQI Email 9','DQR/DQI Email 10',
        'DQR/DQI Email 11','DQR/DQI Email 12','DQR/DQI Email 13','DQR/DQI Email 14','DQR/DQI Email 15',
        'DQR/DQI Email 16','DQR/DQI Email 17','DQR/DQI Email 18','DQR/DQI Email 19','DQR/DQI Email 20',
        'DQR/DQI Email 21','DQR/DQI Email 22','DQR/DQI Email 23','DQR/DQI Email 24','DQR/DQI Email 25',

        // Form C Level 1 (1–16)
        'Form C Level 1 Email 1','Form C Level 1 Email 2','Form C Level 1 Email 3','Form C Level 1 Email 4',
        'Form C Level 1 Email 5','Form C Level 1 Email 6','Form C Level 1 Email 7','Form C Level 1 Email 8',
        'Form C Level 1 Email 9','Form C Level 1 Email 10','Form C Level 1 Email 11','Form C Level 1 Email 12',
        'Form C Level 1 Email 13','Form C Level 1 Email 14','Form C Level 1 Email 15','Form C Level 1 Email 16',

        // Form C Level 2 (1–5)
        'Form C Level 2 Email 1','Form C Level 2 Email 2','Form C Level 2 Email 3',
        'Form C Level 2 Email 4','Form C Level 2 Email 5',

        // Form C Level 3 (1–5)
        'Form C Level 3 Email 1','Form C Level 3 Email 2','Form C Level 3 Email 3',
        'Form C Level 3 Email 4','Form C Level 3 Email 5',

        // Dispute Emails (1–15)
        'Dispute Email 1','Dispute Email 2','Dispute Email 3','Dispute Email 4','Dispute Email 5',
        'Dispute Email 6','Dispute Email 7','Dispute Email 8','Dispute Email 9','Dispute Email 10',
        'Dispute Email 11','Dispute Email 12','Dispute Email 13','Dispute Email 14','Dispute Email 15',

        // OLM Emails (1–40)
        'OLM Email 1','OLM Email 2','OLM Email 3','OLM Email 4','OLM Email 5',
        'OLM Email 6','OLM Email 7','OLM Email 8','OLM Email 9','OLM Email 10',
        'OLM Email 11','OLM Email 12','OLM Email 13','OLM Email 14','OLM Email 15',
        'OLM Email 16','OLM Email 17','OLM Email 18','OLM Email 19','OLM Email 20',
        'OLM Email 21','OLM Email 22','OLM Email 23','OLM Email 24','OLM Email 25',
        'OLM Email 26','OLM Email 27','OLM Email 28','OLM Email 29','OLM Email 30',
        'OLM Email 31','OLM Email 32','OLM Email 33','OLM Email 34','OLM Email 35',
        'OLM Email 36','OLM Email 37','OLM Email 38','OLM Email 39','OLM Email 40'
    };


    // 2. API FIELDS IN EXACT MATCHING ORDER 
    public static final List<String> FIELDS_TO_EXPORT = new List<String>{
        'Name','Id','Bureau_Member_Id__c','Sub_Code__c',
        'Billing_Contact_Name__c','Billing_Contact_Phone__c','Billing_Contact_Email__c',
        'BillingStreet','BillingCity','BillingPostalCode','BillingState','BillingCountry',
        'ShippingStreet','ShippingCity','ShippingPostalCode','ShippingState','ShippingCountry',
        'Registered_Street__c','Registered_City__c','Registered_StateProvince__c','Registered_Pincode__c','Registered_Country__c',

        'Person_Name_Dispute__c','Email_1_Dispute__c','Phone_1__c',
        'Person_Name_2__c','Email_2_Dispute__c','Phone_2__c',
        'Person_Name_3__c','Email_3_Dispute__c','Phone_3__c',
        'Person_Name_4__c','Email_4_Dispute__c','Phone_4__c',
        'Person_Name_5__c','Email_5_Dispute__c','Phone_5__c',
        'Person_Name_6__c','Email_6_Dispute__c','Phone_6__c',
        'Person_Name_7__c','Email_7_Dispute__c','Phone_7__c',
        'Person_Name_8__c','Email_8_Dispute__c','Phone_8__c',
        'Person_Name_9__c','Email_9_Dispute__c','Phone_9__c',
        'Person_Name_10__c','Email_10_Dispute__c','Phone_10__c',

        'Complaint_Nodal_Officer_Name__c',
        'Complaint_Nodal_Officer_Designation__c',
        'Complaint_Nodal_Officer_Email__c',
        'Complaint_Nodal_Officer_Phone__c',

        'CC_Address_1__c','CC_Address_2__c','CC_Address_3__c','CC_Address_4__c','CC_Address_5__c',
        'CC_Address_6__c','CC_Address_7__c','CC_Address_8__c','CC_Address_9__c','CC_Address_10__c',

        'Grievances_Nodal_Officer_Name__c',
        'Grievances_Nodal_Officer_Email__c',
        'Grievances_Nodal_Officer_Phone__c',

        'Technology_Contact_Name__c',
        'Technology_Contact_Email__c',
        'Technology_Contact_Phone__c',

        'Authorized_Signatory_Name__c',
        'Authorized_Signatory_Email__c',
        'Authorized_Signatory_Phone__c',

        'Authorized_User_Id_Name__c',
        'Authorized_User_Id_Email__c',
        'Authorized_User_Id_Phone__c',

        'Nodal_Officer_Name__c',
        'Nodal_Officer_Email__c',
        'Nodal_Officer_Phone__c',

        // DQR/DQI Email (1–25)
        'DQR_DQI_Email_1__c','DQR_DQI_Email_2__c','DQR_DQI_Email_3__c','DQR_DQI_Email_4__c','DQR_DQI_Email_5__c',
        'DQR_DQI_Email_6__c','DQR_DQI_Email_7__c','DQR_DQI_Email_8__c','DQR_DQI_Email_9__c','DQR_DQI_Email_10__c',
        'DQR_DQI_Email_11__c','DQR_DQI_Email_12__c','DQR_DQI_Email_13__c','DQR_DQI_Email_14__c','DQR_DQI_Email_15__c',
        'DQR_DQI_Email_16__c','DQR_DQI_Email_17__c','DQR_DQI_Email_18__c','DQR_DQI_Email_19__c','DQR_DQI_Email_20__c',
        'DQR_DQI_Email_21__c','DQR_DQI_Email_22__c','DQR_DQI_Email_23__c','DQR_DQI_Email_24__c','DQR_DQI_Email_25__c',

        // Form C L1
        'Form_C_Level_1_Email_1__c','Form_C_Level_1_Email_2__c','Form_C_Level_1_Email_3__c',
        'Form_C_Level_1_Email_4__c','Form_C_Level_1_Email_5__c','Form_C_Level_1_Email_6__c',
        'Form_C_Level_1_Email_7__c','Form_C_Level_1_Email_8__c','Form_C_Level_1_Email_9__c',
        'Form_C_Level_1_Email_10__c','Form_C_Level_1_Email_11__c','Form_C_Level_1_Email_12__c',
        'Form_C_Level_1_Email_13__c','Form_C_Level_1_Email_14__c','Form_C_Level_1_Email_15__c',
        'Form_C_Level_1_Email_16__c',

        // Form C L2
        'Form_C_Level_2_Email_1__c','Form_C_Level_2_Email_2__c','Form_C_Level_2_Email_3__c',
        'Form_C_Level_2_Email_4__c','Form_C_Level_2_Email_5__c',

        // Form C L3
        'Form_C_Level_3_Email_1__c','Form_C_Level_3_Email_2__c','Form_C_Level_3_Email_3__c',
        'Form_C_Level_3_Email_4__c','Form_C_Level_3_Email_5__c',

        // Dispute Emails (1–15)
        'Dispute_Email_1__c','Dispute_Email_2__c','Dispute_Email_3__c','Dispute_Email_4__c','Dispute_Email_5__c',
        'Dispute_Email_6__c','Dispute_Email_7__c','Dispute_Email_8__c','Dispute_Email_9__c','Dispute_Email_10__c',
        'Dispute_Email_11__c','Dispute_Email_12__c','Dispute_Email_13__c','Dispute_Email_14__c','Dispute_Email_15__c',

        // OLM Emails (1–40)
        'OLM_Email_1__c','OLM_Email_2__c','OLM_Email_3__c','OLM_Email_4__c','OLM_Email_5__c',
        'OLM_Email_6__c','OLM_Email_7__c','OLM_Email_8__c','OLM_Email_9__c','OLM_Email_10__c',
        'OLM_Email_11__c','OLM_Email_12__c','OLM_Email_13__c','OLM_Email_14__c','OLM_Email_15__c',
        'OLM_Email_16__c','OLM_Email_17__c','OLM_Email_18__c','OLM_Email_19__c','OLM_Email_20__c',
        'OLM_Email_21__c','OLM_Email_22__c','OLM_Email_23__c','OLM_Email_24__c','OLM_Email_25__c',
        'OLM_Email_26__c','OLM_Email_27__c','OLM_Email_28__c','OLM_Email_29__c','OLM_Email_30__c',
        'OLM_Email_31__c','OLM_Email_32__c','OLM_Email_33__c','OLM_Email_34__c','OLM_Email_35__c',
        'OLM_Email_36__c','OLM_Email_37__c','OLM_Email_38__c','OLM_Email_39__c','OLM_Email_40__c'
    };

    Blob csvBlob;

    List<String> emailRecipients;

    public SendAllAccountReport(List<String> toAddresses) {
        emailRecipients = toAddresses;

        // Write header row into Blob
        csvBlob = Blob.valueOf('"' + String.join(CSV_HEADERS, '","') + '"\n');
    }

     public Database.QueryLocator start(Database.BatchableContext bc) {
        Id rtId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Customer' LIMIT 1].Id;

        String soql = 'SELECT ' + String.join(FIELDS_TO_EXPORT, ',') + ' FROM Account WHERE RecordTypeId = \'' + rtId + '\'';
        return Database.getQueryLocator(soql);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {

        for (Account acc : scope) {
            List<String> row = new List<String>();

            for (String f : FIELDS_TO_EXPORT) {
                Object val = acc.get(f);
                String s = (val == null) ? '' : String.valueOf(val);
                s = s.replace('"','""');  // escape quotes
                row.add(s);
            }

            csvBlob = Blob.valueOf(
                csvBlob.toString() +
                '"' + String.join(row, '","') + '"\n'
            );
        }
    }


    public void finish(Database.BatchableContext bc) {

        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setFileName('AllAccountReport' + Date.today().format() + '.csv');
        attach.setContentType('text/csv');
        attach.setBody(csvBlob);

        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'customer.support@in.experian.com'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        } 
        mail.setToAddresses(emailRecipients);
        mail.setSubject('Salesforce All Account Dump');
        mail.setPlainTextBody('Dear Team,\n\nPlease find attached the All Account Report');
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{ attach });

        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
    }

}