@IsTest(SeeAllData=true)
public class UpdateOwnerFromPost_Test {

    @isTest
    public static void test1() {
        Account acc = new Account();
        acc.name = 'test acc';
        insert acc;
        
        Case cs = new Case();
        cs.Displayed_Loan_Balance__c =Decimal.valueof(5000);
        cs.Displayed_EMI_Amount__c =Decimal.valueof(9000);
        cs.Status = 'Open';
        cs.AccountId = acc.id;
        cs.Subject = 'Update';
        cs.Case_Category__c = 'Consumer';
        cs.Case_Complaints__c = null;
        cs.Origin = 'Email';
        insert cs;
        
        ConnectApi.FeedElementPage testPage = new ConnectApi.FeedElementPage();
        List<ConnectApi.FeedItem> testItemList = new List<ConnectApi.FeedItem>();
        testItemList.add(new ConnectApi.FeedItem());
        testItemList.add(new ConnectApi.FeedItem());
        testPage.elements = testItemList;

        // Set the test data
        ConnectApi.ChatterFeeds.setTestGetFeedElementsFromFeed(null, ConnectApi.FeedType.News, 'me', testPage);
        
        
        FeedItem fi = new FeedItem();
        fi.ParentId = cs.Id;
        fi.Body = 'textarea';
        fi.IsRichText = false;
        insert fi;
        
    }
    
}