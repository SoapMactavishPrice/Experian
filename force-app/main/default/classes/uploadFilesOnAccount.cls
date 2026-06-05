public with sharing class uploadFilesOnAccount {
    public uploadFilesOnAccount() {
    }
    public class fileDataList{
        public string filename;
        public string fileContent ;
        public string fileExtension;
    }
    
    @AuraEnabled
    public static String uploadFile(string fileData, String recordId) {
        try{  
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
                    cv.Title = file.filename;
                    cv.PathOnClient = file.fileExtension;
                    contentList.add(cv);
                }
                insert contentList;
                
                
                for(ContentVersion cvr :[select Id,ContentDocumentId from ContentVersion where Id IN:contentList]){
                    ContentDocumentLink cvl = new ContentDocumentLink();
                    cvl.LinkedEntityId = recordId;
                    cvl.ContentDocumentId = cvr.ContentDocumentId;
                    cvl.Visibility = 'AllUsers';
                    cvl.shareType = 'V';
                    cdlList.add(cvl);
                }
                insert cdlList;
                
            }else{
                return 'Record Id blank';
            }
            string retu;
            if(cdlList.size() > 0)
                retu = 'success';
            else 
                retu = '';
            
            return retu;
        }
        catch (Exception ex) {
            System.debug(ex.getMessage() + ' -> ' + ex.getStackTraceString());
            System.debug(ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage());
        }
    }
}