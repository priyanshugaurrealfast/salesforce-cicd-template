
@isTest
private class DMLRecipes_5_Tests {

    @testSetup
    static void setup() {
        // Create test data
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 2; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;
    }

    @isTest
    static void shouldUpdateAccountsSuccessfully() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Retrieve test data
        List<Account> accountsToUpdate = [SELECT Id, Name FROM Account];
        List<Account> updatedAccounts = DMLRecipes.updateAcccountViaKeyword(accountsToUpdate);

        // Assert results
        System.assertEquals(2, updatedAccounts.size(), 'Two accounts should be updated.');
        for (Account acct : updatedAccounts) {
            System.assert(acct.Name.endsWith('Updated via Keyword'), 'Account name should end with "Updated via Keyword".');
        }
    }

    @isTest
    static void shouldHandleEmptyListOfAccounts() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Attempt to update an empty list of accounts
        List<Account> updatedAccounts = DMLRecipes.updateAcccountViaKeyword(new List<Account>());

        // Assert that an empty list is handled gracefully
        System.assertEquals(0, updatedAccounts.size(), 'No accounts should be updated since the list is empty.');
    }

    @isTest
    static void shouldThrowExceptionOnDmlError() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Mock a DML exception by inserting a record that violates a unique constraint
        Account account = new Account(Name = 'UniqueNameForTest');
        insert account;
        account = [SELECT Id, Name FROM Account WHERE Name = 'UniqueNameForTest' LIMIT 1];
        account.Name = 'New Unique Name'; // Change the name to avoid duplicate error
        List<Account> accountsToUpdate = new List<Account>{account, account.clone(false, true)}; // Clone without Id to simulate insert

        // Expecting a DML exception due to duplicate field
        Boolean didThrow = false;
        try {
            DMLRecipes.updateAcccountViaKeyword(accountsToUpdate);
        } catch (DMLRecipes.CustomDMLException e) {
            didThrow = true;
        }
        System.assert(didThrow, 'A CustomDMLException should have been thrown due to DML error.');
    }
}
