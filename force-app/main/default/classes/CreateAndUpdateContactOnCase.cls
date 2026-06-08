public class CreateAndUpdateContactOnCase {

    map <String, List < Case >> emailMatchingMap = new map < String, List < Case >> ();
    Set<String> emailKeySet = new  Set<String>();
    List<Case> filteredCaseList = new List<Case>();
    List<Case> filteredCaseList2 = new List<Case>();
    List<Case> filteredCaseList3 = new List<Case>();
    List<Contact> listOfContacts = new List<Contact>();

    //fill the Contact Email to Contact 
    Map<String,Contact> mapOfEmailToContact = new Map<String,Contact>();
    
    public void assignRelatedRecordsToCase (List<Case> caseList){
        
       
        Set<String> Emailset = new Set<String>();
        Map<String,Contact> conMap = new Map<String,Contact>();
        set<Id> cid = new set<Id>();
        /*set<string> bankName = new set<String>();
        Map<string,Id> bankNameMap = new Map<string,Id>();
        Map<string,Id> accMap = new Map<string,Id>(); 
        Map<Id, Case> caseMap = new Map<Id, Case>(); */
        
        for(Case cs : caseList){ 
            
            /*if(string.isNotBlank(cs.Displayed_Bank_Name__c) && string.isBlank(cs.AccountId)
            && cs.Displayed_Bank_Name__c !='State Bank of India'){
            bankName.add(cs.Displayed_Bank_Name__c); 
            }*/
            
            if(cs.Origin =='Portal' && string.IsBlank(cs.Name_of_Consumer__c)){
                filteredCaseList.add(cs);
                
                if(String.IsNotBlank(cs.Displayed_Email_Id__c)) {
                    Emailset.add(cs.Displayed_Email_Id__c.tolowercase());
                }
                if(String.IsNotBlank(cs.Correct_email_id__c)) {
                    Emailset.add(cs.Correct_email_id__c.tolowercase());
                }
                if(string.IsNotblank(cs.Current_Application_Email__c)){
                    Emailset.add(cs.Current_Application_Email__c.tolowercase());
                }
                if(string.IsNotblank(cs.ContactEmailId__c)){
                    Emailset.add(cs.ContactEmailId__c.tolowercase());
                }
            }
        }
        
        /*if(bankName.size() > 0){

        List<Account> accList = [Select Id, Name, Displayed_Bank_Name__c,Displayed_Bank_Name_2__c,Displayed_Bank_Name_3__c from Account 
        Where ( Name IN : bankName or Displayed_Bank_Name__c IN : bankName 
        or Displayed_Bank_Name_2__c IN : bankName 
        or Displayed_Bank_Name_3__c IN : bankName) and Member_Status__c != 'Merged'];

        if(accList.size()>0){
        for(Account acc : accList){
        accMap.put(acc.Name, acc.Id);
        if(string.isNotBlank(acc.Displayed_Bank_Name__c)){
        bankNameMap.put(acc.Displayed_Bank_Name__c,acc.Id);  
        }
        if(string.isNotBlank(acc.Displayed_Bank_Name_2__c)){
        bankNameMap.put(acc.Displayed_Bank_Name_2__c,acc.Id);  
        }
        if(string.isNotBlank(acc.Displayed_Bank_Name_3__c)){
        bankNameMap.put(acc.Displayed_Bank_Name_3__c,acc.Id);  
        }
        }
        }
        }*/
                
                /*  for(Case cs : caseList){ 
        if(bankNameMap.containskey(cs.Displayed_Bank_Name__c)) {
        if(caseMap.containsKey(cs.Id)) {
        caseMap.get(cs.Id).AccountId = bankNameMap.get(cs.Displayed_Bank_Name__c);
        } else {
        caseMap.put(cs.Id, new Case(Id = cs.Id, AccountId = bankNameMap.get(cs.Displayed_Bank_Name__c)));
        }
        }
        }

        //Update Case
        if(caseList.size() > 0) {
        Database.SaveResult [] cr1 = Database.update(caseMap.values(), false);
        for(Database.SaveResult result : cr1){
        System.debug(result);
        if(result.isSuccess()){
        }
        }
        }*/
        
        system.debug('filteredCaseList Size -> '+filteredCaseList.size());
        
        if(filteredCaseList.size()>0){
            

            for(case cs: filteredCaseList) {

                System.debug('Inside createRelatedRecords Correx Obj'+cs.ContactEmailId__c);

                if(emailMatchingMap.containsKey(cs.ContactEmailId__c)){
                    emailMatchingMap.get(cs.ContactEmailId__c).add(cs);
                }else{
                    emailMatchingMap.put(cs.ContactEmailId__c, new list<case>{cs});
                }
            }

            //fetch all the Contacts with these setOfEmails.
            system.debug('Emailset '+Emailset);
            List<Contact> contactList = new List<Contact>();
            
            if(Emailset.size() > 0){
                contactList  = [SELECT Id, Name, Email, Contact_Role__c FROM Contact 
                                WHERE Email != NULL AND Contact_Role__c = 'Consumer' AND Email IN : Emailset];
            }
            
            if(contactList.isEmpty()) {
                System.debug('** Directly creating new Contact ** ');
                //Create the new Contact and tag the case under them.
                checkDuplicateRecords(filteredCaseList);
            }
            else{
                System.debug('** Checking Available Contacts ** ');
                
                if(contactList.size() > 0){
                    for(Contact con : contactList){
                        conMap.put(con.Email.tolowercase(),con);
                    }
                }
                
                for(case cs: filteredCaseList) {
                    
                    if(String.IsNotBlank(cs.Displayed_Email_Id__c) && String.IsBlank(cs.Name_of_Consumer__c)) {
                        system.debug('Incoming Displayed Email ** ' +cs.Displayed_Email_Id__c);
                        if(conMap!= null && conMap.containsKey(cs.Displayed_Email_Id__c.tolowercase())) {
                            cs.Name_of_Consumer__c = conMap.get(cs.Displayed_Email_Id__c.tolowercase()).Id;
                        }
                    }
                    if(String.isNotBlank(cs.Correct_email_id__c) && String.IsBlank(cs.Name_of_Consumer__c)) {
                        system.debug('Incoming Correct_email_id__c  ** ' +cs.Correct_email_id__c);
                        if(conMap!= null && conMap.containsKey(cs.Correct_email_id__c.tolowercase())) {
                            cs.Name_of_Consumer__c = conMap.get(cs.Correct_email_id__c.tolowercase()).Id;
                        }
                    }
                    if(String.isNotBlank(cs.Current_Application_Email__c) && String.IsBlank(cs.Name_of_Consumer__c)) {
                        system.debug('Incoming Current_Application_Email__c  ** ' +cs.Current_Application_Email__c);
                        if(conMap!= null && conMap.containsKey(cs.Current_Application_Email__c.tolowercase())) {
                            cs.Name_of_Consumer__c = conMap.get(cs.Current_Application_Email__c.tolowercase()).Id;
                        }
                    }
                    if(String.isNotBlank(cs.ContactEmailId__c) && String.IsBlank(cs.Name_of_Consumer__c)) {
                        system.debug('Incoming ContactEmailId__c Email ** ' +cs.ContactEmailId__c);
                        if(conMap!= null && conMap.containsKey(cs.ContactEmailId__c.tolowercase())) {
                            cs.Name_of_Consumer__c = conMap.get(cs.ContactEmailId__c.tolowercase()).Id;
                        }
                    }
                    
                    System.debug('Case no '+cs.CaseNumber);
                    
                    if(String.IsBlank(cs.Name_of_Consumer__c) && 
                       ((String.isNotBlank(cs.Displayed_Email_Id__c) || String.isNotBlank(cs.Correct_email_id__c) ||
                         String.isNotBlank(cs.Current_Application_Email__c) || String.isNotBlank(cs.ContactEmailId__c)))){ 
                             filteredCaseList3.add(cs); 
                         }
                }
                
                if(filteredCaseList3.size()>0){
                    //create New Contact
                    System.debug('** Could not Find the Matching Name_of_Consumer__c, Hence passing to checkDuplicateRecords for Con Creation ** ');
                    checkDuplicateRecords(filteredCaseList3);
                } 
            }
        }
    }
    
    private void checkDuplicateRecords(List<Case> listOfCase){
        
        for(Case objCase : listOfCase) {

            system.debug('emailKeySet contains -> ' +emailKeySet);

            List<case> TempFilteredCaseList;
            if(!emailMatchingMap.isEmpty() && emailMatchingMap.containsKey(objCase.ContactEmailId__c) && !emailKeySet.contains(objCase.ContactEmailId__c)){
                TempFilteredCaseList = emailMatchingMap.get(objCase.ContactEmailId__c);
                emailKeySet.add(objCase.ContactEmailId__c);
            }else{
                Continue;
            }

            system.debug('TempFilteredCaseList Size -> ' +TempFilteredCaseList.size());

            if(TempFilteredCaseList.size()>=1){
                system.debug('1 Case or More than 1 case with same Email Address, we always pick the first Entry for Contact Creation ** ');
                filteredCaseList2.add(TempFilteredCaseList[0]); 
            }

        }

        if(filteredCaseList2.size()>0){
            //create New Contact
            System.debug('** Done the Filtering, Now Passing only the Unique email Id cases ** ');
            createRelatedRecords(filteredCaseList2);
        } 

        
    }

    private void createRelatedRecords(List<Case> listOfCase){
        
        for(Case objCase : listOfCase) {
            
            if(String.IsNotBlank(objCase.Displayed_Name__c) || String.IsNotBlank(objCase.Contact_Name__c)){
                
                Contact con = new Contact();
                if(String.IsNotBlank(objCase.Displayed_Name__c)){
                    con.LastName = objCase.Displayed_Name__c;
                }else if(String.IsNotBlank(objCase.Contact_Name__c)){
                    con.LastName = objCase.Contact_Name__c;
                }
                if(String.IsNotBlank(objCase.Displayed_Email_Id__c))
                    con.Email = objCase.Displayed_Email_Id__c;
                if(String.IsNotBlank(objCase.Correct_email_id__c))
                    con.Email = objCase.Correct_email_id__c;
                if(String.IsNotBlank(objCase.Current_Application_Email__c))
                    con.Email = objCase.Current_Application_Email__c;
                if(String.IsNotBlank(objCase.ContactEmailId__c)){
                    con.Email = objCase.ContactEmailId__c;
                }
                if(String.IsNotBlank(objCase.ContactMobileNo__c)){
                    con.Phone = objCase.ContactMobileNo__c;
                }
                if(String.IsNotBlank(objCase.ContactPan__c)){
                    con.Pan_no__c = objCase.ContactPan__c;
                }
                if(String.IsNotBlank(String.valueOf(objCase.Contact_Date_of_Birth__c))){
                    con.Birthdate = objCase.Contact_Date_of_Birth__c;
                }
                if(String.IsNotBlank(objCase.Contact_Address__c)){
                    con.Address_1__c = objCase.Contact_Address__c;
                }
                con.Phone = objCase.Displayed_Mobile_No__c;
                con.Pan_no__c = objCase.Displayed_PAN_No__c;
                string Displayed_Address_1 = objCase.Displayed_Address__c != null ? objCase.Displayed_Address__c : objCase.Displayed_Address_1_v1__c;
                con.Address_1__c = Displayed_Address_1;
                con.Contact_Role__c = 'Consumer';        
                listOfContacts.add(con);
            }
        }
        
        if(!listOfContacts.isEmpty()) {
            INSERT listOfContacts;
            
            for(Contact objContact : listOfContacts) {
                mapOfEmailToContact.put(objContact.Email, objContact);    
            }
        }
        
        //I am running over FilteredCaseLit as its the Main case List
        for(Case objCase : filteredCaseList) {         
            
            if(string.IsBlank(objCase.Name_of_Consumer__c)){
            
                for(String objEmail : mapOfEmailToContact.keyset()) {
                    
                    system.debug('objEmail -->  ' +objEmail);
                    
                    if(String.IsNotBlank(objCase.Displayed_Email_Id__c)){
                        if(objCase.Displayed_Email_Id__c.tolowercase() == objEmail){
                            //Contact is Tagged Here
                            system.debug(' Inside Displayed_Email_Id__c -->  ');
                            objCase.Name_of_Consumer__c = mapOfEmailToContact.get(objEmail).Id;
                        }
                    }
                    
                    if(String.IsNotBlank(objCase.Correct_email_id__c)){
                        if(objCase.Correct_email_id__c.tolowercase() == objEmail){
                            //Contact is Tagged Here
                            system.debug(' Inside Correct_email_id__c -->  ');
                            objCase.Name_of_Consumer__c = mapOfEmailToContact.get(objEmail).Id;
                        }
                    }
                    
                    if(String.IsNotBlank(objCase.Current_Application_Email__c)){
                        if(objCase.Current_Application_Email__c.tolowercase() == objEmail){
                            //Contact is Tagged Here
                            system.debug(' Inside Current_Application_Email__c -->  ');
                            objCase.Name_of_Consumer__c = mapOfEmailToContact.get(objEmail).Id;
                        }
                    }
                    
                    if(String.IsNotBlank(objCase.ContactEmailId__c)){
                        if(objCase.ContactEmailId__c.tolowercase() == objEmail){
                            //Contact is Tagged Here
                            system.debug(' Inside ContactEmailId__c -->  ');
                            objCase.Name_of_Consumer__c = mapOfEmailToContact.get(objEmail).Id;
                        }
                    }
                }
            }
        }
    }
    
    public void updateAccount (List<Case> caseList){
        
        set<string> bankName = new set<String>();
        Map<string,Id> bankNameMap = new Map<string,Id>();
        Map<string,Id> accMap = new Map<string,Id>(); 
        Map<Id, Case> caseMap = new Map<Id, Case>();
        
        for(Case cs : caseList){ 
            
            if(string.isNotBlank(cs.Displayed_Bank_Name__c) && string.isBlank(cs.AccountId)
               && cs.Displayed_Bank_Name__c !='State Bank of India'){
                   bankName.add(cs.Displayed_Bank_Name__c); 
               }
        }
        
        if(bankName.size() > 0){
            
            List<Account> accList = [Select Id, Name, Displayed_Bank_Name__c,Displayed_Bank_Name_2__c,Displayed_Bank_Name_3__c from Account 
                                     Where ( Name IN : bankName or Displayed_Bank_Name__c IN : bankName 
                                            or Displayed_Bank_Name_2__c IN : bankName 
                                            or Displayed_Bank_Name_3__c IN : bankName) and Member_Status__c != 'Merged'];
            
            if(accList.size()>0){
                for(Account acc : accList){
                    accMap.put(acc.Name, acc.Id);
                    if(string.isNotBlank(acc.Displayed_Bank_Name__c)){
                        bankNameMap.put(acc.Displayed_Bank_Name__c,acc.Id);  
                    }
                    if(string.isNotBlank(acc.Displayed_Bank_Name_2__c)){
                        bankNameMap.put(acc.Displayed_Bank_Name_2__c,acc.Id);  
                    }
                    if(string.isNotBlank(acc.Displayed_Bank_Name_3__c)){
                        bankNameMap.put(acc.Displayed_Bank_Name_3__c,acc.Id);  
                    }
                }
            }
        }
        
        for(Case cs : caseList){ 
            if(bankNameMap.containskey(cs.Displayed_Bank_Name__c)) {
                if(caseMap.containsKey(cs.Id)) {
                    caseMap.get(cs.Id).AccountId = bankNameMap.get(cs.Displayed_Bank_Name__c);
                } else {
                    caseMap.put(cs.Id, new Case(Id = cs.Id, AccountId = bankNameMap.get(cs.Displayed_Bank_Name__c)));
                }
            }
        }
        
        //Update Case
        if(caseList.size() > 0) {
            Database.SaveResult [] cr1 = Database.update(caseMap.values(), false);
            for(Database.SaveResult result : cr1){
                System.debug(result);
                if(result.isSuccess()){
                }
            }
        }
    }
}