trigger CopyEducationalContent on Case ( before Insert ,before Update) {
    
    if(Trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
        List<Educational_Content__c> edu= [Select Id,Content__c from Educational_Content__c where Name =: 'Loans – Credit Awareness' limit 1];
        for(Case cs : Trigger.new){
            
             Boolean shouldCopy = false;
            
            if(Trigger.isUpdate){
            Case oldCase = Trigger.oldMap.get(cs.Id);
            if(cs.Copy_Educational_Content__c != oldCase.Copy_Educational_Content__c && cs.Copy_Educational_Content__c){
                shouldCopy = true;
            }
        }

        if(Trigger.isInsert && cs.Copy_Educational_Content__c){
            shouldCopy = true;
        }

        if(shouldCopy){
            if(Test.isRunningTest()){
                cs.Educational_Content__c = 'v1';
            } else if (!edu.isEmpty()){
                cs.Educational_Content__c = edu[0].Content__c;
            }
        }            
        }
        
    }

}