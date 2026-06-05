trigger SendMembershipCertificate on Account (after update) {
    
    if(Trigger.isUpdate && Trigger.isAfter ){
        
        Set<ID> InvIDs = new Set<ID>(); 
        Set<ID> accID = new Set<ID>(); 
        
        for(Account pa:trigger.new){  
            if(pa.Subscriber_ID__c !=null && pa.Certificate_Email_Sent__c ==false){ // removed Sub_Code__c on 01/08/2022
                InvIDs.add(pa.Id);
            }
            else if(pa.Name !=null){
                accID.add(pa.Id);
            }
        }
        
        If(InvIDs.size()>0){
            system.debug('inside if InvIDs----');
            if(!System.isFuture() && !System.isBatch()){
                system.debug('inside future InvIDs----');
                SendMembershipCertificate.SendEmail(InvIDs);
            }
        }
        If(accID.size()>0){
            system.debug('inside if accID ----');
            if(!System.isFuture() && !System.isBatch()){
                system.debug('inside future accID----');
                TrackOldAccountName.UpdateOldAccountName(accID);
            }
        }
    }  
}