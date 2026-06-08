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

                //Payment Confirmation to Consumer
                if(objMap.containsKey('isSendPaymentConfirmation')){
                    cs.Send_Payment_Confirmation_to_Consumer__c = true;
                }

                //Compensation Email - Payment to Consumer
                if(objMap.containsKey('isCompensationEmailPayment')){
                    cs.Compensation_Email_Payment_to_Consumer__c = true;
                }

                if(objMap.containsKey('isSendEmailToConsumerForDelayCIC')){
                    cs.Send_Email_to_Consumer_for_delay_CIC__c = true;
                }
                
                if(objMap.containsKey('isSendCompensationPaymentReprocessing')){
                    cs.Send_Compensation_Payment_Reprocessing__c = true;
                }

                //Send Compensation Reminder Email
                if(objMap.containsKey('reSend')){
                    cs.Send_Compensation_Reminder_Email__c = true;
                }

                if(objMap.containsKey('isUpdateNCCase')){
                    cs.NC_Case__c = true;
                }

                if(objMap.containsKey('isSendProvideProof')){
                    cs.Send_Provide_Proof__c = true;
                }

                if(objMap.containsKey('isSendNewProvideProof')){
                    cs.Send_New_Provide_Proof_Email__c = true;
                }

                if(objMap.containsKey('isSendNC1stAttempt')){
                    cs.Send_NC_1st_Attempt_Email__c = true;
                }

                if(objMap.containsKey('isSendCallBack')){
                    cs.Send_Call_Back_Email__c = true;
                }

                if(objMap.containsKey('ECICI_Remarks')){
                    cs.ECICI_Remarks__c = (String)objMap.get('ECICI_Remarks');
                }

                if(objMap.containsKey('ReClose')){
                    cs.Status = 'ReClose';
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
    
}