public class OpportunityClass {
    // before delete on opportunity
    public static void deleteClosedOpp(List<Opportunity> oppListDel) {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        Id currentProfileId = UserInfo.getProfileId();
        String profileName = [SELECT Name FROM Profile WHERE Id = :currentProfileId].Name;

        // Collect all ownerIds for Opportunities that will be deleted
        Set<Id> ownerIds = new Set<Id>();
        for (Opportunity opp : oppListDel) {
            if (profileName != 'System Administrator' && opp.StageName == 'Closed Lost') {
                opp.addError('Only System Administrators can delete Closed Lost Opportunities.');
            } else {
                ownerIds.add(opp.OwnerId);
            }
        }

        // Query Users for their emails
        Map<Id, User> userMap = new Map<Id, User>(
            [SELECT Id, Email FROM User WHERE Id IN :ownerIds]
        );

        // Build email messages
        for (Opportunity opp : oppListDel) {
            if (profileName == 'System Administrator') {
                User owner = userMap.get(opp.OwnerId);
                if (owner != null && owner.Email != null) {
                    Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
                    emailMessage.setHTMLBody('Closed Opportunity has been deleted.');
                    emailMessage.setToAddresses(new String[] { owner.Email });
                    emailMessage.setSubject('Opportunity Deleted');
                    emailList.add(emailMessage);
                }
            }
        }

        // Send emails if any
        if (!emailList.isEmpty()) {
            Messaging.sendEmail(emailList);
        }
    }
    
    public static void scenario1(List<Opportunity> oppList){
        // after update on opportunity
        Set<Id> accIds = new Set<Id>();
        List<Account> accListtoUpdate = new List<Account>();
        for(opportunity opp : oppList){
            if(opp.AccountId != NUll && opp.StageName == 'Closed Won'){
                accIds.add(opp.AccountId);
            }
        }
        List<Account> accList = [Select Id,Type,Name from Account where Id in : accIds];
        
        for(Account acc : accList){
            acc.Type ='Closed Won';
            accListtoUpdate.add(acc);
        }
        if(!accListtoUpdate.isEmpty()){
            update accListtoUpdate;
        }
        
    }
    // before insert on contact
    public static void scenario2(List<contact> conList){
        for(contact con : conList){
            if(con.AccountId == NUll || String.isBlank(con.AccountId)){
                con.addError('AccountId cannot be NUll');
            }
        }
	}
    
    // after insert, after update , after delete
    public static void rollUpOppAmountonAccount(List<Opportunity> oppList ,Map<Id, Opportunity> oldMap){
        Set<Id> accIds = New Set<Id>();
        List<Account> accListtoUpdate = new List<Account>();
        for(Opportunity opp : oppList){
            // after  ** after update
            if(oldMap == Null || oldMap.get(opp.Id).Amount != opp.Amount){
                accIds.add(opp.AccountId);
            }
            
        }
        Map<Id,Decimal> accArrMap = new Map<Id,Decimal>();
       // for(AggregateResult arr : [select AccountId accId , sum(Amount) amt from Opportunity where AccountId in :accIds group by AccountId]){
       //     accArrMap.put((id)arr.get('accId') , (Decimal)arr.get('amt'));
       // }
        
        //Map<Id,<id,Opportunity> accOppMap = new Map<Id,<id,Opportunity>();
        //Map<Id,integer> oppAccMap = new Map<Id,integer>();
        //Decimal total =0;
        for(opportunity opp : [select id,Amount,accountId from opportunity where accountId in :accids]){
            
             Decimal total = opp.amount;
            //Decimal total = accArrMap.containsKey(opp.AccountId) 
    //? accArrMap.get(opp.AccountId) + (opp.Amount == null ? 0 : opp.Amount) 
   // : (opp.Amount == null ? 0 : opp.Amount);

//accArrMap.put(opp.AccountId, total);
            if(accArrMap.containsKey(opp.AccountId)){
               
                integer count = 1;
                accArrMap.put(opp.AccountId, accArrMap.get(opp.AccountId)+total);
                //oppAccMap.put(opp.AmountId , oppAccMap.get(opp.AccountId) + count);
                
            }else{
                accArrMap.put(opp.AccountId ,total);
               // oppAccMap.put(opp.AccountId ,1);
            }
        }
        
        for(Id accId : accArrMap.keyset()){
            account acc = new account();
            acc.id = accId;
            acc.OpportunityAmount__c = accArrMap.get(accId);
            accListtoUpdate.add(acc);
        }
        if(!accListtoUpdate.isEmpty()){
            update accListtoUpdate;
        }
    }
    
    // after insert
    public static void cloneOpplIneItems(list<Opportunity> oppList){
        Map<Id,Id> cloneMap = new Map<Id,Id>();
        for(Opportunity opp : oppList){
            if(opp.Original_Opportunity__c != Null){
                cloneMap.put(opp.Original_Opportunity__c , opp.Id);
                
            }
        }
        
        List<opportunityLineItem> OLMCreate = new List<opportunityLineItem>();
        List<opportunityLineItem> oppLineItem = [select id, OpportunityId, PricebookEntryId, ProductCode, Quantity, unitPrice from opportunityLineItem where opportunityId in : cloneMap.keySet()];
        for(opportunityLineItem oLM : oppLineItem){
            OLMCreate.add(new opportunityLineItem(
                opportunityId =cloneMap.get(oLM.opportunityId),
                PricebookEntryId = oLM.PricebookEntryId,
                Quantity = oLM.Quantity,
            	unitPrice = oLM.unitPrice
            
            ) );
            
        }
        
        if(OLMCreate.size()>0){
        insert OLMCreate;
    }
    }
}