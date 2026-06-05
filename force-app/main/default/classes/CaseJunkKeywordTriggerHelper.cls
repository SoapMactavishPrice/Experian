public class CaseJunkKeywordTriggerHelper {

    static List<Sub_Type1__c> subTypes;
    static Sub_Type1__c customerSubType;
    static Sub_Type1__c consumerSubType;
    static Sub_Type1__c membershipSubType;

    static List<Junk_Keyword__c> junkKeywords;

    public static Sub_Type1__c getCustomerSubType(String caseCategory) {
        if(subTypes == null) {
            subTypes = [
                SELECT Id, Case_Category__c, Case_Complaint__c, Case_Type__c, Sub_Type__c, Name, Sub_Type__r.Case_Type__c
                FROM Sub_Type1__c
                WHERE Case_Category__c IN ('Customer', 'Membership') AND Name = 'Junk'
            ];

            for(Sub_Type1__c s : subTypes) {
                if(s.Case_Category__c == 'Customer') {
                    customerSubType = s;
                }
                if(s.Case_Category__c == 'Consumer') {
                    //consumerSubType = s;
                }
                if(s.Case_Category__c == 'Membership') {
                    membershipSubType = s;
                }
            }
        }

        if(caseCategory == 'Customer') {
            return customerSubType;
        }
        if(caseCategory == 'Consumer') {
            //return consumerSubType;
        }
        if(caseCategory == 'Membership') {
            return membershipSubType;
        }

        return null;
    }

    public static List<Junk_Keyword__c> getJunkKeywords() {
        if(junkKeywords == null) {
            junkKeywords = [
                SELECT Id, Name
                FROM Junk_Keyword__c
                WHERE IsActive__c = true
            ];
        }

        return junkKeywords;
    }

}