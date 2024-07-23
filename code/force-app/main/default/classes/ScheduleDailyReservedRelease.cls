public with sharing class ScheduleDailyReservedRelease implements Schedulable{
    public ScheduleDailyReservedRelease() {

    }

    public void execute(SchedulableContext sctx){
        Id batchId = database.executebatch(new ReservedRelease());
    }
}