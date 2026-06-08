public class AccountBounceEmailHandler {

    private static final Set<String> EMAIL_FIELDS = new Set<String>{
        'DA_Level_1_Email_1__c',
        'DA_Level_1_Email_10__c',
        'DA_Level_1_Email_2__c',
        'DA_Level_1_Email_3__c',
        'DA_Level_1_Email_4__c',
        'DA_Level_1_Email_5__c',
        'DA_Level_1_Email_6__c',
        'DA_Level_1_Email_7__c',
        'DA_Level_1_Email_8__c',
        'DA_Level_1_Email_9__c',

        'DA_Level_2_Email_1__c',
        'DA_Level_2_Email_10__c',
        'DA_Level_2_Email_2__c',
        'DA_Level_2_Email_3__c',
        'DA_Level_2_Email_4__c',
        'DA_Level_2_Email_5__c',
        'DA_Level_2_Email_6__c',
        'DA_Level_2_Email_7__c',
        'DA_Level_2_Email_8__c',
        'DA_Level_2_Email_9__c',

        'DA_Level_3_Email_1__c',
        'DA_Level_3_Email_10__c',
        'DA_Level_3_Email_2__c',
        'DA_Level_3_Email_3__c',
        'DA_Level_3_Email_4__c',
        'DA_Level_3_Email_5__c',
        'DA_Level_3_Email_6__c',
        'DA_Level_3_Email_7__c',
        'DA_Level_3_Email_8__c',
        'DA_Level_3_Email_9__c',

        'DQR_DQI_Email_1__c',
        'DQR_DQI_Email_10__c',
        'DQR_DQI_Email_11__c',
        'DQR_DQI_Email_12__c',
        'DQR_DQI_Email_13__c',
        'DQR_DQI_Email_14__c',
        'DQR_DQI_Email_15__c',
        'DQR_DQI_Email_16__c',
        'DQR_DQI_Email_17__c',
        'DQR_DQI_Email_18__c',
        'DQR_DQI_Email_19__c',
        'DQR_DQI_Email_2__c',
        'DQR_DQI_Email_20__c',
        'DQR_DQI_Email_21__c',
        'DQR_DQI_Email_22__c',
        'DQR_DQI_Email_23__c',
        'DQR_DQI_Email_24__c',
        'DQR_DQI_Email_25__c',
        'DQR_DQI_Email_3__c',
        'DQR_DQI_Email_4__c',
        'DQR_DQI_Email_5__c',
        'DQR_DQI_Email_6__c',
        'DQR_DQI_Email_7__c',
        'DQR_DQI_Email_8__c',
        'DQR_DQI_Email_9__c',

        'Form_C_Level_1_Email_1__c',
        'Form_C_Level_1_Email_10__c',
        'Form_C_Level_1_Email_11__c',
        'Form_C_Level_1_Email_12__c',
        'Form_C_Level_1_Email_13__c',
        'Form_C_Level_1_Email_14__c',
        'Form_C_Level_1_Email_15__c',
        'Form_C_Level_1_Email_16__c',
        'Form_C_Level_1_Email_2__c',
        'Form_C_Level_1_Email_3__c',
        'Form_C_Level_1_Email_4__c',
        'Form_C_Level_1_Email_5__c',
        'Form_C_Level_1_Email_6__c',
        'Form_C_Level_1_Email_7__c',
        'Form_C_Level_1_Email_8__c',
        'Form_C_Level_1_Email_9__c',

        'Form_C_Level_2_Email_1__c',
        'Form_C_Level_2_Email_2__c',
        'Form_C_Level_2_Email_3__c',
        'Form_C_Level_2_Email_4__c',
        'Form_C_Level_2_Email_5__c',

        'Form_C_Level_3_Email_1__c',
        'Form_C_Level_3_Email_2__c',
        'Form_C_Level_3_Email_3__c',
        'Form_C_Level_3_Email_4__c',
        'Form_C_Level_3_Email_5__c',

        'Temp_NO__c'
    };

    public static void removeBouncedEmails(List<Account> newAccounts) {

        for(Account acc : newAccounts) {

            if(String.isBlank(acc.Bounced_Email__c)) {
                continue;
            }

            Set<String> bouncedEmails = new Set<String>();

            for(String email : acc.Bounced_Email__c.split(';')) {
                if(String.isNotBlank(email)) {
                    bouncedEmails.add(email.trim().toLowerCase());
                }
            }

            for(String fieldName : EMAIL_FIELDS) {

                Object fieldValueObj = acc.get(fieldName);

                if(fieldValueObj == null) {
                    continue;
                }

                String fieldValue = String.valueOf(fieldValueObj).trim().toLowerCase();

                if(bouncedEmails.contains(fieldValue)) {
                    acc.put(fieldName, null);
                }
            }
        }
    }
}