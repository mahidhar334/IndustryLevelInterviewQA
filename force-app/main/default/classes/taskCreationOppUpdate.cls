/**
* @File Name : leadCreationOppUpdate.cls
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

public class taskCreationOppUpdate {
	public static void taskCreation(list<opportunity> oppList , Map<id, Opportunity> oldMap){
		list<Task> taskInsert = New list<Task>();
		for(opportunity opp : oppList){
			opportunity oldOpp = oldMap.get(opp.Id);
			if(oldOpp.StageName =='Perception Analysis' &&  (opp.stageName =='Qualification' ||  opp.stageName =='Prospecting') ){

				Task tsk = new Task();
				tsk.subject ='Important Task';
				tsk.WhatId = opp.Id;
				tsk.OwnerId = opp.ownerId;
				tsk.ActivityDate = opp.LastModifiedDate.date().addDays(1);
				tsk.status = 'New';
				tsk.Priority ='High';
				taskInsert.add(tsk);

			}
		}

		if(taskInsert.size()>0){
			insert taskInsert;
		}
	}
}