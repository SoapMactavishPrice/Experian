@isTest
public class TestAccessTokenMockError implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{"access_token": "test_access_token","errorString":"SYS100005(Mandatory field missing)"}');
        return res;
    }
    
     
}