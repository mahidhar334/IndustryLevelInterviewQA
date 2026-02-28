trigger PTCCaseLineItemTrigger on CaseLineItem (after update) {
    PTC_CaseLineItemHandler.handleCaseLineItemClosure(
        Trigger.new,
        Trigger.oldMap
    );
}