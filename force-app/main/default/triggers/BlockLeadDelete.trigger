trigger BlockLeadDelete on Lead (before delete) {
    
    if(DeleteControlUtil.allowDelete()){
        return;
    }
    
    for (Lead ld : Trigger.old) {
        //ld.addError('Deletion is not allowed for Lead records.');
    }
}