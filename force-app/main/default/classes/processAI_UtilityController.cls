public  class processAI_UtilityController {

    public string recordID;
    public Id caseId {get;set;}

    public processAI_UtilityController() {
        caseId = ApexPages.currentPage().getparameters().get('id');
    }

    public void updateCase(){

        system.debug('caseId --> ' +caseId);
	    Set<Id> cList = new Set<Id>();
        
        Case caseData = [SELECT Id, subject, Case_Type_Lookup__c, SuppliedName FROM Case WHERE Id = :caseId];
     
        cList.add(caseData.Id);
        CaseTriggerHandler cst = new CaseTriggerHandler();
        cst.updateCaseCategory(cList);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'The AI UTILITY is called'));

    }
	
    
    public pageReference getSomething() {
        // Do your crazy stuff
        // Oppoid= ApexPages.currentPage().getParameters().get('id');
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('id'));
    }
   
}