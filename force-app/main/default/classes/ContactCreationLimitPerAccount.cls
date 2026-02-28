// Boeing scenario: 
//Limit the number of contacts that can be created for an account to 10. This class will be used in a trigger on the Contact object to enforce this limit.
public with sharing class ContactCreationLimitPerAccount {
    //public ContactCreationLimitPerAccount() {

    //}
    public static void enforceContactCreationLimit(List<Contact> newContacts) {
        // Get the account IDs from the new contacts
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Integer> currentCount = new Map<Id, Integer>();
        for (Contact con : newContacts) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
                currentCount.put(ccon.AccountId, currentCount.get(con.AccountId) != null ? currentCount.get(con.AccountId) + 1 : 1);
            }
        }

        // query account records with contactLimit field to check if the limit is set for the account
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, contactLimit__c FROM Account WHERE Id IN :accountIds AND contactLimit__c != null]); 

        // Query the number of existing contacts for each account
        Map<Id, Integer> accountContactCountMap = new Map<Id, Integer>();
        for (AggregateResult ar : [SELECT AccountId, COUNT(Id) contactCount FROM Contact WHERE AccountId IN :accountIds GROUP BY AccountId]) {
            accountContactCountMap.put((Id)ar.get('AccountId'), (Integer)ar.get('contactCount'));
        }

        // Check if adding the new contacts would exceed the limit of 10
        for (Contact con : newContacts) {
            if (con.AccountId != null) {
                Integer existingContactCount = accountContactCountMap.get(con.AccountId);
                Integer contactLimit = accountMap.get(con.AccountId).contactLimit__c != null ? accountMap.get(con.AccountId).contactLimit__c : 10; // Default to 10 if not set
                Integer newContactCount = currentCount.get(con.AccountId) != null ? currentCount.get(con.AccountId) : 0;
                if (existingContactCount != null && existingContactCount + newContactCount >= contactLimit) {
                    con.addError('You cannot create more than ' + contactLimit + ' contacts for this account.');
                }
                
            }
        }
    }

}