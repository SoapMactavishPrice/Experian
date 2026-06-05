public class noGstLetterController {
    
    public String Company {get;set;}
    public String First_Name_AuSig_c {get;set;}
    public String Last_Name_AuSig_c {get;set;}
    
    public noGstLetterController(){
        
        Company = ApexPages.currentPage().getParameters().get('Company');
        
        First_Name_AuSig_c = ApexPages.currentPage().getParameters().get('First_Name_AuSig_c');
        Last_Name_AuSig_c = ApexPages.currentPage().getParameters().get('Last_Name_AuSig_c');
    }
}