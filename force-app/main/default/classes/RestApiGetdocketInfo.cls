public class RestApiGetdocketInfo {

    
    public static String get_pdf_content(String id){
        String pdf_content='';
        
        List<Lead> ld = [Select Id, LegalDesk_Agreement_Document_Id__c ,Legal_desk_docket_id__c
                                         from Lead
                                         Where Id =: id];
        
         String get_docket_URL = system.label.getdocket_info;
        system.debug('****  get_docket_URL'+get_docket_URL);
        system.debug('****  ld.size '+ld.size());
        if(ld.size() > 0){
            Map<String, Object> mapagrrementFinal = new Map<String, Object>();  
        	mapagrrementFinal.put('docket_id', ld[0].Legal_desk_docket_id__c);
            mapagrrementFinal.put('document_id', ld[0].LegalDesk_Agreement_Document_Id__c);
            
            String js = JSON.serialize(mapagrrementFinal);
            
            HttpRequest req = new HttpRequest();
            HttpResponse res  = new HttpResponse();
            Http http = new Http();
            req.setMethod('POST');
            req.setHeader('X-Parse-Rest-Api-Key', system.label.Legal_Desk_Username_Auth);
            req.setHeader('X-Parse-Application-Id', system.label.Legal_Desk_Auth_ID); 
            req.setHeader('Content-Type', 'application/json');
            req.setBody(js);
            
            req.setEndpoint(get_docket_URL);
            System.debug('Input Request:' + js);
            
             try{
                res = http.send(req);
                system.debug('***Response'+ res.getBody());
                JSON2ApexGetDocketInfo japx =  JSON2ApexGetDocketInfo.parse(res.getBody());
                 
                 if(japx.status == 'success'){
                     pdf_content=japx.docket_Info[0].content;
                    /* Attachment att = new Attachment(
                ParentId = id,
                Body = EncodingUtil.Base64Decode(japx.docket_Info[0].content),
                Name = 'Agreement Test pdf_',
                ContentType = 'application/pdf'
            );
                insert att;*/
                 }
            }
            Catch(System.CalloutException e){
                System.debug('Callout error '+ e.getMessage());
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error'+e.getMessage()));
            }
            
        }
        
       return  pdf_content;
    }
    
    public class JSON2ApexGetDocketInfo {

	public String status;
	public String error;
	public String error_code;
	public String message;
	public List<Docket_Info> docket_Info;

    }
	public class Docket_Info {
		public String content;
		public String content_type;
		public String document_id;
	}

	public static JSON2ApexGetDocketInfo parse(String json) {
		return (JSON2ApexGetDocketInfo) System.JSON.deserialize(json, JSON2ApexGetDocketInfo.class);
	}

}