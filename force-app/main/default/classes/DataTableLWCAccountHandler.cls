/**
* @File Name : DataTableLWCAccountHandler.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : December 8, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 8, 2025 |   | Initial Version
**/

public class DataTableLWCAccountHandler {
	@AuraEnabled(cacheable=true)
public static List<Account> getAccountList() {
    return [SELECT Id, Name, Phone, Rating, Industry 
            FROM Account 
            WHERE  createddate != LAST_N_DAYS:10 limit 15];
}

@AuraEnabled
public static String delAccountList(List<Account> accList) {
    try {
        delete accList;
        return 'Success';
    } catch (Exception e) {
        return 'Error: ' + e.getMessage();
    }
}

    @AuraEnabled(cacheable=true)
public static List<Contact> getContacts(){
    
    List<Contact> conList = [Select Id,Name,Account.name,Email,Phone,AccountId from Contact Where AccountId != Null order by createddate desc limit 15 ];
    system.debug('server call fetched' + conList.size());
    return conList;
    
}
    @AuraEnabled
    public static void insertContact(List<Contact> conList){
        insert conList;
    }

   @AuraEnabled
    public static String deleteContacts(List<Id> contactIds) {
    try {
        List<Contact> contactsToDelete = [SELECT Id FROM Contact WHERE Id IN :contactIds];
        delete contactsToDelete;
        return contactsToDelete.size() + ' contacts are deleted';
    } catch (Exception e) {
        throw new AuraHandledException('Error deleting contacts: ' + e.getMessage());
    }
}


    
    @AuraEnabled
    public static Id createContact(String firstName, String lastName, String email, String phone, Id accountId) {
        Contact newContact = new Contact(
            FirstName = firstName,
            LastName  = lastName,
            Email     = email,
            Phone     = phone,
            AccountId = accountId
        );
        
        insert newContact;
        return newContact.Id;
    }



// wire fetch with input parameter
@AuraEnabled(cacheable=true)
public static List<Account> getAccountWithInput(String KeyWord){
    String Key = '%'+KeyWord+'%';
    List<Account> accList = [Select Id,Name,Phone,(Select Id,Email,Phone from Contacts) from Account Where Name LIKE : Key limit 10];
    system.debug('list of Accounts' + accList);
    return accList;

}


}