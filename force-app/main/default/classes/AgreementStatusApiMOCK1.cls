global with sharing class AgreementStatusApiMOCK1 implements HTTPCalloutMock{
      public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('getSignatureStatus')) {
                try{
                String sta = 'OK';
                String Js = '{"status": "", "signer_info":[{"signature_sequence":"1"}]}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
                }Catch(Exception e){}
            }
            return null;
        }
}