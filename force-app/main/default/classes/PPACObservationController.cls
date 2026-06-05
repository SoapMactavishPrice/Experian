public without sharing class PPACObservationController {

    @AuraEnabled(cacheable=true)
    public static ReviewWrapper getReviewData(Id assignmentId){
        ReviewWrapper wrapper =
            new ReviewWrapper();

        List<PPAC_Approving_Authorities__c> assignments = [
            SELECT Id,
                PPAC__c,
                PPAC__r.PPAC_ID__c,
                PPAC__r.Name,
                PPAC__r.Sub_Category__c,
                PPAC__r.CreatedBy.Name
            FROM PPAC_Approving_Authorities__c
            WHERE Id = :assignmentId
            LIMIT 1
        ];

        if(assignments.isEmpty()){
            throw new AuraHandledException(
                'Invalid Approver Link'
            );
        }

        PPAC_Approving_Authorities__c assignment =
        assignments[0];

        wrapper.ppacId =
            assignment.PPAC__r.PPAC_ID__c;

        wrapper.ppacName =
            assignment.PPAC__r.Name;

        wrapper.subCategory =
            assignment.PPAC__r.Sub_Category__c;

        wrapper.submittedBy =
            assignment.PPAC__r.CreatedBy.Name;

        wrapper.observations = [

            SELECT Id,
                Observation__c,
                User_Comment__c

            FROM PPAC_Observations__c

            WHERE PPAC_Approving_Authorities__c
                = :assignmentId

            ORDER BY CreatedDate
        ];

        return wrapper;
    }


    @AuraEnabled
    public static void createObservation(
        Id assignmentId,
        String observation
    ){

        PPAC_Observations__c obs =
            new PPAC_Observations__c(

                PPAC_Approving_Authorities__c =
                    assignmentId,

                Observation__c =
                    observation
            );

        insert obs;

        update new PPAC_Approving_Authorities__c(

            Id = assignmentId,

            Approval_Status__c =
                'Observation Raised'
        );

        sendObservationRaisedEmail(
            obs.Id,
            assignmentId
        );
    }


    @AuraEnabled
    public static void approvePPAC(
        Id assignmentId
    ){

        update new PPAC_Approving_Authorities__c(

            Id = assignmentId,

            Approval_Status__c = 'Approved',

            Approval_Date__c = System.now()
        );

        /*
        Check if all approvers approved

        If yes

        PPAC__c.Status__c='Completed'
        */
    }

    public class ReviewWrapper {

        @AuraEnabled
        public String ppacId;

        @AuraEnabled
        public String ppacName;

        @AuraEnabled
        public String subCategory;

        @AuraEnabled
        public String submittedBy;

        @AuraEnabled
        public List<PPAC_Observations__c> observations;
    }


    private static void sendObservationRaisedEmail(
        Id observationId,
        Id assignmentId
    ){

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

        PPAC_Approving_Authorities__c assignment = [

            SELECT Id,
                Approving_Authority__r.Name,

                PPAC__r.Id,
                PPAC__r.Name,
                PPAC__r.PPAC_ID__c,
                PPAC__r.Sub_Category__c,
                PPAC__r.Requestor_Email__c,
                PPAC__r.CreatedBy.Name

            FROM PPAC_Approving_Authorities__c

            WHERE Id = :assignmentId
        ];

        PPAC_Observations__c obs = [

            SELECT Id,
                Observation__c

            FROM PPAC_Observations__c

            WHERE Id = :observationId
        ];

        String responseLink =

            Label.PPAC_Approver_Site_URL

            + '/PPACReview/apex/PPACUserComments'

            + '?id='

            + observationId;

        List<Messaging.SingleEmailMessage> emails =
            new List<Messaging.SingleEmailMessage>();

        /*
        * USER EMAIL
        */

        if(String.isNotBlank(
            assignment.PPAC__r.Requestor_Email__c
        )){

            Messaging.SingleEmailMessage userMail =
                new Messaging.SingleEmailMessage();

            if(oweaId != null){
                userMail.setOrgWideEmailAddressId(
                    oweaId
                );
            }

            userMail.setToAddresses(
                new List<String>{
                    assignment.PPAC__r.Requestor_Email__c
                }
            );

            userMail.setSubject(

                'New Observation Raised on PPAC Note – '

                + assignment.PPAC__r.PPAC_ID__c

                + ' '

                + assignment.PPAC__r.Name
            );

            String body =

                'Dear '
                + assignment.PPAC__r.CreatedBy.Name
                + ',\n\n'

                + 'An observation has been raised by '
                + assignment.Approving_Authority__r.Name
                + ' on the PPAC Note.\n\n'

                + 'Observation Details:\n\n'

                + obs.Observation__c
                + '\n\n'

                + 'You are requested to review the observation and provide your response.\n\n'

                + 'Respond to the observation here:\n'

                + responseLink

                + '\n\n'

                + 'This is a system generated email.';

            userMail.setPlainTextBody(body);

            emails.add(userMail);
        }

        /*
        * RISK TEAM EMAIL
        */

        // Messaging.SingleEmailMessage riskMail =
        //     new Messaging.SingleEmailMessage();

        // if(oweaId != null){
        //     riskMail.setOrgWideEmailAddressId(
        //         oweaId
        //     );
        // }

        // riskMail.setToAddresses(
        //     new List<String>{
        //         'consumer.support@in.experian.com'
        //     }
        // );

        // riskMail.setSubject(

        //     'New Observation Raised on PPAC Note – '

        //     + assignment.PPAC__r.PPAC_ID__c

        //     + ' '

        //     + assignment.PPAC__r.Name
        // );

        // riskMail.setPlainTextBody(

        //     'An observation has been raised by '

        //     + assignment.Approving_Authority__r.Name

        //     + ' on PPAC '

        //     + assignment.PPAC__r.PPAC_ID__c

        //     + ' '

        //     + assignment.PPAC__r.Name

        //     + '.\n\n'

        //     + 'Observation:\n'

        //     + obs.Observation__c

        //     + '\n\n'

        //     + 'User Response Link:\n'

        //     + responseLink
        // );

        // emails.add(riskMail);

        if(!emails.isEmpty()){

            Messaging.sendEmail(
                emails
            );
        }
    }
}