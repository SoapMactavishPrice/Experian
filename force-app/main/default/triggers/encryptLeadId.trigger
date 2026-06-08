trigger encryptLeadId on Lead (after insert) {

    List<Lead> listlead = new List<Lead>();  

     if(RecursiveTriggerHandler.isFirstTime){
        RecursiveTriggerHandler.isFirstTime = false;
    
        for(Lead led : trigger.new){ 
        
            Lead ld = new Lead(Id = led.Id);
            
            system.debug('****'+ld);
            
            if(ld.Encrypted_Lead_Id__c == Null || String.isblank(ld.Encrypted_Lead_Id__c)){
            
                System.debug('*test***'+ld);
                Blob privateKey = Blob.valueOf('046QdQEH24AgGa==');
                //encrypted blob
                Blob cipherText = Crypto.encryptWithManagedIV('AES128', privateKey, Blob.valueOf(ld.Id));
                //encrypted string
                String encodedCipherText = EncodingUtil.convertToHex(cipherText);
                
                String str = '?id='+encodedCipherText;
                
                System.debug('encodedCipherText-->'+encodedCipherText);
                System.debug('encodedCipherText-->'+str);
                //Blob privateKey = EncodingUtil.base64Decode('046QdQEH24AgGafkkot8gg=='); 
                System.debug('privateKey--->'+privateKey); 
                
                ld.Encrypted_Lead_Id__c = str;
               
                listlead.add(ld); 
            } 
        }
    }
        
    if(listlead.size()>0){
        
        update listlead;
        
    } 
}