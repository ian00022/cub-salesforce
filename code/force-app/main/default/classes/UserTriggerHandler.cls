/*
* Author: IBM
* Date: 2024/07/18
*
* Description: User Trigger Handler used to update a text field with a picklist label value
*/
public inherited sharing class UserTriggerHandler {
    
    public static void UpdateLabelValue(List<User> newUser){
        Map<String, String> unitPicklistMap = new Map<String, String>();
        List<Schema.PicklistEntry> units = Schema.SObjectType.User.fields.Unit__c.getPicklistValues();
        
        for(Schema.PicklistEntry ple :units){
            unitPicklistMap.put(ple.getValue(), ple.getLabel());
        }
        
        for(User u: newUser){
            u.Unit_Name__c = unitPicklistMap.get(u.Unit__c);
        }
    }
}