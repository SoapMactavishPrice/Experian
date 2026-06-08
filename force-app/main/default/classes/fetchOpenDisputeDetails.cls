@RestResource(urlMapping='/fetchOpenDisputeDetails/*')
global without sharing class fetchOpenDisputeDetails {

    // ======== WRAPPER CLASSES ========
    global class RequestWrapper {
        public List<AccountDisputeRequest> accountDisputeRequestList;
        public List<EnquiryDisputeRequest> enquiryDisputeRequestList;
    }

    global class AccountDisputeRequest {
        public String accountNumber;
        public String bureauMemberId;
        public String bureauMemberName;
    }

    global class EnquiryDisputeRequest {
        public String enquiryERN;
        public String bureauMemberId;
        public String bureauMemberName;
    }

    global class DisputeResponse {
        public String caseNumber;
        public String mobileNumber;
        public String subType;
        public String subType1;
        public String caseStatus;
        public String disputeStatus;
        public String disputeRaisedDate;
        public String error;
    }

    global class AccountDisputeResponse {
        public String accountNumber;
        public String bureauMemberId;
        public String bureauMemberName;
        public List<DisputeResponse> disputeResponses = new List<DisputeResponse>();
    }

    global class EnquiryDisputeResponse {
        public String enquiryERN;
        public String bureauMemberId;
        public String bureauMemberName;
        public List<DisputeResponse> disputeResponses = new List<DisputeResponse>();
    }

    global class FinalResponse {
        public List<AccountDisputeResponse> accountDisputeResponseList = new List<AccountDisputeResponse>();
        public List<EnquiryDisputeResponse> enquiryDisputeResponseList = new List<EnquiryDisputeResponse>();
    }

    // ======== MAIN ENTRY POINT ========
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        FinalResponse finalResp = new FinalResponse();
        API_LOG__c ap = new API_LOG__c();
        ap.Request_Source__c = 'fetchOpenDisputeDetails';

        try {
            String jsonString = req.requestBody.toString().replace('\n', '');
            ap.Request__c = jsonString;

            RequestWrapper wrapper = (RequestWrapper) JSON.deserialize(jsonString, RequestWrapper.class);

            // Collect filter sets to avoid SOQL-in-loop
            Set<String> accNumbers = new Set<String>();
            Set<String> bankNames = new Set<String>();
            Set<String> bureauIds = new Set<String>();
            Set<String> enquiryERNs = new Set<String>();

            if (wrapper != null && wrapper.accountDisputeRequestList != null) {
                for (AccountDisputeRequest ar : wrapper.accountDisputeRequestList) {
                    if (!String.isBlank(ar.accountNumber)) accNumbers.add(ar.accountNumber);
                    if (!String.isBlank(ar.bureauMemberName)) bankNames.add(ar.bureauMemberName);
                    if (!String.isBlank(ar.bureauMemberId)) bureauIds.add(ar.bureauMemberId);
                }
            }

            if (wrapper != null && wrapper.enquiryDisputeRequestList != null) {
                for (EnquiryDisputeRequest er : wrapper.enquiryDisputeRequestList) {
                    if (!String.isBlank(er.enquiryERN)) enquiryERNs.add(er.enquiryERN);
                    if (!String.isBlank(er.bureauMemberName)) bankNames.add(er.bureauMemberName);
                    if (!String.isBlank(er.bureauMemberId)) bureauIds.add(er.bureauMemberId);
                }
            }

            // ======== BULK QUERY FOR ACCOUNT CASES ========
            List<Case> allAccountCases = new List<Case>();
            if (!accNumbers.isEmpty()) {
                allAccountCases = [
                    SELECT CaseNumber, ContactMobileNo__c, Sub_Type_Lookup__r.Name,
                           Sub_Type_1_Lookup__r.Name, Status, Consumer_Dispute_Status__c,
                           Dis_Date__c, Displayed_Account_number__c, Displayed_Bank_Name__c,
                           Account.Bureau_Member_Id__c
                    FROM Case
                    WHERE Status = 'Open'
                    AND (Displayed_Account_number__c IN :accNumbers)
                    AND ((Displayed_Bank_Name__c IN :bankNames) OR (Account.Bureau_Member_Id__c IN :bureauIds))
                ];
            }

            // ======== BULK QUERY FOR ENQUIRY CASES ========
            List<Case> allEnquiryCases = new List<Case>();
            if (!enquiryERNs.isEmpty()) {
                allEnquiryCases = [
                    SELECT CaseNumber, ContactMobileNo__c, Sub_Type_Lookup__r.Name,
                           Sub_Type_1_Lookup__r.Name, Status, Consumer_Dispute_Status__c,
                           Dis_Date__c, Enquiry_ERN__c, Enquiry_ERN_1__c,
                           Displayed_Bank_Name__c, Account.Bureau_Member_Id__c
                    FROM Case
                    WHERE Status = 'Open'
                    AND ((Enquiry_ERN__c IN :enquiryERNs) OR (Enquiry_ERN_1__c IN :enquiryERNs))
                    AND ((Displayed_Bank_Name__c IN :bankNames) OR (Account.Bureau_Member_Id__c IN :bureauIds))
                ];
            }

            // ======== MAP CASES FOR QUICK LOOKUP ========
            Map<String, List<Case>> accToCases = new Map<String, List<Case>>();
            for (Case c : allAccountCases) {
                if (!accToCases.containsKey(c.Displayed_Account_number__c)) {
                    accToCases.put(c.Displayed_Account_number__c, new List<Case>());
                }
                accToCases.get(c.Displayed_Account_number__c).add(c);
            }

            Map<String, List<Case>> ernToCases = new Map<String, List<Case>>();
            for (Case c : allEnquiryCases) {
                if (!String.isBlank(c.Enquiry_ERN__c)) {
                    if (!ernToCases.containsKey(c.Enquiry_ERN__c)) {
                        ernToCases.put(c.Enquiry_ERN__c, new List<Case>());
                    }
                    ernToCases.get(c.Enquiry_ERN__c).add(c);
                }
                if (!String.isBlank(c.Enquiry_ERN_1__c)) {
                    if (!ernToCases.containsKey(c.Enquiry_ERN_1__c)) {
                        ernToCases.put(c.Enquiry_ERN_1__c, new List<Case>());
                    }
                    ernToCases.get(c.Enquiry_ERN_1__c).add(c);
                }
            }

            // ======== PROCESS ACCOUNT DISPUTES ========
            if (wrapper.accountDisputeRequestList != null) {
                for (AccountDisputeRequest reqItem : wrapper.accountDisputeRequestList) {
                    AccountDisputeResponse resp = new AccountDisputeResponse();
                    resp.accountNumber = reqItem.accountNumber;
                    resp.bureauMemberId = reqItem.bureauMemberId;
                    resp.bureauMemberName = reqItem.bureauMemberName;

                    try {
                        List<Case> relatedCases = accToCases.get(reqItem.accountNumber);
                        if (relatedCases != null) {
                            for (Case c : relatedCases) {
                                if (
                                    (reqItem.bureauMemberId == c.Account.Bureau_Member_Id__c) ||
                                    (reqItem.bureauMemberName == c.Displayed_Bank_Name__c)
                                ) {
                                    DisputeResponse dr = new DisputeResponse();
                                    dr.caseNumber = c.CaseNumber;
                                    dr.mobileNumber = c.ContactMobileNo__c;
                                    dr.subType = c.Sub_Type_Lookup__r != null ? c.Sub_Type_Lookup__r.Name : null;
                                    dr.subType1 = c.Sub_Type_1_Lookup__r != null ? c.Sub_Type_1_Lookup__r.Name : null;
                                    dr.caseStatus = c.Status;
                                    dr.disputeStatus = c.Consumer_Dispute_Status__c;
                                    dr.disputeRaisedDate = c.Dis_Date__c != null ? String.valueOf(c.Dis_Date__c) : null;
                                    resp.disputeResponses.add(dr);
                                }
                            }
                        }
                    } catch (Exception e) {
                        DisputeResponse errorResp = new DisputeResponse();
                        errorResp.error = e.getMessage();
                        resp.disputeResponses.add(errorResp);
                    }

                    finalResp.accountDisputeResponseList.add(resp);
                }
            }

            // ======== PROCESS ENQUIRY DISPUTES ========
            if (wrapper.enquiryDisputeRequestList != null) {
                for (EnquiryDisputeRequest reqItem : wrapper.enquiryDisputeRequestList) {
                    if (String.isBlank(reqItem.enquiryERN) && String.isBlank(reqItem.bureauMemberId) && String.isBlank(reqItem.bureauMemberName))
                        continue;

                    EnquiryDisputeResponse resp = new EnquiryDisputeResponse();
                    resp.enquiryERN = reqItem.enquiryERN;
                    resp.bureauMemberId = reqItem.bureauMemberId;
                    resp.bureauMemberName = reqItem.bureauMemberName;

                    try {
                        List<Case> relatedCases = ernToCases.get(reqItem.enquiryERN);
                        if (relatedCases != null) {
                            for (Case c : relatedCases) {
                                if (
                                    (reqItem.bureauMemberId == c.Account.Bureau_Member_Id__c) ||
                                    (reqItem.bureauMemberName == c.Displayed_Bank_Name__c)
                                ) {
                                    DisputeResponse dr = new DisputeResponse();
                                    dr.caseNumber = c.CaseNumber;
                                    dr.mobileNumber = c.ContactMobileNo__c;
                                    dr.subType = c.Sub_Type_Lookup__r != null ? c.Sub_Type_Lookup__r.Name : null;
                                    dr.subType1 = c.Sub_Type_1_Lookup__r != null ? c.Sub_Type_1_Lookup__r.Name : null;
                                    dr.caseStatus = c.Status;
                                    dr.disputeStatus = c.Consumer_Dispute_Status__c;
                                    dr.disputeRaisedDate = c.Dis_Date__c != null ? String.valueOf(c.Dis_Date__c) : null;
                                    resp.disputeResponses.add(dr);
                                }
                            }
                        }
                    } catch (Exception e) {
                        DisputeResponse errorResp = new DisputeResponse();
                        errorResp.error = e.getMessage();
                        resp.disputeResponses.add(errorResp);
                    }

                    finalResp.enquiryDisputeResponseList.add(resp);
                }
            }

            // ======== FINAL RESPONSE ========
            res.responseBody = Blob.valueOf(JSON.serializePretty(finalResp));
            res.statusCode = 200;
            res.addHeader('Content-Type', 'application/json');
            ap.Response__c = JSON.serializePretty(finalResp);

        } catch (Exception e) {
            Map<String, Object> errorResp = new Map<String, Object>{
                'error' => e.getMessage(),
                'status' => '400'
            };
            res.responseBody = Blob.valueOf(JSON.serialize(errorResp));
            res.statusCode = 400;
            res.addHeader('Content-Type', 'application/json');
            ap.Exception_Description__c = e.getMessage();
            ap.Response__c = e.getMessage();
        }

        insert ap;
    }
}