public class InvoiceEmailHelper {

    public static void sendInvoiceEmail(List<Account> accounts) {
        Set<Id> accIds = new Set<Id>();
        for (Account acc : accounts) accIds.add(acc.Id);

        // Query related invoices
        Map<Id, List<Invoice__c>> accToInvoices = new Map<Id, List<Invoice__c>>();
        for (Invoice__c inv : [
            SELECT Id, Name, CreatedDate, Invoice_Date__c, Amount__c, Financial_Year__c, Account__c
            FROM Invoice__c
            WHERE Account__c IN :accIds AND CreatedDate = TODAY
            ORDER BY Invoice_Date__c DESC
        ]) {
            if (!accToInvoices.containsKey(inv.Account__c)) {
                accToInvoices.put(inv.Account__c, new List<Invoice__c>());
            }
            accToInvoices.get(inv.Account__c).add(inv);
        }

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Account acc : accounts) {
            List<Invoice__c> invoices = accToInvoices.get(acc.Id);
            if (invoices == null || invoices.isEmpty()) continue;

            // Build HTML email body
            String htmlBody = ''
                + 'Dear Member,<br/><br/>'
                + 'Thank you for your membership with <b>Experian Credit Information Company of India (ECICI)</b>.<br/><br/>'
                + 'We wish to draw your attention to the pending membership invoices payable by you.<br/><br/>'
                + '<table border="1" cellpadding="5" cellspacing="0" style="border-collapse:collapse;">'
                + '<tr style="background-color:#f2f2f2;"><th>Invoice Number</th><th>Invoice Date</th><th>Amount</th><th>Financial Year</th></tr>';

            Decimal totalAmt = 0;
            for (Invoice__c inv : invoices) {
                htmlBody += '<tr>'
                    + '<td>' + inv.Name + '</td>'
                    + '<td>' + (inv.Invoice_Date__c != null ? inv.Invoice_Date__c.format() : '') + '</td>'
                    + '<td>' + (inv.Amount__c != null ? inv.Amount__c.format() : '') + '</td>'
                    + '<td>' + (inv.Financial_Year__c != null ? inv.Financial_Year__c : '') + '</td>'
                    + '</tr>';
                totalAmt += (inv.Amount__c != null ? inv.Amount__c : 0);
            }

            htmlBody += '<tr><td colspan="2" align="right"><b>Total</b></td><td colspan="2"><b>' + totalAmt.format() + '</b></td></tr>';
            htmlBody += '</table><br/><br/>';

            htmlBody += 'The relevant invoices were emailed to you from <b>imaging@experian.com</b>.<br/><br/>'
                + 'You may make the payments via NEFT / IMPS / UPI to:<br/><br/>'
                + '<b>Bank Name:</b> Hongkong Shanghai Banking Corp Ltd<br/>'
                + '<b>Address:</b> 52/60, M.G. Road, M Roaming Security: Mumbai 400 001<br/>'
                + '<b>Account Name:</b> Experian Credit Information Company of India Pvt. Ltd.<br/>'
                + '<b>Account Number:</b> 006075113001<br/>'
                + '<b>IFSC Code:</b> HSBC0400002<br/><br/>'
                + 'Please share the UTR/Transaction IDs of the payments with us on this email once you have made the payments or have already made payments.<br/><br/>'
                + 'In case of any query, you may revert to this email or reach out to us on <b>(022-68165601)</b>.<br/><br/>'
                + 'Regards,<br/>'
                + 'India Membership Collections Team';

            // Collect recipients
            List<String> toAddresses = new List<String>();
            if (acc.Nodal_Officer_Email__c != null) toAddresses.add(acc.Nodal_Officer_Email__c);
            if (acc.Billing_Contact_Email__c != null) toAddresses.add(acc.Billing_Contact_Email__c);
            if (acc.Authorized_Signatory_Email__c != null) toAddresses.add(acc.Authorized_Signatory_Email__c);

            if (toAddresses.isEmpty()) continue;

            // Build email message
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(toAddresses);
            email.setSubject('Pending Membership Fees - Experian Credit Information Company of India');
            email.setHtmlBody(htmlBody);
            email.setSaveAsActivity(true); // ✅ Save email in Activity History

            // Use Org-Wide Email Address
            Id orgWideEmailId = getOrgWideEmailId('indiamembershipcollection@experian.com');
            if (orgWideEmailId != null) {
                email.setOrgWideEmailAddressId(orgWideEmailId);
            }

            // Link to Account for Activity History
            email.setWhatId(acc.Id);

            emails.add(email);
        }

        if (!emails.isEmpty() && !Test.isRunningTest()) {
            Messaging.sendEmail(emails);
        }
        
    }

    // Utility: fetch Org-Wide Email Address Id
    private static Id getOrgWideEmailId(String emailAddress) {
        for (OrgWideEmailAddress owea : [
            SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = :emailAddress LIMIT 1
        ]) {
            return owea.Id;
        }
        return null;
    }
}