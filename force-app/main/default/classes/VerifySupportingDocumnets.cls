public without sharing class VerifySupportingDocumnets {
    private static final String  BASE_URL =Url.getOrgDomainUrl().toExternalForm();
    public VerifySupportingDocumnets() {

    }

    @AuraEnabled
    public static string getDoumnetData (string leadId){
        List<Supporting_Document__c> splist = new List<Supporting_Document__c>();
        splist = [Select Id, lead__c,Document_Status__c,Supporting_Document_Name__c from Supporting_Document__c 
        where lead__c=:leadId];

        List<dataWrapper> dtList = new List<dataWrapper>(); 
        Integer Index = 1;
        for(Supporting_Document__c sob : splist){
            dataWrapper stb = new dataWrapper();
            stb.Id = sob.Id;
            stb.index = Index++;
            stb.Name = sob.Supporting_Document_Name__c;
            stb.status = sob.Document_Status__c;
            if(sob.Document_Status__c =='Approved'){
                stb.isVerified = true;
            }else{
                stb.isVerified = false;
            }
            
            dtList.add(stb);
            
        }
        
        system.debug(dtList.size() + '  '+dtList);

        return JSON.serialize(dtList);
    }
    
    @AuraEnabled 
    public static string getDocumentUrl (string Id){
        
          // List<FileData> files=new List<FileData>();
               system.debug('Id'+Id);

                List<ContentVersion> contentVersions = new List<ContentVersion>();

               ContentDocumentLink cdl = [
                    SELECT ContentDocumentId
                    FROM ContentDocumentLink
                    WHERE LinkedEntityId = :Id limit 1
                 ];
        
                
                    ContentVersion  attach = [
                        SELECT Id, Title, VersionData,FileExtension, ContentDocumentId, ContentDocument.Title, ContentDocument.CreatedDate
                        FROM ContentVersion
                        WHERE ContentDocumentId = :cdl.ContentDocumentId
                        AND ContentDocument.filetype != 'mp4'
                        ORDER BY CreatedDate DESC limit 1];
                 

                   /* FileData data=new FileData();
                    data.Name=attach.Title;
                    data.FileType=attach.FileExtension;
                    data.DownloadUrl =BASE_URL + '/sfc/servlet.shepherd/document/download/'+attach.ContentDocumentId;
                    data.FileUrl =BASE_URL + '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB720BY480&versionId='+attach.Id;
        if(attach.FileExtension !='docx'){
            system.debug('inside if');
            data.Base64Link ='data:image/png;base64,'+EncodingUtil.base64Encode(attach.VersionData);
        }else{
            system.debug('inside else');
            data.Base64Link ='application/vnd.openxmlformats-officedocument.wordprocessingml.document;base64,'+EncodingUtil.base64Encode(attach.VersionData);
            
        }
            
        
                    data.Id=attach.Id;
        
        system.debug(data);*/
                 return attach.ContentDocumentId;
    }
    
    @AuraEnabled 
    public static string saveStatus(string js  ){
        List<dataWrapper> dwrpList= VerifySupportingDocumnets.parse(js);
        List<Supporting_Document__c> sdpList = new List<Supporting_Document__c>();
        for(dataWrapper dwd : dwrpList){
            if(dwd.status !='Pending'){
                Supporting_Document__c sdp = new Supporting_Document__c(); 
                sdp.Id = dwd.Id;
                sdp.Document_Status__c = dwd.status;
                sdpList.add(sdp);
            }
           
        }
        if(sdpList.size() > 0){
            update sdpList;
        }
        return 'success';
    }
    
    public static List<dataWrapper> parse(string js){
        return (List<dataWrapper>)system.JSON.deserialize(js,List<dataWrapper>.class);
    }

    public with sharing class dataWrapper{
        public string Id;
        public Integer index;
        public string Name;
        public string status;
        public boolean isVerified;
    }
    
    /* public class FileData 
        {
            @AuraEnabled
            public string Content{get;set;}
            @AuraEnabled
            public string ContentType{get;set;}
            @AuraEnabled
            public string FileUrl{get;set;}
            @AuraEnabled
            public string DownloadUrl{get;set;}
            @AuraEnabled
            public string Name{get;set;}
            @AuraEnabled
            public string Id{get;set;}
            @AuraEnabled
            public string Base64Link{get;set;}
            @AuraEnabled
            public string FileType{get;set;}
            
        }*/
}