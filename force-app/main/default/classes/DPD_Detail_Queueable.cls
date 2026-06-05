public class DPD_Detail_Queueable implements Queueable {

    private Set<Id> recordIds;

    public DPD_Detail_Queueable(Set<Id> recordIds) {
        this.recordIds = recordIds;
    }

    public void execute(QueueableContext context) {

        List<DPD_Detail__c> records = [
            SELECT Id,
                   DPD_External_Id__c,
                   Correct_EMI_Repayment_Year__c,
                   Displayed_EMI_Repayment_Year__c,
                   Displayed_EMI_Repayment_Month__c,
                   Correct_EMI_Repayment_Month__c
            FROM DPD_Detail__c
            WHERE Id IN :recordIds
        ];

        List<DPD_Detail__c> recordsToUpdate = new List<DPD_Detail__c>();

        for (DPD_Detail__c record : records) {
            if (String.isBlank(record.DPD_External_Id__c)) {

                record.DPD_External_Id__c = record.Id;
                record.Displayed_EMI_Repayment_Year__c = record.Correct_EMI_Repayment_Year__c;
                record.Correct_EMI_Repayment_Month__c = record.Displayed_EMI_Repayment_Month__c;

                recordsToUpdate.add(record);
            }
        }

        if (!recordsToUpdate.isEmpty()) {
            update recordsToUpdate;
        }
    }
}