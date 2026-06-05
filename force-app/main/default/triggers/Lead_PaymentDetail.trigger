trigger Lead_PaymentDetail on Lead (before update,after update, after insert) {
    
    if(Trigger.IsBefore){
        
        Profile pr= [Select Id,Name from Profile where Name ='System Administrator'];
        
        for(Lead ld : Trigger.new){
            if(Trigger.OldMap.get(ld.Id).Status == 'Rejected' && UserInfo.getProfileId() != pr.Id ){
                ld.addError('Once lead is Rejected, no one can update the record except the System Administrator.');
            } 
        }
    }
    
    if(Trigger.IsAfter){
        
        Set<id> lset = new Set<id>();
        List<Lead_Payment_Detail__c> lpayList = new List<Lead_Payment_Detail__c>();
        
        String UserName = UserInfo.getName();
        String UserEmail = UserInfo.getUserEmail();
        
        for (Lead l : Trigger.new) {
            
            if(l.Status =='New'){
                
                List<Product__c> pList= [SELECT id, Name FROM Product__c WHERE Fee_Plan_Type__c = 'Fixed'];
                
                if([Select id from Lead_Payment_Detail__c where Lead__c =:l.id].Size() == 0 || 
                   [Select id from Lead_Payment_Detail__c where Lead__c =:l.id].Size() == null) {
                       
                       for(Product__c p:pList){
                           Lead_Payment_Detail__c lp = new Lead_Payment_Detail__c();
                           lp.Product__c = p.id;
                           lp.Lead__c = l.id;
                           lpayList.add(lp);
                       }
                   } 
            }
            
            If(l.Status=='Sent for Agreement' && !l.Sent_for_Agreement__c){
                //here call the apex class for call the aggrement api
                system.debug('****'+l.Payment_Status__c);
                
                String billing_address=l.Billing_Street__c+','+l.Billing_City__c+','+l.Billing_Zip_Postal_Code__c+','+l.Billing_State__c+','+l.Billing_Country__c;
                
                if(!System.isFuture() && !System.isBatch()){
                    if(!Test.isRunningTest()){
                        AgreementAPiRESTController.save_pdf_in_attachment(l.Billing_Contact_Person__c,l.Billing_Contact_Details__c,l.Billing_Job_Title__c,l.Company,l.FirstName+' '+l.LastName,l.Billing_Job_Title__c,l.Phone,l.Email,l.Billing_Email_Address__c,billing_address,l.GST_No__c,l.Id,l.Nodal_Officer_Name__c,l.Official_Email_Address_Nodal__c,l.Tel_No_Nodal__c,l.Billing_Street__c,l.Billing_City__c,l.Billing_Zip_Postal_Code__c,l.Billing_State__c,l.Billing_Country__c,l.First_Name_Auth_Usr_Req__c,l.Last_Name_Auth_Usr_Req__c,l.Job_Title_Auth_Usr_Req__c,l.Official_Email_Auth_Usr_Req__c,l.Tel_No_Auth_Usr_Req__c,l.First_Name_AuSig__c,l.Last_Name_AuSig__c,l.Job_Title_AuSig__c,l.Tel_No_AuSig__c,l.Official_Email_Address_AuSig__c);
                    }
                }
            }  
            
            if(l.Send_Proposal__c ==true && l.Proposal_Email_Sent__c ==false){
                
                EmailMessage em=new EmailMessage();
                em.Subject=' Proposal Email Sent';
                em.Lead__c=l.id;  
                em.ToAddress=l.Email;
                em.CcAddress=l.Owner.Email;
                em.MessageDate=system.now();
                em.Incoming=false;
                em.Status='3';
                em.FromAddress=UserEmail;
                em.FromName=UserName;
                insert em;
            }
        } 
        
        if(lpayList.size() > 0){
            insert lpayList;
        }
    }
}