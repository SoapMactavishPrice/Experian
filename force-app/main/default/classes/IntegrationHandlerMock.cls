global class IntegrationHandlerMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        if(req.getBody().contains('grant_type')){
            res.setBody('{"access_token":"dummy_token"}');
        }
        else {
            String fakePdf = EncodingUtil.base64Encode(
                Blob.valueOf('Dummy PDF')
            );

            res.setBody(
                '{"stageOneId_":"111","stageTwoId_":"222","pdfReport":"' + fakePdf + '"}'
            );
        }

        res.setStatusCode(200);

        return res;
    }
}