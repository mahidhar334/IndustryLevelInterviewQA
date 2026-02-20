trigger JobLineItemTrigger on JobLineItem__c (after update) {
    JobLineItemHandler.afterUpdate(Trigger.new);
}