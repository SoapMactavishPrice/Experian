public with sharing class PPACPostMeetingController {

    // GET DETAILS
    @AuraEnabled(cacheable=true)
    public static PPAC__c getPPACDetails(Id ppacId) {
        return [

            SELECT Id,
                   Document_Type__c,
                   MOM_Release_Date__c,
                   Sub_Category__c,
                   BU_Head__c

            FROM PPAC__c

            WHERE Id = :ppacId

            LIMIT 1
        ];
    }

    // SAVE
    @AuraEnabled
    public static void savePostMeetingDetails(

        Id ppacId,

        Date momReleaseDate,

        String subCategory,

        String buHead
    ) {

        PPAC__c ppac = new PPAC__c(

            Id = ppacId,

            MOM_Release_Date__c = momReleaseDate,

            Sub_Category__c = subCategory,

            BU_Head__c = buHead
        );

        update ppac;
    }

    // RENAME FILES
    @AuraEnabled
    public static void renameFiles(

        List<Id> contentDocumentIds,

        String prefix
    ) {

        List<ContentVersion> versionsToUpdate =
            new List<ContentVersion>();

        List<ContentVersion> versions = [

            SELECT Id,
                   Title,
                   ContentDocumentId

            FROM ContentVersion

            WHERE ContentDocumentId
            IN :contentDocumentIds

            AND IsLatest = true
        ];

        for(ContentVersion cv : versions) {

            cv.Title =
                prefix + '_' + cv.Title;

            versionsToUpdate.add(cv);
        }

        update versionsToUpdate;
    }
}