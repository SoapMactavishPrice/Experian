@RestResource(urlMapping='/FileUpload/*')
global with sharing class FileUploadAPI {

    @HttpPost
    global static String uploadFile(String fileName, String base64Data) {
        try {
            if (String.isBlank(fileName) || String.isBlank(base64Data)) {
                return JSON.serialize(
                    new ResponseWrapper('Error', 'Missing required parameters: fileName or base64Data', null, null)
                );
            }

            // Decode file
            Blob fileBody = EncodingUtil.base64Decode(base64Data);

            // Create ContentVersion
            ContentVersion cv = new ContentVersion();
            cv.Title = fileName;
            cv.PathOnClient = fileName;  
            cv.VersionData = fileBody;
            cv.ContentLocation = 'S';
            cv.IsMajorVersion = true;
            insert cv;

            // Query ContentDocumentId
            cv = [
                SELECT Id, ContentDocumentId 
                FROM ContentVersion 
                WHERE Id = :cv.Id
                LIMIT 1
            ];

            return JSON.serialize(
                new ResponseWrapper('Success', 'File uploaded successfully', cv.Id, cv.ContentDocumentId)
            );

        } catch (Exception e) {
            return JSON.serialize(
                new ResponseWrapper('Error', 'Failed to upload file: ' + e.getMessage(), null, null)
            );
        }
    }

    global class ResponseWrapper {
        public String status;
        public String message;
        public String contentVersionId;
        public String contentDocumentId;

        public ResponseWrapper(String status, String message, String contentVersionId, String contentDocumentId) {
            this.status = status;
            this.message = message;
            this.contentVersionId = contentVersionId;
            this.contentDocumentId = contentDocumentId;
        }
    }
}