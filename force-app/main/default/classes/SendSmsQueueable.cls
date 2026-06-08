public class SendSmsQueueable implements Queueable, Database.AllowsCallouts {

    private Set<Id> csIds;
    private String mtType;

    public SendSmsQueueable(Set<Id> ids, String type) {
        this.csIds = ids;
        this.mtType = type;
    }

    public void execute(QueueableContext qc) {
        SendSmsOnextel.sendSMSBatch(csIds, mtType);
    }
}