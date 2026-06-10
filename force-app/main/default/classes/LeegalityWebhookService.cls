public without sharing class LeegalityWebhookService {

    public static void process(
        LeegalityWebhookWrapper payload
    ){

        List<Lead> leads = [
            SELECT Id,
                   Email,
                   Signer_1_Status__c,
                   Signer_2_Status__c,
                   Leegality_Document_ID__c
            FROM Lead
            WHERE Leegality_Document_ID__c = :payload.documentId
            LIMIT 1
        ];

        if(leads.isEmpty()){
            return;
        }

        Lead ld = leads[0];

        if(
            payload.request != null &&
            payload.request.action == 'Signed'
        ){

            /*
             * Signer 1
             */
            if(
                payload.request.email != null &&
                payload.request.email.equalsIgnoreCase(
                    ld.Email
                )
            ){
                ld.Signer_1_Status__c = 'Signed';
            }

            /*
             * Signer 2
             */
            else if(
                payload.request.email != null &&
                payload.request.email.equalsIgnoreCase(
                    System.Label.Experian_Leegality_signer_email
                )
            ){
                ld.Signer_2_Status__c = 'Signed';
            }

            update ld;
        }
    }
}