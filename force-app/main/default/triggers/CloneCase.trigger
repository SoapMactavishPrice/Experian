trigger CloneCase on Case (Before Insert ,After Insert) {
    
    if(trigger.isBefore && trigger.isInsert){
        string cloneId='';
        for(Case Cs : Trigger.new){
            cloneId= cs.getCloneSourceId();
            system.debug('cloneIds'+cloneId);
            if(cloneId !=null){
                if(cs.DIS_Dtl_Id__c !=null){
                    String disDtlId=cs.DIS_Dtl_Id__c;
                    if(disDtlId.contains('-')){
                        String[] spliteddisDtlId=disDtlId.split('-');
                        cs.DIS_Dtl_Id__c=spliteddisDtlId[0]+'-'+String.valueOf(Integer.valueOf(spliteddisDtlId[1])+1);
                    }else{
                        cs.DIS_Dtl_Id__c=cs.DIS_Dtl_Id__c+'-'+1;
                    }
                }
                //if(cs.Origin =='Portal'){
                    //Cs.addError('You cannot select case origin as "Portal" when you are cloning');
                //}
            }
        }
    }
    if(trigger.isAfter && trigger.isInsert){
        
        if(!RecursiveHandler.isCaseCloneTime){
            return;
        }
        string cloneId='';
        set<Id> recIds = new set<Id>();
        List<Case> updateCase = new List<Case>();
        for(Case Cs : Trigger.new){
            recIds.add(cs.Id);
            cloneId= cs.getCloneSourceId();
        }
        system.debug('cloneIds'+cloneId);
        system.debug('recIds'+recIds);
        
        List<Case> caselistclone = new List<Case>();
        List<Case>caseLists = new List<Case>();
        
        if(cloneId !=null){
            caseLists =  [Select Id,stgOneHitId__c,stgTwoHitId__c,Error__c,Credit_Report_Link__c,Resend_Credit_Report__c,Credit_Report_Generation_Date__c,Is_Error__c,DIS_Dtl_Id__c,Dispute_Raised_Date__c,Forward_to_bank__c,Forward_to_Score_Team__c,Forward_to_OLM__c,Forward_to_Data_Merger__c,
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
                          OwnerId,Forward_to_Bank_Changed_Date_4__c,Forward_to_Bank_Changed_Date_5__c,Forward_to_Bank_Sent_Date_5__c,Forward_to_Bank_Sent_Date_4__c,
                          Forward_to_OLM_Changed_Date_4__c,Forward_to_OLM_Changed_Date_5__c,Forward_to_OLM_Sent_Date_4__c,Forward_to_OLM_Sent_Date_5__c ,Last_Reply_from_OLM_Team__c	,
                          Last_Reply_from_Data_Submission__c, Forward_to_Data_Sub_Changed_Date_4__c,Forward_to_Data_Sub_Changed_Date_5__c,
                          Forward_to_Data_Submission_Sent_Date_4__c,Forward_to_Data_Submission_Sent_Date_5__c,
                          Dispute_Email_Sent__c, Resolved_Consumer_Email_Sent__c, Not_Resolved_Consumer_Email_Sent__c, No_Response_Bank_Email_Sent__c,
                          No_Response_Date__c, Mail_Sent__c, ReClose_Date__c, Resolve_Date__c, ReOpen_Date__c, Work_in_Progress_Date__c, Last_Reply_from_Bank_Team__c,
                          Last_Reply_from_CST_Team__c, Last_Reply_from_Data_Merger__c, Last_Reply_from_EVC_Team__c,
                          Last_Reply_from_GPD_Team__c, Last_Reply_from_NG_Team__c, Last_Reply_from_Score_Team__c,
                          Ticket_Closed_By__c, Ticket_ReClosed_By__c,Last_Sent_Date_of_CST_Team__c, Last_Sent_Date_of_Data_Merger_Team__c, 
                          Last_Sent_Date_of_Data_Submission__c, Last_Sent_Date_of_ECV_Team__c,Last_Sent_Date_of_Score_Team__c,
                          Last_Sent_Date_of_GPD_Team__c, Last_Sent_Date_of_NG_Team__c, Last_Sent_Date_of_OLM_Team__c from Case where Id IN: recIds];
        }
        system.debug('Case Size-->'+caseLists.size());
        
        for(Case cs : caseLists ){
            system.debug('Case Size-->'+caseLists.size());
            
            cs.Dispute_Raised_Date__c = null;
            //Bank Team
            cs.Forward_to_Bank_Changed_Date_1__c = null;
            cs.Forward_to_Bank_Changed_Date_2__c = null;
            cs.Forward_to_Bank_Changed_Date_3__c = null;
            cs.Forward_to_Bank_Changed_Date_4__c = null;
            cs.Forward_to_Bank_Changed_Date_5__c = null;
            cs.Forward_to_Bank_Sent_Date_1__c = null;
            cs.Forward_to_Bank_Sent_Date_2__c = null;
            cs.Forward_to_Bank_Sent_Date_3__c = null;
            cs.Forward_to_Bank_Sent_Date_4__c = null;
            cs.Forward_to_Bank_Sent_Date_5__c = null;
            
            // Data Sub Team
            cs.Forward_to_Data_Sub_Changed_Date_1__c = null;
            cs.Forward_to_Data_Sub_Changed_Date_2__c = null;
            cs.Forward_to_Data_Sub_Changed_Date_3__c = null;
            cs.Forward_to_Data_Sub_Changed_Date_4__c = null;
            cs.Forward_to_Data_Sub_Changed_Date_5__c = null;
            cs.Forward_to_Data_Submission_Sent_Date_1__c = null;
            cs.Forward_to_Data_Submission_Sent_Date_2__c = null;
            cs.Forward_to_Data_Submission_Sent_Date_3__c = null;
            cs.Forward_to_Data_Submission_Sent_Date_4__c = null;
            cs.Forward_to_Data_Submission_Sent_Date_5__c = null;
            
            //OLM Team
            cs.Forward_to_OLM_Changed_Date_1__c = null;
            cs.Forward_to_OLM_Changed_Date_2__c = null;
            cs.Forward_to_OLM_Changed_Date_3__c = null;
            cs.Forward_to_OLM_Changed_Date_4__c = null;
            cs.Forward_to_OLM_Changed_Date_5__c = null;
            cs.Forward_to_OLM_Sent_Date_1__c = null;
            cs.Forward_to_OLM_Sent_Date2__c = null;
            cs.Forward_to_OLM_Sent_Date_3__c = null;
            cs.Forward_to_OLM_Sent_Date_4__c = null;
            cs.Forward_to_OLM_Sent_Date_5__c = null;
            
            //CST Team 
            cs.Forward_to_CST_Changed_Date_1__c = null;
            cs.Forward_to_CST_Changed_Date_2__c = null;
            cs.Forward_to_CST_Changed_Date_3__c = null;
            cs.Forward_to_CST_Team_Sent_Date_1__c = null;
            cs.Forward_to_CST_Team_Sent_Date_2__c= null; 
            cs.Forward_to_CST_Team_Sent_Date_3__c = null;
            
            //Data Merger Team
            cs.Forward_to_Data_Merger_Changed_Date_1__c = null; 
            cs.Forward_to_Data_Merger_Changed_Date_2__c = null;
            cs.Forward_to_Data_Merger_Changed_Date_3__c = null ;
            cs.Forward_to_Data_Merger_Sent_Date_1__c = null;
            cs.Forward_to_Data_Merger_Sent_Date_2__c = null;
            cs.Forward_to_Data_Merger_Sent_Date_3__c = null; 
            
            //ECV Team
            cs.Forward_to_ECV_Team_Changed_Date_1__c = null;
            cs.Forward_to_ECV_Team_Changed_Date_2__c = null;
            cs.Forward_to_ECV_Team_Changed_Date_3__c = null; 
            cs.Forward_to_ECV_Team_Sent_Date_1__c = null;
            cs.Forward_to_ECV_Team_Sent_Date_2__c = null;
            cs.Forward_to_ECV_Team_Sent_Date_3__c = null;
            
            //GPD Team
            cs.Forward_to_GPD_Team_Changed_Date_1__c = null;
            cs.Forward_to_GPD_Team_Changed_Date_2__c = null;
            cs.Forward_to_GPD_Team_Changed_Date_3__c = null;
            cs.Forward_to_GPD_Team_Sent_Date_1__c = null;
            cs.Forward_to_GPD_Team_Sent_Date_2__c = null;
            cs.Forward_to_GPD_Team_Sent_Date_3__c = null; 
            
            //NG Team
            cs.Forward_to_NG_Team_Changed_Date_1__c = null;
            cs.Forward_to_NG_Team_Changed_Date_2__c = null;
            cs.Forward_to_NG_Team_Changed_Date_3__c = null;
            cs.Forward_to_NG_Team_Sent_Date_1__c = null;
            cs.Forward_to_NG_Team_Sent_Date_2__c = null;
            cs.Forward_to_NG_Team_Sent_Date_3__c = null;
            
            //Score Team
            cs.Forward_to_Score_Team_Changed_Date_1__c = null;
            cs.Forward_to_Score_Team_Changed_Date_2__c = null;
            cs.Forward_to_Score_Team_Changed_Date_3__c = null;
            cs.Forward_to_Score_Team_Sent_Date_1__c = null;
            cs.Forward_to_Score_Team_Sent_Date_2__c = null;
            cs.Forward_to_Score_Team_Sent_Date_3__c = null;
            
            //General Fields
            cs.Dispute_Email_Sent__c=false;
            cs.Resolved_Consumer_Email_Sent__c=false;
            cs.Not_Resolved_Consumer_Email_Sent__c=false;
            cs.No_Response_Bank_Email_Sent__c=false;
            cs.No_Response_Date__c=null;
            cs.Mail_Sent__c=false;
            cs.ReClose_Date__c=null;
            cs.Resolve_Date__c=null;
            cs.ReOpen_Date__c=null;
            cs.Work_in_Progress_Date__c=null;
            cs.Last_Reply_from_Bank_Team__c= null;
            cs.Last_Reply_from_CST_Team__c=null;
            cs.Last_Reply_from_Data_Merger__c=null;
            cs.Last_Reply_from_EVC_Team__c=null;
            cs.Last_Reply_from_Data_Submission__c=null;
            cs.Last_Reply_from_GPD_Team__c=null;
            cs.Last_Reply_from_NG_Team__c=null;
            cs.Last_Reply_from_OLM_Team__c=null;
            cs.Last_Reply_from_Score_Team__c=null;
            cs.Ticket_Closed_By__c=null;
            cs.Ticket_ReClosed_By__c=null;
            cs.Last_Sent_Date_of_CST_Team__c=null;
            cs.Last_Sent_Date_of_Data_Merger_Team__c=null;
            cs.Last_Sent_Date_of_Data_Submission__c=null;
            cs.Last_Sent_Date_of_ECV_Team__c=null;
            cs.Last_Sent_Date_of_GPD_Team__c=null;
            cs.Last_Sent_Date_of_NG_Team__c=null;
            cs.Last_Sent_Date_of_OLM_Team__c=null;
            cs.Last_Sent_Date_of_Score_Team__c=null;
            cs.Forward_to_Bank_Date__c =null;
            cs.Consumer_Dispute_Status__c=null;
            cs.Manual_Entry_Bank_Date__c=false;
            
            cs.stgOneHitId__c=null;
            cs.stgTwoHitId__c=null;
            cs.Error__c=null;
            cs.Credit_Report_Link__c=null;
            cs.Credit_Report_Generation_Date__c=null;
            cs.Resend_Credit_Report__c=false;
            cs.Is_Error__c=false;
            
            //IO Related Fileds
            cs.First_Time_Referred_To_IO__c=false;
            cs.Re_Referred_To_IO_Count__c=null;
            cs.Referred_To_IO_Case__c=false;
            cs.Referred_To_IO_By__c=null;
            cs.Referred_To_IO_Date__c=null;
            cs.Change_in_Member_Decision__c=false;
            cs.ECICI_Remarks__c=null;
            cs.CST_Status_after_IO_Status__c=null;
            cs.CST_Comments__c=null;
            cs.CST_Accepted_Date_Time__c=null;
            cs.Refer_To_MD_Date_Time__c=null;
            cs.IO_Status__c=null;
            cs.IO_Comments__c=null;
            cs.IO_Accepted_Date_Time__c=null;
            cs.IO_Rejected_Date_Time__c=null;
            
            caselistclone.add(cs);
        }     
        if(caselistclone.size() > 0){
            RecursiveHandler.isCaseCloneTime = false;
            update caselistclone;
        }
    }
}