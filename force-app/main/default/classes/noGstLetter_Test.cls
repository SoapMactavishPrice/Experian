@isTest
public class noGstLetter_Test {
    
    @isTest
    public static void validate(){
        noGstLetterController no = new noGstLetterController();
        no.Company = 'gnm';
        no.First_Name_AuSig_c='xfghm';
        no.Last_Name_AuSig_c = 'dfghjk';
        ApexPages.currentPage().getParameters().put('Company',no.Company);
        
    }

}