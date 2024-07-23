public class IndustryPicklistMetadata {
    
    private static MetadataService.MetadataPort service;
    
    public IndustryPicklistMetadata() {
        if(service == null) {
            service = createService();
        }
    }

	// Prepare the Org to call the Metadata API on the current user permissions
    private static MetadataService.MetadataPort createService() {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    
    // Update (Industry__c and Sub_Industry__c fields) & (dependent picklists) & (record type available picklists)
    public void updateFields() {        
        // Create Industry__c customfield Object to update the picklist
        MetadataService.CustomField industryCustomField = new MetadataService.CustomField();
        industryCustomField.label = '主計處行業別';
        industryCustomField.fullName = 'Account.Industry__c';
        industryCustomField.type_x = 'Picklist';
        
        // todo setIndustryPicklistToRecordType
        
        // todo replace the logic
        MetadataService.CustomValue firstPicklistValue = new MetadataService.CustomValue();
        firstPicklistValue.fullName = '農、牧業';
        firstPicklistValue.label = '農、牧業';
        firstPicklistValue.default_x = false;
        
        MetadataService.CustomValue secondPicklistValue = new MetadataService.CustomValue();
        secondPicklistValue.fullName = '林業';
        secondPicklistValue.label = '林業';
        secondPicklistValue.default_x = false;
        
        MetadataService.CustomValue thirdPicklistValue = new MetadataService.CustomValue();
        thirdPicklistValue.fullName = '電子零組件製造業';
        thirdPicklistValue.label = '電子零組件製造業';
        thirdPicklistValue.default_x = false;
        
        MetadataService.CustomValue fourthPicklistValue = new MetadataService.CustomValue();
        fourthPicklistValue.fullName = '電腦、電子產品及光學製品製造業';
        fourthPicklistValue.label = '電腦、電子產品及光學製品製造業';
        fourthPicklistValue.default_x = false;
		
        MetadataService.ValueSetValuesDefinition valueSetDefinition = new MetadataService.ValueSetValuesDefinition();
        valueSetDefinition.sorted = false;
        valueSetDefinition.value = new List<MetadataService.CustomValue>{firstPicklistValue, secondPicklistValue, thirdPicklistValue, fourthPicklistValue};
        
        MetadataService.ValueSettings controllingAndDependentValueSetting1 = new MetadataService.ValueSettings();
        controllingAndDependentValueSetting1.valueName = '農、牧業';
        controllingAndDependentValueSetting1.controllingFieldValue = new List<String>{'礦業及土石採取業'};
        
        MetadataService.ValueSettings controllingAndDependentValueSetting2 = new MetadataService.ValueSettings();
        controllingAndDependentValueSetting2.valueName = '林業';
        controllingAndDependentValueSetting2.controllingFieldValue = new List<String>{'礦業及土石採取業'};
		
        MetadataService.ValueSettings controllingAndDependentValueSetting3 = new MetadataService.ValueSettings();
        controllingAndDependentValueSetting3.valueName = '電腦、電子產品及光學製品製造業';
        controllingAndDependentValueSetting3.controllingFieldValue = new List<String>{'製造業'};
        
        /* Prepare the picklist with Controlling picklist field */
        MetadataService.ValueSet valueSet = new MetadataService.ValueSet();
        valueSet.controllingField = 'Industry__c';
        valueSet.restricted = true;
        valueSet.valueSetDefinition = valueSetDefinition;
        valueSet.valueSettings = new List<MetadataService.ValueSettings>{controllingAndDependentValueSetting1, controllingAndDependentValueSetting2, controllingAndDependentValueSetting3};
        
        // Create Sub_Industry__c customfield Object to update the picklist
        MetadataService.CustomField subIndustryCustomField = new MetadataService.CustomField();
        subIndustryCustomField.label = '主計處行業別子類';
        subIndustryCustomField.fullName = 'Account.Sub_Industry__c';
        subIndustryCustomField.type_x = 'Picklist';
        subIndustryCustomField.valueSet = valueSet;
        
        MetadataService.Metadata subIndustryRecordTypesMD = setSubIndustryPicklistToRecordType();
        
        MetadataService.SaveResult[] results = service.updateMetadata(new List<MetadataService.Metadata> {subIndustryCustomField, subIndustryRecordTypesMD});
        System.debug(results[0].success);
        System.debug(results[0].errors);
        // System.debug(results[1].success);
    }
    
    private MetadataService.Metadata setSubIndustryPicklistToRecordType() {
        MetadataService.Metadata[] recordTypesMDs = service.readMetadata('RecordType', new List<String>{'Account.Company'}).getRecords();
		
        MetadataService.PicklistValue picklistValue1 = new MetadataService.PicklistValue();
        picklistValue1.fullName = '農、牧業';
        picklistValue1.default_x = false;
        
        MetadataService.PicklistValue picklistValue2 = new MetadataService.PicklistValue();
        picklistValue2.fullName = '林業';
        picklistValue2.default_x = false;
        
        MetadataService.PicklistValue picklistValue3 = new MetadataService.PicklistValue();
        picklistValue3.fullName = '電子零組件製造業';
        picklistValue3.default_x = false;
        
        MetadataService.PicklistValue picklistValue4 = new MetadataService.PicklistValue();
        picklistValue4.fullName = '	電腦、電子產品及光學製品製造業';
        picklistValue4.default_x = false;
        
        List<MetadataService.PicklistValue> picklistValues = new List<MetadataService.PicklistValue>{picklistValue1, picklistValue2, picklistValue3, picklistValue4};
            
        MetadataService.RecordTypePicklistValue rtPickValue = new MetadataService.RecordTypePicklistValue();
        rtPickValue.picklist = 'Sub_Industry__c';
        rtPickValue.values = picklistValues;
        
        MetadataService.RecordTypePicklistValue[] rtPickValues = new MetadataService.RecordTypePicklistValue[]{};
        rtPickValues.add(rtPickValue);
        
        MetadataService.RecordType[] recordTypes = (MetadataService.RecordType[]) recordTypesMDs;
        recordTypes[0].picklistValues = rtPickValues;
        
        return recordTypesMDs[0];
    }
}