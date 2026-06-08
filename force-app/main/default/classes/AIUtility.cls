public class AIUtility {
 public Static String getAIResponse(Id CaseId,String template, String inputParameter) 
    {
        String output;
        Map<String, String> property = new Map<String, String>();
        property.put('id', CaseId); // Don't need to pass other field values even if referenced in the template, just the Id
        ConnectApi.WrappedValue propertyValue = new ConnectApi.WrappedValue();
        propertyValue.value = property;
        Map<String, ConnectApi.WrappedValue> inputParams = new Map<String, ConnectApi.WrappedValue>();
        inputParams.put(inputParameter, propertyValue); // Property is the API Name we gave to the input
        
        ConnectApi.EinsteinPromptTemplateGenerationsInput executeTemplateInput = new ConnectApi.EinsteinPromptTemplateGenerationsInput();
        executeTemplateInput.additionalConfig = new ConnectApi.EinsteinLlmAdditionalConfigInput();
        executeTemplateInput.additionalConfig.applicationName = 'PromptBuilderPreview';
        executeTemplateInput.isPreview = false;
        executeTemplateInput.inputParams = inputParams;
        
		System.debug('executeTemplateInput'+executeTemplateInput);        
        ConnectApi.EinsteinPromptTemplateGenerationsRepresentation generationsOutput = ConnectApi.EinsteinLLM.generateMessagesForPromptTemplate(
    	template,
    	executeTemplateInput
		);
        System.debug('generationsOutput'+generationsOutput.generationErrors);
        System.debug('generationsOutput'+generationsOutput.generations.size());
        if(generationsOutput.generations.size()>0)
        {
        ConnectApi.EinsteinLLMGenerationItemOutput response = generationsOutput.generations[0]; 
		output = response.text; 
        } 
        return output;
    }
     @future(callout=true)
    public static void sendResponseEmail(Set<Id>CaseId)
    {
        try
        {
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'consumer.support@in.experian.com'];
        For(Case c:[select id,subject,SuppliedEmail from case where id in:CaseId])
        {
        //template name : GenerateResponseToCase
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {c.SuppliedEmail};
        //mail.setTargetObjectId(c.Id);
        if ( owea.size() > 0 ) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        mail.setToAddresses(toAddresses);
        mail.setSubject('Response:'+c.subject);
            
            if(!test.isRunningtest()){
        mail.setPlainTextBody(AIUtility.getAIResponse(c.id,'GenerateResponseToCase','Input:case1'));
            }else{
                mail.setPlainTextBody('hi');
            }
         Messaging.SendEmailResult[] results = Messaging.sendEmail(
                                 new Messaging.SingleEmailMessage[] { mail });
        inspectResults(results);
        }
        }
        catch(exception e)
        {
            System.debug('Exception e'+e);
        }
    }
    // Helper method
    @TestVisible
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }
    
}