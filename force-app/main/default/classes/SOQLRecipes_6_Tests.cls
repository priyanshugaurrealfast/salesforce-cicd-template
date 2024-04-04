
@isTest
private class SOQLRecipes_6_Tests {

    // Test setup method to create test data
    @testSetup
    static void setup() {
        // Prepare a list of more than 10 Account records to test different scenarios
        List<Account> accountsToInsert = new List<Account>();
        for (Integer i = 0; i < 15; i++) {
            accountsToInsert.add(new Account(Name='TestAccount' + i));
        }
        insert accountsToInsert;
    }

    // Happy Path Test: When there are 10 or more Account records available
    @isTest
    static void testGetSpecificNumberOfRecordsHappyPath() {
        // Bypass the trigger handlers on the Account object
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        Test.startTest();
        List<Account> accounts = SOQLRecipes.getSpecificNumberOfRecords();
        Test.stopTest();

        // Assertions
        System.assertEquals(10, accounts.size(), 'There should be exactly 10 accounts returned.');
        System.assertNotEquals(null, accounts, 'The returned accounts list should not be null.');
    }

    // Sad Path Test: When there are fewer than 10 Account records available
    @isTest
    static void testGetSpecificNumberOfRecordsSadPath() {
        // Bypass the trigger handlers on the Account object
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Deleting some accounts to create a scenario with less than 10 records
        List<Account> accountsToDelete = [SELECT Id FROM Account LIMIT 10];
        delete accountsToDelete;

        Test.startTest();
        List<Account> accounts = SOQLRecipes.getSpecificNumberOfRecords();
        Test.stopTest();

        // Assertions
        Integer actualSize = accounts.size();
        System.assert(actualSize <= 10, 'There should be 10 or fewer accounts returned.');
        System.assertNotEquals(0, actualSize, 'The number of accounts should be greater than 0.');
    }
}
