public without sharing class DataIntelligenceCaseController {

    @AuraEnabled
    public static List<Id> createCases(Map<String, Object> formData) {

        List<Case> casesToInsert = new List<Case>();
        List<Id> createdCaseIds = new List<Id>();

        try {
            /* SAFE DESERIALIZATION */
            List<Object> fileRows = (List<Object>) JSON.deserializeUntyped(JSON.serialize(formData.get('FileDetails')));

            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Data_Intelligence_Support').getRecordTypeId();

            List<Group> diOwnerId = [Select Id, DeveloperName From Group Where DeveloperName = 'Data_Intelligence' Limit 1];

            Id accId = (Id) formData.get('MemberAccountId');

            String accName = '';

            if (accId != null) {
                Account acc = [SELECT Name FROM Account WHERE Id = :accId LIMIT 1];
                accName = acc.Name;
            }

            for (Object rowObj : fileRows) {
                Map<String, Object> row =
                    (Map<String, Object>) rowObj;

                Case c = new Case();
                c.RecordTypeId = recordTypeId;
                c.OwnerId = diOwnerId[0].Id;
                c.Subject = (String.isNotBlank(accName) ? accName + ' - ' : '')  + 'Data Intelligence Form Submitted';
                c.Case_Category__c = 'Data Intelligence';
                c.Origin  = 'Email';

                /* ---------- COMMON FIELDS ---------- */
                c.AccountId = (String) formData.get('MemberAccountId');
                c.Requestor_Name__c =
                    (String) formData.get('RequestorName');
                c.Requestor_Official_Email_Id__c =
                    (String) formData.get('RequestorEmail');
                c.Requestor_Department__c =
                    (String) formData.get('RequestorDept');
                c.Product__c =
                    (String) formData.get('Product');
                c.Bureau__c =
                    (String) formData.get('Bureau');

                String reqDate = (String) formData.get('RequestDate');
                if (String.isNotBlank(reqDate)) {
                    c.Request_Date__c = Date.valueOf(reqDate);
                }

                /* ---------- ROW-SPECIFIC FIELDS ---------- */
                c.File_Name__c = (String) row.get('fileName');

                if (row.get('inputFileRecords') != null) {
                    c.Input_File_Records__c =
                        Decimal.valueOf(
                            String.valueOf(row.get('inputFileRecords'))
                        );
                }

                casesToInsert.add(c);
            }

            // Insert ALL cases at once
            insert casesToInsert;

            for (Case c : casesToInsert) {
                createdCaseIds.add(c.Id);
            }

            /* ---------- FILE UPLOAD(S) ---------- */
            List<ContentVersion> versionsToInsert = new List<ContentVersion>();

            if (formData.containsKey('UploadFiles') && formData.get('UploadFiles') != null) {
                List<Object> uploadFiles =
                    (List<Object>) JSON.deserializeUntyped(JSON.serialize(formData.get('UploadFiles')));

                for (Object fileObj : uploadFiles) {
                    Map<String, Object> fileData =
                        (Map<String, Object>) fileObj;

                    String fileName = (String) fileData.get('fileName');
                    String fileBody = (String) fileData.get('fileBody');

                    if (String.isNotBlank(fileName) && String.isNotBlank(fileBody)) {
                        versionsToInsert.add(new ContentVersion(
                            Title = fileName,
                            PathOnClient = fileName,
                            VersionData = EncodingUtil.base64Decode(fileBody)
                        ));
                    }
                }
            } else if (formData.containsKey('UploadFileBody')) {
                String singleFileName = (String) formData.get('UploadFileName');
                String singleFileBody = (String) formData.get('UploadFileBody');

                if (String.isNotBlank(singleFileName) && String.isNotBlank(singleFileBody)) {
                    versionsToInsert.add(new ContentVersion(
                        Title = singleFileName,
                        PathOnClient = singleFileName,
                        VersionData = EncodingUtil.base64Decode(singleFileBody)
                    ));
                }
            }

            if (!versionsToInsert.isEmpty()) {
                insert versionsToInsert;

                Set<Id> versionIds = new Set<Id>();
                for (ContentVersion cv : versionsToInsert) {
                    versionIds.add(cv.Id);
                }

                List<ContentVersion> savedVersions = [
                    SELECT ContentDocumentId
                    FROM ContentVersion
                    WHERE Id IN :versionIds
                ];

                List<ContentDocumentLink> links = new List<ContentDocumentLink>();
                for (Id caseId : createdCaseIds) {
                    for (ContentVersion savedVersion : savedVersions) {
                        links.add(new ContentDocumentLink(
                            ContentDocumentId = savedVersion.ContentDocumentId,
                            LinkedEntityId = caseId,
                            ShareType = 'V',
                            Visibility = 'AllUsers'
                        ));
                    }
                }

                if (!links.isEmpty()) {
                    insert links;
                }
            }

        } catch (Exception ex) {
            throw new AuraHandledException(
                'Error creating cases: ' + ex.getMessage()
            );
        }

        return createdCaseIds;
    }


    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchKey) {
        if (String.isBlank(searchKey) || searchKey.length() < 2) {
            return new List<Account>();
        }

        return [
            SELECT Id, Name
            FROM Account
            WHERE Name LIKE :('%' + searchKey + '%')
            ORDER BY Name
            LIMIT 10
        ];
    }

}