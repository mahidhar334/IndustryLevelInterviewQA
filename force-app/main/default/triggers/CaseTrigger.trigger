trigger ApprovalCaseJobOrder on Case (after update) {
    if (Trigger.isAfter && Trigger.isUpdate) {
        CaseTriggerHandler.afterUpdateScenarioJob(Trigger.new, Trigger.oldMap);
    }
}