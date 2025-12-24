trigger OpportunityTrigger on Opportunity (after insert, after update, after delete) {
    //if (Trigger.isInsert || Trigger.isUpdate) {
    //    OpportunityClass.rollUpOppAmountOnAccount(Trigger.new, Trigger.oldMap);
    //}
    if (Trigger.isDelete) {
        OpportunityClass.rollUpOppAmountOnAccount(Trigger.old, null);
    }
    
    //trigger OpportunityTrigger on Opportunity (after insert) {
    // After insert, clone line items if Original_Opportunity__c is populated
    if (Trigger.isAfter && Trigger.isInsert) {
        OpportunityClass.cloneOppLineItems(Trigger.new);
    }
    if(Trigger.isAfter && Trigger.isUpdate){
         taskCreationOppUpdate.taskCreation(Trigger.New ,Trigger.oldMap);
    }
}