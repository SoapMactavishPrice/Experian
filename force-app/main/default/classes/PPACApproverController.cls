public with sharing class PPACApproverController {

    public class Wrapper {
        @AuraEnabled
        public List<Approving_Authority__c> authorities;

        @AuraEnabled
        public List<Id> selectedAuthorityIds;
    }

    // Fetch Data
    @AuraEnabled(cacheable=true)
    public static Wrapper getApproverData(Id ppacId) {

        Wrapper response = new Wrapper();

        // All Authorities
        response.authorities = [
            SELECT Id, Name, Role_Designation__c, Email__c
            FROM Approving_Authority__c
            ORDER BY Name
        ];

        // Already Selected
        response.selectedAuthorityIds = new List<Id>();

        for(PPAC_Approving_Authorities__c rec : [
            SELECT Approving_Authority__c
            FROM PPAC_Approving_Authorities__c
            WHERE PPAC__c = :ppacId
        ]){
            response.selectedAuthorityIds.add(rec.Approving_Authority__c);
        }

        return response;
    }

    // Sync Approvers
    @AuraEnabled
    public static void saveApprovers(Id ppacId, List<Id> selectedAuthorityIds) {

        if(ppacId == null){
            throw new AuraHandledException('Invalid PPAC');
        }

        // Existing Junction Records
        List<PPAC_Approving_Authorities__c> existingRecords = [
            SELECT Id, Approving_Authority__c
            FROM PPAC_Approving_Authorities__c
            WHERE PPAC__c = :ppacId
        ];

        Set<Id> existingIds = new Set<Id>();

        for(PPAC_Approving_Authorities__c rec : existingRecords){
            existingIds.add(rec.Approving_Authority__c);
        }

        Set<Id> selectedIds = new Set<Id>(selectedAuthorityIds);

        List<PPAC_Approving_Authorities__c> toInsert = new List<PPAC_Approving_Authorities__c>();
        List<PPAC_Approving_Authorities__c> toDelete = new List<PPAC_Approving_Authorities__c>();

        // Insert New
        for(Id authorityId : selectedIds){

            if(!existingIds.contains(authorityId)){

                toInsert.add(
                    new PPAC_Approving_Authorities__c(
                        PPAC__c = ppacId,
                        Approving_Authority__c = authorityId
                    )
                );
            }
        }

        // Delete Removed
        for(PPAC_Approving_Authorities__c rec : existingRecords){

            if(!selectedIds.contains(rec.Approving_Authority__c)){
                toDelete.add(rec);
            }
        }

        if(!toInsert.isEmpty()){
            insert toInsert;
        }

        if(!toDelete.isEmpty()){
            delete toDelete;
        }

        sendApproverEmails(ppacId);
    }

   private static void sendApproverEmails(Id ppacId){

        Datetime reviewSubmissionDate = System.now();

        OrgWideEmailAddress owea = [
            SELECT Id
            FROM OrgWideEmailAddress
            WHERE Address = 'consumer.support@in.experian.com'
            LIMIT 1
        ];

        PPAC__c ppac = [
            SELECT Id,
                Name,
                PPAC_ID__c,
                Sub_Category__c,
                Requestor_Email__c,
                PPAC_Link__c,
                CreatedBy.Name
            FROM PPAC__c
            WHERE Id = :ppacId
        ];

        List<PPAC_Approving_Authorities__c> approvers = [
            SELECT Id,
                Approving_Authority__r.Name,
                Approving_Authority__r.Email__c
            FROM PPAC_Approving_Authorities__c
            WHERE PPAC__c = :ppacId
        ];

        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();

        /*
        * EMAIL TO APPROVERS
        */
        for(PPAC_Approving_Authorities__c approver : approvers){

            if(String.isBlank(
                approver.Approving_Authority__r.Email__c
            )){
                continue;
            }

            String reviewLink =
                Label.PPAC_Approver_Site_URL
                + '/PPACReview/apex/PPACApproverReview'
                + '?id='
                + approver.Id;

            Messaging.SingleEmailMessage mail =
                new Messaging.SingleEmailMessage();

            mail.setOrgWideEmailAddressId(owea.Id);

            mail.setToAddresses(
                new List<String>{
                    approver.Approving_Authority__r.Email__c
                }
            );

            mail.setSubject(
                'PPAC Note Uploaded for Review – '
                + ppac.PPAC_ID__c
                + ' '
                + ppac.Name
            );

            String body =

                'Dear '
                + approver.Approving_Authority__r.Name
                + ',\n\n'

                + 'A PPAC Note has been uploaded and is ready for your review.\n\n'

                + 'Details:\n'

                + '• PPAC ID: '
                + ppac.PPAC_ID__c
                + '\n'

                + '• PPAC Note Name: '
                + ppac.Name
                + '\n'

                + '• Business Unit: '
                + ppac.Sub_Category__c
                + '\n'

                + '• Submitted By: '
                + ppac.CreatedBy.Name
                + '\n'

                + '• Submission Date: '
                + reviewSubmissionDate.format(
                    'dd-MMM-yyyy hh:mm a'
                )
                + '\n\n'

                + 'You are requested to review the note and provide your comments / observations using the link below.\n\n'

                + 'Review / Approve PPAC:\n'
                + reviewLink
                + '\n\n'

                + 'Access the PPAC Note here:\n'
                + ppac.PPAC_Link__c
                + '\n\n'

                + 'This is a system generated email.';

            mail.setPlainTextBody(body);

            emails.add(mail);
        }


        /*
        * EMAIL TO USER
        */
        if(String.isNotBlank(ppac.Requestor_Email__c)){

            Messaging.SingleEmailMessage userMail =
                new Messaging.SingleEmailMessage();

            userMail.setOrgWideEmailAddressId(owea.Id);

            userMail.setToAddresses(
                new List<String>{
                    ppac.Requestor_Email__c
                }
            );

            userMail.setSubject(

                'PPAC Note Uploaded for Review – '

                + ppac.PPAC_ID__c

                + ' '

                + ppac.Name
            );

            String userBody =

                'Dear ' + ppac.CreatedBy.Name + '\n\n'

                + 'A PPAC Note has been reviewed by the Risk Team and submitted to the approvers for review.\n\n'

                + 'Details:\n'

                + '• PPAC ID: '
                + ppac.PPAC_ID__c
                + '\n'

                + '• PPAC Note Name: '
                + ppac.Name
                + '\n'

                + '• Business Unit: '
                + ppac.Sub_Category__c
                + '\n'

                + '• Submitted By: '
                + ppac.CreatedBy.Name
                + '\n'

                + '• Submission Date: '
                + reviewSubmissionDate.format(
                    'dd-MMM-yyyy hh:mm a'
                )
                + '\n\n'

                + 'You will receive notifications if any approver raises observations requiring your response.\n\n'

                + 'Access the PPAC Record here:\n'
                + ppac.PPAC_Link__c
                + '\n\n'

                + 'This is a system generated email.';

            userMail.setPlainTextBody(userBody);

            emails.add(userMail);
        }


        if(!emails.isEmpty()){

            Messaging.sendEmail(emails);
        }
    }
}