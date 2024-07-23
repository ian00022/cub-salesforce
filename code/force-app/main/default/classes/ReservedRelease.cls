global with sharing class ReservedRelease implements Database.Batchable<SObject>{
    public ReservedRelease() {

    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator('SELECT Id, Release_Date__c,Responsible_RM__c  FROM Account WHERE Release_Date__c = Today AND Managed_RM__c = null');
    }

    public void execute(Database.BatchableContext bc, List<Account> accounts){
        for(Account account : accounts){
            if(account.Release_Date__c == Date.today()){
                account.Responsible_RM__c = null;
            }
        }
        update accounts;
    }

    public void finish(Database.BatchableContext bc){
        System.debug('finish');
    }
}