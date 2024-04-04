
@isTest
private class AccountTriggerHandler_4_Tests {

    // Test setup to create test data
    @testSetup
    static void setupTestData() {
        // Create test accounts
        List<Account> testAccounts = new List<Account>();
        for (Integer i = 0; i < 2; i++) {
            testAccounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert testAccounts;
    }

    // Test method for the happy path scenario where the user has permissions
    @isTest
    static void testAfterUpdateWithPermissions() {
        // Bypass other triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Prepare test data
        List<Account> accountsToUpdate = [SELECT Id, Name FROM Account];
        for (Account acc : accountsToUpdate) {
            acc.Name += ' Updated';
        }
        update accountsToUpdate;

        // Test afterUpdate context
        Test.startTest();
        // We simulate trigger execution as it happens automatically during DML
        Test.stopTest();

        // Assertions
        List<Task> relatedTasks = [SELECT Id, WhatId FROM Task WHERE WhatId IN :accountsToUpdate];
        System.assertEquals(2, relatedTasks.size(), 'Two tasks should be created for the updated accounts');
        for (Task tsk : relatedTasks) {
            System.assert(tsk.Subject.contains('Account was updated'), 'The task subject should indicate an account update');
        }
    }

    // Test method for the exceptional scenario where the circuit breaker is triggered
    @isTest
    static void testAfterUpdateWithCircuitBreaker() {
        // Bypass other triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');

        // Set circuit breaker to simulate an exception
        AccountTriggerHandler.circuitBreaker = new AccountTriggerHandler.AccountTriggerHandlerException('Simulated Exception');

        // Prepare test data
        List<Account> accountsToUpdate = [SELECT Id, Name FROM Account];
        for (Account acc : accountsToUpdate) {
            acc.Name += ' Updated';
        }

        // Test afterUpdate context
        Test.startTest();
        // Expect an exception to be thrown, so we catch it
        Boolean didThrow = false;
        try {
            update accountsToUpdate;
        } catch (AccountTriggerHandler.AccountTriggerHandlerException e) {
            didThrow = true;
        }
        Test.stopTest();

        // Assertions
        System.assertEquals(true, didThrow, 'A custom exception should be thrown when circuit breaker is set');
    }
}
