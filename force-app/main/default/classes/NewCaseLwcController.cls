public class NewCaseLwcController {
    
    @AuraEnabled
    public static String getAccountName(string accountId) {
        system.debug('getAccountName-->'+accountId);
        Account acc = [SELECT Name FROM Account WHERE Id = :accountId LIMIT 1];
        return acc.Name;
    }

    
    @AuraEnabled 
    public static Id getCaseType(){
        return([select id,Name from Case_Type__c  where Name='Complaint Dispute Consumer'].Id);
    }
    
    @AuraEnabled
    public static Map<string,object> createCase(string js){
        List<object> objList =(List<Object>)JSON.deserializeUntyped(js);
        List<Case> newCaseList = new List<Case>();
        Id csRecId = (Id)Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consumer Support Layout').getRecordTypeId();
        
        List<string> GroupName = new List<string>();
        GroupName.add('Consumer Support Queue');
        
        map <string ,Id> queuesmap = new map<string,Id>();
        for(Group grp : [select Id,Name from Group where  Type = 'Queue' and Name IN : GroupName limit 11]){
            queuesmap.put(grp.Name,grp.Id);
        }
        
        Map<string,object> result = new Map<string,object>();
        try{
            
            for(Object obj :objList){
                
                Map<string,object> objMap = (Map<string,object>)obj;
                system.debug('objMap--'+objMap);
                case cse = new case();
                cse.RecordTypeId = csRecId;
                system.debug((string) objMap.get('Case_Category'));
                cse.Case_Category__c = 'Consumer';
                                system.debug((string) objMap.get('Case_Complaints'));
                cse.Case_Complaints__c = 'Report';
                system.debug((string) objMap.get('Case_Type_Lookup'));
                cse.Case_Type_Lookup__c = (string) objMap.get('Case_Type_Lookup');
                system.debug((string) objMap.get('Sub_Type_Lookup'));
                cse.Sub_Type_Lookup__c = (string) objMap.get('Sub_Type_Lookup');
                system.debug((string) objMap.get('Sub_Type_1_Lookup'));
                
                cse.Sub_Type_1_Lookup__c = (string) objMap.get('Sub_Type_1_Lookup');
                system.debug((string) objMap.get('Date_of_the_email_received'));
                
                cse.AccountId = (string) objMap.get('AccountId');
                cse.Displayed_Account_number__c = (string) objMap.get('Displayed_Account_number');
                cse.Displayed_Account_Type__c = (string) objMap.get('Displayed_Account_Type');
                cse.Contact_Name__c = (string) objMap.get('Contact_Name');
                cse.ContactPan__c = (string) objMap.get('ContactPan');
                cse.ContactMobileNo__c = (string) objMap.get('ContactMobileNo');
                cse.Contact_Date_of_Birth__c = (string) objMap.get('Contact_Date_of_Birth') !=null ? Date.valueOf((string) objMap.get('Contact_Date_of_Birth')):null;
                cse.Contact_Address__c = (string) objMap.get('Contact_Address');
                cse.ContactEmailId__c = (string) objMap.get('ContactEmailId');
                cse.Contact_Gender__c = (string) objMap.get('Contact_Gender');
                cse.Displayed_Bank_Name__c = (string) objMap.get('DisplayedBankName');
                cse.Dis_Ern__c = (string) objMap.get('Dis_Ern');
                
                Boolean isLoanBalance = (Boolean) objMap.get('isLoanBalance');
                if(isLoanBalance){
                    cse.Displayed_Loan_Balance__c = Decimal.valueOf((string) objMap.get('Displayed_Loan_Balance'));
                    cse.Correct_Loan_Balance__c = Decimal.valueOf((string) objMap.get('Correct_Loan_Balance'));
                }
                
                Boolean isOverDue = (Boolean) objMap.get('isOverDue');
                if(isOverDue){
                    cse.Displayed_Overdue_Amount__c = Decimal.valueOf((string) objMap.get('Displayed_Overdue_Amount'));
                    cse.Correct_Overdue_Amount__c = Decimal.valueOf((string) objMap.get('Correct_Overdue_Amount'));
                }
                
                Boolean isAccountStatus = (Boolean) objMap.get('isAccountStatus');
                if(isAccountStatus){
                    cse.Displayed_Account_Status__c = (string) objMap.get('Displayed_Account_Status');
                    cse.Correct_Account_Status__c = (string) objMap.get('Correct_Account_Status');
                }
                
                Boolean isAccOpenDate = (Boolean) objMap.get('isAccOpenDate');
                if(isAccOpenDate){
                    cse.Correct_Account_Opening_Date__c = Date.valueOf((string) objMap.get('Correct_Account_Opening_Date'));
                    cse.Displayed_Account_Opening_Date__c = Date.valueOf((string) objMap.get('Displayed_Account_Opening_Date'));
                }
                
                Boolean isLoanOwner = (Boolean) objMap.get('isLoanOwner');
                if(isLoanOwner){
                    cse.Displayed_loan_ownership__c = (string) objMap.get('Displayed_loan_ownership');
                    cse.Correct_loan_ownership__c = (string) objMap.get('Correct_loan_ownership');
                }
                
                
                
                Boolean isLoanType = (Boolean) objMap.get('isLoanType');
                if(isLoanType){
                    cse.Displayed_loan_type__c = (string) objMap.get('Displayed_loan_type');
                    cse.Correct_loan_type__c = (string) objMap.get('Correct_loan_type');
                }
                
                Boolean isCredit = (Boolean) objMap.get('isCredit');
                if(isCredit){
                    cse.Corrected_Credit_Facility_Status__c = (string) objMap.get('Corrected_Credit_Facility_Status');
                    cse.Displayed_Credit_Facility_Status__c = (string) objMap.get('Displayed_Credit_Facility_Status');
                }
                
                Boolean isDName = (Boolean) objMap.get('isDName');
                if(isDName){
                    cse.Correct_Name__c = (string) objMap.get('Correct_Name');
                    cse.Displayed_Name__c = (string) objMap.get('Displayed_Name');
                }
                
                Boolean isDOB = (Boolean) objMap.get('isDOB');
                if(isDOB){
                    cse.Correct_Date_of_Birth__c = Date.valueOf((string) objMap.get('Correct_Date_of_Birth'));
                    cse.Displayed_Date_of_Birth__c = Date.valueOf((string) objMap.get('Displayed_Date_of_Birth'));
                }
                
                Boolean isDG = (Boolean) objMap.get('isDG');
                if(isDG){
                    cse.Displayed_Gender__c = (string) objMap.get('Displayed_Gender');
                    cse.Correct_Gender__c = (string) objMap.get('Correct_Gender');
                }
                
                Boolean isMN = (Boolean) objMap.get('isMN');
                if(isMN){
                    cse.Displayed_Mobile_No__c = (string) objMap.get('Displayed_Mobile_No');
                    cse.Correct_Mobile_No__c = (string) objMap.get('Correct_Mobile_No');
                }
                
                Boolean isA1 = (Boolean) objMap.get('isA1');
                if(isA1){
                    cse.Displayed_Address__c = (string) objMap.get('Displayed_Address');
                    cse.Correct_Address__c = (string) objMap.get('Correct_Address');
                }


                Boolean isKYC = (Boolean) objMap.get('isKYC');
                if(isKYC){
                    cse.Displayed_PAN_No__c = (string) objMap.get('DisplayedKYC');
                    cse.Correct_PAN_No__c = (string) objMap.get('CorrectKYC');
                }

                Boolean isMobileNo = (Boolean) objMap.get('isMobileNo');
                if(isMobileNo){
                    cse.Displayed_Mobile_No__c = (string) objMap.get('DisplayedMobileNo');
                    cse.Correct_Mobile_No__c = (string) objMap.get('CorrectMobileNo');
                }

                Boolean isEmail = (Boolean) objMap.get('isEmail');
                if(isEmail){
                    cse.Displayed_Email_Id__c = (string) objMap.get('DisplayedEmail');
                    cse.Correct_email_id__c = (string) objMap.get('CorrectEmail');
                }
                cse.Origin = (string) objMap.get('Origin');
                 cse.Date_of_the_email_received__c = Date.valueOf((string) objMap.get('Date_of_the_email_received'));
                cse.OwnerId = queuesmap.get('Consumer Support Queue');
               
                
                newCaseList.add(cse);
                
            }
            
            if(newCaseList.size()> 0 ){
                insert newCaseList;
                
            }
            
            result.put('Message','Cases created successfully!!!!');  
            result.put('Status','Success');
            result.put('caseId',newCaseList[0].Id);
            
        }catch(exception e){
            result.put('Message',e.getLineNumber()+' - '+e.getMessage());  
            result.put('Status','Failed');  
        }
        system.debug('result-->'+result);
         return result;
    }



   @AuraEnabled
    public static List<Object> createCaseCSV(String js) {

        System.debug(js);

        List<Object> result = new List<Object>();
        List<Object> objList = (List<Object>) JSON.deserializeUntyped(js);

        for (Object obj : objList) {

            Map<String, Object> row = (Map<String, Object>) obj;
            Map<String, Object> res = new Map<String, Object>();

            try {

                // -------------------------
                // 1. Resolve Case Type
                // -------------------------
                Case_Type__c caseType = [
                    SELECT Id
                    FROM Case_Type__c
                    WHERE Name = :((String)row.get('Case_Type_Lookup__c'))
                    LIMIT 1
                ];

                // -------------------------
                // 2. Resolve Sub Type
                // -------------------------
                Sub_Type__c subType = [
                    SELECT Id
                    FROM Sub_Type__c
                    WHERE isActive__c = true
                    AND Case_Category__c = :((String)row.get('Case_Category__c'))
                    AND Case_Complaint__c = :((String)row.get('Case_Complaints__c'))
                    AND Case_Type__c = :caseType.Id
                    AND Name = :((String)row.get('Sub_Type_Lookup__c'))
                    LIMIT 1
                ];

                // -------------------------
                // 3. Resolve Sub Type 1
                // -------------------------
                Sub_Type1__c subType1 = [
                    SELECT Id
                    FROM Sub_Type1__c
                    WHERE isActive__c = true
                    AND Case_Category__c = :((String)row.get('Case_Category__c'))
                    AND Case_Complaint__c = :((String)row.get('Case_Complaints__c'))
                    AND Case_Type__c = :((String)row.get('Case_Type_Lookup__c'))
                    AND Sub_Type__c = :subType.Id
                    AND Name = :((String)row.get('Sub_Type_1_Lookup__c'))
                    LIMIT 1
                ];

                // -------------------------
                // Create Case (manual mapping)
                // -------------------------
                Case c = new Case();

                c.Case_Category__c = (String) row.get('Case_Category__c');
                c.Case_Complaints__c = (String) row.get('Case_Complaints__c');

                c.Case_Type_Lookup__c = caseType.Id;
                c.Sub_Type_Lookup__c = subType.Id;
                c.Sub_Type_1_Lookup__c = subType1.Id;

                c.Date_of_the_email_received__c =
                    parseDate((String) row.get('Date_of_the_email_received__c'));

                c.Displayed_Bank_Name__c =
                    (String) row.get('Displayed_Bank_Name__c');

                c.Displayed_Account_number__c =
                    (String) row.get('Displayed_Account_number__c');

                c.Displayed_Account_Type__c =
                    (String) row.get('Displayed_Account_Type__c');

                c.Dispute_Detail__c =
                    (String) row.get('Dispute_Detail__c');

                c.Contact_Name__c =
                    (String) row.get('Contact_Name__c');

                c.ContactPan__c =
                    (String) row.get('ContactPan__c');

                c.ContactMobileNo__c =
                    (String) row.get('ContactMobileNo__c');

                c.Contact_Date_of_Birth__c =
                    parseDate((String) row.get('Contact_Date_of_Birth__c'));

                c.Contact_Address__c =
                    (String) row.get('Contact_Address__c');

                c.ContactEmailId__c =
                    (String) row.get('ContactEmailId__c');

                c.Contact_Gender__c =
                    (String) row.get('Contact_Gender__c');

                c.Dis_Ern__c =
                    (String) row.get('Dis_Ern__c');

                // defaults
                c.Origin = 'Email';
                c.OwnerId = '00G2u000000pcYJEAY';

                insert c;

                c = [SELECT CaseNumber FROM Case WHERE Id = :c.Id];

                res.put('Status', 'Success');
                res.put('Message', 'Case Created: ' + c.CaseNumber);

            } catch (Exception e) {

                res.put('Status', 'Failed');
                res.put('Message', e.getMessage());
            }

            result.add(res);
        }

        return result;
    }


    // -------------------------
    // DD-MM-YYYY parser
    // -------------------------
    private static Date parseDate(String input) {

        if (String.isBlank(input)) return null;

        List<String> p = input.split('-');

        return Date.newInstance(
            Integer.valueOf(p[2]),
            Integer.valueOf(p[1]),
            Integer.valueOf(p[0])
        );
    }
    
   
    
}