public without sharing class PPACUserObservationController {

    @AuraEnabled(cacheable=true)
    public static ResponseWrapper getObservationDetails(
        Id observationId
    ){

        ResponseWrapper wrapper =
            new ResponseWrapper();

        PPAC_Observations__c currentObs = [

            SELECT Id,
                Observation__c,
                PPAC_Approving_Authorities__r.PPAC__r.PPAC_ID__c,
                PPAC_Approving_Authorities__r.PPAC__r.Name,
                PPAC_Approving_Authorities__r.PPAC__r.Sub_Category__c,
                PPAC_Approving_Authorities__r.PPAC__r.CreatedBy.Name,
                PPAC_Approving_Authorities__c

            FROM PPAC_Observations__c

            WHERE Id = :observationId

            LIMIT 1
        ];

        wrapper.ppacId =
            currentObs
            .PPAC_Approving_Authorities__r
            .PPAC__r
            .PPAC_ID__c;

        wrapper.ppacName =
            currentObs
            .PPAC_Approving_Authorities__r
            .PPAC__r
            .Name;

        wrapper.subCategory =
            currentObs
            .PPAC_Approving_Authorities__r
            .PPAC__r
            .Sub_Category__c;

        wrapper.submittedBy =
            currentObs
            .PPAC_Approving_Authorities__r
            .PPAC__r
            .CreatedBy.Name;

        wrapper.currentObservation =
            currentObs.Observation__c;

        wrapper.observations = [

            SELECT Id,
                Observation__c,
                User_Comment__c,
                CreatedDate

            FROM PPAC_Observations__c

            WHERE PPAC_Approving_Authorities__c =
                :currentObs.PPAC_Approving_Authorities__c

            ORDER BY CreatedDate
        ];

        return wrapper;
    }

    public class ResponseWrapper {

        @AuraEnabled
        public String ppacId;

        @AuraEnabled
        public String ppacName;

        @AuraEnabled
        public String subCategory;

        @AuraEnabled
        public String submittedBy;

        @AuraEnabled
        public String currentObservation;

        @AuraEnabled
        public List<PPAC_Observations__c> observations;
    }


    @AuraEnabled
    public static void submitResponse(
        Id observationId,
        String response
    ){

        update new PPAC_Observations__c(

            Id = observationId,

            User_Comment__c = response
        );

        sendResponseToApprover(observationId);
    }



    private static void sendResponseToApprover(
        Id observationId
    ){
        
        PPAC_Observations__c obs = [

            SELECT Id,
                Observation__c,
                User_Comment__c,

                PPAC_Approving_Authorities__r.Id,

                PPAC_Approving_Authorities__r.Approving_Authority__r.Name,

                PPAC_Approving_Authorities__r.Approving_Authority__r.Email__c,

                PPAC_Approving_Authorities__r.PPAC__r.Name,

                PPAC_Approving_Authorities__r.PPAC__r.PPAC_ID__c

            FROM PPAC_Observations__c

            WHERE Id = :observationId
        ];


        List<OrgWideEmailAddress> oweaList = [
            SELECT Id
            FROM OrgWideEmailAddress
            WHERE Address =
                'consumer.support@in.experian.com'
            LIMIT 1
        ];

        Id oweaId =
            oweaList.isEmpty()
            ? null
            : oweaList[0].Id;

        String reviewLink =

            Label.PPAC_Approver_Site_URL

            + '/PPACReview/apex/PPACApproverReview'

            + '?id='

            + obs
            .PPAC_Approving_Authorities__r
            .Id;

        Messaging.SingleEmailMessage mail =
            new Messaging.SingleEmailMessage();

        if(oweaId != null){

            mail.setOrgWideEmailAddressId(
                oweaId
            );
        }

        mail.setToAddresses(

            new List<String>{

                obs
                .PPAC_Approving_Authorities__r
                .Approving_Authority__r
                .Email__c
            }
        );

        mail.setSubject(

            'Response Submitted for PPAC Observation – '

            + obs
            .PPAC_Approving_Authorities__r
            .PPAC__r
            .PPAC_ID__c

            + ' '

            + obs
            .PPAC_Approving_Authorities__r
            .PPAC__r
            .Name
        );

        String body =

        'Dear '

        + obs
        .PPAC_Approving_Authorities__r
        .Approving_Authority__r
        .Name

        + ',\n\n'

        + 'The user has submitted comments against your observation on the PPAC Note.\n\n'

        + 'Observation:\n'

        + '------------------------------------\n'

        + obs.Observation__c

        + '\n'

        + '------------------------------------\n\n'

        + 'User\'s Response:\n'

        + '------------------------------------\n'

        + obs.User_Comment__c

        + '\n'

        + '------------------------------------\n\n'

        + 'Please review the response and update the status.\n\n'

        + 'Access details here:\n'

        + reviewLink

        + '\n\n'

        + 'This is a system generated email.';

        mail.setPlainTextBody(
            body
        );

        Messaging.sendEmail(
            new List<Messaging.SingleEmailMessage>{
                mail
            }
        );


        /* Risk Team Notification */
        

    }


}