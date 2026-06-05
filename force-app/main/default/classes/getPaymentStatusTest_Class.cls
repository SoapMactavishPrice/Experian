@IsTest
public class getPaymentStatusTest_Class{

    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('Request')) {
                String sta = 'OK';
                String Js = '{"RPPData": [{"TranStatusDescription":"Success","Amount":9}]}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
            
             
            return null;
        }
    }
    private class Mock1 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (req.getEndpoint().endsWith('Request')) {
                String sta = 'OK';
                String Js = '{"RPPData": [{"TranStatusDescription":"Pending","Amount":9}]}';
                
                HttpResponse res = new HttpResponse();
                res.setBody(Js);
                res.setStatusCode(200);
                res.setStatus(sta);
                return res;
            }
            
             
            return null;
        }
    }
   public static testMethod void validate(){
   
     Lead l=new Lead();
     l.LastName='Test';
     l.Status='Payment';
     l.Pay_Later_RequestId__c='ASDFR';
     l.EBS_Payment_Status__c='Rejected';
     
     insert l;
     Test.startTest(); 
     Test.setMock(HttpCalloutMock.class, new Mock());
     Database.executeBatch(new getPaymentStatus());
     
     Test.stopTest();
   }
    public static testMethod void validate2(){
   
     Lead l=new Lead();
     l.LastName='Test';
     l.Status='Payment';
     l.Pay_Later_RequestId__c='ASDFR';
     l.EBS_Payment_Status__c='Rejected';
     
     insert l;
     Test.startTest(); 
     Test.setMock(HttpCalloutMock.class, new Mock1());
     Database.executeBatch(new getPaymentStatus());
     
     Test.stopTest();
   }
}