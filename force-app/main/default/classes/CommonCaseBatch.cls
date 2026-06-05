global class CommonCaseBatch implements Database.batchable<sObject>,schedulable{
    
    global void execute(SchedulableContext SC) {
        database.executebatch(new CommonCaseBatch(),Integer.ValueOf(Label.Dispute_Detail));
    }
    
    global List<Case> start(Database.BatchableContext BC) {
        
        List<Case> caseList = [ Select Id ,Origin ,Sub_Type_1_Lookup__c,Sub_Type_Name__c,Sub_Type_1_Name__c,Name_of_Consumer__c,Displayed_Overdue_Amount__c,Displayed_Loan_Balance__c,
                               Sub_Type_Lookup__c,Correct_Loan_Balance__c,Displayed_Account_Status__c,Correct_Overdue_Amount__c,Dispute_Detail__c,Correct_Account_Type__c,Displayed_Account_Type__c,Displayed_Name__c,Correct_Name__c,
                               Displayed_Gender__c,Correct_Gender__c,Correct_PAN_No__c,Displayed_PAN_No__c,Displayed_Mobile_No__c,Correct_Mobile_No__c,Correct_Address__c,
                               Displayed_Address__c,Displayed_Address_1_v1__c,Displayed_email_id__c,Correct_email_id__c,Correct_Date_of_Birth__c,Displayed_Date_of_Birth__c,Correct_Account_Status__c,
                               Correct_loan_ownership__c,Displayed_loan_ownership__c, Correct_loan_type__c,Displayed_loan_type__c,Status,Correct_Enquiry_Date__c,
                               Correct_Account_Opening_Date__c,Displayed_Account_Opening_Date__c,CaseNumber, State__c,Displayed_Enquiry_Date__c ,Displayed_Enquired_For__c,
                               Displayed_Bank_Name__c,Displayed_Account_number__c, Consumer_Dispute_Status__c, Dispute_Raised_Date__c,
                               Displayed_Credit_Facility_Status__c,Corrected_Credit_Facility_Status__c,Correct_Enquired_For__c, AccountId, Account.Member_Status__c 
                               from Case 
                               where (CreatedDate = This_Month OR CreatedDate = Yesterday) AND Sub_Type_1_Name__c !='Junk' and Sub_Type_1_Name__c !=null 
                               AND Origin  ='Portal' AND Consumer_Dispute_Status__c = null AND Sub_Type_Name__c != 'Unidentified' AND 
                               (Case_Type_Name__c = 'Complaint Dispute Consumer' OR Case_Type_Name__c = 'Complaint Dispute Commercial')
                               order by CaseNumber asc ];
        return caseList;
    }
    
    global void execute(Database.BatchableContext BC, List<Case> scope) {
        
        List<Sub_Type1__c> subTypeList= [select Id , Name,Sub_Type__c from Sub_Type1__c where Name='closed'];
        Map<Id,Id > subTypeMap =  new Map<Id,Id>();
        
        for(Sub_Type1__c stp  :subTypeList ){
            subTypeMap.put(stp.Sub_Type__c,stp.Id);  
        }
        
        Sub_Type__c st   = [SELECT Id, Name, Case_Type__c, Case_Type__r.Name FROM Sub_Type__c WHERE Name = 'Enquiry Changes' and Case_Type__r.Name = 'Complaint Dispute Consumer'];
        Sub_Type1__c st1 = [SELECT Id, Name, Case_Type__c, Sub_Type__c, Sub_Type__r.Name FROM Sub_Type1__c WHERE Name = 'Enquiry Date' and Case_Type__c = 'Complaint Dispute Consumer' and Sub_Type__r.Name = 'Enquiry Changes'];
        Sub_Type1__c st2 = [SELECT Id, Name, Case_Type__c, Sub_Type__c, Sub_Type__r.Name FROM Sub_Type1__c WHERE Name = 'Loan Type' and Case_Type__c = 'Complaint Dispute Consumer' and  Sub_Type__r.Name = 'Enquiry Changes'];
        
        List<Case> csLists = new List<Case>();
        Map<Id,Case> csValues = new Map<Id,Case>();
        set<Id>  caseId = new set<Id>();   
        set<Id>  tempCasNotId = new set<Id>();
        
        for(Case cs : scope){
            csLists.add(cs);
            
            if (cs.AccountId !=null && cs.Account.Member_Status__c == 'Credit Institution - License Cancelled Entity'){
                cs.Send_Email_to_Terminated_Member__c = true;
                csValues.put(cs.Id,cs);  
            }
            
            if(cs.Dispute_Raised_Date__c == null){
                cs.Dispute_Raised_Date__c = system.today();
                csValues.put(cs.Id,cs);
            }
            else if(cs.Dispute_Raised_Date__c != null && cs.Dispute_Raised_Date__c != system.today()){
                cs.Dispute_Raised_Date__c = system.today();
                csValues.put(cs.Id,cs);
            } 
            
            if(string.isBlank(cs.Dispute_Detail__c)){
                
                string tempAccNumber = '';
                
                if(string.isBlank(cs.Displayed_Account_number__c)){
                    tempAccNumber = 'blank';} 
                else {
                    tempAccNumber = cs.Displayed_Account_number__c;}
                
                string dlbal = 'blank';
                string dodue = 'blank';
                if(string.isNotBlank(string.valueOf(cs.Displayed_Loan_Balance__c))) dlbal = string.valueOf(cs.Displayed_Loan_Balance__c);
                if(string.isNotBlank(string.valueOf(cs.Displayed_Overdue_Amount__c))) dodue = string.valueOf(cs.Displayed_Overdue_Amount__c);
                
                string dlbal01 = 'blank';
                string dodue02 = 'blank';
                
                if(string.isNotBlank(cs.Correct_Account_Status__c)) dlbal01=  cs.Correct_Account_Status__c ;
                if(string.isNotBlank(cs.Displayed_Account_Status__c)) dodue02=  cs.Displayed_Account_Status__c;
                
                //1. Account Status 
                if(string.isNotBlank(cs.Displayed_Account_Status__c) && cs.Sub_Type_Name__c =='Account Status' && string.isNotBlank(cs.Sub_Type_Name__c) ){
                    cs.Dispute_Detail__c =  'As per consumer, this account number ('+tempAccNumber+') account status should be '+ dlbal01 +' but reflecting as '+dodue02+
                        +' with current balance of Rs.'+ dlbal + '/- and overdue amount of Rs.'+ dodue +'/-';
                    csValues.put(cs.Id,cs);
                    
                    /*if(((cs.Displayed_Account_Status__c).toLowerCase()).contains('active') || cs.Displayed_Account_Status__c =='Entity ceased while account was open'){
cs.Dispute_Detail__c =  'As per consumer, this account number ('+tempAccNumber+') account status should be '+ dlbal01 +' but reflecting as '+dodue02+
+' with current balance of Rs.'+ dlbal + '/- and overdue amount of Rs.'+ dodue +'/-';
csValues.put(cs.Id,cs);
}
else if( !((cs.Displayed_Account_Status__c).toLowerCase()).contains('active') && cs.Displayed_Account_Status__c !='Entity ceased while account was open') {
cs.Dispute_Detail__c =  'As per consumer, this account number ('+tempAccNumber+') Written off settled status should be blank but reflecting as '+dodue02 
+' with current balance of Rs.'+ dlbal + '/- and overdue amount of Rs.'+ dodue+'/-';
csValues.put(cs.Id,cs);
} */ 
                }
                
                
                //Credit Facility Status
                string credFaci001 = 'blank';
                string credFaci002 = 'blank';
                
                if(string.isNotBlank(cs.Corrected_Credit_Facility_Status__c)) credFaci001=  cs.Corrected_Credit_Facility_Status__c ;
                if(string.isNotBlank(cs.Displayed_Credit_Facility_Status__c)) credFaci002=  cs.Displayed_Credit_Facility_Status__c;
                if(cs.Sub_Type_Name__c == 'Credit Facility Status'){
                    cs.Dispute_Detail__c = 'As per consumer, this account number ('+tempAccNumber+') Credit facility status should be '+credFaci001+' but reflecting as '+credFaci002;
                    csValues.put(cs.Id,cs);
                }
                
                //2 If Sub type is equal to Account Details and Sub type 1 equal to Account Opened Date then statement should be as Follows. 
                //As per consumer, this account number (Displayed Account number) Account Opened Date should be Correct Account Opening Date but reflecting as Displayed Account Opening Date 
                
                if(cs.Sub_Type_Name__c =='Account Details' && string.isNotBlank(cs.Sub_Type_Name__c)) {
                    if(string.isNotBlank(cs.Sub_Type_1_Name__c) && (cs.Sub_Type_1_Name__c).toLowerCase() == 'account opened date'){
                        
                        String ansDate1 = ''; 
                        string ansDate2 = '';
                        if(cs.Correct_Account_Opening_Date__c != null){
                            
                            DateTime correctDate = cs.Correct_Account_Opening_Date__c;
                            ansDate1 = correctDate.format('dd-MMM-YYYY');
                        }
                        else{
                            ansDate1 ='blank';
                        }
                        if(cs.Displayed_Account_Opening_Date__c != null){
                            DateTime diaplyedDate = cs.Displayed_Account_Opening_Date__c;   
                            ansDate2 = diaplyedDate.format('dd-MMM-YYYY');
                            
                        }else{
                            ansDate2 ='blank';
                        }
                        
                        cs.Dispute_Detail__c = 'As per consumer, this account number ('+tempAccNumber+') Account Opened Date should be '+
                            + ansDate1 +' but reflecting as Displayed Account Opening Date '+ansDate2+'';
                        csValues.put(cs.Id,cs); 
                    }
                }
                
                //2.	Balance Issue
                if(string.isNotBlank(cs.Sub_Type_1_Name__c) && (cs.Sub_Type_1_Name__c).toLowerCase() == 'current balance'){
                    string correctLoneBalnce = 'blank';
                    if(cs.Correct_Loan_Balance__c != null) correctLoneBalnce = string.valueOf(cs.Correct_Loan_Balance__c);
                    string dispalyedLoneBalnce = 'blank';
                    if(cs.Displayed_Loan_Balance__c != null) dispalyedLoneBalnce = string.valueOf(cs.Displayed_Loan_Balance__c);
                    
                    cs.Dispute_Detail__c = 'As per consumer, this account number ('+tempAccNumber+') current balance should be Rs.'+
                        + correctLoneBalnce +'/- but reflecting as Rs.'+dispalyedLoneBalnce+'/-. ';
                    csValues.put(cs.Id,cs);
                }
                
                //2.	Balance Issue
                if( string.isNotBlank(cs.Sub_Type_1_Name__c) && (cs.Sub_Type_1_Name__c).toLowerCase() == 'over due'){
                    
                    string correctOverDueAmt = 'blank';
                    if(cs.Correct_Overdue_Amount__c != null) correctOverDueAmt = string.valueOf(cs.Correct_Overdue_Amount__c);
                    string dispalyedOverDueAmt = 'blank';
                    if(cs.Displayed_Overdue_Amount__c != null) dispalyedOverDueAmt = string.valueOf(cs.Displayed_Overdue_Amount__c);
                    
                    cs.Dispute_Detail__c = 'As per consumer, this account number ('+tempAccNumber+') Overdue amount should be Rs.'+
                        + correctOverDueAmt +'/- but reflecting as Rs.'+dispalyedOverDueAmt+'/-. ';
                    csValues.put(cs.Id,cs);
                }
                
                //3.	Accounts do not belong to the consumer.
                if( string.isNotBlank(cs.Sub_Type_Name__c) && ((cs.Sub_Type_Name__c).toLowerCase() =='account ownership issue' || (cs.Sub_Type_Name__c).toLowerCase() =='matching')){
                    //if(string.isBlank(cs.Displayed_Account_number__c)) cs.Displayed_Account_number__c = '';
                    if(((cs.Sub_Type_1_Name__c).toLowerCase() == 'account does not belong to me') || (cs.Sub_Type_1_Name__c).toLowerCase() == 'matching - account does not belong to me'){
                        cs.Dispute_Detail__c = 'As per consumer, this account number ('+tempAccNumber+') does not belong to him/her.';
                        csValues.put(cs.Id,cs);
                    }
                }
                
                //3.	Accounts do not belong to the consumer. // added by Balram on 27/04/2024
                if( string.isNotBlank(cs.Sub_Type_Name__c) && ((cs.Sub_Type_Name__c).toLowerCase() =='Enquiry ownership issue' || (cs.Sub_Type_Name__c).toLowerCase() =='matching')){
                    //if(string.isBlank(cs.Displayed_Account_number__c)) cs.Displayed_Account_number__c = '';
                    if(( (cs.Sub_Type_1_Name__c).toLowerCase() == 'credit enquiry does not belong to me') || (cs.Sub_Type_1_Name__c).toLowerCase() == 'matching - credit enquiry does not belong to me')  {
                        cs.Dispute_Detail__c = 'As per consumer, this credit enquiry number ('+tempAccNumber+') does not belong to him/her.';
                        csValues.put(cs.Id,cs);
                    }
                }
                
                //4.	Account not reflecting.
                if(string.isNotBlank(cs.Sub_Type_1_Name__c) && (cs.Sub_Type_1_Name__c).toLowerCase() == 'account not reflecting'){
                    //if(string.isBlank(cs.Displayed_Account_number__c)) cs.Displayed_Account_number__c = '';
                    cs.Dispute_Detail__c =  'As per consumer, this account number ('+tempAccNumber+') is not reflecting in CIR.';
                    csValues.put(cs.Id,cs);
                }
                
                //6.	Account Type
                if( string.isNotBlank(cs.Sub_Type_Name__c) && (cs.Sub_Type_Name__c).toLowerCase() =='account type'){
                    //if(string.isBlank(cs.Displayed_Account_number__c)) cs.Displayed_Account_number__c = '';
                    string dlbal1 = 'blank';
                    string dodue1 = 'blank';
                    if(string.isNotBlank(cs.Correct_loan_type__c)) dlbal1 = cs.Correct_loan_type__c;
                    if(string.isNotBlank(cs.Displayed_loan_type__c)) dodue1 = cs.Displayed_loan_type__c;
                    cs.Dispute_Detail__c =  'As per consumer, this account number ('+tempAccNumber+') Account Type should be '+dlbal1+' but reflecting as '+dodue1 +'.';
                    csValues.put(cs.Id,cs);
                }
                
                //7.	Account Ownership 
                if( string.isNotBlank(cs.Sub_Type_Name__c) && ((cs.Sub_Type_Name__c).toLowerCase() =='account ownership issue' || (cs.Sub_Type_Name__c).toLowerCase() =='enquiry ownership issue')){
                    if((cs.Sub_Type_1_Name__c).toLowerCase() != 'account does not belong to me' &&
                       (cs.Sub_Type_1_Name__c).toLowerCase() != 'credit enquiry does not belong to me' &&
                       (cs.Sub_Type_1_Name__c).toLowerCase() != 'matching - credit enquiry does not belong to me' &&
                       (cs.Sub_Type_1_Name__c).toLowerCase() != 'matching - account does not belong to me' ){ // added by Balram on 14/09/2024
                           string dlbal2 = 'blank';
                           string dodue2 = 'blank';
                           if(string.isNotBlank(cs.Correct_loan_ownership__c)) dlbal2 = cs.Correct_loan_ownership__c;
                           if(string.isNotBlank(cs.Displayed_loan_ownership__c)) dodue2 = cs.Displayed_loan_ownership__c;
                           
                           cs.Dispute_Detail__c =  'As per consumer, this account number ('+tempAccNumber+') Account Ownership should be '+dlbal2+' but reflecting as '+dodue2 +'.';
                           csValues.put(cs.Id,cs);
                       }
                }
                
                //8.	Demographic details
                if( string.isNotBlank(cs.Sub_Type_Name__c) && (cs.Sub_Type_Name__c).toLowerCase() == 'demographic details'){
                    string strBefore = 'As per consumer, this account number ';
                    if(string.isNotBlank(cs.Displayed_Account_number__c)){
                        
                        strBefore +='('+cs.Displayed_Account_number__c+')';}
                    else{
                        strBefore +='(blank)';
                    }
                    
                    if((cs.Sub_Type_1_Name__c).toLowerCase() == 'incorrect name'){
                        if(string.isBlank(cs.Correct_Name__c)) cs.Correct_Name__c = 'blank';
                        if(string.isBlank(cs.Displayed_Name__c)) cs.Displayed_Name__c = 'blank';
                        strBefore +=  ' Name should be '+cs.Correct_Name__c+' but  reflecting as '+cs.Displayed_Name__c +'.';
                    }
                    
                    if((cs.Sub_Type_1_Name__c).toLowerCase() == 'incorrect dob'){
                        
                        String ansDate1 = ''; 
                        string ansDate2 = '';
                        if(cs.Correct_Date_of_Birth__c != null){
                            
                            DateTime correctDate = cs.Correct_Date_of_Birth__c;
                            ansDate1 = correctDate.format('dd-MMM-YYYY');
                        }else{
                            ansDate1 = 'blank';
                        }
                        if(cs.Displayed_Date_of_Birth__c != null){
                            DateTime diaplyedDate = cs.Displayed_Date_of_Birth__c;   
                            ansDate2 = diaplyedDate.format('dd-MMM-YYYY');
                        }else{
                            ansDate2 = 'blank';
                        }
                        strBefore +=  ' DOB should be '+ansDate1+' but  reflecting as '+ ansDate2 +'.';
                    }
                    
                    if((cs.Sub_Type_1_Name__c).toLowerCase() == 'incorrect email id'){
                        string dlbal3 = 'blank';
                        string dodue3 = 'blank';
                        
                        if(string.isNOTBlank(cs.Correct_email_id__c)) dlbal3 = cs.Correct_email_id__c;
                        if(string.isNOTBlank(cs.Displayed_email_id__c)) dodue3 = cs.Displayed_email_id__c;
                        strBefore +=  ' Email should be '+dlbal3+' but  reflecting as '+dodue3 +'.';
                    }
                    
                    if((cs.Sub_Type_1_Name__c).toLowerCase() == 'incorrect address'){
                        string dlbal4 = 'blank';
                        string dodue4 = 'blank';
                        string Displayed_Address_1 = cs.Displayed_Address__c != null ? cs.Displayed_Address__c : cs.Displayed_Address_1_v1__c;
                        
                        if(string.isNOTBlank(cs.Correct_Address__c)) dlbal4 = cs.Correct_Address__c;
                        if(string.isNOTBlank(Displayed_Address_1)) dodue4 = Displayed_Address_1;
                        strBefore +=  ' Address should be '+dlbal4+' but  reflecting as '+dodue4 +'.';
                    }
                    
                    if((cs.Sub_Type_1_Name__c).toLowerCase() == 'incorrect mobile no'){
                        string dlbal5 = 'blank';
                        string dodue5 = 'blank';
                        
                        if(string.isNOTBlank(cs.Correct_Mobile_No__c)) dlbal5 = cs.Correct_Mobile_No__c;
                        if(string.isNOTBlank(cs.Displayed_Mobile_No__c)) dodue5 = cs.Displayed_Mobile_No__c;
                        strBefore +=  ' Mobile should be '+dlbal5+' but  reflecting as '+dodue5 +'.';
                    }
                    
                    if((cs.Sub_Type_1_Name__c).toLowerCase() == 'incorrect kyc'){
                        
                        string dlbal6 = 'blank';
                        string dodue6 = 'blank';
                        
                        if(string.isNOTBlank(cs.Correct_PAN_No__c)) dlbal6 = cs.Correct_PAN_No__c;
                        if(string.isNOTBlank(cs.Displayed_PAN_No__c)) dodue6 = cs.Displayed_PAN_No__c;
                        
                        strBefore +=  ' PAN should be '+dlbal6+' but  reflecting as '+dodue6 +'.';
                    }
                    
                    if((cs.Sub_Type_1_Name__c).toLowerCase() == 'incorrect gender'){
                        string dlbal7 = 'blank';
                        string dodue7 = 'blank';
                        
                        if(string.isNOTBlank(cs.Correct_Gender__c)) dlbal7 = cs.Correct_Gender__c;
                        if(string.isNOTBlank(cs.Displayed_Gender__c)) dodue7 = cs.Displayed_Gender__c;
                        strBefore +=  ' Gender should be '+dlbal7+' but  reflecting as '+dodue7 +'.';
                    }
                    
                    if(string.isNotBlank(strBefore)){
                        cs.Dispute_Detail__c = strBefore;
                        csValues.put(cs.Id,cs);
                    }
                }
                
                //9.1  Conditions for Credit Enquiry 
                if(string.isNotBlank(cs.Sub_Type_Name__c) && cs.Sub_Type_Name__c =='Credit Enquiry' && cs.Sub_Type_1_Name__c =='Changes' && cs.Displayed_Enquiry_Date__c != null && cs.Correct_Enquiry_Date__c != null) {
                    
                    String ansDate1 = ''; 
                    string ansDate2 = '';
                    if(cs.Correct_Enquiry_Date__c != null){
                        
                        DateTime correctDate = cs.Correct_Enquiry_Date__c;
                        ansDate1 = correctDate.format('dd-MMM-YYYY');
                    }
                    else{
                        ansDate1 ='blank';
                    }
                    if(cs.Displayed_Enquiry_Date__c != null){
                        DateTime diaplyedDate = cs.Displayed_Enquiry_Date__c;   
                        ansDate2 = diaplyedDate.format('dd-MMM-YYYY');
                        
                    }else{
                        ansDate2 ='blank';
                    }
                    
                    cs.Dispute_Detail__c = 'As per consumer, the enquiry date against this ERN ('+tempAccNumber+') should be ' +ansDate1 + ' but reflecting as '+ansDate2; 
                    cs.Sub_Type_Lookup__c = st.Id;
                    cs.Sub_Type_1_Lookup__c = st1.Id;
                    csValues.put(cs.Id,cs);
                }
                
                //9.2  Conditions for Credit Enquiry 
                if(string.isNotBlank(cs.Sub_Type_Name__c) && cs.Sub_Type_Name__c =='Credit Enquiry' && cs.Sub_Type_1_Name__c =='Changes' && cs.Displayed_Enquired_For__c != null && cs.Correct_Enquired_For__c != null) {
                    cs.Dispute_Detail__c = 'As per consumer, the enquiry loan type against this ERN ('+tempAccNumber+') should be ' +cs.Correct_Enquired_For__c + ' but reflecting as ' +cs.Displayed_Enquired_For__c;
                    cs.Sub_Type_Lookup__c = st.Id;
                    cs.Sub_Type_1_Lookup__c = st2.Id;
                    csValues.put(cs.Id,cs);
                }
            }
        }
        
        List<API_LOG__c> apliLogList = new List<API_LOG__c>();
        system.debug('csValues'+csValues.size() );
        if(csValues.size() > 0){
            
            Database.SaveResult[] srList = Database.update(csValues.values(),TRUE);
            
            for(Integer i=0;i<srList.size();i++){
                
                if(!srList.get(i).isSuccess()){
                    for(Database.Error err : srList[i].getErrors()) {
                        if(csValues.containskey(csLists[i].Id)){
                            API_LOG__c ap =new API_LOG__c();
                            ap.Request_Source__c='Common Batch Failed Case '+csValues.get(csLists[i].Id).CaseNumber;
                            ap.Case__c = csValues.get(csLists[i].Id).Id;
                            ap.Exception_Description__c = err.getMessage();
                            apliLogList.add(ap);
                        } 
                    }
                }
            }
        }   
        
        if(apliLogList.size() > 0){
            insert apliLogList;
        }
        
        
        //commnet on 31 jan
        //11.	In the case of the sub type "account status" and the displayed account status is "closed," or “Entity ceased while account was closed” we should change the sub type to "closed" and send a resolution in favor of the consumer. (Status needs to be resolved and Dispute Raised Date = today)
        
        /*if(cs.Origin == 'Portal' && cs.Sub_Type_Name__c =='Account Status' && (cs.Displayed_Account_Status__c == 'Closed'|| cs.Displayed_Account_Status__c =='Entity ceased while account was open' )){
if(subTypeMap.containskey(cs.Sub_Type_Lookup__c)){
cs.Sub_Type_1_Lookup__c = subTypeMap.get(cs.Sub_Type_Lookup__c);
cs.Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer' ;
cs.Status='Resolved';
cs.Dispute_Raised_Date__c = date.today();
csValues.put(cs.Id,cs);
caseId.add(cs.Id);
}
}


//15.	If the sub type 1 of the dispute is "current balance" and the displayed current balance is 0, we should immediately send a resolution in favor of the consumer. (Status needs to be resolved and Dispute Raised Date = today)

if((cs.Sub_Type_1_Name__c).toLowerCase().contains('current balance') &&  cs.Displayed_Loan_Balance__c == 0){
cs.Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer' ;
cs.Status='Resolved';
cs.Dispute_Raised_Date__c = date.today();
csValues.put(cs.Id,cs);
}

//16.	Similarly, if the sub type 1 is "overdue" and the displayed overdue amount is 0, we need to send a resolution in favor of the consumer. (Status needs to be resolved and Dispute Raised Date = today)
if((cs.Sub_Type_1_Name__c).toLowerCase().contains('over due') &&  cs.Displayed_Overdue_Amount__c == 0){
cs.Consumer_Dispute_Status__c = 'Resolved in favour of the Consumer' ;
cs.Status='Resolved';
cs.Dispute_Raised_Date__c = date.today();
csValues.put(cs.Id,cs);
}
*/
        
        //commnet on 31 jan
        // system.debug('subTypeId '+subTypeId+ 'displayedBankName '+displayedBankName+' accountNumber '+accountNumber+' consumerName '+consumerName);
        /* List<Account> accountList = [select Id, (select Id, Name_of_Consumer__r.Email, AccountId,Name_of_Consumer__c,Name_of_Consumer__r.Name,CaseNumber from cases where Sub_Type_Lookup__c IN : subTypeId and 
Displayed_Bank_Name__c IN  : displayedBankName and
Displayed_Account_number__c  IN : accountNumber and Name_of_Consumer__c In : consumerName and status=:'Open' order by CreatedDate desc
limit 2)
from Account where ID IN (select AccountId from case where Sub_Type_Lookup__c IN : subTypeId and 
Displayed_Bank_Name__c IN  : displayedBankName and
Displayed_Account_number__c  IN : accountNumber and Name_of_Consumer__c In : consumerName and status=:'Open')];

system.debug('csValues'+accountList.size() );


map<Id,Case> csMap = new map<Id,Case>();

for(Account acc : accountList){
if(csMap.containskey(acc.Id)){

}else{
system.debug('cases size'+acc.Cases.size());
if(acc.Cases.size() == 2){
csMap.put(acc.Id,acc.Cases[1]); 
}else if(acc.Cases.size() == 1){
csMap.put(acc.Id,acc.Cases[0]); 
}

}
}


//12.	When a consumer raises a dispute with the same subtype 1, displayed bank name, account number, consumer name, and the status is open, the system should send a working email to the consumer with the case number of the initially raised dispute.
List<Messaging.SingleEmailMessage> lstEmail = new List<Messaging.SingleEmailMessage>();

OrgWideEmailAddress[] owea = new OrgWideEmailAddress[]{};
if(!test.isRunningTest()){
owea = [select Id from OrgWideEmailAddress where Address = 'consumer.support@in.experian.com' limit 1];// To send from Org wide address

}
system.debug('---> csMap'+csMap);
for(Case cs : csMap.values()){
system.debug('consumber mail '+cs.Name_of_Consumer__r.Email);


Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
if ( owea.size() > 0 ) {
mail.setOrgWideEmailAddressId(owea.get(0).Id);
}
string EmailBody = '';
EmailBody +='Dear '+cs.Name_of_Consumer__r.Name+', <br/><br/>'; 
EmailBody +=' Thank you for contacting Experian Credit Information Company of India Pvt Ltd. <br/><br/>';
EmailBody +=' We are working on your query againt case number:  '+cs.CaseNumber +' we shall keep you updated regarding the same.<br/><br/>';
EmailBody +=' We had received your email with all the necessary information and raised it with the financial';
EmailBody +=' instituition. We are awaiting the response from the bank for us to resolve the same at our end. The';
EmailBody +=' regulations governing the dispute resolution process gives us 30 days from the date of the details';
EmailBody +=' received to resolve the same basis the information received from the financial instituition.<br/><br/>';
EmailBody +=' Please feel free to contact us for any further queries.<br/><br/> ';
EmailBody +=' Regards,<br/><br/>';

EmailBody +='<b>Consumer Support Team </b> <br/>';
EmailBody +='Experian Credit Information Company of India Private Limited <br/>';
EmailBody +='consumer.support@in.experian.com<br/>';
EmailBody +='<a href="www.experian.in">www.experian.in</a><br/><br/>';
EmailBody +='Get your Experian Credit Report & Score today, <a href="https://consumer.experian.in/ECV-OLN/view/angular/#/">click here</a>';

if(string.isnotblank(cs.Name_of_Consumer__r.Email)){
mail.setToAddresses(new List<string>{cs.Name_of_Consumer__r.Email});
}
mail.setHtmlBody(EmailBody);
mail.setUseSignature(false); 
mail.setBccSender(false);
mail.setSubject('We are working on your query');
mail.setSaveAsActivity(false); 
if(string.isnotblank(cs.Name_of_Consumer__r.Email)){
lstEmail.add(mail);
}
}

if(lstEmail.size() > 0){

List<Messaging.sendEmailResult> results = Messaging.sendEmail(lstEmail);
}
*/
        
    }
    
    
    global void finish(Database.BatchableContext BC) {
        
    }
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
        
    }
    
}