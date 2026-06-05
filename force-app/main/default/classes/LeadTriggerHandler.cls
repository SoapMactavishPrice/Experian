public class LeadTriggerHandler {
    
    public static void createMembershipDocuments(List<Lead> leads) {
        
        List<Membership_Document__c> docsToInsert = new List<Membership_Document__c>();
        
        List<String> documentNames = new List<String>{
            'PAN Card',
                'GST Certificate',
                'Company Incorporation Certificate',
                'RBI / SEBI / IRDAI / TRAI Certificate',
                'Authorised Signatory PAN',
                'Authorised Sign Authorization Letter'
                };
                    
                    for (Lead ld : leads) {
                        for (String docName : documentNames) {
                            docsToInsert.add(new Membership_Document__c(
                                Lead__c = ld.Id,
                                Document_Name__c = docName
                            ));
                        }
                    }
        
        if (!docsToInsert.isEmpty()) {
            insert docsToInsert;
            
            // Update External_ID__c with Membership_Document__c Id
            for (Membership_Document__c doc : docsToInsert) {
                doc.External_ID__c = doc.Id;
            }
            
            update docsToInsert;
        }
    }
}