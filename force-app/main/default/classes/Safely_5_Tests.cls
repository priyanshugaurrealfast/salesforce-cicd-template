
@isTest
private class Safely_5_Tests {

    @testSetup
    static void setup() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Bypass triggers
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
    }

    // Test updating records with permission
    @isTest
    static void testUpdateWithPermission() {
        List<Account> accountsToUpdate = [SELECT Id FROM Account LIMIT 1];
        accountsToUpdate[0].Name = 'Updated Name';

        Test.startTest();
        Safely safelyInstance = new Safely();
        List<Database.SaveResult> saveResults = safelyInstance.doUpdate(accountsToUpdate);
        Test.stopTest();

        System.assertEquals(1, saveResults.size(), 'There should be one save result');
        System.assert(saveResults[0].isSuccess(), 'The update should be successful');
    }

    // Test updating records without permission
    @isTest
    static void testUpdateWithoutPermission() {
        List<Account> accountsToUpdate = [SELECT Id FROM Account LIMIT 1];
        accountsToUpdate[0].Name = 'Another Name';

        Test.startTest();
        Safely safelyInstance = new Safely();
        List<Database.SaveResult> saveResults = safelyInstance.doUpdate(accountsToUpdate);
        Test.stopTest();

        System.assertEquals(0, saveResults.size(), 'There should be no save results due to lack of permissions');
    }

    // Test updating empty list
    @isTest
    static void testUpdateEmptyList() {
        List<Account> emptyList = new List<Account>();

        Test.startTest();
        Safely safelyInstance = new Safely();
        List<Database.SaveResult> saveResults = safelyInstance.doUpdate(emptyList);
        Test.stopTest();

        System.assertEquals(0, saveResults.size(), 'There should be no save results for an empty list');
    }

    // Test for RemovedFieldsException when fields are removed and throwIfRemovedFields is true
    @isTest
    static void testUpdateWithRemovedFieldsException() {
        List<Account> accountsToUpdate = [SELECT Id FROM Account LIMIT 1];
        accountsToUpdate[0].Name = 'Inaccessible Name';

        Test.startTest();
        Safely safelyInstance = new Safely().throwIfRemovedFields();
        Exception caughtException = null;
        try {
            List<Database.SaveResult> saveResults = safelyInstance.doUpdate(accountsToUpdate);
        } catch (Exception e) {
            caughtException = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, caughtException, 'An exception should have been thrown');
        System.assertEquals(Safely.RemovedFieldsException.class, caughtException.getClass(), 'The exception should be a RemovedFieldsException');
        System.assert(caughtException.getMessage().contains('ThrowIfRemovedFields is enabled'), 'Exception message should indicate that ThrowIfRemovedFields is enabled');
    }

    // Test updating records with allOrNothing=true and all successful
    @isTest
    static void testUpdateAllOrNothingSuccessful() {
        List<Account> accountsToUpdate = [SELECT Id FROM Account LIMIT 1];
        accountsToUpdate[0].Name = 'Updated Name AllOrNothing';

        Test.startTest();
        Safely safelyInstance = new Safely().allOrNothing();
        List<Database.SaveResult> saveResults = safelyInstance.doUpdate(accountsToUpdate);
        Test.stopTest();

        System.assertEquals(1, saveResults.size(), 'There should be one save result');
        System.assert(saveResults[0].isSuccess(), 'The update should be successful');
    }
}
