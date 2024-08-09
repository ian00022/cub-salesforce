@IsTest
public class Test_FirstAccountPlanTask {
	@TestSetup
    public static void SetupData(){
        Account acc = new Account();
        acc.Name = 'Account Test';
        acc.Earliest_NonCredit_Date__c = system.today().addMonths(3);
        acc.Has_Approved_Account_Plan__c = false;
        acc.Loan__c = false;
        acc.Customer_Data_Country__c = 'TW';
        acc.Customer_ID__c = '123456789';
        acc.Identification_Type__c = '21';
        
        insert acc;
    }
    
    @IsTest
    public static void FirstAccountPlanTask(){
        Test.startTest();
        // The schedulable also covers the batch
        System.Schedule('FirstAccountPlanTaskSchedulable','0 0 13 * * ?', new FirstAccountPlanTaskSchedulable());
        Test.stopTest();
    }
}