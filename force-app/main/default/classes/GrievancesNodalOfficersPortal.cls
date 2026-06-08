public without sharing class GrievancesNodalOfficersPortal {
	
    public string accId {get;set;}
    public GrievancesNodalOfficersPortal(){
        accId = ApexPages.currentPage().getParameters().get('recordId');
        system.debug('account Id'+accId);
        if(accId == null){
            accId='001Bi00000CgqD0IAJ';
        }
    }
    
     @AuraEnabled 
    public static string getAccountName(string accId){
        if(accId == null){
            accId='001Bi00000CgqD0IAJ';
        }
        Account awp = [Select Id ,Name from Account where ID =:accId];
        return awp.Name;
    }
    
    
    @AuraEnabled
    public static string getContactsGroupedByRole(string accId) {
        List<String> conRoleList = new List<String>{
            'Data Submission Primary', 'Data Submission Secondary',
                'DQR Primary', 'DQR Secondary', 'DQI Primary', 'DQI Secondary',
                'Form C Primary', 'Form C Secondary', 'Chief Data Officer (CDO)',
                'OLM Primary', 'OLM Secondary', 'Dispute Resolution Officer Primary','Dispute Resolution Officer Secondary',
                'Data Correction Head', 'Grievance Nodal Officer (GNO)',
                'Grievance Principal Nodal Officer (GPNO)',
                'Regulatory and Compliance Primary', 'Regulatory and Compliance Secondary',
                'Chief Compliance Officer (CCO)', 'Billing Primary', 'Billing Secondary',
                'Chief Financial Officer (CFO)', 'Business / Sales Team Primary',
                'Business / Sales Team Secondary', 'Chief Business Officer (CBO)',
                'Chief Revenue Officer (CRO)', 'Technology Team Primary',
                'Technology Team Secondary', 'Chief Technology Officer (CTO)',
                'Authorized Signatory', 'Nodal Officer (NO)', 'Principal Nodal Officer (PNO)',
                'Chief Operating Officer (COO)', 'Chief Executive Officer (CEO)'
           };
                    
                    // Query contacts from all given accounts with matching roles
                    List<Contact> conList = [
                        SELECT Id, Name, Email, Title, Phone, Contact_Role__c
                        FROM Contact
                        WHERE AccountId =:accId
                        AND Contact_Role__c IN :conRoleList
                    ];
        
        // Group contacts by Contact_Role__c
        Map<String, List<Contact>> roleToContactsMap = new Map<String, List<Contact>>();
        
        for (Contact con : conList) {
            String role = con.Contact_Role__c;
            
            if (!roleToContactsMap.containsKey(role)) {
                roleToContactsMap.put(role, new List<Contact>());
            }
            
            roleToContactsMap.get(role).add(con);
        }
        
        return JSON.serialize(roleToContactsMap);
    }
    
    
  
     @AuraEnabled
    public static String insertContacts(String accId, String JS) {
    try {
        List<wrapper> jsList = parse(JS);
        List<Contact> conList = new List<Contact>();

        // Mapping temp index to wrapper and Contact for IP linking
        Map<String, wrapper> wrapperMapByIndex = new Map<String, wrapper>();
        Map<String, Contact> contactMapByIndex = new Map<String, Contact>();

        System.debug('Before insert check size --> ' + accId + ' - ' + jsList.size());

        // 1. Build Contact list and mappings
        for (wrapper wrp : jsList) {
            Contact con = new Contact();

            if (String.isNotBlank(wrp.Id)) {
                con.Id = wrp.Id;
            } else {
                con.AccountId = accId;
            }

            if (String.isNotBlank(wrp.Name))
                con.LastName = wrp.Name;

            if (String.isNotBlank(wrp.Email))
                con.Email = wrp.Email;

            if (String.isNotBlank(wrp.Phone))
                con.Phone = wrp.Phone;

            if (String.isNotBlank(wrp.Title))
                con.Title = wrp.Title;

            if (String.isNotBlank(wrp.UserRole))
                con.Contact_Role__c = wrp.UserRole;

            // Store mappings using temp unique key from client
            if (String.isNotBlank(wrp.index)) {
                wrapperMapByIndex.put(wrp.index, wrp);
                contactMapByIndex.put(wrp.index, con);
            }

            conList.add(con);
        }

        // 2. Upsert Contacts
        if (!conList.isEmpty()) {
            upsert conList;

            // 3. After upsert, insert related IP records
            List<Contact_IP_Address__c> ipList = new List<Contact_IP_Address__c>();

            for (String idx : contactMapByIndex.keySet()) {
                Contact c = contactMapByIndex.get(idx);
                wrapper wrp = wrapperMapByIndex.get(idx);

                if (wrp != null && wrp.IP_Address != null && !wrp.IP_Address.isEmpty()) {
                    for (wrapperLine ipEntry : wrp.IP_Address) {
                        if (String.isNotBlank(ipEntry.fromIp)) {
                            Contact_IP_Address__c cip = new Contact_IP_Address__c();
                            cip.Contact__c = c.Id;
                            cip.Name = ipEntry.fromIp; // Assuming Name stores From IP
                            cip.End_IP_Address__c = ipEntry.fromToIp;
                            ipList.add(cip);
                        }
                    }
                }
            }

            if (!ipList.isEmpty()) {
                insert ipList;
            }
        }

        return 'Contacts and related IPs inserted/updated successfully';

    } catch (Exception e) {
        //return e.getLineNumber() + ' - ' + e.getMessage();
        return e.getMessage();
    }
}

    public static List<wrapper> parse(string js){
        return ((List<wrapper>) system.JSON.deserialize(JS,List<wrapper>.class));
    }
    
    public class wrapper{
        public string Id;
        public string index;
        public string Name;
        public string Email;
        public string Phone;
        public string Title;
        public string UserRole;
        public boolean isIPAddes;
        List<wrapperLine> IP_Address;
    }
    
    public class wrapperLine 
        {
        public string fromIp;
            public string fromToIp;
        }
        
   
}