public with sharing class CreateLead {
    @InvocableMethod(callout=true label='Create Leads')
    public static List<OutputVariables> createLeads(List<InputVariables> inputVariables){
        
        List<Lead> leads = inputVariables.get(0).leads;
        // List<Staging_Lead__c> stagingLeads = inputVariables.get(0).stagingLeads;
        Database.SaveResult[] saveResults = Database.insert(leads, false);

        Integer successCount = 0;
        Integer failureCount = 0;
        List<Lead> errorLead = new List<Lead>();

        for (Integer i = 0; i < saveResults.size(); i++) {
            Database.SaveResult result = saveResults[i];
            if (result.isSuccess()) {
                successCount++;
            } else {
                failureCount++;
                errorLead.add(leads[i]);
            }
        }
        
        OutputVariables output = new OutputVariables();
        output.successCount = successCount;
        output.failureCount = failureCount;
        output.errorLead = errorLead;
        
        List<OutputVariables> outputVariables = new List<OutputVariables>();
        outputVariables.add(output);

        return outputVariables;
    }

    public class OutputVariables{
        @InvocableVariable
        public Integer successCount;
        
        @InvocableVariable
        public Integer failureCount;

        @InvocableVariable
        public List<Lead> errorLead;
    }
        
    public class InputVariables{

        @InvocableVariable
        public List<Lead> leads;

        // @InvocableVariable
        // public List<Staging_Lead__c> stagingLeads;

    }
}