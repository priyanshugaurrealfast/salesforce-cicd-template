
@isTest
public class BatchApexRecipes_1_Tests {

    @testSetup
    static void setup() {
        // Create test data for Accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        // Insert the test Accounts
        insert testAccounts;
    }

    private static void disableTriggers() {
        // Bypass the Account triggers before executing the batch
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testStartMethodReturnsCorrectQueryLocator() {
        disableTriggers();

        Test.startTest();
        BatchApexRecipes batchInstance = new BatchApexRecipes();
        Database.QueryLocator locator = batchInstance.start(null);
        Test.stopTest();

        // Assert the QueryLocator is not null
        System.assertNotEquals(null, locator, 'The QueryLocator should not be null.');

        // Assert the QueryLocator query is correct
        String expectedQuery = 'SELECT Id, Name FROM Account';
        String actualQuery = locator.getQuery();
        System.assertEquals(expectedQuery, actualQuery, 'The QueryLocator should have the correct query.');
    }
}
