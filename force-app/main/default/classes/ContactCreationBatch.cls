global class ContactCreationBatch implements Database.Batchable<sobject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'SELECT Id, Name, ContactCreationBatch__c, Grievances_Nodal_Officer_Name__c, Grievances_Nodal_Officer_Email__c, Grievances_Nodal_Officer_Phone__c, ' +
            'Technology_Contact_Email__c, Technology_Contact_Phone__c, Technology_Contact_Name__c, ' +
            'Person_Name_Dispute__c, Person_Name_2__c, Person_Name_3__c, Person_Name_4__c, Person_Name_5__c, Person_Name_6__c, ' +
            'Person_Name_7__c, Person_Name_8__c, Person_Name_9__c, Person_Name_10__c, ' +
            'Email_1_Dispute__c, Email_2_Dispute__c, Email_3_Dispute__c, Email_4_Dispute__c, Email_5_Dispute__c, Email_6_Dispute__c, ' +
            'Email_7_Dispute__c, Email_8_Dispute__c, Email_9_Dispute__c, Email_10_Dispute__c, ' +
            'Phone_1__c, Phone_2__c, Phone_3__c, Phone_4__c, Phone_5__c, Phone_6__c, Phone_7__c, Phone_8__c, Phone_9__c, Phone_10__c, ' +
            'Nodal_Officer_Name__c, Nodal_Officer_Phone__c, Nodal_Officer_Email__c, Authorized_Signatory_Email__c, ' +
            'Authorized_Signatory_Name__c, Authorized_Signatory_Phone__c, ' +
            'Change_Dispute_Detail_1__c, Change_Dispute_Detail_2__c, Change_Dispute_Detail_3__c, Change_Dispute_Detail_4__c, Change_Dispute_Detail_5__c, ' +
            'Change_Dispute_Detail_6__c, Change_Dispute_Detail_7__c, Change_Dispute_Detail_8__c, Change_Dispute_Detail_9__c, Change_Dispute_Detail_10__c, ' +
            'Temp_Nodal_Officer_Name__c, Temp_Authorized_Signatory_Email__c, Temp_Authorized_Signatory_Name__c, Temp_Authorized_Signatory_Phone__c, ' +
            'Temp_Nodal_Officer_Email__c, Temp_Nodal_Officer_Phone__c, ' +
            'DQR_DQI_Email_1__c, DQR_DQI_Email_2__c, DQR_DQI_Email_3__c, DQR_DQI_Email_4__c, DQR_DQI_Email_5__c, DQR_DQI_Email_6__c, DQR_DQI_Email_7__c, ' +
            'DQR_DQI_Email_8__c, DQR_DQI_Email_9__c, DQR_DQI_Email_10__c, DQR_DQI_Email_11__c, DQR_DQI_Email_12__c, DQR_DQI_Email_13__c, ' +
            'DQR_DQI_Email_14__c, DQR_DQI_Email_15__c, DQR_DQI_Email_16__c, DQR_DQI_Email_17__c, DQR_DQI_Email_18__c, DQR_DQI_Email_19__c, ' +
            'DQR_DQI_Email_20__c, DQR_DQI_Email_21__c, DQR_DQI_Email_22__c, DQR_DQI_Email_23__c, DQR_DQI_Email_24__c, DQR_DQI_Email_25__c, ' +
            'Form_C_Level_1_Email_1__c, Form_C_Level_1_Email_2__c, Form_C_Level_1_Email_3__c, Form_C_Level_1_Email_4__c, Form_C_Level_1_Email_5__c, ' +
            'Form_C_Level_1_Email_6__c, Form_C_Level_1_Email_7__c, Form_C_Level_1_Email_8__c, Form_C_Level_1_Email_9__c, Form_C_Level_1_Email_10__c, ' +
            'Form_C_Level_1_Email_11__c, Form_C_Level_1_Email_12__c, Form_C_Level_1_Email_13__c, Form_C_Level_1_Email_14__c, Form_C_Level_1_Email_15__c, ' +
            'Form_C_Level_2_Email_1__c, Form_C_Level_2_Email_2__c, Form_C_Level_2_Email_3__c, Form_C_Level_2_Email_4__c, Form_C_Level_2_Email_5__c, ' +
            'Form_C_Level_3_Email_1__c, Form_C_Level_3_Email_2__c, Form_C_Level_3_Email_3__c, Form_C_Level_3_Email_4__c, Form_C_Level_3_Email_5__c, ' +
            'Billing_Contact_Email__c, Billing_Contact_Name__c, Billing_Contact_Phone__c, ' +
            'Dispute_Email_1__c, Dispute_Email_2__c, Dispute_Email_3__c, Dispute_Email_4__c, Dispute_Email_5__c, Dispute_Email_6__c, ' +
            'Dispute_Email_7__c, Dispute_Email_8__c, Dispute_Email_9__c, Dispute_Email_10__c, Dispute_Email_11__c, Dispute_Email_12__c, ' +
            'Dispute_Email_13__c, Dispute_Email_14__c, Dispute_Email_15__c, ' +
            'OLM_Email_1__c, OLM_Email_2__c, OLM_Email_3__c, OLM_Email_4__c, OLM_Email_5__c, OLM_Email_6__c, OLM_Email_7__c, OLM_Email_8__c, ' +
            'OLM_Email_9__c, OLM_Email_10__c, OLM_Email_11__c, OLM_Email_12__c, OLM_Email_13__c, OLM_Email_14__c, OLM_Email_15__c, ' +
            'OLM_Email_16__c, OLM_Email_17__c, OLM_Email_18__c, OLM_Email_19__c, OLM_Email_20__c, ' +
            'OLM_Email_21__c, OLM_Email_22__c, OLM_Email_23__c, OLM_Email_24__c, OLM_Email_25__c, ' +
            'OLM_Email_26__c, OLM_Email_27__c, OLM_Email_28__c, OLM_Email_29__c, OLM_Email_30__c, ' +
            'OLM_Email_31__c, OLM_Email_32__c, OLM_Email_33__c, OLM_Email_34__c, OLM_Email_35__c, ' +
            'OLM_Email_36__c, OLM_Email_37__c, OLM_Email_38__c, OLM_Email_39__c, OLM_Email_40__c, ' +
            'CC_Address_1__c,CC_Address_2__c,CC_Address_3__c, CC_Address_4__c, CC_Address_5__c,'+ 
            'CC_Address_6__c, CC_Address_7__c, CC_Address_8__c, CC_Address_9__c, CC_Address_10__c ' +
            
            'FROM Account ' +
            'WHERE ContactCreationBatch__c = true AND RecordType.Name = \'Customer\' ' +
            'ORDER BY CreatedDate DESC';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC , List<Account>Scope){
        
        List<Contact> conListToInsert = new List<Contact>();
        system.debug('Scope-->'+Scope.size());
        
        for(Account acc: Scope){
            
            if(string.isNotBlank(acc.Email_1_Dispute__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Email_1_Dispute__c;
                con.Contact_Role__c = 'Dispute Resolution Officer Primary';
                con.LastName = acc.Person_Name_Dispute__c!=null && acc.Person_Name_Dispute__c!=''?acc.Person_Name_Dispute__c:'.' ;
                con.Phone = acc.Phone_1__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Email_2_Dispute__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Email_2_Dispute__c;
                con.Contact_Role__c = 'Dispute Resolution Officer Primary';
                con.LastName = acc.Person_Name_2__c!=null && acc.Person_Name_2__c!=''?acc.Person_Name_2__c:'.' ;
                con.Phone = acc.Phone_2__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Email_3_Dispute__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Email_3_Dispute__c;
                con.Contact_Role__c = 'Dispute Resolution Officer Primary';
                con.LastName = acc.Person_Name_3__c!=null && acc.Person_Name_3__c!=''?acc.Person_Name_3__c:'.' ;
                con.Phone = acc.Phone_3__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Email_4_Dispute__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Email_4_Dispute__c;
                con.Contact_Role__c = 'Dispute Resolution Officer Primary';
                con.LastName = acc.Person_Name_4__c!=null && acc.Person_Name_4__c!=''?acc.Person_Name_4__c:'.' ;
                con.Phone = acc.Phone_4__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Email_5_Dispute__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Email_5_Dispute__c;
                con.Contact_Role__c = 'Dispute Resolution Officer Primary';
                con.LastName = acc.Person_Name_5__c!=null && acc.Person_Name_5__c!=''?acc.Person_Name_5__c:'.' ;
                con.Phone = acc.Phone_5__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Email_6_Dispute__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Email_6_Dispute__c;
                con.Contact_Role__c = 'Dispute Resolution Officer Primary';
                con.LastName = acc.Person_Name_6__c!=null && acc.Person_Name_6__c!=''?acc.Person_Name_6__c:'.' ;
                con.Phone = acc.Phone_6__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Email_7_Dispute__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Email_7_Dispute__c;
                con.Contact_Role__c = 'Dispute Resolution Officer Primary';
                con.LastName = acc.Person_Name_7__c!=null && acc.Person_Name_7__c!=''?acc.Person_Name_7__c:'.' ;
                con.Phone = acc.Phone_7__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Email_8_Dispute__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Email_8_Dispute__c;
                con.Contact_Role__c = 'Dispute Resolution Officer Primary';
                con.LastName = acc.Person_Name_8__c!=null && acc.Person_Name_8__c!=''?acc.Person_Name_8__c:'.' ;
                con.Phone = acc.Phone_8__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Email_9_Dispute__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Email_9_Dispute__c;
                con.Contact_Role__c = 'Dispute Resolution Officer Primary';
                con.LastName = acc.Person_Name_9__c!=null && acc.Person_Name_9__c!=''?acc.Person_Name_9__c:'.' ;
                con.Phone = acc.Phone_9__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Email_10_Dispute__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Email_10_Dispute__c;
                con.Contact_Role__c = 'Dispute Resolution Officer Primary';
                con.LastName = acc.Person_Name_10__c!=null && acc.Person_Name_10__c!=''?acc.Person_Name_10__c:'.' ;
                con.Phone = acc.Phone_10__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Grievances_Nodal_Officer_Email__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Grievances_Nodal_Officer_Email__c;
                con.Contact_Role__c = 'Grievance Nodal Officer (GNO)';
                con.LastName = acc.Grievances_Nodal_Officer_Name__c!=null && acc.Grievances_Nodal_Officer_Name__c!=''?acc.Grievances_Nodal_Officer_Name__c:'.' ;
                con.Phone = acc.Grievances_Nodal_Officer_Phone__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Technology_Contact_Email__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Technology_Contact_Email__c;
                con.Contact_Role__c = 'Technology Team Primary';
                con.LastName = acc.Technology_Contact_Name__c!=null && acc.Technology_Contact_Name__c!=''?acc.Technology_Contact_Name__c:'.' ;
                con.Phone = acc.Technology_Contact_Phone__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Billing_Contact_Email__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Billing_Contact_Email__c;
                con.Contact_Role__c = 'Billing Primary';
                con.LastName = acc.Billing_Contact_Name__c!=null && acc.Billing_Contact_Name__c!=''?acc.Billing_Contact_Name__c:'.' ;
                con.Phone = acc.Billing_Contact_Phone__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Authorized_Signatory_Email__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Authorized_Signatory_Email__c;
                con.Contact_Role__c = 'Authorized Signatory';
                con.LastName = acc.Authorized_Signatory_Name__c!=null && acc.Authorized_Signatory_Name__c!=''?acc.Authorized_Signatory_Name__c:'.' ;
                con.Phone = acc.Authorized_Signatory_Phone__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Nodal_Officer_Email__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.Nodal_Officer_Email__c;
                con.Contact_Role__c = 'Nodal Officer (NO)';
                con.LastName = acc.Nodal_Officer_Name__c!=null && acc.Nodal_Officer_Name__c!=''?acc.Nodal_Officer_Name__c:'.' ;
                con.Phone = acc.Nodal_Officer_Phone__c;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.DQR_DQI_Email_1__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_1__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.DQR_DQI_Email_2__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_2__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_3__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_3__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_4__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_4__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_5__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_5__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_6__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_6__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_7__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_7__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_8__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_8__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_9__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_9__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_10__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_10__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_11__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_11__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_12__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_12__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_13__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_13__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_14__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_14__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_15__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_15__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_16__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_16__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_17__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_17__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_18__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_18__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_19__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_19__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_20__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_20__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_21__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_21__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_22__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_22__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_23__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_23__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_24__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_24__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.DQR_DQI_Email_25__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Email = acc.DQR_DQI_Email_25__c;
                con.Contact_Role__c = 'DQR Primary';
                con.LastName = '.';
                con.Phone = null;
                
                conListToInsert.add(con);
            } 
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_1__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_1__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_2__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_2__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_3__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_3__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_4__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_4__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_5__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_5__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_6__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_6__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_7__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_7__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_8__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_8__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_9__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_9__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_10__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_10__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_11__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_11__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_12__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_12__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_13__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_13__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_14__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_14__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_1_Email_15__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Primary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_1_Email_15__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_2_Email_1__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Secondary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_2_Email_1__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_2_Email_2__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Secondary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_2_Email_2__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_2_Email_3__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Secondary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_2_Email_3__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_2_Email_4__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Secondary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_2_Email_4__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_2_Email_5__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Secondary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_2_Email_5__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_3_Email_1__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Secondary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_3_Email_1__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_3_Email_2__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Secondary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_3_Email_2__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_3_Email_3__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Secondary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_3_Email_3__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_3_Email_4__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Secondary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_3_Email_4__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.Form_C_Level_3_Email_5__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Form C Secondary';
                con.LastName = '.' ;
                con.Email = acc.Form_C_Level_3_Email_5__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.OLM_Email_1__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_1__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_2__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_2__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_3__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_3__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_4__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_4__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_5__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_5__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_6__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_6__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_7__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_7__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_8__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_8__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_9__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_9__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_10__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_10__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_11__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_11__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_12__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_12__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_13__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_13__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_14__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_14__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_15__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_15__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_16__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_16__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_17__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_18__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_19__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_19__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_20__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_20__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_21__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_21__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_22__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_22__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_23__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_23__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_24__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_24__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_25__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_25__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_26__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_26__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_27__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_27__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_28__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_28__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_29__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_29__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_30__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_30__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_31__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_32__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_32__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_32__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_33__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_33__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_34__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_34__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_35__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_35__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_36__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_36__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_37__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_37__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_38__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_38__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_39__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_39__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.OLM_Email_40__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'OLM Primary';
                con.LastName = '.' ;
                con.Email = acc.OLM_Email_40__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            
            if(string.isNotBlank(acc.CC_Address_1__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Dispute Resolution Officer Secondary';
                con.LastName = '.' ;
                con.Email = acc.CC_Address_1__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.CC_Address_2__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Dispute Resolution Officer Secondary';
                con.LastName = '.' ;
                con.Email = acc.CC_Address_2__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.CC_Address_3__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Dispute Resolution Officer Secondary';
                con.LastName = '.' ;
                con.Email = acc.CC_Address_3__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.CC_Address_4__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Dispute Resolution Officer Secondary';
                con.LastName = '.' ;
                con.Email = acc.CC_Address_4__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.CC_Address_5__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Dispute Resolution Officer Secondary';
                con.LastName = '.' ;
                con.Email = acc.CC_Address_5__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.CC_Address_6__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Dispute Resolution Officer Secondary';
                con.LastName = '.' ;
                con.Email = acc.CC_Address_6__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.CC_Address_7__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Dispute Resolution Officer Secondary';
                con.LastName = '.' ;
                con.Email = acc.CC_Address_7__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.CC_Address_8__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Dispute Resolution Officer Secondary';
                con.LastName = '.' ;
                con.Email = acc.CC_Address_8__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.CC_Address_9__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Dispute Resolution Officer Secondary';
                con.LastName = '.' ;
                con.Email = acc.CC_Address_9__c;
                con.Phone = null;
                conListToInsert.add(con);
            }
            if(string.isNotBlank(acc.CC_Address_10__c)){
                Contact con = new Contact();
                con.AccountId = acc.Id;
                con.Contact_Role__c = 'Dispute Resolution Officer Secondary';
                con.LastName = '.' ;
                con.Email = acc.CC_Address_10__c;
                con.Phone = null;
                conListToInsert.add(con);
            }            
        }
        
        if(conListToInsert.size() > 0){
            database.insert(conListToInsert,false);
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}