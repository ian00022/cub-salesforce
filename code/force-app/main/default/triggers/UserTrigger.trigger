/*
* Author: IBM
* Date: 2024/07/18
*
* Description: User Trigger to run before an insert or update is done
*/
trigger UserTrigger on User (before insert, before update) {
	Map<Id, User> newUserMap = trigger.newMap;
    Map<Id, User> oldUserMap = trigger.oldMap;
    List<User> usersToUpdate = new List<User>();
    
    if(trigger.isBefore){
        if(trigger.isInsert){
            for(User u: trigger.new){
                if(String.IsNotBlank(u.Unit__c)){
                    usersToUpdate.add(u);
                }
            }
        } else {
            for(String key: newUserMap.keySet()){
                if(oldUserMap.get(key).Unit__c != newUserMap.get(key).Unit__c){
                    usersToUpdate.add(newUserMap.get(key));
                }
            }
        }
        if(usersToUpdate.size() > 0) UserTriggerHandler.UpdateLabelValue(usersToUpdate);
    }
}