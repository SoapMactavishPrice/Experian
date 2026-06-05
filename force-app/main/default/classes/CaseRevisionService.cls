public with sharing class CaseRevisionService {

    @AuraEnabled(cacheable=true)
    public static String getRevisions(String caseSfid) {

        Http http = new Http();
        HttpRequest req = new HttpRequest();

        String endpoint =
        'https://experian-new-staging-app-559744ea1fae.aloe-mumbai.herokuapp.com/api/cic-requests/case-revisions/external'
        + '?caseSfid=' + EncodingUtil.urlEncode(caseSfid, 'UTF-8');

        req.setEndpoint(endpoint);
        req.setMethod('GET');

        // Optional security header
        req.setHeader('x-api-key', 'your-secret-key');
        req.setHeader('Content-Type', 'application/json');

        HttpResponse res = http.send(req);

        return res.getBody();
    }
}