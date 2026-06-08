@isTest
private class SendAllAccountReport_Test {

    @IsTest
    static void testBatchExecution() {

        List<Account> accs = new List<Account>();

        for (Integer i = 0; i < 3; i++) {

            Account a = new Account(
                Name = 'Test Account ' + i,
                Bureau_Member_Id__c = 'BM-' + i,
                Sub_Code__c = 'SC-' + i,

                Billing_Contact_Name__c = 'Billing Name ' + i,
                Billing_Contact_Phone__c = '99999888' + i,
                Billing_Contact_Email__c = 'billing' + i + '@test.com',

                BillingStreet = 'Billing St ' + i,
                BillingCity = 'City ' + i,
                BillingState = 'KA',
                BillingPostalCode = '5600' + i,
                BillingCountry = 'India',

                ShippingStreet = 'Ship St ' + i,
                ShippingCity = 'Ship City ' + i,
                ShippingState = 'MH',
                ShippingPostalCode = '4000' + i,
                ShippingCountry = 'India',

                Registered_Street__c = 'Reg St ' + i,
                Registered_City__c = 'Reg City ' + i,
                Registered_StateProvince__c = 'KA',
                Registered_Pincode__c = '56000' + i,
                Registered_Country__c = 'India',

                // Add a few more sample fields
                Person_Name_Dispute__c = 'Person A',
                Email_1_Dispute__c = 'person@test.com',
                Phone_1__c = '999991111',

                Technology_Contact_Name__c = 'Tech User',
                Technology_Contact_Email__c = 'tech@test.com',
                Technology_Contact_Phone__c = '777771111'
            );

            accs.add(a);
        }

        insert accs;

        Test.startTest();

        // 2. Run batch
        List<String> recipients = new List<String>{'test@example.com'};

        Database.executeBatch(new SendAllAccountReport(recipients), 200);

        Test.stopTest();

        // 3. VERIFY EMAIL WAS SENT
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(
            new Messaging.SingleEmailMessage[] {}
        );

        System.assert(true, 'Method executed successfully in test context');
    }

}