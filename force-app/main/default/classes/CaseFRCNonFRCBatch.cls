global class CaseFRCNonFRCBatch implements Database.Batchable<Case>, Schedulable {

    /* =======================
       Batchable Implementation
       ======================= */

    global Iterable<Case> start(Database.BatchableContext bc) {
        return [
            SELECT Id, SuppliedEmail, CreatedDate
            FROM Case
            WHERE SuppliedEmail != null
            AND Case_Category__c = 'Consumer'
            AND Status = 'Open'
            AND FRC_Non_FRC__c  = null
            AND (CreatedDate = YESTERDAY OR CreatedDate = TODAY)
        ];
    }

    global void execute(Database.BatchableContext bc, List<Case> scope) {

        Set<String> emailSet = new Set<String>();
        Map<Id, String> caseIdToEmail = new Map<Id, String>();

        for (Case c : scope) {
            emailSet.add(c.SuppliedEmail);
            caseIdToEmail.put(c.Id, c.SuppliedEmail);
        }

        // Count ALL historical cases (no status filter)
        Map<String, Integer> emailCountMap = new Map<String, Integer>();

        for (AggregateResult ar : [
            SELECT SuppliedEmail email, COUNT(Id) cnt
            FROM Case
            WHERE SuppliedEmail IN :emailSet
            GROUP BY SuppliedEmail
        ]) {
            emailCountMap.put(
                (String) ar.get('email'),
                (Integer) ar.get('cnt')
            );
        }

        List<Case> casesToUpdate = new List<Case>();

        for (Case c : scope) {
            Integer totalCount = emailCountMap.get(caseIdToEmail.get(c.Id));

            if (totalCount != null) {
                c.No_of_Cases_FRC_Non_FRC__c  = totalCount;
                c.FRC_Non_FRC__c  = (totalCount == 1) ? 'FRC' : 'NON FRC';
                casesToUpdate.add(c);
            }
        }

        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }

    global void finish(Database.BatchableContext bc) {
        // optional
    }

    /* =======================
       Schedulable Implementation
       ======================= */

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CaseFRCNonFRCBatch(), 10);
    }
}