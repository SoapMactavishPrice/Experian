@RestResource(urlMapping='/CaseFileUpload/*')
global with sharing class CaseFileUploadAPI {

    @HttpPost
    global static String uploadFileToCase(String caseId, String fileName, String base64Data, String contentType) {
        try {
            // Validate input parameters
            if (String.isBlank(caseId) || String.isBlank(fileName) || String.isBlank(base64Data)) {
                return JSON.serialize(new ResponseWrapper('Error', 'Missing required parameters: caseId, fileName, or base64Data', null));
            }

            // Verify Case exists
            List<Case> cases = [SELECT Id FROM Case WHERE Id = :caseId LIMIT 1];
            if (cases.isEmpty()) {
                return JSON.serialize(new ResponseWrapper('Error', 'Case not found', null));
            }

            // Decode base64 data
            Blob fileBody = EncodingUtil.base64Decode(base64Data);

            // Create ContentVersion (file)
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = fileName;
            contentVersion.PathOnClient = fileName;  // Must include extension for FileType auto-detection (e.g., 'document.pdf')
            contentVersion.VersionData = fileBody;
            contentVersion.ContentLocation = 'S'; // S = Salesforce
            contentVersion.IsMajorVersion = true;
            // Note: FileType is auto-set based on PathOnClient extension; do not set it manually
            insert contentVersion;

            // Retrieve ContentDocumentId
            contentVersion = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];

            // Link file to Case using ContentDocumentLink
            ContentDocumentLink docLink = new ContentDocumentLink();
            docLink.ContentDocumentId = contentVersion.ContentDocumentId;
            docLink.LinkedEntityId = caseId;
            docLink.ShareType = 'V'; // Viewer permission
            docLink.Visibility = 'AllUsers';
            insert docLink;

            // Return success response
            return JSON.serialize(new ResponseWrapper('Success', 'File uploaded and linked to Case successfully', contentVersion.Id));
        } catch (Exception e) {
            // Return error response
            return JSON.serialize(new ResponseWrapper('Error', 'Failed to upload file: ' + e.getMessage(), null));
        }
    }

    // Wrapper class for response
    global class ResponseWrapper {
        public String status;
        public String message;
        public String contentVersionId;

        public ResponseWrapper(String status, String message, String contentVersionId) {
            this.status = status;
            this.message = message;
            this.contentVersionId = contentVersionId;
        }
    }
}