public class DPD_Detail_Handler {
   
    public void getUpdate_DPDInsert(List<DPD_Detail__c> newRecords){
        
        map<string,List<string>> dpdMap = new map<string,List<string>>();
        set<Id> cid = new  set<Id>();
        for(DPD_Detail__c dpd : newRecords){
            cid.add(dpd.Case__c);
        } 
        
        List<DPD_Detail__c> pdList  = new List<DPD_Detail__c>();
        pdList = [select Id, case__c, Correct_EMI_Repayment_Year__c, Displayed_EMI_Repayment_Month__c   from DPD_Detail__c where case__c IN :cid order by  Correct_EMI_Repayment_Year__c ,Displayed_EMI_Repayment_Month__c  asc];
         
        Map<string,set<string>> newDPDMap =new Map<string,set<string>>();
        
        
        for(DPD_Detail__c dpd : pdList){
               string month = '';
               string key = dpd.Case__c+'-'+dpd.Correct_EMI_Repayment_Year__c;
               if(newDPDMap.containskey(key)){
                	newDPDMap.get(string.valueOf(key)).add(string.valueOf(dpd.Displayed_EMI_Repayment_Month__c));
               }else{
                   newDPDMap.put(string.valueOf(key),new set<string>{string.valueOf(dpd.Displayed_EMI_Repayment_Month__c)});
               }
         }
        
        List<Case> cseList = new List<Case>();
        
        cseList = [Select Id ,Displayed_Account_number__c ,Dispute_Detail__c from Case where Id IN : cid and Sub_Type_Name__c =:'DPD'];
        map<string , string> caseMap = new map<string , string>();
        
        Map<string,List<string>> finalMap = new Map<string,List<string>>(); 
        string strMonth = '';
        for(string key : newDPDMap.keyset()){

            string temp;
            for(string month : newDPDMap.get(key)){
                string monthInWord = '';
            	 switch on Integer.valueOf(month) {
                            when 1 {
                                monthInWord = 'Jan';
                            }
                            when 2 {
                                monthInWord = 'Feb';
                            }
                            when 3 {
                                monthInWord = 'Mar';
                            }
                            when 4 {
                                monthInWord = 'Apr';
                            }
                            when 5 {
                                monthInWord = 'May';
                            }
                            when 6 {
                                monthInWord = 'June';
                            }
                            when 7 {
                                monthInWord = 'July';
                            }
                            when 8 {
                                monthInWord = 'Aug';
                            }
                            when 9 {
                                monthInWord = 'Sept';
                            }
                            when 10 {
                                monthInWord = 'Oct';
                            }
                            when 11 {
                                monthInWord = 'Nov';
                            }
                            when 12 {
                                monthInWord = 'Dec';
                            }
                        }
                  
                    if(string.isNotblank(temp)){
                        temp +=','+monthInWord;
                    }  else{
                        temp=monthInWord; 
                    }
                
                //str +=monthInWord+',';       
            }
            string str='('+temp+')'+'-'+key.substringAfter('-');
            temp ='';
            
            strMonth=str;
                if(finalMap.containskey(key.substringBefore('-'))){
                    finalMap.get(key.substringBefore('-')).add(strMonth);
                }else{
                    finalMap.put(key.substringBefore('-'),new List<string>{strMonth});
                }
                
           
        }
        
        system.debug('-->'+cseList.size());
        List<Case> cseListTOUpdate = new List<Case>();
        if(cseList.size() > 0){
         for(Case cs : cseList){
            string againstString =' against account number '+cs.Displayed_Account_number__c; 
            cs.Dispute_Detail__c = 'As per the consumer, the DPD is tagged incorrectly for the month of ';
            if(finalMap.containskey(cs.Id)){
                for(string sts : finalMap.get(cs.Id)){
                    cs.Dispute_Detail__c +=sts +','; 
                   }
                }
             cs.Dispute_Detail__c += ' '+againstString; 
               
             cseListTOUpdate.add(cs); 
            }
         
         }
        
        if(cseListTOUpdate.size() > 0){
            update cseListTOUpdate;
        }

    }
}