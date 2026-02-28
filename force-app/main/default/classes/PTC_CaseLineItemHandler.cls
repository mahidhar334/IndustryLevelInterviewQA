public with sharing class PTC_CaseLineItemHandler {

    public static void handleCaseLineItemClosure(
        List<CaseLineItem> newList,
        Map<Id, CaseLineItem> oldMap
    ) {

        Set<Id> caseIds = new Set<Id>();

        // 1️⃣ Collect only cases where status changed to Closed
        for (CaseLineItem cli : newList) {

            if (cli.CaseId == null) continue;

            if (cli.Status == 'Closed' &&
                oldMap.get(cli.Id).Status != 'Closed') {

                caseIds.add(cli.CaseId);
            }
        }

        if (caseIds.isEmpty()) {
            return;
        }

        // 2️⃣ Query all CaseLineItems for those cases
        List<CaseLineItem> relatedItems = [
            SELECT Id, CaseId, Status
            FROM CaseLineItem
            WHERE CaseId IN :caseIds
        ];

        // 3️⃣ Track whether any open items exist
        Map<Id, Boolean> hasOpenItems = new Map<Id, Boolean>();

        for (Id caseId : caseIds) {
            hasOpenItems.put(caseId, false);
        }

        for (CaseLineItem cli : relatedItems) {
            if (cli.Status != 'Closed') {
                hasOpenItems.put(cli.CaseId, true);
            }
        }

        // 4️⃣ Close cases where no open items remain
        List<Case> casesToUpdate = new List<Case>();

        for (Case c : [
            SELECT Id, Status
            FROM Case
            WHERE Id IN :caseIds
            AND Status != 'Closed'
        ]) {

            if (hasOpenItems.get(c.Id) == false) {
                c.Status = 'Closed';
                casesToUpdate.add(c);
            }
        }

        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
}