global class MapContactBatchClass implements Database.Batchable<sObject>{
    
    global Database.querylocator start(Database.BatchableContext BC) { 
        
        Date today = Date.today();
        string query = 'Select Id, Email, Address_1__c, State__c, Email_2__c From Contact Where Email!=null OR Email_2__c!=null';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> Contactscope){
        
        List<Case> contrToUpdate = new List<Case>();
        
        map<string, Contact> emailMap  = new map<string,Contact>();
        map<string, Contact> emailMap2 = new map<string,Contact>();
        map<string, Contact> ContactRoleMap  = new map<string,Contact>();
        
        Set<Id> conid = new Set<Id>();
        for(Contact l : Contactscope){
            conid.add(l.id);            
        }
        
        List<Contact> conlist= [Select Id, Email, Address_1__c, State__c, Email_2__c, Contact_Role__c From Contact Where Id=:conid ];
        List<Case> scope=  [Select Id, Origin, ContactId, SuppliedEmail, CreatedDate, Displayed_Email_Id__c, NO_Case__c, PNO_Case__c,
                            Correct_email_id__c, Current_Application_Email__c, ContactEmailId__c, Name_of_Consumer__c, Case_Category__c
                            from Case where ((SuppliedEmail != null and ContactId = null)  
                                             OR (Origin = 'Portal' and Name_of_Consumer__c = null)) and CreatedDate =today]; //OR (SuppliedEmail != null and ContactId != null)
        
        Map<String,State__c> stateMap = new Map<String,State__c>();//
        List<State__c> stateList = [select Id,Name from State__c limit 50];
        List<string> str = new List<string>(); 
        for(State__c st : stateList){
            stateMap.put((st.Name).toLowerCase(),st);
        }
        
        map<Id,Contact> conMap = new map<Id,Contact>();
        for(Contact c: conlist){
            if(c.Address_1__c != null){
                if(string.isBlank(c.state__c)){
                    for (String stateName : stateMap.keySet()) {
                        if (c.Address_1__c.containsIgnoreCase(stateName)) {
                            c.state__c = stateMap.get(stateName).Id;
                            conMap.put(c.Id,c);
                            break;
                        }
                    }
                }
            }
            
            if((c.Email !=null || c.Email_2__c !=null) && c.Contact_Role__c == null ){
                ContactRoleMap.put(c.Email, c);
            }
            if(c.Email !=null){
                emailMap.put(c.Email, c);
            }
            if(c.Email_2__c !=null){
                emailMap2.put(c.Email_2__c, c); 
            }
        }
        
        for(Case l : scope){
            
            if(emailMap !=null && emailMap.containsKey(l.SuppliedEmail)){
                l.ContactId=emailMap.get(l.SuppliedEmail).id;
                contrToUpdate.add(l);
            }
            if(emailMap2 !=null && emailMap2.containsKey(l.SuppliedEmail)){
                l.ContactId=emailMap2.get(l.SuppliedEmail).id;
                contrToUpdate.add(l); 
            }
            
            //if(l.SuppliedEmail != null && l.NO_Case__c == false && l.PNO_Case__c  == false && l.Case_Category__c =='Consumer'){
                //l.Send_Acknowledgement_to_Email_Case__c  = true;
                //contrToUpdate.add(l); 
            //}

            if(ContactRoleMap !=null && ContactRoleMap.containsKey(l.Displayed_Email_Id__c)){
                Contact con = conMap.containsKey(ContactRoleMap.get(l.Displayed_Email_Id__c).Id) ?
                    conMap.get(ContactRoleMap.get(l.Displayed_Email_Id__c).Id) :
                new Contact(Id = ContactRoleMap.get(l.Displayed_Email_Id__c).Id);
                con.Contact_Role__c = 'Consumer';
                conMap.put(con.Id, con);
            }
            if(ContactRoleMap !=null && ContactRoleMap.containsKey(l.Correct_email_id__c)){
                Contact con = conMap.containsKey(ContactRoleMap.get(l.Correct_email_id__c).Id) ?
                    conMap.get(ContactRoleMap.get(l.Correct_email_id__c).Id) :
                new Contact(Id = ContactRoleMap.get(l.Correct_email_id__c).Id);
                con.Contact_Role__c = 'Consumer';
                conMap.put(con.Id, con);
            }
            if(ContactRoleMap !=null && ContactRoleMap.containsKey(l.Current_Application_Email__c)){
                Contact con = conMap.containsKey(ContactRoleMap.get(l.Current_Application_Email__c).Id) ?
                    conMap.get(ContactRoleMap.get(l.Current_Application_Email__c).Id) :
                new Contact(Id = ContactRoleMap.get(l.Current_Application_Email__c).Id);
                con.Contact_Role__c = 'Consumer';
                conMap.put(con.Id, con);
            }
            if(ContactRoleMap !=null && ContactRoleMap.containsKey(l.ContactEmailId__c)){
                Contact con = conMap.containsKey(ContactRoleMap.get(l.ContactEmailId__c).Id) ?
                    conMap.get(ContactRoleMap.get(l.ContactEmailId__c).Id) :
                new Contact(Id = ContactRoleMap.get(l.ContactEmailId__c).Id);
                con.Contact_Role__c = 'Consumer';
                conMap.put(con.Id, con);
            }
        } 

        map<Id,Case> accMap = new map<Id,Case>();
        accMap.putall(contrToUpdate);
        
        if(accmap.size()>0){
            update accmap.values();
        }
        if(conMap.size() > 0){
            update conMap.values();
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
    }
}