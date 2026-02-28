trigger BoeingTriggerContact on Contact (before insert) {
    ContactCreationLimitPerAccount.enforceContactCreationLimit(Trigger.new);

}