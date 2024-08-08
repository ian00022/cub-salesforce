public with sharing class AARTriggerHandler {
    public AARTriggerHandler() {

    }

    public static void setInverseRelationship(Map<Id,FinServ__AccountAccountRelation__c> oldItems, List<FinServ__AccountAccountRelation__c> newLists){
        for(FinServ__AccountAccountRelation__c aar : newLists){
            //此ID 為 特定虛擬ID 換org需更換
            if(aar.FinServ__InverseRelationship__c != null && aar.FinServ__InverseRelationship__c.equals('a00H3000001Fy6CIAS')){
                aar.FinServ__InverseRelationship__c = oldItems.get(aar.Id).FinServ__InverseRelationship__c;
            }
        }
    }

    public static void uiCreateAddExternalId(List<FinServ__AccountAccountRelation__c> newLists){
        for(FinServ__AccountAccountRelation__c aar : newLists){
            aar.CUB_External_Id__c = aar.Relation_Record_Key__c;
        }
    }

}