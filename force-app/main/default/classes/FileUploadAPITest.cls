@IsTest
private class FileUploadAPITest {

    @IsTest
    static void testUploadFile_Success() {
        String fileName = 'TestFile.txt';
        Blob body = Blob.valueOf('Hello World');
        String base64Data = EncodingUtil.base64Encode(body);

        Test.startTest();
        String response = FileUploadAPI.uploadFile(fileName, base64Data);
        Test.stopTest();

        FileUploadAPI.ResponseWrapper result =
            (FileUploadAPI.ResponseWrapper) JSON.deserialize(response, FileUploadAPI.ResponseWrapper.class);

        System.assertEquals('Success', result.status);
        System.assertEquals('File uploaded successfully', result.message);
        System.assertNotEquals(null, result.contentVersionId);
        System.assertNotEquals(null, result.contentDocumentId);

        // Verify record actually inserted
        ContentVersion cv = [
            SELECT Id, ContentDocumentId
            FROM ContentVersion
            WHERE Id = :result.contentVersionId
            LIMIT 1
        ];

        System.assertEquals(result.contentDocumentId, cv.ContentDocumentId);
    }

    @IsTest
    static void testUploadFile_MissingFileName() {
        Blob body = Blob.valueOf('Hello World');
        String base64Data = EncodingUtil.base64Encode(body);

        Test.startTest();
        String response = FileUploadAPI.uploadFile(null, base64Data);
        Test.stopTest();

        FileUploadAPI.ResponseWrapper result =
            (FileUploadAPI.ResponseWrapper) JSON.deserialize(response, FileUploadAPI.ResponseWrapper.class);

        System.assertEquals('Error', result.status);
        System.assert(result.message.contains('Missing required parameters'));
    }

    @IsTest
    static void testUploadFile_MissingBase64() {
        Test.startTest();
        String response = FileUploadAPI.uploadFile('TestFile.txt', null);
        Test.stopTest();

        FileUploadAPI.ResponseWrapper result =
            (FileUploadAPI.ResponseWrapper) JSON.deserialize(response, FileUploadAPI.ResponseWrapper.class);

        System.assertEquals('Error', result.status);
        System.assert(result.message.contains('Missing required parameters'));
    }

    @IsTest
    static void testUploadFile_BothParametersMissing() {
        Test.startTest();
        String response = FileUploadAPI.uploadFile(null, null);
        Test.stopTest();

        FileUploadAPI.ResponseWrapper result =
            (FileUploadAPI.ResponseWrapper) JSON.deserialize(response, FileUploadAPI.ResponseWrapper.class);

        System.assertEquals('Error', result.status);
        System.assert(result.message.contains('Missing required parameters'));
    }

    @IsTest
    static void testUploadFile_InvalidBase64() {
        String fileName = 'BadFile.txt';
        String invalidBase64 = 'NotBase64!!!';

        Test.startTest();
        String response = FileUploadAPI.uploadFile(fileName, invalidBase64);
        Test.stopTest();

        FileUploadAPI.ResponseWrapper result =
            (FileUploadAPI.ResponseWrapper) JSON.deserialize(response, FileUploadAPI.ResponseWrapper.class);

        System.assertEquals('Error', result.status);
        System.assert(result.message.contains('Failed to upload file'));
    }
}