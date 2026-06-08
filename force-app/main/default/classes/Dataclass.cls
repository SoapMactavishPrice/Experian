public class Dataclass {

    private static List<OrgWideEmailAddress> orgAddrList1;
    private static List<OrgWideEmailAddress> orgAddrList2;

    public static Id getNodalOfficer() {
        if(orgAddrList1 != null) {
            return orgAddrList1[0].Id;
        }
        else {
            orgAddrList1 = [select Id from OrgWideEmailAddress where Address = 'nodal.officer.india@experian.com' limit 1];     
            return orgAddrList1[0].Id;
        }
    }
    
    public static Id getConsumerSupport() {
        if(orgAddrList2 != null) {
            return orgAddrList2[0].Id;
        }
        else {
            orgAddrList2 = [select Id from OrgWideEmailAddress where Address = 'consumer.support@in.experian.com' limit 1];     
            return orgAddrList2[0].Id;
        }
    }
}