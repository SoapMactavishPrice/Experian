/**
 * Apex class to clone a Case record 100 times with unique identifiers
 * and create 200-300 email messages (to and fro) for each cloned case
 * 
 * Usage: 
 *   CaseCloneWithEmails.cloneCaseWithEmails('00001234')
 *   CaseCloneWithEmails.rollbackClonedCases('00001234')
 */
public class CaseCloneWithEmails {
    /*
     Architectural summary (KT):
     - Problem: Synchronous cloning of 100 Cases and creating 200–300 EmailMessage records per Case exceeds Apex CPU time in a single transaction.
     - Solution: Use chained Queueable jobs to split the work across multiple async transactions. Each job does a bounded amount of work well within limits, then re-enqueues itself until the target volume is fully created.
     - Flow:
         1) cloneCaseWithEmails(caseNumber) -> enqueues CaseCloneWithEmails_Q
         2) CaseCloneWithEmails_Q clones 100 Cases in chunks and collects their Ids -> enqueues CaseEmails_Q with those Ids
         3) CaseEmails_Q creates emails per Case in small batches (~60 per Case per job), counts what exists, creates the next chunk, and re-enqueues itself with remaining cases until all reach 200–300 emails each.
         4) CaseTasks_Q creates ~100 Tasks per Case in small batches (~50 per Case per job) with sensible defaults and re-enqueues until each Case reaches the target.
     - Safety: Batch DML at 200 records, precompute strings/dates, CPU guards, and no debug in hot loops.
    */
    
    /**
     * Main method to clone case and create email messages
     * @param caseNumber - The Case Number of the case to clone
     * @return List of IDs of successfully cloned cases
     */
    // New entry that offloads heavy work to Queueables to avoid CPU limits.
    /**
     * Entry-point method (KT):
     * - Validates the Case Number input.
     * - Starts the asynchronous workflow by enqueueing CaseCloneWithEmails_Q.
     * - We pass parameters:
     *     totalClones = 100
     *     minEmails = 200
     *     maxEmails = 300
     *     cloneChunkSize = 25 (insert clones in groups of 25)
     *     totalEmailCapPerJob = 0 (no global cap; ensures "eventual completion" of all required emails via chaining)
     */
     public static void cloneCaseWithEmails(String caseNumber) {
        if (String.isBlank(caseNumber)) {
            throw new IllegalArgumentException('Case number cannot be blank');
        }
        System.enqueueJob(new CaseCloneWithEmails_Q(caseNumber, 100, 200, 300, 25, 0, 100));
    }
    
    /**
     * Creates 200-300 email messages (to and fro) for each case
     * @param cases - List of cases to create email messages for
     */
    // Retained for backwards-compat small use; not used by async flow.
    /**
     * Legacy helper (KT):
     * - Kept for backward compatibility if any legacy callers pass Case records directly.
     * - It doesn't create emails synchronously anymore. Instead, it collects all Case IDs
     *   and enqueues a single CaseEmails_Q job to avoid violating queueable job limits.
     * - Added safety for large datasets to prevent heap overflow.
     */
    private static void createEmailMessagesForCases(List<Case> cases) {
        if (cases == null || cases.isEmpty()) return;

        // Process in batches to avoid heap limits for very large lists
        // Salesforce recommends keeping list sizes under 10,000 for SOQL queries
        Integer batchSize = 5000;
        for (Integer i = 0; i < cases.size(); i += batchSize) {
            Integer endIdx = Math.min(i + batchSize, cases.size());
            List<Id> batchCaseIds = new List<Id>();
            for (Integer j = i; j < endIdx; j++) {
                batchCaseIds.add(cases[j].Id);
            }
            
            // Enqueue a single job with the batch of case IDs
            // This ensures we only make one enqueue call per transaction
            System.enqueueJob(new CaseEmails_Q(batchCaseIds, 200, 300, 2000, 100));
        }
    }
    
    /**
     * Rollback method to delete all cloned cases and their email messages
     * based on the original case number
     * @param originalCaseNumber - The Case Number of the original case that was cloned
     * @return RollbackResult containing counts of deleted records
     */
    /**
     * Rollback by original Case Number (KT):
     * - Finds the original Case by its CaseNumber to derive a subject pattern (the clones have " - CLONE-XXX").
     * - Locates cloned Cases matching the subject pattern.
     * - Deletes all EmailMessage records related to those Cases first (to avoid child record constraints).
     * - Deletes the cloned Cases.
     * - Returns counts for auditability.
     */
    public static RollbackResult rollbackClonedCases(String originalCaseNumber) {
        if (String.isBlank(originalCaseNumber)) {
            throw new IllegalArgumentException('Case number cannot be blank');
        }
        
        // Find the original case to get its subject pattern
        List<Case> originalCases = [
            SELECT Id, CaseNumber, Subject 
            FROM Case 
            WHERE CaseNumber = :originalCaseNumber 
            LIMIT 1
        ];
        
        if (originalCases.isEmpty()) {
            throw new IllegalArgumentException('Case with number ' + originalCaseNumber + ' not found');
        }
        
        Case originalCase = originalCases[0];
        String baseSubject = originalCase.Subject;
        
        // Find all cloned cases that match the pattern
        // Cloned cases have " - CLONE-XXX" appended to the subject
        String clonePattern = '% - CLONE-%';
        List<Case> clonedCases = [
            SELECT Id, CaseNumber, Subject 
            FROM Case 
            WHERE Subject LIKE :clonePattern
            AND Subject LIKE :('%' + baseSubject + '%')
            ORDER BY CreatedDate DESC
        ];
        
        // Also try to find by case number pattern if subject matching doesn't work
        if (clonedCases.isEmpty()) {
            // Alternative: find cases created after the original case with similar characteristics
            clonedCases = [
                SELECT Id, CaseNumber, Subject 
                FROM Case 
                WHERE Subject LIKE :clonePattern
                AND CreatedDate >= :originalCase.CreatedDate
                ORDER BY CreatedDate DESC
                LIMIT 100
            ];
        }
        
        if (clonedCases.isEmpty()) {
            System.debug('No cloned cases found to rollback for case: ' + originalCaseNumber);
            return new RollbackResult(0, 0, 'No cloned cases found');
        }
        
        System.debug('Found ' + clonedCases.size() + ' cloned cases to delete');
        
        // Get all case IDs
        Set<Id> caseIds = new Set<Id>();
        for (Case c : clonedCases) {
            caseIds.add(c.Id);
        }
        
        // Delete email messages first (child records)
        List<EmailMessage> emailMessages = [
            SELECT Id 
            FROM EmailMessage 
            WHERE RelatedToId IN :caseIds
        ];
        
        Integer emailCount = emailMessages.size();
        if (!emailMessages.isEmpty()) {
            List<Database.DeleteResult> emailDeleteResults = Database.delete(emailMessages, false);
            Integer deletedEmailCount = 0;
            for (Database.DeleteResult result : emailDeleteResults) {
                if (result.isSuccess()) {
                    deletedEmailCount++;
                } else {
                    System.debug('Failed to delete email message: ' + result.getErrors());
                }
            }
            System.debug('Deleted ' + deletedEmailCount + ' out of ' + emailCount + ' email messages');
        }
        
        // Delete cloned cases
        List<Database.DeleteResult> caseDeleteResults = Database.delete(clonedCases, false);
        Integer deletedCaseCount = 0;
        for (Database.DeleteResult result : caseDeleteResults) {
            if (result.isSuccess()) {
                deletedCaseCount++;
            } else {
                System.debug('Failed to delete cloned case: ' + result.getErrors());
            }
        }
        
        System.debug('Deleted ' + deletedCaseCount + ' out of ' + clonedCases.size() + ' cloned cases');
        
        String message = 'Rollback completed: Deleted ' + deletedCaseCount + ' cases and ' + 
                        emailCount + ' email messages';
        
        return new RollbackResult(deletedCaseCount, emailCount, message);
    }
    
    /**
     * Rollback all cases created by this script (no parameters required).
     * - Identifies Cases tagged with Description marker "[AUTO-GEN:CaseCloneWithEmails]" or Origin='Script'
     *   and Subject pattern containing "CLONE-".
     * - Deletes EmailMessage children first, then deletes the Cases (Tasks will cascade on Case delete).
     */
    public static RollbackResult rollbackAllScriptClones() {
        // Identify cloned cases created by this script (mindful tagging via Description only)
        // NOTE: Description is a Long Text Area and cannot be used in WHERE filters.
        // We avoid filtering on Description in SOQL to prevent "field 'Description' can not be filtered" errors.
        List<Case> clonedCases = [
            SELECT Id, CaseNumber, Subject, Description
            FROM Case
            WHERE Subject LIKE '%CLONE-%'
            ORDER BY CreatedDate DESC
            LIMIT 50000
        ];
        // Post-query in-memory filter to keep only the ones tagged by this script.
        // Apex doesn't support Java-like streams; filter imperatively.
        if (!clonedCases.isEmpty()) {
            List<Case> filtered = new List<Case>();
            for (Case c : clonedCases) {
                if (c.Description != null && c.Description.contains('[CLONED:CaseCloneWithEmails]')) {
                    filtered.add(c);
                }
            }
            clonedCases = filtered;
        }

        if (clonedCases.isEmpty()) {
            return new RollbackResult(0, 0, 'No script-generated cloned cases found');
        }

        Set<Id> caseIds = new Set<Id>();
        for (Case c : clonedCases) caseIds.add(c.Id);

        // Delete EmailMessage children first (RelatedToId = Case.Id)
        List<EmailMessage> emailMessages = [
            SELECT Id
            FROM EmailMessage
            WHERE RelatedToId IN :caseIds
            LIMIT 50000
        ];
        Integer emailCount = emailMessages.size();
        if (!emailMessages.isEmpty()) {
            Database.delete(emailMessages, false);
        }

        // Delete Task children explicitly (WhatId = Case.Id)
        // While standard Activities often cascade on Case delete, we ensure cleanup explicitly as requested.
        List<Task> tasksToDelete = [
            SELECT Id
            FROM Task
            WHERE WhatId IN :caseIds
            LIMIT 50000
        ];
        Integer taskCount = tasksToDelete.size();
        if (!tasksToDelete.isEmpty()) {
            Database.delete(tasksToDelete, false);
        }

        // Delete cases
        Database.delete(clonedCases, false);

        // Note: RollbackResult currently tracks only cases and emails.
        // We keep the signature unchanged but include tasks in the message for visibility.
        String msg = 'Rollback completed for script-generated clones: Deleted ' + clonedCases.size() +
                     ' cases, ' + emailCount + ' email(s), ' + taskCount + ' task(s).';
        return new RollbackResult(clonedCases.size(), emailCount, msg);
    }
    
    /**
     * Rollback method to delete cloned cases by their IDs
     * @param clonedCaseIds - List of Case IDs to delete
     * @return RollbackResult containing counts of deleted records
     */
    /**
     * Rollback by Case Ids (KT):
     * - Accepts explicit Case Ids.
     * - Deletes EmailMessage children first, then deletes the Cases.
     * - Useful when you have programmatically tracked the clones elsewhere.
     */
    public static RollbackResult rollbackClonedCasesByIds(List<Id> clonedCaseIds) {
        if (clonedCaseIds == null || clonedCaseIds.isEmpty()) {
            throw new IllegalArgumentException('Case IDs list cannot be empty');
        }
        
        // Query the cases to ensure they exist
        List<Case> clonedCases = [
            SELECT Id, CaseNumber, Subject 
            FROM Case 
            WHERE Id IN :clonedCaseIds
        ];
        
        if (clonedCases.isEmpty()) {
            System.debug('No cases found with the provided IDs');
            return new RollbackResult(0, 0, 'No cases found with provided IDs');
        }
        
        System.debug('Found ' + clonedCases.size() + ' cases to delete');
        
        Set<Id> caseIds = new Set<Id>();
        for (Case c : clonedCases) {
            caseIds.add(c.Id);
        }
        
        // Delete email messages first
        List<EmailMessage> emailMessages = [
            SELECT Id 
            FROM EmailMessage 
            WHERE RelatedToId IN :caseIds
        ];
        
        Integer emailCount = emailMessages.size();
        if (!emailMessages.isEmpty()) {
            List<Database.DeleteResult> emailDeleteResults = Database.delete(emailMessages, false);
            Integer deletedEmailCount = 0;
            for (Database.DeleteResult result : emailDeleteResults) {
                if (result.isSuccess()) {
                    deletedEmailCount++;
                }
            }
            System.debug('Deleted ' + deletedEmailCount + ' out of ' + emailCount + ' email messages');
        }
        
        // Delete cloned cases
        List<Database.DeleteResult> caseDeleteResults = Database.delete(clonedCases, false);
        Integer deletedCaseCount = 0;
        for (Database.DeleteResult result : caseDeleteResults) {
            if (result.isSuccess()) {
                deletedCaseCount++;
            }
        }
        
        System.debug('Deleted ' + deletedCaseCount + ' out of ' + clonedCases.size() + ' cloned cases');
        
        String message = 'Rollback completed: Deleted ' + deletedCaseCount + ' cases and ' + 
                        emailCount + ' email messages';
        
        return new RollbackResult(deletedCaseCount, emailCount, message);
    }
    
    /**
     * Wrapper class to return rollback results
     */
    /**
     * DTO (KT):
     * - Simple wrapper for returning rollback operation results (counts + message).
     */
    public class RollbackResult {
        public Integer deletedCasesCount { get; set; }
        public Integer deletedEmailsCount { get; set; }
        public String message { get; set; }
        
        public RollbackResult(Integer casesCount, Integer emailsCount, String msg) {
            this.deletedCasesCount = casesCount;
            this.deletedEmailsCount = emailsCount;
            this.message = msg;
        }
    }
    
    /**
     * Batch version for handling large volumes
     * This can be used if you need to process more than 100 cases
     */
    // Queueable to clone cases in manageable chunks, then chain email generation
    /**
     * Queueable 1/2: CaseCloneWithEmails_Q (KT):
     * - Takes a CaseNumber, queries the original Case once.
     * - Clones "totalClones" Cases in memory, setting unique subject suffix "CLONE-XXX".
     * - Inserts clones in "cloneChunkSize" batches (e.g., 25) to respect limits.
     * - Collects successful clone Ids and enqueues CaseEmails_Q with those Ids.
     * - Rationale: isolate cloning step from email creation to control CPU and DML separately.
     */
    public class CaseCloneWithEmails_Q implements Queueable {
        private String caseNumber;
        private Integer totalClones;
        private Integer minEmails;
        private Integer maxEmails;
        private Integer cloneChunkSize;
        private Integer totalEmailCapPerJob; // if 0 => no cap, create all emails across chained jobs
        private Integer targetTasksPerCase; // desired Tasks per case

        public CaseCloneWithEmails_Q(String caseNumber, Integer totalClones, Integer minEmails, Integer maxEmails, Integer cloneChunkSize, Integer totalEmailCapPerJob, Integer targetTasksPerCase) {
            this.caseNumber = caseNumber;
            this.totalClones = (totalClones == null ? 100 : totalClones);
            this.minEmails = (minEmails == null ? 200 : minEmails);
            this.maxEmails = (maxEmails == null ? 300 : maxEmails);
            this.cloneChunkSize = (cloneChunkSize == null ? 25 : cloneChunkSize);
            this.totalEmailCapPerJob = (totalEmailCapPerJob == null ? 2000 : totalEmailCapPerJob);
            this.targetTasksPerCase = (targetTasksPerCase == null ? 100 : targetTasksPerCase);
        }

        public void execute(QueueableContext qc) {
            // 1) Find the original Case once (small, selective query)
            Case originalCase = [
                SELECT Id, CaseNumber, Subject, Description, Status, Priority, 
                       Origin, Type, AccountId, ContactId, OwnerId, ParentId, Reason
                FROM Case WHERE CaseNumber = :caseNumber LIMIT 1
            ];

            List<Id> allClonedIds = new List<Id>();
            List<Case> buffer = new List<Case>();

            // 2) Build clones in memory with unique Subject and clear Parent
            for (Integer i = 1; i <= totalClones; i++) {
                Case clone = originalCase.clone(false, true, false, false);
                String uniqueId = 'CLONE-' + String.valueOf(i).leftPad(3, '0');
                clone.Subject = (String.isNotBlank(clone.Subject) ? uniqueId  + ' - ' + clone.Subject : 'Cloned Case - ' + uniqueId);
                clone.Description = (String.isNotBlank(clone.Description) ? uniqueId  + ' - ' + clone.Description : 'Cloned Case - ' + uniqueId);
                clone.ParentId = null;
                // Set Resolved Date to 1 week (7 days) before today
                // Adjust the field API name if different in your org:
                // - If it's a Date field: use Date.today().addDays(-7)
                // - If it's a DateTime field: use System.now().addDays(-7)
                // Here assuming a Date field named Resolve_Date__c based on the class reference.
                clone.Resolve_Date__c = Date.today().addDays(-7);
                // Tag the clone so we can auto-rollback without parameters
                // Mindful markers (non-customer-facing field values):
                //  - Subject already contains "CLONE-XXX"
                //  - Add a subtle deterministic marker into Description only
                //    e.g., "[CLONED:CaseCloneWithEmails]" so UI reads naturally while being machine-detectable.
                clone.Description = (clone.Description == null ? '' : clone.Description) + ' [CLONED:CaseCloneWithEmails]';
                buffer.add(clone);

                // 3) Insert each chunk to stay under limits; gather successful Ids
                if (buffer.size() == cloneChunkSize || i == totalClones) {
                    Database.SaveResult[] sr = Database.insert(buffer, false);
                    for (Integer k = 0; k < sr.size(); k++) {
                        if (sr[k].isSuccess()) allClonedIds.add(buffer[k].Id);
                    }
                    buffer.clear();
                }
            }

            // Chain queueables to build emails and tasks for the new Cases
            // Only enqueue one job at a time to avoid "Too many queueable jobs added to the queue: 2" error
            if (!allClonedIds.isEmpty()) {
                // First emails - this will chain the tasks after completion
                System.enqueueJob(new CaseEmails_Q(allClonedIds, minEmails, maxEmails, totalEmailCapPerJob, targetTasksPerCase));
            }
        }
    }

    // Queueable to create emails in CPU-friendly manner with caps
    /**
     * Queueable 2/2: CaseEmails_Q (KT):
     * - Responsible for creating 200–300 emails per cloned Case.
     * - Strategy:
     *     * Determine the required total per case deterministically (no heavy hashing).
     *     * Count existing emails for each case.
     *     * Create only the next "window" (targetPerCaseThisJob ~ 60) per job per case.
     *     * Re-enqueue itself with the remaining cases until every case reaches the target.
     * - This "eventual completion" pattern guarantees full 200–300 emails per case without exceeding CPU.
     */
    public class CaseEmails_Q implements Queueable {
        private List<Id> caseIds;
        private Integer minEmails;
        private Integer maxEmails;
        private Integer totalEmailCapPerJob; // if 0 => create all required emails across chained jobs
        private Integer targetTasksPerCase; // Target number of tasks per case

        public CaseEmails_Q(List<Id> caseIds, Integer minEmails, Integer maxEmails, Integer totalEmailCapPerJob, Integer targetTasksPerCase) {
            this.caseIds = caseIds;
            this.minEmails = (minEmails == null ? 200 : minEmails);
            this.maxEmails = (maxEmails == null ? 300 : maxEmails);
            this.totalEmailCapPerJob = (totalEmailCapPerJob == null ? 0 : totalEmailCapPerJob);
            this.targetTasksPerCase = (targetTasksPerCase == null ? 100 : targetTasksPerCase);
        }

        // Helper to compute deterministic required count per case index
        // Compute a stable required email count (KT):
        // - Uses the list index to vary between minEmails..maxEmails deterministically.
        // - Avoids Id.hashCode() (heavier) while still distributing counts across cases.
        private Integer requiredEmailsForIndex(Integer idx) {
            Integer range = Math.max(0, maxEmails - minEmails);
            return minEmails + (range == 0 ? 0 : Math.mod(idx, (range + 1)));
        }

        public void execute(QueueableContext qc) {
            if (caseIds == null || caseIds.isEmpty()) return;

            // Note: No heavy logging here to keep CPU low.
            // We precompute invariants (addresses, base datetime) once.

            // Precompute invariant values
            String customerEmail = 'customer@example.com';
            String supportFallback = 'support@example.com';
            String fromEmail = supportFallback;
            User u = [SELECT Email FROM User WHERE Id = :UserInfo.getUserId()];
            if (String.isNotBlank(u.Email)) fromEmail = u.Email;

            // Fetch cases in one query
            Map<Id, Case> cases = new Map<Id, Case>([
                // One query for all cases we need this run
                SELECT Id, CaseNumber, Subject FROM Case WHERE Id IN :caseIds
            ]);

            // State across chained jobs using Platform Cache substitute: custom progress tracking via a helper object is overkill.
            // Instead, process a bounded amount per job and re-enqueue remaining work until all per-case targets are met.

            Integer totalCreatedThisJob = 0;
            List<EmailMessage> buffer = new List<EmailMessage>();
            DateTime nowBase = System.now();
            Integer dmlChunk = 200;
            Integer soqlPerCaseLimit = 1; // we do a single count() per case
            Integer safeCpuSoftStop = 8500; // ms, soft stop before 10k apex cpu
            Integer safeCpuHardStop = 9500; // ms, hard stop guard
            Integer maxRecordsThisJob = 4500; // extra global cap to avoid long-running jobs

            // Work plan per job
            // - Process cases sequentially.
            // - For each case, aim to create up to targetPerCaseThisJob emails (CPU-safe), and continue in next chained job as needed.
            // We only create up to this many per case per job (KT):
            // - Keeps CPU and DML safely under governor limits.
            Integer targetPerCaseThisJob = 40; // smaller per-case window to reduce CPU/DML pressure

            List<Id> remainingCaseIds = new List<Id>();

            for (Integer idx = 0; idx < caseIds.size(); idx++) {
                // CPU guard: if we're close to limit, stop and re-enqueue remaining work
                if (Limits.getCpuTime() > safeCpuSoftStop || totalCreatedThisJob >= maxRecordsThisJob) {
                    // Not finished with this and later cases; collect remaining
                    for (Integer j = idx; j < caseIds.size(); j++) remainingCaseIds.add(caseIds[j]);
                    break;
                }

                Id cid = caseIds[idx];
                Case c = cases.get(cid);
                if (c == null) continue;

                Integer requiredTotal = requiredEmailsForIndex(idx);

                // Determine how many already exist for this case
                // Count how many already exist; this allows safe continuation across chained jobs
                // Count existing emails; keep SOQL per-case at 1
                Integer existing = [SELECT count() FROM EmailMessage WHERE RelatedToId = :cid];

                if (existing >= requiredTotal) {
                    continue; // this case is done
                }

                Integer toCreateForThisCase = requiredTotal - existing;
                Integer willCreateNow = Math.min(toCreateForThisCase, targetPerCaseThisJob);

                String subjectPrefix = 'Re: ' + (String.isNotBlank(c.Subject) ? c.Subject : 'Case') + ' - Email #';
                String baseTextPrefix = ' in the conversation thread for case ' + c.CaseNumber + '. ';
                // Compute starting index and message dates deterministically and consistently:
                Integer startIdx = existing + 1;
                // Compute a consistent message timeline: each email 5 minutes apart
                DateTime startDt = nowBase.addMinutes(-(requiredTotal - startIdx + 1) * 5);

                for (Integer i = 0; i < willCreateNow; i++) {
                    if (totalEmailCapPerJob != 0 && totalCreatedThisJob >= totalEmailCapPerJob) break;
                    if (Limits.getCpuTime() > safeCpuHardStop || totalCreatedThisJob >= maxRecordsThisJob) break;

                    Integer msgNumber = startIdx + i;

                    EmailMessage em = new EmailMessage();
                    em.RelatedToId = c.Id;
                    em.Subject = subjectPrefix + msgNumber;
                    em.MessageDate = startDt.addMinutes(i * 5);

                    Boolean odd = (Math.mod(msgNumber, 2) == 1);
                    String emailContent = 'This is email message #' + msgNumber + baseTextPrefix +
                        (odd ? 'Customer inquiry regarding the case status and resolution.'
                             : 'Support team response with updates and next steps.');
                    em.TextBody = emailContent;
                    em.HtmlBody = '<p>' + emailContent + '</p>';

                    if (odd) {
                        em.Incoming = true;
                        em.FromAddress = customerEmail;
                        em.ToAddress = fromEmail;
                        em.Status = '3';
                    } else {
                        em.Incoming = false;
                        em.FromAddress = fromEmail;
                        em.ToAddress = customerEmail;
                        em.Status = '3';
                    }

                    buffer.add(em);
                    totalCreatedThisJob++;

                    if (buffer.size() == dmlChunk) {
                        Database.insert(buffer, false);
                        buffer.clear();
                    }
                }

                // If not finished for this case, add it to remaining list for next job
                if (existing + Math.min(toCreateForThisCase, targetPerCaseThisJob) < requiredTotal) {
                    remainingCaseIds.add(cid);
                }

                if ((totalEmailCapPerJob != 0 && totalCreatedThisJob >= totalEmailCapPerJob)
                    || totalCreatedThisJob >= maxRecordsThisJob
                    || Limits.getCpuTime() > safeCpuSoftStop) {
                    // cap reached, add remaining cases for next job
                    for (Integer j = idx + 1; j < caseIds.size(); j++) remainingCaseIds.add(caseIds[j]);
                    break;
                }
            }

                // Flush any remaining emails in the buffer (bulkified DML)
                if (!buffer.isEmpty()) {
                Database.insert(buffer, false);
                buffer.clear();
            }

            // Chain continuation until all cases reach their per-case targets (200–300 each)
            // Re-enqueue remaining work until all cases reach the target volume
            if (!remainingCaseIds.isEmpty()) {
                System.enqueueJob(new CaseEmails_Q(remainingCaseIds, minEmails, maxEmails, totalEmailCapPerJob, targetTasksPerCase));
            }
            // If we need to chain tasks after emails are done, enqueue the CaseTasks_Q job
            else {
                // All emails are created for all cases, now chain the tasks
                System.enqueueJob(new CaseTasks_Q(caseIds, targetTasksPerCase));
            }
        }
    }

    // Queueable 3/3: CaseTasks_Q
    /**
     * Queueable: CaseTasks_Q
     * - Creates ~targetTasksPerCase Task records per Case.
     * - Bulk-safe and CPU-safe; creates up to targetPerCaseThisJob (50) tasks per Case per job.
     * - Defaults:
     *   Status=Not Started, Priority=Normal, OwnerId=Case.OwnerId, WhatId=Case.Id, WhoId=Case.ContactId (if present),
     *   Subject='Auto Task {n} for ' + CaseNumber, ActivityDate=today + (n % 30).
     */
    public class CaseTasks_Q implements Queueable {
        private List<Id> caseIds;
        private Integer targetTasksPerCase;

        public CaseTasks_Q(List<Id> caseIds, Integer targetTasksPerCase) {
            this.caseIds = caseIds;
            this.targetTasksPerCase = (targetTasksPerCase == null ? 100 : targetTasksPerCase);
        }

        public void execute(QueueableContext qc) {
            if (caseIds == null || caseIds.isEmpty()) return;

            // Fetch Cases once
            Map<Id, Case> casesById = new Map<Id, Case>([
                SELECT Id, CaseNumber, Subject, OwnerId, ContactId
                FROM Case WHERE Id IN :caseIds
            ]);

            Integer totalCreatedThisJob = 0;
            Integer dmlChunk = 200;
            Integer targetPerCaseThisJob = 40; // smaller window to reduce CPU
            Integer maxRecordsThisJob = 4500; // global DML cap per job
            Integer safeCpuSoftStop = 8500;
            Integer safeCpuHardStop = 9500;
            List<Task> toInsert = new List<Task>();
            List<Id> remaining = new List<Id>();

            Date today = Date.today();

            for (Integer idx = 0; idx < caseIds.size(); idx++) {
                if (Limits.getCpuTime() > safeCpuSoftStop || totalCreatedThisJob >= maxRecordsThisJob) {
                    for (Integer j = idx; j < caseIds.size(); j++) remaining.add(caseIds[j]);
                    break;
                }

                Id cid = caseIds[idx];
                Case c = casesById.get(cid);
                if (c == null) continue;

                // Determine existing count of tasks for this Case
                Integer existing = [SELECT count() FROM Task WHERE WhatId = :cid];

                if (existing >= targetTasksPerCase) {
                    continue;
                }

                Integer toCreate = Math.min(targetPerCaseThisJob, targetTasksPerCase - existing);
                Integer startIdx = existing + 1;

                for (Integer i = 0; i < toCreate; i++) {
                    if (Limits.getCpuTime() > safeCpuHardStop || totalCreatedThisJob >= maxRecordsThisJob) break;

                    Integer n = startIdx + i;
                    Task t = new Task();
                    t.Status = 'Not Started';
                    t.Priority = 'Normal';
                    t.OwnerId = c.OwnerId; // align with Case owner
                    t.WhatId = c.Id;       // relate to Case
                    if (c.ContactId != null) t.WhoId = c.ContactId; // relate to Contact when present
                    t.Subject = 'Auto Task ' + n + ' for ' + (String.isBlank(c.CaseNumber) ? 'Case' : c.CaseNumber);
                    t.ActivityDate = today.addDays(Math.mod(n, 30)); // due date pattern
                    toInsert.add(t);
                    totalCreatedThisJob++;

                    if (toInsert.size() == dmlChunk) {
                        Database.insert(toInsert, false);
                        toInsert.clear();
                    }
                }

                // Not finished for this case yet
                if (existing + toCreate < targetTasksPerCase) {
                    remaining.add(cid);
                }

                if (totalCreatedThisJob >= maxRecordsThisJob || Limits.getCpuTime() > safeCpuSoftStop) {
                    for (Integer j = idx + 1; j < caseIds.size(); j++) remaining.add(caseIds[j]);
                    break;
                }
            }

            if (!toInsert.isEmpty()) {
                Database.insert(toInsert, false);
                toInsert.clear();
            }

            if (!remaining.isEmpty()) {
                System.enqueueJob(new CaseTasks_Q(remaining, targetTasksPerCase));
            }
        }
    }
}