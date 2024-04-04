
@isTest
private class SOQLRecipes_1_Tests {
    @testSetup
    static void setup() {
        // Prepare test data
        List<Account> testAccounts = new List<Account>{
            new Account(Name='Test Account 1', ShippingStreet='123 Test St', ShippingCity='Test City'),
            new Account(Name='Test Account 2', ShippingStreet='456 Test Ave', ShippingCity='Testville')
        };
        insert testAccounts;
    }

    @isTest
    static void testGetRecordsWithAccounts() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Perform test
        Test.startTest();
        List<Account> accounts = SOQLRecipes.getRecords();
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, accounts, 'The result should not be null.');
        System.assertEquals(2, accounts.size(), 'There should be two accounts returned.');
    }

    @isTest
    static void testGetRecordsWithoutAccounts() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        // Deleting accounts to simulate no available accounts
        delete [SELECT Id FROM Account];

        // Perform test
        Test.startTest();
        List<Account> accounts = SOQLRecipes.getRecords();
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, accounts, 'The result should not be null.');
        System.assertEquals(0, accounts.size(), 'There should be no accounts returned.');
    }
}
