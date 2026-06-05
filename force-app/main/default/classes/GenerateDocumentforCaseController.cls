public class GenerateDocumentforCaseController {
    
    @AuraEnabled
    public static string getCasesWithEmailMessage2(string caseId){
        List<map<string,Object>> fs = new List<map<string,Object>>();
        
        map<string,Object> mplist = new map<string,Object>();
        case cs = [Select Id, CaseNumber, Status, Case_Category__c , Subject from Case where Id = :caseId];
        wrapperCls wrp = new wrapperCls();
        wrp.cId = cs.Id;
        wrp.subject = cs.Subject;
        wrp.caseNumber = cs.CaseNumber;
        wrp.Case_Category = cs.Case_Category__c;
        wrp.status = cs.status;
        
        List<EmailMessage>EmailMessage = [SELECT Id,Subject,Email_Body__c ,TextBody, FromName,CreatedDate,ToAddress,ParentId 
                                          FROM EmailMessage where ParentId=:cs.Id  order by  CreatedDate desc];            
        List<string> EmailMessageList = new List<string>();   
        system.debug('EmailMessage '+EmailMessage.size());
        
        
        List<childcls>childMapList = new List<childcls>();
        if(EmailMessage.size() > 0){
            for(EmailMessage emc :EmailMessage ){
                childcls chl = new childcls();
                if(emc.subject.contains('[')){
					chl.subject = emc.subject.substringBefore('[')+'<br/><br/>';
                }else{
                	chl.subject = emc.subject+'<br/><br/>';    
                }
                
                string str ='';
                if(string.isNotBlank(string.valueOf(emc.TextBody)) && string.isNotBlank(string.valueOf(emc.Email_Body__c))){
                    str=  emc.Email_Body__c;
                } else if(string.isNotBlank(string.valueOf(emc.TextBody)) && string.isBlank(string.valueOf(emc.Email_Body__c))){
                    str=  emc.TextBody;
                }else if(string.isBlank(string.valueOf(emc.TextBody)) && string.isNotBlank(string.valueOf(emc.Email_Body__c))){
                    str=  string.valueOf(emc.Email_Body__c);
                }
                  
                chl.body = str+'<br/>';
                chl.fromName = emc.FromName+'<br/>';
                chl.to = emc.ToAddress+'<br/>';
                DateTime myDate = emc.CreatedDate;
                String ansDate = myDate.format('MM/dd/YYYY hh:mm a');
                chl.sendTime = ansDate+'<br/>';
                childMapList.add(chl);
            }
        }
        
        
        wrp.childList =childMapList;
        system.debug('--->'+json.serialize(wrp));
        return json.serialize(wrp);
    }
    
    public class wrapperCls{
        public string cId;
        public string caseNumber;
        public string subject;
        public string Status;
        public string Case_Category;
        public List<childcls> childList;
    }
    public class childcls{
        public string subject;
        public string fromName;
        public string to;
        public string sendTime;
        public string body;
    }
    
}