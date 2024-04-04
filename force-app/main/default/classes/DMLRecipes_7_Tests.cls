
@isTest
private class DMLRecipes_7_Tests {

    @testSetup
    static void setup() {
        // Creating test data
        List<Account> testAccounts = new List<Account>{
            new Account(Name='Test Account 1'),
            new Account(Name='Test Account 2')
        };
        insert testAccounts;
    }

    private static void disableTriggers() {
        // Bypassing triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    @isTest
    static void testDeleteAccountViaKeyword_Success() {
        disableTriggers();

        // Retrieve test data
        List<Account> accountsToDelete = [SELECT Id, Name FROM Account];

        // Perform test
        Test.startTest();
        DMLRecipes.deleteAccountViaKeyword(accountsToDelete);
        Test.stopTest();

        // Assert results
        List<Account> postDeleteAccounts = [SELECT Id FROM Account];
        System.assertEquals(0, postDeleteAccounts.size(), 'Accounts should be deleted');
    }

    @isTest
    static void testDeleteAccountViaKeyword_DmlException() {
        disableTriggers();

        // Retrieve and delete the test data to set up for our DML exception test
        List<Account> accountsToDelete = [SELECT Id, Name FROM Account];
        delete accountsToDelete;

        // Now the accounts have been deleted, attempting to delete them again should cause a DmlException
        Test.startTest();
        Boolean exceptionCaught = false;
        try {
            DMLRecipes.deleteAccountViaKeyword(accountsToDelete);
        } catch(DMLRecipes.CustomDMLException e) {
            exceptionCaught = true;
        }
        Test.stopTest();

        // Assert that a DmlException was caught
        System.assert(exceptionCaught, 'A DmlException should be caught when attempting to delete already deleted accounts');
    }
}
