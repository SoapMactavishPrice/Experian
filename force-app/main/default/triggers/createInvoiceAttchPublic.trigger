trigger createInvoiceAttchPublic on ContentVersion (after insert) {

      List<ContentVersion> lstAttachementTobeRestricted = new List<ContentVersion>();
    
    Map<Id, Id> MapcontentdocumenId  = new Map<Id, Id>();
    for(ContentVersion cv : trigger.new){
        
        MapcontentdocumenId.put(cv.ContentDocumentId, cv.Id); 
        system.debug('****'+cv.ContentDocumentId);


    } 

    Set<Id> setentityId  = new Set<Id>();

    Map<Id, ContentDistribution> listcd = new Map<Id,ContentDistribution>();

    if(MapcontentdocumenId.size()>0){
        for(ContentDocumentLink cdl : [SELECT Id, LinkedEntityId,ContentDocumentId 
                                                From  ContentDocumentLink
                                                Where ContentDocumentId IN :MapcontentdocumenId.keyset()]){
            
            //String keyPrefix= Invoice__C.SObjectType.getDescribe().getKeyPrefix(); 
            
            String linkId = String.valueof(cdl.LinkedEntityId);
            
            system.debug('****'+linkId);
              
              //Check Invoice ID in Sandbox
              
              //if(linkId.startsWith('a06')){ 
              
              //Check Invoice ID in Prod
              
              if(linkId.startsWith('a02')){ 
                system.debug('****'+linkId);

                ContentDistribution cd = new ContentDistribution();
                cd.name = 'test';
                cd.ContentVersionId = MapcontentdocumenId.get(cdl.ContentDocumentId); 
                cd.PreferencesAllowViewInBrowser= true;
                cd.PreferencesLinkLatestVersion=true;
                cd.PreferencesNotifyOnVisit=false;
                cd.PreferencesPasswordRequired=false;
                cd.PreferencesAllowOriginalDownload= true;
                listcd.put(cd.Id,cd);

            } 
            
        }   
        
        if(listcd.size()>0){
            insert listcd.values();
            system.debug('****'+listcd);
        }
    }

    
}