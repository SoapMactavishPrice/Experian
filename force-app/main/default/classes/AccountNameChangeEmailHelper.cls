public class AccountNameChangeEmailHelper {

    public static void sendNameChangeEmail(
        List<Account> newAccounts,
        Map<Id, Account> oldMap
    ) {

        Set<Id> userIds = new Set<Id>();
        for (Account acc : newAccounts) {
             if (acc.LastModifiedById != null) {
                userIds.add(acc.LastModifiedById);
             }
        }

        Map<Id, User> userMap = userIds.isEmpty()
            ? new Map<Id, User>()
            : new Map<Id, User>(
                [SELECT Id, Name FROM User WHERE Id IN :userIds]
              );

        // Get emails from Custom Label and trim spaces
        List<String> recipients = new List<String>();
        for (String emailAddr :
             System.Label.Account_Name_Change_Email.split(',')) {
            recipients.add(emailAddr.trim());
        }

        if (recipients.isEmpty()) {
            return;
        }

        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();

        for (Account newAcc : newAccounts) {
            Account oldAcc = oldMap.get(newAcc.Id);
            if (oldAcc == null) continue;

            Messaging.SingleEmailMessage email =
                new Messaging.SingleEmailMessage();

            email.setToAddresses(recipients);

            email.setSubject('Account Name has been changed');

            User modifiedBy = userMap.get(newAcc.LastModifiedById);
            String modifiedByName =
                (modifiedBy != null) ? modifiedBy.Name : 'Unknown User';

            String body =
                'Dear Team,\n\n' +
                'The Account Name has been changed.\n\n' +
                'Previous Account Name: ' + oldAcc.Name + '\n' +
                'New Account Name: ' + newAcc.Name + '\n' +
                'Last Modified By: ' + modifiedByName + '\n\n' +
                'Regards,\nSalesforce System';

            email.setPlainTextBody(body);
            emails.add(email);
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}