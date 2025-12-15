trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

    List<Task> tasksToInsert = new List<Task>();

    for (Opportunity opp : Trigger.new) {

        // For updates, only act when Stage changes to Closed Won
        Opportunity oldOpp = Trigger.isUpdate ? Trigger.oldMap.get(opp.Id) : null;

        Boolean isNewClosedWon =
            opp.StageName == 'Closed Won' &&
            (Trigger.isInsert || oldOpp.StageName != 'Closed Won');

        if (isNewClosedWon) {

            Task followUpTask = new Task();
            followUpTask.Subject = 'Follow Up Test Task';
            followUpTask.WhatId = opp.Id;
            followUpTask.Status = 'Not Started';
            followUpTask.Priority = 'Normal';

            tasksToInsert.add(followUpTask);
        }
    }

    if (!tasksToInsert.isEmpty()) {
        insert tasksToInsert;
    }
}