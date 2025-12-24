trigger contactTrigger on Contact (before insert) {
contactClass.duplicateEmailValidation(trigger.new);
}