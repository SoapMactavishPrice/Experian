public class ProcessDMLQueueable implements Queueable, Database.AllowsCallouts {
    private List<Case> caseList;
    private List<API_LOG__c> apiLogList;
    private Map<String,ContentVersion> mpContentversion;
    private Set<Id> caseIds;

    public ProcessDMLQueueable(List<Case> caseList,Map<String,ContentVersion> mpContentversion, List<API_LOG__c> apiLogList,Set<Id> caseIds) {
        this.caseList = caseList;
        this.apiLogList = apiLogList;
        this.mpContentversion = mpContentversion;
        this.caseIds = caseIds;
    }

    public void execute(QueueableContext context) {
        if(caseList.size()>0){
            UPDATE caseList;
        }
        
        //Insert apiLogList; 
        if(mpContentversion.keySet().size()>0){
            UPSERT mpContentversion.values();
        }
        for(Case cs:caseList){
            if(mpContentversion.get(cs.Id)!=null){
                // Link ContentDocument to Case
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :mpContentversion.get(cs.Id).Id LIMIT 1].ContentDocumentId;
                cdl.LinkedEntityId = cs.Id;
                cdl.ShareType = 'V';
                cdl.Visibility = 'AllUsers';
                insert cdl;
                
                // Generate ContentDistribution
                ContentDistribution contentDist = new ContentDistribution(
                    Name = 'CreditReport',
                    ContentVersionId = mpContentversion.get(cs.Id).Id,
                    PreferencesAllowViewInBrowser= true,
                    PreferencesLinkLatestVersion=true,
                    PreferencesNotifyOnVisit=false

                );
                insert contentDist;
                
                ContentDistribution cd=[SELECT Id, Name, ContentDownloadUrl,ContentDocumentId, DistributionPublicUrl FROM ContentDistribution WHERE Id=:contentDist.Id];
                
               cs.Credit_Report_Link__c=cd.ContentDownloadUrl;
            }
        }
        UPDATE caseList;
        List<Case> caseRecord = new List<Case>();
           caseRecord= [SELECT Credit_Report_Generation_Date__c,Is_Error__c FROM Case WHERE Id IN:caseIds AND Is_Error__c=false];
         for(Case cs:caseRecord){
             cs.Credit_Report_Generation_Date__c=date.today();
         }
         UPDATE caseRecord;
    }
}