trigger accountTrigger on Account (before insert ,before Update, after undelete) {
    if(Trigger.isBefore){
    accountOwnerUpdate.accOwnerUpdate(Trigger.New , Trigger.isBefore ? Trigger.oldMap : Null);
    } else if(Trigger.isAfter){
       accountOwnerUpdate.accNameUpdate(Trigger.New); 
    }

}