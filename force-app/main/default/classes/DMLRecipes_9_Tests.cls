
@isTest
private class DMLRecipes_9_Tests {

    // Using @testSetup to create test data for all test methods
    @testSetup
    static void setup() {
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        insert testAccounts;
        // Soft delete to prepare for undelete test
        delete testAccounts;
    }

    // Test method for happy path: Accounts are successfully undeleted when the user has read access.
    @isTest
    static void shouldUndeleteAccountsSuccessfully() {
        // Bypass triggers to avoid side effects
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Retrieve soft deleted accounts from the recycle bin
        List<Account> deletedAccounts = [SELECT Id FROM Account WHERE IsDeleted = true ALL ROWS];

        // Perform the undelete operation within a test context
        Test.startTest();
        List<Account> undeletedAccounts = DMLRecipes.undeleteAccountViaKeyword(deletedAccounts);
        Test.stopTest();

        // Retrieve accounts to assert that they have been undeleted
        List<Account> retrievedAccounts = [SELECT Id, Name FROM Account WHERE Id IN :undeletedAccounts];
        
        // Assert that the accounts have been undeleted
        System.assertEquals(2, retrievedAccounts.size(), 'There should be 2 accounts undeleted.');
        System.assertEquals('Test Account 1', retrievedAccounts[0].Name, 'The first account name should match.');
        System.assertEquals('Test Account 2', retrievedAccounts[1].Name, 'The second account name should match.');
    }
}
