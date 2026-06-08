public class Add_ContactAccessControl {
    
    public Id currentRecID{get;set;}
     
    Public List<Contact_Access_Control__c> accList {get;set;}
    public Integer rowIndex {get;set;}
     
    public Add_ContactAccessControl(){
        accList = new list<Contact_Access_Control__c>();
        accList.add(new Contact_Access_Control__c());
        currentRecID=ApexPages.currentPage().getParameters().get('id'); 
        
        system.debug('****'+currentRecID);
          
    }
     
    public void addRow(){
        accList.add(new Contact_Access_Control__c());
    }
     
    public pagereference saveAccount(){
        
        List<Contact_Access_Control__c> listcac = new List<Contact_Access_Control__c>();
        For(Contact_Access_Control__c cac : accList){
            cac.Contact_Name__c = currentRecID;
            listcac.add(cac);
        }
        if(listcac.size()>0){
            Insert listcac;
        }  
        
        pagereference pg=new pagereference('/'+currentRecID);
        pg.setRedirect(true);
        return pg;  
    }
    
    Public Pagereference Cancel(){
        
        pagereference pg=new pagereference('/'+currentRecID);
        pg.setRedirect(true);
        return pg;        
    }    
     
    public PageReference deleteRow(){
        rowIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('rowIndex'));
        accList.remove(rowIndex);
        return null;
    }
}