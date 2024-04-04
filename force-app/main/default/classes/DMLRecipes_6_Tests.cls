
@isTest
private class DMLRecipes_6_Tests {

    @testSetup
    static void setup() {
        // Prepare a list of accounts for the tests
        List<Account> accountsToInsert = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        insert accountsToInsert;
    }

    @isTest
    static void testHappyPathUpdateAccountViaDatabaseMethod() {
        // Disable triggers before performing DML in tests
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Retrieve test data
        List<Account> accountsToUpdate = [SELECT Name FROM Account];
        
        // Perform update operation
        Test.startTest();
        List<Account> updatedAccounts = DMLRecipes.updateAccountViaDatabaseMethod(accountsToUpdate);
        Test.stopTest();

        // Assert that accounts are updated
        for (Account acct : updatedAccounts) {
            System.assertEquals(true, acct.Name.endsWith(' Updated via Keyword'), 'Account name should have suffix " Updated via Keyword"');
        }
    }
}
