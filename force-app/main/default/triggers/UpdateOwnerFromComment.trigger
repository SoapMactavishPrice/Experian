trigger UpdateOwnerFromComment on FeedComment (after insert) {
    
    Set<Id> caseIds = new Set<Id>();
    Set<Id> feedIds = new Set<Id>();
    Set<Id> commIds = new Set<Id>();
    List<Case> casesToUpdate = new List<Case>();
    
    for(FeedComment fc : trigger.new){    
        if(String.valueof(fc.ParentId).substring(0,3) == '500'){
            caseIds.add(fc.ParentId);   
            commIds.add(fc.Id); 
            feedIds.add(fc.FeedItemId);
        } 
    }
    
    FeedComment fc = [SELECT Id, ParentId, CommentType, CreatedById FROM FeedComment WHERE CommentType='TextComment' and Id IN:commIds];
    
    FeedItem fec = [SELECT Id, ParentId, Type, Body, CreatedById FROM FeedItem WHERE Id IN:feedIds];
    
    for(Case c : [ SELECT Id, OwnerId, Status FROM CASE WHERE Id IN: caseIds]){
        
        c.OwnerId=fec.CreatedById;
        casesToUpdate.add(c);
    }
    
    if(!casesToUpdate.isEmpty()) {
        update casesToUpdate;
    } 
    
}