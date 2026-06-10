public class LeegalityFetchDocumentQueueable implements Queueable, Database.AllowsCallouts {

    private Set<Id> leadIds;

    public LeegalityFetchDocumentQueueable(Set<Id> leadIds){
        this.leadIds = leadIds;
    }

    public void execute(QueueableContext context){

        List<Lead> leads = [SELECT Id, Name, Leegality_Document_ID__c FROM Lead WHERE Id IN :leadIds];

        for(Lead ld : leads){

            try{

                /* STEP 1 - Get Download URL */

                HttpRequest req = new HttpRequest();

                req.setMethod('GET');

                req.setEndpoint(
                    'https://sandbox.leegality.com/api/v3.3/document/fetchDocument'
                    + '?documentDownloadType=DOCUMENT'
                    + '&documentId='
                    + EncodingUtil.urlEncode(
                        ld.Leegality_Document_ID__c,
                        'UTF-8'
                    )
                );

                req.setHeader(
                    'X-Auth-Token',
                    'FFsOjl9XLjCRLj0dLYX4682tdk4yBu9e'
                );

                Http http =
                    new Http();

                HttpResponse res =
                    http.send(req);

                if(res.getStatusCode() != 200){
                    createApiLog(ld.Id, ld.Name, 'LeegalityFetchDocumentQueueable - Fetch URL HTTP Failure', 'Status Code : ' + res.getStatusCode() + ' Response : ' + res.getBody());
                    continue;
                }

                Map<String,Object> responseMap =
                    (Map<String,Object>)
                    JSON.deserializeUntyped(
                        res.getBody()
                    );

                Integer statusVal = (Integer)responseMap.get('status');

                if(statusVal != 1){
                    createApiLog(ld.Id, ld.Name, 'LeegalityFetchDocumentQueueable - Fetch URL Business Failure', res.getBody());
                    continue;
                }

                Map<String,Object> data =
                    (Map<String,Object>)
                    responseMap.get('data');

                String fileUrl =
                    (String)data.get('file');

                if(String.isBlank(fileUrl)){
                    createApiLog(ld.Id, ld.Name, 'LeegalityFetchDocumentQueueable - File URL Missing', res.getBody());
                    continue;
                }

                /*STEP 2 Download PDF */

                HttpRequest pdfReq =
                    new HttpRequest();

                pdfReq.setEndpoint(fileUrl);
                pdfReq.setMethod('GET');

                HttpResponse pdfRes =
                    http.send(pdfReq);

                if(pdfRes.getStatusCode() != 200){
                    createApiLog(ld.Id, ld.Name, 'LeegalityFetchDocumentQueueable - PDF Download Failure', 'Status Code : ' + pdfRes.getStatusCode());
                    continue;
                }

                Blob pdfBlob =
                    pdfRes.getBodyAsBlob();

                /*
                 * STEP 3
                 * Save As Salesforce File
                 */

                try{
                    ContentVersion cv = new ContentVersion();
                    cv.Title = 'Leegality Agreement';
                    cv.PathOnClient = 'LeegalityAgreement.pdf';
                    cv.VersionData = pdfBlob;
                    cv.FirstPublishLocationId = ld.Id;
                    insert cv;

                }catch(Exception fileEx){
                    createApiLog(ld.Id, ld.Name, 'LeegalityFetchDocumentQueueable - File Save Failure', fileEx.getMessage() + ' ' + fileEx.getStackTraceString());
                    continue;
                }

                try{
                    Lead updLead = new Lead(
                        Id = ld.Id,
                        Status = 'Agreement Received'
                    );

                    update updLead;
                }catch(Exception leadEx){

                    createApiLog(
                        ld.Id,
                        ld.Name,
                        'LeegalityFetchDocumentQueueable - Lead Status Update Failure',
                        leadEx.getMessage() + ' ' + leadEx.getStackTraceString()
                    );
                }
                

            }catch(Exception ex){
                System.debug(ex.getMessage());
                createApiLog(ld.Id, ld.Name, 'LeegalityFetchDocumentQueueable - Exception', ex.getMessage() + ' ' + ex.getStackTraceString());
            }
        }
    }

    private static void createApiLog(Id leadId, String leadName, String requestSource, String errorMessage){
        try{
            API_LOG__c ap = new API_LOG__c();
            ap.Lead__c = leadId;
            ap.Request_Source__c = requestSource + ' - ' + leadName;
            ap.Exception_Description__c = errorMessage;
            insert ap;

        }catch(Exception ex){
            System.debug('API Log Insert Failed: ' + ex.getMessage());
        }
    }
}