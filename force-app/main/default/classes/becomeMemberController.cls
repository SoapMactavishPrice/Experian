public class becomeMemberController{

    public List<String> type_of_member{get;set;}
    public List<String> nbfcs_types_options{get;set;}

    public becomeMemberController(){
        type_of_member = new List<String>();
        String objectName = 'Lead';
        String fieldName ='Type_of_Member__c';
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            Map<String, Object> mapName = new Map<String, Object>();
            System.debug('---PickList Value---> '+pickListVal.getLabel() +' '+pickListVal.getValue());
            mapName.put('label',pickListVal.getValue());
            type_of_member.add(JSON.serialize(mapName));
        }
        // type_of_member.add(JSON.serialize(type_of_member);
        System.debug('---PickList type_of_member---> '+type_of_member);

        nbfcs_types_options = new List<String>();
        String objectNamee = 'Lead';
        String fieldNamee ='NBFCs_Types__c';
        Schema.SObjectType se = Schema.getGlobalDescribe().get(objectNamee) ;
        Schema.DescribeSObjectResult re = se.getDescribe() ;
        Map<String,Schema.SObjectField> fieldse = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResulte = fieldse.get(fieldNamee).getDescribe();
        List<Schema.PicklistEntry> plee = fieldResulte.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : plee){
            Map<String, Object> mapName = new Map<String, Object>();
            System.debug('---PickList Value---> '+pickListVal.getLabel() +' '+pickListVal.getValue());
            mapName.put('label',pickListVal.getValue());
            nbfcs_types_options.add(JSON.serialize(mapName));
        }
        // type_of_member.add(JSON.serialize(type_of_member);
        System.debug('---PickList type_of_member---> '+nbfcs_types_options);
    }

    @RemoteAction
    public static status SubmitLead(String json){
        System.debug('Update Lead in Action ->'+json);
        String s = json.replace( '__c' , '_c' );
        status status = new status();
        List<Lead> NLead = new List < Lead > ();
        List < LeadApex > LeadList = parseTarget(s);
        String returnId = '';
        for(LeadApex la : LeadList){
            System.debug('----->'+la);
            Lead lts = new Lead();
            lts.Title = la.Title;
            lts.FirstName = la.FirstName;
            lts.LastName = la.LastName;
            lts.Phone = la.Phone;
            lts.Email = la.Email;
            lts.Type_of_Member__c = la.Type_of_Member_c;
            if(la.Type_of_Member_c == 'NBFCs'){
                lts.NBFCs_Types__c = la.nbfcs_types;
            }
            lts.Date_of_Incorporation__c = System.today();        
            lts.Company = la.CompanyName;
            try {
                Integer count = [SELECT count() from Lead where Email =: la.Email AND isConverted = false];
                if(count > 0 ){
                    status.msg = 'you have already filled the form';
                    status.instruction = 'We will get back to you shortly';
                    status.sing = 'fa fa-thumbs-up';
                    status.status = false;
                }else{
                    try {
                        insert lts;
                        status.msg = 'Thank you for filling the form';
                        status.instruction = 'We will get back to you shortly';
                        status.sing = 'fa fa-thumbs-up';
                        status.status = true;
                    } catch (QueryException e) {
                        status.msg = 'Somthing went wrong Exception!';
                        status.instruction = 'please refresh the page or Contact to Experian Support';
                        status.sing = 'fa fa-exclamation-triangle';
                        status.status = false;
                        System.debug('>>> ERROR1 ='+e);
                    }
                }
            } catch (QueryException e) {
                    status.msg = 'Somthing went wrong Exception!';
                    status.instruction = 'please refresh the page or Contact to Experian Support';
                    status.sing = 'fa fa-exclamation-triangle';
                    status.status = false;
                System.debug('>>> ERROR2 ='+e);
            }
            
        }
        return status;
    }

    public class LeadApex {
        public String Title;
        public String FirstName;
        public String LastName;
        public String CompanyName;
        public String Phone;
        public String Email;
        public String Type_of_Member_c;
        public String nbfcs_types;
    }

    public class status{
        public Boolean status{get;set;}
        public String msg{get;set;}
        public String instruction{get;set;}
        public String sing{get;set;}
    }

    public static List < LeadApex > parseTarget(String json) {
        return (List < LeadApex > ) System.JSON.deserialize(json, List < LeadApex > .class);
    }

}