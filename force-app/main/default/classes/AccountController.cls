/**
* @File Name : AccountController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : December 7, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 7, 2025 |   | Initial Version
**/

public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Id accountId) {
        return [SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId = :accountId];
    }
}