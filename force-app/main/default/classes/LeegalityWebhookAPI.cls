@RestResource(urlMapping='/leegality/webhook/*')
global without sharing class LeegalityWebhookAPI {

    @HttpPost
    global static void receiveWebhook() {

        RestResponse res = RestContext.response;

        try {

            String body = RestContext.request.requestBody.toString();

            System.debug(body);

            LeegalityWebhookWrapper payload = (LeegalityWebhookWrapper)JSON.deserialize(body, LeegalityWebhookWrapper.class);

            /*
             * MAC Validation
             */

            if(!isValidMac(payload.documentId, payload.mac)){
                res.statusCode = 401;
                return;
            }

            /*
             * Update Lead
             */

            LeegalityWebhookService.process(payload);

            res.statusCode = 200;

        }
        catch(Exception e){

            System.debug(e);

            res.statusCode = 500;
        }
    }

    private static Boolean isValidMac(String documentId, String receivedMac){

        Blob key = Blob.valueOf(System.Label.Leegality_Private_Salt);

        Blob data = Blob.valueOf(documentId);

        Blob hash = Crypto.generateMac(
                'HmacSHA1',
                data,
                key
            );

        String calculatedMac = EncodingUtil.convertToHex(hash);

        return calculatedMac.equalsIgnoreCase(
            receivedMac
        );
    }
}