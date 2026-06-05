public class updateIOCommentController {

    @AuraEnabled 
    public static List<object> updateCase(boolean bCheck, string js){
        
        List<object> result = new List<object>();
        List<Object> objList = (List<Object>)JSON.deserializeUntyped(js);
        List<Case> csList= new List<Case>();
        
        List<IO_Comments__c> iocList = new List<IO_Comments__c>();
        for(Object obj: objList){
            map<string,object> objMap = (map<string,object>)obj;
            Case cs = new Case();
            cs.Id = (Id)objMap.get('Id');
            IO_Comments__c ioc = new IO_Comments__c();
            ioc.Case__c = (Id)objMap.get('Id');
            ioc.Status__c = (string)objMap.get('IO_Status');
            ioc.IO_Comments__c = (string)objMap.get('IO_Comment');
            iocList.add(ioc);
            //cs.IO_Comments__c = (string)objMap.get('IO_Comment');
            //cs.IO_Status__c = (string)objMap.get('IO_Status');
            csList.add(cs);
        }
        
        if(csList.size() > 0){
            Database.SaveResult[] results = Database.insert(iocList, false); // 'false' allows partial success
            for (Integer i = 0; i < results.size(); i++) {
                Map<string,object> resultMap = new Map<string,object> ();
                if (results[i].isSuccess()) {
                    resultMap.put('Id', csList[i].Id);
                    resultMap.put('Status', 'Success');
                    resultMap.put('Message', 'IO Comment Insert Successfully');
                    result.add(resultMap);
                } else {
                    //failedUpdates.add('Failed to update Case with Id: ' + casesToUpdate[i].Id + ' - Error: ' + results[i].getErrors()[0].getMessage());
                    //system.debug();
                    resultMap.put('Id', csList[i].Id);
                    resultMap.put('Status', 'Failed');
                    resultMap.put('Message', results[i].getErrors()[0].getStatusCode()+': ' + results[i].getErrors()[0].getMessage()+' - '+results[i].getErrors()[0].getFields());
                    result.add(resultMap);
                    system.debug('Error'+result);
                }
            }
        }
        
        if(result.size() > 0)
            return result;
        else 
            return null;
        
    }
    
}