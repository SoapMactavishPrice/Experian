public with sharing class AgreementVFController {

    public Lead leadRecord {get;set;}

    public AgreementVFController() {

        Id leadId = ApexPages.currentPage()
            .getParameters()
            .get('leadId');

        if(leadId != null){

            leadRecord = [
                SELECT Id,
                       Company,
                       Billing_Street__c,
                       Email,
                       Phone,
                       Name,
                       FirstName,
                        LastName,
                        Title
                FROM Lead
                WHERE Id = :leadId
                LIMIT 1
            ];
        }
    }
}