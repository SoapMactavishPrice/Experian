public class updateCaseController {
    @AuraEnabled 
    public static List<object> updateCase(boolean bCheck, string js,string c_type){
        
        List<object> result = new List<object>();
        List<Object> objList = (List<Object>)JSON.deserializeUntyped(js);
        
        List<Case> csList= new List<Case>();
        List<ContentDocumentLink> cdlList  = new List<ContentDocumentLink>();
        Map<Id,case> caseMap = new Map<Id,case>();
        if(c_type =='Resolved in favour of the Consumer' || c_type =='Resolved in favour of the Consumer - Data Submission'){
            set<Id> csId = new set<Id>(); 
            for(Object obj: objList){
                map<string,object> objMap = (map<string,object>)obj;
                csId.add((Id)objMap.get('Id'));
            }
            
            if(csId.size() > 0){
                caseMap = new Map<Id,Case>([Select Id,Credit_Report_Generation_Date__c,Is_Error__c,Error__c from Case where 
                                            Id IN : csId]);
            }
        }
        Map<string,Object> objMapsError = new Map<string,Object>();
        for(Object obj: objList){
            map<string,object> objMap = (map<string,object>)obj;
            
            if(c_type =='Attach File to the Case'){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.LinkedEntityId = (Id)objMap.get('Id');
                cdl.ContentDocumentId = (Id)objMap.get('ContentDocumentId');
                cdl.ShareType = (string)objMap.get('ShareType');
                cdl.Visibility = (string)objMap.get('Visibility');
                cdlList.add(cdl);
                
            }
            else{
                
                Case cs = new Case();
                cs.Id = (Id)objMap.get('Id');
                if(objMap.containsKey('Consumer_Dispute_Status')){
                    system.debug('-->1-->'+objMap.containsKey('Consumer_Dispute_Status'));
                    if((string)objMap.get('Consumer_Dispute_Status') =='Resolved in favour of the Consumer' || 
                       (string)objMap.get('Consumer_Dispute_Status') =='Resolved in favour of the Consumer - Data Submission'
                       ){
                        if(caseMap.containsKey(cs.Id)){
                            if(caseMap.get(cs.Id).Credit_Report_Generation_Date__c !=null){
                                objMapsError.put(cs.Id,'Already Executed-');
                            }else{ 
                                //if(caseMap.get(cs.Id).Is_Error__c){
                                cs.Consumer_Dispute_Status__c = (string)objMap.get('Consumer_Dispute_Status');
                                objMapsError.put(cs.Id,caseMap.get(cs.Id).Is_Error__c+'-'+caseMap.get(cs.Id).Error__c);
                            }
                            /*else{
                              cs.Consumer_Dispute_Status__c = (string)objMap.get('Consumer_Dispute_Status');
                           }*/
                        }else{cs.Consumer_Dispute_Status__c = (string)objMap.get('Consumer_Dispute_Status');
                        }
                    }else{
                        cs.Consumer_Dispute_Status__c = (string)objMap.get('Consumer_Dispute_Status');
                    }
                }

                if(objMap.containsKey('Data_Submission')){cs.Resolved_Based_on_Data_Submission__c = true;
                }
                
                if(objMap.containsKey('Last_Reply_from_Bank_Team')){
                    String dateValue = (String) objMap.get('Last_Reply_from_Bank_Team');
                    if(String.isNotBlank(dateValue)) {
                        String dayStr = dateValue.substring(0, 2);    // Extract day (positions 0-1)
                        String monthStr = dateValue.substring(3, 5);  // Extract month (positions 3-4)
                        String yearStr = dateValue.substring(6, 10);  // Extract year (positions 6-9)
                        
                        Integer day = Integer.valueOf(dayStr);
                        Integer month = Integer.valueOf(monthStr);
                        Integer year = Integer.valueOf(yearStr);
                        
                        Date dateToSave = Date.newInstance(year, month, day); // Create the Date object
                        cs.Last_Reply_from_Bank_Team__c = dateToSave;
                    }
                    
                    if(objMap.containsKey('Rejection_Reason')){
                        if(bCheck){
                            cs.Rejection_Reason__c = (string)objMap.get('Rejection_Reason');
                        }
                    }
                }
                
                if(objMap.containsKey('enquiry_User_Id')){
                    cs.Enquiry_User_Id__c = (string)objMap.get('enquiry_User_Id');
                }
                
                
                if(objMap.containsKey('enquiry_Loan_Amount')){
                    cs.Enquiry_Loan_Amount__c = double.valueOf((string)objMap.get('enquiry_Loan_Amount'));
                }
                
                if(objMap.containsKey('OwnerId')){
                    String ownerId ='';
                    ownerId = (String)objMap.get('OwnerId');
                    cs.OwnerId = ownerId.substring(0, 15);
                    ownerId = (String)objMap.get('OwnerId');
                    
                }
                
                
                //forward to bank
                //system.debug('Inside if-->'+objMap.get('temp_forward_to_bank') == true);
                
                if (objMap.containsKey('temp_forward_to_bank')) {
                    cs.Temp_Forward_to_Bank__c = true;
                    
                }
                if(objMap.containsKey('forward_to_bank')){
                    cs.Forward_to_bank__c = true;
                }
                
                //Send Email to consumer
                if(objMap.containsKey('sendEmailtoConsumer')){
                    cs.Send_Email_to_Consumer__c = true;
                }
                
                
                
                //Sub Type 1 Change
                //system.debug('Inside if-->'+objMap.get('temp_forward_to_bank') == true);
                
                if (objMap.containsKey('subtypeOneId')) {cs.Sub_Type_1_Lookup__c = (Id) objMap.get('subtypeOneId');
                                                         //cs.Temp_Forward_to_Bank__c = true;
                }
                
                if (objMap.containsKey('MatchingCommentsub')) {
                    cs.Matching_Comments__c = (string) objMap.get('MatchingCommentsub');
                }
                
                if(objMap.containsKey('LastReplyFromMatchingTeamforSub')){
                    String dateValue = (String) objMap.get('LastReplyFromMatchingTeamforSub');
                    if(String.isNotBlank(dateValue)) {
                        String dayStr = dateValue.substring(0, 2);    // Extract day (positions 0-1)
                        String monthStr = dateValue.substring(3, 5);  // Extract month (positions 3-4)
                        String yearStr = dateValue.substring(6, 10);  // Extract year (positions 6-9)
                        
                        Integer day = Integer.valueOf(dayStr);
                        Integer month = Integer.valueOf(monthStr);
                        Integer year = Integer.valueOf(yearStr);
                        
                        Date dateToSave = Date.newInstance(year, month, day); // Create the Date object
                        cs.Last_Reply_from_GPD_Team__c = dateToSave;
                    }
                }
                
                //Matching in Favor
                if (objMap.containsKey('consumerDisputeStatus')) {cs.Consumer_Dispute_Status__c = (string) objMap.get('consumerDisputeStatus');
                }
                
                if (objMap.containsKey('MatchingComment')) {
                    cs.Matching_Comments__c = (string) objMap.get('MatchingComment');
                }
                
                if(objMap.containsKey('LastReplyFromMatchingTeam')){
                    String dateValue1 = (String) objMap.get('LastReplyFromMatchingTeam');
                    if(String.isNotBlank(dateValue1)) {
                        String dayStr = dateValue1.substring(0, 2);    // Extract day (positions 0-1)
                        String monthStr = dateValue1.substring(3, 5);  // Extract month (positions 3-4)
                        String yearStr = dateValue1.substring(6, 10);  // Extract year (positions 6-9)
                        
                        Integer day = Integer.valueOf(dayStr);
                        Integer month = Integer.valueOf(monthStr);
                        Integer year = Integer.valueOf(yearStr);
                        
                        Date dateToSave = Date.newInstance(year, month, day); // Create the Date object
                        cs.Last_Reply_from_GPD_Team__c = dateToSave;
                    }
                }
                //Incident Update
                if (objMap.containsKey('incidentNo')) {
                    cs.Incident__c = (string) objMap.get('incidentNo');
                }
                if (objMap.containsKey('forwardToMatechTeam')) {
                    cs.Forward_to_GPD_Team__c = true;
                }
                
                if (objMap.containsKey('sendEmailtoConsumerInc')) {
                    cs.Send_Email_to_Consumer__c = true;
                }
                
                
                
                //refer_to_IO_Case
                if (objMap.containsKey('referToIO')) {
                    cs.Referred_To_IO_Case__c =true;
                }
                if(objMap.containsKey('lastReplyFromBacnkTeam_ref')){
                    String dateValue1 = (String) objMap.get('lastReplyFromBacnkTeam_ref');
                    if(String.isNotBlank(dateValue1)) {
                        String dayStr = dateValue1.substring(0, 2);    // Extract day (positions 0-1)
                        String monthStr = dateValue1.substring(3, 5);  // Extract month (positions 3-4)
                        String yearStr = dateValue1.substring(6, 10);  // Extract year (positions 6-9)
                        
                        Integer day = Integer.valueOf(dayStr);
                        Integer month = Integer.valueOf(monthStr);
                        Integer year = Integer.valueOf(yearStr);
                        
                        Date dateToSave = Date.newInstance(year, month, day); // Create the Date object
                        cs.Last_Reply_from_Bank_Team__c = dateToSave;
                    }
                    
                    if (objMap.containsKey('RejectedRegion_ref')) {cs.Rejection_Reason__c = (string)objMap.get('RejectedRegion_ref');
                    }
                    
                    if (objMap.containsKey('disputeRejectedRegion_ref')) {cs.Dispute_Rejected_Reason__c = (string)objMap.get('disputeRejectedRegion_ref');
                    }
                }
                //update CST comment
                if (objMap.containsKey('caseCSTComment')) {
                    string strAdd = (string)objMap.get('caseCSTComment');
                    strAdd = strAdd.replace(';',',');
                    cs.CST_Comments__c =strAdd;
                }

                //Complaint Withdrawn by Consumer
                if (objMap.containsKey('caseCSTCommentv1')) { 
                    string strAdd = (string)objMap.get('caseCSTCommentv1');
                    strAdd = strAdd.replace(';',',');
                    cs.CST_Comments__c =strAdd;
                }
                if (objMap.containsKey('telConversionDate')) {
                                        String dateValue1 = (String) objMap.get('telConversionDate');
                    if(String.isNotBlank(dateValue1)) {
                        String dayStr = dateValue1.substring(0, 2);    // Extract day (positions 0-1)
                        String monthStr = dateValue1.substring(3, 5);  // Extract month (positions 3-4)
                        String yearStr = dateValue1.substring(6, 10);  // Extract year (positions 6-9)
                        
                        Integer day = Integer.valueOf(dayStr);Integer month = Integer.valueOf(monthStr);Integer year = Integer.valueOf(yearStr);
                        
                        Date dateToSave = Date.newInstance(year, month, day); // Create the Date object 
                        cs.Telephonic_Conversation_Date__c = dateToSave;
                    }
                }
                if (objMap.containsKey('ComplaintConsumerStatus')) {cs.Consumer_Dispute_Status__c =(string)objMap.get('ComplaintConsumerStatus');
                }

                //Update Junk Case
                if (objMap.containsKey('Junkcase')) {cs.Junk_Case__c =true;
                }

                if (objMap.containsKey('JunkStatus')) {cs.Status ='Resolved';
                }
                //Open To resolved
                if (objMap.containsKey('Update_Open_to_Resolved')) {cs.Status ='Resolved';
                }
                if (objMap.containsKey('Send_Email_Acknowledgement')) {cs.Send_Email_Acknowledgement__c =true;
                }
                ///Update Contact Header Details
                if (objMap.containsKey('Contact_Name')) {cs.Contact_Name__c =(string)objMap.get('Contact_Name');
                }
                if (objMap.containsKey('ContactEmailId')) {cs.ContactEmailId__c =(string)objMap.get('ContactEmailId');
                }
                if (objMap.containsKey('Contact_Gender')) {cs.Contact_Gender__c =(string)objMap.get('Contact_Gender');
                }
                if (objMap.containsKey('ContactPan')) {cs.ContactPan__c =(string)objMap.get('ContactPan');
                }
                if (objMap.containsKey('ContactMobileNo')) {cs.ContactMobileNo__c =(string)objMap.get('ContactMobileNo');
                }
                if (objMap.containsKey('Contact_Date_of_Birth')) {
                    String dateValue1 = (String) objMap.get('Contact_Date_of_Birth');
                    if(String.isNotBlank(dateValue1)) {
                        String dayStr = dateValue1.substring(0, 2);    // Extract day (positions 0-1)
                        String monthStr = dateValue1.substring(3, 5);  // Extract month (positions 3-4)
                        String yearStr = dateValue1.substring(6, 10);  // Extract year (positions 6-9)
                        
                        Integer day = Integer.valueOf(dayStr);Integer month = Integer.valueOf(monthStr);Integer year = Integer.valueOf(yearStr);
                        
                        Date dateToSave = Date.newInstance(year, month, day); // Cr
                        cs.Contact_Date_of_Birth__c =dateToSave;
                    }
                }
                if (objMap.containsKey('Contact_Address')) {
                    string strAdd = (string)objMap.get('Contact_Address');
                    strAdd = strAdd.replace(';',',');
                    if(!strAdd.contains('.')) 
                       cs.Contact_Address__c = strAdd;
                }
                
                //Send Compensation Email
                if(objMap.containsKey('isSendEmail')){
                    cs.Send_Compensation_Email__c = true;
                }
                
                //Send Compensation Reminder Email
                if(objMap.containsKey('reSend')){
                    cs.Send_Compensation_Reminder_Email__c = true;
                }
                
                csList.add(cs);
            }
        }
        
        if(csList.size() > 0){
            Database.SaveResult[] results = Database.update(csList, false); // 'false' allows partial success
            system.debug('results-->'+results);
            
            for (Integer i = 0; i < results.size(); i++) {
                
                Map<string,object> resultMap = new Map<string,object> ();
                system.debug('objMapsError-->'+objMapsError);
                if (results[i].isSuccess()) {
                    system.debug('inside sucess');
                    if(objMapsError.containsKey(csList[i].Id) && (c_type =='Resolved in favour of the Consumer' || c_type =='Resolved in favour of the Consumer - Data Submission')){
                        resultMap.put('Id', csList[i].Id);
                        string str = ((string)objMapsError.get(csList[i].Id));
                        str = str.substringBefore('-');
                        system.debug('str--'+str+' - '+objMapsError.get(csList[i].Id));
                        if(str == 'true'){
                            resultMap.put('Message', '-');
                            resultMap.put('Status', 'Failed');
                            resultMap.put('isError', false);
                            resultMap.put('logError', ((string)objMapsError.get(csList[i].Id)).substringAfter('-'));
                        }
                        else{
                            resultMap.put('Message', '');
                            resultMap.put('isError', true);
                            resultMap.put('logError', '-');
                            resultMap.put('Status', 'Already Executed');
                        }
                        result.add(resultMap);
                    }else{
                        resultMap.put('Id', csList[i].Id);
                        resultMap.put('Status', 'Success');
                        resultMap.put('Message', 'Record Update Successfully');
                        
                        result.add(resultMap);
                    }
                } else {
                    
                    system.debug('inside fail');
                    //failedUpdates.add('Failed to update Case with Id: ' + casesToUpdate[i].Id + ' - Error: ' + results[i].getErrors()[0].getMessage());
                    //system.debug();
                    resultMap.put('Id', csList[i].Id);
                    resultMap.put('Status', 'Failed');
                    if(objMapsError.containsKey(csList[i].Id) && (c_type =='Resolved in favour of the Consumer' 
                    || c_type =='Resolved in favour of the Consumer - Data Submission')){
                        string str = ((string)objMapsError.get(csList[i].Id)).substringBefore('-');
                        if(str == 'true' && (c_type =='Resolved in favour of the Consumer' || c_type =='Resolved in favour of the Consumer - Data Submission')){
                            resultMap.put('isError ', false);
                            resultMap.put('logError ', ((string)objMapsError.get(csList[i].Id)).substringAfter('-'));
                        }else{
                            resultMap.put('isError ', true);
                            resultMap.put('logError ', '');
                        }
                    }else 
                    if(c_type =='Resolved in favour of the Consumer' || c_type =='Resolved in favour of the Consumer - Data Submission'){
                        resultMap.put('isError ', false);
                        resultMap.put('logError ', '');
                    }
                    resultMap.put('Message', results[i].getErrors()[0].getStatusCode()+': ' + results[i].getErrors()[0].getMessage()+' - '+results[i].getErrors()[0].getFields());
                    result.add(resultMap);
                    system.debug('Error'+result);
                }
            }
        }
        
        if (cdlList.size() > 0) {
            Database.SaveResult[] results = Database.insert(cdlList, false); // 'false' allows partial success
            system.debug('Insert results: ' + results);
            
            for (Integer i = 0; i < results.size(); i++) {
                Map<String, Object> resultMap = new Map<String, Object>();
                
                if (results[i].isSuccess()) {
                    
                    resultMap.put('Id', cdlList[i].LinkedEntityId); // Corrected to use cdlList[i].Id instead of csList[i].Id
                    resultMap.put('Status', 'Success');
                    resultMap.put('Message', 'Record Updated Successfully');
                    result.add(resultMap);
                } 
                else {
                    resultMap.put('Id', cdlList[i].LinkedEntityId); resultMap.put('Status', 'Failed');
                    resultMap.put('Message', results[i].getErrors()[0].getStatusCode() + ': ' + 
                                  results[i].getErrors()[0].getMessage() + 
                                  ' - ' + results[i].getErrors()[0].getFields()); result.add(resultMap);
                    
                    system.debug('Error details: ' + results[i].getErrors()[0]);
                }
            }
        }
        if(result.size() > 0)
            return result;
        else 
            return null;
    }


    @AuraEnabled
    public static String insertCaseUploadChecker(String fileType, List<Map<String, String>> caseRecords, String csvBase64, String fileName) {
        Id userId = UserInfo.getUserId();

        System.debug('File Type csv' + csvBase64);
        System.debug('File Type filename' + fileName);

        // 1. Create parent record
        Case_Upload_Checker__c checker = new Case_Upload_Checker__c(
            File_Type__c = fileType,
            File_Uploaded_By__c = userId,
            File_Uploaded_Date_Time__c = System.now()
        );
        insert checker;

        // 2. Insert child rows
        List<Case_Upload_Checker_Item__c> items = new List<Case_Upload_Checker_Item__c>();
        for (Map<String, String> row : caseRecords) {

            Case_Upload_Checker_Item__c item = new Case_Upload_Checker_Item__c(
                Case_Upload_Checker__c = checker.Id,
                Case_ID__c = row.get('Id'),
                Case_Number__c = row.get('Id')
            );

            String dateString = row.get('Last_Reply_from_Bank_Team');
            if (!String.isBlank(dateString)) {
                try {
                    List<String> parts = dateString.split('-');
                    if (parts.size() == 3) {
                        item.Last_Reply_from_Bank_Team__c = Date.newInstance(
                            Integer.valueOf(parts[2]), // year
                            Integer.valueOf(parts[1]), // month
                            Integer.valueOf(parts[0])  // day
                        );
                    }
                } catch (Exception e) {
                    System.debug('Date parsing failed: ' + e.getMessage());
                }
            }
            items.add(item);
        }

        if (!items.isEmpty()) insert items;

        // 3. Store uploaded CSV file  
        if (!String.isBlank(csvBase64)) {
            System.debug('File Insertion Started');
            ContentVersion cv = new ContentVersion(
                Title = fileName,
                PathOnClient = '/' + fileName,
                VersionData = EncodingUtil.base64Decode(csvBase64)
            );
            insert cv;

            cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];

            ContentDocumentLink cdl = new ContentDocumentLink(
                ContentDocumentId = cv.ContentDocumentId,
                LinkedEntityId = checker.Id,
                ShareType = 'V'
            );
            insert cdl;
            System.debug('File Insertion Ended');
        }

        return 'Success';
    }


    @AuraEnabled(cacheable=true)
    public static List<Case_Upload_Checker__c> getUploads() {
        return [
            SELECT Id,
                   Name,
                   File_Uploaded_By__r.Name,
                   File_Uploaded_Date_Time__c,
                   No_of_Cases__c,
                   File_Type__c,
                   Status__c         
            FROM Case_Upload_Checker__c
            ORDER BY File_Uploaded_Date_Time__c DESC
        ];
    }

    @AuraEnabled
    public static void approveUpload(Id parentId) {

        // Get child records
        List<Case_Upload_Checker_Item__c> children = [SELECT Id, Case_Number__c, Last_Reply_from_Bank_Team__c, Case_Upload_Checker__r.File_Uploaded_By__c FROM Case_Upload_Checker_Item__c WHERE Case_Upload_Checker__c = :parentId];

        // Map CaseId -> Last Reply Date (from child)
        Map<Id, Date> caseIdToLastReplyMap = new Map<Id, Date>();

        // Map ParentId -> File Uploaded By User
        Id uploadedByUserId;

        for (Case_Upload_Checker_Item__c item : children) {
            if (item.Case_Number__c != null) {
                caseIdToLastReplyMap.put(item.Case_Number__c, item.Last_Reply_from_Bank_Team__c);
            }
            // Capture the user who uploaded the file (same for all children under a parent)
            if (uploadedByUserId == null && 
                item.Case_Upload_Checker__r.File_Uploaded_By__c != null) {

                uploadedByUserId = item.Case_Upload_Checker__r.File_Uploaded_By__c;
            }
        }

        System.debug('File Uploaded By '+ uploadedByUserId);

        if (!caseIdToLastReplyMap.isEmpty()) {

            List<Case> casesToUpdate = [
                SELECT Id, Consumer_Dispute_Status__c, Last_Reply_from_Bank_Team__c
                FROM Case
                WHERE Id IN :caseIdToLastReplyMap.keySet()
            ];

            for (Case c : casesToUpdate) {
                c.Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer';
                c.Last_Reply_from_Bank_Team__c = caseIdToLastReplyMap.get(c.Id);  
                c.Ticket_Closed_By__c = uploadedByUserId;
            }

            update casesToUpdate;
            delete children;
        }

        Id userId = UserInfo.getUserId();
        Case_Upload_Checker__c parent = new Case_Upload_Checker__c(
            Id = parentId,
            Status__c = 'Approved',
            Checker__c = userId,
            Checker_Approved_Rejected_Date_Time__c = Datetime.now()
        );
        update parent;
    }


    @AuraEnabled
    public static void updateStatus(Id recordId, String status) {
        if (String.isBlank(recordId) || String.isBlank(status)) return;

        Id userId = UserInfo.getUserId();
        Case_Upload_Checker__c recordToUpdate = [
            SELECT Id, Status__c, Checker__c, Checker_Approved_Rejected_Date_Time__c
            FROM Case_Upload_Checker__c 
            WHERE Id = :recordId
            LIMIT 1
        ];
        recordToUpdate.Checker__c = userId;
        recordToUpdate.Checker_Approved_Rejected_Date_Time__c = Datetime.now();
        recordToUpdate.Status__c = status;
        update recordToUpdate;
    }

    @AuraEnabled(cacheable=false)
    public static List<Case_Upload_Checker_Item__c> getChildRecords(Id parentId) {
        return [
            SELECT Id, Case_Number__r.CaseNumber, Case_ID__c, Last_Reply_from_Bank_Team__c
            FROM Case_Upload_Checker_Item__c
            WHERE Case_Upload_Checker__c = :parentId
            ORDER BY CreatedDate ASC
        ];
    }


    
    @AuraEnabled(cacheable=false)
    public static List<Case_Upload_Checker_Item__c> getChildCaseUploadCheckerItemRecords(Id parentId) {
        return [
            SELECT Id, Name, Case_Upload_Checker__r.Name, Case_Number__r.CaseNumber, Case_ID__c, Last_Reply_from_Bank_Team__c
            FROM Case_Upload_Checker_Item__c
            WHERE Case_Upload_Checker__c = :parentId
            ORDER BY CreatedDate ASC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static String getUploadedCsvDownloadUrl(Id parentId) {
        // Query attached file
        ContentDocumentLink cdl = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :parentId
            LIMIT 1
        ];

        ContentVersion cv = [
            SELECT Id
            FROM ContentVersion
            WHERE ContentDocumentId = :cdl.ContentDocumentId
            ORDER BY VersionNumber DESC
            LIMIT 1
        ];

        // Standard Salesforce download URL
        return '/sfc/servlet.shepherd/version/download/' + cv.Id;
    }


    // Result wrapper returned to the client for each processed child id
    public class ChunkResult {
        @AuraEnabled public Id childId;
        @AuraEnabled public Id caseId;
        @AuraEnabled public Boolean success;
        @AuraEnabled public String message;
    }

    // @AuraEnabled
    // public static List<ChunkResult> approveUploadChunk(List<Id> childIds, Id parentId) {
    //     List<ChunkResult> results = new List<ChunkResult>();

    //     if (childIds == null || childIds.isEmpty()) {
    //         return results;
    //     }

    //     // Query the child items and capture the uploadedBy user from the parent lookup
    //     List<Case_Upload_Checker_Item__c> children = [
    //         SELECT Id, Case_Number__c, Last_Reply_from_Bank_Team__c, Case_Upload_Checker__c,
    //             Case_Upload_Checker__r.File_Uploaded_By__c
    //         FROM Case_Upload_Checker_Item__c
    //         WHERE Id IN :childIds
    //     ];

    //     // Build map CaseId -> LastReply, and capture uploadedByUserId (first non-null)
    //     Map<Id, Date> caseIdToLastReply = new Map<Id, Date>();
    //     Id uploadedByUserId;

    //     for (Case_Upload_Checker_Item__c ci : children) {
    //         if (ci.Case_Number__c != null) {
    //             caseIdToLastReply.put(ci.Case_Number__c, ci.Last_Reply_from_Bank_Team__c);
    //         }
    //         if (uploadedByUserId == null && ci.Case_Upload_Checker__r != null) {
    //             uploadedByUserId = ci.Case_Upload_Checker__r.File_Uploaded_By__c;
    //         }
    //     }

    //     // Prepare list of Cases to update
    //     List<Case> casesToUpdate = new List<Case>();

    //     if (!caseIdToLastReply.isEmpty()) {
    //         casesToUpdate = [
    //             SELECT Id, Consumer_Dispute_Status__c, Last_Reply_from_Bank_Team__c, Ticket_Closed_By__c
    //             FROM Case
    //             WHERE Id IN :caseIdToLastReply.keySet()
    //         ];

    //         for (Case c : casesToUpdate) {
    //             c.Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer';
    //             c.Last_Reply_from_Bank_Team__c = caseIdToLastReply.get(c.Id);

    //             if (uploadedByUserId != null) {
    //                 c.Ticket_Closed_By__c = uploadedByUserId;
    //             }
    //         }

    //         System.debug('Cases to update ======> '+casesToUpdate);

    //         try {
    //             update casesToUpdate;
    //         }
    //         catch (DmlException dmle) {
    //             System.debug('Partial case update failure: ' + dmle.getMessage());
    //         }
    //     }

    //     // Build map of updated cases for success checking
    //     Map<Id, Case> updatedCaseMap = new Map<Id, Case>();
    //     for (Case c : casesToUpdate) {
    //         updatedCaseMap.put(c.Id, c);
    //     }

    //     // Build result list (NO DELETION)
    //     for (Case_Upload_Checker_Item__c ci : children) {
    //         ChunkResult r = new ChunkResult();
    //         r.childId = ci.Id;
    //         r.caseId = ci.Case_Number__c;
    //         r.success = false;
    //         r.message = '';

    //         if (ci.Case_Number__c != null && updatedCaseMap.containsKey(ci.Case_Number__c)) {
    //             r.success = true;
    //             r.message = 'Case updated';
    //         }
    //         else if (ci.Case_Number__c == null) {
    //             r.success = false;
    //             r.message = 'No Case lookup present on child record';
    //         }
    //         else {
    //             r.success = false;
    //             r.message = 'Case update not performed or case not found';
    //         }

    //         results.add(r);
    //     }

    //     Id userId = UserInfo.getUserId();
    //     if (parentId != null) {
    //         try {
    //             Case_Upload_Checker__c parentObj = new Case_Upload_Checker__c(
    //                 Id = parentId,
    //                 Status__c = 'Approved',
    //                 Checker__c = userId,
    //                 Checker_Approved_Rejected_Date_Time__c = Datetime.now()
    //             );
    //             update parentObj;
    //         } catch (Exception ex) {
    //             System.debug('Parent approval update failed: ' + ex.getMessage());
    //         }
    //     }

    //     return results;
    // }  


    @AuraEnabled
    public static List<ChunkResult> approveUploadChunk(List<Id> childIds, Id parentId) {

        List<ChunkResult> results = new List<ChunkResult>();

        if (childIds == null || childIds.isEmpty()) {
            return results;
        }

        // 1. Fetch child records
        List<Case_Upload_Checker_Item__c> children = [
            SELECT Id, Case_Number__c, Last_Reply_from_Bank_Team__c, Case_Upload_Checker__c,
                Case_Upload_Checker__r.File_Uploaded_By__c
            FROM Case_Upload_Checker_Item__c
            WHERE Id IN :childIds
        ];

        Map<Id, Date> caseIdToLastReply = new Map<Id, Date>();
        Id uploadedByUserId;

        for (Case_Upload_Checker_Item__c ci : children) {
            if (ci.Case_Number__c != null) {
                caseIdToLastReply.put(ci.Case_Number__c, ci.Last_Reply_from_Bank_Team__c);
            }
            if (uploadedByUserId == null && ci.Case_Upload_Checker__r != null) {
                uploadedByUserId = ci.Case_Upload_Checker__r.File_Uploaded_By__c;
            }
        }

        // 2. Prepare case updates
        List<Case> casesToUpdate = new List<Case>();

        if (!caseIdToLastReply.isEmpty()) {
            casesToUpdate = [
                SELECT Id, Consumer_Dispute_Status__c, Last_Reply_from_Bank_Team__c, Ticket_Closed_By__c
                FROM Case
                WHERE Id IN :caseIdToLastReply.keySet()
            ];

            for (Case c : casesToUpdate) {
                c.Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer';
                c.Last_Reply_from_Bank_Team__c = caseIdToLastReply.get(c.Id);

                if (uploadedByUserId != null) {
                    c.Ticket_Closed_By__c = uploadedByUserId;
                }
            }
        }

        // 3. Update Cases with error capture
        Map<Id, String> caseErrors = new Map<Id, String>();

        if (!casesToUpdate.isEmpty()) {  
            Database.SaveResult[] srList = Database.update(casesToUpdate, false); // ALLOW PARTIAL SUCCESS

            Integer i = 0;
            for (Database.SaveResult sr : srList) {
                Case c = casesToUpdate[i];

                if (!sr.isSuccess()) {
                    // get first error
                    caseErrors.put(c.Id, sr.getErrors()[0].getMessage());
                }
                i++;
            }
        }

        // Build success map
        Set<Id> updatedCaseIds = new Set<Id>();
        for (Case c : casesToUpdate) {
            if (!caseErrors.containsKey(c.Id)) {
                updatedCaseIds.add(c.Id);
            }
        }

        // 4. Build result for each child row
        for (Case_Upload_Checker_Item__c ci : children) {
            ChunkResult res = new ChunkResult();
            res.childId = ci.Id;
            res.caseId = ci.Case_Number__c;

            if (ci.Case_Number__c == null) {
                res.success = false;
                res.message = 'No Case lookup present on child record';
            }
            else if (caseErrors.containsKey(ci.Case_Number__c)) {
                res.success = false;
                res.message = caseErrors.get(ci.Case_Number__c);   // <-- return validation rule / trigger error
            }
            else if (updatedCaseIds.contains(ci.Case_Number__c)) {
                res.success = true;
                res.message = 'Case updated successfully';
            }
            else {
                res.success = false;
                res.message = 'Case not updated (unknown reason)';
            }

            results.add(res);
        }

        // 5. Update parent record with error handling
        if (parentId != null) {
            try {
                Case_Upload_Checker__c parentObj = new Case_Upload_Checker__c(
                    Id = parentId,
                    Status__c = 'Approved',
                    Checker__c = UserInfo.getUserId(),
                    Checker_Approved_Rejected_Date_Time__c = Datetime.now()
                );
                update parentObj;
            } 
            catch (Exception ex) {
                System.debug('Parent approval update failed: ' + ex.getMessage());
                
            }
        }

        return results;
}

    
}