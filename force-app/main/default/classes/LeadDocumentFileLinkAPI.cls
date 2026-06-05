@RestResource(urlMapping='/LeadFilesLink/*')
global with sharing class LeadDocumentFileLinkAPI {

    @HttpGet
    global static List<FileWrapper> getLeadFiles() {

        RestRequest req = RestContext.request;
        String leadId = req.params.get('leadId');

        if (String.isBlank(leadId)) {
            throw new AuraHandledException('Lead Id is required');
        }

        List<FileWrapper> files = new List<FileWrapper>();

        for (ContentDocumentLink cdl : [
            SELECT
                ContentDocumentId,
                ContentDocument.Title,
                ContentDocument.FileType,
                ContentDocument.ContentSize,
                ContentDocument.CreatedDate,
                ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :leadId
        ]) {

            FileWrapper file = new FileWrapper();
            file.contentDocumentId = cdl.ContentDocumentId;
            file.title = cdl.ContentDocument.Title;
            file.fileType = cdl.ContentDocument.FileType;
            file.fileSize = cdl.ContentDocument.ContentSize;
            file.createdDate = cdl.ContentDocument.CreatedDate;
            file.versionId = cdl.ContentDocument.LatestPublishedVersionId;

            files.add(file);
        }

        return files;
    }

    global class FileWrapper {
        public String contentDocumentId;
        public String title;
        public String fileType;
        public Long fileSize;
        public Datetime createdDate;
        public String versionId;
    }
}