trigger CaseIOQueueRestrictionTrigger on Case (before update) {

    /* =========================
       STEP 1: Get current user
       ========================= */

    Id currentUserId = UserInfo.getUserId();

    // Query allowed user by Username (NOT email logic)
    User allowedUser = [
        SELECT Id
        FROM User
        //WHERE Username = 'santosh.govardhan@experian.com.onexp'
        WHERE Username = 'santosh.govardhan@experian.com'
        LIMIT 1
    ];

    // If allowed user, bypass all validations
    if (allowedUser != null && currentUserId == allowedUser.Id) {
        return;
    }

    /* =========================
       STEP 2: IO Queue Names
       ========================= */

    Set<String> ioQueueNames = new Set<String>{
        'Referred_To_IO',
        'Re_Presented_to_IO_1',
        'Re_Presented_to_IO_2',
        'Re_Presented_to_IO_3',
        'Re_Presented_to_IO_4',
        'Re_Presented_to_IO_5',
        'Re_Presented_to_IO_6',
        'Re_Presented_to_IO_7',
        'Re_Presented_to_IO_8',
        'Re_Presented_to_IO_9',
        'Re_Presented_to_IO_10'
    };

    /* =========================
       STEP 3: Query Queue IDs
       ========================= */

    Set<Id> ioQueueIds = new Set<Id>();

    for (Group g : [
        SELECT Id
        FROM Group
        WHERE Type = 'Queue'
        AND DeveloperName IN :ioQueueNames
    ]) {
        ioQueueIds.add(g.Id);
    }

    /* =========================
       STEP 4: Validate Cases
       ========================= */

    for (Case c : Trigger.new) {

         Case oldCase = Trigger.oldMap.get(c.Id);

        /* =========================================
        NEW CONDITION:
        Skip validation when checkbox changes
        from FALSE → TRUE
        ========================================= */

        if ( oldCase.Referred_To_IO_Case__c == false && c.Referred_To_IO_Case__c == true) {
            continue;
        }

        Id oldOwnerId = Trigger.oldMap.get(c.Id).OwnerId;
        Id newOwnerId = c.OwnerId;

        Boolean oldIsIOQueue = ioQueueIds.contains(oldOwnerId);
        Boolean newIsIOQueue = ioQueueIds.contains(newOwnerId);

        // Block if Case is or was owned by IO Queue
        if (oldIsIOQueue || newIsIOQueue) {
            c.addError(
                'This Case cannot be edited because it is associated with IO Queue ownership.'
            );
        }
    }
}