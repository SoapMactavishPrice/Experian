global class AgreementStatusApiController implements Database.Batchable < sObject > , Database.AllowsCallouts{
    public String referanceId;
    public String currentDate;

    public AgreementStatusApiController(){
        referanceId = datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''); 
        currentDate = datetime.now().formatGMT('yyyy-MM-dd');
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        
       
        //String query = 'SELECT  Id, LegalDesk_Agreement_Document_Id__c, Agreement_Experian_Status__c,  Agreement_Customer_Status_Stages__c from Lead Where Aggrement_API_Status__c <> \'Success\' AND LegalDesk_Agreement_Document_Id__c <> NULL AND IsConverted = false ';
        String query = 'SELECT  Id, LegalDesk_Agreement_Document_Id__c, Agreement_Experian_Status__c,  Agreement_Customer_Status_Stages__c from Lead Where LegalDesk_Agreement_Document_Id__c <> NULL AND IsConverted = false ';
        System.debug('----------->Database.QueryLocator start '+query);
        return Database.getQueryLocator(query);     
    }
    global void execute(Database.BatchableContext BC, List < Lead > lead_list) {

        System.debug('----------->execute1 '+lead_list);
        System.debug('----------->execute size '+lead_list.size());
         if(lead_list.size() > 0){
            List<String> document_id_Set = new List<String>();
            For(Lead c: lead_list){
                document_id_Set.add(c.LegalDesk_Agreement_Document_Id__c);
            }
            System.debug('----------->execute2 '+document_id_Set); 

          List<Lead> document_list_in_database = [Select Id, LegalDesk_Agreement_Document_Id__c, Agreement_Experian_Status__c,  Agreement_Customer_Status_Stages__c from Lead WHERE LegalDesk_Agreement_Document_Id__c IN:document_id_Set];
          System.debug('----------->execute3 '+document_list_in_database); 

          String loginURL = system.label.Legal_Desk_Agreement_Status;

         // Map<Id, Lead> updatelead = new Map<Id,Lead>();
           List<Lead> updatelead =new List<Lead>();

          for(Lead l:document_list_in_database){

            Map<String,Object> docIdMap = new Map<String, Object>();

            System.debug('----------->execute start in loop'+l.LegalDesk_Agreement_Document_Id__c); 

            docIdMap.put('document_id',l.LegalDesk_Agreement_Document_Id__c);
            String js = JSON.serialize(docIdMap);

            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setMethod('POST');
            req.setHeader('X-Parse-Rest-Api-Key', system.label.Legal_Desk_Username_Auth);
            req.setHeader('X-Parse-Application-Id', system.label.Legal_Desk_Auth_ID); 
            req.setHeader('Content-Type', 'application/json');
            req.setBody(js);
            req.setEndpoint(loginUrl);
            System.debug('Input Request:' + js);
    
            try{
                res = http.send(req);
                system.debug('***Response'+ res.getBody());
    
                JSON2ApexStatusAPi japx =  JSON2ApexStatusAPi.parse(res.getBody()); 
    
               // List<Lead> updatelead = new List<Lead>();
                
    
                if(japx.status == 'success'){
                    Lead ld = [Select Id, LegalDesk_Agreement_Document_Id__c, Agreement_Experian_Status__c,  Agreement_Customer_Status_Stages__c,Aggrement_API_Status__c from Lead Where LegalDesk_Agreement_Document_Id__c =: l.LegalDesk_Agreement_Document_Id__c]; 
    
                        for(Signer_info signinfo : japx.signer_info){
                            if(signinfo.signature_sequence == '1'){
                                ld.Agreement_Customer_Status_Stages__c = signinfo.status;
                            }
                            if(signinfo.signature_sequence == '2'){
                                ld.Agreement_Experian_Status__c = signinfo.status;
                            }
                        }
                       // ld.Aggrement_API_Status__c='Success'; 
                       // updatelead.put(ld.Id, ld);
                       updatelead.add(ld);
                    //System.debug('japx.document_id' + japx.document_id);
                }
                else {
                    Lead ld = [Select Id, LegalDesk_Agreement_Document_Id__c, Agreement_Experian_Status__c,  Agreement_Customer_Status_Stages__c,Aggrement_API_Status__c from Lead Where LegalDesk_Agreement_Document_Id__c =: l.LegalDesk_Agreement_Document_Id__c]; 
    
                            for(Signer_info signinfo : japx.signer_info){
                                if(signinfo.signature_sequence == '1'){
                                    ld.Agreement_Customer_Status_Stages__c = signinfo.status;
                                }
                                if(signinfo.signature_sequence == '2'){
                                    ld.Agreement_Experian_Status__c = signinfo.status;
                                }
                            } 
                            //ld.Aggrement_API_Status__c='In Progress'; 
                            updatelead.add(ld);
                          // updatelead.put(ld.Id, ld);
                } 
            }
            catch(System.CalloutException e){
    
                System.debug('Callout error Of Agreement StatusApi Controller : '+ e.getMessage());
            }
          }

         // update updatelead.values();
         update updatelead;
        }
    }

     // Finish Method
    
     global void finish(Database.BatchableContext BC) {
        
    }
    

   /* @future (callout=true)
    public static void SaveStatus(String DocumentId){

        AgreementAPiRESTController arc = new AgreementAPiRESTController (); 
        //----------Need to change URL
        String loginURL = system.label.Legal_Desk_Agreement_Status;
        //String loginURL ;

        Map<String,Object> docIdMap = new Map<String, Object>();
        docIdMap.put('document_id',DocumentId);

        String js = JSON.serialize(docIdMap);

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setMethod('POST');
        req.setHeader('X-Parse-Rest-Api-Key', system.label.Legal_Desk_Username_Auth);
        req.setHeader('X-Parse-Application-Id', system.label.Legal_Desk_Auth_ID); 
        req.setHeader('Content-Type', 'application/json');
        req.setBody(js);
        req.setEndpoint(loginUrl);
        System.debug('Input Request:' + js);

        try{
            res = http.send(req);
            system.debug('***Response'+ res.getBody());

            JSON2ApexStatusAPi japx =  JSON2ApexStatusAPi.parse(res.getBody()); 

            List<Lead> updatelead = new List<Lead>();
            

            if(japx.status == 'success'){
                Lead ld = [Select Id, LegalDesk_Agreement_Document_Id__c, Agreement_Experian_Status__c,  Agreement_Customer_Status_Stages__c
                                    from Lead
                                    Where LegalDesk_Agreement_Document_Id__c =: DocumentId]; 

                    for(Signer_info signinfo : japx.signer_info){
                        if(signinfo.signature_sequence == '1'){
                            ld.Agreement_Customer_Status_Stages__c = signinfo.status;
                        }
                        if(signinfo.signature_sequence == '2'){
                            ld.Agreement_Experian_Status__c = signinfo.status;
                        }
                    } 

                    updatelead.add(ld);
                //System.debug('japx.document_id' + japx.document_id);
            }
            else {
                Lead ld = [Select Id, LegalDesk_Agreement_Document_Id__c, Agreement_Experian_Status__c,
                        Agreement_Customer_Status_Stages__c
                        from Lead
                        Where LegalDesk_Agreement_Document_Id__c =: DocumentId];

                        for(Signer_info signinfo : japx.signer_info){
                            if(signinfo.signature_sequence == '1'){
                                ld.Agreement_Customer_Status_Stages__c = signinfo.status;
                            }
                            if(signinfo.signature_sequence == '2'){
                                ld.Agreement_Experian_Status__c = signinfo.status;
                            }
                        } 
                        updatelead.add(ld);
            } 
        }
        Catch(System.CalloutException e){

            System.debug('Callout error Of Login API: '+ e.getMessage());
        } 
    } */

    //
    // Generated by JSON2Apex http://json2apex.herokuapp.com/
    //

    public class JSON2ApexStatusAPi {

        public String status;
        public List<Signer_info> signer_info;
        //public Signer_info signer_info;

    }

        public class Signer_info {
            public String signer_id;
            public String signature_sequence;
            public String status;
        }

        
        public static JSON2ApexStatusAPi parse(String json) {
            return (JSON2ApexStatusAPi) System.JSON.deserialize(json, JSON2ApexStatusAPi.class);
        }
    
}