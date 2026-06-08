trigger SendMembershipRenewalCertificateTrigger on Membership_Renewal__c (after insert) {
    
    if(Trigger.isInsert && Trigger.isAfter ){
        
        Set<ID> InvIDs = new Set<ID>(); 
        
        for(Membership_Renewal__c pa:trigger.new){  
            if(pa.Renewal_Payment_Received__c==true && pa.Renewal_Date__c !=null && pa.Certificate_Email_Sent__c ==false){
                InvIDs.add(pa.Id);
            }
        }
        
        If(InvIDs.size()>0){
            system.debug('inside if InvIDs----');
            if(!System.isFuture() && !System.isBatch()){
                system.debug('inside future InvIDs----');
                SendMembershipRenewalCertificate.SendEmail(InvIDs);
            }
        }
    }  
}