trigger BlockCaseDelete on Case (before delete) {
    
    if(DeleteControlUtil.allowDelete()){
        return;
    }
    
    for (Case cs : Trigger.old) {
        cs.addError('Deletion is not allowed for Case records.');
    }
}