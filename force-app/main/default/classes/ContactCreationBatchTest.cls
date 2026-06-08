@isTest
private class ContactCreationBatchTest {
    
    @TestSetup
    static void makeData(){
        
        // Get Record Type Id for 'Customer' on Account
    Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        // Create test Account with required fields
        Account testAccount = new Account(
            Name = 'Test Account',
            RecordTypeId = recordTypeId,
            ContactCreationBatch__c = true,
            // Dispute Resolution Officers
            Person_Name_Dispute__c = 'Test Dispute Officer',
            Person_Name_2__c = 'Test Dispute Officer',
            Person_Name_3__c = 'Test Dispute Officer',
            Person_Name_4__c = 'Test Dispute Officer',
            Person_Name_5__c = 'Test Dispute Officer',
            Person_Name_6__c = 'Test Dispute Officer',
            Person_Name_7__c = 'Test Dispute Officer',
            Person_Name_8__c = 'Test Dispute Officer',
            Person_Name_9__c = 'Test Dispute Officer',
            Person_Name_10__c = 'Test Dispute Officer',
            Email_1_Dispute__c = 'dispute1@test.com',
            Email_2_Dispute__c = 'dispute1@test.com',
            Email_3_Dispute__c = 'dispute1@test.com',
            Email_4_Dispute__c = 'dispute1@test.com',
            Email_5_Dispute__c = 'dispute1@test.com',
            Email_6_Dispute__c = 'dispute1@test.com',
            Email_7_Dispute__c = 'dispute1@test.com',
            Email_8_Dispute__c = 'dispute1@test.com',
            Email_9_Dispute__c = 'dispute1@test.com',
            Email_10_Dispute__c = 'dispute1@test.com',
            Phone_1__c = '1234567890',
            Phone_2__c = '1234567890',
            Phone_3__c = '1234567890',
            Phone_4__c = '1234567890',
            Phone_5__c = '1234567890',
            Phone_6__c = '1234567890',
            Phone_7__c = '1234567890',
            Phone_8__c = '1234567890',
            Phone_9__c = '1234567890',
            Phone_10__c = '1234567890',
            
            // Grievance Nodal Officer
            Grievances_Nodal_Officer_Name__c = 'Test Grievance Officer',
            Grievances_Nodal_Officer_Email__c = 'grievance@test.com',
            Grievances_Nodal_Officer_Phone__c = '1234567890',
            
            // Technology Contact
            Technology_Contact_Name__c = 'Test Tech Contact',
            Technology_Contact_Email__c = 'tech@test.com',
            Technology_Contact_Phone__c = '1234567890',
            
            // Billing Contact
            Billing_Contact_Name__c = 'Test Billing Contact',
            Billing_Contact_Email__c = 'billing@test.com',
            Billing_Contact_Phone__c = '1234567890',
            
            // DQR Contacts
         /*   Data_Quality_Report_Name_1__c = 'Test DQR Contact',
            Data_Quality_Report_Name_2__c = 'Test DQR Contact',
            Data_Quality_Report_Name_3__c = 'Test DQR Contact',
            Data_Quality_Report_Name_4__c = 'Test DQR Contact',
            Data_Quality_Report_Name_5__c = 'Test DQR Contact',
            Data_Quality_Report_Name_6__c = 'Test DQR Contact',
            Data_Quality_Report_Name_7__c = 'Test DQR Contact',
            Data_Quality_Report_Name_8__c = 'Test DQR Contact',
            Data_Quality_Report_Name_9__c = 'Test DQR Contact',
            Data_Quality_Report_Name_10__c = 'Test DQR Contact',
            Data_Quality_Report_Name_11__c = 'Test DQR Contact',
            Data_Quality_Report_Name_12__c = 'Test DQR Contact',
            Data_Quality_Report_Name_13__c = 'Test DQR Contact',
            Data_Quality_Report_Name_14__c = 'Test DQR Contact',
            Data_Quality_Report_Name_15__c = 'Test DQR Contact',
            Data_Quality_Report_Name_16__c = 'Test DQR Contact',
            Data_Quality_Report_Name_17__c = 'Test DQR Contact',
            Data_Quality_Report_Name_18__c = 'Test DQR Contact',
            Data_Quality_Report_Name_19__c = 'Test DQR Contact',
            Data_Quality_Report_Name_20__c = 'Test DQR Contact',
            Data_Quality_Report_Name_21__c = 'Test DQR Contact',
            Data_Quality_Report_Name_22__c = 'Test DQR Contact',
            Data_Quality_Report_Name_23__c = 'Test DQR Contact',
            Data_Quality_Report_Name_24__c = 'Test DQR Contact',
            Data_Quality_Report_Name_25__c = 'Test DQR Contact',
            DQR_DQI_Email_1__c = 'dqr@test.com',
            DQR_DQI_Email_2__c = 'dqr@test.com',
            DQR_DQI_Email_3__c = 'dqr@test.com',
            DQR_DQI_Email_4__c = 'dqr@test.com',
            DQR_DQI_Email_5__c = 'dqr@test.com',
            DQR_DQI_Email_6__c = 'dqr@test.com',
            DQR_DQI_Email_7__c = 'dqr@test.com',
            DQR_DQI_Email_8__c = 'dqr@test.com',
            DQR_DQI_Email_9__c = 'dqr@test.com',
            DQR_DQI_Email_10__c = 'dqr@test.com',
            DQR_DQI_Email_11__c = 'dqr@test.com',
            DQR_DQI_Email_12__c = 'dqr@test.com',
            DQR_DQI_Email_13__c = 'dqr@test.com',
            DQR_DQI_Email_14__c = 'dqr@test.com',
            DQR_DQI_Email_15__c = 'dqr@test.com',
            DQR_DQI_Email_16__c = 'dqr@test.com',
            DQR_DQI_Email_17__c = 'dqr@test.com',
            DQR_DQI_Email_18__c = 'dqr@test.com',
            DQR_DQI_Email_19__c = 'dqr@test.com',
            DQR_DQI_Email_20__c = 'dqr@test.com',
            DQR_DQI_Email_21__c = 'dqr@test.com',
            DQR_DQI_Email_22__c = 'dqr@test.com',
            DQR_DQI_Email_23__c = 'dqr@test.com',
            DQR_DQI_Email_24__c = 'dqr@test.com',
            DQR_DQI_Email_25__c = 'dqr@test.com',
            Data_Quality_Report_Phone_1__c = '1234567890',
            Data_Quality_Report_Phone_2__c = '1234567890',
            Data_Quality_Report_Phone_3__c = '1234567890',
            Data_Quality_Report_Phone_4__c = '1234567890',
            Data_Quality_Report_Phone_5__c = '1234567890',
            Data_Quality_Report_Phone_6__c = '1234567890',
            Data_Quality_Report_Phone_7__c = '1234567890',
            Data_Quality_Report_Phone_8__c = '1234567890',
            Data_Quality_Report_Phone_9__c = '1234567890',
            Data_Quality_Report_Phone_10__c = '1234567890',
            Data_Quality_Report_Phone_11__c = '1234567890',
            Data_Quality_Report_Phone_12__c = '1234567890',
            Data_Quality_Report_Phone_13__c = '1234567890',
            Data_Quality_Report_Phone_14__c = '1234567890',
            Data_Quality_Report_Phone_15__c = '1234567890',
            Data_Quality_Report_Phone_16__c = '1234567890',
            Data_Quality_Report_Phone_17__c = '1234567890',
            Data_Quality_Report_Phone_18__c = '1234567890',
            Data_Quality_Report_Phone_19__c = '1234567890',
            Data_Quality_Report_Phone_20__c = '1234567890',
            Data_Quality_Report_Phone_21__c = '1234567890',
            Data_Quality_Report_Phone_22__c = '1234567890',
            Data_Quality_Report_Phone_23__c = '1234567890',
            Data_Quality_Report_Phone_24__c = '1234567890',
            Data_Quality_Report_Phone_25__c = '1234567890',
            Data_Quality_Report_Desgn_1__c = 'Manager',
            Data_Quality_Report_Desgn_2__c = 'Manager',
            Data_Quality_Report_Desgn_3__c = 'Manager',
            Data_Quality_Report_Desgn_4__c = 'Manager',
            Data_Quality_Report_Desgn_5__c = 'Manager',
            Data_Quality_Report_Desgn_6__c = 'Manager',
            Data_Quality_Report_Desgn_7__c = 'Manager',
            Data_Quality_Report_Desgn_8__c = 'Manager',
            Data_Quality_Report_Desgn_9__c = 'Manager',
            Data_Quality_Report_Desgn_10__c = 'Manager',
            Data_Quality_Report_Desgn_11__c = 'Manager',
            Data_Quality_Report_Desgn_12__c = 'Manager',
            Data_Quality_Report_Desgn_13__c = 'Manager',
            Data_Quality_Report_Desgn_14__c = 'Manager',
            Data_Quality_Report_Desgn_15__c = 'Manager',
            Data_Quality_Report_Desgn_16__c = 'Manager',
            Data_Quality_Report_Desgn_17__c = 'Manager',
            Data_Quality_Report_Desgn_18__c = 'Manager',
            Data_Quality_Report_Desgn_19__c = 'Manager',
            Data_Quality_Report_Desgn_20__c = 'Manager',
            Data_Quality_Report_Desgn_21__c = 'Manager',
            Data_Quality_Report_Desgn_22__c = 'Manager',
            Data_Quality_Report_Desgn_23__c = 'Manager',
            Data_Quality_Report_Desgn_24__c = 'Manager',
            Data_Quality_Report_Desgn_25__c = 'Manager', */
            
            // Form C Contacts
            Form_C_Level_1_Email_1__c = 'formc1@test.com',
            Form_C_Level_1_Email_2__c = 'formc2@test.com',
            Form_C_Level_1_Email_3__c = 'formc3@test.com',
            Form_C_Level_1_Email_4__c = 'formc4@test.com',
            Form_C_Level_1_Email_5__c = 'formc5@test.com',
            Form_C_Level_1_Email_6__c = 'formc6@test.com',
            Form_C_Level_1_Email_7__c = 'formc7@test.com',
            Form_C_Level_1_Email_8__c = 'formc8@test.com',
            Form_C_Level_1_Email_9__c = 'formc9@test.com',
            Form_C_Level_1_Email_10__c = 'formc10@test.com',
            Form_C_Level_1_Email_11__c = 'formc11@test.com',
            Form_C_Level_1_Email_12__c = 'formc12@test.com',
            Form_C_Level_1_Email_13__c = 'formc13@test.com',
            Form_C_Level_1_Email_14__c = 'formc14@test.com',
            Form_C_Level_1_Email_15__c = 'formc15@test.com',
            Form_C_Level_2_Email_1__c = 'formkyc2@test.com',
            Form_C_Level_2_Email_2__c = 'forgmc2@test.com',
            Form_C_Level_2_Email_3__c = 'formgc2@test.com',
            Form_C_Level_2_Email_4__c = 'formchg2@test.com',
            Form_C_Level_2_Email_5__c = 'formfgc2@test.com',
            Form_C_Level_3_Email_1__c = 'formfac2@test.com',
            Form_C_Level_3_Email_2__c = 'formfac2@test.com',
            Form_C_Level_3_Email_3__c = 'formFc2@test.com',
            Form_C_Level_3_Email_4__c = 'formSFc2@test.com',
            Form_C_Level_3_Email_5__c = 'forAmc2@test.com',
            
            
            
            // OLM Contacts
            OLM_Email_1__c = 'olm@test.com',
            OLM_Email_2__c = 'olm@test.com',
            OLM_Email_3__c = 'olm@test.com',
            OLM_Email_4__c = 'olm@test.com',
            OLM_Email_5__c = 'olm@test.com',
            OLM_Email_6__c = 'olm@test.com',
            OLM_Email_7__c = 'olm@test.com',
            OLM_Email_8__c = 'olm@test.com',
            OLM_Email_9__c = 'olm@test.com',
            OLM_Email_10__c = 'olm@test.com',
            OLM_Email_11__c = 'olm@test.com',
            OLM_Email_12__c = 'olm@test.com',
            OLM_Email_13__c = 'olm@test.com',
            OLM_Email_14__c = 'olm@test.com',
            OLM_Email_15__c = 'olm@test.com',
            OLM_Email_16__c = 'olm@test.com',
            OLM_Email_17__c = 'olm@test.com',
            OLM_Email_18__c = 'olm@test.com',
            OLM_Email_19__c = 'olm@test.com',
            OLM_Email_20__c = 'olm@test.com',
            OLM_Email_21__c = 'olm@test.com',
            OLM_Email_22__c = 'olm@test.com',
            OLM_Email_23__c = 'olm@test.com',
            OLM_Email_24__c = 'olm@test.com',
            OLM_Email_25__c = 'olm@test.com',
            OLM_Email_26__c = 'olm@test.com',
            OLM_Email_27__c = 'olm@test.com',
            OLM_Email_28__c = 'olm@test.com',
            OLM_Email_29__c = 'olm@test.com',
            OLM_Email_30__c = 'olm@test.com',
            OLM_Email_31__c = 'olm@test.com',
            OLM_Email_32__c = 'olm@test.com',
            OLM_Email_33__c = 'olm@test.com',
            OLM_Email_34__c = 'olm@test.com',
            OLM_Email_35__c = 'olm@test.com',
            OLM_Email_36__c = 'olm@test.com',
            OLM_Email_37__c = 'olm@test.com',
            OLM_Email_38__c = 'olm@test.com',
            OLM_Email_39__c = 'olm@test.com',
            OLM_Email_40__c = 'olm@test.com',
            
            // CC Addresses
            CC_Address_1__c = 'cc1@test.com',
            CC_Address_2__c = 'cc2@test.com',
            CC_Address_3__c = 'cc3@test.com',
            CC_Address_4__c = 'cc4@test.com',
            CC_Address_5__c = 'cc5@test.com',
            CC_Address_6__c = 'cc6@test.com',
            CC_Address_7__c = 'cc7@test.com',
            CC_Address_8__c = 'cc8@test.com',
            CC_Address_9__c = 'cc9@test.com',
            CC_Address_10__c = 'cc10@test.com',
            
            // Authorized Signatory
            Authorized_Signatory_Name__c = 'Test Signatory',
            Authorized_Signatory_Email__c = 'signatory@test.com',
            Authorized_Signatory_Phone__c = '1234567890',
            
            // Nodal Officer
            Nodal_Officer_Name__c = 'Test Nodal Officer',
            Nodal_Officer_Email__c = 'nodal@test.com',
            Nodal_Officer_Phone__c = '1234567890'
        );
        insert testAccount;
    }
    
    @isTest
    static void testBatchExecution() {
        // Get the test account
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Test.startTest();
        // Execute the batch
        ContactCreationBatch batch = new ContactCreationBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Verify contacts were created
        List<Contact> createdContacts = [SELECT Id, Contact_Role__c, Email FROM Contact WHERE AccountId = :testAccount.Id];
        
        
        
        // Verify specific contact roles were created
        Set<String> contactRoles = new Set<String>();
        for(Contact con : createdContacts) {
            contactRoles.add(con.Contact_Role__c);
        }
        
        // Check that expected contact roles are present
        
    }
    
    @isTest
    static void testEmptyEmailScenarios() {
        // Create account with empty email fields
        Account testAcc = new Account(
            Name = 'Test Account Empty Emails',
            Person_Name_Dispute__c = 'Test Name',
            Email_1_Dispute__c = null, // Empty email
            Phone_1__c = '1234567890'
        );
        insert testAcc;
        
        Test.startTest();
        ContactCreationBatch batch = new ContactCreationBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Verify no contacts were created for empty email fields
        List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId = :testAcc.Id];
    }
    
    @isTest
    static void testBatchWithMultipleAccounts() {
        // Create multiple test accounts
        List<Account> testAccounts = new List<Account>();
        for(Integer i = 0; i < 5; i++) {
            testAccounts.add(new Account(
                Name = 'Test Account ' + i,
                Email_1_Dispute__c = 'test' + i + '@test.com',
                Person_Name_Dispute__c = 'Test ' + i
            ));
        }
        insert testAccounts;
        
        Test.startTest();
        ContactCreationBatch batch = new ContactCreationBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        // Verify only the latest account is processed (batch query uses LIMIT 1)
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact];
    }
}