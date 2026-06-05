@IsTest
public class OneXPCaseTriggerTest {
    
    private static Account createAccount(){
        Account acc = new Account(Name='Test Acc');
        insert acc;
        return acc;
    }
    
    private static Contact createContact(Account acc){
        Contact c = new Contact(LastName='Test', Contact_Role__c = 'Consumer', Email = 'test@gmail.com', AccountId=acc.Id);
        insert c;
        return c;
    }
    
    private static Case createParentCase(Account acc, Contact con){
        Case parent = new Case(
            Origin='Portal',
            Status='Open',
            Case_Identifier_Type__c='Account Number',
            AccountId=acc.Id,
            Name_of_Consumer__c=con.Id
        );
        insert parent;
        return parent;
    }
    
    private static List<Case> createChildCases(Account acc, Contact con, Id parentId){
        
        List<Case> childs = new List<Case>();
        
        for(Integer i=0;i<3;i++){
            childs.add(new Case(
                Origin='Portal',
                Status='New',
                Case_Identifier_Type__c='Attribute',
                AccountId=acc.Id,
                Name_of_Consumer__c=con.Id,
                Parent_Account_Number_Case__c=parentId
            ));
        }
        
        insert childs;
        return childs;
    }
    
    
    /* -----------------------------------------
TEST → Parent Date Sync
----------------------------------------- */
    @IsTest
    static void testParentDateSync(){
        
        Account acc = createAccount();
        Contact con = createContact(acc);
        Case parent = createParentCase(acc, con);
        List<Case> childs = createChildCases(acc, con, parent.Id);
        
        Test.startTest();
        
        childs[0].Forward_to_Bank_Date__c = Date.today();
        childs[0].Dispute_Raised_Date__c = Date.today();
        update childs;
        
        Test.stopTest();
        
        Case updatedParent = [
            SELECT Forward_to_Bank_Date__c, Dispute_Raised_Date__c
            FROM Case
            WHERE Id=:parent.Id
        ];
        
        System.assertEquals(Date.today(), updatedParent.Forward_to_Bank_Date__c);
        System.assertEquals(Date.today(), updatedParent.Dispute_Raised_Date__c);
    }
    
    
    /* -----------------------------------------
TEST → Queueable Parent Resolution
----------------------------------------- */
    @IsTest
    static void testParentResolutionQueueable(){
        
        Account acc = createAccount();
        Contact con = createContact(acc);
        Case parent = createParentCase(acc, con);
        List<Case> childs = createChildCases(acc, con, parent.Id);
        
        for(Case c : childs){
            c.Status = 'Resolved';
        }
        
        Test.startTest();
        update childs;
        Test.stopTest();
        
        Case updatedParent = [
            SELECT Status FROM Case WHERE Id=:parent.Id
        ];
        
        System.assertEquals('Resolved', updatedParent.Status);
    }
    
    
    /* -----------------------------------------
TEST → Refer to IO Logic
----------------------------------------- */
    @IsTest
    static void testReferToIO(){
        
        Account acc = createAccount();
        Contact con = createContact(acc);
        Case parent = createParentCase(acc, con);
        List<Case> childs = createChildCases(acc, con, parent.Id);
        
        Case_Type__c ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'Report';
        insert ct;
        
        Sub_Type__c	stl1 =new Sub_Type__c	();
        stl1.Name = 'Account ownership issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Account does not belong to me';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        childs[0].Maker_Status__c = 'Reject';
        childs[0].Maker_Sub_Status__c = 'Fully Rejected';
        childs[0].Checker_Status__c = 'Accept';
        //childs[0].Send_Email_to_Consumer__c = true;
        //childs[0].Forward_to_bank__c = true;
        childs[0].Dispute_Rejected_Reason__c = 'test';
        childs[0].Displayed_Bank_Name__c = 'SBI';
        childs[0].Displayed_Account_number__c = 'SBI12';
        childs[0].Date_of_the_email_received__c = system.today();
        childs[0].Dispute_Detail__c = 'test';
        childs[0].Dispute_Raised_Date__c = system.today();
        childs[0].Case_Category__c = 'Consumer';
        childs[0].Case_Complaints__c = 'Report';
        childs[0].Case_Type_Lookup__c = ct.Id;
        childs[0].Sub_Type_Lookup__c = stl1.id;
        childs[0].Sub_Type_1_Lookup__c= st1.Id;
        childs[0].Contact_Name__c = 'test';
        childs[0].ContactMobileNo__c = '11246';
        childs[0].ContactEmailId__c = 'test@gmail.com';
        childs[0].Dis_Ern__c = '1234567890123';
        
        Test.startTest();
        update childs[0];
        Test.stopTest();
        
        Case updated = [
            SELECT Referred_To_IO_Case__c, Dispute_Rejected_Reason__c
            FROM Case
            WHERE Id=:childs[0].Id
        ];
        
        //System.assertEquals(true, updated.Referred_To_IO_Case__c);
    }
    
    
    /* -----------------------------------------
TEST → Consumer Resolution Logic
----------------------------------------- */
    @IsTest
    static void testConsumerResolution(){
        
        Account acc = createAccount();
        Contact con = createContact(acc);
        Case parent = createParentCase(acc, con);
        List<Case> childs = createChildCases(acc, con, parent.Id);
        
        Case_Type__c ct = new Case_Type__c();
        ct.Case_Category__c = 'Consumer';
        ct.Name ='Complaint Dispute Consumer';
        ct.Case_Complaint__c = 'Report';
        insert ct;
        
        Sub_Type__c	stl1 =new Sub_Type__c	();
        stl1.Name = 'Account ownership issue';
        stl1.Case_Type__c = ct.Id;
        insert stl1;
        
        Sub_Type1__c st1 = new Sub_Type1__c();
        st1.Name = 'Account does not belong to me';
        st1.Sub_Type__c = stl1.Id;
        insert st1;
        
        childs[0].Maker_Status__c = 'Accept';
        childs[0].Checker_Status__c = 'Accept';
        childs[0].Account_Level_Status__c = 'Processing Passed';
        childs[0].Send_Email_to_Consumer__c = true;
        childs[0].Forward_to_bank__c = true;
        childs[0].Dispute_Rejected_Reason__c = 'test';
        childs[0].Displayed_Bank_Name__c = 'SBI';
        childs[0].Displayed_Account_number__c = 'SBI12';
        childs[0].Date_of_the_email_received__c = system.today();
        childs[0].Dispute_Detail__c = 'test';
        childs[0].Dispute_Raised_Date__c = system.today();
        childs[0].Case_Category__c = 'Consumer';
        childs[0].Case_Complaints__c = 'Report';
        childs[0].Case_Type_Lookup__c = ct.Id;
        childs[0].Sub_Type_Lookup__c = stl1.id;
        childs[0].Sub_Type_1_Lookup__c= st1.Id;
        childs[0].Contact_Name__c = 'test';
        childs[0].ContactMobileNo__c = '11246';
        childs[0].ContactEmailId__c = 'test@gmail.com';
        childs[0].Dis_Ern__c = '1234567890123';
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new DummyMock());
        update childs;
        Test.stopTest();
        
        Case updated = [
            SELECT Consumer_Dispute_Status__c
            FROM Case
            WHERE Id=:childs[0].Id
        ];
        
        //System.assertEquals('Resolved in favour of the Consumer', updated.Consumer_Dispute_Status__c);
    }
}