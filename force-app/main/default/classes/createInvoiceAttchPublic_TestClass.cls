@IsTest
public class createInvoiceAttchPublic_TestClass {
static testMethod void test(){
try{
    

    ContentVersion testContentInsert =new ContentVersion(); 
 testContentInsert.ContentURL='test'; 
 testContentInsert.Title ='Google.com'; 
 insert testContentInsert; 
 
 ContentDocumentLink cd=new ContentDocumentLink();
 cd.ContentDocumentId=testContentInsert.Id;
 insert cd;
 
}catch(Exception e){
}
  

 


}


}