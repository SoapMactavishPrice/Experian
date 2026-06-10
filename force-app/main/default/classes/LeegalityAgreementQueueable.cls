public with sharing class LeegalityAgreementQueueable implements Queueable, Database.AllowsCallouts {

    private Set<Id> leadIds;

    public LeegalityAgreementQueueable(Set<Id> leadIds){
        this.leadIds = leadIds;
    }

    public void execute(QueueableContext context){

        List<Lead> leads = [
            SELECT Id, Name, Company, Email, Phone, Billing_Street__c FROM Lead
            WHERE Id IN :leadIds
        ];

        List<Lead> leadsToUpdate = new List<Lead>();

        for(Lead ld : leads){

            try{

                PageReference pdfPage = Page.StandardMembershipAgreement;

                pdfPage.getParameters().put('leadId', ld.Id);

                Blob pdfBlob = pdfPage.getContentAsPDF();

                String base64Pdf = EncodingUtil.base64Encode(pdfBlob);

                Map<String,Object> payload = new Map<String,Object>();

                payload.put('profileId', 'Bhl38w8');

                Map<String,Object> fileObj = new Map<String,Object>();

                fileObj.put('name', 'StandardMembershipAgreement.pdf');

                fileObj.put('file', base64Pdf);

                payload.put('file', fileObj);

                List<Object> invitees = new List<Object>();

                /* Lead Invitee */
                Map<String,Object> signer1 = new Map<String,Object>();

                signer1.put(
                    'name',
                    ld.Name
                );

                signer1.put(
                    'email',
                    ld.Email
                );

                signer1.put(
                    'phone',
                    ld.Phone
                );

                invitees.add(
                    signer1
                );

                /* Invitee 2 from Labels */
                Map<String,Object> signer2 =
                    new Map<String,Object>();

                signer2.put(
                    'name',
                    System.Label.Experian_Leegality_signer_name
                );

                signer2.put(
                    'email',
                    System.Label.Experian_Leegality_signer_email
                );

                signer2.put(
                    'phone',
                    System.Label.Experian_Leegality_signer_mobile
                );

                invitees.add(
                    signer2
                );

                payload.put(
                    'invitees',
                    invitees
                );

                List<Object> multipleStampSeries =
                    new List<Object>();

                Map<String,Object> stampSeries =
                    new Map<String,Object>();

                stampSeries.put(
                    'stampSeries',
                    '01'
                );

                stampSeries.put(
                    'seriesQuantity',
                    '02'
                );

                multipleStampSeries.add(
                    stampSeries
                );

                payload.put(
                    'multipleStampSeries',
                    multipleStampSeries
                );

                payload.put(
                    'irn',
                    ld.Id
                );

                HttpRequest req =
                    new HttpRequest();

                req.setEndpoint(
                    'https://sandbox.leegality.com/api/v3.0/sign/request'
                );

                req.setMethod(
                    'POST'
                );

                req.setHeader(
                    'Content-Type',
                    'application/json'
                );

                req.setHeader(
                    'X-Auth-Token',
                    'FFsOjl9XLjCRLj0dLYX4682tdk4yBu9e'
                );

                req.setTimeout(
                    120000
                );

                req.setBody(
                    JSON.serialize(
                        payload
                    )
                );

                Http http =
                    new Http();

                HttpResponse res =
                    http.send(req);

                    System.debug('STATUS CODE = ' + res.getStatusCode());
                    System.debug('RESPONSE = ' + res.getBody());

                if(res.getStatusCode() == 200 ){

                    Map<String,Object> responseMap =
                        (Map<String,Object>)
                        JSON.deserializeUntyped(
                            res.getBody()
                        );

                    Integer statusVal =
                        (Integer)
                        responseMap.get(
                            'status'
                        );

                    if(statusVal == 1){

                        Map<String,Object> data =
                            (Map<String,Object>)
                            responseMap.get(
                                'data'
                            );

                        String documentId =
                            (String)
                            data.get(
                                'documentId'
                            );

                        Lead updLead =
                            new Lead(
                                Id = ld.Id
                            );

                        updLead
                            .Leegality_Document_ID__c =
                                documentId;

                        leadsToUpdate.add(
                            updLead
                        );
                    } else{
                        createApiLog( ld.Id, ld.Name, 'LeegalityAgreementQueueable - Status val != 1 - ', res.getBody());
                    }
                } else{
                    createApiLog( ld.Id, ld.Name, 'LeegalityAgreementQueueable - HTTP Failure', 'Status Code : '+res.getStatusCode() + ' Response : ' +res.getBody());
                }

            }catch(Exception ex){
                createApiLog( ld.Id, ld.Name, 'LeegalityAgreementQueueable - Exception', ex.getMessage() + ' ' + + ex.getStackTraceString());
                System.debug('Leegality Error: ' + ex.getMessage());
            }
        }

        if(!leadsToUpdate.isEmpty()){
            update leadsToUpdate;
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