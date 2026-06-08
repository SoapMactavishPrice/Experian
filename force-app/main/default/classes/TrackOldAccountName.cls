public class TrackOldAccountName {
    
    public TrackOldAccountName(){
    }
    
    @future (callout=true)
    public static void UpdateOldAccountName(Set<Id> ids){
        
        List<Account> accupdate  = new List<Account>();
        
        for (Account ca : [SELECT Id, Name, Old_Account_Name__c,
                           (SELECT Id, OldValue, NewValue, Field FROM Histories WHERE Field='TextName' ORDER by CreatedDate desc limit 1)
                           FROM Account where Id IN: ids]) 
        {
            
            for( AccountHistory cs: ca.Histories ){
                
                system.debug('OldValue---------'+cs.OldValue);
                system.debug('NewValue---------'+cs.NewValue);
                String oldVal = String.valueOf(cs.oldValue);
                String newVal = String.valueOf(cs.newValue);
                String field  = String.valueOf(cs.field); 
                system.debug('The value on ' + field + ' has been changed from ' + oldVal + ' to ' + newVal);
                
                if(ca.Name != null) {                    
                    Account cse= new Account ();
                    cse.id=ca.id;
                    cse.Old_Account_Name__c= oldVal;
                    accupdate.add(cse);
                }
            }             
        }
        
        map<id,Account> accmap = new map<id,Account>();
        accMap.putall(accupdate);
        system.debug('accmap---------'+accMap);
        if(accmap.size()>0){
            update accmap.values();
            system.debug('accmap.values()---------'+accmap.values());
        } 
    }
}