trigger Trigger_AAR on FinServ__AccountAccountRelation__c(before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    if(Trigger.isBefore && Trigger.isInsert) {
        AARTriggerHandler.uiCreateAddExternalId(Trigger.new);
        
        // System.debug('@@before insert');
        //System.debug('FinServ__Account__c: '+Trigger.new[0].FinServ__Account__c + '-FinServ__RelatedAccount__c: ' + +Trigger.new[0].FinServ__RelatedAccount__c + '-FinServ__InverseRelationship__c: ' + Trigger.new[0].FinServ__InverseRelationship__c);
    }
    if(Trigger.isAfter && Trigger.isInsert) {
        // AAR record which is user created or dataloader import
        if(Trigger.new[0].FinServ__InverseRelationship__c == null) {
            System.debug([SELECT Id FROM FinServ__AccountAccountRelation__c WHERE FinServ__InverseRelationship__c = :Trigger.new[0].Id]);
        }
        // System.debug('@@after insert');
        //System.debug('FinServ__Account__c: '+Trigger.new[0].FinServ__Account__c + '-FinServ__RelatedAccount__c: ' + +Trigger.new[0].FinServ__RelatedAccount__c + '-FinServ__InverseRelationship__c: ' + Trigger.new[0].FinServ__InverseRelationship__c);
    }
    if(Trigger.isBefore && Trigger.isUpdate) {
        AARTriggerHandler.setInverseRelationship(Trigger.oldMap, Trigger.new);
        //System.debug('@@before update');
        //System.debug('FinServ__Account__c: '+Trigger.new[0].FinServ__Account__c + '-FinServ__RelatedAccount__c: ' + +Trigger.new[0].FinServ__RelatedAccount__c + '-FinServ__InverseRelationship__c: ' + Trigger.new[0].FinServ__InverseRelationship__c);
    }
    if(Trigger.isAfter && Trigger.isUpdate) {
        //System.debug('@@after update');
        //System.debug('FinServ__Account__c: '+Trigger.new[0].FinServ__Account__c + '-FinServ__RelatedAccount__c: ' + +Trigger.new[0].FinServ__RelatedAccount__c + '-FinServ__InverseRelationship__c: ' + Trigger.new[0].FinServ__InverseRelationship__c);
    }
}