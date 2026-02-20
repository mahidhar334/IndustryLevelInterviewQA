apex
// filepath: c:\Users\pmahidharreddy\OneDrive - IQVIA\Desktop\me\Training\vsCode Commits\salesforce-case-trigger-project\force-app\main\default\classes\JobHandler.cls
public class JobHandler {
    public static void afterUpdate(List<Job__c> jobs) {
        if (jobs.isEmpty()) return;

        // Collect Case IDs from updated Jobs
        Set<Id> caseIds = new Set<Id>();
        for (Job__c job : jobs) {
            if (job.CaseId__c != null) {
                caseIds.add(job.CaseId__c);
            }
        }

        if (caseIds.isEmpty()) return;

        // Query all Jobs for those Cases
        Map<Id, List<Job__c>> caseIdToJobs = new Map<Id, List<Job__c>>();
        for (Job__c job : [
            SELECT Id, Status__c, CaseId__c
            FROM Job__c
            WHERE CaseId__c IN :caseIds
        ]) {
            if (!caseIdToJobs.containsKey(job.CaseId__c)) {
                caseIdToJobs.put(job.CaseId__c, new List<Job__c>());
            }
            caseIdToJobs.get(job.CaseId__c).add(job);
        }

        List<Case> casesToUpdate = new List<Case>();

        // Check if all Jobs are closed for each Case
        for (Id caseId : caseIdToJobs.keySet()) {
            Boolean allClosed = true;
            for (Job__c job : caseIdToJobs.get(caseId)) {
                if (job.Status__c != 'Closed') {
                    allClosed = false;
                    break;
                }
            }
            if (allClosed) {
                Case caseRecord = new Case(Id = caseId, Status = 'Closed');
                casesToUpdate.add(caseRecord);
            }
        }

        if (!casesToUpdate.isEmpty()) {
            update casesToUpdate;
        }
    }
}