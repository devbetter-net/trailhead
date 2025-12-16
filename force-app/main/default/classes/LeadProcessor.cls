public without sharing class LeadProcessor implements Database.Batchable<sObject> {
 
    public Database.QueryLocator start(Database.BatchableContext dbContext){
        return Database.getQueryLocator([SELECT Id, Name FROM Lead]);
    }
    
    public void execute(Database.BatchableContext dbContext, List<Lead> leads){
        for (Lead l : leads){
            l.LeadSource = 'Dreamforce';
        }
        update leads;
    }
    
    public void finish(Database.BatchableContext dbContext){
        System.debug('Done');
    }
}