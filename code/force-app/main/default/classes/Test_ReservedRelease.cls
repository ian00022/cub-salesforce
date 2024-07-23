@isTest
private class Test_ReservedRelease {

    @isTest
    static void myUnitTest() {
        Account account = new Account();
        account.recordtypeId = '012H3000000oqvUIAQ';
        account.Name = '法人D';
		account.customer_ID__c = '11112222';
        account.responsible_RM__c = '005H3000001OwZzIAK';
        account.Identification_Type__c = '21-營利事業統一編號(本國)';
        account.Customer_Data_Country__c = 'TW';
        account.preOccupy_End_Date__c = Date.newInstance(2024, 7, 14);

        insert account;

        Test.startTest();
        ReservedRelease rr = new ReservedRelease();
        Id batchId = Database.executeBatch(rr);
        Test.stopTest();

        Account assertAccount = [SELECT Id, Release_Date__c,Responsible_RM__c FROM Account WHERE Name = '法人D' LIMIT 1];
        System.assertEquals(assertAccount.Responsible_RM__c, null, 'Assertion failed!');
        System.assertEquals(assertAccount.Release_Date__c, null, 'Assertion failed!');
    }
}