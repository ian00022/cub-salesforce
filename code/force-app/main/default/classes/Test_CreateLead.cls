@isTest
private class Test_CreateLead {

    @isTest
    static void myUnitTest() {
        List<CreateLead.InputVariables> inputVariables = new List<CreateLead.InputVariables>();

        List<Lead> leads = new List<Lead>();
        Lead l = new Lead();
        l.LastName = 'TestLead';
        l.Company = 'Test';
        l.customer_Id__c = '11111111';
        leads.add(l);

        CreateLead.InputVariables input = new CreateLead.InputVariables();
        input.leads = leads;
        inputVariables.add(input);

        insert leads;

        Test.startTest();

        List<CreateLead.OutputVariables> outputVariables = CreateLead.createLeads(inputVariables);

        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM Lead WHERE LastName = 'TestLead']);
    }
}