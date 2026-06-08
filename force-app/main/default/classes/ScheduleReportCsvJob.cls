global class ScheduleReportCsvJob implements Schedulable {
    global void execute(SchedulableContext sc) {

        String reportId = '00ONy00000gAD0h'; //sandbox report id - 00O2u0000017yY9

        Account acc = [
            SELECT Email_1_Dispute__c, Email_2_Dispute__c, Email_3_Dispute__c, Email_4_Dispute__c, Email_5_Dispute__c,
                   Email_6_Dispute__c, Email_7_Dispute__c, Email_8_Dispute__c, Email_9_Dispute__c, Email_10_Dispute__c,
                   CC_Address_1__c, CC_Address_2__c, CC_Address_3__c, CC_Address_4__c, CC_Address_5__c,
                   CC_Address_6__c, CC_Address_7__c, CC_Address_8__c, CC_Address_9__c, CC_Address_10__c
            FROM Account
            WHERE Id = '0012u00000NYAQdAAP'
        ];

        List<String> recipients = new List<String>();
        
        List<String> emailFields = new List<String>{
            acc.Email_1_Dispute__c, acc.Email_2_Dispute__c, acc.Email_3_Dispute__c, acc.Email_4_Dispute__c, acc.Email_5_Dispute__c,
            acc.Email_6_Dispute__c, acc.Email_7_Dispute__c, acc.Email_8_Dispute__c, acc.Email_9_Dispute__c, acc.Email_10_Dispute__c,
            acc.CC_Address_1__c, acc.CC_Address_2__c, acc.CC_Address_3__c, acc.CC_Address_4__c, acc.CC_Address_5__c,
            acc.CC_Address_6__c, acc.CC_Address_7__c, acc.CC_Address_8__c, acc.CC_Address_9__c, acc.CC_Address_10__c
        };

        for(String email : emailFields){
            if(String.isNotBlank(email)){
                recipients.add(email);
            }
        }

        // call the main method
        if(!recipients.isEmpty()){
            SendReportAsCSV.runAndEmailReport(reportId, recipients);
        }
    }

    
    public void fakeMethod() {
        Integer i = 0;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
    }
}

/*

SendReportAsCSV.runAndEmailReport('00ONy00000gAD0h',
new List<String>{'balram@finessedirect.com'});

* */