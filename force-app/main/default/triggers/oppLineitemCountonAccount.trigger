trigger oppLineitemCountonAccount on OpportunityLineItem (after insert , after delete) {
    
    if(trigger.isInsert){
    OpportunityLineItemTriggerHandler.handleAfterInsert(Trigger.New);
    }
    else{
        OpportunityLineItemTriggerHandler.handleAfterInsert(Trigger.old);
    }

}