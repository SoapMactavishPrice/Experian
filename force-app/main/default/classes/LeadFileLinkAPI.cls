@RestResource(urlMapping='/LeadFileLink/*')
global with sharing class LeadFileLinkAPI {

    @HttpPost
    global static String linkFileToLead(String leadId, String contentDocumentId) {
        try {
            if (String.isBlank(leadId) || String.isBlank(contentDocumentId)) {
                return JSON.serialize(
                    new ResponseWrapper('Error', 'Missing required parameters: leadId or contentDocumentId', null)
                );
            }

            // Verify Lead exists
            if ([SELECT COUNT() FROM Lead WHERE Id = :leadId] == 0) {
                return JSON.serialize(
                    new ResponseWrapper('Error', 'Lead not found', null)
                );
            }

            // Step 1: Link file to Lead
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = leadId;
            cdl.ContentDocumentId = contentDocumentId;
            cdl.ShareType = 'V'; // Viewer
            cdl.Visibility = 'AllUsers';
            insert cdl;

            // Step 2: Get ContentVersion
            ContentVersion cv = [
                SELECT Id, ContentDocumentId, Title
                FROM ContentVersion
                WHERE ContentDocumentId = :contentDocumentId
                ORDER BY CreatedDate DESC
                LIMIT 1
            ];

            // Step 3: Create Public Link
            ContentDistribution cd = new ContentDistribution();
            cd.Name = cv.Title;
            cd.ContentVersionId = cv.Id;
            cd.PreferencesAllowViewInBrowser = true;
            cd.PreferencesAllowOriginalDownload = true;
            cd.PreferencesLinkLatestVersion = true;
            cd.PreferencesNotifyOnVisit = false;
            insert cd;

            // Step 4: Get Public URL
            cd = [
                SELECT DistributionPublicUrl
                FROM ContentDistribution
                WHERE Id = :cd.Id
                LIMIT 1
            ];

            return JSON.serialize(
                new ResponseWrapper(
                    'Success',
                    'File linked to Lead and public URL generated',
                    cd.DistributionPublicUrl
                )
            );

        } catch (Exception e) {
            return JSON.serialize(
                new ResponseWrapper('Error', 'Failed: ' + e.getMessage(), null)
            );
        }
    }

    global class ResponseWrapper {
        public String status;
        public String message;
        public String publicUrl;

        public ResponseWrapper(String status, String message, String publicUrl) {
            this.status = status;
            this.message = message;
            this.publicUrl = publicUrl;
        }
    }
}