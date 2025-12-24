// public class OppLineItemCountOnAccountHandler {
//     public static void updateCountOnAccount(List<OpportunityLineItem> oppLineList) {
//         // Collect Opportunity IDs
//         Set<Id> oppIds = new Set<Id>();
//         for (OpportunityLineItem oli : oppLineList) {
//             oppIds.add(oli.OpportunityId);
//         }

//         // Query Opportunities with AccountId
//         Map<Id, Id> oppToAccMap = new Map<Id, Id>();
//         for (Opportunity opp : [SELECT Id, AccountId FROM Opportunity WHERE Id IN :oppIds]) {
//             if (opp.AccountId != null) {
//                 oppToAccMap.put(opp.Id, opp.AccountId);
//             }
//         }

//         // Count OLIs per Account
//         Map<Id, Integer> accOliCountMap = new Map<Id, Integer>();
//         for (OpportunityLineItem oli : oppLineList) {
//             Id accId = oppToAccMap.get(oli.OpportunityId);
//             if (accId != null) {
//                 accOliCountMap.put(accId, accOliCountMap.get(accId) == null ? 1 : accOliCountMap.get(accId) + 1);
//             }
//         }

//         // Build Account updates
//         List<Account> accUpdateList = new List<Account>();
//         for (Id accId : accOliCountMap.keySet()) {
//             accUpdateList.add(new Account(
//                 Id = accId,
//                 Total_OLI_Count__c = accOliCountMap.get(accId)
//             ));
//         }

//         if (!accUpdateList.isEmpty()) {
//             update accUpdateList;
//         }
//     }
// }

// ////////////////////////////////////////////////////////////////////////////////////////////////

public with sharing class OpportunityLineItemTriggerHandler {
    public static void handleAfterInsert(List<OpportunityLineItem> newItems) {
        Set<Id> oppIds = new Set<Id>();
        for (OpportunityLineItem oli : newItems) {
            if (oli.OpportunityId != null) oppIds.add(oli.OpportunityId);
        }
        if (oppIds.isEmpty()) return;

        // Map opportunities to their account ids
        Map<Id, Id> oppToAcc = new Map<Id, Id>();
        for (Opportunity o : [SELECT Id, AccountId FROM Opportunity WHERE Id IN :oppIds AND AccountId != NULL]) {
            oppToAcc.put(o.Id, o.AccountId);
        }
        if (oppToAcc.isEmpty()) return;

        Set<Id> accountIds = new Set<Id>(oppToAcc.values());

        // Aggregate count of OpportunityLineItem grouped by Opportunity.AccountId
        List<AggregateResult> aggs = [SELECT Opportunity.AccountId accId, COUNT(Id) cnt FROM OpportunityLineItem WHERE Opportunity.AccountId IN :accountIds GROUP BY Opportunity.AccountId];
        Map<Id, Integer> accCounts = new Map<Id, Integer>();
        for (AggregateResult ar : aggs) {
            Id accId = (Id) ar.get('accId');
            Decimal d = (Decimal) ar.get('cnt');
            Integer cnt = d == null ? 0 : d.intValue();
            accCounts.put(accId, cnt);
        }

        List<Account> accsToUpdate = new List<Account>();
        for (Id accId : accountIds) {
            Integer cnt = accCounts.containsKey(accId) ? accCounts.get(accId) : 0;
            accsToUpdate.add(new Account(Id = accId, Total_OLI_Count__c = cnt));
        }

        if (!accsToUpdate.isEmpty()) update accsToUpdate;
    }
}