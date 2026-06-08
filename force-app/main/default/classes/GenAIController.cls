public class GenAIController {
	
    @InvocableMethod(CapabilityType='FlexTemplate://Case_Classification_LLM') 
    public static List<Response> getCaseClassificationMaster(List<Request> requests)
    {
        List<Map<String,String>> mList=new List<Map<String,String>>();
        For(Sub_Type1__c st:[select id,Case_Complaint__c,Case_Type__c,Sub_Type__r.Name,Name from Sub_Type1__c where isActive__c=true and Case_Category__c='Consumer'])
        {
           Map<String, String> master=new Map<String,String>();
           master.put('CaseComplaint',st.Case_Complaint__c);
           master.put('CaseType',st.Case_Type__c);
           master.put('CaseSubType',st.Sub_Type__r.Name);
           master.put('CaseSubType1',st.Name);
           mList.add(master);  
        }
        List<Response> responses = new List<Response>();
        Response output = new Response();
        output.Prompt = 'Use master data for case classification:';
        output.Prompt +=mList;
        responses.add(output);
        return responses;
    }
   
    public class Request {
        @InvocableVariable(required=true)
        public Case Case1;
        
    }
    public class Response {
        @InvocableVariable
        public String Prompt;
    }

}