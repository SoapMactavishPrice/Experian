@RestResource(urlMapping='/MembershipDocumentFileLink/*')
global with sharing class MembershipDocumentFileLinkAPI {

    @HttpPost
    global static String linkFileToMembershipDocument(
        String membershipDocumentId,
        String contentDocumentId
    ) {
        try {

            if (String.isBlank(membershipDocumentId) ||
                String.isBlank(contentDocumentId)) {

                return JSON.serialize(
                    new ResponseWrapper(
                        'Error',
                        'Missing required parameters: membershipDocumentId or contentDocumentId'
                    )
                );
            }

            // Verify Membership_Document__c exists
            if ([SELECT COUNT()
                 FROM Membership_Document__c
                 WHERE Id = :membershipDocumentId] == 0) {

                return JSON.serialize(
                    new ResponseWrapper(
                        'Error',
                        'Membership Document record not found'
                    )
                );
            }

            // Link file
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = membershipDocumentId;
            cdl.ContentDocumentId = contentDocumentId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';

            insert cdl;

            return JSON.serialize(
                new ResponseWrapper(
                    'Success',
                    'File linked successfully to Membership Document'
                )
            );

        } catch (Exception e) {

            return JSON.serialize(
                new ResponseWrapper(
                    'Error',
                    'Failed to link file: ' + e.getMessage()
                )
            );
        }
    }

    global class ResponseWrapper {
        public String status;
        public String message;

        public ResponseWrapper(String status, String message) {
            this.status = status;
            this.message = message;
        }
    }
}