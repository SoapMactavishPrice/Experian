global class getPaymentStatus implements Database.Batchable < sObject > , Database.AllowsCallouts{
    public String referanceId;
    public String currentDate;

    public getPaymentStatus(){
        referanceId = datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''); 
        currentDate = datetime.now().formatGMT('yyyy-MM-dd');
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String request_id='';
        String Rej='Rejected';
        String Pay='Payment';
       
        String query = 'SELECT Name,Email,Pay_Later_RequestId__c,Bank_Name__c,Company,EBS_Payment_Status__c,Id,Mode_of_Transaction__c,Payment_Date_Time__c,RBI_Certificate_Verified__c,Total_Payment_Received__c,Transaction_Id__c FROM Lead WHERE Status = \'' + String.escapeSingleQuotes(Pay)+'\' AND Pay_Later_RequestId__c != \'' + String.escapeSingleQuotes(request_id)+'\' AND (EBS_Payment_Status__c = Null OR EBS_Payment_Status__c = \''+ String.escapeSingleQuotes(Rej)+'\')';
        
        System.debug('----------->Database.QueryLocator start '+query);
        return Database.getQueryLocator(query);     
    }
    global void execute(Database.BatchableContext BC, List < Lead > lead_list) {
        Map<String,Double> m_up=new Map<String,Double>();   
        Map<String,String> m_status=new Map<String,String>();   
        Set<String> tran_id_sucess=new Set<String>();                     
        Set<String> tran_id_pending=new Set<String>();                     
        String pay_URL = system.label.uat_payment_gateway_url;
        System.debug('=============----->'+lead_list.size());
        System.debug('=============----->'+lead_list);

        System.debug('=============----->'+pay_URL);
                                
         for(Lead ld : lead_list){ 

                                                //Final Map
                 Map<String, Object> map_rpp_pay_Final = new Map<String, Object>();  

                 //RPPRequired 
                Map<String, Object> map_rpp_required = new Map<String, Object>();  
                map_rpp_required.put('Token', ld.Transaction_Id__c);
                 map_rpp_required.put('UniqueID', 0);
                 map_rpp_required.put('Hashcode','');
                 map_rpp_required.put('RequestType','pulltranstatus');
                 map_rpp_required.put('TxnType','');
                 map_rpp_required.put('MerchantMID',system.label.merchant_mid);
                 map_rpp_required.put('MerchantID',system.label.merchant_id);
                 map_rpp_required.put('MerchantName',system.label.merchant_name);
                 // map_rpp_required.put('MerchantEmailMobile',system.label.merchant_email);
                 map_rpp_required.put('MerchantEmailMobile','');
                 map_rpp_required.put('Aspid','');
                 map_rpp_required.put('AspMasterID',0);
                 map_rpp_required.put('ChannelName','');
                 map_rpp_required.put('ChannelTypeName','');
                 map_rpp_required.put('IPAddress','');

                 //RPPRequired 
                 Map<String, Object> map_rpp_response = new Map<String, Object>();  
                 map_rpp_response.put('ErrorCode', '');
                 map_rpp_response.put('ErrorDescription', '');

                 Map<String, Object> map_rpp_data = new Map<String, Object>();  
                 map_rpp_data.put('CustomerName', ld.name);
                 map_rpp_data.put('CustomerEmailMobile', ld.email);
                 //map_rpp_data.put('CustomerAlternateEmailMobile', ld.mobile);
                // map_rpp_data.put('Amount', amount);
                 map_rpp_data.put('NoteFromMerchant', 'TestRPPNote5-12');
                 map_rpp_data.put('InvoiceNo', 'INV111');
                 map_rpp_data.put('DistributerIdentifier', 'DISTId');
                 map_rpp_data.put('AgentName', '');
                 map_rpp_data.put('AgentMobileNo', '');
                 //map_rpp_data.put('CustomerIdentifier', 'Customer Id');
                 map_rpp_data.put('CustomerIdentifier', ld.Id);
                 map_rpp_data.put('ProductIdentifier', 'product Name');
                 map_rpp_data.put('CartDetails', '');
                 map_rpp_data.put('InvoiceAmount', '');
                 map_rpp_data.put('InvoiceDiscountAmount', '');
                 map_rpp_data.put('InvoiceSurchargeAmount', '');
                 map_rpp_data.put('AutoDebit', false);
                 map_rpp_data.put('AccountHolderName', '');
                 map_rpp_data.put('StartDate', '');
                 map_rpp_data.put('EndDate', '');
                 map_rpp_data.put('MaxAmount', '');
                 map_rpp_data.put('Frequency', '');
                 map_rpp_data.put('AmountType', '');
                 map_rpp_data.put('AccountType', '');
                 map_rpp_data.put('BillDate', '');
                 map_rpp_data.put('ConsumerCD', '');
                 map_rpp_data.put('IFSCCode', '');
                 map_rpp_data.put('BankCode', '');
                 map_rpp_data.put('AccountNo', '');
                 map_rpp_data.put('ResendNotificationFlag', '');
                 map_rpp_data.put('RequestID', ld.Pay_Later_RequestId__c);
                 map_rpp_data.put('MerchantTXNID', '');
                 map_rpp_data.put('ImageName', '');
                 map_rpp_data.put('Image', '');
                 map_rpp_data.put('NotificationTemplateName', '');
                 map_rpp_data.put('additionalParameter1', '');
                 map_rpp_data.put('additionalParameter2', '');
                 map_rpp_data.put('additionalParameter3', '');
                 map_rpp_data.put('additionalParameter4', '');
                 map_rpp_data.put('additionalParameter5', '');

                 List<Object> map_rpp_data_line_item=new List<Object>();
                 map_rpp_data_line_item.add(map_rpp_data);

                 map_rpp_pay_Final.put('RPPRequired', map_rpp_required);
                 map_rpp_pay_Final.put('RPPResponse', map_rpp_response);
                 map_rpp_pay_Final.put('RPPData', map_rpp_data_line_item);

                 String js = JSON.serialize(map_rpp_pay_Final);

                 HttpRequest req = new HttpRequest();
                 HttpResponse res  = new HttpResponse();
                 Http http = new Http();
                 req.setMethod('POST');
                 req.setHeader('Content-Type', 'application/json');
                 req.setBody(js);
                 req.setEndpoint(pay_URL);
                 System.debug('Input Request:' + js);

                 try{
                     res=http.send(req);
                     system.debug('***Response'+ res.getBody());
                     JSON2ApexPaymentGateway JPG=JSON2ApexPaymentGateway.parse(res.getBody()); 

                      if(JPG.RPPData[0].TranStatusDescription == 'Success')
                      {
                         
                            Double get_amount=JPG.RPPData[0].Amount;
                            m_up.put(ld.Transaction_Id__c, get_amount);
                            tran_id_sucess.add(ld.Transaction_Id__c);    
                      }else{
                            m_status.put(ld.Transaction_Id__c, JPG.RPPData[0].TranStatusDescription);
                            tran_id_pending.add(ld.Transaction_Id__c);   
                      }

                 }catch(Exception e){
                     System.debug('exception=============>>'+e.getMessage()+'---->'+e.getStackTraceString());
                   
                 } 
                                               
         } 
         System.debug('tran_id_sucess size()'+tran_id_sucess);
         System.debug('tran_id_sucess size()'+tran_id_sucess.size());
         List<Lead> l_set=[SELECT Id,Payment_Date_Time__c,Pay_later_Status__c,EBS_Payment_Status__c,Transaction_Id__c FROM Lead WHERE Transaction_Id__c IN :tran_id_sucess];
         List<Lead> l_list_up=new List<Lead>();
         for(Lead l:l_set){
            Lead l_upd=new Lead();
            l_upd.Id=l.Id;
            l_upd.EBS_Payment_Status__c='Approved';
            l_upd.Transaction_Id__c=l.Transaction_Id__c;
            l_upd.Total_Payment_Received__c=m_up.get(l.Transaction_Id__c);
            l_upd.Pay_later_Status__c='Success';
            l_upd.Payment_Date_Time__c=System.now();
            l_list_up.add(l_upd);
         }
        System.debug('l_list_up '+l_list_up);
       
        List<Lead> l_set_pending=[SELECT Id,EBS_Payment_Status__c,Transaction_Id__c FROM Lead WHERE Transaction_Id__c IN :tran_id_pending];
        List<Lead> l_list_up_pending=new List<Lead>();
        for(Lead l:l_set_pending){
           Lead l_upd=new Lead();
           l_upd.Id=l.Id;
           l_upd.Transaction_Id__c=l.Transaction_Id__c;
           l_upd.Pay_later_Status__c=m_status.get(l.Transaction_Id__c);
           l_list_up_pending.add(l_upd);
        }

        System.debug('l_list_up_pending '+l_list_up_pending);
        upsert l_list_up_pending;

        upsert l_list_up;

       
    }

     // Finish Method
    
     global void finish(Database.BatchableContext BC) {
        
    }
                
          
}