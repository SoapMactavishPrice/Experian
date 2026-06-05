@RestResource(urlMapping='/GetMembershipFiles/*')
global with sharing class GetMembershipFilesAPI {

    @HttpGet
    global static String getMembershipFiles() {

        try {

            String idsParam =
                RestContext.request.params.get('membershipDocumentIds');

            if (String.isBlank(idsParam)) {
                return JSON.serialize(
                    new ResponseWrapper(
                        'Error',
                        'membershipDocumentIds is required'
                    )
                );
            }

            Set<Id> membershipDocumentIds = new Set<Id>();

            for (String idStr : idsParam.split(',')) {
                if (!String.isBlank(idStr)) {
                    membershipDocumentIds.add((Id)idStr.trim());
                }
            }

            List<FileWrapper> files = new List<FileWrapper>();

            for (ContentDocumentLink link : [
                SELECT
                    LinkedEntityId,
                    ContentDocumentId,
                    ContentDocument.Title,
                    ContentDocument.FileType,
                    ContentDocument.LatestPublishedVersionId,
                    ContentDocument.CreatedDate
                FROM ContentDocumentLink
                WHERE LinkedEntityId IN :membershipDocumentIds
            ]) {

                files.add(new FileWrapper(
                    (String)link.LinkedEntityId,
                    link.ContentDocumentId,
                    link.ContentDocument.Title,
                    link.ContentDocument.FileType,
                    link.ContentDocument.LatestPublishedVersionId,
                    link.ContentDocument.CreatedDate
                ));
            }

            return JSON.serialize(
                new SuccessResponse('Success', files)
            );

        } catch (Exception e) {

            return JSON.serialize(
                new ResponseWrapper(
                    'Error',
                    e.getMessage()
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

    global class SuccessResponse {
        public String status;
        public List<FileWrapper> files;

        public SuccessResponse(String status, List<FileWrapper> files) {
            this.status = status;
            this.files = files;
        }
    }

    global class FileWrapper {
        public String membershipDocumentId;
        public String contentDocumentId;
        public String title;
        public String fileType;
        public String latestVersionId;
        public Datetime createdDate;

        public FileWrapper(
            String membershipDocumentId,
            String contentDocumentId,
            String title,
            String fileType,
            String latestVersionId,
            Datetime createdDate
        ) {
            this.membershipDocumentId = membershipDocumentId;
            this.contentDocumentId = contentDocumentId;
            this.title = title;
            this.fileType = fileType;
            this.latestVersionId = latestVersionId;
            this.createdDate = createdDate;
        }
    }
}