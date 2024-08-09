/*
* Author: IBM
* Date: 2024/08/01
*
* Description: Batch used to create Tasks for 非授信 Accounts that have never filled in any Account Plan survey.
* Tasks are created three months before the 非授信戶最早往來日期(Earliest_NonCredit_Date__c), w/o taking year into account.
* Due date is one month prior the date mentioned above.
* Test: Test_FirstAccountPlanTask
*/
global class FirstAccountPlanTaskBatch implements Database.Batchable<sObject>{
	private String query;
    private String threeMonthsLaterDate; // 3 months later's date in d/M format i.e. Aug 1st = 1/8, Oct 12th = 12/10, November 1st = 1/11
    private List<Task> tasksToInsert;
    
    global FirstAccountPlanTaskBatch(){
        tasksToInsert = new List<Task>();
        
        Datetime threeMonthsDate = System.today().addMonths(3);
        threeMonthsLaterDate = DateTime.newInstance(threeMonthsDate.year(), threeMonthsDate.month(), threeMonthsDate.day()).format('d/M');
        
        query = 'SELECT Id, Earliest_NonCredit_Date__c, Earliest_NonCredit_ddMM__c, Name, OwnerId ' + 
            ' FROM Account ' + 
            ' WHERE Loan__c = false AND Has_Approved_Account_Plan__c = false AND Earliest_NonCredit_ddMM__c =: threeMonthsLaterDate';
        
        System.Debug('[FirstAccountPlanTaskBatch]' + threeMonthsLaterDate);
        System.Debug('[FirstAccountPlanTaskBatch]' + query);
    }
    
    global database.querylocator start(Database.BatchableContext BC){
    	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        Task tmpTask;
        for(Account a: scope){
            tmpTask = new Task();
            tmpTask.WhatId = a.Id;
            tmpTask.OwnerId = a.OwnerId;
            tmpTask.Subject = '[' + a.Name + '] ' + System.Label.FirstAccountPlanSubject;
            tmpTask.Description = System.Label.FirstAccountPlanDescription;
            tmpTask.ActivityDate = Date.Today().addMonths(2); // Due date must be a month before the reference date
            tasksToInsert.add(tmpTask);
        }
        
        System.debug('[FirstAccountPlanTaskBatch] Tasks to insert: ' + tasksToInsert.size());
        try{
           if(tasksToInsert.size() > 0) insert tasksToInsert; 
        } catch (Exception e){
            System.debug('[FirstAccountPlanTaskBatch]' + e);
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        System.debug('[FirstAccountPlanTaskBatch] finish');
    }
}