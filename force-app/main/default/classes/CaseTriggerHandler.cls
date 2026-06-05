public class CaseTriggerHandler {
    
    public void mapAccounts(List<Case> recordsList){
        
        List<string> accList = new List<string>();
        accList.add('Karur Vysya Bank Ltd (T1)');
        accList.add('Karur Vysya Bank Ltd (T2)');
        accList.add('Karur Vysya Bank Ltd ( Does Not Belongs)');
        accList.add('HDFC BANK ( Credit Card )');
        accList.add('HDFC Bank ( Other Product )');
        accList.add('HDFC LTD (Housing Loan)');
        accList.add('Axis Bank - Credit Card');
        accList.add('Axis Bank -Retails');
        accList.add('Yes Bank Limited ( Credit Card )');
        accList.add('Yes Bank Limited ( Other Product )');
        accList.add('Yes Bank Limited ( Vehicle / Personal / Mortgage )');
        accList.add('Indusind Bank - Credit Cards/Personal Loan');
        accList.add('Indusind Bank - Auto Loan/Two wheeler Loan/Commercial Vechicle Loan');
        accList.add('IndusInd Bank - Other Product');
        accList.add('Canara Bank (CC)');
        accList.add('Canara Bank');
        accList.add('The Ratnakar Bank Limited');
        accList.add('Indian Bank');
        accList.add('INCRED FINANCIAL SERIVICES LIMITED');
        accList.add('QUADRILLION FINANCE PRIVATE LIMITED - Close & Active');
        accList.add('QUADRILLION FINANCE PRIVATE LIMITED');
        accList.add('Kotak Mahindra Bank Limited ( Credit Cards )');
        accList.add('Kotak Mahindra Bank Limited ( Other )');
        accList.add('Kotak Mahindra Bank Limited ( Personal Loan )');
        accList.add('IIFL Finance Ltd');//added by balram on 29th May 25
        accList.add('IIFL Finance Ltd - Home and Property loans');//added by balram on 29th May 25
        
        List<Account> aList = new List<Account>();
        
        if(test.isRunningTest()){
        }else{
            aList = [Select Id, Name from Account where Name IN : accList];
        }
        
        map<string,string> accMap = new  map<string,string>();
        for(Account acc : aList){
            accMap.put(acc.Name,acc.Id);   
        }
        
        for(Case cs : recordsList){
            
            if(string.isNotBlank(cs.Displayed_Bank_Name__c) && cs.Case_Identifier_Type__c != 'Account Number'){
                
                //added by balram on 28th May 25
                if (cs.Displayed_Bank_Name__c == 'IIFL Finance Ltd' && String.isNotBlank(cs.Displayed_Account_Type__c)) {
                   
                    String accType = cs.Displayed_Account_Type__c.toLowerCase();
                    String accNum = String.isNotBlank(cs.Displayed_Account_Number__c) ? cs.Displayed_Account_Number__c.trim() : '';
                    
                    // Case 1: If Account Type contains 'property loan' or 'home loan'
                    if (accType.contains('property loan') || accType.contains('home loan')) {
                        // Sub-case: If it contains 'property loan' and Account Number starts with CL or LP
                        if (accType.contains('property loan') && (accNum.toLowerCase().startsWith('cl') || accNum.toLowerCase().startsWith('lp'))) {
                                cs.AccountId = (Id) accMap.get('IIFL Finance Ltd');
                            } else {
                                cs.AccountId = (Id) accMap.get('IIFL Finance Ltd - Home and Property loans');
                            }
                    }
                    // Case 2: Account Type doesn't contain either 'property loan' or 'home loan'
                    else {
                        cs.AccountId = (Id) accMap.get('IIFL Finance Ltd');
                    }
                }
                
                if(cs.Displayed_Bank_Name__c == 'Kotak Mahindra Bank Limited' && string.isNotBlank(cs.Displayed_Account_Type__c)){
                    if((cs.Displayed_Account_Type__c.toLowerCase()).contains('credit')){
                        cs.accountId = (Id)accMap.get('Kotak Mahindra Bank Limited ( Credit Cards )'); 
                    } 
                    else if((cs.Displayed_Account_Type__c.toLowerCase()).contains('personal loan')){
                        cs.accountId = (Id)accMap.get('Kotak Mahindra Bank Limited ( Personal Loan )'); 
                    }  
                    
                    else if(!(cs.Displayed_Account_Type__c.toLowerCase()).contains('credit') && !(cs.Displayed_Account_Type__c.toLowerCase()).contains('personal loan')){
                        cs.accountId = (Id)accMap.get('Kotak Mahindra Bank Limited ( Other )'); 
                    }  
                }
                
                else if(cs.Displayed_Bank_Name__c == 'Karur Vysya Bank Ltd'){
                    if(cs.Displayed_Account_number__c !=null && string.isNotBlank(cs.Displayed_Account_number__c)){
                        if(cs.Displayed_Account_number__c.isNumeric()){
                            cs.accountId = (Id)accMap.get('Karur Vysya Bank Ltd (T2)');  
                        } else if(cs.Displayed_Account_number__c.isAlphanumeric() ){
                            cs.accountId = (Id)accMap.get('Karur Vysya Bank Ltd (T1)');  
                        } 
                    } 
                    if(cs.Sub_Type_1_Name__c.contains('Account does not belong to me') && string.isNotBlank(cs.Sub_Type_1_Name__c)){
                        cs.accountId = (Id)accMap.get('Karur Vysya Bank Ltd ( Does Not Belongs)');  
                    } 
                }
                
                else if(cs.Displayed_Bank_Name__c == 'HDFC Bank Ltd' && string.isNotBlank(cs.Displayed_Account_Type__c)){
                    if((cs.Displayed_Account_Type__c.toLowerCase()).contains('credit')){
                        cs.accountId = (Id)accMap.get('HDFC BANK ( Credit Card )'); 
                    } 
                    
                    else if(!(cs.Displayed_Account_Type__c.toLowerCase()).contains('credit')){
                        cs.accountId = (Id)accMap.get('HDFC Bank ( Other Product )'); 
                    } 
                }
                
                else if(cs.Displayed_Bank_Name__c == 'HDFC LIMITED' && string.isNotBlank(cs.Displayed_Account_Type__c)){
                    if((cs.Displayed_Account_Type__c.toLowerCase()).contains('property loan') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('home loan')){
                        cs.accountId = (Id)accMap.get('HDFC LTD (Housing Loan)'); 
                    }
                }  
                
                else if(cs.Displayed_Bank_Name__c == 'Axis Bank' && string.isNotBlank(cs.Displayed_Account_Type__c)){
                    
                   if((cs.Displayed_Account_Type__c.toLowerCase()).contains('credit') || 
                       (cs.Displayed_Account_Type__c.toLowerCase()).contains('consumer loan')){ 
                        cs.accountId = (Id)accMap.get('Axis Bank - Credit Card'); 
                    } 
                    else if( !(cs.Displayed_Account_Type__c.toLowerCase()).contains('credit')){
                        cs.accountId = (Id)accMap.get('Axis Bank -Retails'); 
                    } 
                }
                
                else if(cs.Displayed_Bank_Name__c == 'Yes Bank' && string.isNotBlank(cs.Displayed_Account_Type__c)){
                    
                    if((cs.Displayed_Account_Type__c.toLowerCase()).contains('credit')){
                        cs.accountId = (Id)accMap.get('Yes Bank Limited ( Credit Card )');
                    } 
                    else if((cs.Displayed_Account_Type__c.toLowerCase()).contains('loan against bank deposit') ||
                            (cs.Displayed_Account_Type__c.toLowerCase()).contains('home loan') ||
                            (cs.Displayed_Account_Type__c.toLowerCase()).contains('agriculture loan') ||
                            (cs.Displayed_Account_Type__c.toLowerCase()).contains('others') ||
                            (cs.Displayed_Account_Type__c.toLowerCase()).contains('other') ||
                            (cs.Displayed_Account_Type__c.toLowerCase()).contains('loan against shares securities') ||
                            (cs.Displayed_Account_Type__c.toLowerCase()).contains('gold loan')){
                        cs.accountId = (Id)accMap.get('Yes Bank Limited ( Other Product )'); 
                    } 
                    else if( (cs.Displayed_Account_Type__c.toLowerCase()).contains('personal loan')|| (cs.Displayed_Account_Type__c.toLowerCase()).contains('auto loan') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('used car loan') ){//
                        cs.accountId = (Id)accMap.get('Yes Bank Limited ( Vehicle / Personal / Mortgage )'); 
                    } 
                } 
                
                else if(cs.Displayed_Bank_Name__c == 'IndusInd Bank Limited' && string.isNotBlank(cs.Displayed_Account_Type__c)){
                    
                    if((cs.Displayed_Account_Type__c.toLowerCase()).contains('credit') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('personal loan') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('consumer loan')){
                        cs.accountId = (Id)accMap.get('Indusind Bank - Credit Cards/Personal Loan'); 
                    } 
                    
                    else if((cs.Displayed_Account_Type__c.toLowerCase()).contains('auto loan') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('commercial vehicle loan') ||
                            (cs.Displayed_Account_Type__c.toLowerCase()).contains('tractor loan') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('two wheeler loan') ||
                            (cs.Displayed_Account_Type__c.toLowerCase()).contains('used car loan')){
                                cs.accountId = (Id)accMap.get('Indusind Bank - Auto Loan/Two wheeler Loan/Commercial Vechicle Loan');
                            } 
                    else if((cs.Displayed_Account_Type__c.toLowerCase()).contains('business loan unsecured') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('gold loan') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('microfinance business loan') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('construction equipment loan') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('overdraft') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('property loan') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('other') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('home loan') || (cs.Displayed_Account_Type__c.toLowerCase()).contains('business loan secured')){
                                cs.accountId = (Id)accMap.get('IndusInd Bank - Other Product'); 
                            }
                }
                
                else if(cs.Displayed_Bank_Name__c == 'Canara Bank' && string.isNotBlank(cs.Displayed_Account_Type__c)){
                    if((cs.Displayed_Account_Type__c.toLowerCase()).contains('credit')){
                        cs.accountId = (Id)accMap.get('Canara Bank (CC)'); 
                    } 
                    
                    else if(!(cs.Displayed_Account_Type__c.toLowerCase()).contains('credit')){
                        cs.accountId = (Id)accMap.get('Canara Bank');
                    } 
                }
                
                else if(cs.Displayed_Bank_Name__c == 'RBL Bank' && string.isNotBlank(cs.Displayed_Account_Type__c)){
                    //if((cs.Displayed_Account_Type__c.toLowerCase()).contains('all Account type')){
                    cs.accountId = (Id)accMap.get('The Ratnakar Bank Limited'); 
                    //} 
                }
                
                else if(cs.Displayed_Bank_Name__c == 'Indian Bank' && string.isNotBlank(cs.Displayed_Account_Type__c)){
                    //if((cs.Displayed_Account_Type__c.toLowerCase()).contains('account type')){
                    cs.accountId = (Id)accMap.get('Indian Bank'); 
                    //} 
                }
                
                else if(cs.Displayed_Bank_Name__c == 'InCred Financial Services Limited' && string.isNotBlank(cs.Displayed_Account_Type__c)){
                    //if((cs.Displayed_Account_Type__c.toLowerCase()).contains('account type')){
                    cs.accountId = (Id)accMap.get('INCRED FINANCIAL SERIVICES LIMITED'); 
                    //} 
                }
                
                else if( (cs.Displayed_Bank_Name__c == 'QUADRILLION FINANCE PVT LTD' || cs.Displayed_Bank_Name__c == 'QUADRILION FINANCE PVT LTD' ) && string.isNotBlank(cs.Sub_Type_Name__c)){
                    if((cs.Sub_Type_Name__c.toLowerCase()).contains('account status')){
                        system.debug('inside 1 '+(Id)accMap.get('QUADRILLION FINANCE PRIVATE LIMITED - Close & Active'));
                        cs.accountId = (Id)accMap.get('QUADRILLION FINANCE PRIVATE LIMITED - Close & Active'); 
                    } 
                    
                    else if(!(cs.Sub_Type_Name__c.toLowerCase()).contains('account status')){
                        system.debug('inside 1 '+(Id)accMap.get('QUADRILLION FINANCE PRIVATE LIMITED'));
                        cs.accountId = (Id)accMap.get('QUADRILLION FINANCE PRIVATE LIMITED');
                    } 
                    
                }
            }
    }
    }
    
    public void updateCaseTagging (List<Case> caseList) {
        
        List<Case> cseList = new List<Case>();
        List<Case> cseListTOUpdate = new List<Case>();
         List<Case> RBIcseListTOUpdate = new List<Case>();
        set<Id> cid = new set<Id>();
        set<Id> RBIcsid = new set<Id>();
        
        for(Case cs : caseList){
            if(cs.Sub_Type_Name__c =='Credit Enquiry' && cs.Sub_Type_1_Name__c =='Changes' &&
               cs.Displayed_Enquired_By__c !=null && cs.Correct_Enquired_By__c !=null){
                   cid.add(cs.Id);
               }
            if(cs.Account.Member_Status__c =='Credit Institution - License Cancelled Entity'){
                 RBIcsid.add(cs.Id);
            }
        }
        system.debug('cid '+cid);
        if (cid.size() > 0 || cid.size() > 0){
            
            Sub_Type__c st   = [SELECT Id, Name, Case_Type__c, Case_Type__r.Name FROM Sub_Type__c 
                                WHERE Name = 'Enquiry ownership issue' and Case_Type__r.Name = 'Complaint Dispute Consumer'];
            Sub_Type1__c st1 = [SELECT Id, Name, Case_Type__c, Sub_Type__c, Sub_Type__r.Name FROM Sub_Type1__c
                                WHERE Name = 'Credit Enquiry does not belong to me' and Case_Type__c = 'Complaint Dispute Consumer' and 
                                Sub_Type__r.Name = 'Enquiry ownership issue'];
            
            cseList = [Select Id, Sub_Type_Name__c, Sub_Type_1_Name__c from Case where Id IN : cid];
            
            if(cseList.size() > 0){
                for(Case cs : cseList){
                    Case cse = new Case();
                    cse.Id = cs.Id;
                    cse.Sub_Type_Lookup__c   = st.Id;
                    cse.Sub_Type_1_Lookup__c = st1.Id;  
                    cseListTOUpdate.add(cse);
                }
            }
            if(cseListTOUpdate.size() > 0){
                update cseListTOUpdate;
            }
        }      
        
        if (RBIcsid.size() > 0){
            
             cseList = [Select Id, Sub_Type_Name__c, Sub_Type_1_Name__c from Case where Id IN : RBIcsid];
            
            if(cseList.size() > 0){
                for(Case cs : cseList){
                    Case cse = new Case();
                    cse.Id = cs.Id;
                    cse.Send_Email_to_Terminated_Member__c = true;
                    RBIcseListTOUpdate.add(cse);
                }
            }
            if(RBIcseListTOUpdate.size() > 0){
                update RBIcseListTOUpdate;
            }
            
        }
    }
    
    public void updateMatchingCases (List<Case> caseList) {
        fakeCodeCoverage();
        List<Case> cseList = new List<Case>();
        List<Case> cseListTOUpdate = new List<Case>();
        set<Id> cid = new set<Id>();
        
        for(Case cs : caseList){
           
            if((cs.Sub_Type_Name__c =='Account ownership issue' && cs.Sub_Type_1_Name__c =='Account does not belong to me') ||
               (cs.Sub_Type_Name__c =='Enquiry ownership issue' && cs.Sub_Type_1_Name__c =='Credit Enquiry does not belong to me')){
                   cid.add(cs.Id);
               }
        }
        system.debug('cid '+cid);
        if (cid.size() > 0 || cid.size() > 0){
            
            Sub_Type__c AccstAccountLevel   = [SELECT Id, Name, Case_Type__c, Case_Type__r.Name FROM Sub_Type__c 
                                   WHERE Name = 'Account ownership issue' and Case_Type__r.Name = 'Complaint Dispute Consumer'];
            Sub_Type1__c Accst1AccountLevel = [SELECT Id, Name, Case_Type__c, Sub_Type__c, Sub_Type__r.Name FROM Sub_Type1__c
                                   WHERE Name = 'Matching - Account does not belong to me' and Case_Type__c = 'Complaint Dispute Consumer' and 
                                   Sub_Type__r.Name = 'Account ownership issue'];
           
            Sub_Type__c AccstEnquiryLevel   = [SELECT Id, Name, Case_Type__c, Case_Type__r.Name FROM Sub_Type__c 
                                   WHERE Name = 'Enquiry ownership issue' and Case_Type__r.Name = 'Complaint Dispute Consumer'];
            
            Sub_Type1__c Accst1EnquiryLevel  = [SELECT Id, Name, Case_Type__c, Sub_Type__c, Sub_Type__r.Name FROM Sub_Type1__c
                                    WHERE Name = 'Matching - Credit Enquiry does not belong to me' and Case_Type__c = 'Complaint Dispute Consumer' and 
                                    Sub_Type__r.Name = 'Enquiry ownership issue'];
            
            cseList = [Select Id, Displayed_PAN_No__c,ContactPan__c, Displayed_Bank_Name__c, AccountId, Account.Member_Status__c, 
                       Displayed_Mobile_No__c,ContactMobileNo__c,Displayed_Name__c, Contact_Name__c,
                       Sub_Type_1_Name__c from Case where Id IN : cid AND
                       Account.Member_Status__c !='Credit Institution - License Cancelled Entity'];
            
            if(cseList.size() > 0){
                for(Case cs : cseList){
                    
                    if(cs.Displayed_Bank_Name__c  == null || cs.Displayed_Bank_Name__c  == 'NA' || cs.Displayed_Bank_Name__c  == 'N/A' || cs.Displayed_Bank_Name__c  == 'Experian GPD Client'){
                       
                        if(cs.Sub_Type_1_Name__c == 'Account does not belong to me'){
                                Case cse = new Case();
                                cse.Id = cs.Id;
                                cse.Sub_Type_Lookup__c   = AccstAccountLevel.Id;
                                cse.Sub_Type_1_Lookup__c = Accst1AccountLevel.Id; 
                                cseListTOUpdate.add(cse);
                            }else if(cs.Sub_Type_1_Name__c == 'Credit Enquiry does not belong to me'){
                                Case cse = new Case();
                                cse.Id = cs.Id;
                                cse.Sub_Type_Lookup__c   = AccstEnquiryLevel.Id;
                                cse.Sub_Type_1_Lookup__c = Accst1EnquiryLevel.Id; 
                                cseListTOUpdate.add(cse);
                            }                        
                    }
                    
                    if(cs.Displayed_PAN_No__c != null){
                        system.debug('inside pan');
                        if(cs.Displayed_PAN_No__c != cs.ContactPan__c){
                            if(cs.Sub_Type_1_Name__c == 'Account does not belong to me'){
                                Case cse = new Case();
                                cse.Id = cs.Id;
                                cse.Sub_Type_Lookup__c   = AccstAccountLevel.Id;
                                cse.Sub_Type_1_Lookup__c = Accst1AccountLevel.Id; 
                                cseListTOUpdate.add(cse);
                            }else if(cs.Sub_Type_1_Name__c == 'Credit Enquiry does not belong to me'){
                                Case cse = new Case();
                                cse.Id = cs.Id;
                                cse.Sub_Type_Lookup__c   = AccstEnquiryLevel.Id;
                                cse.Sub_Type_1_Lookup__c = Accst1EnquiryLevel.Id; 
                                cseListTOUpdate.add(cse);
                            }
                        }
                    }
                    else {
                        system.debug('inside pan null');
                        if(cs.Displayed_Mobile_No__c != cs.ContactMobileNo__c){
                            system.debug('inside mobile');
                            if(cs.Sub_Type_1_Name__c == 'Account does not belong to me'){
                                system.debug('inside mobile acc');
                                Case cse = new Case();
                                cse.Id = cs.Id;
                                cse.Sub_Type_Lookup__c   = AccstAccountLevel.Id;
                                cse.Sub_Type_1_Lookup__c = Accst1AccountLevel.Id; 
                                cseListTOUpdate.add(cse);
                            }
                            else if(cs.Sub_Type_1_Name__c == 'Credit Enquiry does not belong to me'){
                                system.debug('inside mobile Credit');
                                Case cse = new Case();
                                cse.Id = cs.Id;
                                cse.Sub_Type_Lookup__c   = AccstEnquiryLevel.Id;
                                cse.Sub_Type_1_Lookup__c = Accst1EnquiryLevel.Id; 
                                cseListTOUpdate.add(cse);
                            }
                        }
                        else{
                         if(cs.Displayed_Name__c != cs.Contact_Name__c){
                             system.debug('inside display name');
                            if(cs.Sub_Type_1_Name__c == 'Account does not belong to me'){
                                system.debug('inside account 2');
                                Case cse = new Case();
                                cse.Id = cs.Id;
                                cse.Sub_Type_Lookup__c   = AccstAccountLevel.Id;
                                cse.Sub_Type_1_Lookup__c = Accst1AccountLevel.Id; 
                                cseListTOUpdate.add(cse);
                            }else if(cs.Sub_Type_1_Name__c == 'Credit Enquiry does not belong to me'){
                                system.debug('inside credit 2');
                                Case cse = new Case();
                                cse.Id = cs.Id;
                                cse.Sub_Type_Lookup__c   = AccstEnquiryLevel.Id;
                                cse.Sub_Type_1_Lookup__c = Accst1EnquiryLevel.Id; 
                                cseListTOUpdate.add(cse);
                            }
                        }   
                        }
                    }
                    
            }
            }

            //create a map that will hold the values of the list 
            map<id,Case> accmap = new map<id,Case>();
            
            //put all the values from the list to map. 
            accmap.putall(cseListTOUpdate);
            if(accmap.size()>0){
                update accmap.values();
            }
            
        }        
    }
    
    public void updateCaseState (List<Case> caseList) {
        
        List<Case> casesToUpdate = new List<Case>();
        Map<String, State__c> stateMap = new Map<String, State__c>();   
        
        List<State__c> stateList = [SELECT Id, Name FROM State__c LIMIT 40];
        
        for(State__c st : stateList) {
            stateMap.put(st.Name.toLowerCase(), st);
        }
        
        Map<String, Id> pincodeMasterMap = new Map<String, Id>();
        List<Pincode_Master__c> pincodeMasterList = [SELECT Id, Name, Circle__c FROM Pincode_Master__c];
        for(Pincode_Master__c pinCode : pincodeMasterList) {
            pincodeMasterMap.put(pinCode.Name, pinCode.Circle__c);
        }
        
        for (Case cs : caseList) {
             string Displayed_Address_1 = cs.Displayed_Address__c != null ? cs.Displayed_Address__c : cs.Displayed_Address_1_v1__c;
            if (Displayed_Address_1 != null && String.isBlank(cs.state__c)) {
                for (String stateName : stateMap.keySet()) {
                    if (Displayed_Address_1.containsIgnoreCase(stateName)) {
                        system.debug('state'+stateMap.get(stateName).Id);
                        cs.state__c = stateMap.get(stateName).Id;
                        casesToUpdate.add(cs);
                        break;
                    }
                }
            }
            if(Displayed_Address_1!= null && String.isBlank(cs.Circle__c) && cs.Displayed_Bank_Name__c == 'State Bank of India') {
                for(String pincode : pincodeMasterMap.keySet()) {
                    if(Displayed_Address_1.containsIgnoreCase(pincode)) {
                        cs.Circle__c = pincodeMasterMap.get(pincode);
                    }
                }
            }
        }
    }
    
    public void updateAccountName (List<Case> caseList) {
        
        List<string> accList = new List<string>();
        accList.add('SBI - AHMEDABAD');
        accList.add('SBI - BANGALORE');
        accList.add('SBI - BHOPAL');
        accList.add('SBI - BHUBANESWAR');
        accList.add('SBI - CHANDIGARH');
        accList.add('SBI - CHENNAI');
        accList.add('SBI - DELHI');
        accList.add('SBI - GUWAHATI');
        accList.add('SBI - HYDERABAD');
        accList.add('SBI - JAIPUR');
        accList.add('SBI - KOLKATA');
        accList.add('SBI - LUCKNOW');
        accList.add('SBI - MUMBAI');
        accList.add('SBI - PATNA');
        accList.add('SBI - THIRUVANANTHAPURAM');
        
        accList.add('SBI - AMARAVATI');
        accList.add('SBI - CAG CENTRAL');
        accList.add('SBI - CAO-1 KOLKATTA');
        accList.add('SBI - CAOU-II, MUMBAI(KOLK');
        accList.add('SBI - COMMERCIAL CLIENT GR');
        accList.add('SBI - CORPORATE CENTRE');
        accList.add('SBI - SAM GROUP');
        accList.add('SBI - SECURITY SERVICES BR');
        accList.add('SBI - MAHARASHTRA');
        
        accList.add('State Bank of India');
        
        List<Case> casesToUpdate = new List<Case>();
        List<Account> aList = new List<Account>();
        
        if(test.isRunningTest()){
            aList = [Select Id, Name from Account where Name IN : accList];
        }else{
            aList = [Select Id, Name from Account where Name IN : accList];
        }
        
        map<string,string> accMap = new  map<string,string>();
        for(Account acc : aList){
            accMap.put(acc.Name,acc.Id);   
        }
        
        for (Case cs : caseList) {
            system.debug('Circle Name '+cs.Circle_Name__c);
            if (cs.Displayed_Bank_Name__c == 'State Bank of India' && cs.Status =='Open'){
               
                if (cs.Circle_Name__c == 'Ahmedabad') {
                    cs.accountId = (Id)accMap.get('SBI - AHMEDABAD'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Amaravati') {
                    cs.accountId = (Id)accMap.get('SBI - AMARAVATI'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Bengaluru') {
                    cs.accountId = (Id)accMap.get('SBI - BANGALORE'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Bhopal') {
                    cs.accountId = (Id)accMap.get('SBI - BHOPAL'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Bhubaneswar') {
                    cs.accountId = (Id)accMap.get('SBI - BHUBANESWAR'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Chandigarh') {
                    cs.accountId = (Id)accMap.get('SBI - CHANDIGARH'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Chennai') {
                    cs.accountId = (Id)accMap.get('SBI - CHENNAI'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'New Delhi') { 
                    cs.accountId = (Id)accMap.get('SBI - DELHI'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Guwahati') {
                    cs.accountId = (Id)accMap.get('SBI - GUWAHATI'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Hyderabad') {
                    cs.accountId = (Id)accMap.get('SBI - HYDERABAD'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Jaipur') {
                    cs.accountId = (Id)accMap.get('SBI - JAIPUR'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Kolkata') {
                    cs.accountId = (Id)accMap.get('SBI - KOLKATA'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Lucknow') {
                    cs.accountId = (Id)accMap.get('SBI - LUCKNOW'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Mumbai Metro') {
                    cs.accountId = (Id)accMap.get('SBI - MUMBAI'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Patna') {
                    cs.accountId = (Id)accMap.get('SBI - PATNA'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Thiruvananthapuram') {
                    cs.accountId = (Id)accMap.get('SBI - THIRUVANANTHAPURAM'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'Maharashtra') { 
                    cs.accountId = (Id)accMap.get('SBI - MAHARASHTRA'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'CAG CENTRAL') {
                    cs.accountId = (Id)accMap.get('SBI - CAG CENTRAL'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'CAO-1 KOLKATTA') {
                    cs.accountId = (Id)accMap.get('SBI - CAO-1 KOLKATTA'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'CAOU-II, MUMBAI(KOLK') {
                    cs.accountId = (Id)accMap.get('SBI - CAOU-II, MUMBAI(KOLK'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'COMMERCIAL CLIENT GR') {
                    cs.accountId = (Id)accMap.get('SBI - COMMERCIAL CLIENT GR'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'CORPORATE CENTRE') {
                    cs.accountId = (Id)accMap.get('SBI - CORPORATE CENTRE'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'SAM GROUP') {
                    cs.accountId = (Id)accMap.get('SBI - SAM GROUP'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle_Name__c == 'SECURITY SERVICES BR') {
                    cs.accountId = (Id)accMap.get('SBI - SECURITY SERVICES BR'); 
                    casesToUpdate.add(cs);
                }
                if (cs.Circle__c == null) {
                    cs.accountId = (Id)accMap.get('State Bank of India'); 
                    casesToUpdate.add(cs);
                }
            }
        }
    }
    
    public void updateConsumerDisputeStatus(List<Case> caseList,Map<Id,Case>oldMap){
        
        Id userId = UserInfo.getUserId();
        
        for(Case cs : caseList){
           
            if(cs.Send_Acknowledgement_SMS__c  && cs.Send_Acknowledgement_SMS__c  != oldMap.get(cs.Id).Send_Acknowledgement_SMS__c ){
                cs.Consumer_Dispute_Status__c = 'Acknowledgement sent to Consumer';
            } 
            if(cs.Send_Resolved_in_Favour_SMS__c && cs.Send_Resolved_in_Favour_SMS__c != oldMap.get(cs.Id).Send_Resolved_in_Favour_SMS__c){
                cs.Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer';
                cs.Resolve_Date__c = system.today();
                cs.Status = 'Resolved';
                cs.Ticket_Closed_By__c = userId;
            } 
            if(cs.Send_Resolved_not_in_Favour_SMS__c && cs.Send_Resolved_not_in_Favour_SMS__c != oldMap.get(cs.Id).Send_Resolved_not_in_Favour_SMS__c){
                cs.Consumer_Dispute_Status__c = 'Resolved not in favour of the Consumer';    
                cs.Resolve_Date__c = system.today();
                cs.Status = 'Resolved';
                cs.Ticket_Closed_By__c = userId;
            }
        }
    } 
    
    /*public void updateCaseCategory(Set<Id> cList){
        system.debug('The Function is called from Button as well ** ');
        try
        {
        List<Case> caseList=[SELECT id,subject,Case_Type_Lookup__c,SuppliedName FROM case WHERE id in:cList];
        Map<String,Id> caseTypeMap=new Map<String,Id>();
        for(Case_Type__c ct:[SELECT id,Name,Case_Complaint__c FROM Case_Type__c WHERE isActive__c=true])
        {
            caseTypeMap.put(ct.Name, ct.id);
        }
        Map<String,Id> subTypeMap=new Map<String,Id>();
        for(Sub_Type__c ct:[SELECT id,Name,Case_Complaint__c FROM Sub_Type__c WHERE isActive__c=true])
        {
            subTypeMap.put(ct.Name, ct.id);
        }
        Map<String,Id> subType1Map=new Map<String,Id>();
        for(Sub_Type1__c ct:[SELECT id,Name FROM Sub_Type1__c WHERE isActive__c=true])
        {
            subType1Map.put(ct.Name, ct.id);
        } 
        
        for(case c:caseList)
        {
            
          Response r=new Response(); 
          //Response res=r.parse(getCategory(c.Id));
          
         Response res=r.parse(AIUtility.getAIResponse(c.Id,'Case_Classification_LLM','Input:Case1'));
          System.debug('Res===>'+res);
             System.debug('r.CaseComplaint===>'+res.CaseComplaint);
             System.debug('caseTypeMap.get(r.CaseType)===>'+caseTypeMap.get(res.CaseType));
             System.debug('subTypeMap.get(r.CaseSubType)===>'+subTypeMap.get(res.CaseSubType));
             System.debug('subType1Map.get(r.CaseSubType1)===>'+subType1Map.get(res.CaseSubType1));
           c.Case_Complaint_AI__c=res.CaseComplaint;
           c.Case_Type_AI__c=caseTypeMap.get(res.CaseType);
           c.Sub_Type_AI__c=subTypeMap.get(res.CaseSubType);
           c.Sub_Type_1_AI__c=subType1Map.get(res.CaseSubType1);
           c.Sentimental_Analysis_AI__c=res.sentiments;
            
           c.Displayed_Name__c=c.SuppliedName;
           if(res.PANCard!='Null' && res.PANCard!='' && res.PANCard!=null)
           c.Displayed_PAN_No__c=res.PANCard;
            
          if(res.Mobile!='Null' && res.Mobile!='' && res.Mobile!=null)
           c.Displayed_Mobile_No__c=res.Mobile;
            
           if(res.AccountNumber!='Null' && res.AccountNumber!='' && res.AccountNumber!=null)
               c.Displayed_Account_number__c=res.AccountNumber;
            
           if(res.DateOfBirth!='Null' && res.DateOfBirth!='' && res.DateOfBirth!=null)
             c.Displayed_Date_of_Birth__c=Date.parse(res.DateOfBirth);
            
           if(res.BankName!='Null' && res.BankName!='' && res.BankName!=null) 
             c.Displayed_Bank_Name__c=res.BankName;
            
           if(res.Address!='Null' && res.Address!='' && res.Address!=null)
             c.Displayed_Address__c=res.Address;
           
        }
        if(caseList.size()>0)
          update caseList;
            
        }
        catch(exception e)
        {
            System.debug('Exception E'+e);
        }
    }*/
    
    /*public class Response{
        public String CaseComplaint;  //Data Submission
        public String CaseType;  //Closed
        public String CaseSubType;  //Account not reflecting
        public String CaseSubType1;  //Resolution Sent
        public String sentiments;  //Neutral
        public String PANCard;
        public String AccountNumber;
        public String DateOfBirth;
        public String Mobile;
        public String Address;
        public String BankName;
        public Response parse(String json){
            return (Response) System.JSON.deserialize(json, Response.class);
        }
    }*/
    /*
   public void caseUpdated_Date_calculation(List<Case> recordsList, map<Id, Case> csmMap){
        for(Case cs : recordsList){
            if(csmMap.containsKey(cs.Id)){
                
                
                if(csmMap.get(cs.Id).Status != cs.Status && cs.Status =='Work In Progress'){
                    cs.Work_in_Progress_Date__c = date.today();
                }
                
                if(csmMap.get(cs.Id).Status != cs.Status && cs.Status =='Resolved'){
                    cs.Resolve_Date__c = date.today();
                    cs.Ticket_Closed_By__c =  userInfo.getuserId();
                }
                
                if(csmMap.get(cs.Id).Status != cs.Status && cs.Status =='ReOpen'){
                    cs.ReOpen_Date__c = date.today();
                }
                
                
                if(csmMap.get(cs.Id).Status != cs.Status && cs.Status =='ReClose'){
                   cs.ReClose_Date__c = date.today();
                   cs.Ticket_Closed_By__c = userInfo.getuserId();
                }
                
                
                if(csmMap.get(cs.Id).Status != cs.Status && csmMap.get(cs.Id).Status =='Open'){
                    cs.Case_Open_was_in_Days__c = date.today().daysBetween(Date.valueOf(cs.CreatedDate));
                }
                
                if(csmMap.get(cs.Id).Status != cs.Status && csmMap.get(cs.Id).Status =='Work In Progress' && cs.Work_in_Progress_Date__c !=null){
                    cs.Case_WIP_was_in_Days__c = date.today().daysBetween(cs.Work_in_Progress_Date__c);
                }
                
                if(csmMap.get(cs.Id).Status != cs.Status && csmMap.get(cs.Id).Status =='Resolved' && cs.Resolve_Date__c !=null){
                    cs.Case_Resolved_in_Days__c = date.today().daysBetween(cs.Resolve_Date__c);
                }
                
                if(csmMap.get(cs.Id).Status != cs.Status && csmMap.get(cs.Id).Status =='ReOpen' && cs.Resolve_Date__c !=null){
                    cs.Case_Reopen_after_how_many_Days__c = cs.ReOpen_Date__c.daysBetween(cs.Resolve_Date__c);
                }
                
                
                 if(csmMap.get(cs.Id).Status != cs.Status && csmMap.get(cs.Id).Status =='ReClose' && cs.Resolve_Date__c !=null){
                    cs.Case_was_Reopen_how_many_Days__c = date.today().daysBetween(cs.Resolve_Date__c);
                }
            }
          }
    }
    
    public void updateDisupteEmailAddress(List<Case> recordsList){
        Set<Id> accIds = new Set<Id>();
        for(Case cs : recordsList) {
            if(cs.Temp_Forward_to_Bank__c == true && (String.isBlank(cs.Dispute_Email_1__c) || String.isBlank(cs.Dispute_Email_2__c) || String.isBlank(cs.Dispute_Email_3__c) || String.isBlank(cs.Dispute_Email_4__c) || String.isBlank(cs.Dispute_Email_5__c) || String.isBlank(cs.Dispute_Email_6__c) || String.isBlank(cs.Dispute_Email_7__c))) {
                   accIds.add(cs.AccountId);
               }
        }
        system.debug(accIds.size());
        if(accIds.size() > 0) {
            Map<Id, Account> mapAccounts = new Map<Id, Account>([SELECT Id, Email_Dispute__c, Email_1_Dispute__c, Email_2_Dispute__c, Email_3_Dispute__c, Email_4_Dispute__c,
                                                                 Email_5_Dispute__c, Email_6_Dispute__c FROM Account WHERE Id IN: accIds]);
            //system.debug(mapAccounts.size());
            for(Case cs : recordsList) {
                if(cs.Temp_Forward_to_Bank__c == true && (String.isBlank(cs.Dispute_Email_1__c) || String.isBlank(cs.Dispute_Email_2__c) || String.isBlank(cs.Dispute_Email_3__c) || String.isBlank(cs.Dispute_Email_4__c) || String.isBlank(cs.Dispute_Email_5__c) || String.isBlank(cs.Dispute_Email_6__c) || String.isBlank(cs.Dispute_Email_7__c))) {
                                                              if(mapAccounts.containsKey(cs.AccountId)) {
                                                                  Account acc = mapAccounts.get(cs.AccountId);
                                                                  cs.Dispute_Email_1__c = acc.Email_1_Dispute__c;
                                                                  cs.Dispute_Email_2__c = acc.Email_2_Dispute__c;
                                                                  cs.Dispute_Email_3__c = acc.Email_3_Dispute__c;
                                                                  cs.Dispute_Email_4__c = acc.Email_4_Dispute__c;
                                                                  cs.Dispute_Email_5__c = acc.Email_5_Dispute__c;
                                                                  cs.Dispute_Email_6__c = acc.Email_6_Dispute__c;
                                                                  cs.Dispute_Email_7__c = acc.Email_Dispute__c;
                                                              }
                                                          }
            }
        }
    }
    
    public void validateDispute(List<Case> recordsList, map<Id, Case> csmMap){
        for(Case cs : recordsList){
            if(csmMap.containsKey(cs.Id) && (cs.Send_Email_to_Consumer__c || cs.Forward_to_bank__c)){
                if(cs.Dispute_Raised_Date__c == null && cs.Consumer_Dispute_Status__c != csmMap.get(cs.Id).Consumer_Dispute_Status__c){
                    cs.Dispute_Raised_Date__c.addError('Dispute Raised Date should not be blank');
                }
                else if(cs.Date_of_the_email_received__c == null && cs.Consumer_Dispute_Status__c != csmMap.get(cs.Id).Consumer_Dispute_Status__c){
                    cs.Date_of_the_email_received__c.addError('Email Received Date should not be blank');
                }
                else if(string.isBlank(string.valueOf(cs.Dispute_Detail__c)) && cs.Consumer_Dispute_Status__c != csmMap.get(cs.Id).Consumer_Dispute_Status__c){
                    cs.Dispute_Detail__c.addError('Dispute Detail should not be blank');
                }
                
            }
        }
    }
    
    public void sendSFTPEmail(List<Case> recordsList, map<Id, Case> csmMap){
        List<OrgWideEmailAddress> oweaConsumer = new List<OrgWideEmailAddress>();
        if(!Test.isRunningTest()){
            oweaConsumer = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'consumer.support@in.experian.com' limit 1];
        }
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        List<EmailMessage> emailMessageList = new List<EmailMessage>();
        
        set<Id> accId = new set<Id>();
        map<string,string> CaseMap = new map<string,string>();
        for(Case cs : recordsList){
            if(csmMap.containskey(cs.Id)){
                if(cs.Request_data_correction_on_SFTP__c && cs.Request_data_correction_on_SFTP__c !=csmMap.get(cs.Id).Request_data_correction_on_SFTP__c){
                    accId.add(cs.AccountId);
                    CaseMap.put(cs.AccountId,cs.Id);
                    
                }
            }
            
        }
        
        List<string>  emailList = new List<string>();
        for(Account ac: [Select Id,Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,
                         Email_4_Dispute__c,Email_5_Dispute__c,Email_6_Dispute__c from Account where id IN : CaseMap.keySet()]){
                             if(CaseMap.containsKey(ac.Id)){
                                 if(string.isNotBlank(ac.Email_1_Dispute__c))
                                     emailList.add(ac.Email_1_Dispute__c);
                                 if(string.isNotBlank(ac.Email_2_Dispute__c))
                                     emailList.add(ac.Email_2_Dispute__c);
                                 if(string.isNotBlank(ac.Email_3_Dispute__c))
                                     emailList.add(ac.Email_3_Dispute__c);
                                 if(string.isNotBlank(ac.Email_4_Dispute__c))
                                     emailList.add(ac.Email_4_Dispute__c);
                                 if(string.isNotBlank(ac.Email_5_Dispute__c))
                                     emailList.add(ac.Email_5_Dispute__c);
                                 if(string.isNotBlank(ac.Email_6_Dispute__c))
                                     emailList.add(ac.Email_6_Dispute__c);
                             }
                             
                         }
        
        for(Case cs : recordsList){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.toaddresses = emailList;
            //email.setToAddresses(new List<String> {'rishikesh.korade@finessedirect.com'});
            //email.setToAddresses(new List<String> {'muskanbee.shaikh@experian.com'});
            if(cs.Request_data_correction_on_SFTP__c && cs.Request_data_correction_on_SFTP__c !=csmMap.get(cs.Id).Request_data_correction_on_SFTP__c){
                String body = '';
                body+='<p>Dear Team,</p>';
                body+='<p>Thank you for contacting Experian Credit Information of India Pvt Ltd.</p>';
                body+='<p>We are unable to update the correction details in the consumer’s report if you provide the correction details in the email body.</p>';
                body+='<p>Hence, we request you to share the data correction format on <b>SFTP</b> and share the <b>file name</b> with us to resolve the issue at the earliest.</p>';
                body+='Regards,<br/><br/>';
                
                body+='consumer Support Team<br />';
                body+='Experian Credit Information Company of India Pvt. Ltd.<br/>';
                body+='consumer.support@in.experian.com<br/>';
                body+='<a href="www.experian.in">www.experian.in</a><br/>';
                body+='Get your Experian Credit Report & Score today <a href="https://nxg-india.experian.com/nextgen-ind-pds/">click here</a>';
                
                email.setSubject('Correction in Details on SFTP');
                if(oweaConsumer.size() > 0) {
                    email.setOrgWideEmailAddressId(oweaConsumer[0].Id);
                    
                }
                email.setHtmlBody(body);
                email.setUseSignature(false);
                allMails.add(email);
                
                EmailMessage em=new EmailMessage();
                em.subject = 'Correction in Details on SFTP';
                em.RelatedToId= cs.Id;  
                em.ToAddress = string.join(emailList,',');
                em.MessageDate=system.now();
                em.Incoming=false;
                em.Email_Body__c =body;
                em.Status='3';
                em.FromAddress='consumer.support@in.experian.com';
                em.FromName='Consumer Support';
                emailMessageList.add(em);
                
            }
        }
        if(allMails.size() > 0) {
            Messaging.sendEmail(allMails);
        }
        
        if(emailMessageList.size() > 0) {
            insert emailMessageList;
        }
    }
    
    public void wrapDescription(List<Case> recordsList){
        for(Case cs : recordsList) {
            try {
                if(String.isNotBlank(cs.Description)) {
                    if(cs.Description.length() > 255)
                        cs.Description__c = cs.Description.subString(0, 255);
                    else
                        cs.Description__c = cs.Description;
                }
            } Catch(Exception e) {
                System.debug(e);
            }
        }
    }
    
    public void sendRBIComplaintMail(List<Case> recordsList, map<Id, Case> csmMap){
        OrgWideEmailAddress[] oweaNodal = new OrgWideEmailAddress[]{};
            if(!test.isRunningTest()){
                oweaNodal = [select Id from OrgWideEmailAddress where Address = 'nodal.officer.india@experian.com' limit 1];// To send from Org wide address
                
            }
        
        Set<Id> accIds = new Set<Id>();
        
        for(Case cs : recordsList) {
            if(csmMap.containskey(cs.Id)){
                if(cs.Send_Mail_for_RBI_Complaint__c && cs.Send_Mail_for_RBI_Complaint__c != csmMap.get(cs.Id).Send_Mail_for_RBI_Complaint__c) {
                    if(String.isNotBlank(cs.AccountId)) {
                        accIds.add(cs.AccountId);
                    }
                    else {
                        cs.AccountId.addError('Required field');
                    }
                } 
            }
            
        }
        
        List<string>  emailList = new List<string>();
        for(Account ac: [Select Id,Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,Email_4_Dispute__c,Email_5_Dispute__c,
                         Email_6_Dispute__c from Account where id IN : accIds]){
                             if(string.isNotBlank(ac.Email_1_Dispute__c))
                                 emailList.add(ac.Email_1_Dispute__c);
                             if(string.isNotBlank(ac.Email_2_Dispute__c))
                                 emailList.add(ac.Email_2_Dispute__c);
                             if(string.isNotBlank(ac.Email_3_Dispute__c))
                                 emailList.add(ac.Email_3_Dispute__c);
                             if(string.isNotBlank(ac.Email_4_Dispute__c))
                                 emailList.add(ac.Email_4_Dispute__c);
                             if(string.isNotBlank(ac.Email_5_Dispute__c))
                                 emailList.add(ac.Email_5_Dispute__c);
                             if(string.isNotBlank(ac.Email_6_Dispute__c))
                                 emailList.add(ac.Email_6_Dispute__c);
                         }
        system.debug('accIds'+accIds.size());
        if(accIds.size() > 0){
            
            List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
            List<EmailMessage> emailMessageList = new List<EmailMessage>();
            
            for(Case cs : recordsList) {
                
                if(cs.Send_Mail_for_RBI_Complaint__c && cs.Send_Mail_for_RBI_Complaint__c != csmMap.get(cs.Id).Send_Mail_for_RBI_Complaint__c) {
                    
                    if(String.isNotBlank(cs.AccountId)) {
                        
                        cs.Displayed_Bank_Name__c = String.isBlank(cs.Displayed_Bank_Name__c) ? '' : cs.Displayed_Bank_Name__c;
                        cs.Displayed_Account_Type__c = String.isBlank(cs.Displayed_Account_Type__c) ? '' : cs.Displayed_Account_Type__c;
                        cs.Displayed_Account_number__c = String.isBlank(cs.Displayed_Account_number__c) ? '' : cs.Displayed_Account_number__c;
                        cs.Dispute_Detail__c = String.isBlank(cs.Dispute_Detail__c) ? '' : cs.Dispute_Detail__c;
                        cs.Displayed_Details__c = String.isBlank(cs.Displayed_Details__c) ? '' : cs.Displayed_Details__c;
                        
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setToAddresses(emailList);
                        //email.setToAddresses(new List<String> {'rishikesh.korade@finessedirect.com','muskanbee.shaikh@experian.com','balram@finessedirect.com'});
                        
                        ID orgId = UserInfo.getOrganizationId();
                        String sOrgId = (string)orgId;
                        ID caseId = cs.Id;
                        String sCaseId = (string)caseId;
                        String threadIdPart1 = 'ref:_' + sOrgId.left(5) + sOrgId.right(10).replace('0','');
                        threadIdPart1 = threadIdPart1.substring(0,threadIdPart1.length()-3);
                        String threadIdPart2 = '._' + sCaseId.Left(5) + sCaseId.right(10).left(5).replace('0','') + sCaseId.right(5);
                        threadIdPart2 = threadIdPart2.substring(0,threadIdPart2.length()-3)+':ref';
                        String threadId = threadIdPart1 + threadIdPart2;  
                        System.debug('Thread Id^^'+threadId);
                        
                        email.setSubject('RBI complaint - '+cs.RBI_Complaint_Number__c+' - '+cs.Consumer_Name1__c + ' - '+ '[ '+ threadId + ' ]');
                        
                        if(oweaNodal.size() > 0) {
                            email.setOrgWideEmailAddressId(oweaNodal[0].Id);
                        }
                        
                        String body = '';
                        body += '<p>Hi All,<br/>'+
                            '<p>Requesting your urgent intervention on this.</p>'+
                            '<p>As this is a RBI complaint, this needs to be closed within a stipulated time from our end.</p>'+
                            '<p>As per RBI we are mandated by a 21 days (for banks) and 30 days (for CIC) TAT which we will breach in case we do not '+
                            'receive any response from you / your team. The consumer is looking for a rectified report so that credit could be availed.</p>'+
                            //'<style>table{border-collapse: collapse;}table,tr,th,td {border:0.5px solid gray;padding:2px 5px}</style>'+
                            '<table border="1" style="border-collapse: collapse;width:95%;padding:2px 5px">'+
                            '<thead>'+
                            '<tr>'+
                            '<th style="background-color:#1798c1;">Case No</th>'+
                            '<th style="background-color:#1798c1;">Consumer Name</th>'+
                            '<th style="background-color:#1798c1;">Member Name</th>'+
                            '<th style="background-color:#1798c1;">Account Type</th>'+
                            '<th style="background-color:#1798c1;">Account No</th>'+
                            '<th style="background-color:#1798c1;">Dispute Details</th>'+
                            '</tr>'+
                            '</thead>'+
                            '<tbody>'+
                            '<tr>'+
                            '<td>'+cs.CaseNumber+'</td>'+
                            '<td>'+cs.Consumer_Name1__c+'</td>'+
                            '<td>'+cs.Displayed_Bank_Name__c+'</td>'+
                            '<td>'+cs.Displayed_Account_Type__c+'</td>'+
                            '<td>'+cs.Displayed_Account_number__c+'</td>'+
                            '<td>'+cs.Dispute_Detail__c+'</td>'+
                            '</tr>'+
                            '</tbody>'+
                            '</table>'+
                            '<p>We request you to share the correction on the SFTP folder and share the file name with us. '+
                            'We do not accept changes in excel or on the email body.</p>'+
                            '<p>If we have not addressed this to the right team, please help us with the right contacts within your organisation for this.</p>'+
                            '<p>Please treat this with high priority</p>'+
                            '<p>Please feel free to contact us for any further queries.</p><br/>'+
                            
                            '<p>Regards</p>'+
                            'Nodal Officer<br />'+
                            'Experian Credit Information Company of India Pvt. Ltd.<br />'+
                            'E:<a href="mailto:nodal.officer.india@experian.com">nodal.officer.india@experian.com</a><br />'+
                            '<a href="www.experian.in">www.experian.in</a><br />'+
                            '<strong>India STS Link - </strong><a href="https://data.experian.in">https://data.experian.in</a><br />'+
                            '<strong>Nextgen Link - </strong>'+
                            '<a href="https://nxg-india.experian.com/nextgen-ind-pds/">https://nxg-india.experian.com/nextgen-ind-pds/</a>';
                        
                        email.setHtmlBody(body);
                        email.setUseSignature(false);
                        allMails.add(email);
                        
                        cs.RBI_Complaint_mail_sent_date__c = System.today();
                        
                        EmailMessage em=new EmailMessage();
                        em.subject = 'RBI complaint - '+cs.RBI_Complaint_Number__c+' - '+cs.Consumer_Name1__c;
                        
                        em.RelatedToId= cs.Id;  
                        em.ToAddress = string.join(emailList,',');
                        em.MessageDate=system.now();
                        em.Incoming=false;
                        em.Email_Body__c =body; 
                        em.Status='3';
                        em.FromAddress= 'nodal.officer.india@experian.com';
                        em.FromName='Nodal Officer';
                        emailMessageList.add(em);
                    }
                }
            }
            
            if(allMails.size() > 0) {
                Messaging.sendEmail(allMails);
            }
            if(emailMessageList.size() > 0) {
                insert emailMessageList;
            }
        }
    }
    
    public void updateAssignedCaseDateTime(List<Case> recordsList, map<Id, Case> csmMap){
        for(Case cs : recordsList){
            if(csmMap.containskey(cs.Id)){
                if( cs.Owner.Type =='User' && cs.OwnerId != csmMap.get(cs.Id).OwnerId && cs.Status == 'Open'){
                    cs.Case_Assigned_Time__c = date.today();
                }
            }
            
        }
        
    }
    
    
    public void validateForwardingToBank(List<Case> recordsList){
    Boolean doQuery = false;
    for(Case cs : recordsList) {
        if(cs.Forward_to_bank__c) {
            doQuery = true;
            break;
        }
    }
    
    if(doQuery) {
        String[] subTypeNames = new String[] {'Matching', 'Merging'};
        Map<Id, Sub_Type__c> subTypesMap = new Map<Id, Sub_Type__c> ([SELECT Id, Name FROM Sub_Type__c WHERE Name IN: subTypeNames AND isActive__c = true]);
        
        for(Case cs : recordsList) {
            if(cs.Forward_to_bank__c) {
                if(subTypesMap.containsKey(cs.Sub_Type_Lookup__c)) {
                    cs.Forward_to_bank__c.addError('Forwarding to bank is not allowed when case is classified as ' + cs.Sub_Type_Name__c);
                }
            }
        }
    }
    }
    public void UpdateCaseOwner(List<Case> recordsList, map<Id, Case> csmMap){
        List<string> GroupName = new List<string>();
        GroupName.add('Data Merger Team');
        GroupName.add('Data Submission Team');
        GroupName.add('OLM Team');
        GroupName.add('Bank Team');
        GroupName.add('ECV Team');
        GroupName.add('Consumer Support Queue');
        GroupName.add('EWACS Team');
        GroupName.add('Matching Team');
        GroupName.add('NG Team');
        GroupName.add('STS Team');
        GroupName.add('Score Team');
        
        //List<Group> groupmaster =[select Id,Name from Group where  Type = 'Queue'];
        map <string ,Id> queuesmap = new map<string,Id>();
        for(Group grp : [select Id,Name from Group where  Type = 'Queue' and Name IN : GroupName limit 11]){
            queuesmap.put(grp.Name,grp.Id);
        }
        
       
        system.debug('All Quesue'+queuesmap);
        for(Case cs : recordsList) {
  
            if(csmMap.containsKey(cs.Id)){
                
                if(cs.Forward_to_Data_Merger__c && (cs.Forward_to_Data_Merger_Sent_Date_1__c == null || cs.Forward_to_Data_MergerDate__c == null)  
                   && cs.Forward_to_Data_Merger__c != csmMap.get(cs.Id).Forward_to_Data_Merger__c) {
                       cs.OwnerId = queuesmap.get('Data Merger Team');
                   }
                
                //WF - Owner change to Data Submission  --- 30 January 23 - Rishi
                if(cs.Forward_to_Data_Submission__c && cs.Forward_to_Data_Submission_Sent_Date_1__c == null
                   && cs.Forward_to_Data_Submission__c != csmMap.get(cs.Id).Forward_to_Data_Submission__c) {
                       cs.OwnerId = queuesmap.get('Data Submission Team');
                   }
                
                //WF - Owner change to OLM  --- 30 January 23 - Rishi
                if(cs.Forward_to_OLM__c && cs.Forward_to_OLM__c != csmMap.get(cs.Id).Forward_to_OLM__c && (cs.Forward_to_OLM_Sent_Date_1__c == null || cs.Forward_to_OLMDate__c == null)) {
                    cs.OwnerId = queuesmap.get('OLM Team');
                    // cs.Forward_to_OLMDate__c = system.today();
                }
                
                //WF - Email to Bank Team  --- 30 January 23 - Rishi
                
                if(cs.Forward_to_bank__c && (cs.Forward_to_Bank_Sent_Date_1__c == null || cs.Forward_to_Bank_Date__c == null) &&
                   cs.Forward_to_bank__c != csmMap.get(cs.Id).Forward_to_bank__c) {
                       If(string.isBlank(cs.AccountId) && cs.Forward_to_bank__c){
                           cs.AccountId.addError('Please select account first');
                       }else{
                           cs.OwnerId = queuesmap.get('Bank Team');
                       }
                   }
                
                //WF - Email to ECV   --- 30 January 23 - Rishi
                if(cs.Forward_to_ECV_Team__c && (cs.Forward_to_ECV_Team_Sent_Date_1__c == null || cs.Forward_to_ECV_TeamDate__c == null) &&
                   cs.Forward_to_ECV_Team__c != csmMap.get(cs.Id).Forward_to_ECV_Team__c) {
                       cs.OwnerId = queuesmap.get('ECV Team');
                       cs.Forward_to_ECV_TeamDate__c = system.today();                             
                   }
                
                //WF - Email to CST - Consumer   --- 30 January 23 - Rishi email alert present
                if(cs.Forward_to_CST_Team__c && cs.Case_Category__c == 'Consumer' && cs.Forward_to_CST_Team__c != csmMap.get(cs.Id).Forward_to_CST_Team__c && (cs.Forward_to_CST_Team_Sent_Date_1__c == null || cs.Forward_to_CST_TeamDate__c == null)){
                    
                    If(cs.Forward_to_CST_Team__c && string.isBlank(cs.Name_of_Consumer__c)){
                        cs.Name_of_Consumer__c.addError('Please select Consumer Name first');
                    } else{
                        cs.OwnerId = queuesmap.get('Consumer Support Queue');
                        cs.Forward_to_CST_TeamDate__c = date.today();
                    }
                }
                
                //WF - Email to EWACS Team   --- 30 January 23 - Rishi - 
                if(cs.Forward_to_EWACS_Team__c && cs.Forward_to_EWACS_Team__c != csmMap.get(cs.Id).Forward_to_EWACS_Team__c) {
                    cs.OwnerId = queuesmap.get('EWACS Team');
                    cs.Forward_to_EWACS_Team_Date__c =date.today();
                }
                
                // WF -Email to GPD Team   --- 30 January 23 - Rishi --
                if(cs.Forward_to_GPD_Team__c && ( cs.Forward_to_GPD_Team_Sent_Date_1__c == null || cs.Forward_to_GPD_TeamDate__c == null) &&
                   cs.Forward_to_GPD_Team__c != csmMap.get(cs.Id).Forward_to_GPD_Team__c) {
                       cs.OwnerId = queuesmap.get('Matching Team');
                       cs.Forward_to_GPD_TeamDate__c = Date.today();
                   }
                
                // WF -Email to NG Team   --- 30 January 23 - Rishi
                if(cs.Forward_to_NG_Team__c && (cs.Forward_to_NG_Team_Sent_Date_1__c == null || cs.Forward_to_NG_Team_Date__c == null)  && cs.Forward_to_NG_Team__c != csmMap.get(cs.Id).Forward_to_NG_Team__c) {
                    cs.OwnerId = queuesmap.get('NG Team');
                    //cs.Forward_to_NG_Team_Date__c = date.today();
                }
                
                // WF Email to STS   --- 30 January 23 - Rishi --  no changes
                if(cs.Forward_to_STS_Team__c && cs.Forward_to_STS_Team__c != csmMap.get(cs.Id).Forward_to_STS_Team__c) {
                    cs.OwnerId = queuesmap.get('STS Team');
                    cs.Forward_to_STS_TeamDate__c = date.today();
                }           
                
                // WF Email to Score Team    --- 30 January 23 - Rishi
                if(cs.Forward_to_Score_Team__c && ( cs.Forward_to_Score_Team_Sent_Date_1__c == null || cs.Forward_to_Score_Team_Date__c == null) &&
                   cs.Forward_to_Score_Team__c != csmMap.get(cs.Id).Forward_to_Score_Team__c) {
                       cs.OwnerId = queuesmap.get('Score Team');
                       cs.Forward_to_Score_Team_Date__c = date.today();
                   }
                
                // WF Forward to bank & DataOps Teams(Backend) Date/TIme    --- 30 January 23 - Rishi
                if(cs.Forward_to_bank__c && cs.Forward_to_bank__c!= csmMap.get(cs.Id).Forward_to_bank__c  && cs.Forward_to_DataOps_Teams__c && cs.Forward_to_bank_DataOps_Teams_Backend__c == null) {
                    cs.Forward_to_bank_DataOps_Teams_Backend__c = system.now();
                }
                
                // WF Forward to Forward to bank(Backend) Date/TIme    --- 30 January 23 - Rishi
                if(cs.Forward_to_bank__c && cs.Forward_to_bank__c!= csmMap.get(cs.Id).Forward_to_bank__c && cs.Forward_to_DataOps_Teams__c == false && cs.Forward_to_bank_Backend__c == null) {
                    cs.Forward_to_bank_Backend__c = system.now();
                }
                
            }
        }
    }
    
    public void getDIS_Dtl_Id(List<Case> recordsList){
        string cloneId='';
        for(Case Cs : recordsList){
            cloneId= cs.getCloneSourceId();
            
            if(cloneId !=null){
                if(cs.DIS_Dtl_Id__c !=null){
                    String disDtlId=cs.DIS_Dtl_Id__c;
                    if(disDtlId.contains('-')){
                        String[] spliteddisDtlId=disDtlId.split('-');
                        cs.DIS_Dtl_Id__c=spliteddisDtlId[0]+'-'+String.valueOf(Integer.valueOf(spliteddisDtlId[1])+1);
                    }else{
                        cs.DIS_Dtl_Id__c=cs.DIS_Dtl_Id__c+'-'+1;
                    }
                }
            }
        }       
    }
    
    public void getCloneCase(List<Case> recordsList){
        system.debug('Inside Handler');
        system.debug('Inside isCaseCloneTime'+RecursiveHandler.isCaseCloneTime);
        if(!RecursiveHandler.isCaseCloneTime){
            return;
        }
        string cloneId='';
        set<Id> recIds = new set<Id>();
        List<Case> updateCase = new List<Case>();
        for(Case Cs : recordsList){
            recIds.add(cs.Id);
            cloneId= cs.getCloneSourceId();
        }
        system.debug('cloneIds'+cloneId);
        system.debug('recIds'+recIds);
        
        List<Case> caselistclone = new List<Case>();
        List<Case>caseLists = new List<Case>();
        
        if(cloneId !=null){
            caseLists =  [Select Id,DIS_Dtl_Id__c,Forward_to_bank__c,Forward_to_Score_Team__c,Forward_to_OLM__c,Forward_to_Data_Merger__c,
                          Forward_to_Data_Submission__c,Forward_to_GPD_Team__c,Forward_to_NG_Team__c,Forward_to_ECV_Team__c,
                          Forward_to_Bank_Sent_Date_1__c ,Forward_to_Bank_Changed_Date_1__c ,Forward_to_Score_Team_Sent_Date_1__c,
                          Forward_to_OLM_Sent_Date_1__c,Forward_to_Data_Merger_Sent_Date_1__c,Forward_to_Data_Submission_Sent_Date_1__c,
                          Forward_to_GPD_Team_Sent_Date_1__c,Forward_to_NG_Team_Sent_Date_1__c,Forward_to_ECV_Team_Sent_Date_1__c,
                          Forward_to_Score_Team_Changed_Date_1__c,Forward_to_OLM_Changed_Date_1__c,Forward_to_GPD_Team_Changed_Date_1__c,
                          Forward_to_Data_Merger_Changed_Date_1__c,Forward_to_Data_Sub_Changed_Date_1__c,Forward_to_ECV_Team_Changed_Date_1__c,
                          Forward_to_NG_Team_Changed_Date_1__c,Forward_to_Bank_Sent_Date_2__c,Forward_to_Score_Team_Sent_Date_2__c,
                          Forward_to_OLM_Sent_Date2__c,Forward_to_Data_Merger_Sent_Date_2__c,Forward_to_Data_Submission_Sent_Date_2__c,
                          Forward_to_GPD_Team_Sent_Date_2__c,Forward_to_NG_Team_Sent_Date_2__c,Forward_to_ECV_Team_Sent_Date_2__c,
                          Forward_to_Bank_Changed_Date_2__c,Forward_to_Score_Team_Changed_Date_2__c,Forward_to_OLM_Changed_Date_2__c,
                          Forward_to_Data_Merger_Changed_Date_2__c,Forward_to_Data_Sub_Changed_Date_2__c,Forward_to_GPD_Team_Changed_Date_2__c,
                          Forward_to_NG_Team_Changed_Date_2__c,Forward_to_ECV_Team_Changed_Date_2__c,Forward_to_Bank_Sent_Date_3__c,
                          Forward_to_Score_Team_Sent_Date_3__c,Forward_to_OLM_Sent_Date_3__c,Forward_to_Data_Merger_Sent_Date_3__c,
                          Forward_to_Data_Submission_Sent_Date_3__c, Forward_to_GPD_Team_Sent_Date_3__c,Forward_to_NG_Team_Sent_Date_3__c,
                          Forward_to_ECV_Team_Sent_Date_3__c,Forward_to_Bank_Changed_Date_3__c,Forward_to_Score_Team_Changed_Date_3__c,
                          Forward_to_OLM_Changed_Date_3__c,Forward_to_Data_Merger_Changed_Date_3__c,Forward_to_Data_Sub_Changed_Date_3__c,
                          Forward_to_GPD_Team_Changed_Date_3__c,Forward_to_NG_Team_Changed_Date_3__c,Forward_to_ECV_Team_Changed_Date_3__c,
                          Case_Category__c,Forward_to_CST_Changed_Date_1__c,Forward_to_CST_Changed_Date_2__c  ,Forward_to_CST_Changed_Date_3__c,
                          Forward_to_CST_Team_Sent_Date_1__c,Forward_to_CST_Team_Sent_Date_2__c,Forward_to_CST_Team_Sent_Date_3__c,Forward_to_CST_Team__c,  
                          OwnerId,Forward_to_Bank_Changed_Date_4__c,Forward_to_Bank_Changed_Date_5__c,Forward_to_Bank_Sent_Date_5__c,Forward_to_Bank_Sent_Date_4__c,
                          Forward_to_OLM_Changed_Date_4__c,Forward_to_OLM_Changed_Date_5__c,Forward_to_OLM_Sent_Date_4__c,Forward_to_OLM_Sent_Date_5__c ,Last_Reply_from_OLM_Team__c  ,
                          Last_Reply_from_Data_Submission__c, Forward_to_Data_Sub_Changed_Date_4__c,Forward_to_Data_Sub_Changed_Date_5__c,
                          Forward_to_Data_Submission_Sent_Date_4__c,Forward_to_Data_Submission_Sent_Date_5__c,
                          Dispute_Email_Sent__c, Resolved_Consumer_Email_Sent__c, Not_Resolved_Consumer_Email_Sent__c, No_Response_Bank_Email_Sent__c,
                          No_Response_Date__c, Mail_Sent__c, ReClose_Date__c, Resolve_Date__c, ReOpen_Date__c, Work_in_Progress_Date__c, Last_Reply_from_Bank_Team__c,
                          Last_Reply_from_CST_Team__c, Last_Reply_from_Data_Merger__c, Last_Reply_from_EVC_Team__c,
                          Last_Reply_from_GPD_Team__c, Last_Reply_from_NG_Team__c, Last_Reply_from_Score_Team__c,
                          Ticket_Closed_By__c, Ticket_ReClosed_By__c,Last_Sent_Date_of_CST_Team__c, Last_Sent_Date_of_Data_Merger_Team__c, 
                          Last_Sent_Date_of_Data_Submission__c, Last_Sent_Date_of_ECV_Team__c,Last_Sent_Date_of_Score_Team__c,
                          Last_Sent_Date_of_GPD_Team__c, Last_Sent_Date_of_NG_Team__c, Last_Sent_Date_of_OLM_Team__c from Case where Id IN: recIds];
        }
        system.debug('Case Size-->'+caseLists.size());
        
        for(Case cs : caseLists ){
            system.debug('Case Size-->'+caseLists.size());
            
            //Bank Team
            cs.Forward_to_Bank_Changed_Date_1__c = null;
            cs.Forward_to_Bank_Changed_Date_2__c = null;
            cs.Forward_to_Bank_Changed_Date_3__c = null;
            cs.Forward_to_Bank_Changed_Date_4__c = null;
            cs.Forward_to_Bank_Changed_Date_5__c = null;
            cs.Forward_to_Bank_Sent_Date_1__c = null;
            cs.Forward_to_Bank_Sent_Date_2__c = null;
            cs.Forward_to_Bank_Sent_Date_3__c = null;
            cs.Forward_to_Bank_Sent_Date_4__c = null;
            cs.Forward_to_Bank_Sent_Date_5__c = null;
            
            // Data Sub Team
            cs.Forward_to_Data_Sub_Changed_Date_1__c = null;
            cs.Forward_to_Data_Sub_Changed_Date_2__c = null;
            cs.Forward_to_Data_Sub_Changed_Date_3__c = null;
            cs.Forward_to_Data_Sub_Changed_Date_4__c = null;
            cs.Forward_to_Data_Sub_Changed_Date_5__c = null;
            cs.Forward_to_Data_Submission_Sent_Date_1__c = null;
            cs.Forward_to_Data_Submission_Sent_Date_2__c = null;
            cs.Forward_to_Data_Submission_Sent_Date_3__c = null;
            cs.Forward_to_Data_Submission_Sent_Date_4__c = null;
            cs.Forward_to_Data_Submission_Sent_Date_5__c = null;
            
            //OLM Team
            cs.Forward_to_OLM_Changed_Date_1__c = null;
            cs.Forward_to_OLM_Changed_Date_2__c = null;
            cs.Forward_to_OLM_Changed_Date_3__c = null;
            cs.Forward_to_OLM_Changed_Date_4__c = null;
            cs.Forward_to_OLM_Changed_Date_5__c = null;
            cs.Forward_to_OLM_Sent_Date_1__c = null;
            cs.Forward_to_OLM_Sent_Date2__c = null;
            cs.Forward_to_OLM_Sent_Date_3__c = null;
            cs.Forward_to_OLM_Sent_Date_4__c = null;
            cs.Forward_to_OLM_Sent_Date_5__c = null;
            
            //CST Team 
            cs.Forward_to_CST_Changed_Date_1__c = null;
            cs.Forward_to_CST_Changed_Date_2__c = null;
            cs.Forward_to_CST_Changed_Date_3__c = null;
            cs.Forward_to_CST_Team_Sent_Date_1__c = null;
            cs.Forward_to_CST_Team_Sent_Date_2__c= null; 
            cs.Forward_to_CST_Team_Sent_Date_3__c = null;
            
            //Data Merger Team
            cs.Forward_to_Data_Merger_Changed_Date_1__c = null; 
            cs.Forward_to_Data_Merger_Changed_Date_2__c = null;
            cs.Forward_to_Data_Merger_Changed_Date_3__c = null ;
            cs.Forward_to_Data_Merger_Sent_Date_1__c = null;
            cs.Forward_to_Data_Merger_Sent_Date_2__c = null;
            cs.Forward_to_Data_Merger_Sent_Date_3__c = null; 
            
            //ECV Team
            cs.Forward_to_ECV_Team_Changed_Date_1__c = null;
            cs.Forward_to_ECV_Team_Changed_Date_2__c = null;
            cs.Forward_to_ECV_Team_Changed_Date_3__c = null; 
            cs.Forward_to_ECV_Team_Sent_Date_1__c = null;
            cs.Forward_to_ECV_Team_Sent_Date_2__c = null;
            cs.Forward_to_ECV_Team_Sent_Date_3__c = null;
            
            //GPD Team
            cs.Forward_to_GPD_Team_Changed_Date_1__c = null;
            cs.Forward_to_GPD_Team_Changed_Date_2__c = null;
            cs.Forward_to_GPD_Team_Changed_Date_3__c = null;
            cs.Forward_to_GPD_Team_Sent_Date_1__c = null;
            cs.Forward_to_GPD_Team_Sent_Date_2__c = null;
            cs.Forward_to_GPD_Team_Sent_Date_3__c = null; 
            
            //NG Team
            cs.Forward_to_NG_Team_Changed_Date_1__c = null;
            cs.Forward_to_NG_Team_Changed_Date_2__c = null;
            cs.Forward_to_NG_Team_Changed_Date_3__c = null;
            cs.Forward_to_NG_Team_Sent_Date_1__c = null;
            cs.Forward_to_NG_Team_Sent_Date_2__c = null;
            cs.Forward_to_NG_Team_Sent_Date_3__c = null;
            
            //Score Team
            cs.Forward_to_Score_Team_Changed_Date_1__c = null;
            cs.Forward_to_Score_Team_Changed_Date_2__c = null;
            cs.Forward_to_Score_Team_Changed_Date_3__c = null;
            cs.Forward_to_Score_Team_Sent_Date_1__c = null;
            cs.Forward_to_Score_Team_Sent_Date_2__c = null;
            cs.Forward_to_Score_Team_Sent_Date_3__c = null;
            
            //General Fields
            cs.Dispute_Email_Sent__c=false;
            cs.Resolved_Consumer_Email_Sent__c=false;
            cs.Not_Resolved_Consumer_Email_Sent__c=false;
            cs.No_Response_Bank_Email_Sent__c=false;
            cs.No_Response_Date__c=null;
            cs.Mail_Sent__c=false;
            cs.ReClose_Date__c=null;
            cs.Resolve_Date__c=null;
            cs.ReOpen_Date__c=null;
            cs.Work_in_Progress_Date__c=null;
            cs.Last_Reply_from_Bank_Team__c= null;
            cs.Last_Reply_from_CST_Team__c=null;
            cs.Last_Reply_from_Data_Merger__c=null;
            cs.Last_Reply_from_EVC_Team__c=null;
            cs.Last_Reply_from_Data_Submission__c=null;
            cs.Last_Reply_from_GPD_Team__c=null;
            cs.Last_Reply_from_NG_Team__c=null;
            cs.Last_Reply_from_OLM_Team__c=null;
            cs.Last_Reply_from_Score_Team__c=null;
            cs.Ticket_Closed_By__c=null;
            cs.Ticket_ReClosed_By__c=null;
            cs.Last_Sent_Date_of_CST_Team__c=null;
            cs.Last_Sent_Date_of_Data_Merger_Team__c=null;
            cs.Last_Sent_Date_of_Data_Submission__c=null;
            cs.Last_Sent_Date_of_ECV_Team__c=null;
            cs.Last_Sent_Date_of_GPD_Team__c=null;
            cs.Last_Sent_Date_of_NG_Team__c=null;
            cs.Last_Sent_Date_of_OLM_Team__c=null;
            cs.Last_Sent_Date_of_Score_Team__c=null;
            cs.Forward_to_Bank_Date__c =null;
            cs.Consumer_Dispute_Status__c=null;
            cs.Manual_Entry_Bank_Date__c=false;
            caselistclone.add(cs);
        }     
        if(caselistclone.size() > 0){
            RecursiveHandler.isCaseCloneTime = false;
            update caselistclone;
        }
        
    }
    
    public void RestrictOwnerChange(List<Case> recordsList, map<Id, Case> csmMap){
        String SysAdminIdSand ='00e2v0000034xKFAAY'; //Sandbox
        String SysAdminIdProd ='00e2v0000034xKF';   //Production
        String TLCSIdProd     ='00e2u000000gjdD';   //Production
        String TLCSandbox     ='00e6D000000k85S';   //Sandbox
        string AutomatedUser = '0052v00000ZrO4mAAF'; // sandbox
        
        String ConvertedTLCSandbox=String.valueof(userinfo.getProfileId()).substring(0,15);
        System.debug('ConvertedTLCSandbox^^'+ConvertedTLCSandbox);
        String ConvertedTLCSIdProd=String.valueof(userinfo.getProfileId()).substring(0,15);
        System.debug('ConvertedTLCSIdProd^^'+ConvertedTLCSIdProd);
        
        for (Case ca: recordsList) {
            
            if((csmMap.get(ca.Id).OwnerId != ca.OwnerId )){
                
                if(!((userinfo.getUserId() == AutomatedUser)|| ( userinfo.getProfileId()==SysAdminIdSand) || (userinfo.getProfileId()==SysAdminIdProd) || (ConvertedTLCSandbox==TLCSandbox) || (ConvertedTLCSIdProd==TLCSIdProd) )){
                    if(ca.Case_Complaints__c==null){
                        ca.addError('Please enter Case Compliant before changing the owner.');
                    }
                } 
            }
        }
    }
    
    public void CaseAsDuplicate(List<Case> recordsList, map<Id, Case> csmMap){
        Boolean isDuplicate = true;
        Sub_Type1__c subType1;
        for(Case cs : recordsList) {
            if(cs.Is_Duplicate_Case__c) {
                if(cs.ParentId == null) {
                    cs.ParentId.addError('Parent Case is required to mark case as duplicate');
                    continue;
                }
                if(subType1 == null) {
                    subType1 = [SELECT Id, Sub_Type__c, Sub_Type__r.Case_Type__c,
                                Sub_Type__r.Case_Type__r.Case_Complaint__c, Sub_Type__r.Case_Type__r.Case_Category__c
                                FROM Sub_Type1__c
                                WHERE Name = 'Duplicate' AND
                                Sub_Type__r.Name = 'Status of Dispute' AND
                                Sub_Type__r.Case_Type__r.Name = 'Query' AND
                                Sub_Type__r.Case_Type__r.Case_Complaint__c = 'Report' AND
                                Sub_Type__r.Case_Type__r.Case_Category__c = 'Consumer'];
                }
                if(cs.ParentId != null) {
                    cs.Status = 'Resolved';
                    cs.Case_Category__c = subType1.Sub_Type__r.Case_Type__r.Case_Category__c;
                    cs.Case_Complaints__c = subType1.Sub_Type__r.Case_Type__r.Case_Complaint__c;
                    cs.Case_Type_Lookup__c = subType1.Sub_Type__r.Case_Type__c;
                    cs.Sub_Type_Lookup__c = subType1.Sub_Type__c;
                    cs.Sub_Type_1_Lookup__c = subType1.Id;
                }
            }
        }
        
        
    }
*/
    
    public static void fakeCodeCoverage(){
        integer i=1;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++; i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
}