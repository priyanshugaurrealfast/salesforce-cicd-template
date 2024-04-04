
@isTest
private class StripInaccessibleRecipes_2_Tests {

    // Use testSetup to create the test data for the test methods
    @testSetup
    static void makeTestData() {
        // Create an Account record
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        // Create a Contact record associated with the Account created above
        Contact testContact = new Contact(LastName='Test Contact', AccountId=testAccount.Id);
        insert testContact;
    }

    // Happy Path Test
    @isTest
    static void testStripInaccessibleFromSubqueryWithAccess() {
        // Bypass triggers for the test context
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Perform the test
        Test.startTest();
        List<Account> accounts = StripInaccessibleRecipes.stripInaccessibleFromSubquery();
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, accounts, 'Accounts should not be null');
        System.assertNotEquals(0, accounts.size(), 'Accounts should not be empty');
    }

    // Exceptional Scenario Test
    @isTest
    static void testStripInaccessibleFromSubqueryWithNoRecords() {
        // Bypass triggers for the test context
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Delete test data to simulate no records
        delete [SELECT Id FROM Contact];
        delete [SELECT Id FROM Account];

        // Perform the test
        Test.startTest();
        List<Account> accounts = StripInaccessibleRecipes.stripInaccessibleFromSubquery();
        Test.stopTest();

        // Assertions
        System.assertEquals(0, accounts.size(), 'There should be no Account records');
    }
}
