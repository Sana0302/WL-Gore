trigger CommissionTrigger on Commission__c (after insert,after update,after unDelete,after delete) {
    
    //calling handler method to calculate agent commission at  commission record insertion
    if(Trigger.isInsert||Trigger.isUpdate||Trigger.isUndelete){
            CommissionTriggerHandler.handleNewCommission(Trigger.New);
    }
    
    if(Trigger.isDelete){
        CommissionTriggerHandler.handleNewCommission(Trigger.Old);
    }
}