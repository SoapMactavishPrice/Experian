@isTest
private class DataIntelligenceCaseControllerTest {

    private static Account createTestAccount(String suffix) {
        Account acc = new Account(Name = 'DI Account ' + suffix);
        insert acc;
        return acc;
    }

    private static Map<String, Object> buildBaseFormData(Id accountId) {
        Map<String, Object> formData = new Map<String, Object>();
        formData.put('MemberAccountId', accountId);
        formData.put('RequestDate', String.valueOf(Date.today()));
        formData.put('RequestorName', 'Test Requestor');
        formData.put('RequestorEmail', 'requestor@example.com');
        formData.put('RequestorDept', 'QA');
        formData.put('Product', 'Ar - 24;Score');
        formData.put('Bureau', 'Consumer');
        return formData;
    }

    @isTest
    static void testCreateCasesWithMultipleFiles() {
        Account acc = createTestAccount('Multi');

        List<Object> fileDetails = new List<Object>{
            new Map<String, Object>{
                'fileName' => 'InputA.csv',
                'inputFileRecords' => 10
            },
            new Map<String, Object>{
                'fileName' => 'InputB.csv',
                'inputFileRecords' => 20
            }
        };

        List<Object> uploadFiles = new List<Object>{
            new Map<String, Object>{
                'fileName' => 'proof1.pdf',
                'fileBody' => EncodingUtil.base64Encode(Blob.valueOf('file-one'))
            },
            new Map<String, Object>{
                'fileName' => 'proof2.png',
                'fileBody' => EncodingUtil.base64Encode(Blob.valueOf('file-two'))
            }
        };

        Map<String, Object> formData = buildBaseFormData(acc.Id);
        formData.put('FileDetails', fileDetails);
        formData.put('UploadFiles', uploadFiles);

        Test.startTest();
        List<Id> createdCaseIds = DataIntelligenceCaseController.createCases(formData);
        Test.stopTest();

        System.assertEquals(2, createdCaseIds.size(), 'Expected 2 cases (one for each file detail row).');

        List<Case> createdCases = [
            SELECT Id, AccountId, File_Name__c, Input_File_Records__c
            FROM Case
            WHERE Id IN :createdCaseIds
        ];
        System.assertEquals(2, createdCases.size(), 'Created cases should be queryable.');

        Integer cdlCount = [
            SELECT COUNT()
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :createdCaseIds
        ];
        System.assertEquals(4, cdlCount, '2 uploaded files should link to 2 cases (2x2).');
    }

    @isTest
    static void testCreateCasesWithSingleFileFallback() {
        Account acc = createTestAccount('Single');

        List<Object> fileDetails = new List<Object>{
            new Map<String, Object>{
                'fileName' => 'OnlyOne.csv',
                'inputFileRecords' => 5
            }
        };

        Map<String, Object> formData = buildBaseFormData(acc.Id);
        formData.put('FileDetails', fileDetails);
        formData.put('UploadFileName', 'legacy.txt');
        formData.put('UploadFileBody', EncodingUtil.base64Encode(Blob.valueOf('legacy-file')));

        Test.startTest();
        List<Id> createdCaseIds = DataIntelligenceCaseController.createCases(formData);
        Test.stopTest();

        System.assertEquals(1, createdCaseIds.size(), 'Expected one case for one file detail row.');

        Integer cdlCount = [
            SELECT COUNT()
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :createdCaseIds
        ];
        System.assertEquals(1, cdlCount, 'Legacy single upload should create one file link.');
    }

    @isTest
    static void testSearchAccounts() {
        Account acc1 = createTestAccount('SearchOne');
        Account acc2 = createTestAccount('SearchTwo');

        Test.startTest();
        List<Account> blankResult = DataIntelligenceCaseController.searchAccounts('');
        List<Account> shortResult = DataIntelligenceCaseController.searchAccounts('A');
        List<Account> validResult = DataIntelligenceCaseController.searchAccounts('DI Account Search');
        Test.stopTest();

        System.assertEquals(0, blankResult.size(), 'Blank search should return no rows.');
        System.assertEquals(0, shortResult.size(), 'Search key < 2 chars should return no rows.');
        System.assert(validResult.size() >= 2, 'Valid search should return created accounts.');

        Set<Id> returnedIds = new Set<Id>();
        for (Account a : validResult) {
            returnedIds.add(a.Id);
        }

        System.assert(returnedIds.contains(acc1.Id), 'Result should include first account.');
        System.assert(returnedIds.contains(acc2.Id), 'Result should include second account.');
    }
}