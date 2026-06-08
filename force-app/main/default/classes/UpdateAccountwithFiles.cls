public class UpdateAccountwithFiles {
    @AuraEnabled
    public static string updateaccount(string accountId,string newName,string fileData){
        map<string,object> msg = new map<string,object>();
        try{
            string oldName = '';
            map<Id,Object> checkAccount = new map<Id,Object>(); 
            List<Account> aclist = [Select Id,Name, Name_Changed__c from account where Id=:accountId];
            List<Account> updateAccount = new List<Account>();
            for(Account ac: aclist){
                oldName = ac.Name;
                if(checkAccount.containsKey(ac.Id)){
                    
                    ac.Name= newName;
                    ac.Name_Changed__c = true;
                    updateAccount.add(ac);
                }else{
                    ac.Name= newName;
                    ac.Name_Changed__c = true;
                    checkAccount.get(ac.Id);
                    updateAccount.add(ac);
                }
            }
            
            List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
            if(string.isNotBlank(fileData)) {
                system.debug('fileData'+fileData);
                List<fileDataList> files = (List<fileDataList>) Json.deserialize(fileData,List<fileDataList>.class);
                system.debug('files'+files);
                List<ContentVersion> contentList = new List<ContentVersion>();
                for(fileDataList file : files){
                    ContentVersion cv = new ContentVersion();
                    
                    string strImage ='';
                    strImage  =  file.fileContent.substring(file.fileContent.indexOf(',')+1,file.fileContent.length());
                    cv.VersionData = EncodingUtil.base64Decode(strImage);
                    cv.contentlocation = 'S';
                    cv.Title = oldName +'- to '+ newName;
                    cv.PathOnClient = file.fileExtension;
                    contentList.add(cv);
                }
                insert contentList;
                
                
                for(ContentVersion cvr :[select Id,ContentDocumentId from ContentVersion where Id IN:contentList]){
                    ContentDocumentLink cvl = new ContentDocumentLink();
                    cvl.LinkedEntityId = accountId;
                    cvl.ContentDocumentId = cvr.ContentDocumentId;
                    cvl.Visibility = 'AllUsers';
                    cvl.shareType = 'V';
                    cdlList.add(cvl);
                }
                insert cdlList;
            }
            
            if(updateAccount.size()> 0){
                update updateAccount;
            }
            system.debug('57--->'+updateAccount);
            if(updateAccount.size()> 0){
               updateAccount[0].Name_Changed__c = false;
               update updateAccount;
            }
            
            system.debug('62--->'+updateAccount);
            msg.put('sucess','sucess');
            
        }catch(exception e){
            msg.put('error',e.getMessage());
        }
        system.debug('msg-->'+msg);
        return JSOn.serialize(msg);
    }
    
    
    public class fileDataList{
        public string filename;
        public string fileContent ;
        public string fileExtension;
    }
    

}