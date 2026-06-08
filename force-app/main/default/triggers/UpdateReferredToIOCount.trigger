trigger UpdateReferredToIOCount on Case (before update) {
    
    // Prevent recursion using static helper class
    if (TriggerHelper.processedCases == null) {
        TriggerHelper.processedCases = new Set<Id>();
    }
    
    // Mapping of referral count to owner assignment (Starts from 1)
    Map<Integer, Id> referralOwnerMap = new Map<Integer, Id>{
        2 => System.Label.Re_Presented_to_IO_1,
        3 => System.Label.Re_Presented_to_IO_2,
        4 => System.Label.Re_Presented_to_IO_3,
        5 => System.Label.Re_Presented_to_IO_4,
        6 => System.Label.Re_Presented_to_IO_5,
        7 => System.Label.Re_Presented_to_IO_6,
        8 => System.Label.Re_Presented_to_IO_7,
        9 => System.Label.Re_Presented_to_IO_8,
        10 => System.Label.Re_Presented_to_IO_9,
        11 => System.Label.Re_Presented_to_IO_10
    };
 
    // Mapping of referral count to corresponding date fields (Starts from 1)
    Map<Integer, String> referralDateMap = new Map<Integer, String>{
        2 => 'Re_Presented_to_IO_1_Date__c',
        3 => 'Re_Presented_to_IO_2_Date__c',
        4 => 'Re_Presented_to_IO_3_Date__c',
        5 => 'Re_Presented_to_IO_4_Date__c',
        6 => 'Re_Presented_to_IO_5_Date__c',
        7 => 'Re_Presented_to_IO_6_Date__c',
        8 => 'Re_Presented_to_IO_7_Date__c',
        9 => 'Re_Presented_to_IO_8_Date__c',
        10 => 'Re_Presented_to_IO_9_Date__c',
        11 => 'Re_Presented_to_IO_10_Date__c'
    };
 
    for (Case c : Trigger.new) {
        Case oldCase = Trigger.oldMap.get(c.Id);
        
        // Prevent duplicate processing in the same transaction
        if (TriggerHelper.processedCases.contains(c.Id)) { continue;
        }
        
        // Get the current count
        Integer currentCount = (c.Re_Referred_To_IO_Count__c != null) ? Integer.valueOf(c.Re_Referred_To_IO_Count__c) : 1;

        // **Run trigger logic ONLY if previous count was 1**
        if (oldCase.Re_Referred_To_IO_Count__c >= 1 && c.Referred_To_IO_Case__c == true && oldCase.Referred_To_IO_Case__c == false) {
            Integer newCount = currentCount + 1;
            
            // Ensure we don't exceed the mapped values (max 11 since initial is 1)
            if (newCount <= 11) {
                c.Re_Referred_To_IO_Count__c = Decimal.valueOf(newCount);
                c.OwnerId = referralOwnerMap.get(newCount) != null ? referralOwnerMap.get(newCount) : UserInfo.getUserId(); // Ensure OwnerId is never null
                c.Re_Referred_To_IO_By__c = UserInfo.getUserId(); // Update current user
                
                // Update the corresponding date field
                if (referralDateMap.containsKey(newCount)) {
                    c.put(referralDateMap.get(newCount), System.today());
                }
                
                // Mark the case as processed in this transaction
                TriggerHelper.processedCases.add(c.Id);
            }
        }
    }
}