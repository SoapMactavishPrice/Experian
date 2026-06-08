@IsTest
private class CaseFileLinkAPITest {

    // Utility method to create a ContentDocument for testing
    private static Id createTestContentDocument() {
        Blob body = Blob.valueOf('Test File Content');

        ContentVersion cv = new ContentVersion(
            Title = 'TestFile',
            PathOnClient = 'TestFile.txt',
            VersionData = body,
            IsMajorVersion = true
        );
        insert cv;

        cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
        return cv.ContentDocumentId;
    }

    @IsTest
    static void testLinkFileToCase_Success() {
        // Create Case
        Case c = new Case(
            Subject = 'Test Case',
            Status = 'New',
            Origin = 'Web'
        );
        insert c;

        // Create File
        Id contentDocumentId = createTestContentDocument();

        Test.startTest();
        String response = CaseFileLinkAPI.linkFileToCase(c.Id, contentDocumentId);
        Test.stopTest();

        CaseFileLinkAPI.ResponseWrapper result =
            (CaseFileLinkAPI.ResponseWrapper) JSON.deserialize(response, CaseFileLinkAPI.ResponseWrapper.class);

        System.assertEquals('Success', result.status);
        System.assertEquals('File linked to Case successfully', result.message);

        // Verify ContentDocumentLink created
        ContentDocumentLink cdl = [
            SELECT Id, LinkedEntityId, ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :c.Id
            LIMIT 1
        ];

        System.assertEquals(c.Id, cdl.LinkedEntityId);
        System.assertEquals(contentDocumentId, cdl.ContentDocumentId);
    }

    @IsTest
    static void testLinkFileToCase_MissingCaseId() {
        Id contentDocumentId = createTestContentDocument();

        Test.startTest();
        String response = CaseFileLinkAPI.linkFileToCase(null, contentDocumentId);
        Test.stopTest();

        CaseFileLinkAPI.ResponseWrapper result =
            (CaseFileLinkAPI.ResponseWrapper) JSON.deserialize(response, CaseFileLinkAPI.ResponseWrapper.class);

        System.assertEquals('Error', result.status);
        System.assert(result.message.contains('Missing required parameters'));
    }

    @IsTest
    static void testLinkFileToCase_MissingContentDocumentId() {
        Case c = new Case(
            Subject = 'Test Case',
            Status = 'New',
            Origin = 'Web'
        );
        insert c;

        Test.startTest();
        String response = CaseFileLinkAPI.linkFileToCase(c.Id, null);
        Test.stopTest();

        CaseFileLinkAPI.ResponseWrapper result =
            (CaseFileLinkAPI.ResponseWrapper) JSON.deserialize(response, CaseFileLinkAPI.ResponseWrapper.class);

        System.assertEquals('Error', result.status);
        System.assert(result.message.contains('Missing required parameters'));
    }

    @IsTest
    static void testLinkFileToCase_CaseNotFound() {
        Id contentDocumentId = createTestContentDocument();
        Id fakeCaseId = '500000000000000AAA'; // fake Case Id

        Test.startTest();
        String response = CaseFileLinkAPI.linkFileToCase(fakeCaseId, contentDocumentId);
        Test.stopTest();

        CaseFileLinkAPI.ResponseWrapper result =
            (CaseFileLinkAPI.ResponseWrapper) JSON.deserialize(response, CaseFileLinkAPI.ResponseWrapper.class);

        System.assertEquals('Error', result.status);
        System.assertEquals('Case not found', result.message);
    }

    @IsTest
    static void testLinkFileToCase_InvalidContentDocument() {
        Case c = new Case(
            Subject = 'Test Case',
            Status = 'New',
            Origin = 'Web'
        );
        insert c;

        Id fakeDocId = '069000000000000AAA'; // invalid ContentDocumentId

        Test.startTest();
        String response = CaseFileLinkAPI.linkFileToCase(c.Id, fakeDocId);
        Test.stopTest();

        CaseFileLinkAPI.ResponseWrapper result =
            (CaseFileLinkAPI.ResponseWrapper) JSON.deserialize(response, CaseFileLinkAPI.ResponseWrapper.class);

        System.assertEquals('Error', result.status);
        System.assert(result.message.contains('Failed to link file'));
    }
}