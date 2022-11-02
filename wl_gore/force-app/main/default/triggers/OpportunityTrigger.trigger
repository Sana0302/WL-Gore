trigger OpportunityTrigger on Opportunity (after update,after unDelete,after delete) {
    
    //calling handler method to calculate agent commission at  Opportunity updation
    if(Trigger.isUpdate||Trigger.isUndelete){

    OpportunityTriggerHandler.updateCommission(trigger.new);
    }
    
    if(trigger.isDelete){
            OpportunityTriggerHandler.updateCommission(trigger.old);

    }
}