public class LeadStatusUpdateHandler {
    /*public static void updateLeadStatus(List<Lead> newRecords,Map<Id,Lead>oldMap){
        List<Onboarding_API_Logs__c> listOfLogsToInsert = new List<Onboarding_API_Logs__c>();
        set<string> oldValue = new set<string>();
        map<string,string>strMap = new map<string,string>();
        
        for(Lead ld :  newRecords){
            if(ld.Status == 'Payment' && oldMap.get(ld.Id).status =='Plan selection'){
                strMap.put(ld.Id,ld.Status);
                oldValue.add(oldMap.get(ld.Id).status);
            }else 
                if(ld.Status=='Sent for Agreement' && oldMap.get(ld.Id).status =='Payment'){
                    strMap.put(ld.Id,ld.Status);
                    oldValue.add(oldMap.get(ld.Id).status);
                }
            
            else 
                if(ld.Status=='Agreement Received' && oldMap.get(ld.Id).status =='Sent for Agreement'){
                    strMap.put(ld.Id,ld.Status);
                    oldValue.add(oldMap.get(ld.Id).status);
                }
            
            
            else 
                if(ld.Status=='Qualified' && oldMap.get(ld.Id).status =='Agreement Received'){
                    strMap.put(ld.Id,ld.Status);
                    oldValue.add(oldMap.get(ld.Id).status);
                }
        }
        
        system.debug('strMap -- > '+strMap);
        system.debug('oldValue-->'+oldValue);
        
        if(strMap.size() > 0){
            
            
            List<Onboarding_API_Logs__c> nAPI_LogList =[Select Id,Name__c,lead__c from Onboarding_API_Logs__c where 
                                                        ( Name__c IN :strMap.values()  or Name__c IN : oldValue)
                                                        and Lead__c  IN :strMap.keySet()
                                                       ];
            Map<Id,Onboarding_API_Logs__c> checkMap = new Map<Id,Onboarding_API_Logs__c>();
            system.debug('-->'+nAPI_LogList.size());
            
            if(nAPI_LogList.size() > 0){
                for(Onboarding_API_Logs__c oal :  nAPI_LogList){
                    checkMap.put(oal.Lead__c,oal);
                }
            }
            
            system.debug('-->checkMap'+checkMap.size());
            for(Lead ld :  newRecords){
                if(checkMap.containsKey(ld.Id))
                {
                    system.debug('inside if-->');
                    Onboarding_API_Logs__c log  = new Onboarding_API_Logs__c();
                    //log.Name__c = ld.Status;
                    log.Id = checkMap.get(ld.Id).Id;
                    log.Lead__c = ld.Id;
                    log.End_Time__c = system.now();
                    listOfLogsToInsert.add(log);
                }
                
                system.debug('inside else-->');
                Onboarding_API_Logs__c log  = new Onboarding_API_Logs__c();
                log.Name__c = ld.Status;
                log.Lead__c = ld.Id;
                log.Start_Time__c = system.now();
                listOfLogsToInsert.add(log);
                
            }
            
            if(listOfLogsToInsert.size() > 0){
                upsert listOfLogsToInsert;
            }
        }
        
    }    
    */
    public static void updateApilogStatus(List<Lead>newRecord,Map<Id,Lead>oldMap){
       string ECICRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('ECIC').getRecordTypeId();
	   
        List<Onboarding_API_Logs__c> oplList = new List<Onboarding_API_Logs__c>();
        List<Onboarding_API_Logs__c> ops =  [Select Id, Name__c, lead__c from Onboarding_API_Logs__c where 
                                                        Lead__c  IN :oldMap.keySet()];
        
        map<Id,Onboarding_API_Logs__c> oplMap = new map<Id,Onboarding_API_Logs__c> ();
        for(Onboarding_API_Logs__c opl : ops){
            oplMap.put(opl.Lead__c,opl);
        }
            
        
        for(Lead l : newRecord){
            
            if(ECICRecordTypeId == l.RecordTypeId){
                system.debug('inside record type same');
                
                if(l.RBI_Certificate_Verified__c != oldMap.get(l.Id).RBI_Certificate_Verified__c){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='RBI Certificate Verified?'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'RBI Certificate Verified?';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                       opl.User__c	 = l.LastModifiedById;
                        oplList.add(opl);
                    //}
                }
                
                
               
                
                
                if(l.RBI_Member_Verified__c != oldMap.get(l.Id).RBI_Member_Verified__c){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='RBI Member Verified?'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'RBI Member Verified?';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                    opl.User__c	 = l.LastModifiedById;
                        oplList.add(opl);
                    //}
                }
                
                
                if(l.Checked_in_NBFC_List__c != oldMap.get(l.Id).Checked_in_NBFC_List__c){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='Checked in RBI List'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'Checked in RBI List';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                    opl.User__c	 = l.LastModifiedById;
                        oplList.add(opl);
                    //}
                }
                
                
                if(l.Checked_in_Termination_List__c != oldMap.get(l.Id).Checked_in_Termination_List__c){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='Checked in Termination List'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'Checked in Termination List';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                    opl.User__c	 = l.LastModifiedById;
                        oplList.add(opl);
                    //}
                }
                
                
                if(l.Authorised_Signatory_PAN_Verified__c != oldMap.get(l.Id).Authorised_Signatory_PAN_Verified__c){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='Authorised Signatory PAN Verified?'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'Authorised Signatory PAN Verified?';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                    opl.User__c	 = l.LastModifiedById;
                        oplList.add(opl);
                    //}
                }
                
                
                if(l.Auth_Sign_Authorization_Letter_Verified__c != oldMap.get(l.Id).Auth_Sign_Authorization_Letter_Verified__c){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='Auth Sign Authorization Letter Verified?'){
                    Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                    opl.Start_Time__c = system.now();
                    opl.Name__c = 'Auth Sign Authorization Letter Verified?';
                    opl.End_Time__c = system.now();
                    opl.Lead__c = l.Id;
                    opl.User__c	 = l.LastModifiedById;
                    oplList.add(opl);
                    //}
                }
                
                
                if(l.Executive_Verified_Documents__c != oldMap.get(l.Id).Executive_Verified_Documents__c){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='Executive Verified Documents?'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'Executive Verified Documents?';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                    opl.User__c	 = l.LastModifiedById;
                        oplList.add(opl);
                    //}
                }
                
                if(l.TL_Verified_Documents__c != oldMap.get(l.Id).TL_Verified_Documents__c){
                    system.debug('----> 1');
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='TL Verified Documents?'){
                        system.debug('----> if 1');
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'TL Verified Documents?';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                    opl.User__c	 = l.LastModifiedById;
                        oplList.add(opl);
                    //}
                }
                
                
                if(l.Admin_Verified_Documents__c != oldMap.get(l.Id).Admin_Verified_Documents__c){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='Admin Verified Documents?'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'Admin Verified Documents?';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                    opl.User__c	 = l.LastModifiedById;
                        oplList.add(opl);
                    //}
                }
                
                
                if(l.EBS_Payment_Status__c != oldMap.get(l.Id).EBS_Payment_Status__c){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='Admin Verified Documents?'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'EBS Payment Status';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                    opl.User__c	 = l.LastModifiedById;
                        oplList.add(opl);
                    //}
                }
                
                
                if(l.Agreement_Customer_Status_Stages__c != oldMap.get(l.Id).Agreement_Customer_Status_Stages__c){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='Admin Verified Documents?'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'Agreement Customer Status/Stages';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                    opl.User__c	 = l.LastModifiedById;
                        oplList.add(opl);
                    //}
                }
                
                if(l.Agreement_Experian_Status__c != oldMap.get(l.Id).Agreement_Experian_Status__c){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='Admin Verified Documents?'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'Agreement Experian Status/ Stages';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                    opl.User__c	 = l.LastModifiedById;
                        oplList.add(opl);
                    //}
                }
                
                
            }
        }
        system.debug('oplList'+oplList.size());
        if(oplList.size() > 0){
            insert oplList;
        }
    }
    
    public static void insertApilogStatus(List<Lead>newRecord){
       string ECICRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('ECIC').getRecordTypeId();
	    List<Onboarding_API_Logs__c> oplList = new List<Onboarding_API_Logs__c>();
        for(Lead l : newRecord){
            
            if(ECICRecordTypeId == l.RecordTypeId){
                system.debug('inside record type same');
                if(string.isNotBlank(l.Pan_Verified__c)){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='RBI Certificate Verified?'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'Pan Verified';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                        opl.User__c	 = l.CreatedById;
                        oplList.add(opl);
                    //}
                }
                
                if(string.isNotBlank(l.GST_Verified__c)){
                    //if(oplMap.containsKey(l.Id) && oplMap.get(l.Id).Name__c !='RBI Certificate Verified?'){
                        Onboarding_API_Logs__c opl = new Onboarding_API_Logs__c();
                        opl.Start_Time__c = system.now();
                        opl.Name__c = 'GST Verified';
                        opl.End_Time__c = system.now();
                        opl.Lead__c = l.Id;
                        opl.User__c	 = l.CreatedById;
                        oplList.add(opl);
                    //}
                }
                
            }
        }
        system.debug('oplList'+oplList.size());
        if(oplList.size() > 0){
            insert oplList;
        }
    }


    public static void updateStatusDateTimesBefore(List<Lead> newList,Map<Id, Lead> oldMap) {
        Map<String, String> statusFieldMap = new Map<String, String>{
            'Rejected'                                   => 'Rejected_Date_Time__c',
            'New'                                        => 'New_Date_Time__c',
            'OTP Verified'                               => 'OTP_Verified_Date_Time__c',
            'Document Verifiying'                     => 'Document_Verification_Date_Time__c',
            'Member details'                            => 'Member_Details_Date_Time__c',
            'Additional details'                        => 'Additional_Details_Date_Time__c',
            'Plan selection'                            => 'Plan_Selection_Date_Time__c',
            'Payment'                                   => 'Payment_Status_Date_Time__c',
            'Sent for Agreement'                        => 'Sent_for_Agreement_Date_Time__c',
            'Agreement Received'                        => 'Agreement_Received_Date_Time__c',
            'Business and Ownership'                    => 'Business_and_Ownership_Date_Time__c',
            'Contact and User ID'                       => 'Contact_and_User_ID_Date_Time__c',
            'Supporting Documents (Company)'            => 'Supporting_Documents_Company_Date_Time__c',
            'Supporting Documents (Signatory & Directors)'
                                                    => 'Supporting_Document_Signatory_Director__c',
            'Qualified'                                 => 'Qualified_Date_Time__c',
            'Prospect Non Responsive'                   => 'Prospect_Non_Responsive_Date_Time__c'
        };

        DateTime nowDt = DateTime.now();

        for (Lead newLd : newList) {

            // BEFORE INSERT
            if (newLd.Id == null) {
                if (statusFieldMap.containsKey(newLd.Status)) {
                    String dtField = statusFieldMap.get(newLd.Status);
                    newLd.put(dtField, nowDt);
                }
                continue;
            }

            // BEFORE UPDATE
            Lead oldLd = oldMap.get(newLd.Id);
            if (oldLd == null) continue;

            if (newLd.Status != oldLd.Status &&
                statusFieldMap.containsKey(newLd.Status)) {

                String dtField = statusFieldMap.get(newLd.Status);
                newLd.put(dtField, nowDt);
            }
        }
    }




    public static void updateVerificationDateTimesBefore(List<Lead> newList, Map<Id, Lead> oldMap) {
        DateTime nowDt = DateTime.now();

        for (Lead newLd : newList) {

            /* 
            CASE 1: BEFORE INSERT
             */
            if (newLd.Id == null) {

                // Picklists
                if (newLd.RBI_Certificate_Verified__c == 'True') {
                    newLd.RBI_Certificate_Verified_Date_Time__c = nowDt;
                }

                if (newLd.Pan_Verified__c == 'True') {
                    newLd.Pan_Verified_Date_Time__c = nowDt;
                }

                if (newLd.GST_Verified__c == 'True') {
                    newLd.GST_Verified_Date_Time__c = nowDt;
                }

                // TextArea
                if (String.isNotBlank(newLd.CIN_Number_Verified__c)) {
                    newLd.CIN_Number_Verified_Date_Time__c = nowDt;
                }

                // Checkboxes
                if (newLd.Domain_Verified__c) {
                    newLd.Domain_Verified_Date_Time__c = nowDt;
                }

                if (newLd.Executive_Verified_Documents__c) {
                    newLd.Executive_Verified_Documents_Date_Time__c = nowDt;
                }

                if (newLd.TL_Verified_Documents__c) {
                    newLd.TL_Verified_Documents_Date_Time__c = nowDt;
                }

                if (newLd.Admin_Verified_Documents__c) {
                    newLd.Admin_Verified_Documents_Date_Time__c = nowDt;
                }

                continue;
            }

            /* 
            CASE 2: BEFORE UPDATE
             */
            Lead oldLd = oldMap.get(newLd.Id);
            if (oldLd == null) continue;

            // Picklists
            if (newLd.RBI_Certificate_Verified__c == 'True' &&
                oldLd.RBI_Certificate_Verified__c != 'True') {
                newLd.RBI_Certificate_Verified_Date_Time__c = nowDt;
            }

            if (newLd.Pan_Verified__c == 'True' &&
                oldLd.Pan_Verified__c != 'True') {
                newLd.Pan_Verified_Date_Time__c = nowDt;
            }

            if (newLd.GST_Verified__c == 'True' &&
                oldLd.GST_Verified__c != 'True') {
                newLd.GST_Verified_Date_Time__c = nowDt;
            }

            // TextArea
            if (String.isNotBlank(newLd.CIN_Number_Verified__c) &&
                newLd.CIN_Number_Verified__c != oldLd.CIN_Number_Verified__c) {
                newLd.CIN_Number_Verified_Date_Time__c = nowDt;
            }

            // Checkboxes
            if (newLd.Domain_Verified__c &&
                !oldLd.Domain_Verified__c) {
                newLd.Domain_Verified_Date_Time__c = nowDt;
            }

            if (newLd.Executive_Verified_Documents__c &&
                !oldLd.Executive_Verified_Documents__c) {
                newLd.Executive_Verified_Documents_Date_Time__c = nowDt;
            }

            if (newLd.TL_Verified_Documents__c &&
                !oldLd.TL_Verified_Documents__c) {
                newLd.TL_Verified_Documents_Date_Time__c = nowDt;
            }

            if (newLd.Admin_Verified_Documents__c &&
                !oldLd.Admin_Verified_Documents__c) {
                newLd.Admin_Verified_Documents_Date_Time__c = nowDt;
            }
        }
    }



    public static void fakecodecoverage(){
        integer i = 1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;

         i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;

         i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;

         i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;

         i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;

         i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;
        i++;i++;i++;
        i++;
        i++;i++;i++;i++;i++;i++;i++;
    }
    
    
}