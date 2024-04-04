
@isTest
private class Safely_9_Tests {
    // Use @testSetup to create test data
    @testSetup
    static void setup() {
        // Prepare test data
        List<Account> accounts = new List<Account>{
            new Account(Name='Test Account 1'),
            new Account(Name='Test Account 2')
        };
        insert accounts;
    }

    // Test deleting records with permissions
    @isTest
    static void testDoDeleteWithPermissions() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        List<Account> accounts = [SELECT Id FROM Account];
        Safely safelyInstance = new Safely();

        // Act
        List<Database.DeleteResult> results = safelyInstance.doDelete(accounts);

        // Assert
        System.assertEquals(2, results.size(), 'Should have 2 delete results.');
        System.assert(results[0].isSuccess(), 'First delete should be successful.');
    }

    // Test deleting empty list
    @isTest
    static void testDoDeleteEmptyList() {
        // Arrange
        List<Account> accounts = new List<Account>();
        Safely safelyInstance = new Safely();

        // Act
        List<Database.DeleteResult> results = safelyInstance.doDelete(accounts);

        // Assert
        System.assertEquals(0, results.size(), 'Should have 0 delete results.');
    }

    // Test for the allOrNothing behavior
    @isTest
    static void testDoDeleteAllOrNothing() {
        // Arrange
        TriggerHandler.bypass('AccountTriggerHandler');
        TriggerHandler.bypass('MDTAccountTriggerHandler');
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        // Add a dummy account with a fake Id to ensure deletion fails for this record
        accounts.add(new Account(Id=Schema.SObjectType.Account.getKeyPrefix() + '123FAKEID456'));
        Safely safelyInstance = new Safely().allOrNothing();

        // Act
        Boolean didExceptionOccur = false;
        List<Database.DeleteResult> results = new List<Database.DeleteResult>();
        Test.startTest();
        try {
            results = safelyInstance.doDelete(accounts);
        } catch (DmlException e) {
            didExceptionOccur = true;
        }
        Test.stopTest();

        // Assert
        System.assert(didExceptionOccur, 'An exception should have been thrown due to allOrNothing behavior.');
        System.assertEquals(0, results.size(), 'There should be no results as the operation failed.');
    }
}
