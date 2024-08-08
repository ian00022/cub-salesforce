/*
* Author: IBM
* Date: 2024/08/02
*
* Description: Schedulable Apex used to run FirstAccountPlanTaskBatch
* Apex jobs can be setup in Setup > Custom Code > Apex Classes > Schedule Apex
* Test: Test_FirstAccountPlanTask
*/
global class FirstAccountPlanTaskSchedulable implements Schedulable {
    global FirstAccountPlanTaskSchedulable(){
        
    }
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new FirstAccountPlanTaskBatch());
    }
}