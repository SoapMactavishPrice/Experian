trigger CaseJunkKeywordTrigger on Case (before insert, before update) {

    for(Case c : Trigger.new) {
        if(Trigger.isInsert) {
            System.debug('CaseJunkKeywordTrigger isInsert - ' + JSON.serialize(c));
        }
        if(Trigger.isUpdate) {
            System.debug('CaseJunkKeywordTrigger isUpdate - ' + JSON.serialize(c));
        }
    }

    // Set the Case as Junk if the subject contains a keywords from the Junk_Keyword__c object
    if(Trigger.isBefore && Trigger.isUpdate) {
        System.debug('Inside the trigger context ');
        Boolean isNewCaseUpdateContext = false;
        for(Case cs : Trigger.new) {
            if (cs.CreatedDate == cs.LastModifiedDate && cs.Junk_Case__c == false && cs.Case_Category__c != 'Consumer') {
                System.debug('CreatedDate equals LastModifiedDate');
                isNewCaseUpdateContext = true;
                break;
            }
        }

        if(isNewCaseUpdateContext) {
            List<Junk_Keyword__c> junkKeywords = CaseJunkKeywordTriggerHelper.getJunkKeywords();
            if (!junkKeywords.isEmpty()) {
                for (Case cs : Trigger.new) {
                    if (cs.CreatedDate == cs.LastModifiedDate && cs.Junk_Case__c == false && cs.Case_Category__c != 'Consumer') {
                        System.debug('CaseJunkKeywordTrigger - ' + cs.Case_Category__c);
                        if (String.isBlank(cs.Subject)) {
                            continue;
                        }

                        String subject = cs.Subject.toLowerCase();
                        Boolean isJunk = false;

                        for (Junk_Keyword__c jk : junkKeywords) {
                            if (!String.isBlank(jk.Name) && subject.contains(jk.Name.toLowerCase())) {
                                isJunk = true;
                                break;
                            }
                        }

                        if (isJunk) {
                            cs.Case_Complaints__c = 'Junk';
                            cs.Junk_Case__c = true;
                            cs.Status = 'Resolved';
                            cs.Resolve_Date__c = Date.today();

                            Sub_Type1__c subType = CaseJunkKeywordTriggerHelper.getCustomerSubType(cs.Case_Category__c);
                            if(subType != null) {
                                cs.Case_Type_Lookup__c = subType.Sub_Type__r.Case_Type__c;
                                cs.Sub_Type_Lookup__c = subType.Sub_Type__c;
                                cs.Sub_Type_1_Lookup__c = subType.Id;
                            }

                            // if (c.Case_Category__c == 'Customer') {
                                // c.Case_Type_Lookup__c = 'a0K2u00000Vsw3jEAB';
                                // c.Sub_Type_Lookup__c = 'a0L2u000007rdMbEAI';
                                // c.Sub_Type_1_Lookup__c = 'a0M2u000008MVHHEA4';
                            // }
                            // else if (c.Case_Category__c == 'Consumer') {
                                // c.Case_Type_Lookup__c = 'a0K2u00000VswD8EAJ';
                                // c.Sub_Type_Lookup__c = 'a0L2u000007rdN0EAI';
                                // c.Sub_Type_1_Lookup__c = 'a0M2u000008MVHlEAO';
                            // }
                            // else if (c.Case_Category__c == 'Membership') {
                                // c.Case_Type_Lookup__c = 'a0K2u00000VswDDEAZ';
                                // c.Sub_Type_Lookup__c = 'a0L2u000007rdNEEAY';
                                // c.Sub_Type_1_Lookup__c = 'a0M2u000008MVHuEAO';
                            // }
                        }
                    }
                }


                // check for the cases created in last one hour, if case with same email is there then update the case as junk
                DateTime lastHour = System.now().addHours(-1);

                Set<String> emailIds = new Set<String>();
                Set<String> subjects = new Set<String>();
                for(Case cs : Trigger.new) {
                    if (cs.CreatedDate == cs.LastModifiedDate && cs.Junk_Case__c == false && cs.Case_Category__c != 'Consumer') {
                        if(!String.isBlank(cs.SuppliedEmail)) {
                            emailIds.add(cs.SuppliedEmail);
                        }
                        if(!String.isBlank(cs.Subject)) {
                            subjects.add(cs.Subject);
                        }
                    }
                }

                Map<String, List<Case>> caseMap = new Map<String, List<Case>>();
                for(Case c : [
                    SELECT Id, SuppliedEmail, Case_Category__c, Case_Complaints__c, Case_Type_Lookup__c, Sub_Type_Lookup__c, Sub_Type_1_Lookup__c, Subject
                    FROM Case
                    WHERE CreatedDate >= :lastHour AND SuppliedEmail IN :emailIds AND Subject IN :subjects AND Case_Complaints__c != 'Junk' AND Case_Category__c != 'Consumer'
                ]) {
                    String email = c.SuppliedEmail.trim().toLowerCase();
                    if(!caseMap.containsKey(email)) {
                        caseMap.put(email, new List<Case>());
                    }
                    caseMap.get(email).add(c);
                }

                for(Case cs : Trigger.new) {
                    if (cs.CreatedDate == cs.LastModifiedDate && cs.Junk_Case__c == false && cs.Case_Category__c != 'Consumer') {
                        if(!String.isBlank(cs.Subject)) {
                            if(caseMap.containsKey(cs.SuppliedEmail)) {
                                for(Case c : caseMap.get(cs.SuppliedEmail)) {
                                    if(cs.Subject.trim().toLowerCase() == c.Subject.trim().toLowerCase()) {
                                        cs.Case_Complaints__c = 'Junk';
                                        cs.Junk_Case__c = true;
                                        cs.Status = 'Resolved';
                                        cs.Resolve_Date__c = Date.today();

                                        Sub_Type1__c subType = CaseJunkKeywordTriggerHelper.getCustomerSubType(c.Case_Category__c);
                                        if(subType != null) {
                                            cs.Case_Type_Lookup__c = subType.Sub_Type__r.Case_Type__c;
                                            cs.Sub_Type_Lookup__c = subType.Sub_Type__c;
                                            cs.Sub_Type_1_Lookup__c = subType.Id;
                                        }

                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}