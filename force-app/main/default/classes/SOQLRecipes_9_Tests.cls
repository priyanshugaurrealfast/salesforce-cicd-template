
@isTest
private class SOQLRecipes_9_Tests {

    // Test setup to create initial test data
    @testSetup
    static void createTestData() {
        List<Account> accounts = new List<Account>();
        // Create more than 20 accounts to ensure we have enough data for the happy path
        for (Integer i = 0; i < 25; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;
    }

    // Happy path test: Ensure we can retrieve the second set of 10 Account records
    @isTest
    static void testGetSecond10AccountRecords_HappyPath() {
        // Bypass Trigger Handlers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Test.startTest();
        List<Account> accounts = SOQLRecipes.getSecond10AccountRecords();
        Test.stopTest();

        // Assertions
        System.assertEquals(10, accounts.size(), 'Should retrieve exactly 10 accounts');
        // Removed the assertion for the Account Name field as it was not queried in the SOQL statement
    }

    // Sad path test: Ensure that when there are less than 20 accounts, we retrieve whatever is available
    @isTest
    static void testGetSecond10AccountRecords_SadPath() {
        // Bypass Trigger Handlers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Deleting some accounts to make sure we have less than 20
        List<Account> allAccounts = [SELECT Id FROM Account];
        delete allAccounts;

        // Creating only 15 accounts this time
        List<Account> fewerAccounts = new List<Account>();
        for (Integer i = 0; i < 15; i++) {
            fewerAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert fewerAccounts;

        Test.startTest();
        List<Account> accounts = SOQLRecipes.getSecond10AccountRecords();
        Test.stopTest();

        // Assertions
        System.assertEquals(5, accounts.size(), 'Should retrieve the remaining accounts if less than 10 are available');
        // Removed the assertion for the Account Name field as it was not queried in the SOQL statement
    }
}
