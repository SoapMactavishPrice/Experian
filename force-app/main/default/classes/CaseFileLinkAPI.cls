@RestResource(urlMapping='/CaseFileLink/*')
global with sharing class CaseFileLinkAPI {

    @HttpPost
    global static String linkFileToCase(String caseId, String contentDocumentId) {
        try {
            if (String.isBlank(caseId) || String.isBlank(contentDocumentId)) {
                return JSON.serialize(
                    new ResponseWrapper('Error', 'Missing required parameters: caseId or contentDocumentId')
                );
            }

            // Verify Case exists
            if ([SELECT COUNT() FROM Case WHERE Id = :caseId] == 0) {
                return JSON.serialize(
                    new ResponseWrapper('Error', 'Case not found')
                );
            }

            // Link file to Case
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = caseId;
            cdl.ContentDocumentId = contentDocumentId;
            cdl.ShareType = 'V';
            cdl.Visibility = 'AllUsers';
            insert cdl;

            return JSON.serialize(
                new ResponseWrapper('Success', 'File linked to Case successfully')
            );

        } catch (Exception e) {
            return JSON.serialize(
                new ResponseWrapper('Error', 'Failed to link file: ' + e.getMessage())
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