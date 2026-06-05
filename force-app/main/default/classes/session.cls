public class session {
    public session() {}

    public String startSession(String userId){
        
        Blob blobKey = crypto.generateAesKey(192);
        String key = EncodingUtil.base64encode(blobKey);
        System.debug('KEY====>'+key);
        Session__c SC = new Session__c();
        SC.sessionId__c = key;
        SC.User_Id__c = userId;
        SC.TIme__c = DateTime.now();
        SC.Expire_Time__c = DateTime.now().addminutes(2);
        try {
            Session__c existingSession = [SELECT Id,sessionId__c FROM Session__c WHERE User_Id__c =: userId ];
            SC.Id = existingSession.Id;
        } catch (Exception e) {
            
        }
        System.debug('TiME==NOW==>'+DateTime.now());
        System.debug('TiME====>'+DateTime.now().addminutes(10));
        
        upsert SC;        

        return key;
    }

    public void updateSession(String userId, String sessionId,Session__c SC){
        try {
            Session__c SC_update=new Session__c();
            SC_update.Id=SC.ID;
            SC_update.sessionId__c = SC.sessionId__c;
            SC_update.User_Id__c = userId;
            SC_update.TIme__c = DateTime.now();
            SC_update.Expire_Time__c = DateTime.now().addminutes(10);
            update SC_update;

        } catch (Exception e) {
            System.debug('updateSession method exception'+e);
        }
    }

    public void deleteSession(String userId){
        try {
            System.debug('inside deleteSession');
            List<Session__c> SC = [ SELECT Id, User_Id__c, sessionId__c,TIme__c,Expire_Time__c FROM Session__c WHERE User_Id__c =: userId];
            delete SC;  
        } catch (Exception e) {
            System.debug('------------------->deleteSession method exception'+e);
        }
    }

    public Boolean checkSession(String userId, String sessionId){
        Boolean returnVar = false;
        System.debug('getInforamtion Token 1=> '+sessionId);
        System.debug('getInforamtion userId 1=> '+userId);
        
        try {
            Session__c SC = [ SELECT Id, User_Id__c, sessionId__c,TIme__c,Expire_Time__c FROM Session__c WHERE User_Id__c =: userId AND sessionId__c =: sessionId ];
            system.debug('---->'+SC);
            DateTime CurrentDT = DateTime.now();
            String varSC = SC.sessionId__c;
            System.debug('getInforamtion sessionId__c 1=> '+SC.sessionId__c);
            System.debug('getInforamtion sessionId__c vae1=> '+varSC);
            DateTime expTime = SC.Expire_Time__c;
            System.debug('varSC.equals(sessionId)--->'+varSC.equals(sessionId));
            if(varSC.equals(sessionId)){
                System.debug('CurrentDT--->'+CurrentDT);
                System.debug('expTime--->'+expTime);
                if(CurrentDT > expTime){
                    System.debug('Bigger');
                    returnVar = false;
                }else{
                    System.debug('Smaller');
                    updateSession(userId, sessionId,SC);
                    returnVar = true;
                }
            }else{
                System.debug('ELSE Smaller');
                returnVar = false;
            }
            
        } catch (Exception e) {
            System.debug('checkSession method exception'+e);
            returnVar = false;
        }
        return returnVar;
    }

}