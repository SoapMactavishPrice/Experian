@isTest
public class UpdateAccountwithFiles_Test {
    
    @isTest
    public static void validate(){
        Account acc = new Account();
        acc.Name = 'Finesse';
        acc.Certificate_Email_Sent__c=false;
        insert acc;
        
        string file ='data:text/csv;base64,Q3VzdG9tZXIgQ29kZSxDdXN0b21lciBOYW1lLEJpbGxpbmcgQWRkcmVzcyxTaGlwcGluZyBBZGRyZXNzLEdTVElOLFBBTixQdXJjaGFzZSBPcmRlciBObyxQdXJjaGFzZSBPcmRlciBEYXRlLFByb2R1Y3QgSXRtZSBDb2RlLEl0ZW0gRGVzY3JpcHRpb24sU2l6ZSxRdWFudGl0eSxSYXRlLERpc2NvdW50ICUsVG90YWwgT3JkZXIgVmFsdWUsRGVsaXZlcnkgRGF0ZSxDZXJ0aWZpY2F0aW9uIFJlcXVpcmVkLEluc3BlY3Rpb24sSUJSLFBhY2tpbmcgJiBGb3J3YXJkaW5nLEdTVCUsTW9kZSBPZiBkaXNwYXRjaCxQYXltZW50IFRlcm1zLEZyZWlnaHQsT3JkZXIgRGl2aXNpb24sT3JkZXIgQnJhbmNoLFNhbGVzIEVuZ2luZWVyIE5hbWUsQnJhbmNoIFBsYW50LEN1cnJlbmN5LENvbnNpZ25lZSBjb2RlLExEIGNsYXVzZSxQYXJ0IGRlbGl2ZXJ5IHBlcm1pdHRlZCxQYWNraW5nIE1vZGUsY3VzdG9tZXIgaXRlbSBjb2RlLFVPTSxDdXN0b21lciB0YWcgbm8sQ29taXNzaW9uJSxTYWxlcyBFbmdpbmVlciBzaGFyZSAlLFJlbWFya3MKLENGQkMgSU5ESUEsIlZpbGxhZ2UgTW9ubm4sIiwiVmlsbGFnZSBNb25ubiwiLDEyMzQ1Njc4OTAxMjM0NSwsd2UxMiwyMDIyLTA4LTI2IDAwOjAwOjAwLCxVS0wgRXhwYW5kZWQgUFRGRSBTaGVldCBHcmFkZSBVS0wgU09GVENIRU0uIFNoZWV0IFNpemUgMTUwMG1teDE1MDBtbS4sLDEyLjAwLDM2MDEwMjAuMDAsLDQzMzQxODcuNjgsLCwsLDcyMDIwLjQwLDE4JSwsMTAwJSBhZ2FpbnN0IHByb2Zvcm1hIGludm9pY2UgcHJpb3IgdG8gZGlzcGF0Y2gsRXh0cmEgYXQgYWN0dWFsIGluIGJ1eWVycyBzY29wZSxGU0QsRGVsaGksLCxJTlIsMTAwJSBhZ2FpbnN0IHByb2Zvcm1hIGludm9pY2UgcHJpb3IgdG8gZGlzcGF0Y2gsLCwsLE5PLiwsLCwsCg==';
        
        List<Map<String,string>> mapList = new List<Map<String,string>>();
        Map<String,string> filestr = new  Map<String,string>();
        filestr.put('filename','testla');
        filestr.put('fileExtension','Order_CSV_0025_1.csv');
        filestr.put('fileContent',file);
        mapList.add(filestr);
        UpdateAccountwithFiles.updateaccount(acc.Id,'testa',JSON.serialize(mapList));
        
    }
}