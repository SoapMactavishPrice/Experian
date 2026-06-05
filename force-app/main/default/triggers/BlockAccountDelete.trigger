trigger BlockAccountDelete on Account (before delete) {
    
    if(DeleteControlUtil.allowDelete()){
        return;
    }
    
    for (Account acc : Trigger.old) {
        acc.addError('Deletion is not allowed for Account records.');
    }
}