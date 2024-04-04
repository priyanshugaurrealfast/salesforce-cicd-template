
@isTest
private class DMLRecipes_10_Tests {

    @testSetup
    static void setup() {
        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        delete testAccount;
    }

    private static List<Account> getTestAccounts() {
        return [SELECT Id, Name FROM Account WHERE IsDeleted = true ALL ROWS];
    }
    
    @isTest
    static void testUndeleteAccountViaDatabaseMethod_HappyPath() {
        List<Account> deletedAccounts = getTestAccounts();
        
        Test.startTest();
        List<Account> undeletedAccounts = DMLRecipes.undeleteAccountViaDatabaseMethod(deletedAccounts);
        Test.stopTest();

        // Assertions
        System.assertNotEquals(undeletedAccounts.size(), 0, 'Accounts should be undeleted');
        for (Account acct : undeletedAccounts) {
            System.assertNotEquals(acct.Id, null, 'Account Id should not be null after undelete');
        }
    }

    @isTest
    static void testUndeleteAccountViaDatabaseMethod_ExceptionalScenario() {
        // Prepare a deleted account
        List<Account> deletedAccounts = getTestAccounts();
        // Simulate that the account is not available for undelete (e.g., permanently deleted or not in the recycle bin)
        delete [SELECT Id FROM Account WHERE Id IN :deletedAccounts];

        Test.startTest();
        try {
            DMLRecipes.undeleteAccountViaDatabaseMethod(deletedAccounts);
            System.assert(false, 'Expected a CustomDMLException to be thrown');
        } catch (DMLRecipes.CustomDMLException e) {
            System.assertEquals('Failed', e.getMessage(), 'The exception message should match the expected value');
        }
        Test.stopTest();
    }
}
