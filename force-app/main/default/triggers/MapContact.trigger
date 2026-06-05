trigger MapContact on Case (before insert) { 
    /*
    // We are mapping contact id if the case email matches with any existing conatct email
    
    map<string, Contact> emailMap  = new map<string,Contact>();
    map<string, Contact> emailMap2 = new map<string,Contact>();
    
    List<Contact> conlist= [Select Id, Email, Email_2__c From Contact Where Email!=null OR Email_2__c!=null limit 49999];
    
    for(Contact c: conlist){
        if(c.Email!=null){
            emailMap.put(c.Email, c);
        }
        if(c.Email_2__c!=null){
            emailMap2.put(c.Email_2__c, c); 
        }
    }  
    
    for(Case l :Trigger.new){
        if(emailMap!=null && emailMap.containsKey(l.SuppliedEmail)){
            l.ContactId=emailMap.get(l.SuppliedEmail ).id;
        }
        if(emailMap2!=null && emailMap2.containsKey(l.SuppliedEmail)){
            l.ContactId=emailMap2.get(l.SuppliedEmail ).id;
        }
    } */
}