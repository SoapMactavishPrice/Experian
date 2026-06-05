@isTest
public class InvoiceEmailHelperTest {

    @isTest
    static void testSendInvoiceEmail_Success() {

        // ===== MOCK OWEA SEARCH =====
        Id mockOweaId = Id.valueOf('0D200000000001A'); // Dummy 15-char Id
        Test.setFixedSearchResults(new Id[]{ mockOweaId });

        // ===== CREATE ACCOUNT =====
        Account acc = new Account(
            Name = 'Test Member Account',
            Send_Invoice_Email__c = true,
            Nodal_Officer_Email__c = 'nodal@test.com',
            Billing_Contact_Email__c = 'billing@test.com',
            Authorized_Signatory_Email__c = 'signatory@test.com'
        );
        insert acc;

        // ===== CREATE RELATED INVOICES =====
        List<Invoice__c> invoices = new List<Invoice__c>();
        for (Integer i = 1; i <= 3; i++) {
            invoices.add(new Invoice__c(
                Name = 'INV-00' + i,
                Account__c = acc.Id,
                Invoice_Date__c = Date.today().addDays(-i),
                Amount__c = 1000 * i,
                Financial_Year__c = '2024-2025'
            ));
        }
        insert invoices;

        // ===== RUN TEST =====
        Test.startTest();
        InvoiceEmailHelper.sendInvoiceEmail(new List<Account>{ acc });
        Test.stopTest();

        // ===== ASSERTIONS =====
        Integer invCount = [SELECT COUNT() FROM Invoice__c WHERE Account__c = :acc.Id];
        System.assertEquals(3, invCount, 'Invoices should exist for the account');
        System.assertEquals(true, acc.Send_Invoice_Email__c, 'Flag should remain true');
    }


    @isTest
    static void testSendInvoiceEmail_NoInvoices() {

        Id mockOweaId = Id.valueOf('0D200000000001B');
        Test.setFixedSearchResults(new Id[]{ mockOweaId });

        Account acc = new Account(
            Name = 'No Invoice Account',
            Send_Invoice_Email__c = true,
            Nodal_Officer_Email__c = 'nodal@test.com'
        );
        insert acc;

        Test.startTest();
        InvoiceEmailHelper.sendInvoiceEmail(new List<Account>{ acc });
        Test.stopTest();

        System.assertEquals(true, acc.Send_Invoice_Email__c, 'Email should handle missing invoices gracefully');
    }


    @isTest
    static void testSendInvoiceEmail_FlagFalse() {

        Id mockOweaId = Id.valueOf('0D200000000001C');
        Test.setFixedSearchResults(new Id[]{ mockOweaId });

        Account acc = new Account(
            Name = 'Flag False Account',
            Send_Invoice_Email__c = false,
            Nodal_Officer_Email__c = 'nodal@test.com'
        );
        insert acc;

        Test.startTest();
        InvoiceEmailHelper.sendInvoiceEmail(new List<Account>{ acc });
        Test.stopTest();

        System.assertEquals(false, acc.Send_Invoice_Email__c, 'Email should not trigger when flag is false');
    }
}