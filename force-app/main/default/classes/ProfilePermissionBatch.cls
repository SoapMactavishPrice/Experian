global class ProfilePermissionBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    // 🔹 FULL PERMISSION LIST
    List<String> allPermissions = new List<String>{
        'PermissionsActivitiesAccess',
            'PermissionsAllowViewEditConvertedLeads',
            'PermissionsApiEnabled',
            'PermissionsCanUpdateEmailMessage',
            'PermissionsContentWorkspaces',
            'PermissionsConvertLeads',
            'PermissionsCreateCustomizeDashboards',
            'PermissionsCreateCustomizeFilters',
            'PermissionsCreateCustomizeReports',
            'PermissionsCreateDashboardFolders',
            'PermissionsCreateLtngTempFolder',
            'PermissionsCreateLtngTempInPub',
            'PermissionsCreateReportFolders',
            'PermissionsCreateReportInLightning',
            'PermissionsCreateWorkspaces',
            'PermissionsDeleteFieldHistory',
            'PermissionsEditBrandTemplates',
            'PermissionsEditEvent',
            'PermissionsEditHtmlTemplates',
            'PermissionsEditMyDashboards',
            'PermissionsEditMyReports',
            'PermissionsEditPublicFilters',
            'PermissionsEditTask',
            'PermissionsEmailMass',
            'PermissionsEmailSingle',
            'PermissionsEmailTemplateManagement',
            'PermissionsExportReport',
            'PermissionsImportLeads',
            'PermissionsInboundMigrationToolsUser',
            'PermissionsListEmailSend',
            'PermissionsManageCases',
            'PermissionsManageDashbdsInPubFolders',
            'PermissionsManageDynamicDashboards',
            'PermissionsManageLeads',
            'PermissionsManageLoginAccessPolicies',
            'PermissionsManagePvtRptsAndDashbds',
            'PermissionsManageReportsInPubFolders',
            'PermissionsManageRoles',
            'PermissionsManageSandboxes',
            'PermissionsManageUsers',
            'PermissionsMassInlineEdit',
            'PermissionsModifyAllData',
            'PermissionsNewReportBuilder',
            'PermissionsPreventClassicExperience',
            'PermissionsRunFlow',
            'PermissionsRunReports',
            'PermissionsScheduleJob',
            'PermissionsScheduleReports',
            'PermissionsSubscribeDashboardRolesGrps',
            'PermissionsSubscribeDashboardToOtherUsers',
            'PermissionsSubscribeReportRolesGrps',
            'PermissionsSubscribeReportsRunAsUser',
            'PermissionsSubscribeReportToOtherUsers',
            'PermissionsSubscribeToLightningDashboards',
            'PermissionsSubscribeToLightningReports',
            'PermissionsTransferAnyCase',
            'PermissionsTransferAnyEntity',
            'PermissionsTransferAnyLead',
            'PermissionsUpdateWithInactiveOwner',
            'PermissionsViewAllActivities',
            'PermissionsViewAllData',
            'PermissionsViewAllProfiles',
            'PermissionsViewAllUsers',
            'PermissionsViewMyTeamsDashboards',
            'PermissionsViewPublicDashboards',
            'PermissionsViewPublicReports',
            'PermissionsViewRoles',
            'PermissionsViewSetup'
            };
                
                List<String> validPermissions = new List<String>();
    Map<String, Id> permissionMasterMap = new Map<String, Id>();
    
    // 🔹 START
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        // Load Permission Master mapping
        for (Permission_Master__c pm : [
            SELECT Id, API_Name__c FROM Permission_Master__c
        ]) {
            permissionMasterMap.put(pm.API_Name__c, pm.Id);
        }
        
        // Validate fields (avoid query failure)
        Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.PermissionSet.fields.getMap();
        
        for (String fieldName : allPermissions) {
            if (fieldMap.containsKey(fieldName)) {
                validPermissions.add(fieldName);
            } else {
                System.debug('❌ Skipped invalid field: ' + fieldName);
            }
        }
        
        System.debug('✅ Valid Permissions Count: ' + validPermissions.size());
        
        // Build query with Profile.Name (IMPORTANT FIX)
        List<String> fields = new List<String>{'Id', 'Profile.Name'};
            fields.addAll(validPermissions);
        
        String query = 'SELECT ' + String.join(fields, ',') +
            ' FROM PermissionSet WHERE IsOwnedByProfile = TRUE';
        
        System.debug('🔥 FINAL QUERY: ' + query);
        
        return Database.getQueryLocator(query);
    }
    
    // 🔹 EXECUTE
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        
        List<Permission_Matrix__c> recordsToInsert = new List<Permission_Matrix__c>();
        
        for (SObject sob : scope) {
            
            // ✅ Get correct Profile Name
            String profileName = 'Unknown';
            
            SObject profileObj = sob.getSObject('Profile');
            if (profileObj != null) {
                profileName = (String) profileObj.get('Name');
            }
            
            for (String fieldName : validPermissions) {
                
                Boolean hasAccess = false;
                
                try {
                    Object val = sob.get(fieldName);
                    if (val != null) {
                        hasAccess = (Boolean) val;
                    }
                } catch (Exception e) {
                    continue;
                }
                
                // Only insert if permission exists in master
                if (permissionMasterMap.containsKey(fieldName)) {
                    
                    recordsToInsert.add(new Permission_Matrix__c(
                        Permission__c = permissionMasterMap.get(fieldName),
                        Profile_Name__c = profileName,
                        Has_Access__c = hasAccess
                    ));
                }
            }
        }
        
        if (!recordsToInsert.isEmpty()) {
            insert recordsToInsert;
            System.debug('🚀 Inserted Records: ' + recordsToInsert.size());
        } else {
            System.debug('⚠️ No records inserted');
        }
    }
    
    global void finish(Database.BatchableContext bc) {}
}