public class IntegrationHandlerQueueable implements Queueable, Database.AllowsCallouts {

    private Set<Id> caseIds;
    private Map<Id,String> mpCaseIds;

    public IntegrationHandlerQueueable(Set<Id> caseIds, Map<Id,String> mpCaseIds){
        this.caseIds = caseIds;
        this.mpCaseIds = mpCaseIds;
    }

    public void execute(QueueableContext qc){
        IntegrationHandler.getAccessToken1(caseIds, mpCaseIds);
    }
}