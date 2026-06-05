trigger LeadConverter on Lead(before insert, before update, after update) {
    
    Set<Id> stconIdtodelete = new Set<Id>();
    List <Contact> conList = new List <Contact> (); 
    List <Lead> leadList = new List <Lead> ();
    List<Case> caseList = new List<Case>();
    Map<Id, Id> MapLeadId_accId = new Map<Id, Id> (); 
    List<contact> convertedconto_update = new List<Contact> ();
    
    /*if(Trigger.isBefore && Trigger.isUpdate) {
      
        for(Lead l : Trigger.new) {
        
            if(l.isConverted) {
             
                if(l.Executive_Verified_Documents__c == false && l.TL_Verified_Documents__c == false  && l.Admin_Verified_Documents__c == false)
                    l.addError('Please verify Executive Verified Documents , TL Verified Documentsa and Admin Verified Documents');
                if(l.Executive_Verified_Documents__c == false && l.TL_Verified_Documents__c == false)
                    l.addError('Please verify Executive Verified Documents and TL Verified Documents');
                if(l.Executive_Verified_Documents__c == false && l.Admin_Verified_Documents__c == false)
                    l.addError('Please verify Executive Verified Documents and Admin Verified Documents');
                if(l.TL_Verified_Documents__c == false && l.Admin_Verified_Documents__c == false)
                    l.addError('Please verify TL Verified Documents and Admin Verified Documents');
                if(l.Executive_Verified_Documents__c == false)
                    l.addError('Please verify Executive Verified Documents');
                if(l.TL_Verified_Documents__c == false)
                    l.addError('Please verify TL Verified Documents');
                if(l.Admin_Verified_Documents__c == false)
                    l.addError('Please verify Admin Verified Documents');
                if(l.Checked_in_NBFC_List__c != 'Yes')
                    l.Checked_in_NBFC_List__c.addError('Checked in RBI List required before converting the lead');
                if(l.Checked_in_Termination_List__c != 'Yes')
                    l.Checked_in_Termination_List__c.addError('Checked in Termination List required before converting the lead');
                if(String.isBlank(String.valueOf(l.Total_Payment_Received__c)))
                    l.Total_Payment_Received__c.addError('Total Payment Received required before converting the lead');
                if(String.isBlank(l.Mode_of_Transaction__c))
                    l.Mode_of_Transaction__c.addError('Mode of Transaction required before converting the lead');
                if(String.isBlank(String.valueOf(l.Payment_Date_Time__c)))
                    l.Payment_Date_Time__c.addError('Payment Date & Time required before converting the lead');
                if(String.isNotBlank(l.Agreement_Experian_Status__c)) {
                    if(l.Agreement_Experian_Status__c.toLowerCase() != 'signed')
                        l.Agreement_Experian_Status__c.addError('Agreement Experian Status/ Stages required before converting the lead');
                }
                if(String.isNotBlank(l.Agreement_Customer_Status_Stages__c)) {
                    if(l.Agreement_Customer_Status_Stages__c.toLowerCase() != 'signed')
                        l.Agreement_Customer_Status_Stages__c.addError('Agreement Customer Status/Stages required before converting the lead');
                }
            }
        }
    }*/
    
    if(Trigger.isAfter && Trigger.isUpdate) {
       
        for (Lead l: Trigger.new) {
                        
            if(l.ConvertedContactId != null){ 
                stconIdtodelete.add(l.ConvertedContactId);
            }
                    
            if (l.IsConverted && l.ConvertedAccountId != null){ 
                
                MapLeadId_accId.put(l.Id, l.ConvertedAccountId );
                
                if(l.Authorised_Signatory_Same_As_Nodal_Offic__c == true){
                    
                    Contact cn = new Contact();
                    cn.AccountId = l.ConvertedAccountId;
                    cn.Title = l.Job_Title_Nodal__c;
                    cn.FirstName = l.First_Name_Nodal__c; 
                    cn.LastName = l.Last_Name_Nodal__c;
                    cn.Phone = l.Tel_No_Nodal__c;
                    cn.Fax = l.Fax_No_Nodal__c;
                    cn.Contact_Role__c = 'Nodal Officer';
                    cn.Contact_on_lead_conversion__c = true;
                    cn.Email = l.Official_Email_Address_Nodal__c;
                    cn.Auth_signatory_same_as_Nodal_officer__c = true;
                    conList.add(cn);   
                    
                    Contact co = new Contact();
                    co.AccountId = l.ConvertedAccountId;
                    co.Title = l.Job_Title_AuSig__c;
                    co.FirstName = l.First_Name_AuSig__c;
                    co.LastName = l.Last_Name_AuSig__c;
                    co.Phone = l.Tel_No_AuSig__c;
                    co.Fax = l.Fax_No_AuSig__c;
                    co.Contact_Role__c = 'Authorized Signatory';
                    co.Contact_on_lead_conversion__c = true;
                    co.Email = l.Official_Email_Address_AuSig__c;
                    conList.add(co);
                }
                
                if(l.Authorised_Signatory_Same_As_Nodal_Offic__c == false){
                    Contact cn = new Contact();
                    cn.AccountId = l.ConvertedAccountId;
                    cn.Title = l.Job_Title_Nodal__c;
                    cn.FirstName = l.First_Name_Nodal__c;
                    cn.LastName = l.Last_Name_Nodal__c;
                    cn.Phone = l.Tel_No_Nodal__c;
                    cn.Fax = l.Fax_No_Nodal__c;
                    cn.Contact_Role__c = 'Nodal Officer';
                    cn.Contact_on_lead_conversion__c = true;
                    cn.Email = l.Official_Email_Address_Nodal__c;
                    conList.add(cn);  
                    
                    Contact co = new Contact();
                    co.AccountId = l.ConvertedAccountId;
                    co.Title = l.Job_Title_AuSig__c;
                    co.FirstName = l.First_Name_AuSig__c;
                    co.LastName = l.Last_Name_AuSig__c;
                    co.Phone = l.Tel_No_AuSig__c;
                    co.Fax = l.Fax_No_AuSig__c;
                    co.Contact_Role__c = 'Authorized Signatory';
                    co.Contact_on_lead_conversion__c = true;
                    co.Email = l.Official_Email_Address_AuSig__c;
                    conList.add(co);
                }  
                
                Contact cow1 = new Contact();
                cow1.AccountId = l.ConvertedAccountId;
                cow1.Title = l.Job_Title_Auth_Usr_Req__c;
                cow1.FirstName = l.First_Name_Auth_Usr_Req__c;
                cow1.LastName = l.Last_Name_Auth_Usr_Req__c;
                cow1.Phone = l.Tel_No_Auth_Usr_Req__c;
                cow1.Job_Title__c = l.Job_Title_Auth_Usr_Req__c;
                cow1.Contact_on_lead_conversion__c = true;
                cow1.Email = l.Official_Email_Auth_Usr_Req__c;
                cow1.Contact_Role__c = 'Authorized User Id';
                conList.add(cow1);                
                
                Contact cow = new Contact();
                cow.AccountId = l.ConvertedAccountId;
                cow.Title = l.Job_Title_Web_User__c;
                cow.LastName = l.Billing_Contact_Person__c;
                cow.Phone = l.Billing_Contact_Details__c;
                cow.Job_Title__c = l.Billing_Job_Title__c;
                cow.mailingcity = l.Billing_City__c;
                cow.Contact_Role__c = 'Billing Team Lead';
                cow.mailingstreet = l.Billing_Street__c;
                cow.mailingState = l.Billing_State__c;
                cow.mailingcountry = l.Billing_Country__c;
                cow.MailingPostalCode = l.Billing_Zip_Postal_Code__c;
                cow.Contact_on_lead_conversion__c = true;
                cow.Email = l.Billing_Email_Address__c;
                conList.add(cow);  
            }
            
        }
    }
       /*
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        for(Lead ld : Trigger.New) {
           
         if(ld.Status == 'Member details' || ld.Status == 'Sent for Agreement') {
                
                if(ld.RBI_Certificate_Verified__c != 'True')
                    ld.RBI_Certificate_Verified__c.addError('RBI Certificate Verified? required to change status to \'Member Details\'');
                if(ld.Pan_Verified__c != 'True')
                    ld.Pan_Verified__c.addError('Pan Verified required to change status to \'Member Details\'');
                if(ld.GST_Verified__c != 'True')
                    ld.GST_Verified__c.addError('GST Verified required to change status to \'Member Details\'');
                if(ld.RBI_Member_Verified__c != 'Yes')
                    ld.RBI_Member_Verified__c.addError('RBI Member Verified? required to change status to \'Member Details\'');
                if(ld.Checked_in_NBFC_List__c != 'Yes')
                    ld.Checked_in_NBFC_List__c.addError('Checked in RBI List required to change status to \'Member Details\'');
                if(ld.Checked_in_Termination_List__c != 'Yes')
                    ld.Checked_in_Termination_List__c.addError('Checked in Termination List required to change status to \'Member Details\'');
                
                if(!ld.Executive_Verified_Documents__c)
                    ld.Executive_Verified_Documents__c.addError('Executive Verified Documents? required to change status to \'Member Details\'');
                if(!ld.TL_Verified_Documents__c)
                    ld.TL_Verified_Documents__c.addError('TL Verified Documents? required to change status to \'Member Details\'');
                if(!ld.Admin_Verified_Documents__c)
                    ld.Admin_Verified_Documents__c.addError('Admin Verified Documents? required to change status to \'Member Details\'');
                
                if(ld.Selected_Authorised_Signatory__c == 'Other') {
                    if(ld.Authorised_Signatory_PAN_Verified__c != 'Yes')
                        ld.Authorised_Signatory_PAN_Verified__c.addError('Authorised Signatory PAN Verified? required to change status to \'Member Details\'');
                    if(ld.Auth_Sign_Authorization_Letter_Verified__c != 'Yes')
                        ld.Auth_Sign_Authorization_Letter_Verified__c.addError('Auth Sign Authorization Letter Verified? required to change status to \'Member Details\'');
                }
            }
            
            if(ld.Executive_Verified_Documents__c || ld.TL_Verified_Documents__c || ld.Admin_Verified_Documents__c) {
                if(ld.RBI_Certificate_Verified__c != 'True') ld.RBI_Certificate_Verified__c.addError('RBI certificate should be verified');
                if(ld.Pan_Verified__c != 'True') ld.Pan_Verified__c.addError('Pan should be verified');
                if(ld.GST_Verified__c != 'True') ld.GST_Verified__c.addError('GST should be verified');
                //if(ld.RBI_Member_Verified__c != 'Yes') ld.RBI_Member_Verified__c.addError('RBI Member should be verified');
                if(ld.Checked_in_NBFC_List__c != 'Yes') ld.Checked_in_NBFC_List__c.addError('Should be checked in NBFC list');
                if(ld.Checked_in_Termination_List__c != 'Yes') ld.Checked_in_Termination_List__c.addError('Should be checked in Termination list');
            }
        }
    } */
    
    //Contact from Web Users
    if(Trigger.isAfter && Trigger.isUpdate) {
    for(Web_User_Details__c wud : [Select Id, Web_User_First_Name__c,Web_User_Last_Name__c,Web_User_Tel_No__c,
                                   Web_User_Job_Title__c,Web_User_Email__c,Lead__c, Dispute_Member_Count__c, Web_User_Type__c  
                                   from Web_User_Details__c where   Lead__c In : MapLeadId_accId.keyset()]){
                                       
                                       if (wud.Web_User_Type__c =='For Grievance on Disputes'){
                                           
                                           Contact cn = new Contact();
                                           cn.AccountId = MapLeadId_accId.get(wud.Lead__c);
                                           cn.Title = wud.Web_User_Job_Title__c;
                                           cn.FirstName = wud.Web_User_First_Name__c; 
                                           cn.LastName = wud.Web_User_Last_Name__c;
                                           cn.Phone = wud.Web_User_Tel_No__c; 
                                           cn.Contact_Role__c = 'Dispute Manager';
                                           cn.Contact_on_lead_conversion__c = true;
                                           cn.Email = wud.Web_User_Email__c;
                                           cn.Dispute_Member_Count__c=wud.Dispute_Member_Count__c;
                                           conList.add(cn); 
                                       }
                                       
                                       if (wud.Web_User_Type__c =='Data Pull Id'){
                                           
                                           Contact cn = new Contact();
                                           cn.AccountId = MapLeadId_accId.get(wud.Lead__c);
                                           cn.Title = wud.Web_User_Job_Title__c;
                                           cn.FirstName = wud.Web_User_First_Name__c; 
                                           cn.LastName = wud.Web_User_Last_Name__c;
                                           cn.Phone = wud.Web_User_Tel_No__c; 
                                           cn.Contact_Role__c = 'NG User';
                                           cn.Contact_on_lead_conversion__c = true;
                                           cn.Email = wud.Web_User_Email__c;
                                           cn.Dispute_Member_Count__c=wud.Dispute_Member_Count__c;
                                           conList.add(cn); 
                                       }
                                       
                                       if(wud.Web_User_Type__c =='Data Submission Id'){
                                           
                                           Contact cn = new Contact();
                                           cn.AccountId = MapLeadId_accId.get(wud.Lead__c);
                                           cn.Title = wud.Web_User_Job_Title__c;
                                           cn.FirstName = wud.Web_User_First_Name__c; 
                                           cn.LastName = wud.Web_User_Last_Name__c;
                                           cn.Phone = wud.Web_User_Tel_No__c; 
                                           cn.Contact_Role__c = 'STS User';
                                           cn.Contact_on_lead_conversion__c = true;
                                           cn.Email = wud.Web_User_Email__c;
                                           cn.Dispute_Member_Count__c=wud.Dispute_Member_Count__c;
                                           conList.add(cn); 
                                       }
                                   } 
        
        if(stconIdtodelete.size()>0){
            
            List<Contact> listcon = new List<Contact>();
            
            for(Id conid : stconIdtodelete){
                Contact con = new Contact (Id = conid);
                listcon.add(con);
            }
            
            if(listcon.size()>0){
                try {
                    delete listcon;
                    insert conList;
                }
                catch(Exception e) {
                    System.debug(e.getMessage());
                    System.debug(e.getStackTraceString());
                }
            }            
        }
        
        //if(conList.size()>0){
            //insert conList;
        //}
    }
    
    
    if(Trigger.isAfter && trigger.isUpdate){
        for(Lead ld: Trigger.new){
            if(Trigger.oldMap.get(ld.Id).status !=ld.Status){
              //LeadStatusUpdateHandler.updateLeadStatus(Trigger.New,Trigger.OldMap);   
            }
            
        }
    }
    
}