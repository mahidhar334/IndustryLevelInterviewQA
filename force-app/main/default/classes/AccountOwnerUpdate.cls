/**
* @File Name : accountOwnerUpdate.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : December 14, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 14, 2025 |   | Initial Version
**/

public class AccountOwnerUpdate {

    public static void accOwnerUpdate(
        List<Account> newAccList,
        Map<Id, Account> oldMap
    ) {

        Set<Id> ownerIds = new Set<Id>();

        for(Account acc : newAccList) {
            if(acc.OwnerId != null &&
               acc.OwnerId.getSObjectType() == User.SObjectType) {
                ownerIds.add(acc.OwnerId);
            }
        }

        Map<Id, User> userMap = new Map<Id, User>(
            [SELECT Id, Name FROM User WHERE Id IN :ownerIds]
        );

        for(Account acc : newAccList) {
            User u = userMap.get(acc.OwnerId);
            if(u != null) {
                acc.SalesRep__c = u.Name;
            }
        }
    }




    public static void accNameUpdate(List<Account> newAccounts) {
        set<id> accIds = new set<id>();
        list<Account> accLsitInsert = new list<Account>();
        for(Account acc : newAccounts) {
            if(acc.id !=NUll ) {
                accIds.add(acc.id);
                 
            }
        }
        
        if(accIds.size()>0){
            list<Account> accList = [select Id,Name from Account where id in :accIds];
            
            if(accList.size()>0){
                
                for(Account acc : accList){
                    acc.Name = 'Restored '+acc.Name;
                    accLsitInsert.add(acc);
                }
            }
            
            if(accLsitInsert.size()>0){
                update accLsitInsert;
            }
            
        }
    }
}

/*
 ------------------------------------------------------------Version 2 after insert trigger
    public class AccountOwnerUpdate {

    public static void accOwnerUpdate(List<Account> newAccList) {

        Id currentUserId = UserInfo.getUserId();
        String currentUserName = UserInfo.getName();

        List<Account> accToUpdate = new List<Account>();

        for(Account acc : newAccList) {
            if(acc.OwnerId == currentUserId) {
                accToUpdate.add(
                    new Account(
                        Id = acc.Id,
                        SalesRep__c = currentUserName
                    )
                );
            }
        }

        if(!accToUpdate.isEmpty()) {
            update accToUpdate; // ✅ allowed
        }
    }
}

------------------------------------version 1 after insert trigger
public class accountOwnerUpdate {
	public static void accOwnerUpdate(list<Account> newAccList){
		set<Id> accId = new set<id>();
		set<Id> ownerId = new set<id>();
        list<Account> accListtoUpdate = New list<Account>();

		String userName = UserInfo.getUserName();
		Id userId = UserInfo.getUserId();
		for(Account acc : newAccList){
			if(acc.Id !=NUll && acc.ownerId != Null){
				accId.add(acc.id);
				system.debug(acc.id);
				ownerId.add(acc.OwnerId);
				system.debug(acc.OwnerId);
			}
			
		}
		list<Account> queryList =[select id,ownerId,owner.name from Account where Id in : accId] ;
		
		Map<id, Account> accMap = new Map<id, Account>(queryList);

			if(!accMap.isEmpty()){

				for(Account accRec : queryList){
					if(accRec.ownerId == userId){
						accRec.salesRep__c = userName;
                        accListtoUpdate.add(accRec);
					}
					 

				}
                if(accListtoUpdate.size()>0){
                    update accListtoUpdate;
                }
			}




	}
}*/