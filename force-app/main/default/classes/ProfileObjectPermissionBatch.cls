global class ProfileObjectPermissionBatch implements Database.Batchable<SObject> {
    
    // 🔹 START
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String baseQuery = 'SELECT ParentId, Parent.Profile.Name, SObjectType,' +
            ' PermissionsRead, PermissionsCreate, PermissionsEdit,' +
            ' PermissionsDelete, PermissionsViewAllRecords,' +
            ' PermissionsModifyAllRecords' +
            ' FROM ObjectPermissions WHERE Parent.IsOwnedByProfile = TRUE';
        
        // ✅ CRITICAL FIX: Limit records in test
        if (Test.isRunningTest()) {
            baseQuery += ' LIMIT 200';
        }
        
        return Database.getQueryLocator(baseQuery);
    }
    
    // 🔹 EXECUTE
    global void execute(Database.BatchableContext bc, List<ObjectPermissions> scope) {
        
        List<Object_Permission__c> recordsToInsert = new List<Object_Permission__c>();
        
        for (ObjectPermissions op : scope) {
            
            // ✅ Correct Profile Name (no ID issue)
            String profileName = 'Unknown';
            
            if (op.Parent != null && op.Parent.Profile != null) {
                profileName = op.Parent.Profile.Name;
            }
            
            String objectName = op.SObjectType;
            
            // 🔹 Add all permission types
            recordsToInsert.add(createRecord(profileName, objectName, 'Read', op.PermissionsRead));
            recordsToInsert.add(createRecord(profileName, objectName, 'Create', op.PermissionsCreate));
            recordsToInsert.add(createRecord(profileName, objectName, 'Edit', op.PermissionsEdit));
            recordsToInsert.add(createRecord(profileName, objectName, 'Delete', op.PermissionsDelete));
            recordsToInsert.add(createRecord(profileName, objectName, 'View All', op.PermissionsViewAllRecords));
            recordsToInsert.add(createRecord(profileName, objectName, 'Modify All', op.PermissionsModifyAllRecords));
        }
        
        if (!recordsToInsert.isEmpty()) {
            insert recordsToInsert;
        }
    }
    
    // 🔹 HELPER METHOD
    private Object_Permission__c createRecord(
        String profile,
        String obj,
        String permType,
        Boolean access
    ) {
        return new Object_Permission__c(
            Profile_Name__c = profile,
            Name = obj,
            Permission_Type__c = permType,
            Has_Access__c = access
        );
    }
    
    // 🔹 FINISH
    global void finish(Database.BatchableContext bc) {}
}