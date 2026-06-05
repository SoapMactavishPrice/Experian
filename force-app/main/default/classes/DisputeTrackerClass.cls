public class DisputeTrackerClass {
    
    public DisputeTrackerClass(){
    }
    
    @future (callout=true)
    public static void UpdateDates(Set<Id> ids,string oldMap){
       
            System.debug('ids '+ids);
            system.debug('jeson '+oldMap);
            Map<Id,Case> caseMap = (Map<Id,Case>) json.deserialize(oldMap,map<id, Case>.class);
            
            List<Case>caseList =new List<Case>(); 
            caseList.addAll(caseMap.values());
            
            string caseOldOwnerId_old = '';
            for(Case cese : caseList){
                caseOldOwnerId_old = cese.OwnerId;
            }
            
            List<Case > caseListToInsert  = new List<Case >();
            List<Case > caseListToInsert2 = new List<Case >();
            List<Case > caseListToInsert3 = new List<Case >();
            List<Case > caseListToInsert4 = new List<Case >();
            List<Case > caseListToInsert5 = new List<Case >();
            List<Case > caseListToInsert6 = new List<Case >();
            List<Case > caseListToInsert7 = new List<Case >();
            List<Case > caseListToInsert8 = new List<Case >();
            List<Case > caseListToInsert9 = new List<Case >();
            List<Case > caseListToInsert0 = new List<Case >();
            
            List<Case > caseListToInsert01 = new List<Case >();
            List<Case > caseListToInsert02 = new List<Case >();
            
            Map<Id, Case> newCaseMap = new Map<Id, Case>();
            
            for ( Case ca : [ SELECT Id,Forward_to_bank__c,Forward_to_Score_Team__c,Forward_to_OLM__c,
                             /* Forward_to_OLM_Date__c,*/
                             Forward_to_Data_Merger__c,
                             Forward_to_Data_Submission__c,Forward_to_GPD_Team__c,Forward_to_NG_Team__c,Forward_to_ECV_Team__c,
                             Forward_to_Bank_Sent_Date_1__c ,Forward_to_Bank_Changed_Date_1__c ,Forward_to_Score_Team_Sent_Date_1__c,
                             Forward_to_OLM_Sent_Date_1__c,Forward_to_Data_Merger_Sent_Date_1__c,Forward_to_Data_Submission_Sent_Date_1__c,
                             Forward_to_GPD_Team_Sent_Date_1__c,Forward_to_NG_Team_Sent_Date_1__c,Forward_to_ECV_Team_Sent_Date_1__c,
                             Forward_to_Score_Team_Changed_Date_1__c,Forward_to_OLM_Changed_Date_1__c,Forward_to_GPD_Team_Changed_Date_1__c,
                             Forward_to_Data_Merger_Changed_Date_1__c,Forward_to_Data_Sub_Changed_Date_1__c,Forward_to_ECV_Team_Changed_Date_1__c,
                             Forward_to_NG_Team_Changed_Date_1__c,Forward_to_Bank_Sent_Date_2__c,Forward_to_Score_Team_Sent_Date_2__c,
                             Forward_to_OLM_Sent_Date2__c,Forward_to_Data_Merger_Sent_Date_2__c,Forward_to_Data_Submission_Sent_Date_2__c,
                             Forward_to_GPD_Team_Sent_Date_2__c,Forward_to_NG_Team_Sent_Date_2__c,Forward_to_ECV_Team_Sent_Date_2__c,
                             Forward_to_Bank_Changed_Date_2__c,Forward_to_Score_Team_Changed_Date_2__c,Forward_to_OLM_Changed_Date_2__c,
                             Forward_to_Data_Merger_Changed_Date_2__c,Forward_to_Data_Sub_Changed_Date_2__c,Forward_to_GPD_Team_Changed_Date_2__c,
                             Forward_to_NG_Team_Changed_Date_2__c,Forward_to_ECV_Team_Changed_Date_2__c,Forward_to_Bank_Sent_Date_3__c,
                             Forward_to_Score_Team_Sent_Date_3__c,Forward_to_OLM_Sent_Date_3__c,Forward_to_Data_Merger_Sent_Date_3__c,
                             Forward_to_Data_Submission_Sent_Date_3__c, Forward_to_GPD_Team_Sent_Date_3__c,Forward_to_NG_Team_Sent_Date_3__c,
                             Forward_to_ECV_Team_Sent_Date_3__c,Forward_to_Bank_Changed_Date_3__c,Forward_to_Score_Team_Changed_Date_3__c,
                             Forward_to_OLM_Changed_Date_3__c,Forward_to_Data_Merger_Changed_Date_3__c,Forward_to_Data_Sub_Changed_Date_3__c,
                             Forward_to_GPD_Team_Changed_Date_3__c,Forward_to_NG_Team_Changed_Date_3__c,Forward_to_ECV_Team_Changed_Date_3__c,
                             Case_Category__c,Forward_to_CST_Changed_Date_1__c,Forward_to_CST_Changed_Date_2__c	,Forward_to_CST_Changed_Date_3__c,
                             Forward_to_CST_Team_Sent_Date_1__c,Forward_to_CST_Team_Sent_Date_2__c,Forward_to_CST_Team_Sent_Date_3__c,Forward_to_CST_Team__c,	
                             OwnerId,Manual_Entry_Bank_Date__c,
                             
                             Forward_to_Bank_Changed_Date_4__c,Forward_to_Bank_Changed_Date_5__c,Forward_to_Bank_Sent_Date_5__c,Forward_to_Bank_Sent_Date_4__c,Last_Reply_from_Bank_Team__c,
                             Forward_to_OLM_Changed_Date_4__c,Forward_to_OLM_Changed_Date_5__c,Forward_to_OLM_Sent_Date_4__c,Forward_to_OLM_Sent_Date_5__c ,Last_Reply_from_OLM_Team__c	,
                             Last_Reply_from_Data_Submission__c	,Forward_to_Data_Sub_Changed_Date_4__c,Forward_to_Data_Sub_Changed_Date_5__c,Forward_to_Data_Submission_Sent_Date_4__c,Forward_to_Data_Submission_Sent_Date_5__c,
                             
                             Forward_to_ECV_TeamDate__c,Forward_to_Bank_Date__c,Forward_to_CST_TeamDate__c,Forward_to_GPD_TeamDate__c,Forward_to_NG_Team_Date__c,
                             Forward_to_Data_SubmissionDate__c,Forward_to_Data_MergerDate__c,Forward_to_Score_Team_Date__c	,Forward_to_OLMDate__c	,
                             
                             Last_Reply_from_EVC_Team__c,Last_Reply_from_Score_Team__c,Last_Reply_from_GPD_Team__c,Last_Reply_from_Data_Merger__c,Last_Reply_from_NG_Team__c,Last_Reply_from_CST_Team__c,
                             (SELECT Id,OldValue,CaseId, NewValue, Field, CreatedDate FROM Histories where Field='Owner' and DataType = 'Text'
                              order by CreatedDate desc limit 1)FROM Case where Id IN: ids FOR UPDATE]) 
            {
                system.debug('Histories---------'+ca.Histories);
                List<CaseHistory1>csList=new list<CaseHistory1>();
                if(Test.isRunningTest())
                {
                    csList.add(new CaseHistory1('Bank Team','Score Team','',''));
                    csList.add(new CaseHistory1('Score Team','GPD Team','',''));
                    csList.add(new CaseHistory1('GPD Team','ECV Team','',''));
                    csList.add(new CaseHistory1('Data Merger Team','ECV Team','',''));
                    csList.add(new CaseHistory1('ECV Team','Data Merger Team','',''));
                    csList.add(new CaseHistory1('ECV Team','Data Ops Team','',''));
                    csList.add(new CaseHistory1('Data Ops Team','NG Team','',''));
                    csList.add(new CaseHistory1('NG Team','Data Submission Team','',''));
                    csList.add(new CaseHistory1('OLM Team','OLM Team','','')); 
                    csList.add(new CaseHistory1('Data Submission Team','Data Ops','',''));
                    csList.add(new CaseHistory1('Data Merger Team','OLM Team','',''));
                    csList.add(new CaseHistory1('ECV Team','Bank Team','',''));
                    csList.add(new CaseHistory1('Data Ops Team','ECV Team','',''));
                    csList.add(new CaseHistory1('Consumer Support Queue','ECV Team','',''));
                    csList.add(new CaseHistory1('ECV Team','Consumer Support Queue','',''));
                    
                  
                }
                if(!Test.isRunningTest())
                {
                    for(CaseHistory c:ca.Histories)
                    {
                        csList.add(new CaseHistory1((String)c.OldValue,(String)c.NewValue,c.CaseId,c.Field));
                        System.debug(c.CaseId + ' -> ' + c);
                    }
                    
                }
                
                
                for(CaseHistory1 cs: csList ){
                    
                    system.debug('OldValue---------'+cs.OldValue);
                    system.debug('NewValue---------'+cs.NewValue);
                    String old = String.valueOf(cs.oldValue);
                    String newVal = String.valueOf(cs.newValue);
                    String field = String.valueOf(cs.field);
                    system.debug(' ##### The value on ' + field + ' has been changed from ' + old + ' to ' + newVal);
                    
                    //1st New Value
                    if(ca.Forward_to_bank__c ==true        	   && (ca.Forward_to_Bank_Sent_Date_1__c == null || ca.Forward_to_Bank_Date__c == null)) {
                        System.debug('test 001');
                        Case cse = new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Bank_Sent_Date_1__c = System.today();
                        cse.Forward_to_Bank_Date__c = System.today();
                        newCaseMap.put(cse.Id, cse);
                        // caseListToInsert.add(cse);
                    }
                    else if(cs.NewValue =='Bank Team'  		&& caseOldOwnerId_old != ca.OwnerId	   && ca.Forward_to_Bank_Sent_Date_1__c  !=null  		  && ca.Forward_to_Bank_Sent_Date_2__c ==null ) {
                        system.debug('test 002');
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Bank_Sent_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        // caseListToInsert.add(cse);
                    } else if(cs.NewValue =='Bank Team'  	&& caseOldOwnerId_old != ca.OwnerId		   && ca.Forward_to_Bank_Sent_Date_2__c  !=null           && ca.Forward_to_Bank_Sent_Date_3__c ==null) {
                        system.debug('test ');
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Bank_Sent_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        // caseListToInsert.add(cse);
                    } else if(cs.NewValue =='Bank Team'         && caseOldOwnerId_old != ca.OwnerId      && ca.Forward_to_Bank_Sent_Date_3__c  !=null 		  && ca.Forward_to_Bank_Sent_Date_4__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Bank_Sent_Date_4__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        // caseListToInsert.add(cse);
                    } else if(cs.NewValue =='Bank Team'         && caseOldOwnerId_old != ca.OwnerId      && ca.Forward_to_Bank_Sent_Date_4__c  !=null 		  && ca.Forward_to_Bank_Sent_Date_5__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Bank_Sent_Date_5__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        // caseListToInsert.add(cse);
                    } 
                    
                    if(ca.Forward_to_Score_Team__c == true     && (ca.Forward_to_Score_Team_Sent_Date_1__c == null || ca.Forward_to_Score_Team_Date__c == null)) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Score_Team_Sent_Date_1__c = System.today();
                        cse.Forward_to_Score_Team_Date__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.NewValue =='Score Team'    && caseOldOwnerId_old != ca.OwnerId          && ca.Forward_to_Score_Team_Sent_Date_1__c !=null      && ca.Forward_to_Score_Team_Sent_Date_2__c ==null ) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Score_Team_Sent_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        
                    } else if(cs.NewValue =='Score Team'     && caseOldOwnerId_old != ca.OwnerId         && ca.Forward_to_Score_Team_Sent_Date_2__c !=null      && ca.Forward_to_Score_Team_Sent_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Score_Team_Sent_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        
                    }
                    System.debug(ca.Forward_to_OLMDate__c	);
                    System.debug(ca.Forward_to_OLM_Sent_Date_1__c);
                    if(ca.Forward_to_OLM__c   ==true           && (ca.Forward_to_OLM_Sent_Date_1__c == null || ca.Forward_to_OLMDate__c	 == null)) {
                        system.debug('Inside IF 1');
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_OLM_Sent_Date_1__c = System.today();
                        cse.Forward_to_OLMDate__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        
                    }else if(cs.NewValue =='OLM Team'     && caseOldOwnerId_old != ca.OwnerId           && ca.Forward_to_OLM_Sent_Date_1__c   !=null           && ca.Forward_to_OLM_Sent_Date2__c ==null ) {
                        system.debug('Inside Else 2');
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_OLM_Sent_Date2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.NewValue =='OLM Team'        && caseOldOwnerId_old != ca.OwnerId        && ca.Forward_to_OLM_Sent_Date2__c    !=null   		  && ca.Forward_to_OLM_Sent_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_OLM_Sent_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        
                    }else if(cs.NewValue =='OLM Team'        && caseOldOwnerId_old != ca.OwnerId        && ca.Forward_to_OLM_Sent_Date_3__c    !=null   		  && ca.Forward_to_OLM_Sent_Date_4__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_OLM_Sent_Date_4__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.NewValue =='OLM Team'        && caseOldOwnerId_old != ca.OwnerId        && ca.Forward_to_OLM_Sent_Date_4__c    !=null   		  && ca.Forward_to_OLM_Sent_Date_5__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_OLM_Sent_Date_5__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(ca.Forward_to_Data_Merger__c ==true 	   && (ca.Forward_to_Data_Merger_Sent_Date_1__c ==null || ca.Forward_to_Data_MergerDate__c == null)) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Merger_Sent_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        cse.Forward_to_Data_MergerDate__c = system.today();
                        newCaseMap.put(cse.Id, cse);
                        
                    }else if(cs.NewValue =='Data Merger Team'  && caseOldOwnerId_old != ca.OwnerId       && ca.Forward_to_Data_Merger_Sent_Date_1__c   !=null   && ca.Forward_to_Data_Merger_Sent_Date_2__c ==null ) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Merger_Sent_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.NewValue =='Data Merger Team'  && caseOldOwnerId_old != ca.OwnerId      && ca.Forward_to_Data_Merger_Sent_Date_2__c   !=null   && ca.Forward_to_Data_Merger_Sent_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Merger_Sent_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } 
                    
                    if(ca.Forward_to_Data_Submission__c ==true && ( ca.Forward_to_Data_Submission_Sent_Date_1__c ==null || ca.Forward_to_Data_SubmissionDate__c == null)) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Submission_Sent_Date_1__c = system.today();
                        cse.Forward_to_Data_SubmissionDate__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.NewValue =='Data Submission Team' && caseOldOwnerId_old != ca.OwnerId  && ca.Forward_to_Data_Submission_Sent_Date_1__c !=null && ca.Forward_to_Data_Submission_Sent_Date_2__c ==null ) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Submission_Sent_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }else if(cs.NewValue =='Data Submission Team'   && caseOldOwnerId_old != ca.OwnerId  && ca.Forward_to_Data_Submission_Sent_Date_2__c !=null && ca.Forward_to_Data_Submission_Sent_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Submission_Sent_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        
                    } else if(cs.NewValue =='Data Submission Team'   && caseOldOwnerId_old != ca.OwnerId  && ca.Forward_to_Data_Submission_Sent_Date_3__c !=null && ca.Forward_to_Data_Submission_Sent_Date_4__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Submission_Sent_Date_4__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        
                    } else if(cs.NewValue =='Data Submission Team'   && caseOldOwnerId_old != ca.OwnerId  && ca.Forward_to_Data_Submission_Sent_Date_4__c !=null && ca.Forward_to_Data_Submission_Sent_Date_5__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Submission_Sent_Date_5__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(ca.Forward_to_GPD_Team__c   ==true      && (ca.Forward_to_GPD_Team_Sent_Date_1__c ==null || ca.Forward_to_GPD_TeamDate__c == null)) {
                        system.debug('inside gpd 1 nd');
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_GPD_Team_Sent_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        cse.Forward_to_GPD_TeamDate__c = system.today();
                        newCaseMap.put(cse.Id, cse);
                        
                    } else  if(cs.NewValue =='GPD Team'        && caseOldOwnerId_old != ca.OwnerId        && ca.Forward_to_GPD_Team_Sent_Date_1__c   !=null      && ca.Forward_to_GPD_Team_Sent_Date_2__c ==null ) {
                        system.debug('inside gpd 2 nd');
                        
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_GPD_Team_Sent_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        
                    } else if(cs.NewValue =='GPD Team'      && caseOldOwnerId_old != ca.OwnerId          && ca.Forward_to_GPD_Team_Sent_Date_2__c   !=null      && ca.Forward_to_GPD_Team_Sent_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_GPD_Team_Sent_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(ca.Forward_to_NG_Team__c  ==true        && (ca.Forward_to_NG_Team_Sent_Date_1__c ==null || ca.Forward_to_NG_Team_Date__c == null)){
                        system.debug('Inside if NG');
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_NG_Team_Sent_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        cse.Forward_to_NG_Team_Date__c = system.today();
                        newCaseMap.put(cse.Id, cse);
                        
                    }else if(cs.NewValue =='NG Team'         && caseOldOwnerId_old != ca.OwnerId        && ca.Forward_to_NG_Team_Sent_Date_1__c   !=null       && ca.Forward_to_NG_Team_Sent_Date_2__c ==null ) {
                        system.debug('Inside else NG');
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_NG_Team_Sent_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.NewValue =='NG Team'       && caseOldOwnerId_old != ca.OwnerId          && ca.Forward_to_NG_Team_Sent_Date_2__c   !=null       && ca.Forward_to_NG_Team_Sent_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_NG_Team_Sent_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(ca.Forward_to_ECV_Team__c   ==true      && (ca.Forward_to_ECV_Team_Sent_Date_1__c ==null || ca.Forward_to_ECV_TeamDate__c == null)) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_ECV_Team_Sent_Date_1__c = system.today();
                        cse.Forward_to_ECV_TeamDate__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        
                        newCaseMap.put(cse.Id, cse);
                        
                    } else if(cs.NewValue =='ECV Team'        && caseOldOwnerId_old != ca.OwnerId        && ca.Forward_to_ECV_Team_Sent_Date_1__c   !=null      && ca.Forward_to_ECV_Team_Sent_Date_2__c ==null ) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_ECV_Team_Sent_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.NewValue =='ECV Team'             && caseOldOwnerId_old != ca.OwnerId   && ca.Forward_to_ECV_Team_Sent_Date_2__c   !=null      && ca.Forward_to_ECV_Team_Sent_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_ECV_Team_Sent_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(ca.Case_Category__c == 'Consumer' && ca.Forward_to_CST_Team__c == true && (ca.Forward_to_CST_Team_Sent_Date_1__c == null || ca.Forward_to_CST_TeamDate__c == null)){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_CST_Team_Sent_Date_1__c = system.today();
                        cse.Forward_to_CST_TeamDate__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }else if( cs.NewValue =='Consumer Support Queue'  && caseOldOwnerId_old != ca.OwnerId && ca.Case_Category__c == 'Consumer'           && ca.Forward_to_CST_Team_Sent_Date_1__c   !=null      && ca.Forward_to_CST_Team_Sent_Date_2__c ==null ) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_CST_Team_Sent_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } if(cs.NewValue =='Consumer Support Queue'    && caseOldOwnerId_old != ca.OwnerId && ca.Case_Category__c == 'Consumer'           && ca.Forward_to_CST_Team_Sent_Date_2__c   !=null      && ca.Forward_to_CST_Team_Sent_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_CST_Team_Sent_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    /***************************************************** OLD *****************************************************/

                    if(cs.OldValue =='Bank Team'               && ca.Forward_to_Bank_Changed_Date_1__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Bank_Changed_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.OldValue =='Bank Team'      && caseOldOwnerId_old != ca.OwnerId         && ca.Forward_to_Bank_Changed_Date_1__c  !=null  	  && ca.Forward_to_Bank_Changed_Date_2__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Bank_Changed_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    } else if(cs.OldValue =='Bank Team'         && caseOldOwnerId_old != ca.OwnerId      && ca.Forward_to_Bank_Changed_Date_2__c  !=null 		  && ca.Forward_to_Bank_Changed_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Bank_Changed_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    } else if(cs.OldValue =='Bank Team'         && caseOldOwnerId_old != ca.OwnerId      && ca.Forward_to_Bank_Changed_Date_3__c  !=null 		  && ca.Forward_to_Bank_Changed_Date_4__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Bank_Changed_Date_4__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    } else if(cs.OldValue =='Bank Team'         && caseOldOwnerId_old != ca.OwnerId      && ca.Forward_to_Bank_Changed_Date_4__c  !=null 		  && ca.Forward_to_Bank_Changed_Date_5__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Bank_Changed_Date_5__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    }
                    
                    if(cs.OldValue =='Score Team'              && ca.Forward_to_Score_Team_Changed_Date_1__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Score_Team_Changed_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }else if(cs.OldValue =='Score Team'      && caseOldOwnerId_old != ca.OwnerId        && ca.Forward_to_Score_Team_Changed_Date_1__c  !=null  && ca.Forward_to_Score_Team_Changed_Date_2__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Score_Team_Changed_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.OldValue =='Score Team'       && caseOldOwnerId_old != ca.OwnerId       && ca.Forward_to_Score_Team_Changed_Date_2__c !=null   && ca.Forward_to_Score_Team_Changed_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Score_Team_Changed_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.OldValue =='OLM Team'                && ca.Forward_to_OLM_Changed_Date_1__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_OLM_Changed_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.OldValue =='OLM Team'          && caseOldOwnerId_old != ca.OwnerId       && ca.Forward_to_OLM_Changed_Date_1__c  !=null         && ca.Forward_to_OLM_Changed_Date_2__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_OLM_Changed_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.OldValue =='OLM Team'         && caseOldOwnerId_old != ca.OwnerId       && ca.Forward_to_OLM_Changed_Date_2__c  !=null         && ca.Forward_to_OLM_Changed_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_OLM_Changed_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.OldValue =='OLM Team'         && caseOldOwnerId_old != ca.OwnerId       && ca.Forward_to_OLM_Changed_Date_3__c  !=null         && ca.Forward_to_OLM_Changed_Date_4__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_OLM_Changed_Date_4__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.OldValue =='OLM Team'         && caseOldOwnerId_old != ca.OwnerId       && ca.Forward_to_OLM_Changed_Date_4__c  !=null         && ca.Forward_to_OLM_Changed_Date_5__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_OLM_Changed_Date_5__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        
                    }
                    
                    if(cs.OldValue =='Data Merger Team'        && ca.Forward_to_Data_Merger_Changed_Date_1__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Merger_Changed_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        
                    } else if(cs.OldValue =='Data Merger Team'     && caseOldOwnerId_old != ca.OwnerId    && ca.Forward_to_Data_Merger_Changed_Date_1__c !=null  && ca.Forward_to_Data_Merger_Changed_Date_2__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Merger_Changed_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }else if(cs.OldValue =='Data Merger Team'    && caseOldOwnerId_old != ca.OwnerId    && ca.Forward_to_Data_Merger_Changed_Date_2__c !=null  && ca.Forward_to_Data_Merger_Changed_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Merger_Changed_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.OldValue =='Data Submission Team'    && ca.Forward_to_Data_Sub_Changed_Date_1__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Sub_Changed_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.OldValue =='Data Submission Team' && caseOldOwnerId_old != ca.OwnerId    && ca.Forward_to_Data_Sub_Changed_Date_1__c  !=null    && ca.Forward_to_Data_Sub_Changed_Date_2__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Sub_Changed_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.OldValue =='Data Submission Team'  && caseOldOwnerId_old != ca.OwnerId  && ca.Forward_to_Data_Sub_Changed_Date_2__c  !=null    && ca.Forward_to_Data_Sub_Changed_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Sub_Changed_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } else if(cs.OldValue =='Data Submission Team'  && caseOldOwnerId_old != ca.OwnerId  && ca.Forward_to_Data_Sub_Changed_Date_3__c  !=null    && ca.Forward_to_Data_Sub_Changed_Date_4__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Sub_Changed_Date_4__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }else if(cs.OldValue =='Data Submission Team'  && caseOldOwnerId_old != ca.OwnerId  && ca.Forward_to_Data_Sub_Changed_Date_4__c  !=null    && ca.Forward_to_Data_Sub_Changed_Date_5__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_Data_Sub_Changed_Date_5__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    } 
                    
                    if(cs.OldValue =='GPD Team'                && ca.Forward_to_GPD_Team_Changed_Date_1__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_GPD_Team_Changed_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                        
                    }else if(cs.OldValue =='GPD Team'           && caseOldOwnerId_old != ca.OwnerId     && ca.Forward_to_GPD_Team_Changed_Date_1__c  !=null    && ca.Forward_to_GPD_Team_Changed_Date_2__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_GPD_Team_Changed_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    }else if(cs.OldValue =='GPD Team'        && caseOldOwnerId_old != ca.OwnerId        && ca.Forward_to_GPD_Team_Changed_Date_2__c  !=null    && ca.Forward_to_GPD_Team_Changed_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_GPD_Team_Changed_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    }  
                    
                    if(cs.OldValue =='NG Team'                 && ca.Forward_to_NG_Team_Changed_Date_1__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_NG_Team_Changed_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    }else if(cs.OldValue =='NG Team'              && caseOldOwnerId_old != ca.OwnerId    && ca.Forward_to_NG_Team_Changed_Date_1__c  !=null     && ca.Forward_to_NG_Team_Changed_Date_2__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_NG_Team_Changed_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                        
                    }else if(cs.OldValue =='NG Team'       && caseOldOwnerId_old != ca.OwnerId          && ca.Forward_to_NG_Team_Changed_Date_2__c  !=null     && ca.Forward_to_NG_Team_Changed_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_NG_Team_Changed_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    }
                    
                    if(cs.OldValue =='ECV Team'                && ca.Forward_to_ECV_Team_Changed_Date_1__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_ECV_Team_Changed_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    } else if(cs.OldValue =='ECV Team'        && caseOldOwnerId_old != ca.OwnerId        && ca.Forward_to_ECV_Team_Changed_Date_1__c  !=null    && ca.Forward_to_ECV_Team_Changed_Date_2__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_ECV_Team_Changed_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    } else if(cs.OldValue =='ECV Team'       && caseOldOwnerId_old != ca.OwnerId            && ca.Forward_to_ECV_Team_Changed_Date_2__c  !=null    && ca.Forward_to_ECV_Team_Changed_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_ECV_Team_Changed_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    } 
                    
                    if(cs.OldValue == 'Consumer Support Queue' && ca.Case_Category__c == 'Consumer' && 
                       ca.Forward_to_CST_Changed_Date_1__c == null){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_CST_Changed_Date_1__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    } else if(cs.OldValue =='Consumer Support Queue'  && caseOldOwnerId_old != ca.OwnerId   && ca.Case_Category__c == 'Consumer'             && ca.Forward_to_CST_Changed_Date_1__c  !=null    && ca.Forward_to_CST_Changed_Date_2__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_CST_Changed_Date_2__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    } else if(cs.OldValue =='Consumer Support Queue'  && caseOldOwnerId_old != ca.OwnerId   && ca.Case_Category__c == 'Consumer'            && ca.Forward_to_CST_Changed_Date_2__c  !=null    && ca.Forward_to_CST_Changed_Date_3__c ==null) {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Forward_to_CST_Changed_Date_3__c = system.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse); 
                    }
                    
                    
                    // Last Reply Date for all Team
                   /* if(cs.OldValue =='Bank Team' && ca.Manual_Entry_Bank_Date__c==false ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Reply_from_Bank_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }*/
                    
                    if(cs.OldValue =='Data Submission Team') {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Reply_from_Data_Submission__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.OldValue =='OLM Team') {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Reply_from_OLM_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.OldValue =='ECV Team') {
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Reply_from_EVC_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.OldValue =='Score Team' ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Reply_from_Score_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.OldValue =='GPD Team' ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Reply_from_GPD_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.OldValue =='NG Team' ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Reply_from_NG_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.OldValue =='Consumer Support Queue' && ca.Case_Category__c == 'Consumer'){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Reply_from_CST_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.OldValue =='Data Merger Team' ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Reply_from_Data_Merger__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    
                    // Last Send date  
                    if(cs.newValue =='Data Submission Team' ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Sent_Date_of_Data_Submission__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.NewValue =='OLM Team' ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Sent_Date_of_OLM_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.newValue =='ECV Team' ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Sent_Date_of_ECV_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.newValue =='Score Team' ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Sent_Date_of_Score_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.NewValue =='GPD Team' ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Sent_Date_of_GPD_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.NewValue =='NG Team' ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Sent_Date_of_NG_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.NewValue =='Consumer Support Queue' && ca.Case_Category__c == 'Consumer'){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Sent_Date_of_CST_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                    
                    if(cs.NewValue =='Data Merger Team' ){
                        Case cse= new Case ();
                        if(newCaseMap.containsKey(ca.Id))
                            cse = newCaseMap.get(ca.Id);
                        else
                            cse.id=ca.id; 
                        cse.Last_Sent_Date_of_Data_Merger_Team__c = System.today();
                        cse.OwnerId = ca.OwnerId;
                        newCaseMap.put(cse.Id, cse);
                    }
                }
            }
            
            if(newCaseMap.keySet().size() > 0) {
                update newCaseMap.values();
            }
            
            /* map<Id, Case> accmap = new map<Id, Case>();
accMap.putall(caseListToInsert);
system.debug('accmap---------'+accMap);
if(accmap.size()>0){
update accmap.values();
system.debug('accmap.values()---------'+accmap.values());
} 

map<id,Case> accmap2 = new map<id,Case>();
accmap2.putall(caseListToInsert2);
system.debug('accmap2---------'+accmap2);
if(accmap2.size()>0){
update accmap2.values();
system.debug('accmap2.values()---------'+accmap2.values());
} 

map<id,Case> accmap3 = new map<id,Case>();
accmap3.putall(caseListToInsert3);
system.debug('accmap3---------'+accmap3);
if(accmap3.size()>0){

update accmap3.values();
system.debug('accmap3.values()---------'+accmap3.values());
} 

map<id,Case> accmap4 = new map<id,Case>();
accmap4.putall(caseListToInsert4);
system.debug('accmap4---------'+accmap4);
if(accmap4.size()>0){

update accmap4.values();
system.debug('accmap4.values()---------'+accmap4.values());
} 

map<id,Case> accmap5 = new map<id,Case>();
accmap5.putall(caseListToInsert5);
system.debug('accmap5---------'+accmap5);
if(accmap5.size()>0){

update accmap5.values();
system.debug('accmap5.values()---------'+accmap5.values());
} 

map<id,Case> accmap6 = new map<id,Case>();
accmap6.putall(caseListToInsert6);
system.debug('accmap6---------'+accmap6);
if(accmap6.size()>0){

update accmap6.values();
system.debug('accmap6.values()---------'+accmap6.values());
}

map<id,Case> accmap7 = new map<id,Case>();
accmap7.putall(caseListToInsert7);
system.debug('accmap7---------'+accmap7);
if(accmap7.size()>0){

update accmap7.values();
system.debug('accmap7.values()---------'+accmap7.values());
}

map<id,Case> accmap8 = new map<id,Case>();
accmap8.putall(caseListToInsert8);
system.debug('accmap8---------'+accmap8);
if(accmap8.size()>0){

update accmap8.values();
system.debug('accmap8.values()---------'+accmap8.values());
}

map<id,Case> accmap9 = new map<id,Case>();
accmap9.putall(caseListToInsert9);
system.debug('accmap9---------'+accmap9);
if(accmap9.size()>0){

update accmap9.values();
system.debug('accmap9.values()---------'+accmap9.values());
}

map<id,Case> accmap0 = new map<id,Case>();
accmap0.putall(caseListToInsert0);
system.debug('accmap0---------'+accmap0);
if(accmap0.size()>0){

update accmap0.values();
system.debug('accmap0.values()---------'+accmap0.values());
}

map<id,Case> accmap01 = new map<id,Case>();
accMap01.putall(caseListToInsert01);
system.debug('accmap---------'+accMap01);
if(accmap01.size()>0){
update accmap01.values();
system.debug('accmap01.values()---------'+accmap01.values());
}

map<id,Case> accmap02 = new map<id,Case>();
accMap02.putall(caseListToInsert02);
system.debug('accmap---------'+accMap01);
if(accmap02.size()>0){
update accmap02.values();
system.debug('accmap02.values()---------'+accmap02.values());
}*/
      
    } 
    
    public class CaseHistory1 {
        public string OldValue;
        public string NewValue;
        public string CaseId;
        public String Field;
        
        public CaseHistory1(string oldval,string newval, String CaseId, String Field) {
            this.OldValue=oldval;
            this.NewValue=newval;
            this.CaseId=CaseId;
            this.Field=Field;
        }
    }
    
}