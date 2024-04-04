
@isTest
private class DMLRecipes_8_Tests {

    @testSetup
    static void setupTestData() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Test Account ' + String.valueOf(i)));
        }
        insert accounts;
    }
    
    @isTest
    static void shouldSuccessfullyDeleteAccounts() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        List<Account> testAccounts = [SELECT Id FROM Account];
        
        Test.startTest();
        DMLRecipes.deleteAccountViaDatabaseMethod(testAccounts);
        Test.stopTest();
        
        List<Account> remainingAccounts = [SELECT Id FROM Account];
        System.assertEquals(0, remainingAccounts.size(), 'All accounts should have been deleted.');
    }

    @isTest
    static void shouldThrowExceptionOnLackOfDestroyPermission() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        List<Account> testAccounts = [SELECT Id FROM Account LIMIT 1];
        Boolean exceptionThrown = false;

        Test.startTest();
        try {
            DMLRecipes.deleteAccountViaDatabaseMethod(testAccounts);
        } catch (DMLRecipes.CustomDMLException e) {
            exceptionThrown = true;
        }
        Test.stopTest();

        System.assert(exceptionThrown, 'A CustomDMLException should have been thrown due to lack of destroy permission.');
    }

    @isTest
    static void shouldThrowDmlExceptionDuringDeletion() {
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        
        List<Account> validAccounts = [SELECT Id FROM Account];
        Account invalidAccount = new Account(Id = '00000000XXXX000000');
        validAccounts.add(invalidAccount);
        
        Boolean dmlExceptionThrown = false;

        Test.startTest();
        try {
            DMLRecipes.deleteAccountViaDatabaseMethod(validAccounts);
        } catch (DmlException e) {
            dmlExceptionThrown = true;
        }
        Test.stopTest();

        System.assert(dmlExceptionThrown, 'A DMLException should have been thrown due to an invalid account Id.');
    }
}
