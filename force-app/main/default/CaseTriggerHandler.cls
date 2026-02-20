public with sharing class CaseTriggerHandler {
    public static void afterUpdateScenarioJob(List<Case> newCases, Map<Id, Case> oldCases) {
        List<Job__c> jobsToInsert = new List<Job__c>();
        List<JobLineItem__c> jobLineItemsToInsert = new List<JobLineItem__c>();

        for (Case newCase : newCases) {
            Case oldCase = oldCases.get(newCase.Id);
            if (oldCase != null && newCase.ApprovalStatus__c != oldCase.ApprovalStatus__c) {
                Job__c newJob = new Job__c();
                newJob.Case__c = newCase.Id;
                newJob.Status__c = 'New'; // Example status
                jobsToInsert.add(newJob);

                JobLineItem__c newJobLineItem = new JobLineItem__c();
                newJobLineItem.Job__c = newJob.Id;
                newJobLineItem.Description__c = 'Job created due to approval status change'; // Example description
                jobLineItemsToInsert.add(newJobLineItem);
            }
        }

        if (!jobsToInsert.isEmpty()) {
            insert jobsToInsert;
        }

        if (!jobLineItemsToInsert.isEmpty()) {
            insert jobLineItemsToInsert;
        }
    }
}