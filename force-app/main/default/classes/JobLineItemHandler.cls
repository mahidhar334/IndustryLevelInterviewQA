apex
// filepath: c:\Users\pmahidharreddy\OneDrive - IQVIA\Desktop\me\Training\vsCode Commits\salesforce-case-trigger-project\force-app\main\default\classes\JobLineItemHandler.cls
public class JobLineItemHandler {
    public static void afterUpdate(List<JobLineItem__c> jobLineItems) {
        if (jobLineItems.isEmpty()) return;

        // Collect Job IDs from updated JobLineItems
        Set<Id> jobIds = new Set<Id>();
        for (JobLineItem__c jli : jobLineItems) {
            jobIds.add(jli.JobId__c);
        }

        // Query all JobLineItems for those Jobs
        Map<Id, List<JobLineItem__c>> jobIdToLines = new Map<Id, List<JobLineItem__c>>();
        for (JobLineItem__c line : [
            SELECT Id, Status__c, JobId__c
            FROM JobLineItem__c
            WHERE JobId__c IN :jobIds
        ]) {
            if (!jobIdToLines.containsKey(line.JobId__c)) {
                jobIdToLines.put(line.JobId__c, new List<JobLineItem__c>());
            }
            jobIdToLines.get(line.JobId__c).add(line);
        }

        List<Job__c> jobsToUpdate = new List<Job__c>();

        // Check if all JobLineItems are closed for each Job
        for (Id jobId : jobIdToLines.keySet()) {
            Boolean allClosed = true;
            for (JobLineItem__c line : jobIdToLines.get(jobId)) {
                if (line.Status__c != 'Closed') {
                    allClosed = false;
                    break;
                }
            }
            if (allClosed) {
                Job__c jobRecord = new Job__c(Id = jobId, Status__c = 'Closed');
                jobsToUpdate.add(jobRecord);
            }
        }

        if (!jobsToUpdate.isEmpty()) {
            update jobsToUpdate;
        }
    }
}