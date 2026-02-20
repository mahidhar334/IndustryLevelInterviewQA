trigger JobTrigger on Job__c (after update) {
    JobHandler.afterUpdate(Trigger.new);
}