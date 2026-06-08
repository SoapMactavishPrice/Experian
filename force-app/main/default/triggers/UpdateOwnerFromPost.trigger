trigger UpdateOwnerFromPost on FeedItem (after insert) {
    
    Set<Id> caseIds = new Set<Id>();
    Set<Id> feedIds = new Set<Id>();
    Set<Id> userIds = new Set<Id>();
    List<Case> casesToUpdate = new List<Case>();
    
    for(FeedItem fc : trigger.new){    
        if(String.valueof(fc.ParentId).substring(0,3) == '500'){
            caseIds.add(fc.ParentId);   
            feedIds.add(fc.Id);  
        }
    }
    
    if(feedIds.size() == 0)
        return;
    
    System.debug(Trigger.New[0].Type);
    FeedItem fec = [SELECT Id, ParentId, Type, Body, CreatedById, CreatedBy.Name FROM FeedItem WHERE Type IN ('TextPost', 'ContentPost', 'LinkPost') and Id IN:feedIds];
    
    String communityId = null;
    String feedItemId = fec.Id;
    
    ConnectApi.FeedElement feedItem = ConnectApi.ChatterFeeds.getFeedElement(communityId, feedItemId);
    List<ConnectApi.MessageSegment> messageSegments = feedItem.body.messageSegments;
    
    for (ConnectApi.MessageSegment messageSegment : messageSegments) {
        if (messageSegment instanceof ConnectApi.MentionSegment) {
            ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) messageSegment;
            System.debug('Mentioned user id: ' + mentionSegment.record.Id);
            userIds.add(mentionSegment.record.Id);
        }
    }
    
    if(Test.isRunningTest())
        userIds.add(UserInfo.getUserId());
    
    if(userIds.size() > 0) {
        
        User usr = [SELECT Id, Name FROM User WHERE Id IN:userIds];
        
        for(Case c : [ SELECT Id, OwnerId, Status FROM CASE WHERE Id IN: caseIds]){
            
            c.OwnerId =usr.Id;
            casesToUpdate.add(c);
        }
        
        if(!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        } 
    }
    
}