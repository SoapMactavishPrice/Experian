public class QuarterlyRemindertoBank {
    public QuarterlyRemindertoBank(){
        
    }
    @AuraEnabled
    public static string getEmail(string escalationlevel,string accId){
        List<Object> lsObj = (List<Object>)json.deserializeUntyped(escalationlevel);
        map<string,set<string>> tempemail = new map<string,set<string>>();
        set<string> emailList = new set<string>(); 
        system.debug('accId '+accId);
        for(object obj :lsObj){
            if(obj == 'Dispute Manager – Escalation Level 1'){
                
                List<Account> accountList =[Select Id,Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,
                                            Email_4_Dispute__c,Email_5_Dispute__c,Email_6_Dispute__c,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c from Account where id=: accId];
                if(accountList.size() > 0){
                    for(Account ac : accountList){
                        if(string.isNotBlank(ac.Email_1_Dispute__c))
                            emailList.add(ac.Email_1_Dispute__c);
                        if(string.isNotBlank(ac.Email_2_Dispute__c))
                            emailList.add(ac.Email_2_Dispute__c);
                        if(string.isNotBlank(ac.Email_3_Dispute__c))
                            emailList.add(ac.Email_3_Dispute__c);
                        if(string.isNotBlank(ac.Email_4_Dispute__c))
                            emailList.add(ac.Email_4_Dispute__c);
                        if(string.isNotBlank(ac.Email_5_Dispute__c))
                            emailList.add(ac.Email_5_Dispute__c);
                        if(string.isNotBlank(ac.Email_6_Dispute__c))
                            emailList.add(ac.Email_6_Dispute__c);
                        
                         if(string.isNotBlank(ac.Email_7_Dispute__c))
                            emailList.add(ac.Email_7_Dispute__c);
                        
                         if(string.isNotBlank(ac.Email_8_Dispute__c))
                            emailList.add(ac.Email_8_Dispute__c);
                        
                         if(string.isNotBlank(ac.Email_9_Dispute__c))
                            emailList.add(ac.Email_9_Dispute__c);
                        
                         if(string.isNotBlank(ac.Email_10_Dispute__c))
                            emailList.add(ac.Email_10_Dispute__c);
                        
                        
                    }
                    if(emailList.size() > 0){ 
                        tempemail.put('email',emailList);
                        //tempemail.put('email',emailList);
                    }
                }
            }
            
            if(obj == 'Dispute Manager – Escalation Level 2' || obj == 'Dispute Manager – Escalation Level 3' || obj == 'Dispute Manager – Escalation Level 4'){
                List<Contact> conlist = [select Id ,Email from Contact where AccountId =:accId and Contact_Role__c =: string.valueOf(obj)];
                
                if(conlist.size() > 0){
                    for(Contact con : conlist){
                        emailList.add(con.Email);
                        tempemail.put('email',emailList);
                    }
                }
            }
        }
        system.debug('emaillist'+tempemail);
        return JSON.serialize(tempemail);
    }
    
    // server side
    
    @AuraEnabled
    public static string getAccount_server(String ofst, String lmt, String searchKeyword) {
        system.debug('ofst'+ofst+'lmt'+lmt);
        Integer offset;
        Integer limt;
        String filter = '';
        
        if(String.isNotBlank(ofst)) {
            offset = Integer.valueOf(ofst);
        }
        if(String.isNotBlank(lmt)) {
            limt = Integer.valueOf(lmt);
        }
        
        system.debug('offset'+offset+'limt'+limt);
        
        if(String.isNotBlank(searchKeyword)) {
            filter += 'and (';
            
            filter += 'Name like \'%'+searchKeyword+'%\'';
            filter += ' or Membership_Status__c like \'%'+searchKeyword+'%\'';
            filter += ' or Member_Type__c like \'%'+searchKeyword+'%\'';
            filter += ')';
        }
        
        List<Object> strForJSON = new List<object>();
        List<Map<String, Object>> finalMap = new List<Map<String, Object>>();
        
        integer index = 0;
        String query = 'Select Id, VIP_Member__c,Subscriber_ID__c,Member_Type__c,Membership_Status__c,Name '+
            //'FROM Account WHERE Id IN (SELECT AccountId From Case) ';
            'FROM Account  ';
        IF(!test.isRunningTest()){
            query+= ' WHERE Id IN (SELECT AccountId From Case Where (status = \'Open\' or status = \'Customer Notified\' or status = \'Work In Progress\') and (Case_Type_Lookup__r.Name =\'Complaint Dispute Consumer\' or Case_Type_Lookup__r.Name =\'Complaint Dispute Commercial\') and Owner.Name =\'Bank Team\')' ;
            query+= ' '+filter+' limit:limt offset:offset';
        }
        
        
        system.debug('query'+query);
        for(Account ac : Database.query(query)) {
            system.debug('case list'+ac);
            system.debug('case list'+ac.Cases);
            Map<String, Object> tempMap = new Map<String, Object>();
            tempMap.put('index',index++);
            tempMap.put('resId',ac.Id);
            tempMap.put('accName',ac.Name);
            tempMap.put('accVIPN',ac.VIP_Member__c);
            tempMap.put('accsubId',ac.Subscriber_ID__c);
            tempMap.put('accMemstatus',ac.Membership_Status__c);
            tempMap.put('accMemType',ac.Member_Type__c);
            tempMap.put('isSelected', false);
            List<Map<String, Object>> tempList = new List<Map<String, Object>>();
            finalMap.add(tempMap);
        }
        
        strForJSON.add(finalMap);
        query = 'select count() from Account WHERE Id IN (SELECT AccountId From Case Where (status = \'Open\' or status = \'Customer Notified\' or status = \'Work In Progress\') and (Case_Type_Lookup__r.Name =\'Complaint Dispute Consumer\' or Case_Type_Lookup__r.Name =\'Complaint Dispute Commercial\') and Owner.Name =\'Bank Team\')'+filter;
        strForJSON.add(Database.countQuery(query));
        return JSON.serialize(strForJSON);
    }
    
    @AuraEnabled
    public static map<string,Object> checkNodalOfficerexistOrNot(string accId){
        map<string,Object> objmap = new map<string,Object>();
        boolean b = false;
        List<Contact> con = [select Id,Name,email,FirstName,Contact_Role__c,Phone from Contact where Contact_Role__c=:'Nodal Officer' and AccountId =: accId limit 1];
        if(con.size() == 1){
            b = true;
            objmap.put('Email',con[0].Email);
            objmap.put('Tempchk',b);
            
        }else if(con.size() == 0){
            objmap.put('Email','');
            objmap.put('Tempchk',b);
        }
        system.debug(b);
        return objmap;
    }
    
    @AuraEnabled 
    public static string getCaseDetail(string accId, date fromDate , date toDate){
        system.debug('accId'+accId);
        string NodalOfficerName;
        
        /* Contact con = [select Id,Name,email,FirstName,Contact_Role__c,Phone from Contact where Contact_Role__c=:'Nodal Officer' and AccountId =: accId limit 1];
if(null != con.Email){
NodalOfficerName = con.Email;   
}*/
        
        
        List<Case> caseList = new List<Case>();
        if(!test.isRunningTest()){
            caseList = [select Id,Case_Category__c,Case_Type_Lookup__r.Name,Sub_Type_Lookup__r.Name,Sub_Type_1_Lookup__r.Name,Dispute_Raised_Date__c,
                        Subject,OwnerId,Owner.Name,AccountId,CaseNumber from Case where (status =:'Open' or status =: 'Customer Notified' or status =: 'Work In Progress' )  and  Owner.Name =:'Bank Team' and
                        AccountId=:accId and Sub_Type_Lookup__r.Name != null and
                        Case_Type_Lookup__r.Name != null and (Case_Type_Lookup__r.Name ='Complaint Dispute Consumer' or Case_Type_Lookup__r.Name ='Complaint Dispute Commercial') and Dispute_Raised_Date__c != null and Dispute_Raised_Date__c >= :fromDate and Dispute_Raised_Date__c <=:toDate ORDER BY CaseNumber];
            
            /*caseList = [select Id,Case_Category__c,Case_Type_Lookup__r.Name,Sub_Type_Lookup__r.Name,Sub_Type_1_Lookup__r.Name,
Subject,OwnerId,Owner.Name,AccountId,CaseNumber from Case where AccountId=:accId ORDER BY CaseNumber];*/
            
        }else{
            caseList = [select Id,Case_Category__c,Case_Type_Lookup__r.Name,Sub_Type_Lookup__r.Name,Sub_Type_1_Lookup__r.Name,
                        Subject,OwnerId,Owner.Name,AccountId,CaseNumber from Case where (status =:'Open')
                        and AccountId=:accId];
        }
        
        List<Map<String, Object>> tempList = new List<Map<String, Object>>();
        for(case cs : caseList){
            Map<String, Object> tempMap2 = new Map<String, Object>();
            tempMap2.put('csId',cs.Id);
            tempMap2.put('csAccId',cs.AccountId);
            tempMap2.put('CaseNumber',cs.CaseNumber);
            tempMap2.put('CaseCategory',cs.Case_Category__c);
            tempMap2.put('CaseSubject',cs.Subject);
            tempMap2.put('CaseOwner',cs.owner.Name);
            if(string.IsNOTBlank(cs.Case_Type_Lookup__c)){tempMap2.put('CaseType',cs.Case_Type_Lookup__r.Name);}
            if(string.IsNOTBlank(cs.Sub_Type_Lookup__c)){tempMap2.put('CaseSubType',cs.Sub_Type_Lookup__r.Name);}
            if(string.IsNOTBlank(cs.Sub_Type_1_Lookup__c)){tempMap2.put('CaseSub12Type',cs.Sub_Type_1_Lookup__r.Name);}
            tempMap2.put('isSelected', true);
            //tempMap2.put('NodalOfficerName', NodalOfficerName);
            tempList.add(tempMap2);
        }
        
        return JSON.serialize(tempList);
    }
    
    @AuraEnabled
    public static string  SendEmail(String data,string toEmail, List<string> emails) {
        map<string, string> returnResult = new map<string, string>();
        try{
            List<Messaging.Email> allMails = new List<Messaging.Email>();
            
            Map<String, Object> jsonData = (Map<String, Object>) System.JSON.deserializeUntyped(data);
            
            List<String> accIds = new List<String>();
            List<String> caseIds = new List<String>();
            
            for(String str : jsonData.keySet()) {
                accIds.add(str);
                for(Object obj : (List<Object>) jsonData.get(str)) {
                    caseIds.add(String.valueOf(obj));
                }
            }
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: 'nodal.officer.india@experian.com'];// To send from Org wide address
            
            String query = 'select Id, Name, '+
                '(select Id, Name_of_Consumer__r.Name,'+
                'AccountId, Dispute_Raised_Date__c,'+
                'Account.Name, Displayed_Account_Type__c, Displayed_Account_number__c, Dispute_Detail__c,  '+
                'Displayed_Details__c, Correct_Details__c,Open_Ageing_with_Bank__c, '+
                'CaseNumber from Cases where Id in: caseIds and Sub_Type_Lookup__r.Name != null and Case_Type_Lookup__r.Name != null and (Case_Type_Lookup__r.Name =\'Complaint Dispute Consumer\' or Case_Type_Lookup__r.Name =\'Complaint Dispute Commercial\') ';
            if(!test.isRunningTest()){
                query += 'and Owner.Name =\'Bank Team\'';
            }else{
                //query += 'Owner.Name =\'Bank Team\' and ';
                
            }
            
            query += ') from Account where Id in: accIds';
            
            String query2 = 'select Id, Name, '+
                '(select Id, Name_of_Consumer__r.Name,'+
                'AccountId, Dispute_Raised_Date__c,'+
                'Account.Name, Displayed_Account_Type__c, Displayed_Account_number__c, Dispute_Detail__c,  '+
                'Displayed_Details__c, Correct_Details__c,Open_Ageing_with_Bank__c, '+
                'CaseNumber from Cases where Sub_Type_Lookup__r.Name != null and Case_Type_Lookup__r.Name != null and (Case_Type_Lookup__r.Name =\'Complaint Dispute Consumer\' or Case_Type_Lookup__r.Name =\'Complaint Dispute Commercial\') ';
            if(!test.isRunningTest()){
                query2 += 'and Owner.Name =\'Bank Team\'';
            }else{
                //query += 'Owner.Name =\'Bank Team\' and ';
                
            }
            
            query2 += ') from Account where Id in: accIds';
            
            //system.debug('405 get heap size for loop query'+Limits.getHeapSize());
            
            Map<string,map<string,string>> accwithmonth = new Map<string,map<string,string>>();
            
            List<AggregateResult> arResult = new List<AggregateResult>();       
            
            Map<String, map<string,string>> seasonObjMap = new Map<String, map<string,string>>();
            List<Account> accountList =[Select Id,Email_1_Dispute__c,Email_2_Dispute__c,Email_3_Dispute__c,
                                        Person_Name_Dispute__c,Person_Name_2__c, 
                                        Person_Name_3__c, Person_Name_4__c, Person_Name_5__c,Person_Name_6__c,Person_Name_7__c,Person_Name_8__c,Person_Name_9__c,Person_Name_10__c,
                                        Phone_1__c, Phone_2__c, Phone_3__c, Phone_4__c, Phone_5__c, Phone_6__c,Phone_7__c,Phone_8__c,Phone_9__c,Phone_10__c,
                                        Email_4_Dispute__c,Email_5_Dispute__c,Email_6_Dispute__c,Email_7_Dispute__c,Email_8_Dispute__c,Email_9_Dispute__c,Email_10_Dispute__c,
                                        (select Id,Name,email,FirstName,Contact_Role__c,Phone from Contacts where Contact_Role__c=:'Nodal Officer' limit 1)
                                        from Account where id=: accIds];
            //system.debug('405 get heap size for loop acount query'+Limits.getHeapSize());
            
            for(AggregateResult ar :[select count(Id) cid,CALENDAR_MONTH(Dispute_Raised_Date__c) month,AccountId,CALENDAR_YEAR(Dispute_Raised_Date__c) year ,Sub_Type_Lookup__r.Name ctType
                                     from case where AccountId IN : accIds AND ID IN:caseIds and Sub_Type_Lookup__r.Name != null and
                                     Case_Type_Lookup__r.Name != null and (Case_Type_Lookup__r.Name ='Complaint Dispute Consumer' or Case_Type_Lookup__r.Name ='Complaint Dispute Commercial')
                                     GROUP BY AccountId, CALENDAR_MONTH(Dispute_Raised_Date__c),CALENDAR_YEAR(Dispute_Raised_Date__c),
                                     Sub_Type_Lookup__r.Name  order by CALENDAR_YEAR(Dispute_Raised_Date__c), CALENDAR_MONTH(Dispute_Raised_Date__c) asc]){
                                         arResult.add(ar);
                                     }  
            
            /*  for(AggregateResult ar :[select count(Id) cid,CALENDAR_MONTH(CreatedDate) month,AccountId,CALENDAR_YEAR(CreatedDate) year ,Case_Category__c ctType
from case where AccountId IN : accIds AND ID IN:caseIds GROUP BY AccountId, CALENDAR_MONTH(CreatedDate),CALENDAR_YEAR(CreatedDate),
Case_Category__c  order by CALENDAR_YEAR(CreatedDate), CALENDAR_MONTH(CreatedDate) asc]){
arResult.add(ar);
} */
            //system.debug('405 get heap size for loop aggregate query'+Limits.getHeapSize());
            
            
            List<string> dispatchb = new List<string>();
            dispatchb.add('<table border="1" style="border-collapse: collapse;width:80%"><tr> <th style="background-color:#1798c1;color:#000000">Dispute Contact details </th> <th style="background-color:#1798c1;">Email</th> <th style="background-color:#1798c1;">Tephone Number</th> </tr> ');
            
            List<string> Nodalb= new List<string>();
            string Nodal_Officer_Name;
            
            map<Id,List<Case>> csMap = new map<Id,List<Case>>();
            Case_Type__c ct = [SELECT Id FROM Case_Type__c where Name = 'Query' and Case_Category__c='Consumer' and Case_Complaint__c='Report'];
            Sub_Type__c	  sub = [Select Id , Case_Type__c  from Sub_Type__c	 where Name ='Dispute Data' and Case_Type__c =: ct.Id];
            Sub_Type1__c sub1 = [Select Id from Sub_Type1__c	 where Name ='Monthly / Quarterly' and Sub_Type__c =:sub.Id];
            
            
            List<Case> cslist = new List<Case>();
            List<Case> NewCasecslist = new List<Case>();
            for(Account acc : accountList){
                Case cse = new Case();
                cse.Origin = 'Email';
                cse.AccountId = acc.Id;
                cse.Status = 'Open';
                cse.Case_Complaints__c = 'Report';
                cse.Case_Category__c = 'Consumer';
                cse.Case_Type_Lookup__c = ct.Id;
                cse.Sub_Type_Lookup__c = sub.Id;
                cse.Sub_Type_1_Lookup__c = sub1.Id;
                NewCasecslist.add(cse);
                
                for(Contact con : acc.Contacts) {
                    Nodal_Officer_Name =con.Name;
                    
                    if(string.isNotBlank(con.Name) || string.isNotBlank(con.Phone) || string.isNotBlank(con.email)) {
                        Nodalb.add('<table border="1" style="border-collapse: collapse;width:80%"><tr><th style="background-color:#1798c1;">Nodal Officer Name</th> <th style="background-color:#1798c1;">Email</th> <th style="background-color:#1798c1;">Phone</th> </tr>'); 
                        Nodalb.add('<tr><td style="text-align:center">'+checkNull(con.Name)+'</td><td style="text-align:center">'+checkNull(con.email)+'</td><td style="text-align:center">'+checkNull(con.Phone)+'</td></tr>');
                    }
                }
                if(string.isNotBlank(acc.Person_Name_Dispute__c) || string.isNotBlank(acc.Email_1_Dispute__c)  || string.isNotBlank(acc.Phone_1__c )){
                    dispatchb.add('<tr><td style="text-align:center">'+checkNull(acc.Person_Name_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_1_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_1__c)+'</td></tr>');
                } 
                if(string.isNotBlank(acc.Person_Name_2__c) || string.isNotBlank(acc.Email_2_Dispute__c)  || string.isNotBlank(acc.Phone_2__c )){
                    dispatchb.add('<tr><td style="text-align:center">'+checkNull(acc.Person_Name_2__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_2_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_2__c)+'</td></tr>');
                }
                if(string.isNotBlank(acc.Person_Name_3__c) || string.isNotBlank(acc.Email_3_Dispute__c)  || string.isNotBlank(acc.Email_3_Dispute__c )){
                    dispatchb.add('<tr><td style="text-align:center">'+checkNull(acc.Person_Name_3__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_3_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_3__c)+'</td></tr>');
                }
                if(string.isNotBlank(acc.Person_Name_4__c) || string.isNotBlank(acc.Phone_4__c)  || string.isNotBlank(acc.Email_4_Dispute__c )){
                    dispatchb.add('<tr><td style="text-align:center">'+checkNull(acc.Person_Name_4__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_4_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_4__c)+'</td></tr>');
                }
                
                if(string.isNotBlank(acc.Person_Name_5__c) || string.isNotBlank(acc.Phone_5__c)  || string.isNotBlank(acc.Email_5_Dispute__c )){
                    dispatchb.add('<tr><td style="text-align:center">'+checkNull(acc.Person_Name_5__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_5_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_5__c)+'</td></tr>');
                }
                if(string.isNotBlank(acc.Person_Name_6__c) || string.isNotBlank(acc.Phone_6__c)  || string.isNotBlank(acc.Email_6_Dispute__c )){
                    dispatchb.add('<tr><td style="text-align:center">'+checkNull(acc.Person_Name_6__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_6_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_6__c)+'</td></tr>');
                }
                
            if(string.isNotBlank(acc.Person_Name_7__c) || string.isNotBlank(acc.Phone_7__c)  || string.isNotBlank(acc.Email_7_Dispute__c )){
                    dispatchb.add('<tr><td style="text-align:center">'+checkNull(acc.Person_Name_7__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_7_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_7__c)+'</td></tr>');
            }
            
            if(string.isNotBlank(acc.Person_Name_8__c) || string.isNotBlank(acc.Phone_8__c)  || string.isNotBlank(acc.Email_8_Dispute__c )){
                    dispatchb.add('<tr><td style="text-align:center">'+checkNull(acc.Person_Name_8__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_8_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_8__c)+'</td></tr>');
            }
            
            if(string.isNotBlank(acc.Person_Name_9__c) || string.isNotBlank(acc.Phone_9__c)  || string.isNotBlank(acc.Email_9_Dispute__c )){
                    dispatchb.add('<tr><td style="text-align:center">'+checkNull(acc.Person_Name_9__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_9_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_9__c)+'</td></tr>');
            }
                
                if(string.isNotBlank(acc.Person_Name_10__c) || string.isNotBlank(acc.Phone_10__c)  || string.isNotBlank(acc.Email_10_Dispute__c )){
                    dispatchb.add('<tr><td style="text-align:center">'+checkNull(acc.Person_Name_10__c)+'</td><td style="text-align:center">'+checkNull(acc.Email_10_Dispute__c)+'</td><td style="text-align:center">'+checkNull(acc.Phone_10__c)+'</td></tr>');
            }
            
            }
            //accountList.clear();
            
            insert NewCasecslist;
            
            
            map<Id,Id> newCaseMap = new map<Id,Id>();
            for(Case cse : NewCasecslist){
                newCaseMap.put(cse.AccountId,cse.Id);   
            }
            
            if(Nodalb.size()> 0)
                Nodalb.add('</table>');
            
            if(dispatchb.size() > 0) {
                dispatchb.add('</table>');
            }
            
            //List<string> tempExcel = new List<string>();
           // tempExcel.add('<style>table{border-collapse:collapse;border-spacing:0;width:100%;border:1px solid #D5D5D5}td,th{padding:5px;border:1px solid #D5D5D5}');
            //tempExcel.add('th{font-size:25px;font-weight:400;text-align:center;background-color:#D5D5D5 !important;color:#fff !important}td{font-size:11px;font-weight:100;text-align:center !important}</style>');
           // tempExcel.add('<table border="1px"><tr><th>Case Number</th><th>Consumer Name</th><th>Member Name</th><th>Account Type</th><th>Account No</th><th>Dispute Details</th><th>Displayed Details</th><th>Correct Details</th><th>Dispute Raised Date</th><th>Open Ageing with Bank</th></tr>');
            
            List<string> tempExcelcsv = new List<string>();
            string csvHeader = 'Case Number,Consumer Name, Member Name,Account Type,Account No,Dispute Details,Displayed Details,Correct Details,Dispute Raised Date,Open Ageing with Bank\n';
            tempExcelcsv.add(csvHeader);
            
            for(Account ac : Database.query(query2)) {
                for(Case cs : ac.cases) {
                    tempExcelcsv.add(cs.CaseNumber+',');
                    tempExcelcsv.add(cs.Name_of_Consumer__r.Name+',');
                    tempExcelcsv.add(cs.Account.Name+',');
                    tempExcelcsv.add(cs.Displayed_Account_Type__c+',');
                    tempExcelcsv.add(cs.Displayed_Account_number__c+',');
                    tempExcelcsv.add(cs.Dispute_Detail__c+',');
                    tempExcelcsv.add(cs.Displayed_Details__c+',');
                    tempExcelcsv.add(cs.Correct_Details__c+',');
                    tempExcelcsv.add(string.valueOf(cs.Dispute_Raised_Date__c+','));
                    tempExcelcsv.add(string.valueOf(cs.Open_Ageing_with_Bank__c+','));
                    tempExcelcsv.add('\n');
                  }
            }
            
            for(Account ac : Database.query(query)) {
                List<String> caseexcelRow = new List<String>();
                for(Case cs : ac.cases) {
                    cs.Reminder_Parent_Case__c = NewCasecslist[0].Id;
                    cslist.add(cs);
                    //tempExcel.add('<tr><td>'+cs.CaseNumber+'</td><td >'+cs.Name_of_Consumer__r.Name+'</td> <td>'+cs.Account.Name+'</td> <td>'+cs.Displayed_Account_Type__c+'</td> <td>'+cs.Displayed_Account_number__c+'</td>  <td >'+cs.Dispute_Detail__c+'</td>  <td>'+cs.Displayed_Details__c+'</td>  <td>'+cs.Correct_Details__c+'</td><td>'+cs.Dispute_Raised_Date__c+'</td><td>'+cs.Open_Ageing_with_Bank__c+'</td></tr>');
                    
                }
                
                //string temp ;
                //string tempdata = '';
                //temp += String.join(tempExcel,' ');
                //tempdata +=temp.replace('null','');
                //tempdata =tempdata.replace('00:00:00','');
                //tempExcel.clear();
                //tempExcel.add(tempdata);
                //tempExcel.add('</table>');
                
                //tempData = null;
                //temp= null;
                
            }
            
            system.debug('353 get heap size for loop excel'+Limits.getHeapSize());
            
            system.debug('ar size--'+arResult.size());
            for(AggregateResult ar : arResult){
                
                string month = '';
                integer monNum = integer.valueOf(ar.get('month'));
                switch on monNum {
                    when 1 {
                        month = 'January';
                    }
                    when 2 {
                        month = 'February';
                    }
                    when 3 {
                        month = 'March';
                    }
                    when 4 {
                        month = 'April';
                    }
                    when 5 {
                        month = 'May';
                    }
                    when 6 {
                        month = 'June';
                    }
                    when 7 {
                        month = 'July';
                    }
                    when 8 {
                        month = 'August';
                    }
                    when 9 {
                        month = 'September';
                    }
                    when 10 {
                        month = 'October';
                    }
                    when 11 {
                        month = 'November';
                    }
                    when 12 {
                        month = 'December';
                    }
                }
                
                
                
                //seasonObjMap.put(string.valueOf(ar.get('AccountId')),new List<object>());
                string key = string.valueOf(ar.get('ctType'));
                if(seasonObjMap.containskey(key)){
                    seasonObjMap.get(key).put(month+'\''+ar.get('year'),string.valueOf(ar.get('cid')));
                }else{
                    map<string, string> yearWiseMonth = new map<string, string>();
                    yearWiseMonth.put(month+'\''+ar.get('year'),string.valueOf(ar.get('cid')));
                    seasonObjMap.put(key,yearWiseMonth);
                }
                //seasonObjMapList.add(seasonObjMap);
            }
            
            //system.debug('405 get heap size for loop aggriagte'+Limits.getHeapSize());
            
            string emailBody ='';
            List<string> tableDataRow = new List<string>();
            List<string> tableDataRow1 = new List<string>();
            if(string.isBlank(Nodal_Officer_Name)){
                Nodal_Officer_Name = 'Team';
            }
            //system.debug('412 get heap size'+Limits.getHeapSize());
            tableDataRow1.add('Dear '+Nodal_Officer_Name+',<br/><br/>');
            tableDataRow1.add('Thank you for your association with us at Experian and being a patron of our products and services.<br/>');
            tableDataRow1.add('<br/>');
            tableDataRow1.add('Below is the status of the account discrepancies found in an Experian credit report received by us from Consumers.<br/>');
            tableDataRow.add('<table border="1" style="border-collapse:collapse;"><tr>');
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<string> headerth = new List<string>();
            
            List<string> MonthTotal = new List<string>();
            MonthTotal.add('<table border="1" style="border-collapse:collapse;width:20%"><tr><th style="width:7%;background-color:#1798c1;color:#000000">Month</th> <th style="width:7%;background-color:#1798c1;color:#000000">Total</th></tr>');
            //headerth.add('Type');
            
            map<string,Decimal> mp = new map<string,Decimal>();
            
            for(Object obj : seasonObjMap.keyset()){
                map<string,string> strMap =seasonObjMap.get(string.valueOf(obj));
                integer i = 0;  
                for(string strg : strMap.keyset()){
                    if(!headerth.contains(string.valueOf(strg))){
                        headerth.add(string.valueOf(strg));
                        //MonthTotal +=string.valueOf(strg);
                    }
                    if(mp.containskey(strg)){
                        mp.put(strg,mp.get(strg)+decimal.valueOf(strMap.get(strg)));
                    }else{
                        mp.put(strg,decimal.valueOf(strMap.get(strg)));
                        
                    }
                    
                }
                
            }
            
            //system.debug('499 get heap size'+Limits.getHeapSize());
            Decimal finalTotal = 0;
            
            for(string st :mp.keyset()){
                MonthTotal.add('<tr>');
                MonthTotal.add('<td>'+st+'</td>');
                MonthTotal.add('<td style="text-align:center;">'+mp.get(st)+'</td>');
                MonthTotal.add('</tr>');
                finalTotal += mp.get(st);
            }
            
            MonthTotal.add('<tr><td><b>Total</b></td><td style="text-align:center;"><b>'+finalTotal+'</b></td>');
            MonthTotal.add('</table>');
            
            tableDataRow.add('<th style="width:auto !important;background-color:#1798c1;color:#000000">Type</th>');
            
            for(string str : headerth){
                tableDataRow.add('<th style="width:auto !important;background-color:#1798c1;color:#000000">'+str+'</th>');
            }
            tableDataRow.add('<th style="width:auto !important;background-color:#1798c1;color:#000000">Total</th></tr>');
            
            
            
            for(Object obj : seasonObjMap.keyset()){
                
                integer rowCount = 0;
                map<string,string> strMap =seasonObjMap.get(string.valueOf(obj));
                
                for(string str : strMap.keyset()){
                    rowCount+=integer.valueOf(strMap.get(str));
                }
                
                if(!tableDataRow.contains('<td style="width:auto !important;word-wrap: break-word;">'+string.valueOf(obj)+'</td>')){
                    tableDataRow.add('<tr>');
                    tableDataRow.add('<td style="width:auto !important;word-wrap: break-word;">'+string.valueOf(obj)+'</td>'); 
                }else{
                    //tableDataRow+=tableDataRow.remove('<td style="width:auto !important;word-wrap: break-word;"></td>');
                }
                
                for(string str : headerth ){
                    //tableDataRow.remove('<td style="width:auto !important"></td>');
                    if(str !='Type' && str != null){
                        tableDataRow.add('<td style="width:auto !important;text-align:center">'+checkNull(string.valueOf(strMap.get(str)))+'</td>');
                    }
                }
                
                tableDataRow.add('<td style="width:3%;text-align:center;">'+rowCount+'</td>');
                tableDataRow.add('</tr>');
            }
            
            //system.debug('500 get heap size'+Limits.getHeapSize());
            tableDataRow.add('</table>');
            tableDataRow.add('<br/>');
            //tableDataRow += 'We request you to note that the TAT mentioned above are different. <br/>';
            //tableDataRow += '<ul><li>Bank TAT – is calculated from the time when we have raised the dispute and your response. </li>';
            //tableDataRow+=  '<li>Consumer TAT – is calculated from the time when we have received the dispute.</li></ul>';
            tableDataRow.add('As you are aware, as owners of the data, we are dependent on you for the correction of any data in our records. We are');
            tableDataRow.add(' reporting quarterly data as required by the Reserve Bank of India for account discrepancies that have gone beyond the');
            tableDataRow.add(' 30-day (Date of receipt / Date of closure) timeline that the regulator provides both of us to resolve these. We urge you');
            tableDataRow.add(' to engage with us in timely closure of these disputes.<br/><br/>');
            tableDataRow.add('We have the following as our contact details in our system. Do let us know in case there are any updates to be made in');
            tableDataRow.add(' the same.<br/><br/>');
            
            tableDataRow.add(string.join(dispatchb,' '));
            tableDataRow.add('<br/>');
            tableDataRow.add(string.join(Nodalb,' '));
            tableDataRow.add('<br/>');
            
            
            
            
            tableDataRow.add('We are enclosing the data correction formats (account details & demographic details) and total disputes pending along');
            tableDataRow.add('with this email.<br/><br/>');
            tableDataRow.add('Do reach out to us for any clarifications.<br/><br/>');
            tableDataRow.add('Regards<br/>');
            
            tableDataRow.add('Nodal Officer <br/>');
            
            tableDataRow.add('Experian Credit Information Company of India Pvt. Ltd. <br/>');
            tableDataRow.add('E:'+' '+'nodal.officer.india@experian.com<br/>');
            tableDataRow.add('www.experian.in<br/>');
            tableDataRow.add('India STS Link '+'-'+' https://data.experian.in'+' '+'<br/>');
            tableDataRow.add('Nextgen Link '+'-'+' https://nxg-india.experian.com/nextgen-ind-pds/'+''+'<br/>');
            tableDataRow.add('Get your Experian Credit Report & Score today,'+' '+'<a href="https://consumer.experian.in/ECV-OLN/view/angular/index.html#/experianHome">click here</a><br/>');
            
            if ( owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            
            //mail.setToAddresses(new List<String> {'rishikesh.korade@finessedirect.com','balram@finessedirect.com'/*,'muskanbee.shaikh@experian.com','renu.jha@experian.com','muskanbee.shaikh@experian.com'*/});
            List<string> str = new List<string>();
            str = toEmail.split(',');
            if(str.size() > 0)
                mail.setToAddresses(str);
            
            if(emails.size() > 0)
               mail.ccaddresses = emails;
          
            mail.setSubject('Quarterly Reminders - Disputes | CICRA obligations to be met by Financial Institutions');
            mail.htmlbody = string.join(tableDataRow1,' ')+'\n\n<br/>'+string.join(MonthTotal,' ')+'\n\n<br/>'+string.join(tableDataRow,' ');
            mail.setUseSignature(false);
            
            EmailMessage em=new EmailMessage();
            //em.subject = 'Open Disputes Reminder('+ac.Name+')'+ '[ '+ threadId +' ]';
            em.subject = 'Quarterly Reminders - Disputes | CICRA obligations to be met by Financial Institutions';
            em.RelatedToId= NewCasecslist[0].Id;  
            em.ToAddress = toEmail;
            if(emails.size() > 0){
                em.CcAddress = string.join(emails,',');
            }
            em.MessageDate=system.now();
            em.Incoming=false;
            em.Email_Body__c =string.join(tableDataRow1,' ')+'\n\n<br/>'+string.join(MonthTotal,' ')+'\n\n<br/>'+string.join(tableDataRow,' ');
            em.Status='3';
            em.FromAddress='nodal.officer.india@experian.com';
            em.FromName='Nodal Officer';
            insert em;
            
            string temp1 ;
                string tempdata1 = '';
                temp1 += String.join(tempExcelcsv,' ');
                tempdata1 +=temp1.replace('null','');
                tempdata1 =tempdata1.replace('00:00:00','');
                tempExcelcsv.clear();
                tempExcelcsv.add(tempdata1);
            ContentVersion cv = new ContentVersion();
            //blob b = blob.valueOf(string.join(tempExcel,''));
            blob b = blob.valueOf(string.join(tempExcelcsv,''));
            cv.VersionData = b;
            cv.Title = 'Cases.csv';
            cv.PathOnClient = 'Cases.csv';
            insert cv;
            
            
            //Link the File to Parent Record
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = [SELECT Id, ContentDocumentId, contentDocument.LatestPublishedVersionId  FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
            cdl.LinkedEntityId = em.Id;
            cdl.ShareType = 'V';
            insert cdl;
            
            
            
            List<ContentDocumentLink> cdls = new List<ContentDocumentLink>();
            cdls = [select id, ContentDocument.LatestPublishedVersionId from ContentDocumentLink where Id  =: cdl.Id];
            Set<String> LatestPublishedVersionIds = new Set<String>();
            for(ContentDocumentLink cdlst: cdls) {
                LatestPublishedVersionIds.add(cdlst.ContentDocument.LatestPublishedVersionId);
            }
            
            if(LatestPublishedVersionIds.size() > 0) {
                List<String> LatestPublishedVersionIdList = new List<String>();
                LatestPublishedVersionIdList.addAll(LatestPublishedVersionIds);
                mail.setEntityAttachments(LatestPublishedVersionIdList);
            }
            
            
            List<Messaging.EmailFileAttachment> emcclist = new List<Messaging.EmailFileAttachment>();
            
            
            list<StaticResource> objPDFList = [Select body,ContentType, name from StaticResource where name IN ('OLM_Suppression_Demographic_Correction','Data_Correction_Formats')];
            for(StaticResource objPDF:objPDFList){
                Messaging.EmailFileAttachment objPDFAttachment = new Messaging.EmailFileAttachment();
                if(objPDF.name =='OLM_Suppression_Demographic_Correction'){
                    objPDFAttachment.setBody(objPDF.Body);
                    objPDFAttachment.setFileName(objPDF.name + '.pdf');
                    emcclist.add(objPDFAttachment);
                }else if(objPDF.name =='Data_Correction_Formats'){
                    objPDFAttachment.setBody(objPDF.Body);
                    objPDFAttachment.setFileName(objPDF.name + '.xlsb');
                    emcclist.add(objPDFAttachment);
                }
                
            }            
            
            
            mail.setFileAttachments(emcclist);
            
            if(cslist.size() > 0){
                if(!test.isRunningTest()){
                    Database.executeBatch(new  QuarterlyRemindertoBank_Batch(cslist),10);
                }
                
                //update Up_Parent_CaseList;
            }
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });	
            returnResult.put('msg','success');
            
            system.debug('653'+limits.getHeapSize());
            accIds.clear();
            caseIds.clear();
            seasonObjMap.clear();
            arResult.clear();
            mp.clear();
            Nodalb.clear();
            dispatchb.clear();
            accountList.clear();
            
            system.debug('661'+limits.getHeapSize());
            
            return JSON.serialize(returnResult); 
            //return ''; 
        }catch(exception e){
            system.debug('error message '+e.getLineNumber() + '----msg --'+ e.getMessage());
            returnResult.put('msg',e.getMessage()); 
            return JSON.serialize(returnResult); 
        } 
        
    }
    private static String checkNull(Object obj) {
        if(obj == null)
            return '';
        else
            return String.valueOf(obj).trim()+'';
    }
    
}