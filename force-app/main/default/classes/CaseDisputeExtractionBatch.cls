global class CaseDisputeExtractionBatch implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    
    /* ================== START ================== */
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        /* ---- Step 1: Fetch EmailMessages (Today + Yesterday) ---- */
        Set<Id> caseIds = new Set<Id>();
        
        for (EmailMessage em : [
            SELECT ParentId, CcAddress
            FROM EmailMessage
            WHERE ParentId != null
            AND CreatedDate = LAST_N_DAYS:2
            AND (
                CcAddress LIKE '%loan_support@oolka.in%'
                OR CcAddress LIKE '%creditreport@zetapp.in%'
            )
        ]) {
            caseIds.add(em.ParentId);
        }
        
        /* ---- No matching emails → skip batch safely ---- */
        if (caseIds.isEmpty()) {
            return Database.getQueryLocator('SELECT Id FROM Case WHERE Id = null');
        }
        
        /* ---- Step 2: Query only matching Cases ---- */
        return Database.getQueryLocator([
            SELECT Id,
            Description,
            SuppliedEmail,
            Case_Category__c,
            Status,
            Displayed_Name__c,
            Displayed_Mobile_No__c,
            Displayed_Email_Id__c,
            Displayed_PAN_No__c,
            Dis_Ern__c,
            Dis_Uti__c,
            Displayed_Bank_Name__c,
            Displayed_Account_number__c,
            Displayed_Account_Type__c,
            Displayed_Account_Status__c,
            Displayed_Overdue_Amount__c,
            Displayed_Loan_Balance__c,
            Displayed_Account_Opening_Date__c,
            Account_Date_Reported__c,
            Sanctioned_Amount__c,
            Dispute_Detail__c,
            Desired_Resolution__c
            FROM Case
            WHERE Id IN :caseIds
            AND SuppliedEmail != null
            AND Case_Category__c = 'Consumer'
            AND Dis_Ern__c = null
            AND Status = 'Open'
            ORDER BY CreatedDate ASC
        ]);
    }
    
    /* ================== EXECUTE ================== */
    global void execute(Database.BatchableContext bc, List<Case> scope) {
        
        /* ---- Identify format per Case ---- */
        Map<Id, String> caseFormatMap = new Map<Id, String>();
        
        for (EmailMessage em : [
            SELECT ParentId, CcAddress
            FROM EmailMessage
            WHERE ParentId IN :scope
        ]) {
            if (em.CcAddress != null) {
                if (em.CcAddress.contains('loan_support@oolka.in')) {
                    caseFormatMap.put(em.ParentId, 'OOLKA');
                } else if (em.CcAddress.contains('creditreport@zetapp.in')) {
                    caseFormatMap.put(em.ParentId, 'ZET');
                }
            }
        }
        
        List<Case> updates = new List<Case>();
        
        for (Case c : scope) {
            if (String.isBlank(c.Description)) continue;
            
            String format = caseFormatMap.get(c.Id);
            if (format == 'OOLKA') {
                extractOolkaFormat(c);
            } else if (format == 'ZET') {
                extractZetFormat(c);
            }
            
            updates.add(c);
        }
        
        if (!updates.isEmpty()) {
            update updates;
        }
    }
    
    global void finish(Database.BatchableContext bc) {}
    
    /* ================== SCHEDULER ================== */
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CaseDisputeExtractionBatch(), 1);
    }
    
    /* =====================================================
================== OOLKA FORMAT =====================
===================================================== */
    private static void extractOolkaFormat(Case c) {
        
        String descpt = c.Description;
        
        Integer pdIndex = descpt.indexOf('Personal Details:');
        if (pdIndex != -1) {
            descpt = descpt.substring(pdIndex);
        }
        
        //c.Displayed_Name__c       = extractSingleLine(descpt, 'Full Name');
        String nameVal = extractSingleLine(descpt, 'Full Name');
        if (!isPlaceholder(nameVal)) {
            c.Displayed_Name__c = nameVal.trim();
        }
        
        //c.Displayed_Mobile_No__c  = extractSingleLine(descpt, 'Mobile Number');
        String mobile = extractSingleLine(descpt, 'Mobile Number');
        if (!isPlaceholder(mobile)) {
            c.Displayed_Mobile_No__c = mobile.trim();
        }
        
        //c.Displayed_PAN_No__c     = extractSingleLine(descpt, 'PAN');
        String pan = extractSingleLine(descpt, 'PAN');
        if (!isPlaceholder(pan)) {
            c.Displayed_PAN_No__c = pan.trim();
        }
        
        /*String ern = extractSingleLine(descpt, 'Latest Experian Credit Report (ERN)');
if (ern != null && !ern.toLowerCase().contains('please insert')) {
c.Dis_Ern__c = ern;
}*/
        
        String ernRaw = extractSingleLine(descpt, 'Latest Experian Credit Report (ERN)');
        if (!isPlaceholder(ernRaw)) {
            Pattern p = Pattern.compile('(17\\d{11})');
            Matcher m = p.matcher(ernRaw);
            if (m.find()) {
                c.Dis_Ern__c = m.group(1);
            }
        }
        
        
        /*String uti = extractSingleLine(descpt, 'UTI');
if (uti != null && !uti.toLowerCase().contains('please insert')) {
c.Dis_Uti__c = uti;
}*/
        
        String uti = extractSingleLine(descpt, 'UTI');
        if (!isPlaceholder(uti)) {
            c.Dis_Uti__c = uti.trim();
        }
        
        //c.Displayed_Bank_Name__c      = extractSingleLine(descpt, 'Lender Name');
        String bankRaw;
        Integer lenderIdx = descpt.indexOf('Lender Name:');
        if (lenderIdx != -1) {
            
            lenderIdx += 'Lender Name:'.length();
            Integer accIdx = descpt.indexOf('Account Number', lenderIdx);
            
            if (accIdx != -1 && accIdx > lenderIdx) {
                bankRaw = descpt.substring(lenderIdx, accIdx).trim();
            } else {
                bankRaw = descpt.substring(lenderIdx).trim();
            }
        }
        
        if (!isPlaceholder(bankRaw)) {
            while (
                bankRaw.endsWith(',') ||
                bankRaw.endsWith('(')
            ) {
                bankRaw = bankRaw.substring(0, bankRaw.length() - 1).trim();
            }
            c.Displayed_Bank_Name__c = bankRaw;
        }
        
        //c.Displayed_Account_number__c = extractSingleLine(descpt, 'Account Number');
        String accRaw = extractSingleLine(descpt, 'Account Number');
        
        if (!isPlaceholder(accRaw) && !accRaw.toLowerCase().contains('not available')) {
            
            String acc = accRaw.trim();
            Integer cutPos = acc.length();
            
            // Stop at first separator
            for (String sep : new List<String>{' ', '(', ')', ',', '-'}) {
                Integer idx = acc.indexOf(sep);
                if (idx != -1 && idx < cutPos) {
                    cutPos = idx;
                }
            }
            
            acc = acc.substring(0, cutPos).trim();
            
            // Must contain at least one digit
            if (acc.replaceAll('[^0-9]', '').length() > 0) {
                c.Displayed_Account_number__c = acc;
            }
        }
        
        c.Displayed_Account_Type__c   = extractSingleLine(descpt, 'Account Type');
        c.Displayed_Account_Status__c = extractSingleLine(descpt, 'Account Status');
        
        /* ---- Sanctioned Amount ---- */
        String sanc = extractSingleLine(descpt, 'Sanctioned Amount / Highest Credit Limit');
        if (sanc != null) {
            c.Sanctioned_Amount__c =
                sanc.replace('₹', '').replace(',', '').trim();
        }
        
        /* ---- Amount Overdue ---- */
        String overdue = extractSingleLine(descpt, 'Amount Overdue');
        if (overdue != null) {
            overdue = overdue.replace('₹','').replace(',','').trim();
            try { c.Displayed_Overdue_Amount__c = Decimal.valueOf(overdue); } catch (Exception e) {}
        }
        
        /* ---- Date Opened yyyyMMdd ---- */
        String opened = extractSingleLine(descpt, 'Date Opened');
        if (opened != null && opened.length() == 8) {
            try {
                c.Displayed_Account_Opening_Date__c =
                    Date.newInstance(
                        Integer.valueOf(opened.substring(0,4)),
                        Integer.valueOf(opened.substring(4,6)),
                        Integer.valueOf(opened.substring(6,8))
                    );
            } catch (Exception e) {}
        }
        
        /* ---- Issue: between Issue & Desired Resolution ---- */
        Integer issueIdx = descpt.indexOf('Issue:');
        Integer resIdx   = descpt.indexOf('Desired Resolution:');
        if (issueIdx != -1) {
            issueIdx += 6;
            c.Dispute_Detail__c =
                (resIdx != -1)
                ? descpt.substring(issueIdx, resIdx)
                : descpt.substring(issueIdx);
            c.Dispute_Detail__c =
                c.Dispute_Detail__c.replace('\n', ' ').trim();
        }
        
        /* ---- Desired Resolution: first sentence ---- */
        String res = extractMultiLine(descpt, 'Desired Resolution');
        if (res != null) {
            Integer dot = res.indexOf('.');
            if (dot != -1) res = res.substring(0, dot + 1);
            c.Desired_Resolution__c = res.trim();
        }
    }
    
    /* =====================================================
=================== ZET FORMAT ======================
===================================================== */
    private static void extractZetFormat(Case c) {
        
        String body = c.Description;
        
        Integer accIdx = body.indexOf('Account Details:');
        if (accIdx != -1) body = body.substring(accIdx);
        
        c.Displayed_Bank_Name__c      = extractSingleLine(body, 'Subscriber Name');
        c.Displayed_Account_number__c = extractSingleLine(body, 'Account Number');
        c.Displayed_Account_Type__c   = extractSingleLine(body, 'Account Type');
        c.Displayed_Account_Status__c = extractSingleLine(body, 'Account Status');
        
        /* ---- Date Reported yyyy-MM-dd ---- */
        String dr = extractSingleLine(body, 'Date Reported');
        if (dr != null) {
            try {
                List<String> p = dr.split('-');
                c.Account_Date_Reported__c =
                    Date.newInstance(
                        Integer.valueOf(p[0]),
                        Integer.valueOf(p[1]),
                        Integer.valueOf(p[2])
                    );
            } catch (Exception e) {}
        }
        
        /* ---- Credit Limit ---- */
        String cl = extractSingleLine(body, 'Credit Limit');
        if (cl != null) {
            c.Sanctioned_Amount__c =
                cl.replace('₹','').replace(',', '').trim();
        }
        
        
        /* ---- Current Balance ---- */
        String bal = extractSingleLine(body, 'Current Balance');
        if (bal != null) {
            bal = bal.replace('₹','').replace(',','').trim();
            try { c.Displayed_Loan_Balance__c = Decimal.valueOf(bal); } catch (Exception e) {}
        }
        
        /* ---- Dispute sentence after Current Balance ---- */
        Integer balLineEnd = body.indexOf('\n', body.indexOf('Current Balance:'));
        Integer repIdx = body.indexOf('Report Information:');
        
        if (balLineEnd != -1) {
            String dispute =
                (repIdx != -1 && repIdx > balLineEnd)
                ? body.substring(balLineEnd, repIdx)
                : body.substring(balLineEnd);
            
            c.Dispute_Detail__c =
                dispute.replace('\n', ' ')
                .replace('₹0', '')
                .trim();
        }
        
        c.Dis_Ern__c = extractSingleLine(body, 'Experian Reference Number (ERN)');
        
        String uti = extractSingleLine(body, 'Unique Transaction ID (UTI)');
        if (uti != null && !uti.contains('[UTI]')) {
            c.Dis_Uti__c = uti;
        }
        
        /* ---- Desired Resolution after Report Number ---- */
        Integer reportNoLineEnd =
            body.indexOf('\n', body.indexOf('Report Number:'));
        Integer sinIdx = body.indexOf('Sincerely,');
        
        if (reportNoLineEnd != -1) {
            String resolution =
                (sinIdx != -1 && sinIdx > reportNoLineEnd)
                ? body.substring(reportNoLineEnd, sinIdx)
                : body.substring(reportNoLineEnd);
            
            c.Desired_Resolution__c =
                resolution.replace('\n', ' ')
                .trim();
        }
        
        /* ---- Sign-off ---- */
        if (sinIdx != -1) {
            String sign = body.substring(sinIdx);
            c.Displayed_Name__c      = extractLineAfter(sign, 'Sincerely,');
            c.Displayed_Email_Id__c  = extractSingleLine(sign, 'Email');
            c.Displayed_Mobile_No__c = extractSingleLine(sign, 'Phone');
            c.Displayed_PAN_No__c    = extractSingleLine(sign, 'PAN');
        }
    }
    
    /* ================== HELPERS ================== */
    private static String extractSingleLine(String body, String label) {
        String v = extractRaw(body, label);
        if (v != null && v.contains('\n')) v = v.substring(0, v.indexOf('\n'));
        return v != null ? v.trim() : null;
    }
    
    private static String extractMultiLine(String body, String label) {
        String v = extractRaw(body, label);
        return v != null ? v.trim() : null;
    }
    
    private static String extractRaw(String body, String label) {
        String token = label + ':';
        Integer s = body.indexOf(token);
        if (s == -1) return null;
        s += token.length();
        Integer e = body.indexOf('\n', s);
        if (e == -1) e = body.length();
        return body.substring(s, e).trim();
    }
    
    private static String extractLineAfter(String body, String marker) {
        Integer i = body.indexOf(marker);
        if (i == -1) return null;
        i += marker.length();
        String s = body.substring(i).trim();
        return s.contains('\n') ? s.substring(0, s.indexOf('\n')).trim() : s;
    }
    private static Boolean isPlaceholder(String val) {
        return String.isBlank(val)
            || val.contains('[')
            || val.contains(']')
            || val.contains('{')
            || val.contains('}');
    }    
}